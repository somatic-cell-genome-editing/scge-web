<%@ page import="edu.mcw.scge.datamodel.Experiment" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.datamodel.Delivery" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.datamodel.Vector" %>

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
            <form class="form-inline my-2 my-lg-0">
                <input size=60 class="form-control " type="search" placeholder="Search Vectors/Formats" aria-label="Search">
                <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
            </form>
        </td>
    </tr>
</table>
<br>



<div>
    <%
        List<Vector> systems = (List<Vector>) request.getAttribute("vectors");
    %>

    <table id="myTable" class="table tablesorter table-striped">
    <thead>
    <tr>
        <th>Name</th>
        <th>Type</th>
        <th>Subtype</th>
        <th>Alias</th>
        <th>SCGE ID</th>
    </tr>
    </thead>

    <% for (Vector d: systems) { %>
    <tr>
        <td><a href="/toolkit/data/vector/format/?id=<%=d.getVectorId()%>"><%=d.getName()%></a></td>
        <td><%=d.getType()%></td>
        <td><%=d.getSubtype()%></td>
        <td><%=SFN.parse(d.getAlias())%></td>
        <td><%=d.getVectorId()%></td>
    </tr>
        <% } %>
</table>
