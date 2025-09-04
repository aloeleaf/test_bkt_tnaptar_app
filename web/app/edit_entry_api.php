<?php
// app/edit_entry_api.php

// Betöltjük a configot és a Database osztályt
$config = require __DIR__ . '/../config/config.php'; // Fontos a helyes útvonal!
require_once __DIR__ . '/Database.php'; // Feltételezve, hogy a Database.php az app mappában van

$db = new Database($config);
$pdo = $db->getPdo();

header('Content-Type: application/json'); // Minden válasz JSON formátumú lesz

$response = [
    'success' => false,
    'message' => '',
    'data' => null
];

// Adatok lekérdezése (GET kérés)
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (isset($_GET['id']) && is_numeric($_GET['id'])) {
        $id = $_GET['id'];

        try {
            $stmt = $pdo->prepare("SELECT * FROM rooms WHERE id = :id");
            $stmt->bindParam(':id', $id, PDO::PARAM_INT);
            $stmt->execute();
            $entry_data = $stmt->fetch(PDO::FETCH_ASSOC); // Változó neve módosítva

            if ($entry_data) {
                // A 'subject' mező felosztása 'ugyminoseg'-re és 'intezkedes'-re
                $subject_parts = explode("\n", $entry_data['subject'] ?? '');
                $entry_data['ugyminoseg'] = $subject_parts[0] ?? '';
                $entry_data['intezkedes'] = $subject_parts[1] ?? '';

                $response['success'] = true;
                $response['data'] = $entry_data;
            } else {
                $response['message'] = 'A megadott azonosítóval nem található bejegyzés.'; 
            }
        } catch (PDOException $e) {
            $response['message'] = 'Adatbázis hiba a lekérdezéskor: ' . $e->getMessage();
        }
    } else {
        $response['message'] = 'Nincs megadva bejegyzés azonosító a lekérdezéshez.'; 
    }
} 
// Adatok frissítése (POST kérés)
else if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // DEBUG: Naplózzuk a teljes $_POST tömböt a szerver logjába
    error_log("edit_entry_api.php - Received POST data: " . print_r($_POST, true));

    // Ellenőrizzük, hogy minden szükséges adat megérkezett-e
    if (isset($_POST['id']) && is_numeric($_POST['id'])) {
        $id = $_POST['id'];
        // $_POST kulcsok igazítása a rogzites.php name attribútumaihoz
        $birosag = $_POST['court_name'] ?? ''; 
        $tanacs = $_POST['council_name'] ?? '';
        $date = $_POST['date'] ?? '';
        $rooms = $_POST['room_number'] ?? ''; 
        $sorszam = $_POST['sorszam'] ?? '';
        $time = $_POST['ido'] ?? ''; 
        $ugyszam = $_POST['ugyszam'] ?? '';
        $persons = $_POST['resztvevok'] ?? '';
        $letszam = $_POST['letszam'] ?? '';
        $ugyminoseg = $_POST['ugyminoseg'] ?? '';
        $intezkedes = $_POST['intezkedes'] ?? '';

        // Validáció: Ellenőrizzük a kötelező mezőket
        if (empty($birosag) || empty($tanacs) || empty($date) || empty($rooms) || empty($ugyszam) || empty($time)) {
            $response['message'] = 'Hiányzó kötelező mező(k): Bíróság, Tanács, Dátum, Tárgyaló, Ügyszám, Idő.';
            echo json_encode($response);
            exit; // Kilépés, ha a validáció sikertelen
        }

        $time_for_db = date('H:i:s', strtotime($time)); 

        // A 'subject' mező visszaállítása a két részből
        $subject = trim($ugyminoseg . "\n" . $intezkedes);

        try {
            $stmt = $pdo->prepare("UPDATE rooms SET 
                birosag = :birosag, 
                tanacs = :tanacs, 
                date = :date, 
                rooms = :rooms, 
                sorszam = :sorszam, 
                time = :time, 
                ugyszam = :ugyszam, 
                resztvevok = :persons, 
                letszam = :letszam, 
                subject = :subject 
                WHERE id = :id");

            $stmt->bindParam(':birosag', $birosag);
            $stmt->bindParam(':tanacs', $tanacs);
            $stmt->bindParam(':date', $date);
            $stmt->bindParam(':rooms', $rooms);
            $stmt->bindParam(':sorszam', $sorszam);
            $stmt->bindParam(':time', $time_for_db); 
            $stmt->bindParam(':ugyszam', $ugyszam);
            $stmt->bindParam(':persons', $persons);
            $stmt->bindParam(':letszam', $letszam);
            $stmt->bindParam(':subject', $subject);
            $stmt->bindParam(':id', $id, PDO::PARAM_INT);

            if ($stmt->execute()) {
                $response['success'] = true;
                $response['message'] = 'A bejegyzés sikeresen frissítve!'; 
            } else {
                $response['message'] = 'Hiba történt a bejegyzés frissítésekor.';
            }
        } catch (PDOException $e) {
            $response['message'] = 'Adatbázis hiba a frissítéskor: ' . $e->getMessage();
        }
    } else {
        $response['message'] = 'Hiányzó adatok a frissítéshez.';
    }
} else {
    $response['message'] = 'Érvénytelen kérés metódus.';
}

echo json_encode($response);
?>
