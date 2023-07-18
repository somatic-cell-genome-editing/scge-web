<c:if test="${hit.sourceAsMap.studyNames!=null && (category=='Experiment' || hit.sourceAsMap.category=='Experiment')}">
    <div style="padding-top: 1%">

    <details>
        <summary>Show Project</summary>
        <p>

    <c:forEach items="${hit.sourceAsMap.studyNames}" var="map">

        <span style="margin-left: 2%;"><a class="search-results-anchor" href="/toolkit/data/experiments/study/${map.key}">${map.value}</a></span>
<br>
    </c:forEach>
    </p>

    </details>

    </div>

</c:if>
<c:if test="${hit.sourceAsMap.experimentNames!=null}">

    <div style="padding-top: 1%">

        <details>
            <summary>Show Experiments (${fn:length(hit.sourceAsMap.experimentNames)})</summary>
            <p>

                    <c:forEach items="${hit.sourceAsMap.experimentNames}" var="map">
                        <c:choose>
                            <c:when test="${userAccessExperimentIds!=null}">
                                <c:if test="${fn:contains(userAccessExperimentIds,map.key )}">
                                    <span style="margin-left: 2%;"><a class="search-results-anchor" href="/toolkit/data/experiments/experiment/${map.key}">${map.value}</a></span>
                                    <br>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <span style="margin-left: 2%;"><a class="search-results-anchor" href="/toolkit/data/experiments/experiment/${map.key}">${map.value}</a></span>
                                    <br>
                            </c:otherwise>
                        </c:choose>

                    </c:forEach>


            </p>

        </details>

    </div>

</c:if>

