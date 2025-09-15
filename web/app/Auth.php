<?php

ini_set('display_errors', 1);
error_reporting(E_ALL);

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

class Auth {
    private $config;
    private $pdo;

    public function __construct($config) {
        $this->config = $config;
        // Use standardized config keys to match Database.php
        $this->pdo = new PDO(
            "mysql:host={$config['host']};dbname={$config['dbname']};charset=utf8mb4",
            $config['user'],
            $config['password']
        );
        $this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        date_default_timezone_set('Europe/Budapest');
    }

    public function login($username, $password) {
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
                    if (!is_string($groupDn)) continue;
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

                    $stmt = $this->pdo->prepare(
                        "INSERT INTO name (name, last_login) VALUES (:name, :last_login) ON DUPLICATE KEY UPDATE last_login = :last_login"
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

    public static function isAuthenticated() {
        return isset($_SESSION['user']);
    }

    public static function logout() {
        if (session_status() === PHP_SESSION_NONE) {
            session_start();
        }

        $_SESSION = [];

        if (ini_get("session.use_cookies")) {
            $params = session_get_cookie_params();
            setcookie(session_name(), '', time() - 42000,
                $params["path"], $params["domain"],
                $params["secure"], $params["httponly"]
            );
        }

        session_destroy();
    }
}
?>