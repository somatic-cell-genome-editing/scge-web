<%@ page import="edu.mcw.scge.datamodel.Model" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/29/2020
  Time: 4:25 PM
  To change this template use File | Settings | File Templates.
--%>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
<link href="/common/tableSorter/css/filter.formatter.css" rel="stylesheet" type="text/css"/>
<link href="/common/tableSorter/css/theme.jui.css" rel="stylesheet" type="text/css"/>
<link href="/common/tableSorter/css/theme.blue.css" rel="stylesheet" type="text/css"/>

<script src="/common/tableSorter/js/tablesorter.js"> </script>
<script src="/common/tableSorter/js/jquery.tablesorter.widgets.js"></script>
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
        <td align="center"><img height="100" width="100" src="https://scge.mcw.edu/wp-content/uploads/2019/06/Editor-rev.png" border="0"/></td>
        <td align="center">
            <form action="/toolkit/data/search/results/Model" class="form-inline my-2 my-lg-0">
                <input size=60 class="form-control " name="searchTerm" type="search" placeholder="Search Genetic Models" aria-label="Search">
                <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
            </form>
        </td>
    </tr>
</table>
<br>

<% List<Model> models = (List<Model>) request.getAttribute("models"); %>


<table id="myTable" class="table tablesorter table-striped">
        <thead>
        <tr>
        <th>Name</th>
        <th>Model Type</th>
        <th>Subtype</th>
        <th>Alias</th>
        <th>Species</th>
        <th>SCGE ID</th>
    </tr>
    </thead>
<% for (Model model: models )  { %>

    <tr>
        <td><!--a href="model/?id=<%--=model.getModelId()-%>"><%--=SFN.parse(model.getShortName())--%></a--></td>
        <td><%=model.getType()%></td>
        <td><%=SFN.parse(model.getSubtype())%></td>
        <td><a href="model/?id=<%=model.getModelId()%>"><%=model.getName()%></a></td>
        <td><%=model.getOrganism()%></td>
        <td><%=model.getModelId()%></td>
    </tr>
<% } %>
</table>
