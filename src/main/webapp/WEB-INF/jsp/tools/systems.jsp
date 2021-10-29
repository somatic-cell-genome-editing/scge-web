<%@ page import="edu.mcw.scge.datamodel.Experiment" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.datamodel.Delivery" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.datamodel.Person" %>

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
        display:table-cell
    }
    .tablesorter-childRow td{
        background-color: lightcyan;
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
            <form action="/toolkit/data/search/results/Delivery%20System" class="form-inline my-2 my-lg-0">
                <input size=60 class="form-control " name="searchTerm" type="search" placeholder="Search Delivery Systems" aria-label="Search">
                <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
            </form>
        </td>
    </tr>
</table>
<br>



<div>
    <%
        List<Delivery> systems = (List<Delivery>) request.getAttribute("systems");
        Access access = new Access();
        Person p = access.getUser(request.getSession());
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

    <% for (Delivery d: systems) { %>

        <% if (access.hasDeliveryAccess(d,p))  { %>
        <tr>
            <td width="10"><%=d.getTier()%></td>
            <td><a href="/toolkit/data/delivery/system?id=<%=d.getId()%>"><%=d.getName()%></a></td>
        <td><%=d.getType()%></td>
        <td><%=SFN.parse(d.getSubtype())%></td>
        <td><%=SFN.parse(d.getDescription())%></td>
        <td><%=d.getId()%></td>
            <% } %>
    </tr>
        <% } %>
</table>
