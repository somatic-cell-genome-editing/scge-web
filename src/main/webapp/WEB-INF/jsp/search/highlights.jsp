<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/14/2021
  Time: 9:11 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div  class="more hideContent" style="overflow-y: auto">
    <span class="header"><strong>Matched on:</strong></span>
    <c:set value="true" var="first"/>
    <c:forEach items="${hit.highlightFields}" var="hf">
        <c:choose>
            <c:when test="${hf.key=='name.ngram'}">
                <span class="header" style="color:#2a6496;"><strong>Name -></strong></span>
            </c:when>
            <c:otherwise>
                <span class="header" style="color:#2a6496;"><strong>${hf.key} -></strong></span>
            </c:otherwise>
        </c:choose>
        <c:forEach items="${hf.value.fragments}" var="f">
            &nbsp;${f}
        </c:forEach>
    </c:forEach>
</div>
