
<?php
// room_bookings.php
// This page displays the HTML for a given room from foglalas_matrix_view for today

require_once __DIR__ . '/app/Database.php';
$config = require __DIR__ . '/config/config.php';
$db = new Database($config);
$pdo = $db->getPdo();

$room = isset($_GET['room']) ? $_GET['room'] : '';
if (empty($room)) {
    echo '<h2>No room specified.</h2>';
    exit;
}

$stmt = $pdo->prepare('SELECT "' . $room . '" FROM foglalas_matrix_view WHERE date = CURRENT_DATE');
$stmt->execute();
$result = $stmt->fetch(PDO::FETCH_NUM);

// Set refresh header for 10 minutes
//header('Refresh: 600');
//header('Content-Type: text/html; charset=utf-8');

echo $result[0];
