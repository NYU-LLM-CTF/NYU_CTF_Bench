<?php
$username = $_GET['username'];
$password = $_GET['password'];

if($username == "claymore" && $password == "MyChemicalRomance") {
    header("location: welcome.php");
} else {
    header("location: notwelcome.php");
}
?>