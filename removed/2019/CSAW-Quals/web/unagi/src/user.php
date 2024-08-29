<!DOCTYPE html>
<html>
<head>
  <link rel="stylesheet" href="style.css">
  <script src="jquery.js"></script> 
  <script> 
    $(function(){
      $("#userinfo").load("userdb.php"); 
    });
  </script>
</head>

<body>
	<div class="topnav">
  		<a href="index.php">Home</a>
  		<a class="active" href="user.php">User</a>
  		<a href="upload.php">Upload</a>
  		<a href="about.php">About</a>
	</div>
  
  <div id="userinfo"></div>
  
</body>
</html>