<?php

require_once 'secrets.php';

$dbh = new mysqli(
	'localhost',
	$DB_USER,
	$DB_PASS,
	$DB_DB);
				  
if ($dbh->connect_errno) {
	die("Couldn't connect to DB! https://i.imgur.com/6NfmQ.jpg");
}
