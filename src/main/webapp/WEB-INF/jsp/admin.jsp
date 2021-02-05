<%@ page import="edu.mcw.scge.datamodel.Person" %>
<%@ page import="java.util.List" %>
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


<% List<Person> people = (List<Person>)request.getAttribute("people"); %>

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


<div class="container-fluid">
    <div class="row">
        <div class="col-sm-2 col-md-2 sidebar">
            <ul class="nav nav-sidebar">
                <li class="active"><a href="">Become User<span class="sr-only">(current)</span></a></li>
                <li><a href="unauthorizedUsers">New user requests</a></li>
                <li><a href="memberProfile">Update member profile</a></li>
            </ul>
            <ul class="nav nav-sidebar">
                <li><a href="#">Join the Group</a></li>
                <li><a href="#">Leave the Group</a></li>
                <li><a href="#">Delete Group</a></li>
                <li><a href="groups">List groups</a></li>
                <li><a href="members">List members</a></li>

            </ul>
            <ul class="nav nav-sidebar">
                <li><a href="#">Submit Study</a></li>
                <li><a href="#">Update Study</a></li>
            </ul>
        </div>
    </div>
</div>

<!-- Bootstrap core JavaScript
================================================== -->
<!-- Placed at the end of the document so the pages load faster -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>

</body>
</html>
