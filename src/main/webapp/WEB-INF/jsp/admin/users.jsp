<%@ page import="edu.mcw.scge.datamodel.Person" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.dao.implementation.PersonDao" %>
<%@ page import="edu.mcw.scge.dao.implementation.GroupDAO" %>
<%@ page import="edu.mcw.scge.datamodel.PersonInfo" %>
<%@ page import="edu.mcw.scge.datamodel.SCGEGroup" %>
<%@ page import="edu.mcw.scge.datamodel.Institution" %>
<%@ page import="edu.mcw.scge.dao.InstitutionDAO" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
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



<br>
<form action="/toolkit/admin/addUser">
    <table border="0" class="table tablesorter table-striped">
        <tr>
            <td></td>
            <td>Name</td>
            <td>Institution</td>
            <td>Google Account Email</td>
            <td>Other Email</td>
            <td></td>

        <%
        try {
            InstitutionDAO idao = new InstitutionDAO();
            List<Institution> iList = idao.getAll();
            System.out.println("ilist = " + iList);
        %>
                        <tr>
            <td>Add User:&nbsp;</td>
            <td><input name="name" type="text" /></td>
            <td>
                <select name="institution">
                <% for (Institution i:iList) { %>
                        <option value="<%=i.getId()%>"><%=i.getName()%></option>
                <% } %>

                </select>
            </td>
            <% }catch (Exception e) {
            e.printStackTrace();
            }
            %>


            <td><input name="gEmail" type="text" /></td>
            <td><input name="oEmail" type="text" /></td>
            <td><input type="submit" value="Add User"/></td>
        </tr>
    </table>
</form>

<style>
    .adminInput {
        color:black;
    }

    table {
        border: 1px solid #ddd;
        width: 100%;
    }

    td {
        color:black;
        text-align: right;
    }

    input {
        color:black;
    }

</style>
<br>
<script>
    $(function() {
        $("#users").tablesorter({
            theme : 'blue'

        });
    });
</script>

<table id="users" border="1" cellpadding="4" cellspacing="4" class="table tablesorter table-striped">
    <tr>
        <td>ID</td>
        <td>Name</td>
        <td>Institution</td>
        <td>Google Account Email</td>
        <td>Other Email</td>
        <td>Account Status</td>
        <td></td>
        <td></td>
        <td></td>
        <td></td>


    </tr>
    <% for (Person p: people) { %>
        <tr>
            <form action="#">
            <input type="hidden" value="<%=p.getId()%>" name="id"/>
            <td><%=p.getId()%></td>
            <td><input name="name" type="text" value="<%=p.getName()%>" width="150" class="adminInput" /></td>
            <td><input name="institution" type="text" value="<%=p.getInstitution()%>"  width="150" class="adminInput"/></td>
            <td><input name="gEmail" type="text" value="<%=p.getEmail()%>" width="150" class="adminInput"/></td>
            <td><input name="oEmail" type="text" value="<%=SFN.parse(p.getOtherId())%>" width="150" class="adminInput"/></td>
            <td><select name="status">

                <% if (p.getStatus().equals("ACTIVE")) { %>
                <option value="ACTIVE" checked>ACTIVE</option>
                <% } else { %>
                <option value="ACTIVE">ACTIVE</option>
                <% } %>
                <% if (p.getStatus().equals("INACTIVE")) { %>
                <option value="INACTIVE" checked>INACTIVE</option>
                <% } else { %>
                <option value="INACTIVE">INACTIVE</option>
                <% } %>

            </select>
            </td>
            <td><input type="button" value="U" onclick="this.form.action='/toolkit/admin/updateUser'; this.form.submit();"/></td>
            <td><input type="button" value="D" onclick="this.form.action='/toolkit/admin/removeUser'; this.form.submit();"/></td>
            <td><input type="button" value="G" onclick="this.form.action='/toolkit/admin/groups'; this.form.submit();"/></td>
            </form>
            <td width="300">



                <% List<PersonInfo> piList = gdao.getGroupsNRolesByPersonId(p.getId()); %>

                <% if (piList != null) { %>
                    <table border="1" cellspacing="0">
                    <% for (PersonInfo pi: piList) { %>
                        <tr><td><span style="padding: 0;font-size:14px" class="text-muted"><%=pi.getSubGroupName()%></span></td></tr>

                    <% } %>
                    </table>
                <% } %>



            </td>



     </tr>
    <% } %>


</table>









<!-- Bootstrap core JavaScript
================================================== -->
<!-- Placed at the end of the document so the pages load faster -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>

</body>
</html>
