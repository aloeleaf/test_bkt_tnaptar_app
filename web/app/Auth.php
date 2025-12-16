<?php
/**
 * Authentication Class
 * 
 * Handles user authentication via Active Directory LDAP,
 * role-based access control (RBAC), and session management.
 * Stores user login information in PostgreSQL database.
 * 
 * @author Birosagi IT Team
 * @version 1.0
 */

// Enable error display for debugging
ini_set('display_errors', 1);
error_reporting(E_ALL);

// Start session if not already started
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

class Auth
{
    /** @var array Database and LDAP configuration */
    private $config;
    
    /** @var PDO PostgreSQL database connection */
    private $pdo;

    /**
     * Constructor - Initialize database connection
     * 
     * @param array $config Configuration array containing:
     *                      - host: Database host
     *                      - port: Database port
     *                      - dbname: Database name
     *                      - user: Database username
     *                      - password: Database password
     *                      - ldap_server: LDAP server URL
     *                      - ldap_base_dn: LDAP base DN for searches
     *                      - ldap_required_groups: Array of authorized AD groups
     */
    public function __construct($config)
    {
        $this->config = $config;
        
        // Use PostgreSQL DSN to establish database connection
        $this->pdo = new PDO(
            "pgsql:host={$config['host']};port={$config['port']};dbname={$config['dbname']}",
            $config['user'],
            $config['password']
        );
        
        // Set PDO to throw exceptions on errors
        $this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        
        // Set timezone for accurate timestamp logging
        date_default_timezone_set('Europe/Budapest');
    }

    /**
     * Authenticate user against Active Directory LDAP
     * 
     * This method:
     * 1. Validates credentials against AD LDAP
     * 2. Retrieves user's group memberships
     * 3. Checks if user belongs to required groups
     * 4. Determines user role based on group membership
     * 5. Creates session and logs login to database
     * 
     * @param string $username Username (without domain)
     * @param string $password User's password
     * @return bool|string True on success, error message string on failure
     */
    public function login($username, $password)
    {
        // Prevent empty credentials from attempting an anonymous LDAP bind
        // Anonymous binds could succeed without authentication
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

            // Get search results and close LDAP connection
            $entries = ldap_get_entries($conn, $search);
            ldap_close($conn);

            // Process user's group memberships if found
            if ($entries['count'] > 0 && isset($entries[0]['memberof'])) {
                $userGroups = [];
                
                // Extract group names from Distinguished Names (DNs)
                // Example DN: CN=BKT_TargyaloFoglaloAdmin,OU=Groups,DC=birosagiad,DC=hu
                foreach ($entries[0]['memberof'] as $groupDn) {
                    if (!is_string($groupDn))
                        continue;
                    // Extract CN (Common Name) from the DN
                    if (preg_match('/CN=([^,]+)/i', $groupDn, $matches)) {
                        $userGroups[] = $matches[1];
                    }
                }

                // Check if user belongs to at least one required group
                $hasPermission = false;
                foreach ($this->config['ldap_required_groups'] as $requiredGroup) {
                    if (in_array($requiredGroup, $userGroups)) {
                        $hasPermission = true;
                        break;
                    }
                }

                if ($hasPermission) {
                    // Get user's display name from AD, fallback to constructed name or username
                    $displayName = $entries[0]['displayname'][0] ??
                        trim(($entries[0]['givenname'][0] ?? '') . ' ' . ($entries[0]['sn'][0] ?? ''));

                    // Store user information in session
                    $_SESSION['user'] = $username;
                    $_SESSION['display_name'] = $displayName ?: $username;
                    $_SESSION['login_time'] = date('Y-m-d H:i:s');
                    $_SESSION['groups'] = $userGroups;
                    $_SESSION['user_role'] = self::determineRole($userGroups);

                    // Log user login to database
                    // Use UPSERT (INSERT ... ON CONFLICT) to update last_login if user exists
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

    /**
     * Check if user is currently authenticated
     * 
     * @return bool True if user session exists, false otherwise
     */
    public static function isAuthenticated()
    {
        return isset($_SESSION['user']);
    }

    /**
     * Logout user and destroy session
     * 
     * Clears all session data and removes session cookie
     * for complete logout
     */
    public static function logout()
    {
        // Start session if not already started
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }

        // Clear all session variables
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
     * 
     * Checks user's AD groups and assigns the highest priority role.
     * Priority order: Admin > Felugyelo > Szerkeszto > Betekinto
     * 
     * Role hierarchy:
     * - admin: Full system access including settings
     * - felugyelo: Can view, create, edit, and delete
     * - szerkeszto: Can view and create entries
     * - betekinto: Read-only access (default)
     * 
     * @param array $userGroups Array of AD group names
     * @return string User role (admin|felugyelo|szerkeszto|betekinto)
     */
    private static function determineRole($userGroups)
    {
        // Check groups in priority order (highest to lowest)
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
        // Default to most restrictive role if no matching group found
        return 'betekinto';
    }

    /**
     * Get the current user's role
     * 
     * @return string Current user's role or 'betekinto' (default)
     */
    public static function getUserRole()
    {
        return $_SESSION['user_role'] ?? 'betekinto';
    }

    /**
     * Check if user can view the list
     * 
     * All authenticated roles can view the list.
     * 
     * @return bool True if user is authenticated
     */
    public static function canViewList()
    {
        return self::isAuthenticated();
    }

    /**
     * Check if user can create new entries
     * 
     * Allowed roles: Szerkeszto, Felugyelo, and Admin
     * 
     * @return bool True if user has create permission
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
     * 
     * Allowed roles: Felugyelo and Admin
     * 
     * @return bool True if user has edit permission
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
     * 
     * Allowed roles: Felugyelo and Admin only
     * 
     * @return bool True if user has delete permission
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
     * 
     * Allowed roles: Admin only
     * 
     * @return bool True if user has settings access
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
     * 
     * Note: This method currently returns false because refreshing permissions
     * requires re-authenticating with LDAP, which needs the user's password.
     * Since we don't store passwords (security best practice), users must
     * log out and log back in to refresh their permissions.
     * 
     * Alternative implementations could use:
     * - Service account for LDAP queries (less secure)
     * - Cached credentials (security risk)
     * - Regular re-authentication prompts
     * 
     * @return bool Always returns false (not implemented)
     */
    public static function refreshPermissions()
    {
        // Since we cannot query LDAP without the user's password (which we don't store),
        // we'll force a logout and redirect to login page.
        // This is more secure than storing credentials or using a service account.
        return false;
    }
}
?>