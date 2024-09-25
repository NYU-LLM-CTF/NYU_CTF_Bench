<?php
	require 'common.php';
	
	if ($req_method == "GET") {
		// Get note
		
		$s = $db->prepare('SELECT note FROM note WHERE uid=?');
		$s->execute(array($_SESSION['id']));
		$note = $s->fetch(PDO::FETCH_COLUMN, 0);
		
		if (!$note) {
			$note = "";
		}
		
		echo jsonp($_GET['callback'], array("note" => $note));
		
	} else if ($req_method == "POST") {
		// Update note
		
		verify_auth($_POST['uid']);
		
		$note = $_POST['note'];
		
		$s = $db->prepare('INSERT INTO note (uid, note) VALUES (?, ?) ON DUPLICATE KEY UPDATE note=?');
		$s->execute(array(intval($_POST['uid']), $note, $note));
	} else {
		http_response_code(405);
	}
?>