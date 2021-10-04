<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 1/22/2021
  Time: 1:40 PM
  To change this template use File | Settings | File Templates.
--%>
<style>
    .header{
        font-size: .9rem;
        color:slategrey;
    }
</style>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>

<script>
    $(function() {
        $("#myTable").tablesorter({
            theme: 'blue'

        });
        $('[data-toggle="popover"]').popover({
            html: true,
            content: function () {
                var content = $(this).attr("data-popover-content");
                return $(content).children(".popover-body").html();
            }

        })
            .on("focus", function () {
            $(this).popover("show");
        }).on("focusout", function () {
            var _this = this;
            if (!$(".popover:hover").length) {
                $(this).popover("hide");
            } else {
                $('.popover').mouseleave(function () {
                    $(_this).popover("hide");
                    $(this).off('mouseleave');
                });
            }
        });
        $(".collapse").on('show.bs.collapse', function(){
            $(this).prev(".card-header").find(".fas").removeClass("fa-angle-up").addClass("fa-angle-down");
        }).on('hide.bs.collapse', function(){
            $(this).prev(".card-header").find(".fas").removeClass("fa-angle-down").addClass("fa-angle-up");
        });
    })

</script>
<h4>${sr.hits.totalHits} <c:if test="${category!=null}">&nbsp;in ${category}</c:if> </h4>
<table class="table table-striped">
    <c:forEach items="${sr.hits.hits}" var="hit">
    <tr><td>
        <div>
            <div>
                <div >
            <c:if test="${hit.sourceAsMap.name!=null}">
            <h6><a href="${hit.sourceAsMap.reportPageLink}${hit.sourceAsMap.id}">${hit.sourceAsMap.name}</a> &nbsp; -  <small class="text-muted">${hit.sourceAsMap.category}
            <c:if test="${hit.sourceAsMap.type!=null}">
               -  ${hit.sourceAsMap.type}
            </c:if>
            </small>
                
                <button class="btn btn-sm" type="button" data-toggle="collapse" data-target="#highlights-${hit.sourceAsMap.id}" aria-expanded="false" aria-controls="highlights-${hit.sourceAsMap.id}" title="View highlights">
              +
            </button></h6>
            </c:if>
            <c:if test="${hit.sourceAsMap.symbol!=null}">
            <h6><a href="${hit.sourceAsMap.reportPageLink}${hit.sourceAsMap.id}">${hit.sourceAsMap.symbol}</a>&nbsp; -  <small class="text-muted">${hit.sourceAsMap.category}
            </small><button class="btn  btn-sm" type="button" data-toggle="collapse" data-target="#highlights-${hit.sourceAsMap.id}" aria-expanded="false" aria-controls="highlights-${hit.sourceAsMap.id}" title="View highlights">
                +
            </button></h6>
            </c:if>
                    <div class="collapse" id="highlights-${hit.sourceAsMap.id}">
                        <div class="card card-body">
                    <%@include file="highlights.jsp"%>
                        </div>
                    </div>
                </div>
            <small>${hit.sourceAsMap.study.pi}</small>
            </div>
            <c:if test="${hit.sourceAsMap.description!=null}">
                <span><span class="header"></span>&nbsp;${hit.sourceAsMap.description}</span><br>
            </c:if>
            <!--c:if test="$-{hit.sourceAsMap.type!=null}"-->
                <!--span><span class="header">$-{hit.sourceAsMap.category}&nbsp;Type:&nbsp;</span> $-{hit.sourceAsMap.type}</span><br-->
            <!--/c:if-->
            <c:if test="${hit.sourceAsMap.subType!=null}">
                <span><span class="header"><strong>${hit.sourceAsMap.category}&nbsp;SubType:</strong></span>&nbsp;${hit.sourceAsMap.subType}</span> <br>
            </c:if>

            <c:if test="${hit.sourceAsMap.species!=null}">
                <span><span class="header"><strong>Species:</strong></span>&nbsp;${hit.sourceAsMap.species}</span> <br>
            </c:if>
            <c:if test="${hit.sourceAsMap.target!=null && hit.sourceAsMap.category=='Experiment'}">
                <c:set var="first" value="true"/>
                <span><span class="header">Target Tissue :</span>
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
            <c:if test="${hit.sourceAsMap.guides!=null && hit.sourceAsMap.category=='Experiment'}">
                <c:set var="first" value="true"/>
                <span><span class="header">Target Locus :</span>
                <c:forEach items="${hit.sourceAsMap.guides}" var="guide">
                    <c:choose>
                        <c:when test="${first=='true'}">
                            ${guide.targetLocus}
                            <c:set var="first" value="false"/>

                        </c:when>
                        <c:otherwise>
                            , ${guide.targetLocus}

                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                </span> <br>
            </c:if>
            <c:if test="${hit.sourceAsMap.studyNames!=null}">
                <span class="header">Associated Studies:</span>

                <button type="button" class="btn btn-light btn-sm" data-container="body" data-toggle="popover" data-placement="bottom" data-popover-content="#popover-study-${hit.sourceAsMap.id}" title="Studies" style="background-color: transparent">
                    <span style="text-decoration:underline">${fn:length(hit.sourceAsMap.studyNames)}</span>
                </button>
                <div style="display: none" id="popover-study-${hit.sourceAsMap.id}">
                    <div class="popover-body">
                        <c:set var="first" value="true"/>
                        <c:forEach items="${hit.sourceAsMap.studyNames}" var="map">
                            <c:choose>
                                <c:when test="${first=='true'}">
                                    <a href="/toolkit/data/experiments/study/${map.key}">${map.value}</a>
                                    <c:set var="first" value="false"/>
                                </c:when>
                                <c:otherwise>
                                    <hr>
                                    <a href="/toolkit/data/experiments/study/${map.key}">${map.value}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </div>
                </div>
            </c:if>
            <c:if test="${hit.sourceAsMap.experimentNames!=null}">
                <span class="header">Associated Experiments:</span>
                <!--a  data-placement="top" data-popover-content="#popover-${hit.sourceAsMap.id}" data-toggle="popover" data-trigger="focus" href="" tabindex="0"> $-{fn:length(hit.sourceAsMap.experimentNames)}</a-->

                <button type="button" class="btn btn-light btn-sm" data-container="body" data-toggle="popover" data-placement="bottom" data-popover-content="#popover-${hit.sourceAsMap.id}" title="Experiments" style="background-color: transparent">
                    <span style="text-decoration:underline">${fn:length(hit.sourceAsMap.experimentNames)}</span>
                </button>
                <div style="display: none" id="popover-${hit.sourceAsMap.id}">
                    <div class="popover-body">
                        <c:set var="first" value="true"/>
                        <c:forEach items="${hit.sourceAsMap.experimentNames}" var="map">
                            <c:choose>
                            <c:when test="${first=='true'}">
                            <a href="/toolkit/data/experiments/experiment/${map.key}">${map.value}</a>
                                <c:set var="first" value="false"/>
                            </c:when>
                                <c:otherwise>
                                    <hr>
                                    <a href="/toolkit/data/experiments/experiment/${map.key}">${map.value}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </div>
                </div>
            </c:if>
            <c:if test="${hit.sourceAsMap.study.study!=null}">
                <span class="header"><strong>Associated Studies:</strong></span>
                <!--a href="/toolkit/data/experiments/study/$-{hit.sourceAsMap.study.studyId}">$-{hit.sourceAsMap.study.study}</a><br-->
                <button type="button" class="btn btn-light btn-sm" data-container="body" data-toggle="popover" data-placement="bottom" data-popover-content="#popover-study-${hit.sourceAsMap.study.studyId}" title="Studies" style="background-color: transparent">
                    <span style="text-decoration:underline">1</span>
                </button>
                <div style="display: none" id="popover-study-${hit.sourceAsMap.study.studyId}">
                    <div class="popover-body">
                        <a href="/toolkit/data/experiments/study/${hit.sourceAsMap.study.studyId}">${hit.sourceAsMap.study.study}</a>

                    </div>
                </div>
            </c:if>



            <!--c:if test="$-{hit.sourceAsMap.experimentCount>0}"-->
                <!--i class="fas fa-eye"></i-->
                <!--span><a href="$-{hit.sourceAsMap.reportPageLink}${hit.sourceAsMap.id}">Associated Experiments:&nbsp;${hit.sourceAsMap.experimentCount}</a></span> <br-->
            <!--/c:if-->


        </div>
    </td></tr>
    </c:forEach>
</table>

