<?php
class Database {
    private $pdo;

    public function __construct($config) {
        $this->pdo = new PDO(
            "mysql:host={$config['db_host']};dbname={$config['db_name']};charset=utf8mb4",
            $config['db_user'],
            $config['db_pass']
        );
        $this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        date_default_timezone_set('Europe/Budapest');
    }

    public function getPdo() {
        return $this->pdo;
    }
}
