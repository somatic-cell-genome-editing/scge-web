<%@ page import="edu.mcw.scge.datamodel.Study" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.configuration.UserService" %>
<%@ page import="edu.mcw.scge.datamodel.Person" %>
<%@ page import="edu.mcw.scge.dao.implementation.GrantDao" %>
<%@ page import="edu.mcw.scge.web.UI" %>

<script>
    $(function() {
        $("#myTable-1").tablesorter({
            theme : 'blue'

        });
    });
</script>
<%
    List<Study> studies = (List<Study>)request.getAttribute("studies");
    if (studies.size() > 0) {
    %>
<hr>
<h4 class="page-header" style="color:grey;">Associated SCGE Studies</h4>

<%
   Access localStudyAccess = new Access();
   Person localStudyPerson = new UserService().getCurrentUser(request.getSession());
    GrantDao grantDao = new GrantDao();
%>
<table id="myTable-1" class="tablesorter">
    <thead>
    <tr><!--th>Select</th-->
        <!--th>Action</th-->
        <th>Grant Title</th>
        <th>Initiative</th>
        <th>Contact PI</th>
        <th>Submission Date</th>
    </tr>
    </thead>
    <tbody>
    <% for (Study s: studies) { %>
    <% if (localStudyAccess.hasStudyAccess(s,localStudyPerson)) { %>
        <tr>
            <td><a href="/toolkit/data/experiments/group/<%=s.getGroupId()%>"><%=s.getStudy()%></a></td>
            <td><%=UI.correctInitiative(grantDao.getGrantByGroupId(s.getGroupId()).getGrantInitiative())%></td>
            <td>
                <%for(Person pi:s.getMultiplePis()){%>
                <%=pi.getName()%>
               <% }%>


                <br>(<%=s.getLabName()%>)</td>
            <%
                String pattern = "MM/dd/yyyy";
                SimpleDateFormat format = new SimpleDateFormat(pattern);
            %>
            <td><%=format.format(s.getSubmissionDate())%></td>
        </tr>
    <% } %>
    <% } %>
    </tbody>
</table>

<% } %>