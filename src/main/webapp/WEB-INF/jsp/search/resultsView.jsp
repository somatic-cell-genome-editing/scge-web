<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script>

       var view='${selectedView}'
       $(function () {
           if(view=='table'){
               $('#listViewTab').removeClass('active')
               $('#listViewContent').removeClass('active')
               $('#tableViewTab').addClass('active')
               $('#tableViewContent').addClass('active')
           }else{
               $('#listViewTab').addClass('active')
               $('#listViewContent').addClass('active')
               $('#tableViewTab').removeClass('active')
               $('#tableViewContent').removeClass('active')
           }
       })




    function switchView(view) {
    $('#selectedView').val(view)
        if(view=='table'){
            $('#listViewTab').removeClass('active')
            $('#listViewContent').removeClass('active')
            $('#tableViewTab').addClass('active')
            $('#tableViewContent').addClass('active')
        }else{
            $('#listViewTab').addClass('active')
            $('#listViewContent').addClass('active')
            $('#tableViewTab').removeClass('active')
            $('#tableViewContent').removeClass('active')
        }
}

function removeFilter(filter, name) {
        $.each($('input[type="checkbox"]'),function () {
            var _this=$(this);
            var val=_this.val();

            if(val==filter){
                _this.prop('checked',false);
                $('#unchecked').val(val);
            }

        });
        $('#sidebarForm').submit()
    }
</script>
<c:choose>
    <c:when test="${fn:length(sr.hits.hits)>0}">
        <c:if test="${fn:length(selectedFilters)>0}">
        <span><strong style="color:black">Remove Filters:</strong>
            <button class="btn btn-light btn-sm" value="all">
                <c:choose>
                    <c:when test="${category!=null}">
                        <a href="/toolkit/data/search/results/${category}?searchTerm=${searchTerm}">All&nbsp;<i class="fa fa-times-circle" style="font-size:15px;color:red"></i></a>

                    </c:when>
                    <c:otherwise>
                        <a href="/toolkit/data/search/results?searchTerm=${searchTerm}">All&nbsp;<i class="fa fa-times-circle" style="font-size:15px;color:red"></i></a>

                    </c:otherwise>
                </c:choose>
            </button>
            <c:if test="${fn:length(sr.hits.hits)>0}">
                <c:forEach items="${selectedFilters}" var="termList">
                    <c:forEach items="${termList.value}" var="filter">
                        <c:set var="flag" value="false"/>
                        <c:forEach items="${aggregations}" var="agg">
                        <c:if test="${fn:length(agg.value.buckets)>0}">
                            <c:forEach items="${agg.value.buckets}" var="bkt">
                                <c:if test="${bkt.key==filter}">
                                    <c:set var="flag" value="true"/>
                                </c:if>
                            </c:forEach>
                        </c:if>
                        </c:forEach>
                        <c:if test="${flag=='true'}">
                        <button class="btn btn-light btn-sm " value="${filter}" onclick="removeFilter('${filter}', '${termList.key}')">${filter}&nbsp;<i class="fa fa-times-circle" style="font-size:15px;color:red" ></i></button>
                        </c:if>
                    </c:forEach>
                </c:forEach>
            </c:if>
        </span>
        </c:if>

<ul class="nav nav-tabs" role="tablist" >
        <li class="nav-item">
            <a class="nav-link active" id="listViewTab" data-toggle="tab" href="#listView" onclick="switchView('list')" role="tab">
                <span data-feather="list"></span>&nbsp;List View</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" data-toggle="tab" id="tableViewTab" href="#tableView" onclick="switchView('table')" role="tab">
                <span data-feather="grid"></span>&nbsp;Table View</a>
        </li>

    </ul>

    <!-- Tab panes -->
    <div class="tab-content">
        <div class="tab-pane active" id="listViewContent" role="tabpanel">
            <%@include file="resultsList.jsp"%>
        </div>
        <div class="tab-pane" id="tableViewContent" role="tabpanel">
            <%@include file="resultsTable.jsp"%></div>

    </div>
    </c:when>
    <c:otherwise>
        <%@include file="zeroResults.jsp"%>
    </c:otherwise>

</c:choose>

    <script src="https://unpkg.com/feather-icons/dist/feather.min.js"></script>
    <script>
        feather.replace()
    </script>