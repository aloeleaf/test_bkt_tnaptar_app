<?php
session_start();
require_once __DIR__ . '/app/Auth.php';

if (!Auth::isAuthenticated()) {
    header("Location: index.php");
    exit;
}
$nev = $_SESSION['display_name'] ?? $_SESSION['user'];
$loginIdo = $_SESSION['login_time'] ?? 'ismeretlen időpont';
?>

<!DOCTYPE html>
<html lang="hu">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Kezdőlap</title>
    <link href="assets/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <link href="assets/css/main.css" rel="stylesheet" />
    <link href="assets/fontawesome/css/all.css" rel="stylesheet" />
    <meta name="author" content="Martínez Luis Dávid & Papp Ágoston" />
</head>
<body class="no-flex">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
        <div class="container-fluid">
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
            <?php
            if (in_array('BKT_WebLoginGroup', $_SESSION['groups'])) {
                echo '<li class="nav-item">
                        <a class="nav-link load-page" href="#" data-page="list.php"><i class="fa-solid fa-people-roof"></i> Tárgyalási jegyzékek</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link load-page" href="#" data-page="rogzites.php"><i class="fa-solid fa-list-check"></i> Rögzítés</a>
                    </li>';
            }
            if (in_array('BKT_WebLoginGroupAdmin', $_SESSION['groups'])) {
                echo '<li class="nav-item">
                        <a class="nav-link load-page" href="#" data-page="list.php"><i class="fa-solid fa-people-roof"></i> Tárgyalási jegyzékek</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link load-page" href="#" data-page="rogzites.php"><i class="fa-solid fa-list-check"></i> Rögzítés</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link load-page" href="#" data-page="settings.php"><i class="fa-solid fa-screwdriver-wrench"></i> Beállítások</a>
                    </li>';
            }
            ?>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <span class="nav-link text-white"><i class="fa-solid fa-user"></i> Üdvözlünk <?= htmlspecialchars($nev) ?>!</span>
                    </li>
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
    
    <footer>
        <div class="container">
            <p>&copy; <?php echo date("Y"); ?> | Budapest Környéki Törvényszék | Minden jog fenntartva. <br />
            Készítette: Martínez Luis Dávid & Papp Ágoston</p>
        </div>
    </footer>

    <script src="assets/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="assets/js/main.js"></script>
    <script src="assets/js/settings.js"></script>
    <!-- <script src="assets/js/list_search.js"></script> -->
    
</body>
</html>
