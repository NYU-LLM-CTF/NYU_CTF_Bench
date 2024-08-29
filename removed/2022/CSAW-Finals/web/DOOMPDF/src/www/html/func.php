<?php 
	include("db.php");
	include_once __DIR__ . '/../config/bootstrap.php';

    use League\CommonMark\CommonMarkConverter;

    $converter = new CommonMarkConverter(['html_input' => 'escape', 'allow_unsafe_links' => false]);

	if (isset($_GET['edid'])){

	    $id = $_GET['edid'];

		$statement = $db->prepare('SELECT * FROM task where id = ?');
		$statement->bindValue(1, $id);
	    $result = $statement->execute();

	    if(sqlite_num_rows($result) == 1){
	        $row = $result->fetchArray(SQLITE3_ASSOC);
	        $title = $row['title'];

	        $_SESSION['message'] = 'Edit Task';
	        $_SESSION['message_type'] = 'info';
	    }
	}


?>