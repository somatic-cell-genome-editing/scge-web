<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.dao.implementation.PersonDao" %>
<%@ page import="edu.mcw.scge.dao.implementation.GroupDAO" %>
<%@ page import="edu.mcw.scge.dao.implementation.GrantDao" %>
<%@ page import="edu.mcw.scge.dao.implementation.StudyDao" %>
<%@ page import="edu.mcw.scge.datamodel.*" %>
<%@ page import="java.util.HashMap" %>
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
try {

    GroupDAO gdao = new GroupDAO();
    StudyDao sdao = new StudyDao();

List<SCGEGroup> groups = gdao.getAllGroups();
%>
    <table style="border:1px solid black;margin:5px; padding:5px;">

<%for (SCGEGroup g: groups) {%>
        <tr>
            <td><hr></td>
            <td><hr></td>
        </tr>
        <tr>
            <td colspan="2"><b>Group:</b> <span style="font-size:20px;"><%=g.getGroupName()%></span></td>
            <td></td>
        </tr>
        <tr><td></td><td></td></tr>
        <tr>
            <td>Studies:</td>
        </tr>
            <%
            List<Study> sList = sdao.getStudiesByGroupId(g.getGroupId());
            if (sList.size()==0) {
                out.print("<tr><td></td><td>NONE</td></tr>");
            }

            HashMap<Integer, String> submitter = new HashMap<Integer, String>();
            HashMap<Integer, String> pi = new HashMap<Integer, String>();

            for (Study s: sList) {
                submitter.put(s.getSubmitterId(),null);
                pi.put(s.getPiId(),null);
            %>

            <tr>
                <td></td>
                <td><%=s.getStudy()%></td>
            </tr>
            <%} %>
        <tr><td>People:</td></tr>
            <%
            List<Person> people = gdao.getGroupMembersByGroupId(g.getGroupId());
                if (people.size()==0) {
                    out.print("<tr><td></td><td>NONE</td></tr>");
                }
            for (Person p: people) { %>
             <tr>
                 <td></td>
                 <td>
                 <% if (submitter.containsKey(p.getId())) { %>
                     <span style="color:red;">(SUBMITTER)&nbsp;</span>
                 <% } %>
                     <% if (pi.containsKey(p.getId())) { %>
                     <span style="color:blue">(PI)&nbsp;</span>
                     <% } %>

                     <%=p.getName()%>  -- (<%=p.getInstitutionName()%>)
                 </td>


             </tr>
            <% } %>



<% }
} catch (Exception es) {
    es.printStackTrace();
}
%>
    </table>

<!-- Bootstrap core JavaScript
================================================== -->
<!-- Placed at the end of the document so the pages load faster -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>

</body>
</html>
