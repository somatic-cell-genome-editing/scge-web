<%@ page import="edu.mcw.scge.datamodel.Study" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.configuration.UserService" %>
<%@ page import="edu.mcw.scge.datamodel.Person" %>
<h4 class="page-header" style="color:grey;">Associated SCGE Studies</h4>

<% List<Study> studies = (List<Study>)request.getAttribute("studies");
   Access localStudyAccess = new Access();
   Person localStudyPerson = new UserService().getCurrentUser(request.getSession());
%>

<% if (studies.size() ==0) { %>
<tr>
    <td>0 Studies associated</td>
</tr>

<%} else { %>

<script>
    $(function() {
        $("#associatedStudies").tablesorter({
            theme : 'blue'

        });
    });
</script>


<table id="associatedStudies" class="table tablesorter table-striped">
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
    <% if (localStudyAccess.hasStudyAccess(s,localStudyPerson)) { %>
        <tr>
            <td><%=s.getTier()%>
            <td><a href="/toolkit/data/experiments/study/<%=s.getStudyId()%>"><%=s.getStudy()%></a></td>
            <td></td>
            <td><%=s.getLabName()%></td>
            <td><%=s.getPi()%></td>
            <%
                String pattern = "MM/dd/yyyy";
                SimpleDateFormat format = new SimpleDateFormat(pattern);
            %>
            <td><%=format.format(s.getSubmissionDate())%></td>
        </tr>
    <% } %>
    <% } %>

</table>

<% } %>