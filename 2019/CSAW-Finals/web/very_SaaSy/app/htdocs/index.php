<html>
<body>
<?php
    if (isset($_GET['source'])) {
        highlight_file(__FILE__);
        die;
    }
    if (isset($_POST["scream"])) {


        $sql = bin2hex(strval($_POST["scream"]));

        exec("timeout 5 php query.php $sql >/dev/null 2>/dev/null &");

    }
?>
    <div>
        Screaming into the void as a service!
        <form method="post" action="">
        <textarea name="scream"></textarea>
        <button type="submit">AAAA!</button>
    </div>
    </form>
<!-- <a href="?source">source</a>-->
</body>
</html>
