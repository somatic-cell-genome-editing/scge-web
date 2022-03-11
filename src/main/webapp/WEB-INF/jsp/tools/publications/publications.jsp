<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 3/7/2022
  Time: 10:37 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div class="container" style="height: available">
    <table class="table">
    <c:forEach items="${publications}" var="pub">

        <tr><td>
        <div>
            <h5><a href="/toolkit/data/experiments/study/${pub.articleIds[0].scgeId}" >${pub.reference.title}</a></h5>
            <small>
            <c:forEach items="${pub.authorList}" var="author">
                ${author.firstName},${author.lastName}, ${author.initials};&nbsp;
            </c:forEach>
            </small>
            <br>
            <strong style="color:grey">Date of publication:</strong><span style="color:green">${pub.reference.pubDate}</span>
            <br>
            <strong style="color:grey">Article Ids:</strong>
            <c:forEach items="${pub.articleIds}" var="id">
                <c:choose>
                    <c:when test="${id.url=='' || id.url==null}">
                       ${id.id};&nbsp;

                    </c:when>
                    <c:otherwise>
                        <a href="${id.url}${id.id}">${id.id}</a>;&nbsp;

                    </c:otherwise>
                </c:choose>
            </c:forEach>
            <br>
            <span style="font-weight: bold;color:grey">Abstract:</span>
            <span>${pub.reference.refAbstract}</span>
        </div>
            </td></tr>
    </c:forEach>
    </table>
</div>

