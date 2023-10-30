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
<%@include file="resultHeader.jsp"%>

<table id="myTable" class="tablesorter">
    <thead>
    <tr>
        <%if(request.getAttribute("category")==null ||request.getAttribute("category")==""){%>
        <th>Category</th>
        <%}%>
        <%if(request.getAttribute("category")!=null && !(request.getAttribute("category").toString().equalsIgnoreCase("Guide"))){%>
        <th>Type</th>
        <%}%>
        <%if(request.getAttribute("category")!=null &&
                (request.getAttribute("category").toString().equalsIgnoreCase("Model System") ||request.getAttribute("category").toString().equalsIgnoreCase("Guide") )){%>
        <th>Organism</th>
        <%}%>
        <%if(request.getAttribute("category")!=null && !(request.getAttribute("category").toString().equalsIgnoreCase("Guide"))){%>

        <th>Subtype</th>
        <%}else{%>
        <th>Compatibility</th><%}%>
        <th>Name</th>
        <th>Description</th>
        <th>Source</th>
        <%if(access.isAdmin(person)){%>
        <th>Tier</th>
        <%}%>

        <%if(request.getAttribute("category")!=null && (request.getAttribute("category").toString().equalsIgnoreCase("experiment") || request.getAttribute("category").toString().equalsIgnoreCase("project"))){%>
        <th>Last Updated Date</th>
        <%}%>



        <th class="sorter-false">View Associated..</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${sr.hits.hits}" var="hit">

        <tr>
            <%if(request.getAttribute("category")==null ||request.getAttribute("category")==""){%>
            <td>${hit.sourceAsMap.category}</td>
            <%}%>
            <%if(request.getAttribute("category")!=null && !(request.getAttribute("category").toString().equalsIgnoreCase("Guide"))){%>

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
            <%}%>
            <%if(request.getAttribute("category")!=null && (request.getAttribute("category").toString().equalsIgnoreCase("Model System") || request.getAttribute("category").toString().equalsIgnoreCase("Guide"))){%>
            <td>
                <c:forEach items="${hit.sourceAsMap.modelOrganism}" var="t">
                    ${t}
                </c:forEach>
            </td>
            <%}%>
            <%if(request.getAttribute("category")!=null && !(request.getAttribute("category").toString().equalsIgnoreCase("Guide"))){%>

            <td>  <c:set var="type" value=""/>

                <c:if test="${hit.sourceAsMap.category=='Genome Editor'}">
                    <c:set var="type" value="${hit.sourceAsMap.editorSubType}"/>
                </c:if>
                <c:if test="${hit.sourceAsMap.category=='Model System'}">
                    <c:set var="type" value="${hit.sourceAsMap.modelSubtype}"/>
                </c:if>
                <c:if test="${hit.sourceAsMap.category=='Delivery System'}">
                    <c:set var="type" value="${hit.sourceAsMap.deliverySubtype}"/>
                </c:if>
                <c:if test="${hit.sourceAsMap.category=='Vector'}">
                    <c:set var="type" value="${hit.sourceAsMap.vectorSubtype}"/>
                </c:if>
                <c:forEach items="${type}" var="t">
                    ${t}
                </c:forEach>
            </td>
            <%}else{%>
            <td>

                        <c:forEach items="${hit.sourceAsMap.guideCompatibility}" var="t">
                            ${t}
                        </c:forEach>
            </td>
            <%}%>
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
            <td>
                <c:set var="source" value=""/>

                <c:if test="${hit.sourceAsMap.category=='Genome Editor'}">
                    <c:set var="source" value="${hit.sourceAsMap.editorSource}"/>
                </c:if>
                <c:if test="${hit.sourceAsMap.category=='Model System'}">
                    <c:set var="source" value="${hit.sourceAsMap.modelSource}"/>
                </c:if>
                <c:if test="${hit.sourceAsMap.category=='Delivery System'}">
                    <c:set var="source" value="${hit.sourceAsMap.deliverySource}"/>
                </c:if>
                <c:if test="${hit.sourceAsMap.category=='Vector'}">
                    <c:set var="source" value="${hit.sourceAsMap.vectorSource}"/>
                </c:if>
                <c:if test="${hit.sourceAsMap.category=='Guide'}">
                    <c:set var="source" value="${hit.sourceAsMap.guideSource}"/>
                </c:if>
                <c:forEach items="${source}" var="t">
                    ${t}
                </c:forEach>
            </td>
            <%if(access.isAdmin(person)){%>
            <td>${hit.sourceAsMap.tier}</td>
            <%}%>

            <%if(request.getAttribute("category")!=null && (request.getAttribute("category").toString().equalsIgnoreCase("experiment") || request.getAttribute("category").toString().equalsIgnoreCase("project"))){%>
            <td>
                <c:if test="${hit.sourceAsMap.lastModifiedDate!=null}">
                    ${hit.sourceAsMap.lastModifiedDate}
                </c:if>
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
