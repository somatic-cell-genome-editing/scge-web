<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ page import="edu.mcw.scge.datamodel.Person" %>
<%@ page import="edu.mcw.scge.configuration.Access" %><%--
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
    h6{
        margin-bottom: 0;
        padding-bottom: 0;
    }
    .table-striped > tbody > tr:nth-child(2n+1) > td, .table-striped > tbody > tr:nth-child(2n+1) > th {
        background-color:   #f7f9fc;
    }
    .Study{
        background-color: lightcyan;
    }
    .Experiment{
        background-color: #fad9e6;
        color:deeppink;
    }
</style>

<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>

<script>

</script>


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


<%
    Access access=new Access();
    Person person = null;
    try {
        person = access.getUser(request.getSession());
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<%@include file="resultHeader.jsp"%>
<table class="table table-striped">
    <c:forEach items="${sr.hits.hits}" var="hit">
    <tr style="margin-top: 5%"><td style="border-color: transparent">
        <div>
            <div>
                <div>
                    <h4>

                        <c:if test="${hit.sourceAsMap.name!=null}">
                            <c:if test="${hit.sourceAsMap.studyType=='Validation'}">
                            <span title="Validation Study" style="color:darkorange;font-weight: bold;font-size: large;color:darkorange"> [Validation]</span>
                            </c:if>
                            <c:choose>
                                <c:when test="${hit.sourceAsMap.reportPageLink!=null}">
                                    <a class="search-results-anchor" href="${hit.sourceAsMap.reportPageLink}${hit.sourceAsMap.id}">${hit.sourceAsMap.name}</a>
                                </c:when>
                                <c:otherwise>${hit.sourceAsMap.name}&nbsp;<c:if test="${hit.sourceAsMap.externalLink!=null}">
                                    <a href="${hit.sourceAsMap.externalLink}"><i class="fa fa-external-link" aria-hidden="true"></i></a></c:if>
                                </c:otherwise>
                            </c:choose>
                        </c:if>

                        <c:if test="${hit.sourceAsMap.symbol!=null}">
                            <c:choose>
                                <c:when test="${hit.sourceAsMap.reportPageLink!=null}">
                                    <a class="search-results-anchor" href="${hit.sourceAsMap.reportPageLink}${hit.sourceAsMap.id}">
                                            ${hit.sourceAsMap.symbol}</a>
                                </c:when>
                                <c:otherwise>
                                    ${hit.sourceAsMap.symbol}&nbsp;
                                    <c:if test="${hit.sourceAsMap.externalLink!=null}">
                                        <a href="${hit.sourceAsMap.externalLink}"><i class="fa fa-external-link" aria-hidden="true"></i></a>
                                    </c:if>                </c:otherwise>
                            </c:choose>
                        </c:if>
                        -<small class="${hit.sourceAsMap.category} text-muted" >${hit.sourceAsMap.category}&nbsp;</small>
                        <small class="text-muted">
                            <c:if test="${hit.sourceAsMap.experimentType!=null}">-  ${hit.sourceAsMap.experimentType}</c:if></small>
                        <small class="text-muted">${hit.sourceAsMap.initiative}</small>
                        <small class="text-muted">${hit.sourceAsMap.modelOrganism}</small>
                         <c:forEach items="${hit.sourceAsMap.modelOrganism}" var="organism">
                              <c:if test="${organism=='Mouse'}">

                                </c:if>
                                <c:if test="${organism=='Human'}">
                                    <i class="fas fa-thin fa-person"></i>
                                </c:if>
                          </c:forEach>
                        <%if(access.isAdmin(person) && request.getAttribute("searchTerm")!=""){%>
                        <a class="search-results-anchor" style="text-decoration: none;cursor: pointer"  data-toggle="collapse" data-target="#highlights-${hit.sourceAsMap.id}" aria-expanded="false" aria-controls="highlights-${hit.sourceAsMap.id}" title="View highlights">+</a><%}%>
                    </h4>
                    <div class="collapse" id="highlights-${hit.sourceAsMap.id}" style="padding: 0; margin: 0">
                        <div class="card card-body" style="margin-bottom: 0;padding-bottom: 0">
                    <%@include file="highlights.jsp"%>
                        </div>
                    </div>
                </div>
                <c:if test="${ hit.sourceAsMap.category=='Experiment' || hit.sourceAsMap.category=='Project'}">
                   <c:set var="first" value="true"/>
                    <small>
                    <c:forEach items="${hit.sourceAsMap.pi}" var="item">
                        <c:choose>
                            <c:when test="${first=='true'}">
                                ${item}
                                <c:set var="first" value="false"/>
                            </c:when>
                            <c:otherwise>
                                ,&nbsp;${item}
                            </c:otherwise>
                        </c:choose>
                   </c:forEach>

                    <c:if test="${hit.sourceAsMap.lastModifiedDate!=null}">
                        &nbsp;<span class="header">Last Updated Date:</span> ${hit.sourceAsMap.lastModifiedDate}
                    </c:if>
                    <c:if test="${hit.sourceAsMap.currentGrantNumber!=null}">
                        <!--a href="https://reporter.nih.gov/project-details/$-{hit.sourceAsMap.currentGrantNumber}" target="_blank"><img src="/toolkit/images/nihReport.png" alt="NIH Report" > </a-->
                        <a href="${hit.sourceAsMap.nihReporterLink}" target="_blank"><img src="/toolkit/images/nihReport.png" alt="NIH Report" > </a>

                    </c:if>
                    </small>
                    <br>&nbsp;
                </c:if>
            </div>
            <c:if test="${hit.sourceAsMap.category=='Antibody' && fn:length(hit.sourceAsMap.externalId)>0}">
                <span><b>Other Id:</b>
                <c:forEach items="${hit.sourceAsMap.externalId}" var="item">
                    <c:if test="${item!=hit.sourceAsMap.name}">
                    ${item}&nbsp;
                    </c:if>
                </c:forEach>
                </span><br>
            </c:if>
            <c:if test="${hit.sourceAsMap.description!=null}">
                <span>${hit.sourceAsMap.description}</span><br>
            </c:if>
            <c:if test="${hit.sourceAsMap.target!=null && hit.sourceAsMap.category=='Experiment'}">
                <c:set var="first" value="true"/>
                <span><span class="header">Tissue :</span>
                <c:forEach items="${hit.sourceAsMap.tissueTerm}" var="item">
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
                            ${guide.guideTargetLocus}
                            <c:set var="first" value="false"/>

                        </c:when>
                        <c:otherwise>
                            , ${guide.guideTargetLocus}

                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                </span> <br>
            </c:if>

        </div>
    </td>
    </tr>

    </c:forEach>
</table>
<link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" integrity="sha384-AYmEC3Yw5cVb3ZcuHtOA93w35dYTsvhLPVnYs9eStHfGJvOvKxVfELGroGkvsg+p" crossorigin="anonymous"/>

