<?php
// app/get_dropdown_items.php

// Betöltjük a configot és a Database osztályt
$config = require __DIR__ . '/../config/config.php'; // Fontos a helyes útvonal!
require_once __DIR__ . '/Database.php'; // Feltételezve, hogy a Database.php az app mappában van

$db = new Database($config);
$pdo = $db->getPdo();

header('Content-Type: application/json'); // Minden válasz JSON formátumú lesz

$response = [
    'success' => false,
    'message' => '',
    'data' => []
];

// Ellenőrizzük, hogy van-e 'category' paraméter
if (isset($_GET['category'])) {
    $category = $_GET['category'];

    try {
        $stmt = $pdo->prepare("SELECT value FROM settings WHERE category = :category AND active = 1 ORDER BY value ASC");
        $stmt->bindParam(':category', $category, PDO::PARAM_STR);
        $stmt->execute();
        $items = $stmt->fetchAll(PDO::FETCH_COLUMN); // Csak az értékeket kérjük le

        $response['success'] = true;
        $response['data'] = $items;

    } catch (PDOException $e) {
        $response['message'] = 'Adatbázis hiba a lekérdezéskor: ' . $e->getMessage();
    }
} else {
    $response['message'] = 'Hiányzó "category" paraméter.';
}

echo json_encode($response);
?>
