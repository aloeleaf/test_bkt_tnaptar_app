<?php
$config = require __DIR__ . '/../config/config.php';
require_once __DIR__ . '/Database.php';

$db = new Database($config);
$pdo = $db->getPdo();

$data = json_decode(file_get_contents('php://input'), true);
$id = $data['id'] ?? null;

if ($id) {
    $stmt = $pdo->prepare("DELETE FROM settings WHERE id = ?");
    $stmt->execute([$id]);
    echo json_encode(['success' => true]);
} else {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Hiányzó ID']);
}
