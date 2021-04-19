<div class="accordion" id="accordion2">
    <div class="accordion-group">
        <div class="accordion-heading">
            <a class="accordion-toggle" data-toggle="collapse" href="#collapseOne">
             Categories
            </a>
        </div>
        <div id="collapseOne" class="accordion-body collapse show" data-parent="#accordion2">
            <div class="accordion-inner">
                <ul class="nav flex-column">
                    <c:forEach items="${aggregations.categoryAggs}" var="bkt">
                        <!--li class="list-group-item"><a href="/toolkit/data/search/results/${bkt.key}?searchTerm=${searchTerm}">${bkt.key}</a> (${bkt.docCount})</li-->
                        <li class="nav-item">
                            <a class="nav-link facet-head" onclick="searchByFilter('${bkt.key}','${searchTerm}','', '')" >
                        <span style="color:#2478c7">${bkt.key}&nbsp;(${bkt.docCount})</span></a>
                            <!--ul>
                        <c:set var="bktName" value="${bkt.key}TypeAggs"/>
                        <c:forEach items="${aggregations.get(bktName)}" var="type">
                            <li> <a class="nav-link" onclick="searchByFilter('${bkt.key}','${searchTerm}','${type.key}','')" >${type.key}(${type.docCount})</a>
                                <ul>
                                <c:set var="subtypeAggsBkt" value="${type.key}SubtypeAggs"/>
                                <c:forEach items="${aggregations.get(subtypeAggsBkt)}" var="subtype">
                                    <li> <a class="nav-link" onclick="searchByFilter('${bkt.key}','${searchTerm}','${type.key}','${subtype.key}')" >${subtype.key} (${subtype.docCount})</a></li>
                                </c:forEach>
                                </ul>
                            </li>
                        </c:forEach>
                    </ul-->
                        </li>


                    </c:forEach>
                </ul>
            </div>
        </div>
    </div>
    <div class="accordion-group">
        <div class="accordion-heading">
            <a class="accordion-toggle" data-toggle="collapse" href="#collapseTwo">
                Filter by Type
            </a>
        </div>
        <div id="collapseTwo" class="accordion-body collapse">
            <div class="accordion-inner">
                <ul class="nav flex-column" >
                    <c:forEach items="${aggregations.categoryAggs}" var="bkt">
                        <li class="list-group-item"><strong>${bkt.key} Type</strong>
                            <!--li class="nav-item"-->
                            <!--input type="checkbox" name="category" value="${bkt.key}" >${bkt.key}&nbsp;(${bkt.docCount})
            <a class="nav-link facet-head" onclick="searchByFilter('${bkt.key}','${searchTerm}','', '')" >
                        <span style="color:#2478c7">${bkt.key}&nbsp;(${bkt.docCount})</span></a-->
                            <ul class="nav flex-column">
                                <c:set var="bktName" value="${bkt.key}TypeAggs"/>
                                <c:forEach items="${aggregations.get(bktName)}" var="type">
                                    <li class="nav-item">  <input type="checkbox" name="type" value="${bkt.key}">${type.key}(${type.docCount})
                                        <!--li> <a class="nav-link" onclick="searchByFilter('${bkt.key}','${searchTerm}','${type.key}','')" >${type.key}(${type.docCount})</a-->
                                        <!--ul>
                                <c:set var="subtypeAggsBkt" value="${type.key}SubtypeAggs"/>
                                <c:forEach items="${aggregations.get(subtypeAggsBkt)}" var="subtype">
                                    <li> <a class="nav-link" onclick="searchByFilter('${bkt.key}','${searchTerm}','${type.key}','${subtype.key}')" >${subtype.key} (${subtype.docCount})</a></li>
                                </c:forEach>
                                </ul-->
                                    </li>
                                </c:forEach>
                            </ul>
                        </li>


                    </c:forEach>

                </ul>
            </div>
        </div>
    </div>
    <div class="accordion-group">
        <div class="accordion-heading">
            <a class="accordion-toggle" data-toggle="collapse" href="#collapseThree">
                Filter by Subtype
            </a>
        </div>
        <div id="collapseThree" class="accordion-body collapse">
            <div class="accordion-inner">
                <ul class="nav flex-column" >
                    <c:forEach items="${aggregations.categoryAggs}" var="bkt">
                        <strong>${bkt.key} Subtype</strong>

                        <!--li class="nav-item"-->
                        <!--input type="checkbox" name="category" value="${bkt.key}" >${bkt.key}&nbsp;(${bkt.docCount})
                        <a class="nav-link facet-head" onclick="searchByFilter('${bkt.key}','${searchTerm}','', '')" >
                        <span style="color:#2478c7">${bkt.key}&nbsp;(${bkt.docCount})</span></a-->
                        <c:set var="bktName" value="${bkt.key}TypeAggs"/>
                        <c:forEach items="${aggregations.get(bktName)}" var="type">
                            <!--li> <a class="nav-link" onclick="searchByFilter('${bkt.key}','${searchTerm}','${type.key}','')" >${type.key}(${type.docCount})</a-->

                            <c:set var="subtypeAggsBkt" value="${type.key}SubtypeAggs"/>
                            <c:forEach items="${aggregations.get(subtypeAggsBkt)}" var="subtype">
                                <!--li> <a class="nav-link" onclick="searchByFilter('${bkt.key}','${searchTerm}','${type.key}','${subtype.key}')" >${subtype.key} (${subtype.docCount})</a></li-->
                                <li class="nav-item"> <input type="checkbox">${subtype.key} (${subtype.docCount})</a></li>

                            </c:forEach>

                        </c:forEach>



                    </c:forEach>
                </ul>
            </div>
        </div>
    </div>
</div>

<script>

    function searchByFilter(category, searchTerm, type, subType) {

        var  $contentDiv=$('#results');
        var  $tmp=$contentDiv.html();
        var url;
        var breadCrumbList=$("#breadcrumb");
            breadCrumbList.html(
                " <ol class=\"breadcrumb\">" +
                "        <!--li class=\"breadcrumb-item active\" aria-current=\"page\">Home</li-->" +
                "<li class=\"breadcrumb-item active\">Categories</li>"+
                "<li class=\"breadcrumb-item \" aria-current=\"page\">"+category+"</li>"+
                " </ol>"


        )

        url="/toolkit/data/search/results/"+category+"?facetSearch=true&searchTerm="+searchTerm+"&type="+type+"&subType="+subType

        $.get(url, function (data, status) {
            breadCrumbList.show();

            $contentDiv.html(data);
        })

    }

</script>