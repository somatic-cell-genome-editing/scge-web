<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 1/20/2021
  Time: 1:31 PM
  To change this template use File | Settings | File Templates.
--%>

<ul class="nav flex-column">
    <li class="nav-item"><a href="/toolkit/data/search/results?searchTerm=${searchTerm}"><strong>All</strong> (${sr.hits.totalHits})</a>
        <ul class="nav flex-column">
            <c:forEach items="${aggregations.categoryAggs}" var="bkt">
                <!--li class="list-group-item"><a href="/toolkit/data/search/results/${bkt.key}?searchTerm=${searchTerm}">${bkt.key}</a> (${bkt.docCount})</li-->
                <li class="nav-item">
                    <a class="nav-link" onclick="searchByFilter('${bkt.key}','${searchTerm}')">
                        <span data-feather=""></span>
                            ${bkt.key}&nbsp;(${bkt.docCount})</a>
                </li>


            </c:forEach>
        </ul>
    </li>
</ul>

<script>

    function searchByFilter(category, searchTerm) {

        var  $contentDiv=$('#results');
        var  $tmp=$contentDiv.html();
        var url;
        url="/toolkit/data/search/results/"+category+"?facetSearch=true&searchTerm="+searchTerm

        $.get(url, function (data, status) {
            $contentDiv.html(data);
        })

    }

</script>
