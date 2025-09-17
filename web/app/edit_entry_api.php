<?php
// filepath: \srv\containers\test_bkt_tnaptar_app\web\app\edit_entry_api.php
ob_start();
ini_set('display_errors', '0');
ini_set('log_errors', '1');
header('Content-Type: application/json; charset=utf-8');

$config = require __DIR__ . '/../config/config.php';
require_once __DIR__ . '/Database.php';

function respond(array $payload, int $code = 200): void {
    http_response_code($code);
    // Ensure no stray output corrupts JSON
    while (ob_get_level() > 0) { ob_end_clean(); }
    echo json_encode($payload, JSON_UNESCAPED_UNICODE | JSON_INVALID_UTF8_SUBSTITUTE);
    exit;
}

try {
    $db = new Database($config);
    $pdo = $db->getPdo();
} catch (Throwable $e) {
    respond(['success' => false, 'message' => 'Adatbázis kapcsolat hiba: ' . $e->getMessage(), 'data' => null], 500);
}

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
    $id = isset($_GET['id']) && is_numeric($_GET['id']) ? (int)$_GET['id'] : 0;
    if ($id <= 0) {
        respond(['success' => false, 'message' => 'Nincs megadva érvényes azonosító.', 'data' => null], 400);
    }
    try {
        $stmt = $pdo->prepare('SELECT * FROM rooms WHERE id = :id');
        $stmt->execute([':id' => $id]);
        $entry = $stmt->fetch(PDO::FETCH_ASSOC);
        if (!$entry) {
            respond(['success' => false, 'message' => 'A bejegyzés nem található.', 'data' => null], 404);
        }
        
        // Split subject into parts for backward compatibility
        $subject_parts = explode("\n", $entry['subject'] ?? '', 2);
        $entry['ugyminoseg'] = $subject_parts[0] ?? '';
        $entry['intezkedes'] = $subject_parts[1] ?? '';
        
        respond(['success' => true, 'message' => '', 'data' => $entry]);
    } catch (PDOException $e) {
        respond(['success' => false, 'message' => 'Adatbázis hiba: ' . $e->getMessage(), 'data' => null], 500);
    }
} elseif ($method === 'POST') {
    // Handle both legacy form (rogzites.php) and new edit form field names
    $id = isset($_POST['id']) && is_numeric($_POST['id']) ? (int)$_POST['id'] : 0;
    
    // Try new edit form field names first, then fall back to legacy names
    $birosag = trim($_POST['birosag'] ?? $_POST['court_name'] ?? '');
    $tanacs = trim($_POST['tanacs'] ?? $_POST['council_name'] ?? '');
    $date = trim($_POST['date'] ?? '');
    $rooms = trim($_POST['rooms'] ?? $_POST['room_number'] ?? '');
    $start_input = trim($_POST['start_time'] ?? $_POST['ido'] ?? $_POST['kezd_ido'] ?? '');
    $end_input_raw = trim($_POST['end_time'] ?? $_POST['befejez_ido'] ?? '');
    $ugyszam = trim($_POST['ugyszam'] ?? '');
    $persons = trim($_POST['resztvevok'] ?? $_POST['persons'] ?? '');
    $letszam = trim($_POST['letszam'] ?? $_POST['azon'] ?? '');
    $alperes_terhelt = trim($_POST['alperes_terhelt'] ?? '');
    $felperes_vadlo = trim($_POST['felperes_vadlo'] ?? '');
    
    // Handle subject field - could be combined or separate
    $subject_combined = trim($_POST['subject'] ?? '');
    $ugyminoseg = trim($_POST['ugyminoseg'] ?? '');
    $intezkedes = trim($_POST['intezkedes'] ?? '');
    
    // If combined subject is provided, use it; otherwise combine separate fields
    if ($subject_combined) {
        $final_subject = $subject_combined;
    } else {
        $final_subject = trim($ugyminoseg . "\n" . $intezkedes);
    }

    if ($id <= 0) {
        respond(['success' => false, 'message' => 'Hiányzó bejegyzés azonosító (id).', 'data' => null], 422);
    }
    if ($birosag === '' || $tanacs === '' || $date === '' || $rooms === '' || $ugyszam === '' || $start_input === '') {
        respond(['success' => false, 'message' => 'Hiányzó kötelező mező(k): Bíróság, Tanács, Dátum, Tárgyaló, Ügyszám, Kezdési idő.', 'data' => null], 422);
    }

    // Validate and process time fields
    $start_ts = DateTime::createFromFormat('H:i', $start_input);
    if (!$start_ts) {
        respond(['success' => false, 'message' => 'Érvénytelen kezdési időformátum (HH:MM).', 'data' => null], 422);
    }
    
    $end_eff = ($end_input_raw !== '') ? $end_input_raw : '16:00';
    $end_ts = DateTime::createFromFormat('H:i', $end_eff);
    if (!$end_ts) {
        respond(['success' => false, 'message' => 'Érvénytelen befejezési időformátum (HH:MM).', 'data' => null], 422);
    }
    
    if ($start_ts >= $end_ts) {
        respond(['success' => false, 'message' => 'A befejezési idő későbbi kell legyen, mint a kezdési idő.', 'data' => null], 422);
    }
    
    $start_time_for_db = $start_ts->format('H:i:s');
    $end_time_for_db = $end_ts->format('H:i:s');

    // Check for time conflicts
    try {
        $overlap = $pdo->prepare(
            'SELECT COUNT(*) FROM rooms
             WHERE rooms = :room AND date = :date
               AND start_time < :end_time
               AND end_time > :start_time
               AND id <> :id'
        );
        $overlap->execute([
            ':room' => $rooms,
            ':date' => $date,
            ':start_time' => $start_time_for_db,
            ':end_time' => $end_time_for_db,
            ':id' => $id
        ]);
        if ((int)$overlap->fetchColumn() > 0) {
            respond(['success' => false, 'message' => 'Hiba: A módosított időpont ütközik egy másik foglalással.', 'data' => null], 409);
        }
    } catch (PDOException $e) {
        respond(['success' => false, 'message' => 'Ütközésvizsgálat hiba: ' . $e->getMessage(), 'data' => null], 500);
    }

    // Create foglalas summary
    $foglalas = trim(
        "Kezdés: " . $start_ts->format('H:i') . "\n" .
        "Befejezés: " . $end_ts->format('H:i') . "\n" .
        "Ügyszám: " . $ugyszam . "\n" .
        "Létszám: " . $letszam . "\n" .
        "Tárgy: " . $final_subject . "\n" .
        "Alperes/Vádlott: " . $alperes_terhelt . "\n" .
        "Felperes/Vádló: " . $felperes_vadlo
    );

    // Update the database
    try {
        $stmt = $pdo->prepare(
            'UPDATE rooms SET
                birosag = :birosag,
                tanacs = :tanacs,
                date = :date,
                rooms = :rooms,
                start_time = :start_time,
                end_time = :end_time,
                ugyszam = :ugyszam,
                resztvevok = :persons,
                letszam = :letszam,
                alperes_terhelt = :alperes_terhelt,
                felperes_vadlo = :felperes_vadlo,
                subject = :subject,
                foglalas = :foglalas
             WHERE id = :id'
        );
        $ok = $stmt->execute([
            ':birosag' => $birosag,
            ':tanacs' => $tanacs,
            ':date' => $date,
            ':rooms' => $rooms,
            ':start_time' => $start_time_for_db,
            ':end_time' => $end_time_for_db,
            ':ugyszam' => $ugyszam,
            ':persons' => $persons,
            ':letszam' => $letszam,
            ':alperes_terhelt' => $alperes_terhelt,
            ':felperes_vadlo' => $felperes_vadlo,
            ':subject' => $final_subject,
            ':foglalas' => $foglalas,
            ':id' => $id
        ]);
        
        if ($ok && $stmt->rowCount() > 0) {
            respond(['success' => true, 'message' => 'A bejegyzés sikeresen frissítve!', 'data' => null]);
        } elseif ($ok) {
            respond(['success' => true, 'message' => 'Nincs változás az adatokban.', 'data' => null]);
        } else {
            respond(['success' => false, 'message' => 'Hiba történt a frissítés során.', 'data' => null], 500);
        }
    } catch (PDOException $e) {
        respond(['success' => false, 'message' => 'Adatbázis hiba: ' . $e->getMessage(), 'data' => null], 500);
    }
} else {
    respond(['success' => false, 'message' => 'Érvénytelen kérés metódus.', 'data' => null], 405);
}