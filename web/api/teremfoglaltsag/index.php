<?php
ob_start();
ini_set('display_errors', '0');
ini_set('log_errors', '1');
header('Content-Type: application/json; charset=utf-8');

$response = [
    'success' => false,
    'message' => '',
    'date'    => '',
    'time'    => null,
    'rooms'   => [],
];

try {
    // --- Parameter validation ---
    $dateParam = $_GET['date'] ?? date('Y-m-d');
    $timeParam = $_GET['time'] ?? null;
    $roomParam = isset($_GET['room']) && $_GET['room'] !== '' ? $_GET['room'] : null;

    if (!preg_match('/^\d{4}-\d{2}-\d{2}$/', $dateParam) || !checkdate(
        (int)substr($dateParam, 5, 2),
        (int)substr($dateParam, 8, 2),
        (int)substr($dateParam, 0, 4)
    )) {
        http_response_code(400);
        $response['message'] = 'Érvénytelen dátum formátum. Elvárt: YYYY-MM-DD';
        throw new InvalidArgumentException($response['message']);
    }

    if ($timeParam !== null) {
        if (!preg_match('/^\d{2}:\d{2}(:\d{2})?$/', $timeParam)) {
            http_response_code(400);
            $response['message'] = 'Érvénytelen idő formátum. Elvárt: HH:MM';
            throw new InvalidArgumentException($response['message']);
        }
        // Normalise to HH:MM
        $timeParam = substr($timeParam, 0, 5);
    }

    $response['date'] = $dateParam;
    $response['time'] = $timeParam;
    $response['room'] = $roomParam;

    // --- Database ---
    $config = require __DIR__ . '/../../config/config.php';
    require_once __DIR__ . '/../../app/Database.php';

    $db  = new Database($config);
    $pdo = $db->getPdo();

    // Fetch active rooms from settings (filter to requested room if given)
    if ($roomParam !== null) {
        $stmtRooms = $pdo->prepare("SELECT value FROM settings WHERE category = 'room' AND active = true AND value = :room ORDER BY value");
        $stmtRooms->execute([':room' => $roomParam]);
    } else {
        $stmtRooms = $pdo->query("SELECT value FROM settings WHERE category = 'room' AND active = true ORDER BY value");
    }
    $activeRooms = $stmtRooms->fetchAll(PDO::FETCH_COLUMN);

    // Build query – optionally narrow by time and/or room
    $where   = ['date = :date'];
    $params  = [':date' => $dateParam];

    if ($timeParam !== null) {
        $where[]         = 'start_time <= :time';
        $where[]         = 'end_time > :time';
        $params[':time'] = $timeParam;
    }

    if ($roomParam !== null) {
        $where[]         = 'rooms = :room';
        $params[':room'] = $roomParam;
    }

    $sql  = "SELECT rooms, start_time, end_time, birosag, tanacs, ugyszam, subject,
                    letszam, resztvevok, alperes_terhelt, felperes_vadlo, foglalas
             FROM rooms
             WHERE " . implode(' AND ', $where) . "
             ORDER BY rooms ASC, start_time ASC";
    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);

    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Initialise matrix with empty entries for every active room
    $matrix = [];
    foreach ($activeRooms as $room) {
        $matrix[$room] = ['foglalt' => false, 'foglalas' => []];
    }

    // Fill matrix – also include rooms not in settings (edge case)
    foreach ($rows as $row) {
        $roomName = $row['rooms'];
        if (!isset($matrix[$roomName])) {
            $matrix[$roomName] = ['foglalt' => false, 'foglalas' => []];
        }
        $matrix[$roomName]['foglalt']    = true;
        $matrix[$roomName]['foglalas'][] = [
            'start_time'      => substr($row['start_time'], 0, 5),
            'end_time'        => substr($row['end_time'],   0, 5),
            'birosag'         => $row['birosag'],
            'tanacs'          => $row['tanacs'],
            'ugyszam'         => $row['ugyszam'],
            'subject'         => $row['subject'],
            'letszam'         => $row['letszam'],
            'resztvevok'      => $row['resztvevok'],
            'alperes_terhelt' => $row['alperes_terhelt'],
            'felperes_vadlo'  => $row['felperes_vadlo'],
            'foglalas'        => $row['foglalas'],
        ];
    }

    $response['success'] = true;
    $response['rooms']   = $matrix;

} catch (InvalidArgumentException $e) {
    // message already set above
} catch (PDOException $e) {
    http_response_code(500);
    $response['message'] = 'Adatbázis hiba: ' . $e->getMessage();
} catch (Exception $e) {
    http_response_code(500);
    $response['message'] = 'Hiba: ' . $e->getMessage();
}

while (ob_get_level() > 0) {
    ob_end_clean();
}
echo json_encode($response, JSON_UNESCAPED_UNICODE | JSON_INVALID_UTF8_SUBSTITUTE | JSON_PRETTY_PRINT);
