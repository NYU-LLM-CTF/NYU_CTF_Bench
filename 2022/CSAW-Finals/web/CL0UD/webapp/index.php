<!DOCTYPE html>
<html>
  <head>
  <title>Secure Tripverse Login</title>
    <!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">

<!-- jQuery library -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

<!-- Latest compiled JavaScript -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
  </head>

  <form class="form-horizontal" action="login.php">
    <fieldset>
    
    <!-- Form Name -->
    <legend>SECURE TRIPVERSE LOGIN</legend>
    
    <!-- Text input-->
    <div class="form-group">
      <label class="col-md-4 control-label" for="textinput">Username</label>  
      <div class="col-md-5">
      <input id="username" name="username" type="text" placeholder="username" class="form-control input-md" required="">
      <span class="help-block">Enter your emailID</span>  
      </div>
    </div>
    
    <!-- Password input-->
    <div class="form-group">
      <label class="col-md-4 control-label" for="password">Password</label>
      <div class="col-md-4">
        <input id="password" name="password" type="password" placeholder="password" class="form-control input-md" required="">
        
      </div>
    </div>
    
    <!-- Button -->
    <div class="form-group">
      <label class="col-md-4 control-label" for="submit"></label>
      <div class="col-md-4">
        <button id="submit" name="submit" class="btn btn-primary">Login</button>
      </div>
    </div>
    
    </fieldset>
    </form>

</html>
