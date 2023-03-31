<%@ page import="edu.mcw.scge.datamodel.Experiment" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.datamodel.Delivery" %>
<%@ page import="edu.mcw.scge.datamodel.Guide" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.datamodel.Person" %>
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
        <td align="center"><img height="100" width="100" src="/toolkit/images/guideIcon.png" border="0"/></td>
        <td align="center">
            <form action="/toolkit/data/search/results/Guide" class="form-inline my-2 my-lg-0">
                <input size=60 class="form-control " name="searchTerm" type="search" placeholder="Search Guides" aria-label="Search">
                <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
            </form>
        </td>
    </tr>
</table>
<br>


<div>
    <%
        List<Guide> guides = (List<Guide>) request.getAttribute("guides");
        Access access = new Access();
        Person p = access.getUser(request.getSession());
    %>
      <% if (access.isAdmin(p) && !SCGEContext.isProduction()) { %>
        <div align="right"><a href="/toolkit/data/guide/edit"><button class="btn btn-primary">Add Guide</button></a></div>
        <% } %>
    <table id="myTable" class="table tablesorter table-striped">
    <thead>
    <tr>
        <th>Tier</th>
        <th>Name</th>
        <td>Species</td>
        <th>Target Locus</th>
        <th>Description</th>
        <td>Guide Compatability</td>
        <td>Specificity Ratio</td>
        <td>SCGE ID</td>
    </tr>
    </thead>

    <% for (Guide g: guides) { %>

        <% if (access.hasGuideAccess(g,p)) { %>
    <tr>
        <td width="10"><%=g.getTier()%></td>
        <td><a href="/toolkit/data/guide/system?id=<%=g.getGuide_id()%>"><%=g.getGuide()%></a></td>
        <td><%=SFN.parse(g.getSpecies())%></td>
        <td><%=SFN.parse(g.getTargetLocus())%></td>
        <td><%=SFN.parse(g.getGuideDescription())%></td>
        <td><%=SFN.parse(g.getGuideCompatibility())%></td>
        <td><%=SFN.parse(g.getSpecificityRatio())%></td>
        <td><%=g.getGuide_id()%></td>
    </tr>
        <% } %>

     <% } %>
</table>
