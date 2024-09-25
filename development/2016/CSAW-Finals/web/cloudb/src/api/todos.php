<?php
	require 'common.php';
	
	if ($req_method == "GET") {
		// Get to-do list
		
		$s = $db->prepare('SELECT todo_id, todo, done FROM todo WHERE uid=?');
		$s->execute(array($_SESSION['id']));
		$todos = $s->fetchAll(PDO::FETCH_ASSOC);
		
		echo jsonp($_GET['callback'], array("todos" => $todos));
		
	} else if ($req_method == "POST") {
		// Update the to-do list
		
		verify_auth($_POST['uid']);
		
		if ($_POST['action'] == "add") {
			
			$s = $db->prepare('INSERT INTO todo (todo_id, uid, todo, done) VALUES (NULL, ?, ?, 0)');
			$s->execute(array(intval($_POST['uid']), $_POST['todo']));
			
		} else if ($_POST['action'] == "done") {
			
			$s = $db->prepare('UPDATE todo SET done=true WHERE uid=? AND todo_id=?');
			$s->execute(array(intval($_POST['uid']), intval($_POST['todo_id'])));
			
		} else {
			http_response_code(400);
			error_msg("Invalid action.");
		}
		
	} else {
		http_response_code(405);
	}
?>