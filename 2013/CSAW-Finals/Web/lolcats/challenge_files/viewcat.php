<?
$cats = array(
  1 => array("id"=>1, "Name"=>"Grumpy Cat", "Available"=>"Now", "Description"=>"Your day was not possibly worse than mine.", "Picture"=>"/img/grumpy-large.jpg"),
  2 => array("id"=>2, "Name"=>"Keyboard Cat", "Available"=>"Now", "Description"=>"Entertaining since 1984", "Picture"=>"/img/Keyboard-large.jpg"),
  3 => array("id"=>3, "Name"=>"Computer Cat", "Available"=>"Now", "Description"=>"Just keeping up on the memes.", "Picture"=>"/img/Computer-large.jpg"),
  4 => array("id"=>4, "Name"=>"Bodybuilder Cat", "Available"=>"Now", "Description"=>"Just one more rep", "Picture"=>"/img/Guns-large.jpg"),
  5 => array("id"=>5, "Name"=>"Hoodie Cat", "Available"=>"Now", "Description"=>"He didn't do it", "Picture"=>"/img/Hoodie-large.jpg"),
  6 => array("id"=>6, "Name"=>"Hacker Cat", "Available"=>"Now", "Description"=>"All your Internetz belong to Uz", "Picture"=>"/img/Hacker-Cat-large.jpg"),
  7 => array("id"=>7, "Name"=>"CSAW Cat", "Available"=>"Coming Soon", "Description"=>"Description Coming Soon", "Picture"=>"/img/ComingSoon_large.jpg"),
);

//default
$cat = array("id"=>0, "Name"=>"Error:Not Found", "Available"=>"Error:Not Found", "Description"=>"Error:Not Found", "Picture"=>"/img/grumpy-large.jpg");

if(isset($_GET['catid'])){
	if($_GET['catid'] >= 1 && $_GET['catid'] <= 7){
		$cat = $cats[$_GET['catid']];
	}
} 
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
<th><?=$cat['Name']?></th>
</tr>
<tr><td>Available:
<?=$cat['Available']?>
</td></tr>
<tr><td>
<?=$cat['Description']?>
</td></tr>
<tr><td>
<img src="<?=$cat['Picture']?>">
</td></tr>
</table>
<script type="text/javascript" src="bootstrap/javascript/bootstrap.min.js" />
</body>
</html>