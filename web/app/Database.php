<?php
// app/Database.php

class Database
{
    private $pdo;

    public function __construct($config)
    {
        // JAVÍTVA: DSN kiegészítve a charset=utf8mb4 beállítással
        $dsn = 'mysql:host=' . $config['host'] . ';dbname=' . $config['dbname'] . ';charset=utf8mb4';
        
        // ÚJ: PDO opciók a jobb hibakezelésért és alapértelmezett adatformátumért
        $options = [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION, // Kritikus a try-catch blokkok működéséhez
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,       // Alapértelmezetten asszociatív tömböt ad vissza
            PDO::ATTR_EMULATE_PREPARES   => false,                  // Valódi prepared statement-eket használ, növeli a biztonságot
        ];

        try {
            $this->pdo = new PDO($dsn, $config['user'], $config['password'], $options);
        } catch (PDOException $e) {
            // Hiba esetén leállítjuk a futást és kiírjuk a hibát
            // Éles környezetben ezt egy log fájlba kellene írni, nem a képernyőre.
            die('Adatbázis kapcsolódási hiba: ' . $e->getMessage());
        }
    }

    public function getPdo()
    {
        return $this->pdo;
    }
}
?>