<%@ page import="edu.mcw.scge.datamodel.Model" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.configuration.UserService" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.datamodel.HRDonor" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>

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


<% List<HRDonor> hrDonors = (List<HRDonor>) request.getAttribute("hrdonors");

    Access access = new Access();
    UserService userService = new UserService();
%>


<table id="myTable" class="table tablesorter table-striped">
        <thead>
        <tr>
            <th>Tier</th>
        <th>Name</th>
        <th>Type</th>
        <th>Source</th>
        <th>Description</th>
        <th>SCGE ID</th>
    </tr>
    </thead>


    <%
        for (HRDonor hrDonor: hrDonors )  { %>

    <% if (access.hasHrdonorAccess(hrDonor, userService.getCurrentUser(request.getSession()))) {%>

    <tr>
        <td width="10"><%=hrDonor.getTier()%></td>
        <td><a href="/toolkit/data/hrdonors/hrdonor/?id=<%=hrDonor.getId()%>"><%=hrDonor.getLabId()%></a></td>
        <td><%=hrDonor.getType()%></td>
        <td><%=hrDonor.getSource()%></td>
        <td><%=SFN.parse(hrDonor.getDescription())%></td>
        <td><%=hrDonor.getId()%></td>
    </tr>
    <% } %>
<% } %>
</table>
