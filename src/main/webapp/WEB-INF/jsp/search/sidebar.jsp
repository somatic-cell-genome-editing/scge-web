<input type="hidden" name="searchTerm" id="searchTerm" value="${searchTerm}"/>
<input type="hidden" name="category" id="category" value="${category}" >
<script>
    $(document).ready(function(){
        // Add down arrow icon for collapse element which is open by default
        $(".collapse.show").each(function(){
          $(this).prev(".card-header").find(".fas").addClass("fa-angle-down").removeClass("fa-angle-up");
        });

        // Toggle right and down arrow icon on show hide of collapse element
        $(".collapse").on('show.bs.collapse', function(){
            $(this).prev(".card-header").find(".fas").removeClass("fa-angle-up").addClass("fa-angle-down");
        }).on('hide.bs.collapse', function(){
            $(this).prev(".card-header").find(".fas").removeClass("fa-angle-down").addClass("fa-angle-up");
        });
    });
</script>
<style>
    .card-header{
        background-color: white;
        padding-left:0;
    }
    .card-header a{
        text-decoration: none;
    }
</style>
<c:if test="${fn:length(aggregations.category.buckets)>1}">
<div class="p-2" style="border-bottom: 2px solid black">Select Category&nbsp;</div>
</c:if>
<div class="accordion">
    <div class="accordion-group">

            <c:if test="${fn:length(aggregations.category.buckets)>1}">
            <c:forEach items="${aggregations}" var="agg">
                <c:if test="${agg.key=='category'}">
                <div id="collapseOne" class="accordion-body collapse show" >
                    <div class="pl-3  accordion-inner card-header" >
                        <ul class="nav flex-column">
                            <c:forEach items="${agg.value.buckets}" var="bkt">
                                <c:if test="${bkt.key=='Experiment'}">
                                <li class="nav-item">

                                    <a class="nav-link search-results-anchor" href="/toolkit/data/search/results/${bkt.key}?searchTerm=${searchTerm}" style="padding-left: 0">
                                        ${bkt.key}&nbsp;(${bkt.docCount})</a>

                                </li>
                            </c:if>

                            </c:forEach>
                            <c:forEach items="${agg.value.buckets}" var="bkt">
                            <c:if test="${bkt.key!='Experiment'}">
                                <li class="nav-item">

                                    <a class="nav-link search-results-anchor" href="/toolkit/data/search/results/${bkt.key}?searchTerm=${searchTerm}" style="padding-left: 0">
                                            ${bkt.key}&nbsp;(${bkt.docCount})</a>

                                </li>
                            </c:if>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
                </c:if>


            </c:forEach>
            </c:if>
    </div>
<c:if test="${fn:length(aggregations.category.buckets)==1}">
    <div class="p-2" style="border-bottom: 2px solid black">Filter By ...&nbsp;<span style="color:#2a6496"><i class="fa fa-arrow-down" aria-hidden="true"></i></span></div>
</c:if>
    <c:if test="${fn:length(aggregations.category.buckets)>1}">
        <div class="p-2" style="border-bottom: 2px solid black">OR Filter By ...&nbsp;<span style="color:#2a6496"><i class="fa fa-arrow-down" aria-hidden="true"></i></span></div>
    </c:if>


    <form action="/toolkit/data/search/results/${category}" method="get" >
        <input type="hidden" name="searchTerm" value="${searchTerm}"/>
        <input type="hidden" name="facetSearch" value="true"/>
        <c:if test="${category=='Study'}">
            <%@include file="studyFacets.jsp"%>
        </c:if>
        <c:if test="${category=='Genome Editor'}">
            <%@include file="editorFacets.jsp"%>
        </c:if>
        <c:if test="${category=='Model System'}">
            <%@include file="modelFacets.jsp"%>
        </c:if>
        <c:if test="${category=='Delivery System'}">
            <%@include file="deliveryFacets.jsp"%>
        </c:if>
        <c:if test="${category=='Guide'}">
            <%@include file="guideFacets.jsp"%>
        </c:if>
        <c:if test="${category=='Vector'}">
            <%@include file="vectorFacets.jsp"%>
        </c:if>
        <c:if test="${category=='Experiment' ||  (fn:length(aggregations.category.buckets)>1 && action!='Studies And Experiments')}">
            <%@include file="experimentFacets.jsp"%>
        </c:if>
        <c:if test="${fn:length(aggregations.category.buckets)==2 && action=='Studies And Experiments'}">

        </c:if>
    </form>
</div>

