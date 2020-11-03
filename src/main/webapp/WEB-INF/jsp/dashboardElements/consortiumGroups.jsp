<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 10/30/2020
  Time: 1:29 PM
  To change this template use File | Settings | File Templates.
--%>

<div class="card">
    <table>
        <tr><th>Consortium Groups</th></tr>
        <c:forEach items="${groupsMap}" var="m">
        <tr><td>
            <a href="members?group=${m.key}">${m.key}</a>
            <div id="${m.key}" style="display: none">
                <ul>
                    <c:forEach items="${m.value}" var="sg">
                        <li><a href="members?group=${sg}">${sg}</a></li>
                    </c:forEach>
                </ul>
            </div>
        </td></tr>
        </c:forEach>
    </table>


        </div>




