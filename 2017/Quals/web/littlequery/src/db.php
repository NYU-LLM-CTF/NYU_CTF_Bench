<?php
    $dbh = new mysqli('localhost',
                      'littlequery',
                      'MbJ0OJi2JeATnjmTQSpAwN6567KIW7D',
                      'littlequery');
                      
    if ($dbh->connect_errno) {
        die("Couldn't connect to DB! https://i.imgur.com/6NfmQ.jpg");
    }
?>
