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
            <c:when test="${(hf.key=='name.ngram' ||hf.key=='name') && first=='true' }">
                <span class="header" style="color:#2a6496;"><strong>Name -></strong></span>
                <c:set var="first" value="false"/>
                <c:set var="fragmentsFirst" value="true"/>
                <c:forEach items="${hf.value.fragments}" var="f">
                    <c:choose>
                        <c:when test="${fragmentsFirst=='true'}">
                            <c:set var="fragmentsFirst" value="false"/>
                            &nbsp;${f}
                        </c:when>
                        <c:otherwise>
                            ;&nbsp;${f}
                        </c:otherwise>
                    </c:choose>

                </c:forEach>
            </c:when>
            <c:otherwise>
                <c:if test="${(hf.key!='name.ngram' && hf.key!='name')}">
                    <c:if test="${hf.key=='termSynonyms'}">
                        <span class="header" style="color:#2a6496;"><strong>Tissue/CellType Term Synonyms -></strong></span>

                    </c:if>
                    <c:if test="${hf.key!='termSynonyms'}">
                        <span class="header" style="color:#2a6496;"><strong>${hf.key} -></strong></span>

                    </c:if>
                    <c:set var="fragmentsFirst" value="true"/>
                    <c:forEach items="${hf.value.fragments}" var="f">
                        <c:choose>
                            <c:when test="${fragmentsFirst=='true'}">
                                <c:set var="fragmentsFirst" value="false"/>
                                &nbsp;${f}
                            </c:when>
                            <c:otherwise>
                                ;&nbsp;${f}
                            </c:otherwise>
                        </c:choose>

                    </c:forEach>
                </c:if>
            </c:otherwise>
        </c:choose>

    </c:forEach>
</div>
