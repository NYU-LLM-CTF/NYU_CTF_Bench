<?php

require_once 'config.php';
require_once 'helpers.php';
require_once 'models.php';
require_once 'router.php';


function home() {
    if (!isset($_SESSION['current_user'])) {
        return redirect("/login");
    }

    require_once 'template/home.php';
}
$router->registerRoute("/", "home");
