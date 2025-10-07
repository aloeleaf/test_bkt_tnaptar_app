<?php
ob_start();
ini_set('display_errors', '0');
ini_set('log_errors', '1');
header('Content-Type: application/json; charset=utf-8');

$response = [
    'success' => false,
    'message' => '',
    'data' => []
];

try {
    $config = require __DIR__ . '/../config/config.php';
    require_once __DIR__ . '/Database.php';

    $db = new Database($config);
    $pdo = $db->getPdo();

    // Safe ORDER BY mapping to prevent SQL injection
    $orderOptions = [
        'date' => 'date DESC, start_time ASC',
        'room_number' => 'rooms ASC, date ASC, start_time ASC',
        'council_name' => 'tanacs ASC, date ASC, start_time ASC',
        'ugyszam' => 'ugyszam ASC, date ASC, start_time ASC',
        'room_date_time' => 'rooms ASC, date ASC, start_time ASC'
    ];

    $orderBy = $_GET['orderBy'] ?? 'date';
    if (!array_key_exists($orderBy, $orderOptions)) {
        $orderBy = 'date';
    }

    $sqlOrderClause = $orderOptions[$orderBy];

    // Adatok lekérése az elmúlt 4 hétből a kiválasztott rendezés szerint
    $stmt = $pdo->prepare("SELECT * FROM rooms WHERE date >= CURRENT_DATE - INTERVAL '28 days' ORDER BY " . $sqlOrderClause);
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
            'id' => $row['id'] ?? '',
            'court_name' => $row['birosag'] ?? '',
            'council_name' => $row['tanacs'] ?? '',
            'session_date' => $row['date'] ?? '',
            'room_number' => $row['rooms'] ?? '',
            'kezd_ido' => $formatted_start_time,
            'befejez_ido' => $formatted_end_time,
            'ugyszam' => $row['ugyszam'] ?? '',
            'persons' => $row['resztvevok'] ?? '',
            'letszam' => $row['letszam'] ?? '',
            'subject' => $row['subject'] ?? '',
            'alperes_terhelt' => $row['alperes_terhelt'] ?? '',
            'felperes_vadlo' => $row['felperes_vadlo'] ?? '',
        ];
    }, $rows);

    $response['success'] = true;
    $response['data'] = $formatted_data;

} catch (PDOException $e) {
    http_response_code(500);
    $response['message'] = 'Adatbázis hiba a listázáskor: ' . $e->getMessage();
} catch (Exception $e) {
    http_response_code(400);
    $response['message'] = 'Hiba: ' . $e->getMessage();
}

// Clear any unwanted output before JSON
while (ob_get_level() > 0) {
    ob_end_clean();
}
echo json_encode($response, JSON_UNESCAPED_UNICODE | JSON_INVALID_UTF8_SUBSTITUTE);