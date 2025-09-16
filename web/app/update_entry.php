<?php
// filepath: \srv\containers\test_bkt_tnaptar_app\web\app\update_entry.php
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

    // Forward to edit_entry_api.php for processing
    $_SERVER['REQUEST_METHOD'] = 'POST';
    require __DIR__ . '/edit_entry_api.php';

} catch (Exception $e) {
    $response['message'] = 'Hiba: ' . $e->getMessage();
    while (ob_get_level() > 0) { ob_end_clean(); }
    echo json_encode($response, JSON_UNESCAPED_UNICODE | JSON_INVALID_UTF8_SUBSTITUTE);
}