<?php

namespace Lib;

class DB {

    use \Lib\Singleton;

    private $server;
    private $username;
    private $password;
    private $database;
    private $port;

    private $pdo;

    protected function __construct() {
        $this->getConnection();
        $port = $this->port? ';port='.$this->port: '';

        try {
            $this->pdo = new \PDO("mysql:host=$this->server;dbname={$this->database}{$port};charset=utf8mb4", $this->username, $this->password, [
                \PDO::ATTR_DEFAULT_FETCH_MODE => \PDO::FETCH_ASSOC
            ]);
        } catch (\PDOException $e) {
            echo $e->getMessage();
            exit();
        }
    }

    public function getPDO() {
        return $this->pdo;
    }

    public function getConnection($conn = null) {
        if ($conn == null || count(explode(",", $conn)) != 4)
            $conn = CONN_DEFAULT;

        $arr = explode(",", $conn);

        $this->server = $arr[0];
        $this->username = $arr[1];
        $this->password = $arr[2];
        $this->database = $arr[3];
        $this->port = $arr[4] ?? '';
    }

    public function query($sql) {
        $stmt = $this->pdo->prepare($sql);
       	if($stmt->execute()) return true;
        return false;
    }

    public function fetch_one($sql) {
        try {
            $stmt = $this->pdo->prepare($sql);
            $stmt->execute();

            $row = $stmt->fetch();
            return $row;
        } catch (\PDOException $e) {
            return false;
        }
    }
    
    public function fetch_one_fields($table, $field, $where=null){
    	$where = ($where==''||$where==null) ? "1=1" : $where;
    	$sql = "SELECT $field FROM $table WHERE $where";
    	$result = $this->fetch_one($sql);
    	$str = @$result[$field];
    	if($result && count(explode(",", $field))>1){
    		$a_field = explode(",", $field);
    		$a_result = [];
    		foreach ($a_field AS $item){
    			$a_result[] = @$result[$item];
    		}
    		$str = implode(", ", $a_result);
    	}
    	return $str;
    }

    public function fetch_all($sql) {
        try {
            $stmt = @$this->pdo->prepare($sql);
            @$stmt->execute();
            $rows = @$stmt->fetchAll();
            return $rows;
        } catch (\PDOException $e) {
            return false;
        }
    }
    
    public function fetch_array_field($table, $field, $where=null){
        $where = ($where==''||$where==null) ? "1=1" : $where;
        $sql = "SELECT $field FROM $table WHERE $where";
        $result = $this->fetch_all($sql);
        $a_field = [];
        foreach ($result AS $k=>$item){
            $a_field[] = $item[$field];
        }
        return $a_field;
    }

    public function check_exist($sql) {
        try {
            $stmt = @$this->pdo->prepare($sql);
            @$stmt->execute();
            $number = @$stmt->rowCount();
            if ($number > 0) return true;
            else return false;
        } catch (\PDOException $e) {
            return false;
        }
    }

    public function insert($table, $data) {
        try {
            if (count($data) == 0) return false;
            
            $sql = "INSERT INTO $table (" . implode(", ", array_keys($data)) . ") VALUES (:" . implode(", :", array_keys($data)) . ")";
            $stmt = $this->pdo->prepare($sql);
            if($stmt->execute($data)) return $this->pdo->lastInsertId();
            else return false;
        } catch (\PDOException $e) {
            return false;
        }
    }

    public function update($table, $data, $where) {
        try {
            if (count($data) == 0) return false;

            $values = [];
            foreach ($data AS $key => $item) {
                $values[] = $key . "=:" . $key;
            }

            $sql = "UPDATE $table SET " . implode(", ", $values);
            if ($where != "") $sql .= " WHERE " . $where;
            $stmt = $this->pdo->prepare($sql);
            if($stmt->execute($data)) return true;
            else return false;
        } catch (\PDOException $e) {
            return false;
        }
    }

    public function count_rows($sql) {
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute();
        return $stmt->rowCount();
    }

    public function count_item($table, $where=null){
    	if($where!='' && $where!=null) $where = " AND " . $where;
    	$result = $this->fetch_one("SELECT COUNT(1) AS number FROM $table a WHERE 1=1 $where");
    	return intval(@$result['number']);
    }
    
    public function count_custom($sql){
        $result = $this->fetch_one($sql);
        return intval(@$result['number']);
    }
    
    public function close() {
        $this->pdo = NULL;
    }
}