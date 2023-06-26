<c:if test="${hit.sourceAsMap.studyNames!=null && (category=='Experiment' || hit.sourceAsMap.category=='Experiment')}">
    <div style="padding-top: 1%">

    <ul class="myUL">
    <li><span class="caret">Show Project</span>
    <div class="card" style="background-color: #f0ffff;border:transparent">
    <ul class="nested">
    <c:forEach items="${hit.sourceAsMap.studyNames}" var="map">

        <li><span><a class="search-results-anchor" href="/toolkit/data/experiments/study/${map.key}">${map.value}</a></span></li>

    </c:forEach>
    </ul>
    </div>
    </li>
    </ul>

    </div>

</c:if>
<c:if test="${hit.sourceAsMap.experimentNames!=null}">

    <div style="padding-top: 1%">

        <ul class="myUL">
            <li><span class="caret">Show Experiments (${fn:length(hit.sourceAsMap.experimentNames)})</span>
                <div class="card" style="background-color: #f0ffff;border:transparent">
                <ul class="nested">
                    <c:forEach items="${hit.sourceAsMap.experimentNames}" var="map">
                        <c:choose>
                            <c:when test="${userAccessExperimentIds!=null}">
                                <c:if test="${fn:contains(userAccessExperimentIds,map.key )}">
                                    <li><span><a class="search-results-anchor" href="/toolkit/data/experiments/experiment/${map.key}">${map.value}</a></span></li>

                                </c:if>
                            </c:when>
                            <c:otherwise>
                                <li><span><a class="search-results-anchor" href="/toolkit/data/experiments/experiment/${map.key}">${map.value}</a></span></li>

                            </c:otherwise>
                        </c:choose>

                    </c:forEach>

                </ul>
                </div>
            </li>
        </ul>

    </div>

</c:if>

