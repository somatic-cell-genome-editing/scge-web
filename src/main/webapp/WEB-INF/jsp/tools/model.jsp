<%@ page import="edu.mcw.scge.datamodel.Model" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/29/2020
  Time: 4:25 PM
  To change this template use File | Settings | File Templates.
--%>


<% Model m = (Model) request.getAttribute("model"); %>
<%
    Access access= new Access();
    Person p = access.getUser(request.getSession());

    if (access.isAdmin(p)) {
%>

<div align="right"><a href="/toolkit/data/models/edit?id=<%=m.getModelId()%>"><button class="btn btn-primary">Edit</button></a></div>
<% } %>
<div class="col-md-2 sidenav bg-light">
    <a href="#summary">Summary</a>
    <!--a href="#associatedProtocols">Protocols</a-->
    <a href="#associatedStudies">Projects & Experiments</a>
</div>
<main role="main" class="col-md-10 ml-sm-auto px-4"  >
<%@include file="summary.jsp"%>

<%
    long objectId = m.getModelId();
    String redirectURL = "/data/models/model?id=" + objectId;
    String bucket="main1";

%>

<%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
<% bucket="main2"; %>
<%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
<% bucket="main3"; %>
<%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
<% bucket="main4"; %>
<%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
<% bucket="main5"; %>
<%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>

<div id="associatedProtocols">
    <%@include file="/WEB-INF/jsp/tools/associatedProtocols.jsp"%>
</div>


<div id="associatedPublications">
    <%@include file="/WEB-INF/jsp/tools/publications/associatedPublications.jsp"%>
</div>

    <div id="associatedStudies">
<jsp:include page="associatedStudies.jsp"/>
    </div>



</main>