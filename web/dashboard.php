<?php
session_start();
require_once __DIR__ . '/app/Auth.php';
$paths = require_once __DIR__ . '/config/paths.php';
$base_url = $paths['base_url'];

if (!Auth::isAuthenticated()) {
    header("Location: index.php");
    exit;
}

// Handle permission refresh request - force logout and re-login
if (isset($_GET['refresh_permissions'])) {
    session_unset();
    session_destroy();
    header("Location: index.php?message=please_login_again");
    exit;
}

// Check if session is older than 30 minutes and force re-authentication
$sessionAge = time() - strtotime($_SESSION['login_time'] ?? 'now');
if ($sessionAge > 1800) { // 30 minutes
    session_unset();
    session_destroy();
    header("Location: index.php?message=session_expired");
    exit;
}

$nev = $_SESSION['display_name'] ?? $_SESSION['user'];
$loginIdo = $_SESSION['login_time'] ?? 'ismeretlen időpont';
$userRole = Auth::getUserRole();
$userGroups = $_SESSION['groups'] ?? [];
?>

<!DOCTYPE html>
<html lang="hu">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Kezdőlap</title>
    
    <!-- Security headers -->
    <meta http-equiv="X-Content-Type-Options" content="nosniff">
    <meta http-equiv="X-Frame-Options" content="DENY">
    <meta http-equiv="X-XSS-Protection" content="1; mode=block">
    
    <!-- Stylesheets using base_url -->
    <link rel="stylesheet" href="<?= $base_url ?>/assets/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="<?= $base_url ?>/assets/css/main.css">
    <link rel="stylesheet" href="<?= $base_url ?>/assets/fontawesome/css/all.css">
    
    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="<?= $base_url ?>/favicon.ico">
</head>
<body class="no-flex">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
        <div class="container-fluid">
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
            <?php
            // All authenticated users can view the list
            if (Auth::canViewList()) {
                echo '<li class="nav-item">
                        <a class="nav-link load-page" href="#" data-page="list.php"><i class="fa-solid fa-people-roof"></i> Tárgyalási jegyzékek</a>
                    </li>';
            }
            
            // Szerkeszto, Felugyelo, and Admin can create/edit (Rögzítés)
            if (Auth::canCreate()) {
                echo '<li class="nav-item">
                        <a class="nav-link load-page" href="#" data-page="rogzites.php"><i class="fa-solid fa-list-check"></i> Rögzítés</a>
                    </li>';
            }
            
            // Only Admin can see settings
            if (Auth::canViewSettings()) {
                echo '<li class="nav-item">
                        <a class="nav-link load-page" href="#" data-page="settings.php"><i class="fa-solid fa-screwdriver-wrench"></i> Beállítások</a>
                    </li>';
            }
            ?>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <span class="nav-link text-white"><i class="fa-solid fa-user"></i> Üdvözlünk <?= htmlspecialchars($nev) ?>!</span>
                    </li>
                    <?php /* Debug info - uncomment to see user role and groups */ ?>
                    <!--li class="nav-item">
                        <span class="nav-link text-white">Role: <?= htmlspecialchars($userRole) ?> | Groups: <?= htmlspecialchars(implode(', ', $userGroups)) ?></span>
                    </li-->
                    <li class="nav-item">
                        <span class="nav-link text-white">Belépés ideje: <?= htmlspecialchars($loginIdo) ?></span>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link btn btn-outline-light btn-sm ms-2 logout-button" href="logout.php"><i class="fa-solid fa-arrow-right-from-bracket"></i> Kijelentkezés</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div id="content-area" class="container"></div>
    
    <!-- footer>
        <div class="container">
            <p>&copy; <?php echo date("Y"); ?> | Budapest Környéki Törvényszék | Minden jog fenntartva. <br />
            Készítette: Martínez Luis Dávid & Papp Ágoston</p>
        </div>
    </footer-->

    <script src="<?= $base_url ?>/assets/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="<?= $base_url ?>/assets/js/main.js"></script>
    <script src="<?= $base_url ?>/assets/js/settings.js"></script>
    <!-- <script src="<?= $base_url ?>/assets/js/list_search.js"></script> -->
    
</body>
</html>
