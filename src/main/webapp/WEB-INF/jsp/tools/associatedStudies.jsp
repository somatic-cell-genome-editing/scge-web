<%@ page import="edu.mcw.scge.datamodel.Study" %>
<%@ page import="java.util.List" %>
<h4 class="page-header" style="color:grey;">Associated SCGE Studies</h4>

<table id="myTable" class="table tablesorter table-striped">
    <thead>
    <tr><!--th>Select</th-->
        <!--th>Action</th-->
        <th>Tier</th>
        <th>Study_Name</th>
        <th>Type</th>
        <th>Laboratory</th>
        <th>PI</th>
        <th>Submitter</th>
        <th>Raw Data</th>
        <td>Ref</td>
        <th>Submission_Date</th>
        <th>Study_ID</th>
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
        <td><%=s.getSubmitter()%></td>
        <td><a href="<%=s.getRawData()%>">link</a></td>
        <td><a href="<%=s.getReference()%>">ref</a></td>
        <td><%=s.getSubmissionDate()%></td>
        <td><%=s.getStudyId()%></td>
    </tr>
    <% } %>

</table>

