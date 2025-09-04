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
        $this->pdo = new PDO(
            "mysql:host={$config['db_host']};dbname={$config['db_name']};charset=utf8mb4",
            $config['db_user'],
            $config['db_pass']
        );
        $this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        date_default_timezone_set('Europe/Budapest');
    }

    public function login($username, $password) {
        $ldap_user = $username . '@birosagiad.hu';
        $conn = ldap_connect($this->config['ldap_server']);

        ldap_set_option($conn, LDAP_OPT_REFERRALS, 0);
        ldap_set_option($conn, LDAP_OPT_PROTOCOL_VERSION, 3);

        if ($conn && @ldap_bind($conn, $ldap_user, $password)) {
            // Bővített lekérdezés több attribútummal
            $search = ldap_search(
                $conn,
                $this->config['ldap_base_dn'],
                "(sAMAccountName=$username)",
                ['memberof','displayName', 'givenName', 'sn']
            );

            if (!$search) {
                return "LDAP keresési hiba: " . ldap_error($conn);
            }

            $entries = ldap_get_entries($conn, $search);
            if ($entries['count'] > 0 && isset($entries[0]['memberof'])) {
    $userGroups = [];

        foreach ($entries[0]['memberof'] as $groupDn) {
            if (!is_string($groupDn)) continue;
            if (preg_match('/CN=([^,]+)/i', $groupDn, $matches)) {
                $userGroups[] = $matches[1];
            }
        }

        // Ellenőrzés: van-e legalább egy jogosult csoport
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

            return "Felhasználó LDAP hiba.";
        }

        return "Hibás felhasználónév vagy jelszó, ill. nem elérhető LDAP!";
    }

    public static function isAuthenticated() {
        return isset($_SESSION['user']);
    }

    public static function logout() {
    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }

    // Ürítsük ki a session adattárolót
    $_SESSION = [];

    // Töröljük a session cookie-t is, ha van
    if (ini_get("session.use_cookies")) {
        $params = session_get_cookie_params();
        setcookie(session_name(), '', time() - 42000,
            $params["path"], $params["domain"],
            $params["secure"], $params["httponly"]
        );
    }

    // Végül megszüntetjük a session-t
    session_destroy();
    }
}
