<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 1/22/2021
  Time: 1:40 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script>
    $(function() {
        $("#myTable").tablesorter({
            theme : 'blue'

        });
    });
</script>
<h4>${sr.hits.totalHits} <c:if test="${category!=null}">&nbsp;in ${category}</c:if> </h4>
<table id="myTable" class="tablesorter">
    <thead>
    <tr>
        <th>Category</th>
        <th>Type</th>
        <th>Subtype</th>
        <th>Symbol</th>
        <th>Name</th>
        <th>Matched Fields</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${sr.hits.hits}" var="hit">

        <tr>
            <td>${hit.sourceAsMap.category}</td>

            <td>${hit.sourceAsMap.type}</td>
            <td>${hit.sourceAsMap.subType}</td>
            <td>
                <c:choose>
                    <c:when test="${hit.sourceAsMap.subType=='Cas12'}">
                        <c:if test="${fn:contains(hit.sourceAsMap.symbol,'-1')}">
                            cas&#934;-1
                        </c:if>
                        <c:if test="${fn:contains(hit.sourceAsMap.symbol,'-3')}">
                            cas&#934;-3
                        </c:if>
                        <c:if test="${fn:contains(hit.sourceAsMap.symbol,'-2')}">
                            cas&#934;-2
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        ${hit.sourceAsMap.symbol}
                    </c:otherwise>
                </c:choose>
            </td>
            <td> <a href="${hit.sourceAsMap.reportPageLink}${hit.sourceAsMap.id}">${hit.sourceAsMap.name}</a></td>
            <td>
                <div  class="more hideContent" style="overflow-y: auto">
                    <c:set value="true" var="first"/>
                    <c:forEach items="${hit.highlightFields}" var="hf">
                        <span style="font-weight: bold">${hf.key} -></span>
                        <c:forEach items="${hf.value.fragments}" var="f">
                            ${f} ;
                        </c:forEach>
                        <br>
                    </c:forEach>
                </div>
            </td>
        </tr>

    </c:forEach>

    </tbody>
</table>
