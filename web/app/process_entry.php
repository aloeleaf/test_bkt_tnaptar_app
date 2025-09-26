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
if ($birosag === '' || $tanacs === '' || $dateInput === '' || $room === '' || $startInput === '' || $resztvevok === '' || $letszamInput === '') {
    respond(['success' => false, 'message' => 'Hiányzó kötelező mező(k): Bíróság, Tanács, Dátum, Tárgyaló, Kezdési idő, Résztvevők, Idézettek száma.'], 422);
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
        "SELECT COUNT(*) FROM rooms
         WHERE rooms = :room
           AND date = :date
           AND start_time < :end_time
           AND end_time > :start_time"
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
$foglalas = '
<div class="foglalas">
    <div class="row">
        <div class="cell-tanacs">Tanács:</div>
        <div class="cell-tanacs-adat">' . htmlspecialchars($tanacs) . '</div>       
    </div>
    <div class="row">
        <div class="cell-date">Dátum</div>
        <div class="cell-start">Kezdés</div>
        <div class="cell-end">Befejezés</div>
    </div>
    <div class="row">
        <div class="cell-date-adat">' . htmlspecialchars($dateForDb) . '</div>
        <div class="cell-start-adat">' . htmlspecialchars($startObj->format('H:i')) . '</div>
        <div class="cell-end-adat">' . htmlspecialchars($endObj->format('H:i')) . '</div>
    </div>
    <div class="row">
        <div class="cell-letszam">Létszám:</div>
        <div class="cell-letszam-adat">' . htmlspecialchars($letszam ?? '') . '</div>
    </div>
    <div class="row">
        <div class="cell-alperes-terhelt">Alperes/Vádlott</div>
        <div class="cell-felperes-vadlo">Felperes/Vádló:</div>
    </div>
    <div class="row">
        <div class="cell-alperes-terhelt-adat">' . htmlspecialchars($alperes_terhelt) . '</div>
        <div class="cell-felperes-vadlo-adat">' . htmlspecialchars($felperes_vadlo) . '</div>
    </div>
    <div class="row">
        <div class="cell-targy">Tárgy:</div>
    </div>
    <div>
        <div class="cell-targy-adat">' . htmlspecialchars($subject) . '</div>
    </div>
</div>
';

// Insert
try {
    $stmt = $pdo->prepare(
        "INSERT INTO rooms
         (birosag, tanacs, date, start_time, end_time, rooms, ugyszam, subject, letszam, resztvevok, alperes_terhelt, felperes_vadlo, foglalas)
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