<%@ page import="edu.mcw.scge.datamodel.Experiment" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.datamodel.Delivery" %>
<%@ page import="edu.mcw.scge.datamodel.Guide" %>
<%@ page import="edu.mcw.scge.web.SFN" %>

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
                <input size=60 class="form-control " type="search" placeholder="Search Guides" aria-label="Search">
                <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
            </form>
        </td>
    </tr>
</table>
<br>


<div>
    <%
        List<Guide> guides = (List<Guide>) request.getAttribute("guides");
    %>

    <table id="myTable" class="table tablesorter table-striped">
    <thead>
    <tr>
    <th>Guide</th>
        <th>Target Locus</th>
    <th>Detection Method</th>
        <td>Species</td>
    <th>Source</th>
    </tr>
    </thead>

        <% for (Guide g: guides) { %>

    <tr>
        <td><a href="guide?id=<%=g.getGuide_id()%>"><%=g.getGuide()%></a></td>
        <td><%=SFN.parse(g.getTargetLocus())%></td>
        <td><%=SFN.parse(g.getDetectionMethod())%></td>
        <td><%=SFN.parse(g.getSpecies())%></td>
        <td><%=SFN.parse(g.getSource())%></td>
    </tr>
        <% } %>
</table>
<!--div style="float:right; width:8%;padding-bottom: 10px"><button class="btn btn-primary" >Compare</button></div-->
