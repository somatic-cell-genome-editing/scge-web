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
<h4>${sr.hits.totalHits} <c:if test="${category!=null}">&nbsp;in ${category}</c:if> </h4>
<table class="table table-striped">
    <c:forEach items="${sr.hits.hits}" var="hit">
    <tr><td>
        <div>
            <c:if test="${hit.sourceAsMap.name!=null}">
            <h5><a href="${hit.sourceAsMap.reportPageLink}${hit.sourceAsMap.id}">${hit.sourceAsMap.name}</a></h5>
            </c:if>
            <c:if test="${hit.sourceAsMap.symbol!=null}">
            <h5><a href="${hit.sourceAsMap.reportPageLink}${hit.sourceAsMap.id}">
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
            </a>
            </h5>
            </c:if>
            <span><strong>Category:</strong>&nbsp;${hit.sourceAsMap.category}</span><br>
            <c:if test="${hit.sourceAsMap.type!=null}">
            <span><strong>Type:</strong>&nbsp;${hit.sourceAsMap.type}</span><br>
            </c:if>
            <c:if test="${hit.sourceAsMap.subType!=null}">
            <span><strong>SubType:</strong>&nbsp;${hit.sourceAsMap.subType}</span> <br>
            </c:if>

            <c:if test="${hit.sourceAsMap.description!=null}">
                <span><strong>Description:</strong>&nbsp;${hit.sourceAsMap.description}</span>
            </c:if>

                <!--div  class="more hideContent" style="overflow-y: auto">
                    <strong style="text-decoration: underline">Matched on:</strong>
                    <c:set value="true" var="first"/>
                    <c:forEach items="${hit.highlightFields}" var="hf">
                        <span style="font-weight: bold">${hf.key} -></span>
                        <c:forEach items="${hf.value.fragments}" var="f">
                            ${f} ;
                        </c:forEach>
                        <br>
                    </c:forEach>
                </div-->

        </div>
    </td></tr>
    </c:forEach>
</table>

