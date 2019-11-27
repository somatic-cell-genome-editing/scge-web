<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 8/16/2019
  Time: 10:17 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<h1>Form submitted successfully. Below data is inserted into database.</h1>
<table>

    <tr><td>Name</td><td>Symbol</td></tr>
        <c:forEach items="${records}" var="item">
            <tr><td>${item.name}</td><td>${item.symbol}</td></tr>

        </c:forEach>
</table>
<script src="https://apis.google.com/js/platform.js?onload=onLoad" async defer></script>