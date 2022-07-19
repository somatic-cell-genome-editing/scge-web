<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:choose>
    <c:when test="${fn:length(sr.hits.hits)>0}">


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

</c:choose>

    <script src="https://unpkg.com/feather-icons/dist/feather.min.js"></script>
    <script>
        feather.replace()
    </script>