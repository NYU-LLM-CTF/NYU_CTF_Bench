<?
$cats = array(
  1 => array("id"=>1, "Name"=>"Grumpy Cat", "Available"=>"Now", "Description"=>"Your day was not possibly worse than mine.", "Picture"=>"/img/grumpy-small.jpg"),
  2 => array("id"=>2, "Name"=>"Keyboard Cat", "Available"=>"Now", "Description"=>"Entertaining since 1984", "Picture"=>"/img/Keyboard-small.jpg"),
  3 => array("id"=>3, "Name"=>"Computer Cat", "Available"=>"Now", "Description"=>"Just keeping up on the memes.", "Picture"=>"/img/Computer-small.jpg"),
  4 => array("id"=>4, "Name"=>"Bodybuilder Cat", "Available"=>"Now", "Description"=>"Just one more rep", "Picture"=>"/img/Guns-small.jpg"),
  5 => array("id"=>5, "Name"=>"Hoodie Cat", "Available"=>"Now", "Description"=>"He didn't do it", "Picture"=>"/img/Hoodie-small.jpg"),
  6 => array("id"=>6, "Name"=>"Hacker Cat", "Available"=>"Now", "Description"=>"All your Internetz belong to Uz", "Picture"=>"/img/Hacker-Cat-small.jpg"),
  7 => array("id"=>7, "Name"=>"CSAW Cat", "Available"=>"Coming Soon", "Description"=>"Coming Soon", "Picture"=>"/img/ComingSoon_small.jpg"),
); 
?>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Adoptable Lol Cats</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="bootstrap/css/bootstrap.css" rel="stylesheet">
    <link href="bootstrap/css/bootstrap-responsive.css" rel="stylesheet">
    <link href="docs.css" rel="stylesheet">

</head>
<header>
    <!-- Navbar
    ================================================== -->
    <div class="navbar navbar-inverse navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container">
          <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="brand" href="./home.php">Home</a>
          <!--
		  <div class="nav-collapse collapse">
            <ul class="nav">
              <li class="active">
                <a href="./home.php">Home</a>
              </li>
            </ul>
          </div>
		  -->
        </div>
      </div>
    </div>
</header>
<body>
<br><br>
<table border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="#CCCCCC">
<tr>
<th>Cats Available for Adoption</th>
</tr>
<tr>
<table border="1" align="center" cellpadding="1" cellspacing="1" bgcolor="#CCCCCC">
<tr>
<td>
<table border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="#CCCCCC">
<tr><td><?=$cats[1]['Name']?></td></tr>
<tr><td><a href="viewcat.php?catid=1"><img src="<?=$cats[1]['Picture']?>"></td></tr>
</table>
</td>
<td>
<table border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="#CCCCCC">
<tr><td><?=$cats[2]['Name']?></td></tr>
<tr><td><a href="viewcat.php?catid=2"><img src="<?=$cats[2]['Picture']?>"></td></tr>
</table>
</td>
</tr>
<tr>
<td>
<table border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="#CCCCCC">
<tr><td><?=$cats[3]['Name']?></td></tr>
<tr><td><a href="viewcat.php?catid=3"><img src="<?=$cats[3]['Picture']?>"></td></tr>
</table>
</td>
<td>
<table border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="#CCCCCC">
<tr><td><?=$cats[4]['Name']?></td></tr>
<tr><td><a href="viewcat.php?catid=4"><img src="<?=$cats[4]['Picture']?>"></td></tr>
</table>
</td>
</tr>
<tr>
<td>
<table border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="#CCCCCC">
<tr><td><?=$cats[5]['Name']?></td></tr>
<tr><td><a href="viewcat.php?catid=5"><img src="<?=$cats[5]['Picture']?>"></td></tr>
</table>
</td>
<td>
<table border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="#CCCCCC">
<tr><td><?=$cats[6]['Name']?></td></tr>
<tr><td><a href="viewcat.php?catid=6"><img src="<?=$cats[6]['Picture']?>"></td></tr>
</table>
</td>
</tr>
<tr>
<td>
<table border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="#CCCCCC">
<tr><td><?=$cats[7]['Name']?></td></tr>
<tr><td><a href="viewcat.php?catid=7"><img src="<?=$cats[7]['Picture']?>"></td></tr>
</table>
</td>
<td>
<table border="0" align="center" cellpadding="0" cellspacing="1" bgcolor="#CCCCCC">
<tr><td></td></tr>
<tr><td></td></tr>
</table>
</td>
</tr>
</tr>
</table>
</tr>
</table>
<script type="text/javascript" src="bootstrap/javascript/bootstrap.min.js" />
</body>
</html>
