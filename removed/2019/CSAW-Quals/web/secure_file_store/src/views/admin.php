<?php

require_once 'config.php';
require_once 'helpers.php';
require_once 'models.php';
require_once 'router.php';


function admin() {
    if (!isset($_SESSION['current_user'])) {
        return redirect("/admin/login");
    }

    $current_user = $_SESSION['current_user'];

    if (!($current_user->privs & Privilege::ADMIN)) {
        return forbidden();
    }

    $num_sessions = count(scandir(session_save_path())) - 2;

    require_once 'template/admin.php';
}
$router->registerRoute("/admin", "admin");


function admin_view_user(string $id) {
    if (!isset($_SESSION['current_user'])) {
        return forbidden();
    }

    $current_user = $_SESSION['current_user'];

    if (!($current_user->privs & Privilege::ADMIN)) {
        return forbidden();
    }

    $u = User::get($id);

    if (!$u) {
        return abort(404);
    }

    require_once 'template/admin_user.php';
}
$router->registerRoute("/admin/user/(\d+)", "admin_view_user");
