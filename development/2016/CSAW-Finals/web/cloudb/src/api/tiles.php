<?php
	require 'common.php';
	
	if ($req_method == "GET") {
		// Get tiles
		
		$s = $db->prepare('SELECT url, template FROM tile WHERE uid=? ORDER BY position');
		$s->execute(array($_SESSION['id']));
		$tiles = $s->fetchAll(PDO::FETCH_ASSOC);
		
		echo jsonp($_GET['callback'], array("tiles" => $tiles));
		
	} else if ($req_method == "POST") {
		// Update tiles
		
		verify_auth($_POST['uid']);
		
		$url = $_POST['url'];
		$uid = intval($_SESSION['id']);
		
		if ($_POST['action'] == "add") {
			
			$parsed = parse_url($url);
			
			// Only allow tiles on our website
			if ($parsed["scheme"] != "http" || $parsed["host"] != "web.chal.csaw.io") {
				http_response_code(400);
				error_msg("Tiles can only load data from this domain.");
			}
			
			// Make sure template is valid
			if (!isset($_POST['template']) || !ctype_alnum($_POST['template'])) {
				http_response_code(400);
				error_msg("Template must be a valid template filename");
			}
			
			// TODO: Add ability to move tiles around
			$s = $db->prepare('SELECT IFNULL(MAX(position),0)+1 FROM tile WHERE uid=?');
			$s->execute(array($uid));
			$position = $s->fetchColumn();
			
			$s = $db->prepare('INSERT INTO tile (uid, url, template, position) VALUES (?, ?, ?, ?)');
			$s->execute(array($uid, $url, $_POST['template'], $position));
			
		} else if ($_POST['action'] == "remove") {
			// Remove from DB
			
			$s = $db->prepare('DELETE FROM tile WHERE uid=? AND url=?');
			$s->execute(array($uid, $url));
			
		} else {
			http_response_code(400);
			error_msg("Invalid action.");
		}
	} else {
		http_response_code(405);
	}
?>
