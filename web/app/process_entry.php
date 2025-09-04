<?php
// Betöltjük a configot és a Database osztályt
$config = require __DIR__ . '/../config/config.php';
require_once __DIR__ . '/Database.php';

// Létrehozzuk az adatbázis kapcsolatot a már meglévő Database osztállyal
$db = new Database($config);
$pdo = $db->getPdo();  // Ez adja a PDO objektumot

// POST adatok fogadása
$birosag = $_POST['court_name'] ?? '';
$tanacs = $_POST['council_name'] ?? '';
$date = $_POST['date'] ?? '';
$room = $_POST['room_number'] ?? '';
$time = $_POST['ido'] ?? '';
$ugyszam = $_POST['ugyszam'] ?? '';
$resztvevok = $_POST['resztvevok'] ?? '';
$letszam = $_POST['letszam'] ?? '';
$ugyminoseg = $_POST['ugyminoseg'] ?? '';
$intezkedes = $_POST['intezkedes'] ?? '';
$sorszam = $_POST['sorszam'] ?? ''; 

// Az ügyminőség és intézkedés összefűzése a subject mezőbe
$subject = trim($ugyminoseg . "\n" . $intezkedes);

// Egyszerű validáció
if (!$birosag || !$tanacs || !$date || !$time || !$room) {
    // Hibaüzenet JSON formátumban
    header('Content-Type: application/json');
    echo json_encode(['success' => false, 'message' => 'Hiányzó kötelező mező(k).']);
    exit; // Fontos, hogy kilépjünk a szkriptből
}

header('Content-Type: application/json');

try {
    $stmt = $pdo->prepare("INSERT INTO rooms (birosag, tanacs, date, time, rooms, ugyszam, subject, letszam, resztvevok, sorszam)
                            VALUES (:birosag, :tanacs, :date, :time, :rooms, :ugyszam, :subject, :letszam, :resztvevok, :sorszam)");
    $stmt->execute([
        ':birosag' => $birosag,
        ':tanacs' => $tanacs,
        ':date' => $date,
        ':time' => date('H:i', strtotime($time)),
        ':rooms' => $room,
        ':ugyszam' => $ugyszam,
        ':subject' => $subject,
        ':letszam' => $letszam,
        ':resztvevok' => $resztvevok,
        ':sorszam' => $sorszam, 
    ]);
    
    echo json_encode(['success' => true, 'message' => 'Sikeres rögzítés']);
} catch (PDOException $e) {
    echo json_encode(['success' => false, 'message' => 'Hiba: ' . $e->getMessage()]);
}
