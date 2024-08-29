<html>
<body>
<?php
    if (isset($_GET['source'])) {
        highlight_file(__FILE__);
        die;
    }
    if (isset($_POST["scream"])) {
        require 'config.php';
        $conn = new mysqli($server, $username, $password);

        if ($conn->connect_error) {
            die("Contact an admin. The void we're using can only handle so much.");
        }

        $sql = strval($_POST["scream"]);
        $conn->multi_query($sql);

        do {
            if ($result = $conn->store_result()) {
                $result->free();
            }
        } while ($conn->next_result());

        echo "
            Successfully threw your query in to the void.
            <!-- well, it's not here anymore at least -->
        ";
        mysqli_close($conn);
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
