<h2 class="mb-4 text-center">Új Tárgyalási Bejegyzés Rögzítése</h2>

<div class="card p-4 shadow-sm"> <h3 class="card-title mb-4  text-dark">Tárgyalási Bejegyzés Adatai</h3> <div id="formMessage" class="alert d-none" role="alert"></div>

    <form id="jegyzekForm">
        <input type="hidden" name="id" id="recordId" value="">
        
        <div class="row g-3 mb-4"> <div class="col-md-6">
                <label for="court_name" class="form-label">Bíróság</label>
                <select class="form-select form-select-sm" id="court_name" name="court_name" required title="A tárgyalás helyszínéül szolgáló bíróság neve.">
                    <option value="">Válasszon...</option>
                    <?php
                    // Ide illeszd be a PHP foreach ciklust a $courts tömbhöz
                    if (!empty($courts)) {
                        foreach ($courts as $court): ?>
                            <option value="<?php echo htmlspecialchars($court); ?>"><?php echo htmlspecialchars($court); ?></option>
                        <?php endforeach;
                    }
                    ?>
                </select>
            </div>
            
            <div class="col-md-6">
                <label for="council_name" class="form-label">Tanács</label>
                <select class="form-select form-select-sm" id="council_name" name="council_name" required title="A tárgyalást vezető bíró.">
                    <option value="">Válasszon...</option>
                    <?php
                    if (!empty($councils)) {
                        foreach ($councils as $council): ?>
                            <option value="<?php echo htmlspecialchars($council); ?>"><?php echo htmlspecialchars($council); ?></option>
                        <?php endforeach;
                    }
                    ?>
                </select>
            </div>
        </div>

        <div class="row g-3 mb-4">
            <div class="col-md-6">
                <label for="date" class="form-label">Dátum</label>
                <input type="date" class="form-control form-control-sm" id="date" name="date" required title="A tárgyalás dátuma.">
            </div>
            <div class="col-md-6">
                <label for="room_number" class="form-label">Tárgyaló</label>
                <select class="form-select form-select-sm" id="room_number" name="room_number" required title="A tárgyalás helyszínéül szolgáló tárgyalóterem száma vagy neve.">
                    <option value="">Válasszon...</option>
                    <?php
                        if (!empty($rooms)) {
                        foreach ($rooms as $room): ?>
                            <option value="<?php echo htmlspecialchars($room); ?>"><?php echo htmlspecialchars($room); ?></option>
                        <?php endforeach;
                    }
                    ?>
                </select>
            </div>
        </div>

        <hr class="my-4">

        <h3 class="card-title mb-3">Tárgyalási Részletek</h3>
        
        <div class="row g-3 align-items-end mb-4"> <div class="col-md-2">
                <label for="sorszam" class="form-label">Sorszám</label>
                <input type="text" class="form-control form-control-sm" id="sorszam" name="sorszam" value="1" title="A tárgyalás sorszáma az adott napon.">
            </div>
            <div class="col-md-4">
                <label for="ido" class="form-label">Idő</label>
                <input type="time" class="form-control form-control-sm" id="ido" name="ido" placeholder="Idő (pl. 13:00)" required title="A tárgyalás kezdési időpontja.">
            </div>
            <div class="col-md-6"> <label for="ugyszam" class="form-label">Ügyszám</label>
                <input type="text" class="form-control form-control-sm" id="ugyszam" name="ugyszam" placeholder="Ügyszám (pl. P.2023/2023)" required title="A tárgyalás ügyazonosító száma.">
            </div>
        </div>
        
        <div class="row g-3 mb-4">
    <div class="col-md-6"> <label for="resztvevok" class="form-label">Résztvevők</label>
        <select class="form-select form-select-sm" id="resztvevok" name="resztvevok" required title="A tárgyalásban résztvevő felek minősége.">
            <option value="">Válasszon...</option>
            <?php
            if (!empty($persons)) {
                foreach ($persons as $person):
                    ?>
                    <option value="<?php echo htmlspecialchars($person); ?>"><?php echo htmlspecialchars($person); ?></option>
                <?php endforeach;
            }
            ?>
        </select>
    </div>
    <div class="col-md-6"> <label for="letszam" class="form-label">Id.</label>
        <input type="text" class="form-control form-control-sm" id="letszam" name="letszam" placeholder="Id. (pl. 2)" title="Az idézettek szám.">
    </div>
</div>

        <div class="row g-3 mb-4"> <div class="col-md-6">
                <label for="ugyminoseg" class="form-label">Ügyminőség</label>
                <textarea class="form-control form-control-sm" id="ugyminoseg" name="ugyminoseg" rows="3" placeholder="Ügyminőség (pl. Sajtóhelyreigazítási per)" title="Az ügy minősítése vagy típusa."></textarea>
            </div>
            <div class="col-md-6">
                <label for="intezkedes" class="form-label">Intézkedés</label>
                <textarea class="form-control form-control-sm" id="intezkedes" name="intezkedes" rows="3" placeholder="Intézkedés" title="Az ügyben hozott intézkedés vagy döntés."></textarea>
            </div>
        </div>

        <div class="d-grid gap-2 col-6 mx-auto mt-4"> <button type="submit" class="btn btn-success btn-lg" id="jegyzekFormSubmitBtn">Rögzítés és Mentés</button>
            <button type="button" class="btn btn-secondary btn-lg" id="cancelEditBtn">Mégse</button>
        </div>
    </form>
</div>