<?php

require_once 'db.php';

abstract class Privilege {
    const FILE_READ = 1 << 0;
    const FILE_WRITE = 1 << 1;
    const FILE_LIST = 1 << 2;
    const ADMIN = 1 << 3;
}

class User extends DBObject {
    public $username;
    public $password;
    public $privs = Privilege::FILE_READ | Privilege::FILE_WRITE;

    public static function getByName(string $username) {
        return DB::getObjectByProp(get_called_class(), "username", $username);
    }
}

