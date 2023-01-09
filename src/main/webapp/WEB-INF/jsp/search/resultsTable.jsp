<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 1/22/2021
  Time: 1:40 PM
  To change this template use File | Settings | File Templates.
--%>

<script>
    $(function() {
        $("#myTable").tablesorter({
            theme : 'blue'

        });
    });
</script>
<c:choose>
<c:when test="${action!=null && category!=null}">
<h4>${fn:length(sr.hits.hits)}&nbsp;results<c:if test="${action!=null && category!=null}">&nbsp;in ${action}</c:if> </h4>
    </c:when>
<c:otherwise>
    <h4>${action} </h4>
</c:otherwise>
</c:choose>
<table id="myTable" class="tablesorter">
    <thead>
    <tr>
        <th>Category</th>
        <th>Type</th>
        <th>Name</th>
        <th>Description</th>
        <%if(access.isAdmin(person)){%>
        <th>Tier</th>
        <%}%>
        <th class="sorter-false">View Associated..</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${sr.hits.hits}" var="hit">

        <tr>
            <td>${hit.sourceAsMap.category}</td>
            <td>
                <c:set var="type" value=""/>
            <c:if test="${hit.sourceAsMap.category=='Experiment'}">
                <c:set var="type" value="${hit.sourceAsMap.experimentType}"/>
            </c:if>
                <c:if test="${hit.sourceAsMap.category=='Genome Editor'}">
                    <c:set var="type" value="${hit.sourceAsMap.editorType}"/>
                </c:if>
                <c:if test="${hit.sourceAsMap.category=='Model System'}">
                    <c:set var="type" value="${hit.sourceAsMap.modelType}"/>
                </c:if>
                <c:if test="${hit.sourceAsMap.category=='Delivery System'}">
                    <c:set var="type" value="${hit.sourceAsMap.deliveryType}"/>
                </c:if>
                <c:if test="${hit.sourceAsMap.category=='Vector'}">
                    <c:set var="type" value="${hit.sourceAsMap.vectorType}"/>
                </c:if>
                <c:forEach items="${type}" var="t">
                    ${t}
                </c:forEach>
            </td>

            <td>
                <c:choose>
                    <c:when test="${hit.sourceAsMap.symbol!=null}">

                        <c:choose>
                            <c:when test="${hit.sourceAsMap.reportPageLink!=null}">
                                <a class="search-results-anchor" href="${hit.sourceAsMap.reportPageLink}${hit.sourceAsMap.id}">
                                        ${hit.sourceAsMap.symbol}</a>
                            </c:when>
                            <c:otherwise>
                                ${hit.sourceAsMap.symbol}&nbsp;
                                <c:if test="${hit.sourceAsMap.externalLink!=null}">
                                    <a href="${hit.sourceAsMap.externalLink}"><i class="fa fa-external-link" aria-hidden="true"></i></a>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <c:choose>
                            <c:when test="${hit.sourceAsMap.reportPageLink!=null}">
                                <a class="search-results-anchor" href="${hit.sourceAsMap.reportPageLink}${hit.sourceAsMap.id}">
                                        ${hit.sourceAsMap.name}</a>
                            </c:when>
                            <c:otherwise>
                                ${hit.sourceAsMap.name}&nbsp;
                                <c:if test="${hit.sourceAsMap.externalLink!=null}">
                                    <a href="${hit.sourceAsMap.externalLink}"><i class="fa fa-external-link" aria-hidden="true"></i></a>
                                </c:if>
                            </c:otherwise>
                        </c:choose>                    </c:otherwise>
                </c:choose>

            </td>
            <td>${hit.sourceAsMap.description}</td>
            <%if(access.isAdmin(person)){%>
            <td>
                    ${hit.sourceAsMap.tier}
            </td>
            <%}%>
            <td>
                <%@include file="associations.jsp"%>
            </td>
            <!--td>
                <div  class="more hideContent" style="overflow-y: auto">
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
                            ${f} ;
                        </c:forEach>
                        <br>
                    </c:forEach>
                </div>
            </td-->
        </tr>

    </c:forEach>

    </tbody>
</table>
