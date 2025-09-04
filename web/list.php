<?php
// Betöltjük a configot és a Database osztályt
$config = require __DIR__ . '/config/config.php';
require_once __DIR__ . '/app/Database.php';

$db = new Database($config);
$pdo = $db->getPdo();

// Alapértelmezett rendezési paraméterek
$orderBy = 'date';
$orderDir = 'DESC';
$secondaryOrderBy = 'time';
$secondaryOrderDir = 'ASC';


// Ha van rendezési paraméter az URL-ben, használjuk azt
if (isset($_GET['orderBy'])) {
    switch ($_GET['orderBy']) {
        case 'date':
            $orderBy = 'date';
            $orderDir = 'DESC';
            $secondaryOrderBy = 'time';
            $secondaryOrderDir = 'ASC';
            break;
        case 'room_number':
            $orderBy = 'rooms'; // Az adatbázis oszlop neve
            $orderDir = 'ASC';
            $secondaryOrderBy = 'date'; // Másodlagos rendezés
            $secondaryOrderDir = 'ASC';
            break;
        case 'council_name':
            $orderBy = 'tanacs'; // Az adatbázis oszlop neve
            $orderDir = 'ASC';
            $secondaryOrderBy = 'date'; // Másodlagos rendezés
            $secondaryOrderDir = 'ASC';
            break;
        case 'ugyszam':
            $orderBy = 'ugyszam';
            $orderDir = 'ASC';
            $secondaryOrderBy = 'date'; // Másodlagos rendezés
            $secondaryOrderDir = 'ASC';
            break;
        case 'room_date_time': // ÚJ RENDEZÉSI SZEMPONT
            $orderBy = 'rooms';
            $orderDir = 'ASC';
            $secondaryOrderBy = 'date, time'; // Több oszlop a másodlagos rendezéshez
            $secondaryOrderDir = 'ASC'; // Mindkettő ASC
            break;
        default:
            // Alapértelmezett, ha érvénytelen paramétert kapunk
            $orderBy = 'date';
            $orderDir = 'DESC';
            $secondaryOrderBy = 'time';
            $secondaryOrderDir = 'ASC';
            break;
    }
}

// Adatok lekérése az elmúlt 4 hétből a kiválasztott rendezés szerint
// Fontos: Az ORDER BY záradékot dinamikusan illesztjük be, de csak megbízható forrásból származó oszlopnevekkel!
// A secondaryOrderBy már tartalmazhatja a 'date, time' részt, ha a 'room_date_time' van kiválasztva
$sqlOrderClause = $orderBy . " " . $orderDir;
if ($secondaryOrderBy && $secondaryOrderBy !== 'time') { // Ne duplázzuk meg a 'time' rendezést, ha már az 'orderBy' része
    $sqlOrderClause .= ", " . $secondaryOrderBy . " " . $secondaryOrderDir;
} else if ($secondaryOrderBy === 'time' && $orderBy !== 'date') {
    // Ha az alapértelmezett időrendezés van, de nem dátum szerint rendezünk elsődlegesen
    $sqlOrderClause .= ", " . $secondaryOrderBy . " " . $secondaryOrderDir;
}

$stmt = $pdo->prepare("SELECT * FROM rooms WHERE date >= CURDATE() - INTERVAL 28 DAY ORDER BY " . $sqlOrderClause);
$stmt->execute();
$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

// Átalakítjuk a mezőket a megjelenítéshez
$filtered_entries = array_map(function ($row) { // Változó neve módosítva
    $time = $row['time'] ?? '';
    $formatted_time = $time ? substr($time, 0, 5) : '';
    return [
        'court_name'     => $row['birosag'] ?? '',
        'council_name'   => $row['tanacs'] ?? '',
        'session_date'   => $row['date'] ?? '',
        'room_number'    => $row['rooms'] ?? '',
        'sorszam'        => $row['sorszam'] ?? '',
        'ido'            => $formatted_time,
        'ugyszam'        => $row['ugyszam'] ?? '',
        'persons'        => $row['resztvevok'] ?? '',
        'azon'           => $row['letszam'] ?? '', 
        'id'             => $row['id'] ?? '', 
        'ugyminoseg'     => explode("\n", $row['subject'])[0] ?? '',
        'intezkedes'     => explode("\n", $row['subject'])[1] ?? '',
    ];
}, $rows);
?>

    <div class="container mt-5">
        <h1 class="mb-4 text-center mt-custom-top-margin">Tárgyalási Bejegyzések Listája </h1>

        <div class="row mb-4 align-items-center"> <!-- Új sor a kereső és export gombnak -->
            <div class="col-md-7"> <!-- Keresőmező oszlopa -->
                <input type="text" class="form-control" id="Search" placeholder="Keresés az ügyszám, bíróság és tanács alapján...">
            </div>
            <div class="col-md-3"> <!-- Rendezési opciók oszlopa -->
                <select class="form-select form-select-sm sort-Order-Selec" id="sortOrderSelect">
                    <option value="date" <?= ($orderBy === 'date' ? 'selected' : '') ?>>Rendezés: Dátum szerint</option>
                    <option value="ugyszam" <?= ($orderBy === 'ugyszam' ? 'selected' : '') ?>>Rendezés: Ügyszám szerint</option>
                    <option value="room_number" <?= ($orderBy === 'room_number' ? 'selected' : '') ?>>Rendezés: Tárgyaló szerint</option>
                    <option value="council_name" <?= ($orderBy === 'council_name' ? 'selected' : '') ?>>Rendezés: Tanács szerint</option>
                </select>
            </div>
            <div class="col-md-2 text-end"> <!-- Export gomb oszlopa, jobbra igazítva -->
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
                                        <div class="col-12 mb-2"><strong title="A tárgyalás sorszáma az adott napon.">Sorszám:</strong> <?= htmlspecialchars($data['sorszam'] ?? 'N/A'); ?></div>
                                    </div>
                                    <div class="row">
                                        <div class="col-12 mb-2"><strong title="A tárgyalás kezdési időpontja.">Idő:</strong> <?= htmlspecialchars($data['ido'] ?? 'N/A'); ?></div>
                                    </div>
                                    <div class="row">
                                        <div class="col-12 mb-2"><strong title="A tárgyalás ügyazonosító száma.">Ügyszám:</strong> <?= htmlspecialchars($data['ugyszam'] ?? 'N/A'); ?></div>
                                    </div>
                                    <div class="row">
                                        <div class="col-12 mb-2"><strong title="A tárgyalásban résztvevő felek minősége.">Résztvevők:</strong> <?= nl2br(htmlspecialchars($data['persons'] ?? 'N/A')); ?></div>
                                    </div>
                                    <div class="row">
                                        <div class="col-12 mb-2"><strong title="Az idézettek szám.">Id.:</strong> <?= htmlspecialchars($data['azon'] ?? 'N/A'); ?></div>
                                    </div>
                                    <div class="row">
                                        <div class="col-12 mb-2"><strong title="Az ügy minősítése vagy típusa.">Ügyminőség:</strong> <?= nl2br(htmlspecialchars($data['ugyminoseg'] ?? 'N/A')); ?></div>
                                    </div>
                                    <div class="row">
                                        <div class="col-12 mb-2"><strong title="Az ügyben hozott intézkedés vagy döntés.">Intézkedés:</strong> <?= nl2br(htmlspecialchars($data['intezkedes'] ?? 'N/A')); ?></div>
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
