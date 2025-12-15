<?php

ini_set('display_errors', 1);
error_reporting(E_ALL);

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

class Auth
{
    private $config;
    private $pdo;

    public function __construct($config)
    {
        $this->config = $config;
        // Use PostgreSQL DSN
        $this->pdo = new PDO(
            "pgsql:host={$config['host']};port={$config['port']};dbname={$config['dbname']}",
            $config['user'],
            $config['password']
        );
        $this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        date_default_timezone_set('Europe/Budapest');
    }

    public function login($username, $password)
    {
        // Prevent empty credentials from attempting an anonymous bind
        if (empty($username) || empty($password)) {
            return "Hibás felhasználónév vagy jelszó.";
        }

        $ldap_user = $username . '@birosagiad.hu';
        $conn = ldap_connect($this->config['ldap_server']);

        if (!$conn) {
            return "Nem sikerült csatlakozni az LDAP szerverhez.";
        }

        ldap_set_option($conn, LDAP_OPT_REFERRALS, 0);
        ldap_set_option($conn, LDAP_OPT_PROTOCOL_VERSION, 3);

        if (@ldap_bind($conn, $ldap_user, $password)) {
            $search = ldap_search(
                $conn,
                $this->config['ldap_base_dn'],
                "(sAMAccountName=$username)",
                ['memberof', 'displayName', 'givenName', 'sn']
            );

            if (!$search) {
                ldap_close($conn);
                return "LDAP keresési hiba: " . ldap_error($conn);
            }

            $entries = ldap_get_entries($conn, $search);
            ldap_close($conn);

            if ($entries['count'] > 0 && isset($entries[0]['memberof'])) {
                $userGroups = [];
                foreach ($entries[0]['memberof'] as $groupDn) {
                    if (!is_string($groupDn))
                        continue;
                    if (preg_match('/CN=([^,]+)/i', $groupDn, $matches)) {
                        $userGroups[] = $matches[1];
                    }
                }

                $hasPermission = false;
                foreach ($this->config['ldap_required_groups'] as $requiredGroup) {
                    if (in_array($requiredGroup, $userGroups)) {
                        $hasPermission = true;
                        break;
                    }
                }

                if ($hasPermission) {
                    $displayName = $entries[0]['displayname'][0] ??
                        trim(($entries[0]['givenname'][0] ?? '') . ' ' . ($entries[0]['sn'][0] ?? ''));

                    $_SESSION['user'] = $username;
                    $_SESSION['display_name'] = $displayName ?: $username;
                    $_SESSION['login_time'] = date('Y-m-d H:i:s');
                    $_SESSION['groups'] = $userGroups;
                    $_SESSION['user_role'] = self::determineRole($userGroups);

                    $stmt = $this->pdo->prepare(
                        "INSERT INTO name (name, last_login) VALUES (:name, :last_login)
                        ON CONFLICT (name) DO UPDATE SET last_login = EXCLUDED.last_login"
                    );
                    $stmt->execute([
                        ':name' => $displayName,
                        ':last_login' => $_SESSION['login_time']
                    ]);

                    return true;
                }
                return "Nincs jogosultságod a weboldalhoz!";
            }
            return "Felhasználói adatok nem találhatók vagy a felhasználó nem tagja egyetlen csoportnak sem.";
        }

        if ($conn) {
            ldap_close($conn);
        }
        return "Hibás felhasználónév vagy jelszó, vagy nem elérhető az LDAP szerver.";
    }

    public static function isAuthenticated()
    {
        return isset($_SESSION['user']);
    }

    public static function logout()
    {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }

        $_SESSION = [];

        if (ini_get("session.use_cookies")) {
            $params = session_get_cookie_params();
            setcookie(
                session_name(),
                '',
                time() - 42000,
                $params["path"],
                $params["domain"],
                $params["secure"],
                $params["httponly"]
            );
        }

        session_destroy();
    }

    /**
     * Determine user role based on group membership
     * Priority order: Admin > Felugyelo > Szerkeszto > Betekinto
     */
    private static function determineRole($userGroups)
    {
        if (in_array('BKT_TargyaloFoglaloAdmin', $userGroups)) {
            return 'admin';
        }
        if (in_array('BKT_TargyaloFoglaloFelugyelo', $userGroups)) {
            return 'felugyelo';
        }
        if (in_array('BKT_TargyaloFoglaloSzerkeszto', $userGroups)) {
            return 'szerkeszto';
        }
        if (in_array('BKT_TargyaloFoglaloBetekinto', $userGroups)) {
            return 'betekinto';
        }
        return 'betekinto'; // default to most restrictive role
    }

    /**
     * Get the current user's role
     */
    public static function getUserRole()
    {
        return $_SESSION['user_role'] ?? 'betekinto';
    }

    /**
     * Check if user can view the list
     * All roles can view the list
     */
    public static function canViewList()
    {
        return self::isAuthenticated();
    }

    /**
     * Check if user can create new entries
     * Szerkeszto, Felugyelo, and Admin can create
     */
    public static function canCreate()
    {
        if (!self::isAuthenticated()) {
            return false;
        }
        
        $role = self::getUserRole();
        return in_array($role, ['szerkeszto', 'felugyelo', 'admin']);
    }

    /**
     * Check if user can edit entries
     * Szerkeszto, Felugyelo, and Admin can edit
     */
    public static function canEdit()
    {
        if (!self::isAuthenticated()) {
            return false;
        }
        
        $role = self::getUserRole();
        return in_array($role, ['felugyelo', 'admin']);
    }

    /**
     * Check if the current user has delete permissions
     * Only Felugyelo and Admin can delete
     */
    public static function canDelete()
    {
        if (!self::isAuthenticated()) {
            return false;
        }

        $role = self::getUserRole();
        return in_array($role, ['felugyelo', 'admin']);
    }

    /**
     * Check if user can access settings
     * Only Admin can access settings
     */
    public static function canViewSettings()
    {
        if (!self::isAuthenticated()) {
            return false;
        }
        
        $role = self::getUserRole();
        return $role === 'admin';
    }

    /**
     * Refresh user's LDAP groups and role from Active Directory
     * This allows updating permissions without logout/login
     * Note: This requires the user to log out and back in since we don't store passwords
     */
    public static function refreshPermissions()
    {
        // Since we cannot query LDAP without the user's password (which we don't store),
        // we'll force a logout and redirect to login page
        // This is more secure than storing credentials or using a service account
        return false;
    }
}
?>