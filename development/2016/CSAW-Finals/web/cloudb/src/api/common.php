<?php
	session_start();
	require_once '../db.php';

	function jsonp($callback, $data) {
		// Encode $data into a JSONP response will callback $callback
		return $callback . "(" . json_encode($data) . ");";
	}
	
	function error_msg($msg) {
		// Die with the given error message
		die(json_encode(array("status"		=> "error",
		                      "message"		=> $msg)));
	}
	
	function verify_auth($id) {
		// Verify the user is who they say they are.
		// Returns true if the provided ID matches what is stored in the session, kills the script otherwise.
		
		if (isset($id) && intval($_SESSION['id']) === intval($id)) {
			return true;
		}
		
		http_response_code(403);
		error_msg("Invalid user ID passed or not logged in");
	}
	
	
	$req_method = $_SERVER['REQUEST_METHOD'];
	
	if ($req_method == "GET") {
		if (!isset($_GET['callback']) || $_GET['callback'] == "") {
			die("JSONP endpoint requires a callback!");
		}
	
		header("Content-Type: application/javascript");
	}
?>