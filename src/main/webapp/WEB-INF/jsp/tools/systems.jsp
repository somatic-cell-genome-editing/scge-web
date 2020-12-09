<%@ page import="edu.mcw.scge.datamodel.Experiment" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.datamodel.Delivery" %>

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

<div>
    <%
        List<Delivery> systems = (List<Delivery>) request.getAttribute("systems");
    %>

    <table id="myTable" class="table tablesorter table-striped">
    <thead>
    <tr>
    <th>ID</th>
    <th>Delivery System Type</th>
    <th>Subtype</th>
    </tr>
    </thead>

        <% for (Delivery d: systems) { %>

    <tr>
        <td><%=d.getId()%></td>
        <td><%=d.getType()%></td>
        <td><%=d.getSubtype()%></td>
    </tr>
        <% } %>
</table>
<!--div style="float:right; width:8%;padding-bottom: 10px"><button class="btn btn-primary" >Compare</button></div-->
