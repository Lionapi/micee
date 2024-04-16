<?php
    class Database {
        // database credentials
        private $host = "192.168.1.182"; // "127.0.0.1";
        private $db_name = "micee";
        private $port = "3309";
        private $username = "Franck-Lionel";
        private $password = "Franck-Lionel007";
        public $conn;

        // database connection
        public function getConnection() {
            $this->conn = null;

            try {
                $this->conn = new PDO("mysql:host=" . $this->host . ";dbname=" . $this->db_name . ";port=" . $this->port, $this->username, $this->password);
            } catch(PDOException $exception) {
                echo "Connection error: " . $exception->getMessage();
            }

            return $this->conn;
        }
    }
?>