<?php
class DB {

    private static function initDBConnnection() {
        $SQL_HOST = "localhost";
        $SQL_PORT = 3306;
        $SQL_USER = "sfs";
        $SQL_PASS = "sfs";
        $SQL_DB = "sfs";

        try {
            $con = new PDO("mysql:host=$SQL_HOST;port=$SQL_PORT;dbname=$SQL_DB", $SQL_USER, $SQL_PASS);

            return $con;
        } catch (PDOException $e) {
            die("Error establishing database connection: $e");
        }
    }

    public static function getObjectByProp(string $cls, string $prop, $val) {
        $con = DB::initDBConnnection();
        
        $query = "SELECT * FROM $cls WHERE $prop = :$prop";
        $stmt = $con->prepare($query);
        $stmt->bindValue(":$prop", $val);
        $stmt->setFetchMode(PDO::FETCH_CLASS, $cls);
        $stmt->execute();

        return $stmt->fetch();
    }

    public static function getObjectById(string $cls, int $id) {
        return DB::getObjectByProp($cls, "id", $id);
    }

    public static function getAllObjects(string $cls) {
        $con = DB::initDBConnnection();
        
        $query = "SELECT * FROM $cls";
        $stmt = $con->prepare($query);
        $stmt->setFetchMode(PDO::FETCH_CLASS, $cls);
        $stmt->execute();

        return $stmt->fetchAll();
    }

    public static function save($o) {
        $cls = get_class($o);
        $cls_props = get_class_vars($cls);

        $safe_props = array();
        foreach (array_keys($cls_props) as $prop) {
            $safe_props[preg_replace("/[^a-zA-Z0-9_]+/", "", $prop)] = get_object_vars($o)[$prop];
        }

        $con = DB::initDBConnnection();

        if ($o->id === NULL) {
            $query = "INSERT INTO $cls ";
            $query .= " (" . implode(", ", array_keys($safe_props)) . ") ";
            $query .= " VALUES ( :";
            $query .= implode(", :", array_keys($safe_props));
            $query .= ")";
        } else {
            $query = "UPDATE $cls SET ";

            $updates = array();
            foreach (array_keys($safe_props) as $prop) {
                $updates[] = $prop . '=:' . $prop;
            }

            $query .= implode(', ', $updates);
        }

        $stmt = $con->prepare($query);

        foreach ($safe_props as $key => $val) {
            $stmt->bindValue(':' . $key, $val);
        }

        $stmt->execute();

        if ($o->id === NULL) {
            $o->id = intval($con->lastInsertId());
        }
    }
}

class DBObject {
    public $id = NULL;

    public static function get(int $id) {
        return DB::getObjectById(get_called_class(), $id);
    }

    public static function all() {
        return DB::getAllObjects(get_called_class());
    }
}
