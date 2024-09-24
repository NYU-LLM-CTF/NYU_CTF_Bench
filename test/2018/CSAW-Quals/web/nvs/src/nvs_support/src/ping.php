<?php
if (!isset($_GET['dest'])) {
    die("Missing parameters.");
}

$dest = $_GET['dest'];

system("ping -c3 \"" . $dest . "\" 2>&1");
?>
