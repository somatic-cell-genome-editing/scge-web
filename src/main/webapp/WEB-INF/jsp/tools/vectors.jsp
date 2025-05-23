<%@ page import="edu.mcw.scge.datamodel.Experiment" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.datamodel.Delivery" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.datamodel.Vector" %>
<%@ page import="edu.mcw.scge.configuration.UserService" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.web.SCGEContext" %>

<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/29/2020
  Time: 4:25 PM
  To change this template use File | Settings | File Templates.
--%>

<link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" integrity="sha384-AYmEC3Yw5cVb3ZcuHtOA93w35dYTsvhLPVnYs9eStHfGJvOvKxVfELGroGkvsg+p" crossorigin="anonymous"/>
<style>
    td{
        font-size: 12px;
    }
</style>
<script>
    $(function() {
        $("#myTable").tablesorter({
            theme : 'blue'

        });
    });
</script>

<table align="center">
    <tr>
        <td align="center"><img height="100" width="100" src="https://scge.mcw.edu/wp-content/uploads/2019/03/Delivery.png" border="0"/></td>
        <td align="center">
            <form class="form-inline my-2 my-lg-0" action="/toolkit/data/search/results/Vector">
                <input size=60 class="form-control " name="searchTerm" type="search" placeholder="Search Vectors/Formats" aria-label="Search">
                <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
            </form>
        </td>
    </tr>
</table>
<br>

<%
    Access access = new Access();
    UserService userService = new UserService();
%>

  <% if (access.isAdmin(userService.getCurrentUser(request.getSession())) && !SCGEContext.isProduction()) { %>
    <div align="right"><a href="/toolkit/data/vector/edit"><button class="btn btn-primary">Add Vector</button></a></div>
<% } %>

<div>
    <%
        List<Vector> systems = (List<Vector>) request.getAttribute("vectors");
    %>

    <table id="myTable" class="table tablesorter table-striped">
    <thead>
    <tr>
        <th>Tier</th>
        <th>Name</th>
        <th>Type</th>
        <th>Subtype</th>
        <th>Description</th>
        <th>SCGE ID</th>
    </tr>
    </thead>
        <%

            for (Vector vector: systems) {

      if (access.hasVectorAccess(vector, userService.getCurrentUser(request.getSession()))) {%>


    <tr>
        <td><%=vector.getTier()%></td>
        <td><a href="/toolkit/data/vector/format/?id=<%=vector.getVectorId()%>"><%=vector.getName()%></a></td>
        <td><%=vector.getType()%></td>
        <td><%=vector.getSubtype()%></td>
        <td><%=vector.getDescription()%></td>
        <td><%=vector.getVectorId()%></td>
    </tr>
        <% }
            } %>
</table>
