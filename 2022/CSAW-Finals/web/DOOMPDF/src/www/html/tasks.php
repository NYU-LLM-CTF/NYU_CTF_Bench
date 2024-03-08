<?php

require('func.php');

include_once __DIR__ . '/../config/bootstrap.php';

if(isset($_POST['save_task'])){
    
    $title = urlencode($_POST['title']);

    if(isset($_POST['edid'])) { 
        $edid = $_POST['edid'];
        $statement = $db->prepare("UPDATE task SET title = :title WHERE id = :id");
        $statement->bindValue(':id', $edid);
        $statement->bindValue(':url', $title);
    }
    else {
        $statement = $db->prepare("INSERT INTO task(title, created_at) VALUES (:title, :created_at)");
        $statement->bindValue(':title', $title);
        $statement->bindValue(':created_at', date('Y-m-d H:i:s'));
    }

    $result = $statement->execute();

    if(!$result){
        die("Query failed");
    }
    
    $_SESSION['message'] = 'Task saved successfully';
    $_SESSION['message_type'] = 'success';

} elseif (isset($_GET['delid'])) {

        $id = $_GET['delid'];

        $query = "DELETE FROM task WHERE id = $id";
        $statement = $db->prepare("DELETE FROM task WHERE id = :id");
        $statement->bindValue(':id', $id);
        $result = $statement->execute();
        if(!$result){
            die("Query failed");
        }
        $_SESSION['message'] = 'Task removed successfully';
        $_SESSION['message_type'] = 'warning';

}

header('Location: index.php');

?>