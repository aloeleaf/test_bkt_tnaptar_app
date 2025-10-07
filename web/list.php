<?php
// Betöltjük a configot és a Database osztályt
$config = require __DIR__ . '/config/config.php';
require_once __DIR__ . '/app/Database.php';

// Adatbázis kapcsolat létrehozása
$db = new Database($config);
$pdo = $db->getPdo();

// Safe ORDER BY mapping - prevents SQL injection
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

$orderClause = $orderOptions[$orderBy];

// PostgreSQL kompatibilis lekérdezés
try {
    $stmt = $pdo->prepare("SELECT * FROM rooms WHERE date >= CURRENT_DATE - INTERVAL '28 days' ORDER BY " . $orderClause);
    $stmt->execute();
    $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    echo '<div class="alert alert-danger">Adatbázis lekérdezési hiba: ' . htmlspecialchars($e->getMessage()) . '</div>';
    exit;
}

// Átalakítjuk a mezőket a megjelenítéshez
$filtered_entries = array_map(function ($row) {
    $start_time = $row['start_time'] ?? '';
    $end_time = $row['end_time'] ?? '';
    $formatted_start_time = $start_time ? substr($start_time, 0, 5) : '';
    $formatted_end_time = $end_time ? substr($end_time, 0, 5) : '';
    
    return [
        'court_name'     => $row['birosag'] ?? '',
        'council_name'   => $row['tanacs'] ?? '',
        'session_date'   => $row['date'] ?? '',
        'room_number'    => $row['rooms'] ?? '',
        'kezd_ido'       => $formatted_start_time,
        'befejez_ido'    => $formatted_end_time,
        'ugyszam'        => $row['ugyszam'] ?? '',
        'persons'        => $row['resztvevok'] ?? '',
        'alperes_terhelt'=> $row['alperes_terhelt'] ?? '',
        'felperes_vadlo' => $row['felperes_vadlo'] ?? '',
        'letszam'        => $row['letszam'] ?? '', 
        'subject'        => $row['subject'] ?? '',
        'id'             => $row['id'] ?? '', 
    ];
}, $rows);
?>

