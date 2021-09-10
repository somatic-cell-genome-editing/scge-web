<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 1/22/2021
  Time: 1:40 PM
  To change this template use File | Settings | File Templates.
--%>
<style>
    .header{
        font-weight: bold;
    }
</style>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>

<script>
    $(function() {
        $("#myTable").tablesorter({
            theme : 'blue'

        });
        $('[data-toggle="popover"]').popover({
            html : true

        })
    });
</script>
<h4>${sr.hits.totalHits} <c:if test="${category!=null}">&nbsp;in ${category}</c:if> </h4>
<table class="table table-striped">
    <c:forEach items="${sr.hits.hits}" var="hit">
    <tr><td>
        <div>
            <div class="row">
                <div class="col-10">
            <c:if test="${hit.sourceAsMap.name!=null}">
            <h6><a href="${hit.sourceAsMap.reportPageLink}${hit.sourceAsMap.id}">${hit.sourceAsMap.name}</a> &nbsp;</h6>
            </c:if>
            <c:if test="${hit.sourceAsMap.symbol!=null}">
            <h6><a href="${hit.sourceAsMap.reportPageLink}${hit.sourceAsMap.id}">${hit.sourceAsMap.symbol}</a></h6>
            </c:if>
                </div>
                <div class="col-2" align="right">
                <small class="text-muted">${hit.sourceAsMap.category}</small>
                </div>
            </div>
            <c:if test="${hit.sourceAsMap.description!=null}">
                <span><span class="header">Description:</span>&nbsp;${hit.sourceAsMap.description}</span><br>
            </c:if>
            <c:if test="${hit.sourceAsMap.target!=null}">
                <c:set var="first" value="true"/>
                <span><span class="header">Target :</span>
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
            <c:if test="${hit.sourceAsMap.studyNames!=null}">
                <span><span class="header">Associated Studies:</span>&nbsp;<a href="">${fn:length(hit.sourceAsMap.studyNames)}</a></span>

                <br>
            </c:if>
            <c:if test="${hit.sourceAsMap.experimentNames!=null}">
                <span class="header">Associated Experiments:&nbsp;</span>&nbsp;<a href="">${fn:length(hit.sourceAsMap.experimentNames)}</a>
                <div id="popover-content">
                <c:forEach items="${hit.sourceAsMap.experimentNames}" var="map">
                    <a href="/toolkit/data/experiments/experiment/${map.key}">${map.value}</a>&nbsp;
                </c:forEach>
                <br>
                </div>
                <button type="button" class="btn btn-secondary" data-container="body" data-toggle="popover" data-placement="bottom" data-content='
                <a href="/toolkit/data/experiments/experiment/18000000013">Experiment</a>'>
                    Popover on bottom
                </button>
            </c:if>
            <c:if test="${hit.sourceAsMap.study.study!=null}">
                <span class="header">Study:&nbsp;</span>
                <a href="/toolkit/data/experiments/study/${hit.sourceAsMap.study.studyId}">${hit.sourceAsMap.study.study}</a><br>
            </c:if>
            <c:if test="${hit.sourceAsMap.type!=null}">
                <span><span class="header">${hit.sourceAsMap.category}&nbsp;Type:&nbsp;</span> ${hit.sourceAsMap.type}</span><br>
            </c:if>
            <c:if test="${hit.sourceAsMap.subType!=null}">
                <span><span class="header">${hit.sourceAsMap.category}&nbsp;SubType:</span>&nbsp;${hit.sourceAsMap.subType}</span> <br>
            </c:if>

            <c:if test="${hit.sourceAsMap.species!=null}">
                <span><span class="header">Species:</span>&nbsp;${hit.sourceAsMap.species}</span> <br>
            </c:if>


            <!--c:if test="$-{hit.sourceAsMap.experimentCount>0}"-->
                <!--i class="fas fa-eye"></i-->
                <!--span><a href="$-{hit.sourceAsMap.reportPageLink}${hit.sourceAsMap.id}">Associated Experiments:&nbsp;${hit.sourceAsMap.experimentCount}</a></span> <br-->
            <!--/c:if-->

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

