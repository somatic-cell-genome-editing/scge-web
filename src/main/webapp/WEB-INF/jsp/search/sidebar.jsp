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
                                   id="type-${type.key}" onclick= "searchByFilters('${type.key}')"/>
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
</div>

<script>

    function searchByFilter(category, searchTerm, type, subType) {

      //  var  $contentDiv=$('#results');
        var  $contentDiv=$('#reloadResults');
        var  $tmp=$contentDiv.html();
        var currentURL=window.location.href
        var url;
        url="/toolkit/data/search/results/"+category+"?facetSearch=true&searchTerm="+searchTerm+"&type="+type+"&subType="+subType
        var breadCrumbList=$("#breadcrumb");
            breadCrumbList.html(
                " <ol class=\"breadcrumb\">" +
                "        <!--li class=\"breadcrumb-item active\" aria-current=\"page\">Home</li-->" +
                "<!--li class=\"breadcrumb-item active\"><a onclick=\"+searchByFilter('','"+searchTerm+"','', '')\">Categories</a></li-->"+
                "<li class=\"breadcrumb-item active\"><a href='"+currentURL+"'>Categories</a></li>"+
                "<li class=\"breadcrumb-item \" aria-current=\"page\"><a onclick=\"+searchByFilter('"+category+"','"+searchTerm+"','"+type+"', '"+subType+"')\">"+category+"</a></li>"+
                " </ol>"


        )

        $.get(url, function (data, status) {
            if(category!== typeof undefined)
            breadCrumbList.show();
            else
                breadCrumbList.setAttribute('display','none')

            $contentDiv.html(data);
        })

    }

    $( ":checkbox" ).click(function () {
      //  alert("HELLo");
     //   var  $contentDiv=$('#results');
        var  $contentDiv=$('#reloadResults');
        var selectedType=   $('input[name="typeBkt"]:checked').map(function () {
            return this.value;
        }).get().join(',');
        var selectedSubtype=   $('input[name="subtypeBkt"]:checked').map(function () {
            return this.value;
        }).get().join(',');
        var selectedEditorType=   $('input[name="editorTypeBkt"]:checked').map(function () {
            return this.value;
        }).get().join(',');
        var selectedDsType=   $('input[name="dsTypeBkt"]:checked').map(function () {
            return this.value;
        }).get().join(',');
        var selectedModelType=   $('input[name="modelTypeBkt"]:checked').map(function () {
            return this.value;
        }).get().join(',');

        var selectedSpeciesType=   $('input[name="speciesBkt"]:checked').map(function () {
            return this.value;
        }).get().join(',');
        var selectedWithExperiments=   $('input[name="withExperimentsBkt"]:checked').map(function () {
            return this.value;
        }).get().join(',');
        var selectedTarget=   $('input[name="targetBkt"]:checked').map(function () {
            return this.value;
        }).get().join(',');
        var selectedGuideTargetLocus=   $('input[name="guideTargetLocusBkt"]:checked').map(function () {
            return this.value;
        }).get().join(',');
        var searchTerm=$("#searchTerm")
        var category=$("#category")
      /*  alert("SEARCH TERM:"+searchTerm.val()+"\n"+
            "Category:"+category.val()+"\n"+
        "TYPE:"+selectedType+"\n"+
        "SUBTYPE:"+selectedSubtype);*/
        var url="/toolkit/data/search/results/"+category.val()+"?facetSearch=true&searchTerm="+searchTerm.val()+
            "&type="+selectedType+"&subType="+selectedSubtype +
            "&editorType="+selectedEditorType +
            "&dsType="+selectedDsType+
            "&modelType="+ selectedModelType+
            "&speciesType="+ selectedSpeciesType+
            "&withExperiments="+ selectedWithExperiments+
            "&target="+ selectedTarget+
            "&guideTargetLocus="+ selectedGuideTargetLocus;


            $.get(url, function (data, status) {
            $contentDiv.html(data);
            $.each($('input[name="typeBkt"]'), function(){
                if(selectedType.includes($(this).val())){
                    $(this).prop('checked',true)
                }
            });
            $.each($('input[name="subtypeBkt"]'), function(){

                if(selectedSubtype.includes($(this).val())){
                    $(this).prop('checked',true)
                }
            });
            $.each($('input[name="editorTypeBkt"]'), function(){

                if(selectedEditorType.includes($(this).val())){
                    $(this).prop('checked',true)
                }
            });
            $.each($('input[name="modelTypeBkt"]'), function(){

                if(selectedModelType.includes($(this).val())){
                    $(this).prop('checked',true)
                }
            });
            $.each($('input[name="speciesBkt"]'), function(){

                if(selectedSpeciesType.includes($(this).val())){
                    $(this).prop('checked',true)
                }
            });

                $.each($('input[name="targetBkt"]'), function(){

                    if(selectedTarget.includes($(this).val())){
                        $(this).prop('checked',true)
                    }
                });
                $.each($('input[name="guideTargetLocusBkt"]'), function(){

                    if(selectedGuideTargetLocus.includes($(this).val())){
                        $(this).prop('checked',true)
                    }
                });
                $.each($('input[name="withExperimentsBkt"]'), function(){

                    if(selectedWithExperiments.includes($(this).val())){
                        $(this).prop('checked',true)
                    }
                });
                $.each($('input[name="dsTypeBkt"]'), function(){

                    if(selectedDsType.includes($(this).val())){
                        $(this).prop('checked',true)
                    }
                });
        })
    })

</script>