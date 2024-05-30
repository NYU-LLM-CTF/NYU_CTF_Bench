<?php
    require_once 'common.php';
    require_login();
    
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        if (!isset($_POST['code'])) {
            die("Must send query code!");
        }

        $code = $_POST['code'];
        $dir = tmpdir();
        file_put_contents("$dir/index.js", $code);
        symlink(NODE_MODULES, "$dir/node_modules");
        symlink("/opt/funtimejs/fs_flag.txt", "$dir/flag.txt");
        putenv("PATH=/usr/bin:/usr/local/bin");
        putenv("HOME=/opt/funtimejs/home");
        passthru("cd '$dir' && /usr/bin/timeout 20 /usr/bin/runtime start --nographic --net none 2>&1");
        unlink("$dir/index.js");
        unlink("$dir/flag.txt");
        unlink("$dir/node_modules");
        unlink("$dir/.initrd");
        rmdir($dir);

        die();
    } else {
        require_once 'db.php';
        $dbs = array();
        $result = $dbh->query("SELECT s.schema_name AS 'db', t.table_name AS 'table', c.column_name AS 'column', c.column_type AS 'ctype' FROM information_schema.schemata s JOIN information_schema.tables t ON s.schema_name = t.table_schema JOIN information_schema.columns c ON s.schema_name = c.table_schema AND t.table_name = c.table_name WHERE schema_name NOT IN ('information_schema');");
        while ($row = $result->fetch_assoc()) {
            if (!array_key_exists($row['db'], $dbs)) {
                $dbs[$row['db']] = array();
            }
            $db = &$dbs[$row['db']];
            if (!array_key_exists($row['table'], $db)) {
                $db[$row['table']] = array();
            }
            $table = &$db[$row['table']];
            $table[$row['column']] = $row['ctype'];
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
    <link href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.27.4/codemirror.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">

    <link href="css/main.css" rel="stylesheet">
</head>

<body>

    <?php require_once 'navbar.php'; ?>

    <div class="container">
        <div class="row">
            <div class="col-md-4">
                <p>Your Databases:</p>
                <ul>
                    <?php
                        foreach ($dbs as $db => $tables) {
                    ?>
                    <li>
                        <?php echo $db; ?>
                        <ul>
                            <?php
                                foreach ($tables as $table => $columns) {
                            ?>
                            <li>
                                <?php echo $table; ?>
                                <ul>
                                    <?php
                                        foreach ($columns as $colname => $coltype) {
                                    ?>
                                    <li>
                                        <?php echo "$colname - $coltype"; // https://i.imgur.com/BtjZedW.jpg ?>
                                    </li>
                                    <?php
                                        }
                                    ?>
                                </ul>
                            </li>
                            <?php
                                }
                            ?>
                        </ul>
                    </li>
                    <?php
                        }
                    ?>
                </ul>
            </div>
            <div class="col-md-8">
                <textarea id="editor" name="code">
// flag{mayb3_1ts_t1m3_4_real_real_escape_string?}
console.log("Hello from runtime.js");
</textarea>
            </div>
        </div>
        <br>
        <div class="row">
            <div class="pull-right">
                <i class="fa fa-spinner fa-spin invisible" id="spinner"></i>
                <button type="button" class="btn btn-primary btn-lg" id="submit">Run</button>
            </div>
        </div>
        <hr>
        <div class="row">
            <div class="col-md-12">
                <textarea id="output" readonly style="width: 100%" rows=20>Results from the query will appear here</textarea>
            </div>
        </div>
        
    </div>
    <!-- /.container -->

    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.27.4/codemirror.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.27.4/mode/javascript/javascript.min.js"></script>
    <script src="js/query.js"></script>
</body>
</html>
