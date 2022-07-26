<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<script>
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
                        <button class="btn btn-light btn-sm " value="${filter}" onclick="removeFilter('${filter}', '${termList.key}')">${filter}&nbsp;<i class="fa fa-times-circle" style="font-size:15px;color:red" ></i></button>
                    </c:forEach>
                </c:forEach>
            </c:if>
        </span>
        </c:if>

<ul class="nav nav-tabs" role="tablist">
        <li class="nav-item">
            <a class="nav-link active" data-toggle="tab" href="#listView" role="tab">
                <span data-feather="list"></span>&nbsp;List View</a>
        </li>
        <li class="nav-item">
            <a class="nav-link" data-toggle="tab" href="#tableView" role="tab">
                <span data-feather="grid"></span>&nbsp;Table View</a>
        </li>

    </ul>

    <!-- Tab panes -->
    <div class="tab-content">
        <div class="tab-pane active" id="listView" role="tabpanel">
            <%@include file="resultsList.jsp"%>
        </div>
        <div class="tab-pane" id="tableView" role="tabpanel">
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