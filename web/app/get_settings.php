<?php
// filepath: \srv\containers\test_bkt_tnaptar_app\web\app\get_settings.php
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

    $category = $_GET['category'] ?? $_GET['type'] ?? null;
    if (!$category) {
        throw new Exception('Hiányzó paraméter: category vagy type');
    }

    // Validate allowed categories
    $allowedCategories = ['birosag', 'tanacs', 'room', 'resztvevok'];
    if (!in_array($category, $allowedCategories, true)) {
        throw new Exception('Ismeretlen kategória: ' . $category);
    }

    // Check if this is for dropdown (active only) or admin (all items)
    $forDropdown = isset($_GET['dropdown']) || isset($_GET['type']);

    if ($forDropdown) {
        // For dropdowns: only active items, minimal fields
        $stmt = $pdo->prepare("
        SELECT id, value
        FROM settings
        WHERE category = :category AND active = TRUE
        ORDER BY sort_order ASC, value ASC
    ");
    } else {
        // For admin: all items with full details
        $stmt = $pdo->prepare("
        SELECT id, value, sort_order, active
        FROM settings
        WHERE category = :category
        ORDER BY sort_order ASC, value ASC
    ");
    }

    $stmt->execute([':category' => $category]);
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

// Clear any unwanted output before JSON
while (ob_get_level() > 0) {
    ob_end_clean();
}
echo json_encode($response, JSON_UNESCAPED_UNICODE | JSON_INVALID_UTF8_SUBSTITUTE);