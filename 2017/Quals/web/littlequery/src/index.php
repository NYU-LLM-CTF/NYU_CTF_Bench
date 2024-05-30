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

        <div class="row">
            <div class="col-md-8">
                <img class="img-responsive img-rounded" src="img/bigdata.png" alt="">
                <p style="font-size: 10px">CC BY-SA 3.0 from <a href="/img/bigdata.png">https://commons.wikimedia.org/wiki/File:BigData_2267x1146_white.png</a></p>
            </div>
            <div class="col-md-4">
                <h1>LittleQuery</h1>
                <p>Process your enterprise's big data with the most webscale language on the planet, JavaScript! Run your queries in our secure isolated systems faster than anywhere else.</p>
            </div>
        </div>

        <hr>

        <div class="row">
            <div class="col-md-4">
                <h2>Why JavaScript?</h2>
                <p>Why not JavaScript!?! You already use it in websites, on servers, and even on the desktop, so we thought: why not in data analytics?</p>
            </div>
            <div class="col-md-4">
                <h2>How?</h2>
                <p>All queries are run in an isolated <a href="https://github.com/runtimejs/runtime">runtime.js</a> VM giving you the absolute best performance and the best security!</p>
            </div>
            <div class="col-md-4">
                <h2>Where can I sign up?</h2>
                <p>Unfortunately due to the overwhelming interest in LittleQuery, we're not able to handle any more customers right now. Check back later!</p>
                <p>Existing customers can <a href="/login.php">sign in here</a>.</p>
            </div>
            <!--
            <div class="col-md-4">
                <h2>For Developers</h2>
                <p>Check out our <a href="/api/db_explore.php">API</a></p>
            </div>
            -->
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
    <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>

</body>
</html>
