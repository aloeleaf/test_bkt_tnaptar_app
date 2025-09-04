<div class="container mt-5">
    <h1 class="mb-4 text-center mt-custom-top-margin">Jegyzőkönyv szerkesztése</h1>

    <!-- Az üzenetek megjelenítésére szolgáló div. A JavaScript fogja feltölteni. -->
    <div id="editMessage" class="alert d-none" role="alert"></div>

    <form id="editEntryForm" action="" method="POST">
        <!-- Az ID mező rejtett lesz, a JavaScript tölti fel -->
        <input type="hidden" name="id" id="editEntryId" value="">

        <div class="mb-3">
            <label for="editBirosag" class="form-label">Bíróság:</label>
            <input type="text" class="form-control" id="editBirosag" name="birosag" required>
        </div>
        <div class="mb-3">
            <label for="editTanacs" class="form-label">Tanács:</label>
            <input type="text" class="form-control" id="editTanacs" name="tanacs" required>
        </div>
        <div class="mb-3">
            <label for="editDate" class="form-label">Dátum:</label>
            <input type="date" class="form-control" id="editDate" name="date" required>
        </div>
        <div class="mb-3">
            <label for="editRooms" class="form-label">Tárgyaló:</label>
            <input type="text" class="form-control" id="editRooms" name="rooms">
        </div>
        <div class="mb-3">
            <label for="editSorszam" class="form-label">Sorszám:</label>
            <input type="text" class="form-control" id="editSorszam" name="sorszam">
        </div>
        <div class="mb-3">
            <label for="editTime" class="form-label">Idő:</label>
            <input type="time" class="form-control" id="editTime" name="time" required>
        </div>
        <div class="mb-3">
            <label for="editUgyszam" class="form-label">Ügyszám:</label>
            <input type="text" class="form-control" id="editUgyszam" name="ugyszam" required>
        </div>
        <div class="mb-3">
            <label for="editPersons" class="form-label">Résztvevők:</label>
            <textarea class="form-control" id="editPersons" name="persons" rows="3"></textarea>
        </div>
        <div class="mb-3">
            <label for="editLetszam" class="form-label">Id. (Létszám):</label>
            <input type="text" class="form-control" id="editLetszam" name="letszam">
        </div>
        <div class="mb-3">
            <label for="editUgyminoseg" class="form-label">Ügyminőség:</label>
            <textarea class="form-control" id="editUgyminoseg" name="ugyminoseg" rows="3"></textarea>
        </div>
        <div class="mb-3">
            <label for="editIntezkedes" class="form-label">Intézkedés:</label>
            <textarea class="form-control" id="editIntezkedes" name="intezkedes" rows="3"></textarea>
        </div>

        <button type="submit" class="btn btn-success">
            <i class="fa-solid fa-save"></i> Módosítások mentése
        </button>
        <button type="button" id="cancelEditBtn" class="btn btn-secondary ms-2">
            <i class="fa-solid fa-ban"></i> Mégse
        </button>
    </form>
</div>

<!-- Fontos: Ez a fájl önmagában nem tartalmazza a Bootstrap és Font Awesome linkeket,
     azokat a dashboard.php-nak kell biztosítania, amikor ezt a HTML-t betölti. -->
