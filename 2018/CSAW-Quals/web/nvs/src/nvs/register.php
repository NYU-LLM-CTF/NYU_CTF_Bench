<?php
// Registration form processing. Start up a chrome headless browser with admin cookies to look review
function chrome($url, $timeout=10) {
    $cmd = array(
        "/usr/bin/timeout",
        escapeshellarg(strval($timeout)),
        "/usr/bin/chromium-browser",
        "--disable-gpu",
        "--headless",
	"--dump-dom",
        "--",
        escapeshellarg($url),
    );
        
    exec(implode(' ', $cmd));
}

$error = null;

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    $error = "Invalid request method.";
}

if ($error === null && (!isset($_POST['email']) || !isset($_POST['description']) || !isset($_POST["g-recaptcha-response"]))) {
    $error = "Missing parameters.";
}

if ($error === null) {
    $response = $_POST["g-recaptcha-response"];
    $url = 'https://www.google.com/recaptcha/api/siteverify';
    $data = array(
    	'secret' => '6Lc-_m8UAAAAAHq55LxFLT9c3agPQ_0A0ln4MA3T',
    	'response' => $response,
    );
    $options = array(
    	'http' => array (
    		'method' => 'POST',
    		'content' => http_build_query($data),
    	)
    );
    $context = stream_context_create($options);
    $verify = file_get_contents($url, false, $context);
    $captcha_success = json_decode($verify);

    if ($captcha_success->success === false) {
	$error = "Bad bot.";
    }
}

if ($error === null) {
    require_once '../db.php';

    if ($stmt = $dbh->prepare("INSERT INTO contact (email, description) VALUES (?, ?)")) {
        $stmt->bind_param("ss", $_POST['email'], $_POST['description']);
        $stmt->execute();
        $stmt->close();
        $new_id = $dbh->insert_id;
        chrome("http://admin.no.vulnerable.services/review.php?id=$new_id");
    } else {
        $error = "MySQL error. You may want to contact the admins...";
    }

    $dbh->close();
}

$PAGE_NAME = "Contact"; require_once "header.php";
?>

			<!-- Main -->
				<div id="main" class="wrapper style1">
					<div class="container">
						<header class="major">
                            <?php if ($error === null) { ?>
                                <h2>Thank you</h2>
                                <p>We'll review your application shortly and reach out when we have capacity.</p>
                            <?php } else { ?>
                                <h2>An error has occurred</h2>
                                <p><?php echo $error; ?></p>
                                <p>You're not trying to hack us, are you?</p>
                            <?php } ?>
						</header>
					</div>
				</div>
<?php require_once "footer.php"; ?>
