<%@ page import="edu.mcw.scge.datamodel.Editor" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.configuration.UserService" %>
<%@ page import="edu.mcw.scge.dao.implementation.EditorDao" %>
<%@ page import="edu.mcw.scge.dao.implementation.StatsDao" %>
<%@ page import="edu.mcw.scge.web.UI" %>
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
            <form action="/toolkit/data/search/results/Editor" class="form-inline my-2 my-lg-0">
                <input size=60 class="form-control " name="searchTerm" type="search" placeholder="Search Genome Editors" aria-label="Search">
                <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
            </form>
        </td>
    </tr>
</table>
<br>

<% List<Editor> editors = (List<Editor>) request.getAttribute("editors");
    StatsDao sdao = new StatsDao();
    int total = sdao.getEditorCount();
    boolean showCountMessage = true;
    if (total == editors.size()) {
        showCountMessage=false;
    }
%>

<% if (showCountMessage) { %>
<span style="color:#1A80B6; padding-left:10px;">Displaying <b><%=editors.size()%></b> of <b><%=total%></b> Editors.  <%=(total - editors.size())%> Editors hidden from view (tier 1 or 2)</span>
<% } %>

<table id="myTable" class="table tablesorter table-striped">
        <thead>
        <tr>
        <th>Name</th>
        <th>Type</th>
        <th>Subtype</th>
        <th>Alias</th>
        <th>Origin Species</th>
        <th>Activity</th>
        <th>Cleavage Type</th>
        <th>Source</th>
        <th>SCGE ID</th>
    </tr>
    </thead>

<%
    UserService userService=new UserService();
    Access access= new Access();
    for (Editor editor: editors) { %>


        <tr>
            <td><a href="editor?id=<%=editor.getId()%>"><%=UI.replacePhiSymbol(editor.getSymbol())%></a></td>
            <td><%=editor.getType()%></td>
            <td><%=editor.getSubType()%></td>
            <td><%=SFN.parse(editor.getAlias())%></td>
            <td><%=editor.getSpecies()%></td>
            <td><%=editor.getActivity()%></td>
            <td><%=editor.getDsbCleavageType()%></td>
            <td><%=editor.getSource()%></td>
            <td><%=editor.getId()%></td>

        </tr>
    <% } %>
</table>
