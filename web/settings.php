<?php
session_start();
require_once __DIR__ . '/app/Auth.php';

// Check if user has settings permissions (Admin only)
if (!Auth::canViewSettings()) {
    echo '<div class="alert alert-danger">Nincs jogosultságod a beállítások megtekintéséhez!</div>';
    exit;
}
?>

<h1 class="mb-4 text-center mt-custom-top-margin">Adminisztrációs felület</h1>    
<div class="container mt-5">
    

    <div class="row">
        <div class="col-12 col-md-6 mb-4">
            <div class="card h-100">
                <div class="card-header">
                    <h3 class="mb-0">Bíróság kezelése</h3>
                </div>
                <div class="card-body">
                    <!-- Add new -->
                    <div class="input-group mb-3">
                        <input type="text" id="birosag-input" class="form-control" placeholder="Új bíróság neve">
                        <button class="btn btn-success" type="button" data-add-category="birosag">
                            <i class="fas fa-plus"></i> Hozzáad
                        </button>
                    </div>
                    
                    <!-- Edit/Delete existing -->
                    <div class="input-group mb-3">
                        <select id="birosag-select" class="form-select">
                            <option value="">Válasszon bíróságot...</option>
                        </select>
                        <button class="btn btn-warning" type="button" data-edit-category="birosag">
                            <i class="fas fa-edit"></i> Szerkeszt
                        </button>
                        <button class="btn btn-danger" type="button" data-delete-category="birosag">
                            <i class="fas fa-trash"></i> Töröl
                        </button>
                    </div>
                    
                    <div id="birosag-message" class="alert d-none"></div>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-6 mb-4">
            <div class="card h-100">
                <div class="card-header">
                    <h3 class="mb-0">Tanács kezelése</h3>
                </div>
                <div class="card-body">
                    <!-- Add new -->
                    <div class="input-group mb-3">
                        <input type="text" id="tanacs-input" class="form-control" placeholder="Új tanács neve">
                        <button class="btn btn-success" type="button" data-add-category="tanacs">
                            <i class="fas fa-plus"></i> Hozzáad
                        </button>
                    </div>
                    
                    <!-- Edit/Delete existing -->
                    <div class="input-group mb-3">
                        <select id="tanacs-select" class="form-select">
                            <option value="">Válasszon tanácsot...</option>
                        </select>
                        <button class="btn btn-warning" type="button" data-edit-category="tanacs">
                            <i class="fas fa-edit"></i> Szerkeszt
                        </button>
                        <button class="btn btn-danger" type="button" data-delete-category="tanacs">
                            <i class="fas fa-trash"></i> Töröl
                        </button>
                    </div>
                    
                    <div id="tanacs-message" class="alert d-none"></div>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-6 mb-4">
            <div class="card h-100">
                <div class="card-header">
                    <h3 class="mb-0">Tárgyaló kezelése</h3>
                </div>
                <div class="card-body">
                    <!-- Add new -->
                    <div class="input-group mb-3">
                        <input type="text" id="room-input" class="form-control" placeholder="Új tárgyaló neve">
                        <button class="btn btn-success" type="button" data-add-category="room">
                            <i class="fas fa-plus"></i> Hozzáad
                        </button>
                    </div>
                    
                    <!-- Edit/Delete existing -->
                    <div class="input-group mb-3">
                        <select id="room-select" class="form-select">
                            <option value="">Válasszon tárgyalót...</option>
                        </select>
                        <button class="btn btn-warning" type="button" data-edit-category="room">
                            <i class="fas fa-edit"></i> Szerkeszt
                        </button>
                        <button class="btn btn-danger" type="button" data-delete-category="room">
                            <i class="fas fa-trash"></i> Töröl
                        </button>
                    </div>
                    
                    <div id="room-message" class="alert d-none"></div>
                </div>
            </div>
        </div>

        <div class="col-12 col-md-6 mb-4">
            <div class="card h-100">
                <div class="card-header">
                    <h3 class="mb-0">Résztvevők kezelése</h3>
                </div>
                <div class="card-body">
                    <!-- Add new -->
                    <div class="input-group mb-3">
                        <input type="text" id="resztvevok-input" class="form-control" placeholder="Új résztvevő neve">
                        <button class="btn btn-success" type="button" data-add-category="resztvevok">
                            <i class="fas fa-plus"></i> Hozzáad
                        </button>
                    </div>
                    
                    <!-- Edit/Delete existing -->
                    <div class="input-group mb-3">
                        <select id="resztvevok-select" class="form-select">
                            <option value="">Válasszon résztvevőt...</option>
                        </select>
                        <button class="btn btn-warning" type="button" data-edit-category="resztvevok">
                            <i class="fas fa-edit"></i> Szerkeszt
                        </button>
                        <button class="btn btn-danger" type="button" data-delete-category="resztvevok">
                            <i class="fas fa-trash"></i> Töröl
                        </button>
                    </div>
                    
                    <div id="resztvevok-message" class="alert d-none"></div>
                </div>
            </div>
        </div>
    </div>
</div>
