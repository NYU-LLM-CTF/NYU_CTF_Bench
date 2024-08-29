<html>
<head>
<title>Secure File Storage - Register</title>
</head>
<body>
<?php if (isset($err)) { echo "<p>$err</p>"; } ?>
<form method="POST">
<input type="text" name="username" placeholder="Username" />
<input type="password" name="password" placeholder="Password" />
<input type="submit" value="Register" />
</form>
</body>
</html>
