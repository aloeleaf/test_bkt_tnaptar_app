<?php
// filepath: \srv\containers\test_bkt_tnaptar_app\web\edit_entry_form.php
// This file contains only HTML for AJAX loading
?>
<div class="container mt-5">
    <h1 class="mb-4 text-center mt-custom-top-margin">Jegyzőkönyv szerkesztése</h1>

    <!-- Az üzenetek megjelenítésére szolgáló div. A JavaScript fogja feltölteni. -->
    <div id="editMessage" class="alert d-none" role="alert"></div>

    <form id="editEntryForm" action="" method="POST">
        <!-- Az ID mező rejtett lesz, a JavaScript tölti fel -->
        <input type="hidden" name="id" id="editEntryId" value="">

        <div class="row">
            <div class="col-md-6 mb-3">
                <label for="editBirosag" class="form-label">Bíróság:</label>
                <select class="form-select" id="editBirosag" name="birosag" required>
                    <option value="">Válasszon bíróságot...</option>
                </select>
            </div>
            <div class="col-md-6 mb-3">
                <label for="editTanacs" class="form-label">Tanács:</label>
                <select class="form-select" id="editTanacs" name="tanacs" required>
                    <option value="">Válasszon tanácsot...</option>
                </select>
            </div>
        </div>

        <div class="row">
            <div class="col-md-4 mb-3">
                <label for="editDate" class="form-label">Dátum:</label>
                <input type="date" class="form-control" id="editDate" name="date" required>
            </div>
            <div class="col-md-4 mb-3">
                <label for="editRooms" class="form-label">Tárgyaló:</label>
                <select class="form-select" id="editRooms" name="rooms" required>
                    <option value="">Válasszon tárgyalót...</option>
                </select>
            </div>
            <div class="col-md-4 mb-3">
                <label for="editSorszam" class="form-label">Sorszám:</label>
                <input type="text" class="form-control" id="editSorszam" name="sorszam">
            </div>
        </div>

        <div class="row">
            <div class="col-md-6 mb-3">
                <label for="editStartTime" class="form-label">Kezdési idő:</label>
                <input type="time" class="form-control" id="editStartTime" name="start_time" required>
            </div>
            <div class="col-md-6 mb-3">
                <label for="editEndTime" class="form-label">Befejezési idő:</label>
                <input type="time" class="form-control" id="editEndTime" name="end_time">
            </div>
        </div>

        <div class="mb-3">
            <label for="editUgyszam" class="form-label">Ügyszám:</label>
            <input type="text" class="form-control" id="editUgyszam" name="ugyszam" required>
        </div>

        <div class="row">
            <div class="col-md-6 mb-3">
                <label for="editAlperesTerhelt" class="form-label">Alperes/Vádlott:</label>
                <input type="text" class="form-control" id="editAlperesTerhelt" name="alperes_terhelt">
            </div>
            <div class="col-md-6 mb-3">
                <label for="editFelperesVadlo" class="form-label">Felperes/Vádló:</label>
                <input type="text" class="form-control" id="editFelperesVadlo" name="felperes_vadlo">
            </div>
        </div>

        <div class="mb-3">
            <label for="editResztvevok" class="form-label">Résztvevők:</label>
            <input type="text" class="form-control" id="editResztvevok" name="resztvevok" 
                   placeholder="Írja be a résztvevőket...">
            <div class="form-text">Pl: bíró, ügyész, védő</div>
        </div>

        <div class="mb-3">
            <label for="editLetszam" class="form-label">Id. (Létszám):</label>
            <input type="number" class="form-control" id="editLetszam" name="letszam" min="1">
        </div>

        <div class="mb-3">
            <label for="editSubject" class="form-label">Ügyminőség és intézkedés:</label>
            <textarea class="form-control" id="editSubject" name="subject" rows="4" 
                placeholder="Első sor: Ügyminőség&#10;Második sor: Intézkedés"></textarea>
            <div class="form-text">Első sor: ügyminőség, második sor: intézkedés</div>
        </div>

        <div class="d-flex gap-2">
            <button type="submit" class="btn btn-success">
                <i class="fa-solid fa-save"></i> Módosítások mentése
            </button>
            <button type="button" id="cancelEditBtn" class="btn btn-secondary">
                <i class="fa-solid fa-ban"></i> Mégse
            </button>
        </div>
    </form>
</div>

<!-- Fontos: Ez a fájl önmagában nem tartalmazza a Bootstrap és Font Awesome linkeket,
     azokat a dashboard.php-nak kell biztosítania, amikor ezt a HTML-t betölti. -->