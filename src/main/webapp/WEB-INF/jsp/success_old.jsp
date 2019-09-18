<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 8/14/2019
  Time: 2:22 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@include file="/common/header.jsp"%>
<script src="/scge/js/scge.js"></script>
<!--link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script-->


<title>Success Page</title>
<div class="container">
    <h4>Hello ${userName}, Welcome to SCGE</h4>
    <h4 style="color:royalblue">${message}</h4>
    <c:if test="${fn:toLowerCase(status)=='approved'}">
        <div style="width: 100%">Member Services</div>
        <ul>
            <!--li><a href="create">Create Member</a></li-->
            <li><a href="create">Create Group</a></li>
            <li><a href="update">Update Member Profile</a></li>
            <li><a href="delete">Delete Member Profile</a></li>

            <li><a href="listMembers">List Members</a></li>
            <li><a href="listMembers">View Member Profile</a></li>
        </ul>
        <div style="width: 100%">Data Services</div>
        <ul>
            <li><a href="submission">Submit Study</a></li>
            <li><a href="#">List Studies</a></li>
            <li><a href="#">Edit/Update Study</a></li>

        </ul>
    </c:if>
</div>

<%@include file="/common/footer.jsp"%>