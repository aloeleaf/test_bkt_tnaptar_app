<?php
// filepath: \srv\containers\test_bkt_tnaptar_app\web\app\updateItem.php
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
    $id = $input['id'] ?? $_POST['id'] ?? null;
    $value = $input['value'] ?? $_POST['value'] ?? null;

    if (!$type) {
        throw new Exception('Nincs megadva a kért elem típusa.');
    }
    
    if (!$id || !is_numeric($id)) {
        throw new Exception('Nincs megadva érvényes elem azonosító.');
    }

    if (!$value || trim($value) === '') {
        throw new Exception('Nincs megadva az új érték.');
    }

    $value = trim($value);

    // Validate allowed types
    $allowedTypes = ['birosag', 'tanacs', 'room', 'resztvevok'];
    if (!in_array($type, $allowedTypes, true)) {
        throw new Exception('Érvénytelen elem típus: ' . $type);
    }

    // Check if new value already exists (except for current item)
    $stmt = $pdo->prepare("SELECT COUNT(*) FROM settings WHERE category = :category AND value = :value AND id != :id");
    $stmt->execute([':category' => $type, ':value' => $value, ':id' => (int)$id]);
    
    if ($stmt->fetchColumn() > 0) {
        throw new Exception('Ez az érték már létezik másik elemnél.');
    }

    // Update the item
    $stmt = $pdo->prepare("UPDATE settings SET value = :value WHERE category = :category AND id = :id");
    $stmt->execute([':value' => $value, ':category' => $type, ':id' => (int)$id]);

    if ($stmt->rowCount() > 0) {
        $response['success'] = true;
        $response['message'] = 'Sikeresen módosítva!';
    } else {
        throw new Exception('Az elem nem található vagy nincs változás.');
    }

} catch (PDOException $e) {
    http_response_code(500);
    $response['message'] = 'Adatbázis hiba: ' . $e->getMessage();
} catch (Exception $e) {
    http_response_code(400);
    $response['message'] = $e->getMessage();
}

while (ob_get_level() > 0) { ob_end_clean(); }
echo json_encode($response, JSON_UNESCAPED_UNICODE | JSON_INVALID_UTF8_SUBSTITUTE);