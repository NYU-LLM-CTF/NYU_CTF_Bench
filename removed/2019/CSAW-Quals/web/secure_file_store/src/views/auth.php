<?php

require_once 'config.php';
require_once 'helpers.php';
require_once 'models.php';
require_once 'router.php';


function api_register() {
    if (isset($_SESSION['current_user'])) {
        return error("Already logged in");
    }

    if (!require_params(array("username", "password"))) {
        return error("Missing params");
    }

    if (User::getByName($_POST['username'])) {
        return error("Username already in use");
    }

    $u = new User;
    $u->username = $_POST['username'];
    $u->password = password_hash($_POST['password'], PASSWORD_DEFAULT);

    DB::save($u);
    $_SESSION['current_user'] = $u;

    return ok();
}
$router->registerRoute("/api/v1/register", "api_register");


function api_login() {
    if (isset($_SESSION['current_user'])) {
        return error("Already logged in");
    }

    if (!require_params(array("username", "password"))) {
        return error("Missing params");
    }

    $u = User::getByName($_POST['username']);
    if (!$u || !password_verify($_POST['password'], $u->password)) {
        return error("Invalid username or password");
    }

    $_SESSION['current_user'] = $u;

    return ok();
}
$router->registerRoute("/api/v1/login", "api_login");


function fe_register() {
    if ($_SERVER['REQUEST_METHOD'] === "GET") {
        require_once 'template/register.php';
        die();
    }

    if (!require_params(array("username", "password"))) {
        return abort(400);
    }

    if (User::getByName($_POST['username'])) {
        $err = "Username already in use";
        require_once 'template/register.php';
        die();
    }

    $u = new User;
    $u->username = $_POST['username'];
    $u->password = password_hash($_POST['password'], PASSWORD_DEFAULT);

    DB::save($u);
    $_SESSION['current_user'] = $u;

    return redirect("/");
}
$router->registerRoute("/register", "fe_register");


function fe_login() {
    if ($_SERVER['REQUEST_METHOD'] === "GET") {
        require_once 'template/login.php';
        die();
    }

    if (!require_params(array("username", "password"))) {
        return abort(400);
    }

    $u = User::getByName($_POST['username']);
    if (!$u || !password_verify($_POST['password'], $u->password)) {
        $err = "Invalid username or password";
        require_once 'template/login.php';
        die();
    }

    $_SESSION['current_user'] = $u;

    return redirect("/");
}
$router->registerRoute("/login", "fe_login");


function logout() {
    if (!isset($_SESSION['current_user'])) {
        return abort(403);
    }

    session_destroy();

    return redirect("/login");
}
