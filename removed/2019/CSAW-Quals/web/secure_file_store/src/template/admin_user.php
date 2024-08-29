<?php
function listDir(string $path) {
    $files = scandir($path);
    echo "<ul>\n";
    foreach ($files as $file) {
        if ($file === "." || $file === "..") {
            continue;
        }

        echo "<li>$file</li>\n";
        $abspath = "$path/$file";
        if (is_dir($abspath)) {
            listDir($abspath);
        }
    }
    echo "</ul>\n";
}
?>
<html>
<head>
<title>Secure File Storage - Admin</title>
</head>
<body>
<h1>Welcome <?php echo $current_user->username; ?></h1>
<h1>User <?php echo $u->id; ?></h1>
<h2>Files</h2>
<?php listDir(BASE_PATH . "/" . $current_user->id . "/"); ?>
</body>
</html>
