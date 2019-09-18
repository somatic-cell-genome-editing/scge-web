<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/3/2019
  Time: 2:58 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script
        src="https://code.jquery.com/jquery-3.4.1.min.js"
        integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
        crossorigin="anonymous"></script>
<style>
 .scge-admin-table-label{
         width:10%
 }
    .scge-admin-table-value{
        width:20%
    }

</style>
<div class="container">
    <h3>
        New user requests  <c:out value="${action}" />..
    </h3>

<c:forEach items="${unauthorizedUsers}" var="user">
    <div class="panel panel-default form-group" style="background-color:  #f2f2f2" >
        <form method="POST" action="${destination}" >
            <input type="hidden" name="name" value="${user.name}"/>
            <input type="hidden" name="email" value="${user.email}"/>
            <table class="table table-condensed" >
                <tr class="success">
                    <td class="scge-admin-table-label">Name:</td><td class="scge-admin-table-value">${user.name}</td>
                </tr>
                <tr class="success">
                    <td class="scge-admin-table-label">Institution:</td><td class="scge-admin-table-value">${user.institution}</td>
                </tr>
                <tr class="success">
                    <td class="scge-admin-table-label">Principal Investigator</td><td class="scge-admin-table-value"></td>
                </tr>
                <tr class="success">
                    <td class="scge-admin-table-label">Email</td><td class="scge-admin-table-label">${user.email}</td>
                </tr>
            </table>

            <div class="form-group" >
                <div class="radio">
                    <label>
                        <input type="radio" name="status" value="approved" class="from-group">Approve
                    </label>
                    <label>
                        <input type="radio" name="status" value="declined" class="form-group">Decline
                    </label>
                    <span><button type="submit" class="form-group btn btn-default btn-xs">Submit</button></span>
                </div>


            </div>
        </form>
    </div>
</c:forEach>

</div>
