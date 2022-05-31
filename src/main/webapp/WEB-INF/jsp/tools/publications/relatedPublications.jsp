<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 3/15/2022
  Time: 11:16 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<table width="95%">
    <tr><td><h4 class="page-header" style="color:grey;">Related Publications</h4></td></tr>
</table>
<c:choose>
    <c:when test="${fn:length(relatedPublications)>0}">
        <table  id="myTable-pub2" class="tablesorter">
            <thead>
            <tr>
                <% if (access.isAdmin(p)) {  %>
                <th></th>
                <% } %>
                <th>Publication Title</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${relatedPublications}" var="pub">
                <tr>
                    <% if (access.isAdmin(p)) {  %>
                    <td><a href="/toolkit/data/publications/removeAssociation?objectId=<%=objectId%>&refKey=${pub.reference.key}&redirectURL=<%=redirectURL%>" style="color:white;background-color:red; padding:7px;">Remove</a></td>
                    <% } %>
                    <td><c:set var="pmid" value=""/>
                        <c:forEach items="${pub.articleIds}" var="id">
                            <c:if test="${id.idType=='pubmed'}">
                                <c:set var="pmid" value="${id.id}"/>
                            </c:if>
                        </c:forEach>
                        <a href="https://pubmed.ncbi.nlm.nih.gov/${pmid}" target="_blank">${pub.reference.title}</a></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

    </c:when>
    <c:otherwise>
        &nbsp;&nbsp;None Associated

    </c:otherwise>
</c:choose>
&nbsp;&nbsp;