<?php
    $conn = ldap_connect("ldap://localhost", 389)
        or die("Could not connect to localhost");
    ldap_set_option($conn, LDAP_OPT_PROTOCOL_VERSION, 3);
    if ($conn) {
        if (!ldap_bind($conn, "cn=admin,dc=any,dc=comp", "toor")) {
            die("Could not bind to localhost");
        }
    }
    $filter = "(&(objectClass=person)(!(givenName=Flag)))";
    if (isset($_GET['search'])) {
        $filter = "(&(objectClass=person)(&(givenName=" .$_GET['search']. ")(!(givenName=Flag))))";
    }
    $attrs = array("ou", "cn", "sn", "givenname", "uid");
    $result = ldap_search($conn, "dc=any,dc=comp", $filter, $attrs);
?>

<html>
    <head> <title>Any Comp. Directory </title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
        <style>
        .input-mysize{
            width:791px;
        }
        .table {
            background-color:white;
            border-style: solid;
            border-width: 2px;
            right-margin: 50px;
            width:1000px;
        }
        </style>
    </head>
    <body>
        <nav class="navbar navbar-inverse">
            <div class="containter-fluid">
                <div class="navbar-header">
                    <a class="navbar-brand" href="/"> Any Comp. Directory </a>
                </div>
            </div>
            <ul class="nav navbar-nav">
                <li class="active"><a href="/"> Home </a></li>
            </ul>
        </nav>
        <div class="container">
            <div class="row">
                <div class="col-md-10 col-md-offset-1 text-center">
                    <p> Here is a list of all users and groups </p>
                </div>
            </div>
        </div>
        <div class="container">
            <div class="row">
                <div class="col-md-10 col-md-offset-2">
                    <form role="search" action="index.php">
                        <div class="form-group" >
                            <input type="text" class="form-control input-mysize" placeholder="Search" name="search">
                            <button type="submit" class="btn btn-default"> Search</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <div class="container">
            <div class="row">
                <div class="col-md-10 col-md-offset-1">
                    <?php
                        if (isset($_GET['debug'])) {
                            echo $filter;
                        }
                    ?>
                    <table class="table">
                        <?php
                            if (isset($result)){
                                echo "
                                    <tr>
                                        <th> OU </th> <th> CN </th> <th> SN </th> <th> GivenName </th> <th> UID </th>
                                    </tr>
                                    ";
                                $entries = ldap_get_entries($conn, $result);
                                foreach($entries as $item) {
                                    echo "<tr><td>". $item["ou"][0] ."</td><td>".$item["cn"][0]."</td><td>".$item["sn"][0]."</td><td>".$item["givenname"][0]."</td><td>".$item["uid"][0]."</td></tr>";
                                }
                            }
                        ?>
                    </table>
                </div>
            </div>
        </div>
        <div class="container">
            <div class="row">
                <div class="col-md-10 col-md-offset-1">
                    <table class="table">

                    </table>
                </div>
            </div>
        </div>
    </body>
</html>