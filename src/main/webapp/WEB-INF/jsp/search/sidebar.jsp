<input type="hidden" name="searchTerm" id="searchTerm" value="${searchTerm}"/>
<input type="hidden" name="category" id="category" value="${category}" >
<div class="accordion" id="accordion2">
    <div class="accordion-group">
        <c:if test="${fn:length(aggregations.catBkts)>1}">
        <div class="accordion-heading card-header">

            <a class="accordion-toggle" data-toggle="collapse" href="#collapseOne">
             Categories
            </a>

        </div>
        </c:if>
        <c:choose>
            <c:when test="${fn:length(aggregations.catBkts)==1}">

                <div>
                    <c:forEach items="${aggregations.catBkts}" var="bkt">
                            <!--li class="list-group-item"><a href="/toolkit/data/search/results/${bkt.key}?searchTerm=${searchTerm}">${bkt.key}</a> (${bkt.docCount})</li-->
                        <a class="nav-link facet-head" onclick="searchByFilter('${bkt.key}','${searchTerm}','', '')" -->
                            <span style="color:#2478c7">${bkt.key}&nbsp;(${bkt.docCount})</span></a>

                    </c:forEach>

                </div>
            </c:when>
            <c:otherwise>
                <div id="collapseOne" class="accordion-body collapse show" data-parent="#accordion2">
                    <div class="accordion-inner">
                        <ul class="nav flex-column">
                            <c:forEach items="${aggregations.catBkts}" var="bkt">
                                <!--li class="list-group-item"><a href="/toolkit/data/search/results/${bkt.key}?searchTerm=${searchTerm}">${bkt.key}</a> (${bkt.docCount})</li-->
                                <li class="nav-item">

                                    <a class="nav-link facet-head" href="/toolkit/data/search/results/${bkt.key}?searchTerm=${searchTerm}">
                                        <span style="color:#2478c7">${bkt.key}&nbsp;(${bkt.docCount})</span></a>

                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>


    </div>
    <c:if test="${fn:length(aggregations.typeBkts)>0}">


    <div class="accordion-group">
        <div class="accordion-heading card-header">
            <a class="accordion-toggle" data-toggle="collapse" href="#collapseTwo">
                Filter by Type
            </a>
        </div>
        <div id="collapseTwo" class="accordion-body collapse show">
            <div class="accordion-inner">
                <ul class="nav flex-column" >
                    <c:forEach items="${aggregations.typeBkts}" var="type">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="typeBkt" value="${type.key}"
                                   id="type-${type.key}" onclick= searchByFilters('${type.key}')>
                            <label class="form-check-label" for="type-${type.key}">
                               ${type.key}(${type.docCount})

                            </label>

                        </div>

                    </c:forEach>

                </ul>
            </div>
        </div>
    </div>
        <c:if test="${fn:length(aggregations.subtypeBkts)>0}">
    <div class="accordion-group">
        <div class="accordion-heading card-header">
            <a class="accordion-toggle" data-toggle="collapse" href="#collapseThree">
                Filter by Subtype
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
                    Filter by Editor
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
                    Filter by Delivery System
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
                    Filter by Model
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
        var  $contentDiv=$('#results');

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
        var searchTerm=$("#searchTerm")
        var category=$("#category")
      /*  alert("SEARCH TERM:"+searchTerm.val()+"\n"+
            "Category:"+category.val()+"\n"+
        "TYPE:"+selectedType+"\n"+
        "SUBTYPE:"+selectedSubtype);*/
        var url="/toolkit/data/search/results/"+category.val()+"?filter=true&searchTerm="+searchTerm.val()+
            "&type="+selectedType+"&subType="+selectedSubtype +
            "&editorType="+selectedEditorType +
            "&dsType="+selectedDsType+
            "&modelType="+ selectedModelType

        $.get(url, function (data, status) {

            $contentDiv.html(data);
        })
    })

</script>