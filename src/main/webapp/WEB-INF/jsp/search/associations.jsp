<!--c:if test="${hit.sourceAsMap.studyNames!=null && category!='Study'}"-->

    <c:choose>
        <c:when test="${fn:length(hit.sourceAsMap.studyNames)==1}">
            <!--button type="button" class="btn btn-light btn-sm"><c:forEach items="${hit.sourceAsMap.studyNames}" var="map">
               <b>Study:</b>&nbsp; <a href="/toolkit/data/experiments/study/${map.key}" style="text-decoration: underline;color:#212529">${map.value}</a>
            </c:forEach>
            </button-->
        </c:when>
        <c:otherwise>

            <!--button type="button" class="btn btn-light btn-sm" data-container="body" data-trigger="click" data-toggle="popover" data-placement="bottom" data-popover-content="#popover-study-${hit.sourceAsMap.id}" title="Studies" style="background-color: transparent">
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
            </div-->
        </c:otherwise>
    </c:choose>

<!--/c:if-->
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

