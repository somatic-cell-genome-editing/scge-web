<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 6/2/2023
  Time: 10:43 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:choose>
  <c:when test="${action!=null && category!=null}">
    <h4>${fn:length(sr.hits.hits)}&nbsp;results<c:if test="${action!=null && category!=null && action!='Search Results'}">&nbsp;in ${action} </c:if><c:if test="${searchTerm!=null && searchTerm!=''}">&nbsp;for search term '${searchTerm}'</c:if> <c:if test="${category!=null && searchTerm!=null && searchTerm!='' }">&nbsp;in category ${category}</c:if> </h4>
  </c:when>
  <c:otherwise>
    <h4>${action} </h4>
  </c:otherwise>
</c:choose>
