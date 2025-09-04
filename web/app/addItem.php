<?php
$config = require __DIR__ . '/../config/config.php';
require_once __DIR__ . '/Database.php';

$db = new Database($config);
$pdo = $db->getPdo();

$data = json_decode(file_get_contents('php://input'), true);
$category = $data['type'] ?? null;
$value = $data['name'] ?? null;

if ($category && $value) {
    $stmt = $pdo->prepare("INSERT INTO settings (category, value, sort_order, active) VALUES (?, ?, 0, 1)");
    $stmt->execute([$category, $value]);
    echo json_encode(['success' => true]);
} else {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Hiányzó adat']);
}
