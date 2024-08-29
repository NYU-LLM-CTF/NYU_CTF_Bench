<?php
session_start(); 
?>
<!DOCTYPE html>
<html>
<head>
  <link rel="stylesheet" href="style.css">
</head>

<body>
    <?php
        if (isset($_FILES['doc']) && ($_FILES['doc']['error'] == UPLOAD_ERR_OK)) {
            $isValid = false;
            $filename = $_FILES['doc']['name'];
            $ext = pathinfo($filename, PATHINFO_EXTENSION);
            if( $ext !== 'xml'){
                $isValid = false;
            }
            elseif( strpos(htmlentities(file_get_contents($_FILES['doc']['tmp_name'])),"file") !== false) {
                $isValid = false;
            }
            elseif( strpos(htmlentities(file_get_contents($_FILES['doc']['tmp_name'])),"SYSTEM") !== false) {
                $isValid = false;
            }
            elseif( strpos(htmlentities(file_get_contents($_FILES['doc']['tmp_name'])),"PHP") !== false) {
                $isValid = false;
            }
            elseif( strpos(htmlentities(file_get_contents($_FILES['doc']['tmp_name'])),"php") !== false) {
                $isValid = false;
            }
            elseif( strpos(htmlentities(file_get_contents($_FILES['doc']['tmp_name'])),"ENTITY") !== false) {
                $isValid = false;
            }
            elseif( strpos(htmlentities(file_get_contents($_FILES['doc']['tmp_name'])),"xxe") !== false) {
                $isValid = false;
            }
            elseif( strpos(htmlentities(file_get_contents($_FILES['doc']['tmp_name'])),"XXE") !== false) {
                $isValid = false;
            }
            else{
                $isValid = true;
            }

            if($isValid){
                libxml_disable_entity_loader(false);
                $new_xml = simplexml_load_file($_FILES['doc']['tmp_name'], null, LIBXML_NOENT); 
                $new_users = $new_xml->user;
                $text = "";
                foreach ($new_users as $user){
                    if ($user->name->__toString()){
                        $text .= "<p>Name: " . substr($user->name->__toString(),0,20) . "</p>\n";
                    }
                    if ($user->email->__toString()){
                        $text .= "<p>Email: " . substr($user->email->__toString(),0,20). "</p>\n";
                    }
                    if ($user->group->__toString()){
                        $text .= "<p>Group: " . substr($user->group->__toString(),0,20) . "</p>\n";
                    }
                    if ($user->intro->__toString()){
                        $text .= "<p>Intro: " . $user->intro->__toString() . "</p><br>\n";
                    }
                    $text .= "<br>\n";
                }
                printf('<b>%s</b>', "Successfully uploaded user profiles.");
            }
            else{
                printf('<b>%s</b>', "WAF blocked uploaded file. Please try again");
            }
        }
    ?>
    <div class="topnav">
    <a href="index.php">Home</a>
    <a href="user.php">User</a>
    <a class="active" href="upload.php">Upload</a>
    <a href="about.php">About</a>
    </div>

    <h1> Upload new users to the system </h1>
    <p1> You can check out the format example <a href="sample.xml">here</a></p1><br>
    <br>

    <form action="" method="POST" enctype="multipart/form-data">
        <input type="file" name="doc" />
        <input type="submit" name="submit" value="Upload">
    </form>

    <div id="newuser"></div>
    <?php printf($text); ?>
</body>
</html>