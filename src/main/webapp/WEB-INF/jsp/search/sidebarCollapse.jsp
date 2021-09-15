



<div class="accordion" id="accordionExample">
    <div class="card">
        <div class="card-header" id="headingOne">
            <h2 class="mb-0">
                <button class="btn btn-link" type="button" data-toggle="collapse" data-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                    Filter by Category
                </button>
            </h2>
        </div>

        <div id="collapseOne" class="collapse show" aria-labelledby="headingOne" data-parent="#accordionExample">
            <div class="card-body">
                <ul class="nav flex-column">
                    <c:forEach items="${aggregations.categoryAggs}" var="bkt">
                        <!--li class="list-group-item"><a href="/toolkit/data/search/results/${bkt.key}?searchTerm=${searchTerm}">${bkt.key}</a> (${bkt.docCount})</li-->
                        <li class="nav-item">
                            <input type="checkbox" name="category" value="${bkt.key}" >${bkt.key}&nbsp;(${bkt.docCount})
                            <!--a class="nav-link facet-head" onclick="searchByFilter('${bkt.key}','${searchTerm}','', '')" >
                        <span style="color:#2478c7">${bkt.key}&nbsp;(${bkt.docCount})</span></a-->
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
    <div class="card">
        <div class="card-header" id="headingTwo">
            <h2 class="mb-0">
                <button class="btn btn-link collapsed" type="button" data-toggle="collapse" data-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                    Filter by Type
                </button>
            </h2>
        </div>
        <div id="collapseTwo" class="collapse" aria-labelledby="headingTwo" data-parent="#accordionExample">
            <div class="card-body">
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
    <div class="card">
        <div class="card-header" id="headingThree">
            <h2 class="mb-0">
                <button class="btn btn-link collapsed" type="button" data-toggle="collapse" data-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                    Filter by Subtype
                </button>
            </h2>
        </div>
        <div id="collapseThree" class="collapse" aria-labelledby="headingThree" data-parent="#accordionExample">
            <div class="card-body">
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