<div class="container mt-5">
    <h1 class="mb-4 text-center mt-custom-top-margin">Tárgyalási naptár lista</h1>

    <div class="row mb-4 align-items-center">
        <div class="col-md-7">
            <input type="text" class="form-control" id="Search" placeholder="Keresés az ügyszám, bíróság és tanács alapján...">
        </div>
        <div class="col-md-3">
            <select class="form-select form-select-sm" id="sortOrderSelect">
                <option value="date" <?= ($orderBy === 'date' ? 'selected' : '') ?>>Rendezés: Dátum szerint</option>
                <option value="ugyszam" <?= ($orderBy === 'ugyszam' ? 'selected' : '') ?>>Rendezés: Ügyszám szerint</option>
                <option value="room_number" <?= ($orderBy === 'room_number' ? 'selected' : '') ?>>Rendezés: Tárgyaló szerint</option>
                <option value="council_name" <?= ($orderBy === 'council_name' ? 'selected' : '') ?>>Rendezés: Tanács szerint</option>
                <option value="room_date_time" <?= ($orderBy === 'room_date_time' ? 'selected' : '') ?>>Rendezés: Tárgyaló + Dátum + Idő</option>
            </select>
        </div>
        <div class="col-md-2 text-end">
            <button id="exportCsvBtn" class="btn btn-info btn-sm">
                <i class="fa-solid fa-file-csv"></i> Exportálás CSV-be
            </button>
        </div>
    </div>

    <div id="ListContainer" class="row">
        <?php if (empty($filtered_entries)): ?>
            <div class="alert alert-info" role="alert">
                Nincs megjeleníthető bejegyzés az elmúlt 4 hétből.
            </div>
        <?php else: ?>
            <?php foreach ($filtered_entries as $data): ?>
                <div class="col-12 col-md-6 mb-4">
                    <div class="card entry-card h-100">
                        <div class="card-header text-center">
                            Tárgyalási Bejegyzés - <?php echo htmlspecialchars($data['ugyszam'] ?? 'N/A'); ?> (<?php echo htmlspecialchars($data['session_date'] ?? 'N/A'); ?>)
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-12 mb-2"><strong title="A tárgyalás helyszínéül szolgáló bíróság neve.">Bíróság:</strong> <?= htmlspecialchars($data['court_name'] ?? 'N/A'); ?></div>
                            </div>
                            <div class="row">
                                <div class="col-12 mb-2"><strong title="A tárgyalást vezető bíró.">Tanács:</strong> <?= htmlspecialchars($data['council_name'] ?? 'N/A'); ?></div>
                            </div>
                            <div class="row">
                                <div class="col-12 mb-2"><strong title="A tárgyalás dátuma.">Dátum:</strong> <?= htmlspecialchars($data['session_date'] ?? 'N/A'); ?></div>
                            </div>
                            <div class="row">
                                <div class="col-12 mb-2"><strong title="A tárgyalás helyszínéül szolgáló tárgyalóterem száma vagy neve.">Tárgyaló:</strong> <?= htmlspecialchars($data['room_number'] ?? 'N/A'); ?></div>
                            </div>
                            <div class="row">
                                <div class="col-12 mb-2"><strong title="A tárgyalás kezdési időpontja.">Kezdés:</strong> <?= htmlspecialchars($data['kezd_ido'] ?? 'N/A'); ?></div>
                            </div>
                            <div class="row">
                                <div class="col-12 mb-2"><strong title="A tárgyalás befejezési időpontja.">Befejezés:</strong> <?= htmlspecialchars($data['befejez_ido'] ?? 'N/A'); ?></div>
                            </div>       
                            <div class="row">
                                <div class="col-12 mb-2"><strong title="A tárgyalás ügyazonosító száma.">Ügyszám:</strong> <?= htmlspecialchars($data['ugyszam'] ?? 'N/A'); ?></div>
                            </div>
                            <div class="row">
                                <div class="col-12 mb-2"><strong title="A tárgyalásban résztvevő felek minősége.">Résztvevők:</strong> <?= nl2br(htmlspecialchars($data['persons'] ?? 'N/A')); ?></div>
                            </div>
                            <div class="row">
                                <div class="col-12 mb-2"><strong title="Alperes vagy vádlott neve.">Alperes/Vádlott:</strong> <?= htmlspecialchars($data['alperes_terhelt'] ?? 'N/A'); ?></div>
                            </div>
                            <div class="row">
                                <div class="col-12 mb-2"><strong title="Felperes vagy vádló neve.">Felperes/Vádló:</strong> <?= htmlspecialchars($data['felperes_vadlo'] ?? 'N/A'); ?></div>
                            </div>
                            <div class="row">
                                <div class="col-12 mb-2"><strong title="Az idézettek száma.">Idézettek száma:</strong> <?= htmlspecialchars($data['letszam'] ?? 'N/A'); ?></div>
                            </div>
                            <div class="row">
                                <div class="col-12 mb-2"><strong title="A tárgyalás tárgya vagy leírása.">Tárgy:</strong> <?= nl2br(htmlspecialchars($data['subject'] ?? 'N/A')); ?></div>
                            </div>
                        </div>
                        <div class="card-footer text-center">
                            <?php if (!empty($data['id'])): ?>
                                <a href="#" class="btn btn-primary btn-sm edit-button" data-id="<?= htmlspecialchars($data['id']); ?>">
                                    <i class="fa-solid fa-edit"></i> Szerkesztés
                                </a>
                            <?php else: ?>
                                <span class="text-muted">Nincs azonosító a szerkesztéshez</span>
                            <?php endif; ?>
                        </div>
                    </div>
                </div>
            <?php endforeach; ?>
        <?php endif; ?>
    </div>
</div>