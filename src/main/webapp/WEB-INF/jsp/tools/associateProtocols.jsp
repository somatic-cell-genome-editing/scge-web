<%@ page import="edu.mcw.scge.datamodel.Experiment" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.datamodel.Delivery" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.datamodel.Vector" %>
<%@ page import="edu.mcw.scge.configuration.UserService" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.datamodel.Protocol" %>

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
        font-size: 12px;
    }
</style>
<script>
    $(function() {
        $("#myTable").tablesorter({
            theme : 'blue'

        });
    });
</script>

<br>



<div>
    <%
        List<Protocol> protocols = (List<Protocol>) request.getAttribute("protocols");
            Access access = new Access();
            UserService userService = new UserService();
    %>
        <% if (access.isAdmin(userService.getCurrentUser(request.getSession()))) { %>

        <% } %>

        <form method="GET" action="/toolkit/data/protocols/updateAssociations">
            <input type="hidden" name="objectId" value="<%=request.getParameter("objectId")%>"/>
            <input type="hidden" name="redirectURL" value="<%=request.getParameter("redirectURL")%>"/>
        <table id="myTable" class="table tablesorter table-striped">
    <thead>
    <tr>
        <th></th>
        <th>Title</th>
        <th>Description</th>
        <th>File Download</th>
        <th>SCGE ID</th>
    </tr>
    </thead>
        <%
            for (Protocol protocol: protocols) {

      if (access.hasProtocolAccess(protocol, userService.getCurrentUser(request.getSession()))) {%>


    <tr>
        <td><input type="checkbox" name="protocolIds" value="<%=protocol.getId()%>"/></td>
        <td><a href="/toolkit/data/protocols/protocol?id=<%=protocol.getId()%>"><%=protocol.getTitle()%></a></td>
        <td><%=protocol.getDescription()%></td>
        <td><a href="/toolkit/files/protocol/<%=protocol.getFilename()%>"><%=protocol.getFilename()%></a></td>
        <td><%=protocol.getId()%></td>
    </tr>
        <% }
            } %>
</table>
            <input type="submit" value="submit"/>
        </form>