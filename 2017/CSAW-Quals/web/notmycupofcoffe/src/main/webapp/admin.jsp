<%@ page import="coffee.*" %>

<!DOCTYPE html>
<html lang="en">

  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
      <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/css/bootstrap.min.css" integrity="sha384-/Y6pD6FV/Vv2HJnA6t+vslU6fwYXjCFtcEpHbNJ0lyAFsXTsjBbfaDjzALeQsN6M" crossorigin="anonymous">
    <link rel="stylesheet" type="text/css" href="sources/main.css">
  </head>

  <body>
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
      <a class="navbar-brand" href="/">Passion Beans</a>
    </nav>
    <div class="container">
      <div class="row justify-content-center nav-space">
        <div class="col-sm-auto">
          <%
          Auth auth = new Auth();
          String guess = request.getParameter("password");
          String result;
          // NOTE: Change $ to s when page is ready
          auth.loadPassword("Pas$ion");
          if (!guess.matches("[A-Za-z0-9]+")) {
            result = "Only alphanumeric characters allowed";
          } else {
            result = auth.lookup(guess.hashCode());
            if (result == null) {
              result = "Incorrect Password";
            }
          }
          out.println(result);
          %>
        </div>
      </div>
      <div class="row justify-content-center">
        <div class="col-sm-auto">
          <a href="/password.jsp">Try again</a>
        </div>
      </div>
    </div>
  </body>
</html>
