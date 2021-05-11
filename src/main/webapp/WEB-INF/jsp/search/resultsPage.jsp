<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="col-md-3  sidebar">
    <!--div class="sidebar-sticky"-->
    <%@include file="sidebar.jsp"%>

    <!--/div-->
</div>
<main role="main" class="col-md-9 ml-sm-auto px-4" id="results">
    <%@include file="resultsView.jsp"%>
</main>