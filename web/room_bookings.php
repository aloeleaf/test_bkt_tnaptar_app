<?php
// room_bookings.php
// This page displays the HTML for a given room from foglalas_matrix_view for today

require_once __DIR__ . '/app/Database.php';
$config = require __DIR__ . '/config/config.php';
$db = new Database($config);
$pdo = $db->getPdo();

$room = isset($_GET['room']) ? trim($_GET['room']) : '';
if (empty($room)) {
    echo '<h2>No room specified.</h2>';
    exit;
}

// Get valid column names from the view to prevent SQL injection
try {
    $columnsStmt = $pdo->query("SELECT column_name FROM information_schema.columns WHERE table_name = 'foglalas_matrix_view' AND table_schema = 'public'");
    $validColumns = $columnsStmt->fetchAll(PDO::FETCH_COLUMN);
    
    // Check if the requested room is a valid column
    if (!in_array($room, $validColumns)) {
        echo '<h2>Invalid room specified.</h2>';
        exit;
    }
    
    // Now safe to use the room name in the query
    $stmt = $pdo->prepare('SELECT "' . $room . '" FROM foglalas_matrix_view WHERE date = CURRENT_DATE');
    $stmt->execute();
    $result = $stmt->fetch(PDO::FETCH_NUM);
    
    if (!$result || empty($result[0])) {
        echo '<h2>No booking data available for room: ' . htmlspecialchars($room, ENT_QUOTES, 'UTF-8') . '</h2>';
        exit;
    }
    
    // Set headers before any output - refresh every 10 minutes
    if (!headers_sent()) {
        header('Refresh: 600');
        header('Content-Type: text/html; charset=utf-8');
    }
    
    // Output the HTML content (assuming it's already safe HTML from the view)
    echo $result[0];
    
} catch (PDOException $e) {
    error_log('Database error in room_bookings.php: ' . $e->getMessage());
    echo '<h2>Error retrieving booking data.</h2>';
    exit;
}
