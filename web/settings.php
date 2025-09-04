<!DOCTYPE html>
<html lang="hu">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kategóriák kezelése</title>
    <link href="assets/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/fontawesome/css/all.min.css" rel="stylesheet">
    <link href="assets/css/settings.css" rel="stylesheet"> </head>
    <meta name="author" content="Martínez Luis Dávid & Papp Ágoston" />
<body>
<div class="container mt-5">
    <h1 class="text-center mb-5">Adminisztrációs felület</h1>

    <div class="row">
        <div class="col-12 col-md-6 mb-4"> <div class="category-section h-100">
                <h2>Bíróság hozzáadása</h2>
                <div class="input-group mb-3">
                    <input type="text" id="birosagInput" class="form-control" placeholder="Új bíróság neve" aria-label="Új bíróság neve">
                    <div class="input-group-append">
                        <button class="btn btn-primary" type="button" onclick="addItem('birosag')">Hozzáad <i class="fas fa-plus"></i></button>
                    </div>
                </div>
                <ul id="birosagList">
                    </ul>
            </div>
        </div>

        <div class="col-12 col-md-6 mb-4">
            <div class="category-section h-100">
                <h2>Tanács (bíró) hozzáadása</h2>
                <div class="input-group mb-3">
                    <input type="text" id="tanacsInput" class="form-control" placeholder="Új tanács (bíró) neve" aria-label="Új tanács (bíró) neve">
                    <div class="input-group-append">
                        <button class="btn btn-primary" type="button" onclick="addItem('tanacs')">Hozzáad <i class="fas fa-plus"></i></button>
                    </div>
                </div>
                <ul id="tanacsList">
                    </ul>
            </div>
        </div>

        <div class="col-12 col-md-6 mb-4">
            <div class="category-section h-100">
                <h2>Tárgyaló hozzáadása</h2>
                <div class="input-group mb-3">
                    <input type="text" id="roomInput" class="form-control" placeholder="Új tárgyaló neve" aria-label="Új tárgyaló neve">
                    <div class="input-group-append">
                        <button class="btn btn-primary" type="button" onclick="addItem('room')">Hozzáad <i class="fas fa-plus"></i></button>
                    </div>
                </div>
                <ul id="roomList">
                    </ul>
            </div>
        </div>

        <div class="col-12 col-md-6 mb-4">
            <div class="category-section h-100">
                <h2>Résztvevők hozzáadása</h2>
                <div class="input-group mb-3">
                    <input type="text" id="resztvevokInput" class="form-control" placeholder="Új résztvevő(k) neve" aria-label="Új résztvevők neve">
                    <div class="input-group-append">
                        <button class="btn btn-primary" type="button" onclick="addItem('resztvevok')">Hozzáad <i class="fas fa-plus"></i></button>
                    </div>
                </div>
                <ul id="resztvevokList">
                    </ul>
            </div>
        </div>
    </div> </div>

<script src="assets/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="assets/js/admin_functions.js"></script> </body>
</html>