<?php
ob_start();
ini_set('display_errors', '0');
ini_set('log_errors', '1');
header('Content-Type: application/json; charset=utf-8');

$config = require __DIR__ . '/../config/config.php';
require_once __DIR__ . '/Database.php';

function respond(array $payload, int $code = 200): void {
    http_response_code($code);
    while (ob_get_level() > 0) { ob_end_clean(); }
    echo json_encode($payload, JSON_UNESCAPED_UNICODE | JSON_INVALID_UTF8_SUBSTITUTE);
    exit;
}

try {
    $db = new Database($config);
    $pdo = $db->getPdo();
} catch (Throwable $e) {
    respond(['success' => false, 'message' => 'Adatbázis kapcsolat hiba: ' . $e->getMessage()], 500);
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    respond(['success' => false, 'message' => 'Csak POST kérések támogatottak.'], 405);
}

// Read JSON input
$input = file_get_contents('php://input');
$data = json_decode($input, true);

if (json_last_error() !== JSON_ERROR_NONE) {
    respond(['success' => false, 'message' => 'Érvénytelen JSON adatok.'], 400);
}

$type = trim($data['type'] ?? '');
$id = isset($data['id']) && is_numeric($data['id']) ? (int)$data['id'] : 0;

if ($type === '' || $id <= 0) {
    respond(['success' => false, 'message' => 'Hiányzó vagy érvénytelen paraméterek (type, id).'], 422);
}

// Validate category
$allowedTypes = ['birosag', 'tanacs', 'room', 'resztvevok'];
if (!in_array($type, $allowedTypes, true)) {
    respond(['success' => false, 'message' => 'Ismeretlen kategória: ' . $type], 400);
}

try {
    // Check if item exists
    $checkStmt = $pdo->prepare('SELECT id FROM settings WHERE id = :id AND category = :category');
    $checkStmt->execute([':id' => $id, ':category' => $type]);
    
    if (!$checkStmt->fetch()) {
        respond(['success' => false, 'message' => 'Az elem nem található.'], 404);
    }

    // Delete the item
    $deleteStmt = $pdo->prepare('DELETE FROM settings WHERE id = :id AND category = :category');
    $deleteStmt->execute([':id' => $id, ':category' => $type]);

    if ($deleteStmt->rowCount() > 0) {
        respond(['success' => true, 'message' => 'Az elem sikeresen törölve.']);
    } else {
        respond(['success' => false, 'message' => 'Nem sikerült törölni az elemet.'], 500);
    }
} catch (PDOException $e) {
    respond(['success' => false, 'message' => 'Adatbázis hiba: ' . $e->getMessage()], 500);
} catch (Throwable $e) {
    respond(['success' => false, 'message' => 'Váratlan hiba: ' . $e->getMessage()], 500);
}