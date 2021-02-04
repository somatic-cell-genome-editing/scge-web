<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 10/8/2020
  Time: 3:08 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div>
    <ul>
        <c:forEach items="${files}" var="file">
            <li>
                <a href="${file}">${file}</a>

            </li>
        </c:forEach>
    </ul>
</div>

