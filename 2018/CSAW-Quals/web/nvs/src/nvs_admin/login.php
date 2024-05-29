<?php
session_start();

$error = null;
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
	if (isset($_POST['user']) && isset($_POST['password']) && $_POST['user'] === 'admin' && $_POST['password'] === 'A_S3cret_backdoor_password_96f43d60a908b89f7343071c3862e14bcd1273ee') {
		$_SESSION['admin'] = 1;
		header('Location: index.php');
		die();
	}
	$error = "Invalid username or password!";
}

?>
<html>
	<head>
		<title>NVS INTERNAL - Login</title>
	</head>
	<body>
		<?php if ($error !== null) { ?>
		<p><?php echo $error; ?></p>
		<?php } ?>
		<form action="login.php" method="POST">
			<input type="text" name="user" />
			<input type="password" name="password" />
			<input type="submit" value="Login" />
		</form>
	</body>
</html>
