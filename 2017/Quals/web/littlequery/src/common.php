<?php
    session_start();
    function signed_in() {
        return isset($_SESSION['id']);
    }
    
    function require_login() {
        if (!signed_in()) {
            header("Location: login.php");
            die();
        }
    }
    
    function tmpdir() {
        $tempfile=tempnam(sys_get_temp_dir(), 'littlequery');
        if (file_exists($tempfile)) { unlink($tempfile); }
        mkdir($tempfile);
        if (is_dir($tempfile)) { return $tempfile; }
    }
    
    define('NODE_MODULES', "/opt/funtimejs/node_modules");
?>
