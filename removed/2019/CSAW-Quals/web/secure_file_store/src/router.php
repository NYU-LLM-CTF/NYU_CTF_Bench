<?php

require_once 'helpers.php';

class Router {
    private $routes = array();

    function registerRoute(string $route, string $callback) {
        $this->routes[$route] = $callback;
    }

    function handleRequest(string $query) {
        $handled = false;

        if ($query === "") {
            $query = "/";
        }

        foreach ($this->routes as $route => $handler) {
            $regex = "/^" . str_replace("/", "\/", $route) . "$/";
            if (preg_match($regex, $query, $vars)) {
                array_shift($vars);
                call_user_func_array($handler, $vars);
                $handled = true;
                break;
            }
        }

        if (!$handled) {
            abort(404);
        }
    }
}

$router = new Router;
