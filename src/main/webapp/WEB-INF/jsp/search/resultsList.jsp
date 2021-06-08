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
            <h6><a href="${hit.sourceAsMap.reportPageLink}${hit.sourceAsMap.id}">${hit.sourceAsMap.name}</a></h6>
            </c:if>
            <c:if test="${hit.sourceAsMap.symbol!=null}">
            <h6><a href="${hit.sourceAsMap.reportPageLink}${hit.sourceAsMap.id}">
                <c:choose>
                    <c:when test="${hit.sourceAsMap.subType=='Cas12j'}">
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
            </h6>
            </c:if>
            <!--span>Category:&nbsp;$-{hit.sourceAsMap.category}</span><br-->
            <c:if test="${hit.sourceAsMap.studyNames!=null}">
                <span>Study:&nbsp;</span>
                <c:forEach items="${hit.sourceAsMap.studyNames}" var="map">
                   <a href="/toolkit/data/experiments/study/${map.key}">${map.value}</a>&nbsp;
                </c:forEach>
                <br>
            </c:if>
            <c:if test="${hit.sourceAsMap.experimentNames!=null}">
                <span>Experiment:&nbsp;</span>
                <c:forEach items="${hit.sourceAsMap.experimentNames}" var="map">
                    <a href="/toolkit/data/experiments/experiment/${map.key}">${map.value}</a>&nbsp;
                </c:forEach>
                <br>
            </c:if>
            <c:if test="${hit.sourceAsMap.study.study!=null}">
                <span>Study:&nbsp;</span>
                <a href="/toolkit/data/experiments/study/${hit.sourceAsMap.study.studyId}">${hit.sourceAsMap.study.study}</a><br>
            </c:if>
            <c:if test="${hit.sourceAsMap.type!=null}">
            <span>${hit.sourceAsMap.category}&nbsp;Type:&nbsp; ${hit.sourceAsMap.type}</span><br>
            </c:if>
            <c:if test="${hit.sourceAsMap.subType!=null}">
            <span>${hit.sourceAsMap.category}&nbsp;SubType:&nbsp;${hit.sourceAsMap.subType}</span> <br>
            </c:if>
            <c:if test="${hit.sourceAsMap.target!=null}">
                <c:set var="first" value="true"/>
                <span>Target Tissue:
                <c:forEach items="${hit.sourceAsMap.target}" var="item">
                    <c:choose>
                    <c:when test="${first=='true'}">
                        ${item}
                        <c:set var="first" value="false"/>

                    </c:when>
                        <c:otherwise>
                           , ${item}

                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                </span> <br>
            </c:if>
            <c:if test="${hit.sourceAsMap.species!=null}">
                <span>Species:&nbsp;${hit.sourceAsMap.species}</span> <br>
            </c:if>

            <c:if test="${hit.sourceAsMap.description!=null}">
                <span>Description:&nbsp;${hit.sourceAsMap.description}</span><br>
            </c:if>
            <c:if test="${hit.sourceAsMap.experimentCount>0}">
                <i class="fas fa-eye"></i>
                <span><a href="${hit.sourceAsMap.reportPageLink}${hit.sourceAsMap.id}">Associated Experiments:&nbsp;${hit.sourceAsMap.experimentCount}</a></span> <br>
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

