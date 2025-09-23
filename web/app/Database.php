<?php
// filepath: \srv\containers\test_bkt_tnaptar_app\web\app\Database.php

class Database
{
    private $pdo;

    public function __construct($config)
    {
        // Build PostgreSQL DSN
        $dsn = 'pgsql:host=' . $config['host'] . ';port=' . ($config['port'] ?? '5432') . ';dbname=' . $config['dbname'];

        $options = [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ];

        try {
            $this->pdo = new PDO($dsn, $config['user'], $config['password'], $options);
        } catch (PDOException $e) {
            die('Adatbázis kapcsolódási hiba: ' . $e->getMessage());
        }
    }

    public function getPdo()
    {
        return $this->pdo;
    }
}
?>