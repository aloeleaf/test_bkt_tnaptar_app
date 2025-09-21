<?php
$config = require __DIR__ . '/../config/config.php';
require_once __DIR__ . '/Database.php';

ob_start();
ini_set('display_errors', '0');
ini_set('log_errors', '1');
header('Content-Type: application/json; charset=utf-8');


function respond(array $payload, int $code = 200): void {
    http_response_code($code);
    while (ob_get_level() > 0) { ob_end_clean(); }
    echo json_encode($payload, JSON_UNESCAPED_UNICODE | JSON_INVALID_UTF8_SUBSTITUTE);
    exit;
}

try {
    $db = new Database($config);
    $pdo = $db->getPdo();
} catch (Throwable $e) {
    respond(['success' => false, 'message' => 'Adatbázis kapcsolat hiba: ' . $e->getMessage()], 500);
}

// Inputs
$birosag          = trim($_POST['court_name'] ?? '');
$tanacs           = trim($_POST['council_name'] ?? '');
$dateInput        = trim($_POST['date'] ?? '');
$room             = trim($_POST['room_number'] ?? '');
$startInput       = trim($_POST['kezd_ido'] ?? '');
$endInputRaw      = trim($_POST['befejez_ido'] ?? '');
$ugyszam          = trim($_POST['ugyszam'] ?? '');
$resztvevok       = trim($_POST['resztvevok'] ?? '');
$letszamInput     = trim($_POST['letszam'] ?? '');
$ugyminoseg       = trim($_POST['ugyminoseg'] ?? '');
$alperes_terhelt  = trim($_POST['alperes_terhelt'] ?? '');
$felperes_vadlo   = trim($_POST['felperes_vadlo'] ?? '');

// Required
if ($birosag === '' || $tanacs === '' || $dateInput === '' || $room === '' || $startInput === '' || $resztvevok === '') {
    respond(['success' => false, 'message' => 'Hiányzó kötelező mező(k): Bíróság, Tanács, Dátum, Tárgyaló, Kezdési idő, Résztvevők.'], 422);
}


// Validate date
$dateObj = DateTime::createFromFormat('Y-m-d', $dateInput);
$dtErr = DateTime::getLastErrors();
$warnCount = is_array($dtErr) ? ($dtErr['warning_count'] ?? 0) : 0;
$errCount  = is_array($dtErr) ? ($dtErr['error_count'] ?? 0) : 0;
if (!$dateObj || $warnCount > 0 || $errCount > 0) {
    respond(['success' => false, 'message' => 'Érvénytelen dátum formátum (YYYY-MM-DD).'], 422);
}
$dateForDb = $dateObj->format('Y-m-d');


// Times
$startObj = DateTime::createFromFormat('H:i', $startInput);
$endEff   = ($endInputRaw !== '') ? $endInputRaw : '16:00';
$endObj   = DateTime::createFromFormat('H:i', $endEff);
if (!$startObj || !$endObj) {
    respond(['success' => false, 'message' => 'Érvénytelen időformátum (HH:MM).'], 422);
}
if ($startObj >= $endObj) {
    respond(['success' => false, 'message' => 'A befejezési időpontnak későbbinek kell lennie, mint a kezdési időpont.'], 422);
}
$start_time_for_db = $startObj->format('H:i:s');
$end_time_for_db   = $endObj->format('H:i:s');

// Numeric validations
$letszam = ($letszamInput === '') ? null : (filter_var($letszamInput, FILTER_VALIDATE_INT) !== false ? (int)$letszamInput : null);
if ($letszamInput !== '' && $letszam === null) {
    respond(['success' => false, 'message' => 'A létszám csak szám lehet.'], 422);
}

// Overlap check
try {
    $overlap_stmt = $pdo->prepare(
        "SELECT COUNT(*) FROM `rooms`
         WHERE `rooms` = :room
           AND `date` = :date
           AND `start_time` < :end_time
           AND `end_time` > :start_time"
    );
    $overlap_stmt->execute([
        ':room'       => $room,
        ':date'       => $dateForDb,
        ':start_time' => $start_time_for_db,
        ':end_time'   => $end_time_for_db
    ]);
    if ((int)$overlap_stmt->fetchColumn() > 0) {
        respond(['success' => false, 'message' => 'Hiba: A megadott időpont ütközik egy már meglévő foglalással.'], 409);
    }
} catch (PDOException $e) {
    respond(['success' => false, 'message' => 'Ütközésvizsgálat hiba: ' . $e->getMessage()], 500);
}

// Summarys
$subject  = $ugyminoseg;
$foglalas = trim(
    "Kezdés: {$startObj->format('H:i')}\n" .
    "Befejezés: {$endObj->format('H:i')}\n" .
    "Ügyszám: {$ugyszam}\n" .
    "Létszám: " . ($letszam ?? '') . "\n" .
    "Tárgy: {$subject}\n" .
    "Alperes/Vádlott: {$alperes_terhelt}\n" .
    "Felperes/Vádló: {$felperes_vadlo}"
);

// $foglalas = sprintf(
//     "Ügyszám: %s<br>".
//     "Időpont: %s - %s<br>".
//     "Létszám: %s<br>".
//     "Alperes/Vádlott: %s<br>".
//     "Felperes/Vádló: %s<br>".
//     "Tárgy: %s<br>".
//     "<div style='border-bottom: 2px solid #16000081; margin: 8px 0; width: 100%%;'></div>",
//     $ugyszam,
//     $startObj->format('H:i'),
//     $endObj->format('H:i'),
//     $letszam ?? '',
//     $alperes_terhelt,
//     $felperes_vadlo,
//     $subject
// );

// Insert
try {
    $stmt = $pdo->prepare(
        "INSERT INTO `rooms`
         (`birosag`, `tanacs`, `date`, `start_time`, `end_time`, `rooms`, `ugyszam`, `subject`, `letszam`, `resztvevok`, `alperes_terhelt`, `felperes_vadlo`, `foglalas`)
         VALUES
         (:birosag, :tanacs, :date, :start_time, :end_time, :rooms, :ugyszam, :subject, :letszam, :resztvevok, :alperes_terhelt, :felperes_vadlo, :foglalas)"
    );
    $stmt->execute([
        ':birosag'          => $birosag,
        ':tanacs'           => $tanacs,
        ':date'             => $dateForDb,
        ':start_time'       => $start_time_for_db,
        ':end_time'         => $end_time_for_db,
        ':rooms'            => $room,
        ':ugyszam'          => $ugyszam,
        ':subject'          => $subject,
        ':letszam'          => $letszam,
        ':resztvevok'       => $resztvevok,
        ':alperes_terhelt'  => $alperes_terhelt,
        ':felperes_vadlo'   => $felperes_vadlo,
        ':foglalas'         => $foglalas
    ]);

    $insertId = (int)$pdo->lastInsertId();
    respond(['success' => true, 'id' => $insertId, 'message' => 'Sikeres rögzítés'], 201);
} catch (PDOException $e) {
    if ($e->getCode() === '23000') {
        respond(['success' => false, 'message' => 'Hiba: Ebben az időpontban ez a tárgyaló már foglalt! (DB)'], 409);
    }
    respond(['success' => false, 'message' => 'Adatbázis hiba a rögzítéskor: ' . $e->getMessage()], 500);
} catch (Throwable $e) {
    respond(['success' => false, 'message' => 'Váratlan hiba: ' . $e->getMessage()], 500);
}