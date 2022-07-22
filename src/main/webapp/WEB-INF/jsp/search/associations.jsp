<c:if test="${hit.sourceAsMap.studyNames!=null && category!='Study'}">

    <c:choose>
        <c:when test="${fn:length(hit.sourceAsMap.studyNames)==1}">
            <button type="button" class="btn btn-light btn-sm"><c:forEach items="${hit.sourceAsMap.studyNames}" var="map">
            <a href="/toolkit/data/experiments/study/${map.key}" style="text-decoration: underline;color:#212529">Study</a>
            </c:forEach>
            </button>
        </c:when>
        <c:otherwise>
            <button type="button" class="btn btn-light btn-sm" data-container="body" data-trigger="click" data-toggle="popover" data-placement="bottom" data-popover-content="#popover-study-${hit.sourceAsMap.id}" title="Studies" style="background-color: transparent">
                <span style="text-decoration:underline">Studies:&nbsp;${fn:length(hit.sourceAsMap.studyNames)}</span>
            </button>
            <div style="display: none" id="popover-study-${hit.sourceAsMap.id}">
                <div class="popover-body">
                    <c:set var="first" value="true"/>
                    <c:forEach items="${hit.sourceAsMap.studyNames}" var="map">
                        <c:choose>
                            <c:when test="${first=='true'}">
                                <a class="search-results-anchor" href="/toolkit/data/experiments/study/${map.key}">${map.value}</a>
                                <c:set var="first" value="false"/>
                            </c:when>
                            <c:otherwise>
                                <hr>
                                <a class="search-results-anchor" href="/toolkit/data/experiments/study/${map.key}">${map.value}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </div>
            </div>
        </c:otherwise>
    </c:choose>

</c:if>
<c:if test="${hit.sourceAsMap.experimentNames!=null}">
    <!--a  data-placement="top" data-popover-content="#popover-${hit.sourceAsMap.id}" data-toggle="popover" data-trigger="focus" href="" tabindex="0"> $-{fn:length(hit.sourceAsMap.experimentNames)}</a-->
    <c:choose>
        <c:when test="${fn:length(hit.sourceAsMap.experimentNames)==1}">
            <button type="button" class="btn btn-light btn-sm" >
                <c:forEach items="${hit.sourceAsMap.experimentNames}" var="map">
                <a href="/toolkit/data/experiments/experiment/${map.key}"><span style="text-decoration:underline;color:#212529">Experiment</span></a>
                </c:forEach>
            </button>
        </c:when>
        <c:otherwise>
            <button type="button" class="btn btn-light btn-sm" data-container="body" data-trigger="click" data-toggle="popover" data-placement="bottom" data-popover-content="#popover-${hit.sourceAsMap.id}" title="Experiments" style="background-color: transparent">
                <span style="text-decoration:underline">Experiments:&nbsp;${fn:length(hit.sourceAsMap.experimentNames)}</span>
            </button>
            <div style="display: none" id="popover-${hit.sourceAsMap.id}">
                <div class="popover-body">
                    <c:set var="first" value="true"/>
                    <c:forEach items="${hit.sourceAsMap.experimentNames}" var="map">
                        <c:choose>
                            <c:when test="${first=='true'}">
                                <a class="search-results-anchor" href="/toolkit/data/experiments/experiment/${map.key}">${map.value}</a>
                                <c:set var="first" value="false"/>
                            </c:when>
                            <c:otherwise>
                                <hr>
                                <a class="search-results-anchor" href="/toolkit/data/experiments/experiment/${map.key}">${map.value}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </div>
            </div>
        </c:otherwise>
    </c:choose>

</c:if>

