<?php
if(isset($_POST["url"]) && isset($_POST["message"])) {
    $url = $_POST["url"];
    $msg = $_POST["message"];
    $parsed = parse_url($url);
    if (
        !preg_match("|^https?$|", $parsed["scheme"]) ||
        !preg_match("|^discord\.com$|", $parsed["host"]) ||
        !preg_match("|^/api/webhooks/\d+/[A-Za-z0-9_\-]+$|", $parsed["path"])
    ) {
        exit("bad webhook url"); 
    }
    $url = escapeshellarg($url);
    $msg = escapeshellarg("{\"content\":\"$msg\"}");
    system("curl -X POST -H 'Content-Type: application/json' -d $msg $url");
    exit("message sent to webhook!");
}
?>
<html>
<head>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@1/css/pico.min.css">
<title>Discord Webhook Tester</title>
</head>
<body>
<main class="container">
<h1>Discord Webhook Tester</h1>
<form onsubmit="message.value=JSON.stringify(message.value);" method="POST" action="/">
<label for="url">Webhook URL to test:</label>
<input id="url" name="url" placeholder="https://discord.com/api/webhooks/123/abc">
<label for="message">Message to send:</label>
<textarea id="message" name="message" placeholder="Hello World"></textarea>
<button type="submit">Test</button>
</form>
</main>
</body>
</html>
