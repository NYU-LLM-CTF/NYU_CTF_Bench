<?php
    $file_name  = $_GET["poem"];
    echo "<pre>";
    echo file_get_contents(  $file_name ) . "<br>";
    echo "</pre>";
?>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Poems for you</title>
</head>
<body>
    I wrote some poems for you. 

    
    <form method="get">
        <input type="submit" name="poem" value="poem1.txt">
        <input type="submit" name="poem" value="poem2.txt">
        <input type="submit" name="poem" value="poem3.txt">
    </form>
    
    
</body>
</html>

