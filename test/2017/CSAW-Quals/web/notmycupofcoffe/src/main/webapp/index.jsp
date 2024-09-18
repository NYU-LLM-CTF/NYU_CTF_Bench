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
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
      <a class="navbar-brand" href="/">Passion Beans</a>
    </nav>
    <div class="container-fluid bean-container">
      <div class="row justify-content-center bean-title">
        <div class="col-sm-12">
          <h2>Welcome to Passion Beans</h2>
        </div>
      </div>
      <div class="row justify-content-center bean-desc">
        <div class="col-sm-6">
          <h5>We aspire to create only the freshest beans that help people do less. We want to put breeding first and cultivation alongside. We dream of a world where the endless and the infinite become realities to beankind, and where the true value of beans are preserved.</h5>
        </div>
      </div>
      <div class="row justify-content-center bean-btn">
        <div class="col-sm-auto">
          <a href="breed.jsp" role="button" class="btn btn-success">Start Breeding</a>
        </div>
      </div>
    </div>
    <div class="container">
      <div class="row justify-content-center bean-title">
        <div class="col-sm-12">
          <h2>Our Beans</h2>
        </div>
      </div>
      <div class="row">
        <table class="table">
          <thead>
            <tr>
              <th>Name</th>
              <th>Description</th>
              <th>Parent</th>
              <th>Parent</th>
              <th>Available</th>
            </tr>
          </thead>
          <tbody>
            <%
            LegumeLoader loader = (LegumeLoader) session.getAttribute("loader");
            ArrayList<Bean> beans = loader.getBeans();
            for (Bean bean : beans) {
            %>
              <tr>
                <td class="bean-data"><%= bean.getName() %></td>
                <td class="bean-data"><%= loader.roast(bean) %></td>
                <td class="bean-data"><%= bean.getParent1() %></td>
                <td class="bean-data"><%= bean.getParent2() %></td>
                <td class="bean-data bean-avail">Yes</td>
              </tr>
            <%
            }
            %>
            <tr>
              <td class="bean-data">Flag</td>
              <td class="bean-data">-</td>
              <td class="bean-data">-</td>
              <td class="bean-data">-</td>
              <td class="bean-data bean-no-avail">No</td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="row justify-content-center footer">
        <div class="col-sm-auto">
          <a href="/password.jsp">Admin</a>
        </div>
      </div>
    </div>
  </body>
</html>
