<html>
<head>
<title>Secure File Storage - Admin</title>
</head>
<body>
<h1>Welcome <?php echo $current_user->username; ?></h1>
<h1>Site Administration</h1>
<h2>Users</h2>
<ul>
<?php
foreach (User::all() as $u) { 
    $esc = htmlspecialchars($u->username);
    echo "<li><a href=\"/admin/user/{$u->id}\">{$esc}</a></li>";
}
?>
</ul>
<h2>Sessions</h2>
<p>There are currently <?php echo $num_sessions; ?> active sessions.</p>
</body>
</html>
