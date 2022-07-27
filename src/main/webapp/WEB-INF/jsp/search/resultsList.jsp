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
<c:choose>
    <c:when test="${action!=null && category!=null}">
        <h4>${fn:length(sr.hits.hits)}&nbsp;results<c:if test="${action!=null && category!=null}">&nbsp;in ${action}</c:if> </h4>
    </c:when>
    <c:otherwise>
        <h4>${action} </h4>
    </c:otherwise>
</c:choose>
<table class="table table-striped">
    <c:forEach items="${sr.hits.hits}" var="hit">
    <tr><td style="border-color: transparent">
        <div>
            <div>
                <div style="padding-bottom: 0;margin-bottom: 0">
            <c:if test="${hit.sourceAsMap.name!=null}">
            <h6>
                <c:if test="${hit.sourceAsMap.studyType=='Validation'}">
                    <span title="Validation Study" style="color:darkorange;font-weight: bold;font-size: large"> [<i class="fa-solid fa-v" style="color:darkorange"></i>]</span>
                </c:if>
                <a class="search-results-anchor" href="${hit.sourceAsMap.reportPageLink}${hit.sourceAsMap.id}">${hit.sourceAsMap.name}</a> &nbsp; -  <small class="${hit.sourceAsMap.category}">${hit.sourceAsMap.category}</small>
           <small>
            <c:if test="${hit.sourceAsMap.experimentType!=null}">
               -  ${hit.sourceAsMap.experimentType}
            </c:if>
            </small>
               <%if(access.isAdmin(person) && request.getAttribute("searchTerm")!=""){%>
                <a class="search-results-anchor" style="text-decoration: none;cursor: pointer" data-toggle="collapse" data-target="#highlights-${hit.sourceAsMap.id}" aria-expanded="false" aria-controls="highlights-${hit.sourceAsMap.id}" title="View highlights">
              +
            </a>
            <%}%></h6>
            </c:if>

            <c:if test="${hit.sourceAsMap.symbol!=null}">
            <h6><a class="search-results-anchor" href="${hit.sourceAsMap.reportPageLink}${hit.sourceAsMap.id}">${hit.sourceAsMap.symbol}</a>&nbsp; -  <small class="${hit.sourceAsMap.category}">${hit.sourceAsMap.category}
            </small>
                <%if(access.isAdmin(person) && request.getAttribute("searchTerm")!=""){%>
                <a class="search-results-anchor" style="text-decoration: none;cursor: pointer"  data-toggle="collapse" data-target="#highlights-${hit.sourceAsMap.id}" aria-expanded="false" aria-controls="highlights-${hit.sourceAsMap.id}" title="View highlights">
                +
            </a>
            <%}%>
            </h6>
            </c:if>
                    <div class="collapse" id="highlights-${hit.sourceAsMap.id}" style="padding: 0; margin: 0">
                        <div class="card card-body" style="margin-bottom: 0;padding-bottom: 0">
                    <%@include file="highlights.jsp"%>
                        </div>
                    </div>
                </div>
                <small>  <c:if test="${hit.sourceAsMap.category=='Study' || hit.sourceAsMap.category=='Experiment'}">
                    ${hit.sourceAsMap.pi.get(0)}
                    <c:if test="${hit.sourceAsMap.category=='Study'}">
                        &nbsp;&nbsp;<span class="header">Date Of Submission:</span> ${hit.sourceAsMap.submissionDate}
                    </c:if>
                </c:if></small>
            </div>
            <c:if test="${hit.sourceAsMap.description!=null}">
                <span>${hit.sourceAsMap.description}</span><br>
            </c:if>
            <c:if test="${hit.sourceAsMap.generatedDescription!=null}">
                <!--span><span class="header">Generated Description</span>&nbsp;${hit.sourceAsMap.generatedDescription}</span><br-->
            </c:if>
            <!--c:if test="$-{hit.sourceAsMap.type!=null}"-->
                <!--span><span class="header">$-{hit.sourceAsMap.category}&nbsp;Type:&nbsp;</span> $-{hit.sourceAsMap.type}</span><br-->
            <!--/c:if-->
            <c:if test="${hit.sourceAsMap.subType!=null}">
                <!--span><span class="header">$-{hit.sourceAsMap.category}&nbsp;SubType:</span>&nbsp;$-{hit.sourceAsMap.subType}</span> <br-->
            </c:if>

            <!--c:if test="${hit.sourceAsMap.modelOrganism!=null}"-->
                <!--span><span class="header">Species:</span>&nbsp;-$-{hit.sourceAsMap.modelOrganism}</span> <br-->
            <!--/c:if-->
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
            <small class="text-muted">View Associated:&nbsp;</small><%@include file="associations.jsp"%>



            <!--c:if test="$-{hit.sourceAsMap.experimentCount>0}"-->
                <!--i class="fas fa-eye"></i-->
                <!--span><a href="$-{hit.sourceAsMap.reportPageLink}${hit.sourceAsMap.id}">Associated Experiments:&nbsp;${hit.sourceAsMap.experimentCount}</a></span> <br-->
            <!--/c:if-->


        </div>
    </td>
    </tr>
    </c:forEach>
</table>
<link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" integrity="sha384-AYmEC3Yw5cVb3ZcuHtOA93w35dYTsvhLPVnYs9eStHfGJvOvKxVfELGroGkvsg+p" crossorigin="anonymous"/>

