<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 10/30/2020
  Time: 1:29 PM
  To change this template use File | Settings | File Templates.
--%>
<div class="card" >
    <table>
        <tr><th>Working Group</th></tr>
        <c:forEach items="${groupSubgroupRoleMap}" var="wg">
            <c:if test="${wg.key=='working group'}">
                <c:forEach items="${wg.value}" var="g2">
                    <c:if test="${g2.key!='Dissemination and Coordinating Center'}">
                        <tr><td ><a href="members?group=${g2.key}">${g2.key}</a></td>
                           </tr>
                    </c:if>
                </c:forEach>
            </c:if>
        </c:forEach>

    </table>
</div>