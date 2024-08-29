<?php

    if (php_sapi_name() !== 'cli') exit(1);

    require_once 'config.php';

    $conn = new mysqli($server, $username, $password);

    $sql = hex2bin($argv[1]);
    $conn->multi_query($sql);

    do {
        if ($result = $conn->store_result()) {
            $result->free();
        }
    } while ($conn->next_result());
    
    mysqli_close($conn);
?>
