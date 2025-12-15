<?php
// delete_entry.php - Confirmation page for deleting a booking entry
session_start();

$config = require __DIR__ . '/config/config.php';
require_once __DIR__ . '/app/Database.php';
require_once __DIR__ . '/app/Auth.php';

// Check authentication and delete permissions
if (!Auth::isAuthenticated()) {
    header('Location: index.php');
    exit;
}

if (!Auth::canDelete()) {
    $_SESSION['error_message'] = 'Nincs jogosultságod a bejegyzések törléséhez!';
    header('Location: dashboard.php');
    exit;
}

$db = new Database($config);
$pdo = $db->getPdo();

$id = $_GET['id'] ?? null;
$error = '';
$entry = null;

if (!$id || !is_numeric($id)) {
    $error = 'Érvénytelen azonosító!';
} else {
    // Fetch entry details
    try {
        $stmt = $pdo->prepare("SELECT * FROM rooms WHERE id = :id");
        $stmt->execute([':id' => $id]);
        $entry = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if (!$entry) {
            $error = 'A bejegyzés nem található!';
        }
    } catch (PDOException $e) {
        $error = 'Adatbázis hiba: ' . htmlspecialchars($e->getMessage());
    }
}

// Handle delete confirmation
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['confirm_delete']) && $entry) {
    try {
        $stmt = $pdo->prepare("DELETE FROM rooms WHERE id = :id");
        $stmt->execute([':id' => $id]);
        
        $_SESSION['success_message'] = 'A bejegyzés sikeresen törölve!';
        header('Location: dashboard.php');
        exit;
    } catch (PDOException $e) {
        $error = 'Törlési hiba: ' . htmlspecialchars($e->getMessage());
    }
}

// Format times for display
if ($entry) {
    $start_time = isset($entry['start_time']) ? substr($entry['start_time'], 0, 5) : '';
    $end_time = isset($entry['end_time']) ? substr($entry['end_time'], 0, 5) : '';
}
?>
<!DOCTYPE html>
<html lang="hu">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bejegyzés törlése - BKT Naptár</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .delete-confirmation {
            max-width: 800px;
            margin: 50px auto;
        }
        .entry-details {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 20px;
            margin: 20px 0;
        }
        .warning-box {
            background-color: #fff3cd;
            border: 2px solid #ffc107;
            border-radius: 8px;
            padding: 20px;
            margin: 20px 0;
        }
        .btn-cancel {
            background-color: #6c757d;
            color: white;
        }
    </style>
</head>
<body>
    <div class="container delete-confirmation">
        <div class="card shadow">
            <div class="card-header bg-danger text-white">
                <h3 class="mb-0"><i class="fa-solid fa-exclamation-triangle"></i> Bejegyzés törlésének megerősítése</h3>
            </div>
            <div class="card-body">
                <?php if ($error): ?>
                    <div class="alert alert-danger" role="alert">
                        <i class="fa-solid fa-circle-xmark"></i> <?= $error ?>
                    </div>
                    <div class="text-center mt-4">
                        <a href="dashboard.php" class="btn btn-secondary">
                            <i class="fa-solid fa-arrow-left"></i> Vissza
                        </a>
                    </div>
                <?php elseif ($entry): ?>
                    <div class="warning-box">
                        <h5><i class="fa-solid fa-triangle-exclamation"></i> Figyelmeztetés!</h5>
                        <p class="mb-0">Biztosan törölni szeretnéd ezt a tárgyalási bejegyzést? Ez a művelet nem vonható vissza!</p>
                    </div>

                    <div class="entry-details">
                        <h5 class="mb-3"><i class="fa-solid fa-info-circle"></i> Törlendő bejegyzés részletei:</h5>
                        <div class="row mb-2">
                            <div class="col-md-4"><strong>Bíróság:</strong></div>
                            <div class="col-md-8"><?= htmlspecialchars($entry['birosag'] ?? 'N/A') ?></div>
                        </div>
                        <div class="row mb-2">
                            <div class="col-md-4"><strong>Tanács:</strong></div>
                            <div class="col-md-8"><?= htmlspecialchars($entry['tanacs'] ?? 'N/A') ?></div>
                        </div>
                        <div class="row mb-2">
                            <div class="col-md-4"><strong>Dátum:</strong></div>
                            <div class="col-md-8"><?= htmlspecialchars($entry['date'] ?? 'N/A') ?></div>
                        </div>
                        <div class="row mb-2">
                            <div class="col-md-4"><strong>Időpont:</strong></div>
                            <div class="col-md-8"><?= htmlspecialchars($start_time) ?> - <?= htmlspecialchars($end_time) ?></div>
                        </div>
                        <div class="row mb-2">
                            <div class="col-md-4"><strong>Tárgyaló:</strong></div>
                            <div class="col-md-8"><?= htmlspecialchars($entry['rooms'] ?? 'N/A') ?></div>
                        </div>
                        <div class="row mb-2">
                            <div class="col-md-4"><strong>Ügyszám:</strong></div>
                            <div class="col-md-8"><?= htmlspecialchars($entry['ugyszam'] ?? 'N/A') ?></div>
                        </div>
                        <div class="row mb-2">
                            <div class="col-md-4"><strong>Tárgy:</strong></div>
                            <div class="col-md-8"><?= nl2br(htmlspecialchars($entry['subject'] ?? 'N/A')) ?></div>
                        </div>
                        <div class="row mb-2">
                            <div class="col-md-4"><strong>Alperes/Terhelt:</strong></div>
                            <div class="col-md-8"><?= htmlspecialchars($entry['alperes_terhelt'] ?? 'N/A') ?></div>
                        </div>
                        <div class="row mb-2">
                            <div class="col-md-4"><strong>Felperes/Vádló:</strong></div>
                            <div class="col-md-8"><?= htmlspecialchars($entry['felperes_vadlo'] ?? 'N/A') ?></div>
                        </div>
                        <div class="row mb-2">
                            <div class="col-md-4"><strong>Idézettek száma:</strong></div>
                            <div class="col-md-8"><?= htmlspecialchars($entry['letszam'] ?? 'N/A') ?></div>
                        </div>
                    </div>

                    <form method="POST" class="mt-4">
                        <div class="d-flex justify-content-center gap-3">
                            <a href="dashboard.php" class="btn btn-cancel btn-lg">
                                <i class="fa-solid fa-times"></i> Mégse
                            </a>
                            <button type="submit" name="confirm_delete" class="btn btn-danger btn-lg">
                                <i class="fa-solid fa-trash"></i> Törlés megerősítése
                            </button>
                        </div>
                    </form>
                <?php endif; ?>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
