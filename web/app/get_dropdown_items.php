<?php
// filepath: \srv\containers\test_bkt_tnaptar_app\web\app\get_dropdown_items.php
ob_start();
ini_set('display_errors', '0');
ini_set('log_errors', '1');
header('Content-Type: application/json; charset=utf-8');

$response = ['success' => false, 'message' => '', 'data' => []];

try {
    $config = require __DIR__ . '/../config/config.php';
    require_once __DIR__ . '/Database.php';

    $db = new Database($config);
    $pdo = $db->getPdo();

    $itemType = $_GET['type'] ?? '';
    if (empty($itemType)) {
        throw new Exception('Nincs megadva a kért elem típusa.');
    }

    // Validate allowed types
    $allowedTypes = ['birosag', 'tanacs', 'room', 'resztvevok'];
    if (!in_array($itemType, $allowedTypes, true)) {
        throw new Exception('Érvénytelen elem típus: ' . $itemType);
    }

    // Query the settings table for dropdown data
    $stmt = $pdo->prepare("
        SELECT id, value 
        FROM settings 
        WHERE category = :category AND active = 1 
        ORDER BY sort_order ASC, value ASC
    ");
    $stmt->execute([':category' => $itemType]);
    $items = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $response['success'] = true;
    $response['data'] = $items;

} catch (PDOException $e) {
    http_response_code(500);
    $response['message'] = 'Adatbázis hiba: ' . $e->getMessage();
} catch (Exception $e) {
    http_response_code(400);
    $response['message'] = $e->getMessage();
}

// Clear any unwanted output before JSON
while (ob_get_level() > 0) { ob_end_clean(); }
echo json_encode($response, JSON_UNESCAPED_UNICODE | JSON_INVALID_UTF8_SUBSTITUTE);