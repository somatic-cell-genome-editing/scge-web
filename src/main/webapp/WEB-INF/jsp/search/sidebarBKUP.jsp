<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 1/20/2021
  Time: 1:31 PM
  To change this template use File | Settings | File Templates.
--%>
<h3>Filters</h3>
<div id="jstree_results">

    <ul class="nav flex-column" >
        <li class="nav-item"><strong><a onclick="searchByFilter('','${searchTerm}','', '')">All (${sr.hits.totalHits})</a></strong>
            <ul class="nav flex-column">
                <c:forEach items="${aggregations.categoryAggs}" var="bkt">
                    <!--li class="list-group-item"><a href="/toolkit/data/search/results/${bkt.key}?searchTerm=${searchTerm}">${bkt.key}</a> (${bkt.docCount})</li-->
                    <li class="nav-item">
                        <a class="nav-link facet-head" onclick="searchByFilter('${bkt.key}','${searchTerm}','', '')" >
                            <span style="color:#2478c7">${bkt.key}&nbsp;(${bkt.docCount})</span></a>
                        <ul>
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
                        </ul>
                    </li>


                </c:forEach>
            </ul>
        </li>
    </ul>
</div>
<script>

    function searchByFilter(category, searchTerm, type, subType) {

        var  $contentDiv=$('#results');
        var  $tmp=$contentDiv.html();
        var url;
        url="/toolkit/data/search/results/"+category+"?facetSearch=true&searchTerm="+searchTerm+"&type="+type+"&subType="+subType

        $.get(url, function (data, status) {
            $contentDiv.html(data);
        })

    }

</script>
