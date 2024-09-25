        <nav class="navbar navbar-fixed-top navbar-dark bg-inverse">
            <a class="navbar-brand" href="index.php">Custom Homepage</a>
			
            <ul class="nav navbar-nav">
                <li class="nav-item <?php if (basename($_SERVER["SCRIPT_FILENAME"], '.php') == "index"){ echo 'active'; } ?>">
                    <a class="nav-link" href="index.php">Home</a>
                </li>
                <li class="nav-item <?php if (basename($_SERVER["SCRIPT_FILENAME"], '.php') == "about"){ echo 'active'; } ?>">
                    <a class="nav-link" href="about.php">About</a>
                </li>
            </ul>
			
			<ul class="nav navbar-nav float-xs-right">
				<?php if (isset($_SESSION['id'])) { ?>
			    <li class="nav-item <?php if (basename($_SERVER["SCRIPT_FILENAME"], '.php') == "logout"){ echo 'active'; } ?>">
					<a class="nav-link" href="logout.php">Logout</a>
				</li>
				<?php } else { ?>
			    <li class="nav-item <?php if (basename($_SERVER["SCRIPT_FILENAME"], '.php') == "register"){ echo 'active'; } ?>">
					<a class="nav-link" href="register.php"><span class="glyphicon glyphicon-user"></span> Sign Up</a>
				</li>
				<li class="nav-item <?php if (basename($_SERVER["SCRIPT_FILENAME"], '.php') == "login"){ echo 'active'; } ?>">
			    	<a class="nav-link" href="login.php"><span class="glyphicon glyphicon-log-in"></span> Login</a>
				</li>
				<?php } ?>
			</ul>
        </nav>