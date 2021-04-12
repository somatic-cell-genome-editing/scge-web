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


<% GroupDAO gdao = new GroupDAO();
    PersonDao pdao = new PersonDao();
    List<Person> people = (List<Person>)request.getAttribute("people");
    Person person = (Person) request.getAttribute("person");
%>

You are logged in as <b><%=person.getName()%></b>
<br><br>
<table>
    <tr>
        <td>Become User</td>
        <td>&nbsp;</td>
        <td>
            <form action="admin/sudo" method="get">
                <select name="person">
                    <% for (Person p: people) { %>
                    <option value="<%=p.getId()%>"><%=p.getName()%></option>

                    <% } %>
                </select>
                <input type="submit">
            </form>
        </td>
    </tr>
</table>


<br>

<a href="/toolkit/admin/users" style="font-size:20px;"/>Manage Users</a><br><br>
<a href="/toolkit/admin/groupOverview"  style="font-size:20px;" />Group Overview</a><br><br>
<a href="/toolkit/admin/studyTierUpdates"  style="font-size:20px;" />Study Tier Updates</a>











<!-- Bootstrap core JavaScript
================================================== -->
<!-- Placed at the end of the document so the pages load faster -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>

</body>
</html>
