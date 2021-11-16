<%@ page import="edu.mcw.scge.datamodel.Study" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.configuration.UserService" %>
<%@ page import="edu.mcw.scge.datamodel.Person" %>
<%@ page import="edu.mcw.scge.dao.implementation.GrantDao" %>
<%@ page import="edu.mcw.scge.web.UI" %>
<%@ page import="edu.mcw.scge.datamodel.Protocol" %>

<script>
    $(function() {
        $("#myTable-1").tablesorter({
            theme : 'blue'

        });
    });
</script>
<h4 class="page-header" style="color:grey;">Protocols</h4>

<% List<Protocol> protocols = (List<Protocol>)request.getAttribute("protocols");
   Access localStudyAccess = new Access();
   Person localStudyPerson = new UserService().getCurrentUser(request.getSession());
    GrantDao grantDao = new GrantDao();
%>
<table id="myTable-1" class="tablesorter">
    <thead>
    <tr>
        <th>Title</th>
        <th>Description</th>
        <th>File Download</th>
        <th>SCGE ID</th>
    </tr>
    </thead>
    <tbody>
    <% for (Protocol protocol: protocols) { %>
    <% if (localStudyAccess.hasProtocolAccess(protocol,localStudyPerson)) { %>
        <tr>
    <tr>
        <td><a href="/toolkit/data/protocols/protocol/?id=<%=protocol.getId()%>"><%=protocol.getTitle()%></a></td>
        <td><%=protocol.getDescription()%></td>
        <td><a href="/toolkit/files/protocol/<%=protocol.getFilename()%>"><%=protocol.getFilename()%></a></td>
        <td><%=protocol.getId()%></td>
    </tr>
        </tr>
    <% } %>
    <% } %>
    </tbody>
</table>

