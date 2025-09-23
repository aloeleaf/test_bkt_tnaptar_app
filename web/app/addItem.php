<?php
// filepath: \srv\containers\test_bkt_tnaptar_app\web\app\addItem.php
ob_start();
ini_set('display_errors', '0');
ini_set('log_errors', '1');
header('Content-Type: application/json; charset=utf-8');

$response = ['success' => false, 'message' => ''];

try {
    $config = require __DIR__ . '/../config/config.php';
    require_once __DIR__ . '/Database.php';

    $db = new Database($config);
    $pdo = $db->getPdo();

    // Get JSON input
    $input = json_decode(file_get_contents('php://input'), true);

    $type = $input['type'] ?? $_POST['type'] ?? null;
    $name = $input['name'] ?? $_POST['name'] ?? null;

    if (!$type) {
        throw new Exception('Nincs megadva a kért elem típusa.');
    }

    if (!$name || trim($name) === '') {
        throw new Exception('Nincs megadva az elem neve.');
    }

    $name = trim($name);

    // Validate allowed types
    $allowedTypes = ['birosag', 'tanacs', 'room', 'resztvevok'];
    if (!in_array($type, $allowedTypes, true)) {
        throw new Exception('Érvénytelen elem típus: ' . $type);
    }

    // Check if already exists
    $stmt = $pdo->prepare("SELECT COUNT(*) FROM settings WHERE category = :category AND value = :value");
    $stmt->execute([':category' => $type, ':value' => $name]);

    if ($stmt->fetchColumn() > 0) {
        throw new Exception('Ez az elem már létezik.');
    }

    // Get next sort order
    $stmt = $pdo->prepare("SELECT COALESCE(MAX(sort_order), 0) + 1 FROM settings WHERE category = :category");
    $stmt->execute([':category' => $type]);
    $sortOrder = $stmt->fetchColumn();

    // Insert new item
    $stmt = $pdo->prepare("
    INSERT INTO settings (category, value, active, sort_order) 
    VALUES (:category, :value, TRUE, :sort_order)"
    );

    $stmt->execute([
        ':category' => $type,
        ':value' => $name,
        ':sort_order' => $sortOrder
    ]);

    $response['success'] = true;
    $response['message'] = 'Sikeresen hozzáadva!';

} catch (PDOException $e) {
    http_response_code(500);
    $response['message'] = 'Adatbázis hiba: ' . $e->getMessage();
} catch (Exception $e) {
    http_response_code(400);
    $response['message'] = $e->getMessage();
}

while (ob_get_level() > 0) {
    ob_end_clean();
}
echo json_encode($response, JSON_UNESCAPED_UNICODE | JSON_INVALID_UTF8_SUBSTITUTE);