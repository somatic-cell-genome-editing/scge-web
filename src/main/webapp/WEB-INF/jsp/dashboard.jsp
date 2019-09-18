<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/9/2019
  Time: 12:10 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<div class="panel panel-default" style="width:50%;">
    <div class="panel-heading" style="background-color:#4c91cd;color:white;font-weight: bold">Group Associations</div>
    <div class="panel panel-body">
        <table class="table">
            <tr><th>Group</th><th>Role</th></tr>
            <c:forEach items="${groupRoleMap}" var="g">
                <tr><td ><a href="members?group=${g.key}">${g.key}</a></td>
                    <td>
                        <c:set var="first" value="true"/>
                        <c:forEach items="${g.value}" var="r">
                            <c:choose>
                                <c:when test="${first=='true'}">
                                    ${r}
                                    <c:set var="first" value="false"/>
                                </c:when>
                                <c:otherwise>
                                    ;${r}
                                </c:otherwise>
                            </c:choose>

                    </c:forEach>
                   </td></tr>
            </c:forEach>

        </table>
    </div>
</div>




<div class="panel panel-default" style="width:50%;">
    <div class="panel-heading" style="background-color:#4c91cd;color:white;font-weight: bold">Experiments</div>
    <div class="panel panel-body">
        <table class="table">
            <tr><th>Experiment</th><th>Owner</th></tr>
            <tr><td><a href="#">Cancer cell line</a></td><td>animal_reporter_wg</td></tr>
            <tr><td><a href="#">Conditionally immortalized cell line</a></td><td>editor_wg</td></tr>
            <tr><td><a href="#">Embryonic stem cell</a></td><td>animal_reporter_wg</td></tr>
            <tr><td><a href="#">Finite cell line</a></td><td>animal_reporter_wg</td></tr>
        </table>
    </div>
</div>