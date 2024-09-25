<?php session_start(); ?>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <title>THE CLOUD</title>

        <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.0.0-alpha.5/css/bootstrap.min.css" rel="stylesheet">

        <link href="css/main.css" rel="stylesheet">
		
		<?php
		if (isset($_SESSION['id'])) {
			echo "<script type=\"text/javascript\">var uid = ".$_SESSION['id'].";</script>\n";
		} else {
			echo "<script type=\"text/javascript\">var uid = -1;</script>\n";
		}
		?>
    </head>

    <body>
        <?php include 'nav.php'; ?>

        <div class="container">

            <div class="starter-template">
				<?php if (!isset($_SESSION['id'])) { ?>
                <h1>THE CLOUD</h1>
                <p class="lead">Please use our services to store <i>all</i> of your information. We have a perfect security track record!</p>
				<p>Read more about how the site works and what services we provide on the <a href="about.php">about</a> page.</p>
            	<?php } else { ?>
				<h1>Dashboard</h1>
				<div id="tiles">
				</div>
				<hr />
				<p>Add a data source:</p>
				<div id="addDiv">
					<select id="tileType">
					</select>
					<input type="button" id="addTile" value="Add" />
				</div>
				<?php } ?>
			</div>

        </div>


        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/tether/1.2.0/js/tether.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.0.0-alpha.5/js/bootstrap.min.js"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/mustache.js/2.3.0/mustache.min.js"></script>
		<script src="/js/main.js"></script>
    </body>
</html>
