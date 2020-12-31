<%@ page import="edu.mcw.scge.datamodel.Study" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<h4 class="page-header" style="color:grey;">Associated SCGE Submissions</h4>

<table id="myTable" class="table tablesorter table-striped">
    <thead>
    <tr><!--th>Select</th-->
        <!--th>Action</th-->
        <th>Tier</th>
        <th>Name</th>
        <th>Type</th>
        <th>Laboratory</th>
        <th>Contact PI</th>
        <th>Raw Data</th>
        <th>Submission Date</th>
        <th>SCGE ID</th>
    </tr>
    </thead>

    <% List<Study> studies = (List<Study>)request.getAttribute("studies"); %>

    <% for (Study s: studies) { %>
    <tr>
        <td><%=s.getTier()%>
        <td><a href="/toolkit/data/experiments/search/<%=s.getStudyId()%>"><%=s.getStudy()%></a></td>
        <td><%=s.getType()%></td>
        <td><%=s.getLabName()%></td>
        <td><%=s.getPi()%></td>
        <td><a href="<%=s.getRawData()%>">[Download]</a></td>
        <%
            String pattern = "dd/MM/yyyy";
            SimpleDateFormat format = new SimpleDateFormat(pattern);
        %>
        <td><%=format.format(s.getSubmissionDate())%></td>
        <td><%=s.getStudyId()%></td>
    </tr>
    <% } %>

</table>

