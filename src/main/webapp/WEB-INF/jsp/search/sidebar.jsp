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
<h5>Refine your Search&nbsp;<span style="color:#2a6496"><i class="fa fa-arrow-down" aria-hidden="true"></i></span></h5>
<div class="accordion">
    <div class="accordion-group">

            <c:if test="${fn:length(aggregations.catBkts)>1}">
                <div id="collapseOne" class="accordion-body collapse show" >
                    <div class="accordion-inner card-header" >
                        <ul class="nav flex-column">
                            <c:forEach items="${aggregations.catBkts}" var="bkt">
                                <!--li class="list-group-item"><a href="/toolkit/data/search/results/${bkt.key}?searchTerm=${searchTerm}">${bkt.key}</a> (${bkt.docCount})</li-->
                                <li class="nav-item">

                                    <a class="nav-link" href="/toolkit/data/search/results/${bkt.key}?searchTerm=${searchTerm}" style="padding-left: 0">
                                        ${bkt.key}&nbsp;(${bkt.docCount})</a>

                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
            </c:if>



    </div>
    <form action="/toolkit/data/search/results/${category}" method="get" onclick="applyFacetFilters()">
    <input type="hidden" name="searchTerm" value="${searchTerm}"/>
        <input type="hidden" name="facetSearch" value="true"/>
        <c:if test="${fn:length(aggregations.typeBkts)>0}">


    <div class="accordion-group">
        <div class="accordion-heading card-header">
            <a class="accordion-toggle" data-toggle="collapse" href="#collapseTwo">
                ${category}&nbsp;Type<span class="float-right"><i class="fas fa-angle-down"></i></span>
            </a>
        </div>
        <div id="collapseTwo" class="accordion-body collapse show">
            <div class="accordion-inner">

                    <c:forEach items="${aggregations.typeBkts}" var="type">

                        <div class="form-check">

                            <input class="form-check-input" type="checkbox" name="typeBkt" value="${type.key}"
                                   id="type-${type.key}"/>
                            <label class="form-check-label" for="type-${type.key}">
                               ${type.key}(${type.docCount})

                            </label>

                        </div>

                    </c:forEach>


            </div>
        </div>
    </div>
        <c:if test="${fn:length(aggregations.subtypeBkts)>0}">
    <div class="accordion-group">
        <div class="accordion-heading card-header">
            <a class="accordion-toggle" data-toggle="collapse" href="#collapseThree">
                    ${category}&nbsp; Subtype<span class="float-right"><i class="fas fa-angle-down"></i></span>
            </a>
        </div>
        <div id="collapseThree" class="accordion-body collapse show">
            <div class="accordion-inner">
                    <c:forEach items="${aggregations.subtypeBkts}" var="subtype">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="subtypeBkt" value="${subtype.key}" id="subtype-${subtype.key}">
                            <label class="form-check-label" for="subtype-${subtype.key}">
                        <!--li> <a class="nav-link" onclick="searchByFilter('${bkt.key}','${searchTerm}','${type.key}','${subtype.key}')" >${subtype.key} (${subtype.docCount})</a></li-->
                            ${subtype.key} (${subtype.docCount})
                            </label>
                        </div>
                            </c:forEach>
            </div>
        </div>

    </div>
        </c:if>


    </c:if>
    <c:if test="${fn:length(aggregations.editorBkts)>0}">
        <div class="accordion-group">
            <div class="accordion-heading card-header">
                <a class="accordion-toggle" data-toggle="collapse" href="#collapseFour">
                        ${category}&nbsp; Editor<span class="float-right"><i class="fas fa-angle-down"></i></span>
                </a>
            </div>
            <div id="collapseFour" class="accordion-body collapse show">
                <div class="accordion-inner">
                    <c:forEach items="${aggregations.editorBkts}" var="subtype">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="editorTypeBkt" value="${subtype.key}" id="editorType-${subtype.key}">
                            <label class="form-check-label" for="editorType-${subtype.key}">
                                <!--li> <a class="nav-link" onclick="searchByFilter('${bkt.key}','${searchTerm}','${type.key}','${subtype.key}')" >${subtype.key} (${subtype.docCount})</a></li-->
                                    ${subtype.key} (${subtype.docCount})
                            </label>
                        </div>
                    </c:forEach>
                </div>
            </div>

        </div>
    </c:if>
    <c:if test="${fn:length(aggregations.editorSubTypeBkts)>0}">
        <div class="accordion-group">
            <div class="accordion-heading card-header">
                <a class="accordion-toggle" data-toggle="collapse" href="#collapse13">
                        ${category}&nbsp; Editor Subtype<span class="float-right"><i class="fas fa-angle-down"></i></span>
                </a>
            </div>
            <div id="collapse13" class="accordion-body collapse show">
                <div class="accordion-inner">
                    <c:forEach items="${aggregations.editorSubTypeBkts}" var="subtype">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="editorSubTypeBkt" value="${subtype.key}" id="editorSubType-${subtype.key}">
                            <label class="form-check-label" for="editorSubType-${subtype.key}">
                                <!--li> <a class="nav-link" onclick="searchByFilter('${bkt.key}','${searchTerm}','${type.key}','${subtype.key}')" >${subtype.key} (${subtype.docCount})</a></li-->
                                    ${subtype.key} (${subtype.docCount})
                            </label>
                        </div>
                    </c:forEach>
                </div>
            </div>

        </div>
    </c:if>
    <c:if test="${fn:length(aggregations.editorSpeciesBkts)>0}">
        <div class="accordion-group">
            <div class="accordion-heading card-header">
                <a class="accordion-toggle" data-toggle="collapse" href="#collapse14">
                        ${category}&nbsp; Editor Species<span class="float-right"><i class="fas fa-angle-down"></i></span>
                </a>
            </div>
            <div id="collapse14" class="accordion-body collapse show">
                <div class="accordion-inner">
                    <c:forEach items="${aggregations.editorSpeciesBkts}" var="subtype">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="editorSpeciesBkt" value="${subtype.key}" id="editorSpecies-${subtype.key}">
                            <label class="form-check-label" for="editorSpecies-${subtype.key}">
                                <!--li> <a class="nav-link" onclick="searchByFilter('${bkt.key}','${searchTerm}','${type.key}','${subtype.key}')" >${subtype.key} (${subtype.docCount})</a></li-->
                                    ${subtype.key} (${subtype.docCount})
                            </label>
                        </div>
                    </c:forEach>
                </div>
            </div>

        </div>
    </c:if>
    <c:if test="${fn:length(aggregations.deliveryBkts)>0}">
        <div class="accordion-group">
            <div class="accordion-heading card-header">
                <a class="accordion-toggle" data-toggle="collapse" href="#collapseFive">
                        ${category}&nbsp;Delivery System<span class="float-right"><i class="fas fa-angle-down"></i></span>
                </a>
            </div>
            <div id="collapseFive" class="accordion-body collapse show">
                <div class="accordion-inner">
                    <c:forEach items="${aggregations.deliveryBkts}" var="subtype">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="dsTypeBkt" value="${subtype.key}" id="dsType-${subtype.key}">
                            <label class="form-check-label" for="dsType-${subtype.key}">
                                <!--li> <a class="nav-link" onclick="searchByFilter('${bkt.key}','${searchTerm}','${type.key}','${subtype.key}')" >${subtype.key} (${subtype.docCount})</a></li-->
                                    ${subtype.key} (${subtype.docCount})
                            </label>
                        </div>
                    </c:forEach>
                </div>
            </div>

        </div>
    </c:if>
    <c:if test="${fn:length(aggregations.modelBkts)>0}">
        <div class="accordion-group">
            <div class="accordion-heading card-header">
                <a class="accordion-toggle" data-toggle="collapse" href="#collapseSix">
                        ${category}&nbsp; Model<span class="float-right"><i class="fas fa-angle-down"></i></span>
                </a>
            </div>
            <div id="collapseSix" class="accordion-body collapse show">
                <div class="accordion-inner">
                    <c:forEach items="${aggregations.modelBkts}" var="subtype">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="modelTypeBkt" value="${subtype.key}" id="modelType-${subtype.key}">
                            <label class="form-check-label" for="modelType-${subtype.key}">
                                <!--li> <a class="nav-link" onclick="searchByFilter('${bkt.key}','${searchTerm}','${type.key}','${subtype.key}')" >${subtype.key} (${subtype.docCount})</a></li-->
                                    ${subtype.key} (${subtype.docCount})
                            </label>
                        </div>
                    </c:forEach>
                </div>
            </div>

        </div>
    </c:if>
    <c:if test="${fn:length(aggregations.modelSpeciesBkts)>0}">
        <div class="accordion-group">
            <div class="accordion-heading card-header">
                <a class="accordion-toggle" data-toggle="collapse" href="#collapse11">
                        ${category}&nbsp; Model Species<span class="float-right"><i class="fas fa-angle-down"></i></span>
                </a>
            </div>
            <div id="collapse11" class="accordion-body collapse show">
                <div class="accordion-inner">
                    <c:forEach items="${aggregations.modelSpeciesBkts}" var="subtype">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="modelSpeciesBkt" value="${subtype.key}" id="modelSpecies-${subtype.key}">
                            <label class="form-check-label" for="modelSpecies-${subtype.key}">
                                <!--li> <a class="nav-link" onclick="searchByFilter('${bkt.key}','${searchTerm}','${type.key}','${subtype.key}')" >${subtype.key} (${subtype.docCount})</a></li-->
                                    ${subtype.key} (${subtype.docCount})
                            </label>
                        </div>
                    </c:forEach>
                </div>
            </div>

        </div>
    </c:if>
    <c:if test="${fn:length(aggregations.reporterBkts)>0}">
        <div class="accordion-group">
            <div class="accordion-heading card-header">
                <a class="accordion-toggle" data-toggle="collapse" href="#collapse12">
                        ${category}&nbsp; Model Reporter<span class="float-right"><i class="fas fa-angle-down"></i></span>
                </a>
            </div>
            <div id="collapse12" class="accordion-body collapse show">
                <div class="accordion-inner">
                    <c:forEach items="${aggregations.reporterBkts}" var="subtype">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="reporterBkt" value="${subtype.key}" id="reporter-${subtype.key}">
                            <label class="form-check-label" for="reporter-${subtype.key}">
                                <!--li> <a class="nav-link" onclick="searchByFilter('${bkt.key}','${searchTerm}','${type.key}','${subtype.key}')" >${subtype.key} (${subtype.docCount})</a></li-->
                                    ${subtype.key} (${subtype.docCount})
                            </label>
                        </div>
                    </c:forEach>
                </div>
            </div>

        </div>
    </c:if>
    <c:if test="${fn:length(aggregations.guidesBkts)>0}">
        <div class="accordion-group">
            <div class="accordion-heading card-header">
                <a class="accordion-toggle" data-toggle="collapse" href="#collapseNine">
                        ${category}&nbsp; Guide Target<span class="float-right"><i class="fas fa-angle-down"></i></span>
                </a>
            </div>
            <div id="collapseNine" class="accordion-body collapse show">
                <div class="accordion-inner">
                    <c:forEach items="${aggregations.guidesBkts}" var="subtype">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="guideTargetLocusBkt" value="${subtype.key}" id="guideTarget-${subtype.key}">
                            <label class="form-check-label" for="guideTarget-${subtype.key}">
                                <!--li> <a class="nav-link" onclick="searchByFilter('${bkt.key}','${searchTerm}','${type.key}','${subtype.key}')" >${subtype.key} (${subtype.docCount})</a></li-->
                                    ${subtype.key} (${subtype.docCount})
                            </label>
                        </div>
                    </c:forEach>
                </div>
            </div>

        </div>
    </c:if>
    <c:if test="${fn:length(aggregations.speciesBkts)>0}">
        <div class="accordion-group">
            <div class="accordion-heading card-header">
                <a class="accordion-toggle" data-toggle="collapse" href="#collapseSeven">
                        ${category}&nbsp; Species<span class="float-right"><i class="fas fa-angle-down"></i></span>
                </a>
            </div>
            <div id="collapseSeven" class="accordion-body collapse show">
                <div class="accordion-inner">
                    <c:forEach items="${aggregations.speciesBkts}" var="subtype">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="speciesBkt" value="${subtype.key}" id="species-${subtype.key}">
                            <label class="form-check-label" for="species-${subtype.key}">
                                    ${subtype.key} (${subtype.docCount})
                            </label>
                        </div>
                    </c:forEach>
                </div>
            </div>

        </div>
    </c:if>
    <c:if test="${fn:length(aggregations.vectorTypeBkts)>0}">
        <div class="accordion-group">
            <div class="accordion-heading card-header">
                <a class="accordion-toggle" data-toggle="collapse" href="#collapse15">
                        ${category}&nbsp; Vector Type<span class="float-right"><i class="fas fa-angle-down"></i></span>
                </a>
            </div>
            <div id="collapse15" class="accordion-body collapse show">
                <div class="accordion-inner">
                    <c:forEach items="${aggregations.vectorTypeBkts}" var="subtype">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="vectorTypeBkt" value="${subtype.key}" id="vectorType-${subtype.key}">
                            <label class="form-check-label" for="vectorType-${subtype.key}">
                                <!--li> <a class="nav-link" onclick="searchByFilter('${bkt.key}','${searchTerm}','${type.key}','${subtype.key}')" >${subtype.key} (${subtype.docCount})</a></li-->
                                    ${subtype.key} (${subtype.docCount})
                            </label>
                        </div>
                    </c:forEach>
                </div>
            </div>

        </div>
    </c:if>
    <c:if test="${fn:length(aggregations.vectorSubTypeBkts)>0}">
        <div class="accordion-group">
            <div class="accordion-heading card-header">
                <a class="accordion-toggle" data-toggle="collapse" href="#collapse16">
                        ${category}&nbsp; Vector Subtype<span class="float-right"><i class="fas fa-angle-down"></i></span>
                </a>
            </div>
            <div id="collapse16" class="accordion-body collapse show">
                <div class="accordion-inner">
                    <c:forEach items="${aggregations.vectorSubTypeBkts}" var="subtype">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="vectorSubTypeBkt" value="${subtype.key}" id="vectorSubType-${subtype.key}">
                            <label class="form-check-label" for="vectorSubType-${subtype.key}">
                                <!--li> <a class="nav-link" onclick="searchByFilter('${bkt.key}','${searchTerm}','${type.key}','${subtype.key}')" >${subtype.key} (${subtype.docCount})</a></li-->
                                    ${subtype.key} (${subtype.docCount})
                            </label>
                        </div>
                    </c:forEach>
                </div>
            </div>

        </div>
    </c:if>
    <c:if test="${fn:length(aggregations.vectorBkts)>0}">
        <div class="accordion-group">
            <div class="accordion-heading card-header">
                <a class="accordion-toggle" data-toggle="collapse" href="#collapse17">
                        ${category}&nbsp; Vector <span class="float-right"><i class="fas fa-angle-down"></i></span>
                </a>
            </div>
            <div id="collapse17" class="accordion-body collapse show">
                <div class="accordion-inner">
                    <c:forEach items="${aggregations.vectorBkts}" var="subtype">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="vectorBkt" value="${subtype.key}" id="vector-${subtype.key}">
                            <label class="form-check-label" for="vector-${subtype.key}">
                                <!--li> <a class="nav-link" onclick="searchByFilter('${bkt.key}','${searchTerm}','${type.key}','${subtype.key}')" >${subtype.key} (${subtype.docCount})</a></li-->
                                    ${subtype.key} (${subtype.docCount})
                            </label>
                        </div>
                    </c:forEach>
                </div>
            </div>

        </div>
    </c:if>
    <c:if test="${fn:length(aggregations.targetBkts)>0}">
        <div class="accordion-group">
            <div class="accordion-heading card-header">
                <a class="accordion-toggle" data-toggle="collapse" href="#collapseEight">
                        ${category}&nbsp; Target<span class="float-right"><i class="fas fa-angle-down"></i></span>
                </a>
            </div>
            <div id="collapseEight" class="accordion-body collapse show">
                <div class="accordion-inner">
                    <c:forEach items="${aggregations.targetBkts}" var="subtype">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="targetBkt" value="${subtype.key}" id="target-${subtype.key}">
                            <label class="form-check-label" for="target-${subtype.key}">
                                <!--li> <a class="nav-link" onclick="searchByFilter('${bkt.key}','${searchTerm}','${type.key}','${subtype.key}')" >${subtype.key} (${subtype.docCount})</a></li-->
                                    ${subtype.key} (${subtype.docCount})
                            </label>
                        </div>
                    </c:forEach>
                </div>
            </div>

        </div>
    </c:if>
    <c:if test="${fn:length(aggregations.withExperimentsBkts)>0}">
        <div class="accordion-group">
            <div class="accordion-heading card-header">
                <a class="accordion-toggle" data-toggle="collapse" href="#collapseTen">
                  ${category} with Experiments<span class="float-right"><i class="fas fa-angle-down"></i></span>
                </a>
            </div>
            <div id="collapseTen" class="accordion-body collapse show">
                <div class="accordion-inner">
                    <c:forEach items="${aggregations.withExperimentsBkts}" var="subtype">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="withExperimentsBkt" value="${subtype.key}" id="withExperiments-${subtype.key}">
                            <label class="form-check-label" for="withExperiments-${subtype.key}">
                                <!--li> <a class="nav-link" onclick="searchByFilter('${bkt.key}','${searchTerm}','${type.key}','${subtype.key}')" >${subtype.key} (${subtype.docCount})</a></li-->
                                    ${subtype.key} (${subtype.docCount})
                            </label>
                        </div>
                    </c:forEach>
                </div>
            </div>

        </div>
    </c:if>
    </form>
</div>

