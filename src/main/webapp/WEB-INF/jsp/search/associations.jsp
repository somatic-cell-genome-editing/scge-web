<c:if test="${hit.sourceAsMap.studyNames!=null && (category=='Experiment' || hit.sourceAsMap.category=='Experiment')}">
    <div>

    <ul class="myUL">
    <li><span class="caret">Projects</span>
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

    <div>

        <ul class="myUL">
            <li><span class="caret">Experiments</span>
                <div class="card" style="background-color: #f0ffff;border:transparent">
                <ul class="nested">
                    <c:forEach items="${hit.sourceAsMap.experimentNames}" var="map">
                        <li><span><a class="search-results-anchor" href="/toolkit/data/experiments/experiment/${map.key}">${map.value}</a></span></li>

                    </c:forEach>

                </ul>
                </div>
            </li>
        </ul>

    </div>

</c:if>

