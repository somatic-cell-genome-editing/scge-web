<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 10/30/2020
  Time: 1:28 PM
  To change this template use File | Settings | File Templates.
--%>
<style>
    th{
        color:#24609c;
    }
</style>
<div class="card">
    <table >
        <tr><th>My Group</th></tr>
        <!--tr><td><a href="members?group=consortium group">Consortium Group</a></td></tr-->
        <c:forEach items="${groupSubgroupRoleMap}" var="sg">

            <c:if test="${sg.key!='working group'}">
                <c:forEach items="${sg.value}" var="g1">
                    <c:if test="${g1.key!='Dissemination and Coordinating Center'}">
                        <tr><td ><a href="members?group=${g1.key}">${g1.key}</a></td>
                            </tr>
                    </c:if>
                </c:forEach>
            </c:if>
        </c:forEach>

    </table>
</div>