<%@ page import="edu.mcw.scge.datamodel.Study" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.configuration.UserService" %>
<%@ page import="edu.mcw.scge.datamodel.Person" %>
<%@ page import="edu.mcw.scge.dao.implementation.GrantDao" %>
<%@ page import="edu.mcw.scge.web.UI" %>


<h4 class="page-header" style="color:grey;">Associated SCGE Studies</h4>

<% List<Study> studies = (List<Study>)request.getAttribute("studies");
   Access localStudyAccess = new Access();
   Person localStudyPerson = new UserService().getCurrentUser(request.getSession());
    GrantDao grantDao = new GrantDao();
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
        <th>Grant Title</th>
        <th>Initiative</th>
        <th>Contact PI</th>
        <th>Submission Date</th>
    </tr>
    </thead>

    <% for (Study s: studies) { %>
    <% if (localStudyAccess.hasStudyAccess(s,localStudyPerson)) { %>
        <tr>
            <td><%=s.getTier()%>
            <td><a href="/toolkit/data/experiments/study/<%=s.getStudyId()%>"><%=s.getStudy()%></a></td>
            <td><%=UI.correctInitiative(grantDao.getGrantByGroupId(s.getGroupId()).getGrantInitiative())%></td>
            <td><%=s.getPi()%><br>(<%=s.getLabName()%>)</td>
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