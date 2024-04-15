<?php
require_once 'config.php';
require_once 'helpers.php';
require_once 'models.php';
require_once 'router.php';

session_save_path("/tmp"); // Having weird issues leaving this default... oh well
session_start();

require_once 'views/admin.php';
require_once 'views/api.php';
require_once 'views/auth.php';
require_once 'views/frontend.php';

$router->handleRequest($_SERVER['QUERY_STRING']);
