<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/3/2019
  Time: 12:05 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/common/header.jsp"%>
<script src="/scge/js/scge.js"></script>
<!--link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script-->


<title>Success Page</title>
<div class="container">
    <h4>Hello ${userName}, Welcome to SCGE Admin Console</h4>
    <h4 style="color:royalblue">${message}</h4>

    <div style="width: 100%">Admin Services</div>
    <ul>
        <!--li><a href="create">Create Member</a></li-->
        <li><a href="unauthorizedUsers">New user requests</a></li>
        <li><a href="createNewGroup">Create new group</a></li>
        <li><a href="addMembers">Add new members to a group</a></li>
        <li><a href="deleteMembers">Delete members from a group</a></li>
        <li><a href="deleteGroup">Delete existing group</a></li>
        <li><a href="updateProfile">Update member profile</a></li>
        <li><a href="deleteProfile">Delete member profile</a></li>
        <li><a href="viewProfile">View member profile</a></li>
        <li><a href="listMembers">List Members of a group</a></li>

    </ul>

</div>

<%@include file="/common/footer.jsp"%>
