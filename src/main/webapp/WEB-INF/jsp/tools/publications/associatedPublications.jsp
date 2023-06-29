<%@ page import="edu.mcw.scge.datamodel.publications.Publication" %>
<%List<Publication> associatedPublications= (List<Publication>) request.getAttribute("associatedPublications");%>
<% if(associatedPublications!=null && associatedPublications.size()>0 || access.isAdmin(p)){ %>
    <script>
    $(function() {
        $("#myTable-pub").tablesorter({
            theme : 'blue'

        });
        $("#myTable-pub2").tablesorter({
            theme : 'blue'

        });
    });
    </script>
<hr>
<table width="95%">
    <tr><td>
        <c:if test="${associatedPublications!=null && fn:length(associatedPublications)>0}">
            <h4 class="page-header" style="color:grey;">Associated Publications</h4>
        </c:if>
        </td>
            <% if (access.isAdmin(p) && !SCGEContext.isProduction()) { %>
        <td align="right"><a href="/toolkit/data/publications/associate?objectId=<%=objectId%>&redirectURL=<%=redirectURL%>" style="color:white;background-color:#007BFF; padding:10px;">Associate Publications</a></td>
    <%}%>
    </tr>
    </table>

<c:choose>
    <c:when test="${associatedPublications!=null && fn:length(associatedPublications)>0}">
        <table  id="myTable-pub" class="tablesorter">
            <thead>
            <tr>
                <% if (access.isAdmin(p) && !SCGEContext.isProduction()) {  %>
                <th></th>
                <% } %>
                <th>Publication Title</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${associatedPublications}" var="pub">
                <tr>
                    <% if (access.isAdmin(p) && !SCGEContext.isProduction()) {  %>
                    <td><a href="/toolkit/data/publications/removeAssociation?objectId=<%=objectId%>&refKey=${pub.reference.key}&redirectURL=<%=redirectURL%>" style="color:white;background-color:red; padding:7px;">Remove</a></td>
                    <% } %>
                    <td><c:set var="pmid" value=""/>
                        <c:forEach items="${pub.articleIds}" var="id">
                            <c:if test="${id.idType=='pubmed'}">
                                <c:set var="pmid" value="${id.id}"/>
                            </c:if>
                        </c:forEach>
                            ${pub.reference.title}&nbsp;<a href="https://pubmed.ncbi.nlm.nih.gov/${pmid}" target="_blank">NCBI</a></td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

    </c:when>
</c:choose>
<%}%>
<c:if test="${relatedPublications!=null && fn:length(relatedPublications)>0}">
    <hr>
    <%@include file="relatedPublications.jsp"%>
</c:if>

