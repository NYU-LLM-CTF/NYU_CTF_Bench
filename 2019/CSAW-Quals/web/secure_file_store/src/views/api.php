<?php

require_once 'config.php';
require_once 'helpers.php';
require_once 'models.php';
require_once 'router.php';


function read_user_file() {
    if (!isset($_SESSION['current_user'])) {
        return forbidden();
    }

    $current_user = $_SESSION['current_user'];

    if (!($current_user->privs & Privilege::FILE_READ)) {
        return forbidden();
    }

    if (!require_params(array("path"))) {
        return error("Missing params");
    }

    $path = resolve_user_path($_POST['path']);

    if ($path === false) {
        return error("Path is not valid");
    }

    if (!file_exists($path)) {
        return error("File does not exist");
    }

    header('Content-Type: application/octet-stream');
    header('Content-Length: ' . filesize($path));
    readfile($path);
}
$router->registerRoute("/api/v1/file/read", "read_user_file");


function edit_user_file() {
    if (!isset($_SESSION['current_user'])) {
        return forbidden();
    }

    $current_user = $_SESSION['current_user'];

    if (!($current_user->privs & Privilege::FILE_WRITE)) {
        return forbidden();
    }

    if (!require_params(array("path", "content"))) {
        return error("Missing params");
    }

    if (strlen($_POST['content']) > 1*1024*1024) {
        return abort(413);
    }

    $path = resolve_user_path($_POST['path']);

    if ($path === false) {
        return error("Path is not valid");
    }

    if (!file_exists(dirname($path))) {
        if (!mkdir(dirname($path), 0777, true)) {
            return error("Could not create parent folder");
        }
    }

    if (file_put_contents($path, $_POST['content']) === false) {
        return error("Could not edit file");
    }

    return ok();
}
$router->registerRoute("/api/v1/file/edit", "edit_user_file");


function create_user_symlink() {
    if (!isset($_SESSION['current_user'])) {
        return forbidden();
    }

    $current_user = $_SESSION['current_user'];

    if (!($current_user->privs & Privilege::FILE_WRITE)) {
        return forbidden();
    }

    if (!require_params(array("path", "target"))) {
        return error("Missing params");
    }

    $path = resolve_user_path($_POST['path']);

    if ($path === false) {
        return error("Path is not valid");
    }

    $basePath = BASE_PATH . "/" . $_SESSION['current_user']->id . "/";
    $target = $basePath . $_POST['target'];

    if (!file_exists($target)) {
        return error("Target does not exist");
    }

    if (file_exists($path)) {
        unlink($path);
    }

    if (!symlink($target, $path)) {
        return error("Could not create symlink");
    }

    return ok();
}
$router->registerRoute("/api/v1/file/symlink", "create_user_symlink");


function delete_user_file() {
    if (!isset($_SESSION['current_user'])) {
        return forbidden();
    }

    $current_user = $_SESSION['current_user'];

    if (!($current_user->privs & Privilege::FILE_WRITE)) {
        return forbidden();
    }

    if (!require_params(array("path"))) {
        return error("Missing params");
    }

    $path = resolve_user_path($_POST['path']);

    if ($path === false) {
        return error("Path is not valid");
    }

    if (!unlink($path)) {
        return error("Could not delete file");
    }

    return ok();
}
$router->registerRoute("/api/v1/file/delete", "delete_user_file");


function list_user_files() {
    if (!isset($_SESSION['current_user'])) {
        return forbidden();
    }

    $current_user = $_SESSION['current_user'];

    if (!($current_user->privs & Privilege::FILE_LIST)) {
        return forbidden();
    }

    if (!require_params(array("path"))) {
        return error("Missing params");
    }

    $path = resolve_user_path($_POST['path']);

    if ($path === false) {
        return error("Path is not valid");
    }

    if (!is_dir($path)) {
        return error("Path is not a directory");
    }

    $files = scandir($path);

    if ($files === false) {
        return error("Could not list files");
    }

    return success($files);
}
$router->registerRoute("/api/v1/file/list", "list_user_files");
