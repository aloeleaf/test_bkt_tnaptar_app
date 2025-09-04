<?php
$page_title = 'Bejelentkezés'; // <-- set this before including header
require_once __DIR__ . '/includes/header.php';
?>

    <div class="login-container">
    <h2 class="text-center mb-4">Bejelentkezés</h2>
    <?php if (!empty($error)): ?>
        <p class="alert alert-danger"><?= htmlspecialchars($error) ?></p>
    <?php endif; ?>
    <form method="post" action="">
        <div class="mb-3">
            <label class="form-label">Felhasználónév</label>
            <input type="text" class="form-control" name="username" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Jelszó</label>
            <input type="password" class="form-control" name="password" required>
        </div>
        <button type="submit" class="btn w-100 btn-brown">Belépés</button>
    </form>
    </div>
  <title><?= htmlspecialchars($page_title) ?></title>
    <script src="<?= $base_url ?>/assets/bootstrap/js/bootstrap.bundle.min.js"></script>


<?php require_once __DIR__ . '/includes/footer.php'; ?>