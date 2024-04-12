<?php
    class userdata {
        // database connection and table name
        private $conn;
        private $table_name = "usersdata";

        // object properties
        public $id;
        public $name;
        public $xmlcontent;
        // In xmlcontent
        public $Login;
        public $Motdepasse;

        // constructor with $db as database connection
        public function __construct($db) {
            $this->conn = $db;
        }

        // connect with username and password
        public function connect() {
            // select a user
            $query = "SELECT * FROM ". $this->table_name ." WHERE ExtractValue(xmlcontent, 'utilisateur/Login') = :Login AND
                      ExtractValue(xmlcontent, 'utilisateur/Motdepasse') = :Motdepasse";
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            // posted values
            $this->Login = htmlspecialchars(strip_tags($this->Login));
            $this->Motdepasse = htmlspecialchars(strip_tags($this->Motdepasse));
            // bind values
            $stmt->bindParam(":Login", $this->Login);
            $stmt->bindParam(":Motdepasse", $this->Motdepasse);
            // execute query
            $stmt->execute();
            return $stmt;
        }

        // create userdata
        public function create() {
            // query to insert record
            $query = "INSERT IGNORE INTO ". $this->table_name ." SET name = :name, xmlcontent = :xmlcontent";

            // prepare query
            $stmt = $this->conn->prepare($query);

            // posted values
            $this->name = htmlspecialchars(strip_tags($this->name));
            $this->xmlcontent = $this->xmlcontent; //htmlspecialchars(strip_tags($this->xmlcontent));

            // bind values
            $stmt->bindParam(":name", $this->name);
            $stmt->bindParam(":xmlcontent", $this->xmlcontent);

            // execute query
            if($stmt->execute()) {
                return true;
            } else {
                echo "<pre>";
                    print_r($stmt->errorInfo());
                echo "</pre>";

                return false;
            }
        }

        // read all userdata
        function readAll() {
            // select all query
            $query = "SELECT * FROM ". $this->table_name ." WHERE id <> 1 ORDER BY id ASC LIMIT 5000";
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            // execute query
            $stmt->execute();
            return $stmt;
        }

        // used when filling up the update userdata form
        public function readOne() {
            // query to read single record
            $query = "SELECT id, name, xmlcontent FROM ". $this->table_name ." WHERE id = ? LIMIT 0,1";
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            // bind id of userdata to be updated
            $stmt->bindParam(1, $this->id);
            // execute query
            $stmt->execute();
            // get retrieved row
            $row = $stmt->fetch(PDO::FETCH_ASSOC);
            // set values to object properties
            $this->id = $row['id'];
            $this->name = $row['name'];
            $this->xmlcontent = $row['xmlcontent'];
        }

        // update the userdata
        public function update() {
            // update query
            $query = "UPDATE ". $this->table_name ." SET name = :name, xmlcontent = :xmlcontent WHERE id = :id";
            // prepare query statement
            $stmt = $this->conn->prepare($query);
            // posted values
            $this->name = htmlspecialchars(strip_tags($this->name));
            $this->xmlcontent = $this->xmlcontent; //htmlspecialchars(strip_tags($this->xmlcontent));
            // bind new values
            $stmt->bindParam(':name', $this->name);
            $stmt->bindParam(':xmlcontent', $this->xmlcontent);
            $stmt->bindParam(':id', $this->id);
            // execute the query
            if($stmt->execute()) {
                return true;
            }else{
                return false;
            }
        }

        // delete the userdata
        public function delete() {
            // delete query
            $query = "DELETE FROM ". $this->table_name ." WHERE id = ?";
            // prepare query
            $stmt = $this->conn->prepare($query);
            // bind id of record to delete
            $stmt->bindParam(1, $this->id);
            // execute query
            if($stmt->execute()) {
                return true;
            }else{
                return false;
            }
        }
    }
?>
