<?php
	// To mirror the initial DB import (backups/db.sql.bak)
    try {
	    $db = new PDO('mysql:host=localhost;dbname=cloudb',
	                  'admin',
			    	  'S0meR3@11yG00dPa$$w0rdThatY0u5hou1dntCar3@b0uT',
			  	      array(PDO::MYSQL_ATTR_INIT_COMMAND => 'SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO"'));
    } catch (PDOException $e) {
        echo "Couldn't connect to DB! https://i.imgur.com/6NfmQ.jpg";
        die();
    }
?>
