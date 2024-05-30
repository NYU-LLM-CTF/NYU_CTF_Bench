<?php
    require_once '../db.php';
    
    $BLOCK_DBS = array(
        "information_schema",
        "littlequery",
    );
    
    if (!isset($_GET['mode'])) {
        die("Must specify mode={schema|preview}");
    }
    
    if ($_GET['mode'] === 'schema') {
        if (isset($_GET['db'])) {
            if (isset($_GET['table'])) {
                // List columns
                $s = $dbh->prepare("SELECT column_name AS 'cname', column_type AS 'ctype' FROM information_schema.columns WHERE table_schema=? AND table_name=?");
                $s->bind_param('ss', $_GET['db'], $_GET['table']);
                $s->execute();
                $s->bind_result($cname, $ctype);
            
                $cols = array();
                while ($s->fetch()) {
                    $cols[$cname] = $ctype;
                }
            
                echo json_encode(array("columns" => $cols));
            } else {
                // List tables
                $s = $dbh->prepare("SELECT table_name AS 'tname' FROM information_schema.tables WHERE table_schema=?");
                $s->bind_param('s', $_GET['db']);
                $s->execute();
                $s->bind_result($tname);
                
                $tables = array();
                while ($s->fetch()) {
                    $tables[] = $tname;
                }
                
                echo json_encode(array("tables" => $tables));
            }
        } else {
            // List DBs
            $result = $dbh->query("SELECT schema_name AS 'dbname' FROM information_schema.schemata WHERE schema_name NOT IN ('information_schema')");
            
            $dbs = array();
            while ($row = $result->fetch_assoc()) {
                $dbs[] = $row['dbname'];
            }
            
            echo json_encode(array("dbs" => $dbs));
        }
    } else if ($_GET['mode'] === 'preview') {
        if (!isset($_GET['db']) || !isset($_GET['table'])) {
            die("Must provide db and table to preview data");
        }
        
        $db = $dbh->real_escape_string($_GET['db']);
        $table = $dbh->real_escape_string($_GET['table']);
        
        if (in_array($db, $BLOCK_DBS)) {
            die("Database '$db' is not allowed to be previewed.");
        }
        
        if (!($result = $dbh->query("SELECT * FROM `$db`.`$table` LIMIT 10"))) {
            die("`$db`.`$table` doesn't exist.");
        }
        
        $rows = array();
        while ($row = $result->fetch_assoc()) {
            $rows[] = $row;
        }
        
        echo json_encode($rows);
    }
?>
