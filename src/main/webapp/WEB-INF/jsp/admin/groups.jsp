<%@ page import="edu.mcw.scge.datamodel.Person" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.dao.implementation.PersonDao" %>
<%@ page import="edu.mcw.scge.dao.implementation.GroupDAO" %>
<%@ page import="edu.mcw.scge.datamodel.PersonInfo" %>
<%@ page import="edu.mcw.scge.datamodel.SCGEGroup" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">


    <title>Administration</title>

    <!-- Bootstrap core CSS -->
    <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">

    <!-- Custom styles for this template -->
    <link href="/scge/css/dashboard.css" rel="stylesheet">
    <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>

</head>

<body>
<% try { %>


<%

    PersonDao pdao = new PersonDao();
    GroupDAO gdao = new GroupDAO();
    Person p = pdao.getPersonById(Integer.parseInt(request.getParameter("id"))).get(0);
%>

<h2>User: <%=p.getName()%> - <%=p.getEmail()%></h2>

<%
  List<PersonInfo> piList = gdao.getGroupsNRolesByPersonId(p.getId());
%>

<% if (piList != null) { %>
<h2>Current Group Association</h2>
<table border="" cellspacing="0">
    <% for (PersonInfo pi: piList) { %>
        <tr><td><input type="button" value="Remove" onclick="location.href='/toolkit/admin/removeGroup?id=<%=p.getId()%>&gid=<%=pi.getGrantId()%>'"/></td><td>&nbsp;&nbsp;&nbsp;</td><td><span style="padding: 0;font-size:14px" class="text-muted"><%=pi.getSubGroupName()%></span></td></tr>
    <% } %>
</table>
<% } %>

<%
    List<SCGEGroup> groups = gdao.getAllGroups();
%>
<br>
<h2>Other Groups</h2>
<table border="" cellspacing="0">
    <form>
    <% for (SCGEGroup group: groups) { %>
        <tr><td><input type="button" value="Add" onclick="location.href='/toolkit/admin/addGroup?id=<%=p.getId()%>&gid=<%=group.getGroupId()%>'"/></td><td>&nbsp;&nbsp;&nbsp;</td><td><span style="padding: 0;font-size:14px" class="text-muted"><%=group.getGroupName()%></span></td></tr>
    <% } %>
    </form>
</table>



<% } catch (Exception e) {
    e.printStackTrace();
}
%>





<!-- Bootstrap core JavaScript
================================================== -->
<!-- Placed at the end of the document so the pages load faster -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>

</body>
</html>
