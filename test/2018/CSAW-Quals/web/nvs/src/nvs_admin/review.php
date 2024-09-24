<?php
if (!($_SERVER['REMOTE_ADDR'] === '127.0.0.1' || $_SERVER['REMOTE_ADDR'] === '::1')) {
    header('HTTP/1.1 403 Forbidden');
    die();
}

session_start();

// Hack to make chrome instances not have to get logged in
$_SESSION['admin'] = 1;

if (!isset($_GET['id'])) {
	die("No id passed");
}

$id = $_GET['id'];

require_once '../db.php';
if ($stmt = $dbh->prepare("SELECT description FROM contact WHERE id = ?")) {
    $stmt->bind_param("i", $id);
    $stmt->execute();
    $stmt->bind_result($description);
    $stmt->fetch();
    $stmt->close();
} else {
	die("MySQL error! https://i.imgur.com/6NfmQ.jpg");
}

$dbh->close();
?>
<html>
	<head>
		<title>NVS INTERNAL - Contact Review</title>
	</head>
	<body>
		<?php echo $description; ?>
	</body>
</html>
