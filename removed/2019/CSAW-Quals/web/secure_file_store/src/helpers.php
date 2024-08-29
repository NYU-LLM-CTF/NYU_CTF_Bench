<?php

require_once 'config.php';

function redirect(string $loc) {
    $url = $_SERVER['SCRIPT_NAME'] . "?" . $loc;
    header("Location: $url");
    return true;
}

function abort(int $status) {
    http_response_code($status);
    return true;
}

function error(string $msg) {
    echo json_encode(array("status" => "error", "error" => $msg));
    return abort(409);
}

function forbidden() {
    return error("You are not authorized to perform this action");
}

function ok() {
    echo json_encode(array("status" => "ok"));
    return true;
}

function success($data) {
    echo json_encode(array("status" => "ok", "data" => $data));
    return true;
}

function require_params(array $params) {
    foreach ($params as $param) {
        if (!isset($_POST[$param])) {
            return false;
        }
    }
    return true;
}

function realrealpath(string $filename) {
    // realpath doesn't work on files that don't exist
    // https://tomnomnom.com/posts/realish-paths-without-realpath
    $filename = str_replace('//', '/', $filename);
    $parts = explode('/', $filename);
    $out = array();
    foreach ($parts as $part){
        if ($part == '.') continue;
        if ($part == '..') {
            array_pop($out);
            continue;
        }
        $out[] = $part;
    }
    return implode('/', $out);
}
    
function resolve_user_path(string $upath)
{
    $basePath = BASE_PATH . "/" . $_SESSION['current_user']->id . "/";
    $fullpath = realrealpath($basePath . $upath);
    if (substr($fullpath, 0, strlen($basePath)) !== $basePath) {
        return false;
    }

    return $fullpath;
}

