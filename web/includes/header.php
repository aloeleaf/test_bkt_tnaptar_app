<?php

require_once __DIR__ . '/../app/Auth.php';
$config = require_once __DIR__ . '/../config/config.php';

$paths = require_once __DIR__ . '/../config/paths.php';
$base_url = $paths['base_url'];


// Default title if not set
if (!isset($page_title)) {
    $page_title = 'My App';
}

$auth = new Auth($config);
$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
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
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title><?= htmlspecialchars($page_title) ?></title>
  <link rel="stylesheet" href="/assets/bootstrap/css/bootstrap.min.css">
  <link rel="stylesheet" href="/assets/css/main.css">
  <meta name="author" content="Martínez Luis Dávid & Papp Ágoston" />
</head>
<body>