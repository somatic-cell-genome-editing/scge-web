<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/9/2019
  Time: 11:43 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<div class="panel panel-default" style="width:50%;">
    <div class="panel-heading" style="background-color:#4c91cd;color:white;font-weight: bold">${groupName}  subgroups</div>
    <div class="panel panel-body">
        <table class="table">
            <tr><th>Subgroup Name</th></tr>
            <c:forEach items="${groups}" var="g">
                <tr><td ><a href="members?group=${g}">${g}</a></td>
                  </tr>
            </c:forEach>

        </table>
    </div>
</div>
