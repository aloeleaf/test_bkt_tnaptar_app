<?php
// filepath: \srv\containers\test_bkt_tnaptar_app\web\includes\header.php

require_once __DIR__ . '/../app/Auth.php';
$config = require_once __DIR__ . '/../config/config.php';
$paths = require_once __DIR__ . '/../config/paths.php';
$base_url = $paths['base_url'];

// Default title if not set
if (!isset($page_title)) {
    $page_title = 'Tárgyalási Naptár';
}

$auth = new Auth($config);
$error = '';

// Handle login only if this is a login page
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['username'], $_POST['password'])) {
    $username = $_POST['username'] ?? '';
    $password = $_POST['password'] ?? '';
    $result = $auth->login($username, $password);

    if ($result === true) {
        header("Location: dashboard.php");
        exit;
    } else {
        $error = $result;
    }
}
?>

<!DOCTYPE html>
<html lang="hu">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= htmlspecialchars($page_title) ?></title>
    
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
    
    <!-- Meta information -->
    <meta name="author" content="Martínez Luis Dávid & Papp Ágoston">
    <meta name="description" content="Tárgyalási Naptár Alkalmazás - Budapest Környéki Törvényszék">
</head>
<body>