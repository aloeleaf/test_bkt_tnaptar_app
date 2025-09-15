<?php
// app/get_list_data.php

// Betöltjük a configot és a Database osztályt
$config = require __DIR__ . '/../config/config.php';
require_once __DIR__ . '/Database.php';

$db = new Database($config);
$pdo = $db->getPdo();

header('Content-Type: application/json; charset=utf-8');

$response = [
    'success' => false,
    'message' => '',
    'data' => []
];

// Alapértelmezett rendezési klauzula
$sqlOrderClause = 'date DESC, start_time ASC';

// Ha van rendezési paraméter az URL-ben, felülírjuk az alapértelmezettet
if (isset($_GET['orderBy'])) {
    switch ($_GET['orderBy']) {
        case 'date':
            $sqlOrderClause = 'date DESC, start_time ASC';
            break;
        case 'room_number':
            $sqlOrderClause = 'rooms ASC, date ASC, start_time ASC';
            break;
        case 'council_name':
            $sqlOrderClause = 'tanacs ASC, date ASC, start_time ASC';
            break;
        case 'ugyszam':
            $sqlOrderClause = 'ugyszam ASC, date ASC, start_time ASC';
            break;
        default:
            // Ha érvénytelen paramétert kapunk, marad az alapértelmezett
            $sqlOrderClause = 'date DESC, start_time ASC';
            break;
    }
}

try {
    // Adatok lekérése az elmúlt 4 hétből a kiválasztott rendezés szerint
    $stmt = $pdo->prepare("SELECT * FROM rooms WHERE date >= CURDATE() - INTERVAL 28 DAY ORDER BY " . $sqlOrderClause);
    $stmt->execute();
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Átalakítjuk a mezőket a JSON válasz számára
    $formatted_data = array_map(function ($row) {
        // Kezdési idő formázása
        $start_time = $row['start_time'] ?? '';
        $formatted_start_time = $start_time ? substr($start_time, 0, 5) : '';

        // Befejezési idő formázása
        $end_time = $row['end_time'] ?? '';
        $formatted_end_time = $end_time ? substr($end_time, 0, 5) : '';
        
        // Konzisztens mezőnevek használata
        return [
            'id'               => $row['id'] ?? '',
            'court_name'       => $row['birosag'] ?? '',
            'council_name'     => $row['tanacs'] ?? '',
            'session_date'     => $row['date'] ?? '',
            'room_number'      => $row['rooms'] ?? '',
            'sorszam'          => $row['sorszam'] ?? '',
            'kezd_ido'         => $formatted_start_time,
            'befejez_ido'      => $formatted_end_time,
            'ugyszam'          => $row['ugyszam'] ?? '',
            'persons'          => $row['resztvevok'] ?? '',
            'azon'             => $row['letszam'] ?? '', 
            'ugyminoseg'       => $row['subject'] ?? '', // MODIFIED: 'subject' is now just 'ugyminoseg'
            'alperes_terhelt'  => $row['alperes_terhelt'] ?? '', // ADDED
            'felperes_vadlo'   => $row['felperes_vadlo'] ?? '',  // ADDED
        ];
    }, $rows);

    $response['success'] = true;
    $response['data'] = $formatted_data;

} catch (PDOException $e) {
    $response['message'] = 'Adatbázis hiba a listázáskor: ' . $e->getMessage();
}

echo json_encode($response);
?>