<%@ page import="edu.mcw.scge.datamodel.Study" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<h4 class="page-header" style="color:grey;">Associated SCGE Submissions</h4>

<% List<Study> studies = (List<Study>)request.getAttribute("studies"); %>

<% if (studies.size() ==0) { %>
<tr>
    <td>0 Studies associated</td>
</tr>

<%} else { %>


<table id="myTable" class="table tablesorter table-striped">
    <thead>
    <tr><!--th>Select</th-->
        <!--th>Action</th-->
        <th>Tier</th>
        <th>Name</th>
        <th>Initiative</th>
        <th>Institution</th>
        <th>Contact PI</th>
        <th>Submission Date</th>
    </tr>
    </thead>

    <% for (Study s: studies) { %>
    <tr>
        <td><%=s.getTier()%>
        <td><a href="/toolkit/data/experiments/study/<%=s.getStudyId()%>"><%=s.getStudy()%></a></td>
        <td></td>
        <td><%=s.getLabName()%></td>
        <td><%=s.getPi()%></td>
        <%
            String pattern = "dd/MM/yyyy";
            SimpleDateFormat format = new SimpleDateFormat(pattern);
        %>
        <td><%=format.format(s.getSubmissionDate())%></td>
    </tr>
    <% } %>

</table>

<% } %>