<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 3/15/2022
  Time: 12:16 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

    <small>
        <c:set var="first" value="true"/>
        <c:forEach items="${pub.authorList}" var="author">
            <c:choose>
            <c:when test="${first=='true'}">
            ${author.lastName}&nbsp;${author.initials}
                <c:set var="first" value="false"/>
            </c:when>
                <c:otherwise>
                    ,&nbsp;${author.lastName}&nbsp;${author.initials}
                </c:otherwise>
            </c:choose>
        </c:forEach>
    </small>
    <br>
<%--    <a style="text-decoration: underline; cursor: pointer" data-toggle="collapse" data-target="#refDetails${pub.reference.key}" aria-expanded="false" aria-controls="refDetails${pub.reference.key}" title="View Abstract">--%>
<%--    View Abstract--%>
<%--    </a>--%>

    <div  id="refDetails${pub.reference.key}">
    <!--strong style="color:grey">Date of publication:</strong><span style="color:green">$--{pub.reference.pubDate}</span-->
<%--    <br>--%>
<%--    <span >Article Ids:</span>--%>
    <c:forEach items="${pub.articleIds}" var="id">
        <c:choose>
            <c:when test="${id.url=='' || id.url==null}">
                ${fn:toUpperCase(id.idType)}:&nbsp;${id.id};&nbsp;

            </c:when>
            <c:otherwise>
                ${fn:toUpperCase(id.idType)}:<a href="${id.url}${id.id}" target="_blank">&nbsp;${id.id}</a>;&nbsp;

            </c:otherwise>
        </c:choose>
    </c:forEach>
    <br><br>
    <span style="font-weight: bold;">ABSTRACT:</span>
    <span>${pub.reference.refAbstract}</span>
        <c:if test="${pub.reference.meshTerms!=null && fn:length(pub.reference.meshTerms)>0}">
            <br><br><span><b>Mesh Terms:</b> ${pub.reference.meshTerms}</span>
        </c:if>
</div>
