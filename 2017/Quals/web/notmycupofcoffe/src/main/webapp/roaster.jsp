<%@ page import="coffee.*" %>
<%@ page import="java.util.ArrayList" %>

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
      <%
      if(session.getAttribute("loader") == null) {
        LegumeLoader loader = new LegumeLoader(getServletContext().getRealPath("/") + "beans/");
        session.setAttribute("loader", loader);
      }
      %>
      <%
      LegumeLoader loader = (LegumeLoader) session.getAttribute("loader");
      BeanBreeder breeder = new BeanBreeder(loader);

      Bean bean = breeder.process(request);
      if (bean != null) {
        loader.addBean(bean, request.getParameter("bean-desc"));
      }
      %>
  </body>
  <script>
    window.location.href = '/';
  </script>
</html>
