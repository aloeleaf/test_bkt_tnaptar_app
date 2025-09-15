<?php
<?php
// app/getitems.php

// Betöltjük a configot és a Database osztályt
$config = require __DIR__ . '/../config/config.php';
require_once __DIR__ . '/Database.php';

$db = new Database($config);
$pdo = $db->getPdo();

header('Content-Type: application/json; charset=utf-8');

$response = [
    'success' => false,
    'message' => '',
    'data' => []
];

$itemType = $_GET['type'] ?? '';

if (empty($itemType)) {
    $response['message'] = 'Nincs megadva a kért elem típusa.';
    echo json_encode($response);
    exit;
}

// Meghatározzuk a lekérdezendő oszlopot a 'type' paraméter alapján
$column = '';
switch ($itemType) {
    case 'birosag':
        $column = 'birosag';
        break;
    case 'tanacs':
        $column = 'tanacs';
        break;
    case 'rooms':
        $column = 'rooms';
        break;
    default:
        $response['message'] = 'Érvénytelen elem típus.';
        echo json_encode($response);
        exit;
}

try {
    // DISTINCT használata a duplikátumok elkerülésére és ORDER BY a rendezéshez
    $sql = "SELECT DISTINCT " . $column . " FROM rooms WHERE " . $column . " IS NOT NULL AND " . $column . " != '' ORDER BY " . $column . " ASC";
    $stmt = $pdo->query($sql);
    
    $data = $stmt->fetchAll(PDO::FETCH_COLUMN, 0);

    $response['success'] = true;
    $response['data'] = $data;

} catch (PDOException $e) {
    $response['message'] = 'Adatbázis hiba a lista lekérdezésekor: ' . $e->getMessage();
}

echo json_encode($response);
?>