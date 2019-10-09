<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/9/2019
  Time: 11:47 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<div class="panel panel-default" style="width:50%;">
    <div class="panel-heading" style="background-color:#4c91cd;color:white;font-weight: bold">${groupName} members (${groupMembersCount})</div>
    <div class="panel panel-body">
        <table class="table">
            <tr><th>Name</th><th>Institution</th><th>Role</th></tr>
            <c:forEach items="${groupMembers}" var="m">
                <tr><td >${m.name}</td>
                    <td>${m.institutionName}</td>
                <td>
                    <c:set var="firstRole" value="true"/>
                    <c:forEach items="${m.roles}" var="r">
                        <c:choose>
                            <c:when test="${firstRole=='true'}">
                                ${r}
                                <c:set var="firstRole" value="false"/>
                            </c:when>
                            <c:otherwise>
                                ; ${r}

                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                </td></tr>
            </c:forEach>

        </table>
    </div>
</div>

