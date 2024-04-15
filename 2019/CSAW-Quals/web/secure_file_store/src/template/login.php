<html>
<head>
<title>Secure File Storage - Login</title>
</head>
<body>
<?php if (isset($err)) { echo "<p>$err</p>"; } ?>
<form method="POST" id="login-form">
<input type="text" name="username" id="username" placeholder="Username" />
<input type="password" name="password" id="password" placeholder="Password" />
<input type="submit" value="Login" />
</form>
<p>No account? <a href="/register">Register here</a></p>
</body>
</html>
