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
        <%if(request.getAttribute("category")!=null && !(request.getAttribute("category").toString().equalsIgnoreCase("Guide"))
                && !(request.getAttribute("category").toString().equalsIgnoreCase("Protocol"))){%>
        <th>Type</th>
        <%}%>
        <%if(request.getAttribute("category")!=null &&
                (request.getAttribute("category").toString().equalsIgnoreCase("Model System") ||request.getAttribute("category").toString().equalsIgnoreCase("Guide") )){%>
        <th>Organism</th>
        <%}%>
        <%if(request.getAttribute("category")!=null && !(request.getAttribute("category").toString().equalsIgnoreCase("Guide"))
                && !(request.getAttribute("category").toString().equalsIgnoreCase("Protocol"))){%>

        <th>Subtype</th>
        <%}
            if(request.getAttribute("category")!=null && (request.getAttribute("category").toString().equalsIgnoreCase("Guide"))){%>
        <th>Compatibility</th>
        <%}%>
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
    <%
        for(SearchHit searchHit:hits){
            Map<String, Object> hit=  searchHit.getSourceAsMap();
    %>


        <tr>
            <%if(request.getAttribute("category")==null ||request.getAttribute("category")==""){%>
            <td><%=hit.get("category")%></td>
            <%}%>
            <%if(request.getAttribute("category")!=null && !(request.getAttribute("category").toString().equalsIgnoreCase("Guide"))
                    && !(request.getAttribute("category").toString().equalsIgnoreCase("Protocol"))){%>

            <td>
                <%List<String> type=new ArrayList<>();
                if(hit.get("category")!=null && hit.get("category").toString().equalsIgnoreCase("Experiment") && hit.get("experimentType")!=null)
                    type= (List<String>) hit.get("experimentType");
                    if(hit.get("category")!=null && hit.get("category").toString().equalsIgnoreCase("Genome Editor") && hit.get("editorType")!=null)
                        type= (List<String>) hit.get("editorType");
                    if(hit.get("category")!=null && hit.get("category").toString().equalsIgnoreCase("Model System") && hit.get("modelType")!=null)
                        type= (List<String>) hit.get("modelType");
                    if(hit.get("category")!=null && hit.get("category").toString().equalsIgnoreCase("Delivery System") && hit.get("deliveryType")!=null)
                        type= (List<String>) hit.get("deliveryType");
                    if(hit.get("category")!=null && hit.get("category").toString().equalsIgnoreCase("Vector") && hit.get("vectorType")!=null)
                        type= (List<String>) hit.get("vectorType");


                    if(type!=null){
                        for(String t:type){
                %>
               <%=t%>
                <%}}%>
            </td>
            <%}%>
            <%if(request.getAttribute("category")!=null && (request.getAttribute("category").toString().equalsIgnoreCase("Model System") || request.getAttribute("category").toString().equalsIgnoreCase("Guide"))){%>
            <td>

                <%if(hit.get("modelOrganism")!=null)
                    for(String model:(List<String>)hit.get("modelOrganism")){%>
                    <%=model%>
                <%}%>
            </td>
            <%}%>
            <%if(request.getAttribute("category")!=null && !(request.getAttribute("category").toString().equalsIgnoreCase("Guide"))
                    && !(request.getAttribute("category").toString().equalsIgnoreCase("Protocol"))){%>

            <td>

                <%List<String> type=new ArrayList<>();
                    if(hit.get("category")!=null && hit.get("category").toString().equalsIgnoreCase("Genome Editor") && hit.get("editorSubType")!=null)
                        type= (List<String>) hit.get("editorSubType");
                    if(hit.get("category")!=null && hit.get("category").toString().equalsIgnoreCase("Model System") && hit.get("modelSubtype")!=null)
                        type= (List<String>) hit.get("modelSubtype");
                    if(hit.get("category")!=null && hit.get("category").toString().equalsIgnoreCase("Delivery System") && hit.get("deliverySubtype")!=null)
                        type= (List<String>) hit.get("deliverySubtype");
                    if(hit.get("category")!=null && hit.get("category").toString().equalsIgnoreCase("Vector") && hit.get("vectorSubtype")!=null)
                        type= (List<String>) hit.get("vectorSubtype");
                    if(type.size()>0){
                        for(String t: type){
                %>
                <%=t%>
                <%}}%>
            </td>
            <%}if(request.getAttribute("category")!=null && (request.getAttribute("category").toString().equalsIgnoreCase("Guide"))){%>
            <td>
                        <%if(hit.get("guideCompatibility")!=null)
                            for(String compatibility: (List<String>)hit.get("guideCompatibility")){%>
                        <%=compatibility%>>
                <%}%>
            </td>
            <%}%>
            <td>
                <% if(hit.get("name")!=null){%>
                <%if(hit.get("studyType")!=null && hit.get("studyType").toString().equalsIgnoreCase("Validation")){%>
                <span title="Validation Study" style="color:darkorange;font-weight: bold;font-size: large;color:darkorange"> [Validation]</span>
                <%}if(hit.get("reportPageLink")!=null){%>

                <a class="search-results-anchor" href="<%=hit.get("reportPageLink")%><%=hit.get("id")%>"><%=hit.get("name")%></a>
                <%}else{%>
                <%=hit.get("name")%>&nbsp;<%if(hit.get("externalLink")!=null){%>
                <a href="<%=hit.get("externalLink")%>"><i class="fa fa-external-link" aria-hidden="true"></i></a>

                <%}}}
                    if(hit.get("symbol")!=null){%>

                <%if(hit.get("studyType")!=null && hit.get("studyType").toString().equalsIgnoreCase("Validation")){%>
                <span title="Validation Study" style="color:darkorange;font-weight: bold;font-size: large;color:darkorange"> [Validation]</span>
                <%}if(hit.get("reportPageLink")!=null){%>

                <a class="search-results-anchor" href="<%=hit.get("reportPageLink")%><%=hit.get("id")%>"><%=hit.get("symbol")%></a>
                <%}else{%>
                <%=hit.get("symbol")%>&nbsp;<%if(hit.get("externalLink")!=null){%>
                <a href="<%=hit.get("externalLink")%>"><i class="fa fa-external-link" aria-hidden="true"></i></a>

                <%}}}%>







<%--                <c:choose>--%>
<%--                    <c:when test="${hit.sourceAsMap.symbol!=null}">--%>

<%--                        <c:choose>--%>
<%--                            <c:when test="${hit.sourceAsMap.reportPageLink!=null}">--%>
<%--                                <a class="search-results-anchor" href="${hit.sourceAsMap.reportPageLink}${hit.sourceAsMap.id}">--%>
<%--                                        ${hit.sourceAsMap.symbol}</a>--%>
<%--                            </c:when>--%>
<%--                            <c:otherwise>--%>
<%--                                ${hit.sourceAsMap.symbol}&nbsp;--%>
<%--                                <c:if test="${hit.sourceAsMap.externalLink!=null}">--%>
<%--                                    <a href="${hit.sourceAsMap.externalLink}"><i class="fa fa-external-link" aria-hidden="true"></i></a>--%>
<%--                                </c:if>--%>
<%--                            </c:otherwise>--%>
<%--                        </c:choose>--%>
<%--                    </c:when>--%>
<%--                    <c:otherwise>--%>
<%--                        <c:choose>--%>
<%--                            <c:when test="${hit.sourceAsMap.reportPageLink!=null}">--%>
<%--                                <a class="search-results-anchor" href="${hit.sourceAsMap.reportPageLink}${hit.sourceAsMap.id}">--%>
<%--                                        ${hit.sourceAsMap.name}</a>--%>
<%--                            </c:when>--%>
<%--                            <c:otherwise>--%>
<%--                                ${hit.sourceAsMap.name}&nbsp;--%>
<%--                                <c:if test="${hit.sourceAsMap.externalLink!=null}">--%>
<%--                                    <a href="${hit.sourceAsMap.externalLink}"><i class="fa fa-external-link" aria-hidden="true"></i></a>--%>
<%--                                </c:if>--%>
<%--                            </c:otherwise>--%>
<%--                        </c:choose>                    --%>
<%--                    </c:otherwise>--%>
<%--                </c:choose>--%>

            </td>
            <td><%if(hit.get("description")!=null){%>
                <%=hit.get("description")%></td>
            <%}%>
            <td>
                <%List<String> source=new ArrayList<>();
                    if(hit.get("category")!=null && hit.get("category").toString().equalsIgnoreCase("Guide") && hit.get("guideSource")!=null)
                        source= (List<String>) hit.get("guideSource");
                    if(hit.get("category")!=null && hit.get("category").toString().equalsIgnoreCase("Genome Editor") && hit.get("editorSource")!=null)
                        source= (List<String>) hit.get("editorSource");
                    if(hit.get("category")!=null && hit.get("category").toString().equalsIgnoreCase("Model System") && hit.get("modelSource")!=null)
                        source= (List<String>) hit.get("modelSource");
                    if(hit.get("category")!=null && hit.get("category").toString().equalsIgnoreCase("Delivery System") && hit.get("deliverySource")!=null)
                        source= (List<String>) hit.get("deliverySource");
                    if(hit.get("category")!=null && hit.get("category").toString().equalsIgnoreCase("Vector") && hit.get("vectorSource")!=null)
                        source= (List<String>) hit.get("vectorSource");
                    if(source.size()>0){
                        for(String s:source){

                %>
                <%=s%>
                <%}%>
                <%}%>





<%--                <c:set var="source" value=""/>--%>

<%--                <c:if test="${hit.sourceAsMap.category=='Genome Editor'}">--%>
<%--                    <c:set var="source" value="${hit.sourceAsMap.editorSource}"/>--%>
<%--                </c:if>--%>
<%--                <c:if test="${hit.sourceAsMap.category=='Model System'}">--%>
<%--                    <c:set var="source" value="${hit.sourceAsMap.modelSource}"/>--%>
<%--                </c:if>--%>
<%--                <c:if test="${hit.sourceAsMap.category=='Delivery System'}">--%>
<%--                    <c:set var="source" value="${hit.sourceAsMap.deliverySource}"/>--%>
<%--                </c:if>--%>
<%--                <c:if test="${hit.sourceAsMap.category=='Vector'}">--%>
<%--                    <c:set var="source" value="${hit.sourceAsMap.vectorSource}"/>--%>
<%--                </c:if>--%>
<%--                <c:if test="${hit.sourceAsMap.category=='Guide'}">--%>
<%--                    <c:set var="source" value="${hit.sourceAsMap.guideSource}"/>--%>
<%--                </c:if>--%>
<%--                <c:forEach items="${source}" var="t">--%>
<%--                    ${t}--%>
<%--                </c:forEach>--%>
            </td>
            <%if(access.isAdmin(person)){%>
            <td><%=hit.get("tier")%></td>
            <%}%>

            <%if(request.getAttribute("category")!=null && (request.getAttribute("category").toString().equalsIgnoreCase("experiment") || request.getAttribute("category").toString().equalsIgnoreCase("project"))){%>
            <td>
                <%if(hit.get("lastModifiedDate")!=null){%>

                   <%=hit.get("lastModifiedDate")%>

                <%}%>
            </td>
            <%}%>


            <td>
                <%@include file="associations.jsp"%>
            </td>

<%--            <!--td>--%>
<%--                <div  class="more hideContent" style="overflow-y: auto">--%>
<%--                    <c:set value="true" var="first"/>--%>
<%--                    <c:forEach items="${hit.highlightFields}" var="hf">--%>
<%--                        <c:choose>--%>
<%--                            <c:when test="${hf.key=='name.ngram'}">--%>
<%--                                <span class="header" style="color:#2a6496;"><strong>Name -></strong></span>--%>
<%--                            </c:when>--%>
<%--                            <c:otherwise>--%>
<%--                                <span class="header" style="color:#2a6496;"><strong>${hf.key} -></strong></span>--%>
<%--                            </c:otherwise>--%>
<%--                        </c:choose>--%>
<%--                        <c:forEach items="${hf.value.fragments}" var="f">--%>
<%--                            ${f} ;--%>
<%--                        </c:forEach>--%>
<%--                        <br>--%>
<%--                    </c:forEach>--%>
<%--                </div>--%>
<%--            </td-->--%>
        </tr>


<%}%>
    </tbody>
</table>
