<?php
header('Content-Type: application/json; charset=utf-8');

$response = ['success' => false, 'message' => '', 'data' => []];

try {
    $config = require __DIR__ . '/../config/config.php';
    require_once __DIR__ . '/Database.php';

    $db = new Database($config);
    $pdo = $db->getPdo();

    // Use a single canonical param name
    $type = $_GET['type'] ?? null;
    if (!$type) {
        throw new Exception('Hiányzó paraméter: type');
    }

    $stmt = $pdo->prepare("
        SELECT id, value
        FROM settings
        WHERE category = :category AND active = 1
        ORDER BY sort_order ASC, value ASC
    ");
    $stmt->execute([':category' => $type]);
    $items = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $response['success'] = true;
    $response['data'] = $items;
} catch (PDOException $e) {
    http_response_code(500);
    $response['message'] = 'Adatbázis hiba: ' . $e->getMessage();
} catch (Exception $e) {
    http_response_code(400);
    $response['message'] = 'Hiba: ' . $e->getMessage();
}

echo json_encode($response, JSON_UNESCAPED_UNICODE | JSON_INVALID_UTF8_SUBSTITUTE);