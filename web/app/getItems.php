<?php
$config = require __DIR__ . '/../config/config.php';
require_once __DIR__ . '/Database.php';

$db = new Database($config);
$pdo = $db->getPdo();

$type = $_GET['type'] ?? null;

if ($type) {
    $stmt = $pdo->prepare("SELECT id, value FROM settings WHERE category = ? AND active = 1 ORDER BY sort_order ASC, value ASC");
    $stmt->execute([$type]);
    $items = $stmt->fetchAll(PDO::FETCH_ASSOC);
    echo json_encode($items);
} else {
    http_response_code(400);
    echo json_encode(['success' => false, 'message' => 'Hiányzó típus']);
}
