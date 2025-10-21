<?php
// room_matrix.php
// Outputs the HTML for a given room and date from foglalas_matrix_view

require_once __DIR__ . '/app/Database.php';
$config = require __DIR__ . '/config/config.php';
$db = new Database($config);
$pdo = $db->getPdo();

// Get room and date from GET params
$room = isset($_GET['room']) ? $_GET['room'] : '';
$date = isset($_GET['date']) ? $_GET['date'] : date('Y-m-d');

if (empty($room)) {
    echo '<h2>No room specified.</h2>';
    exit;
}

// Query the view for the given date
$stmt = $pdo->prepare('SELECT * FROM foglalas_matrix_view WHERE date = ?');
$stmt->execute([$date]);
$row = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$row || !isset($row[$room])) {
    echo '<h2>No booking info found for this room and date.</h2>';
    exit;
}

// Output the HTML stored in the view for the room
header('Content-Type: text/html; charset=utf-8');
echo $row[$room];
