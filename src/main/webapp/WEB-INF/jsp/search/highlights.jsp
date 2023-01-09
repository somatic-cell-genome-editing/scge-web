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
    <c:set value="true" var="name"/>
    <c:set value="true" var="symbol"/>
    <c:set value="true" var="editorType"/>
    <c:set value="true" var="esitorSubType"/>
    <c:set value="true" var="grnaLabId"/>
    <c:set value="true" var="guideTargetLocus"/>
    <c:forEach items="${hit.highlightFields}" var="hf">
        <c:if test="${!fn:contains(hf.key, 'accessLevel')}">
        <b>${fn:substringBefore(hf.key, "." )}&nbsp;--></b>
            <c:forEach items="${hf.value.fragments}" var="f">
                        &nbsp;${f}

            </c:forEach>
        </c:if>


    </c:forEach>
</div>
