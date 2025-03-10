<?php
	session_start();
	require_once 'db.php';
	
	if ($_SERVER['REQUEST_METHOD'] === 'POST') {
		if (!isset($_POST['username']) || !isset($_POST['password'])) {
			$error = "Username/password blank";
		} else {
			$hashpass = sha1($_POST['password']);
			
			$s = $db->prepare('SELECT uid FROM user WHERE username=? AND password=?');
			$s->execute(array($_POST['username'], $hashpass));
		
			$u = $s->fetch();
		
			if (!$u) {
				$error = "Invalid username or password specified";
			} else {
				$_SESSION['id'] = $u['uid'];
				header("Location: index.php");
			}
		}
	}
?><!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <title>THE CLOUD</title>

        <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.0.0-alpha.5/css/bootstrap.min.css" rel="stylesheet">

        <link href="css/main.css" rel="stylesheet">
    </head>

    <body>
        <?php include 'nav.php'; ?>

        <div class="container">

            <div class="starter-template">
				<p style="color: red"><?php if (isset($error)) { echo "ERROR: ".$error; }?></p>
				<form class="form-signin" method="POST">
			        <h2 class="form-signin-heading">Log In</h2>
			        <label for="username" class="sr-only">Username</label>
			        <input type="text" id="username" name="username" class="form-control" placeholder="Username" required autofocus>
			        <label for="password" class="sr-only">Password</label>
			        <input type="password" id="password" name="password" class="form-control" placeholder="Password" required>
					
			        <button class="btn btn-lg btn-primary btn-block" type="submit">Sign in</button>
			     </form>
            </div>

        </div>


        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/tether/1.2.0/js/tether.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.0.0-alpha.5/js/bootstrap.min.js"></script>
    </body>
</html>
