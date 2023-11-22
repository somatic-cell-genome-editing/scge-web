<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ page import="edu.mcw.scge.datamodel.Person" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="org.elasticsearch.action.search.SearchResponse" %>
<%@ page import="org.elasticsearch.search.SearchHit" %>
<%@ page import="edu.mcw.scge.datamodel.Guide" %>
<%@ page import="java.util.*" %><%--
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
    <%
        for(SearchHit searchHit:hits){
            Map<String, Object> hit=  searchHit.getSourceAsMap();
    %>
    <tr style="margin-top: 5%">
        <td style="border-color: transparent">
        <div>
            <div>
                <div>
                    <h4>
                        <% if(hit.get("name")!=null){%>
                            <%if(hit.get("studyType")!=null && hit.get("studyType").toString().equalsIgnoreCase("Validation")){%>
                        <span title="Validation Study" style="color:darkorange;font-weight: bold;font-size: large;color:darkorange"> [Validation]</span>
                        <%}if(hit.get("reportPageLink")!=null){%>

                                    <a class="search-results-anchor" href="<%=hit.get("reportPageLink")%><%=hit.get("id")%>"><%=hit.get("name")%></a>
                           <%}else{%>
                               <%=hit.get("name")%>&nbsp;<%if(hit.get("externalLink")!=null){%>
                                    <a href="<%=hit.get("externalLink")%>"><i class="fa fa-external-link" aria-hidden="true"></i></a>

                        <%}}}
                            if(hit.get("symbol")!=null){%>

                        <%if(hit.get("studyType")!=null && hit.get("studyType").toString().equalsIgnoreCase("Validation")){%>
                        <span title="Validation Study" style="color:darkorange;font-weight: bold;font-size: large;color:darkorange"> [Validation]</span>
                        <%}if(hit.get("reportPageLink")!=null){%>

                        <a class="search-results-anchor" href="<%=hit.get("reportPageLink")%><%=hit.get("id")%>"><%=hit.get("symbol")%></a>
                        <%}else{%>
                        <%=hit.get("symbol")%>&nbsp;<%if(hit.get("externalLink")!=null){%>
                        <a href="<%=hit.get("externalLink")%>"><i class="fa fa-external-link" aria-hidden="true"></i></a>

                        <%}}}%>
                        <%if(access.isAdmin(person) && request.getAttribute("searchTerm")!=""){%>
                        <a class="search-results-anchor" style="text-decoration: none;cursor: pointer"  data-toggle="collapse" data-target="#highlights-<%=hit.get("id")%>" aria-expanded="false" aria-controls="highlights-<%=hit.get("id")%>" title="View highlights">+</a><%}%>
                    </h4>
                    <small class="<%=hit.get("category")%> text-muted" <%=hit.get("category")%>>&nbsp;</small>
                    <small class="text-muted">
                        <%if(hit.get("experimentType")!=null){%>-&nbsp;<%=hit.get("experimentType")%><%}%>
                    </small>
                    <small class="text-muted"><%=hit.get("initiative")%></small>
                        <%if(hit.get("modelOrganism")!=null){%>
                    <small class="text-muted"><%=hit.get("modelOrganism")%></small>

                        <%for(String organism: (List<String>)hit.get("modelOrganism")){
                        if(organism.equalsIgnoreCase("Human")){%>
                    <i class="fas fa-thin fa-person"></i>
                    <%}}}%>
                    <div class="collapse" id="highlights-<%=hit.get("id")%>" style="padding: 0; margin: 0">
                        <div class="card card-body" style="margin-bottom: 0;padding-bottom: 0">
                            <%@include file="highlights.jsp"%>
                        </div>
                    </div>
                </div>
                <%if(hit.get("category")!=null && hit.get("category").toString().equalsIgnoreCase("Experiment") || hit.get("category").toString().equalsIgnoreCase("Project")){
                    boolean first=true;%>
                <small>
                    <%for(String pi: (List<String>)hit.get("pi")){
                        if(first){%>
                    <span><%=pi%></span>
                    <%first=false;}else{%>
                    <span>,&nbsp;<%=pi%></span>

                    <%}} if(hit.get("lastModifiedDate")!=null){%>

                    &nbsp;<span class="header">Last Updated Date:</span> <%=hit.get("lastModifiedDate")%>

                    <%} if(hit.get("currentGrantNumber")!=null){%>

                    <!--a href="https://reporter.nih.gov/project-details/$-{hit.sourceAsMap.currentGrantNumber}" target="_blank"><img src="/toolkit/images/nihReport.png" alt="NIH Report" > </a-->
                    <a href="<%=hit.get("nihReporterLink")%>" target="_blank"><img src="/toolkit/images/nihReport.png" alt="NIH Report" > </a>


                    <%}%>
                </small>
                <br>&nbsp;
                <%}%>
            </div>
            <%if(hit.get("category")!=null && hit.get("category").toString().equalsIgnoreCase("Antibody") && hit.get("externalId")!=null){
                List<String> externalIds= (List<String>) hit.get("externalId");
                if(externalIds.size()>0){%>
            <span><b>Other Id:</b>
              <%for(String id:externalIds){%>
                    <%if(hit.get("name")!=null && id!=hit.get("name")){%>
                        <span><%=id%></span>
               <%}}%>
                    </span><br>
            <% }%>


            <%}%>
            <%if(hit.get("description")!=null){%>

            <span><%=hit.get("description")%></span><br>

            <%}%>
               <% if(hit.get("target")!=null && hit.get("category").toString().equalsIgnoreCase("Experiment")){
                    boolean first=true;%>


            <span><span class="header">Tissue :</span>
                    <%for(String tissue: (List<String>)hit.get("tissueTerm")){
                        if(first){first=false;%>
                    <%=tissue%>
                    <%}else {%>
                    <%}%>
                    ,<%=tissue%>
                    <%}%>
                </span> <br>

            <%}%>
               <% if(hit.get("guides")!=null && hit.get("category").toString().equalsIgnoreCase("Experiment")){
                    boolean first=true;%>


            <span><span class="header">Target Locus :</span>
                    <%for(Guide guide:(List<Guide>) hit.get("guides")){
                        if(first){
                            first=false;
                    %>
                    <%=guide.getTargetLocus()%>
              <%}else{%>
                    ,&nbsp;<%=guide.getTargetLocus()%>
                    <%}%>

                    <%}%>
                </span> <br>

            <%}%>

        </div>

    </td>
    </tr>

    <%}%>
</table>
<link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" integrity="sha384-AYmEC3Yw5cVb3ZcuHtOA93w35dYTsvhLPVnYs9eStHfGJvOvKxVfELGroGkvsg+p" crossorigin="anonymous"/>

