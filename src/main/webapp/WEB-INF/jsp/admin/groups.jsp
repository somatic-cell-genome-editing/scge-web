<%@ page import="edu.mcw.scge.datamodel.Person" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.dao.implementation.PersonDao" %>
<%@ page import="edu.mcw.scge.dao.implementation.GroupDAO" %>
<%@ page import="edu.mcw.scge.datamodel.PersonInfo" %>
<%@ page import="edu.mcw.scge.datamodel.SCGEGroup" %>
<%@ page import="edu.mcw.scge.dao.implementation.GrantDao" %>
<%@ page import="edu.mcw.scge.datamodel.Grant" %>
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

<%
    String msg = (String) request.getAttribute("msg");
    if (msg !=null) {
%>
<div style="font-size:20px;color:blue;"><%=msg%></div>
<% } %>


<% try { %>


<%

    PersonDao pdao = new PersonDao();
    GroupDAO gdao = new GroupDAO();
    Person p = pdao.getPersonById(Integer.parseInt(request.getParameter("id"))).get(0);
%>
<table width="90%">
    <tr>
        <td>
            <span style="font-size:24px;"><%=p.getName()%> - <%=p.getEmail()%>&nbsp;&nbsp;&nbsp;&nbsp;(SCGE ID: <%=p.getId()%>)</span>
        </td>
        <td align="right">
            <a href="/toolkit/admin/users" style="font-size:24px; border:1px solid #EEEEEE; padding:5px;"><<< Return to Manage Users</a>
        </td>
    </tr>
</table>

<%
  List<PersonInfo> piList = gdao.getGroupsNRolesByPersonId(p.getId());
%>

<% if (piList != null) { %>
<h2>Current Group Association</h2>
<div style="border:1px solid black; padding:5px; margin:5px;">
<table border="0" style="margin:10px; padding:10px; border:0px solid black;">
    <% if (piList.size()==0) { %>
        <tr><td>0 Group Associations</td></tr>
    <% } else {
         for (PersonInfo pi: piList) { %>
            <tr>
                <td><input type="button" value="Remove" onclick="location.href='/toolkit/admin/removeGroup?id=<%=p.getId()%>&gid=<%=pi.getGroupId()%>'"/></td><td>&nbsp;&nbsp;&nbsp;</td><td><span style="padding: 0;font-size:14px" class="text-muted"><%=pi.getGroupName()%></span></td>
                <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                <td><%=pi.getGrantInitiative()%></td>
            </tr>
        <% }
     } %>
</table>
</div>
<% } %>

<%
    List<SCGEGroup> groups = gdao.getAllGroups();
%>
<br>
<h2>Other Groups</h2>
<div style="border:1px solid black; padding:5px; margin:5px;">
    <%
        GrantDao grantDao = new GrantDao();
        %>
    <table border="0" cellspacing="0" style="margin:5px; padding:5px;">
    <% for (SCGEGroup group: groups) { %>
        <tr>
            <td><input type="button" value="Add" onclick="location.href='/toolkit/admin/addGroup?id=<%=p.getId()%>&gid=<%=group.getGroupId()%>'"/></td>
            <td>&nbsp;&nbsp;</td>
            <td><%=group.getGroupName()%></td>
            <td>&nbsp;&nbsp;</td>
            <td><%=grantDao.getGrantByGroupId(group.getGroupId()).getGrantInitiative()%></td>
        </tr>
    <% } %>
</table>
</div>



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
