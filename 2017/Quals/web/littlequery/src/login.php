<?php
    session_start();
    require_once 'db.php';
    
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        if (!isset($_POST['username']) || !isset($_POST['password'])) {
            $error = "Username/password blank";
        } else {
            $s = $dbh->prepare('SELECT uid FROM user WHERE username=? AND password=?');
            $s->bind_param('ss', $_POST['username'], $_POST['password']);
            $s->execute();
            $s->bind_result($uid);
        
            if ($s->fetch()) {
                $_SESSION['id'] = $uid;
                header("Location: query.php");
            } else {
                $error = "Invalid username or password specified";
            }
        }
    }
?>
<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>LittleQuery</title>
    
    <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">

    <link href="css/main.css" rel="stylesheet">
</head>

<body>

    <?php require_once 'navbar.php'; ?>

    <!-- Page Content -->
    <div class="container">

        <div class="starter-template">
            <p style="color: red"><?php if (isset($error)) { echo "ERROR: ".$error; }?></p>
            <form class="form-signin" method="POST">
                <h2>Log In</h2>
                <label for="username" class="sr-only">Username</label>
                <input type="text" id="username" name="username" class="form-control" placeholder="Username" required autofocus>
                <label for="password" class="sr-only">Password</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="Password" required>
        
                <button class="btn btn-lg btn-primary btn-block" type="submit">Sign in</button>
             </form>
        </div>

        <footer>
            <div class="row">
                <div class="col-lg-12">
                    <p>&copy; 2017. Not really.</p>
                    <p style="font-size: 8px">Please don't sue us Google</p>
                </div>
            </div>
        </footer>

    </div>
    <!-- /.container -->

    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/3.1.9-1/core.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/crypto-js/3.1.9-1/sha1.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script src="js/login.js"></script>

</body>
</html>
