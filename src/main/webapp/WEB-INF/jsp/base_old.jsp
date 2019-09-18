<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 8/23/2019
  Time: 9:05 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<html lang="en">
<head>
    <title>SCGE - Add member</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
</head>
<body>
<div class="navbar navbar-default">
    <div class="container">
        <div class="navbar-header">
            <div class="navbar-brand"><img src="https://scge.mcw.edu/wp-content/uploads/2019/03/SCGElogo-50.jpg" srcset="https://scge.mcw.edu/wp-content/uploads/2019/03/SCGElogo-50.jpg 1x" width="72" height="50" alt="Somatic Cell Gene Editing Logo" data-retina_logo_url="" class="fusion-standard-logo" /></div>
        </div>
        <ul class="nav navbar-nav">
            <li><a href="/"></a></li>
            <li><a href=""></a></li>
        </ul>
        <p class="navbar-text navbar-right">
            <c:choose>
                <c:when test="${not empty token}">
                    <!-- using pageContext requires jsp-api artifact in pom.xml -->
                    <a href="logout">
                        <c:if test="${not empty userImageUrl}">
                            <img class="img-circle" src="${fn:escapeXml(userImageUrl)}" width="24">
                        </c:if>
                            ${fn:escapeXml(userEmail)}
                    </a>
                </c:when>
                <c:when test="${isAuthConfigured}">
                    <a href="login">Login</a>
                </c:when>
            </c:choose>
        </p>
    </div>
</div>
<c:import url="/${page}.jsp" />
</body>
</html>