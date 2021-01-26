<%@ page import="edu.mcw.scge.datamodel.Study" %>
<%@ page import="java.util.List" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/29/2020
  Time: 4:25 PM
  To change this template use File | Settings | File Templates.
--%>

<style>
    td{
        font-size: 12px;
    }
    .tiers{
        padding:0;
    }
    #updateTier{
        padding: 0;
    }
    .dropdown-menu {
        max-height: 200px;
        width:100%;
        overflow-y: auto;
        overflow-x: auto;
    }

</style>
<script>
    $(function() {
        $("#myTable").tablesorter({
            theme : 'blue'

        });
    });
</script>
<% List<Study> studies = (List<Study>) request.getAttribute("studies");%>


<div>
    <table id="myTable" class="table tablesorter table-striped table-sm">
        <thead>
        <tr>
            <th>Tier</th>
            <th>Name</th>
            <th>Laboratory</th>
            <th>Contact PI</th>
            <th>Submission Date</th>
            <th>SCGE ID</th>

        </tr>
        </thead>
        <tbody>
        <% for (Study s: studies) { %>
        <tr>
            <td style="width: 10%">
                <%=s.getTier()%>
            </td>

            <td><%=s.getStudy()%></td>
            <td><%=s.getLabName()%></td>
            <td><%=s.getPi()%></td>
            <td><%=s.getSubmissionDate()%></td>
            <td><%=s.getStudyId()%></td>
        </tr>
        <%}%>
        </tbody>
    </table>
</div>
