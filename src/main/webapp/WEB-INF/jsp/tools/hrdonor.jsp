<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.storage.ImageTypes" %>
<%@ page import="edu.mcw.scge.datamodel.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>



<% HRDonor h = (HRDonor) request.getAttribute("hrdonor"); %>

<%
    Access access= new Access();
    Person p = access.getUser(request.getSession());
%>

<div class="col-md-2 sidenav bg-light">
    <a href="#summary">Summary</a>
    <a href="#associatedProtocols">Protocols</a>
    <a href="#associatedStudies">Projects & Experiments</a>
</div>
<main role="main" class="col-md-10 ml-sm-auto px-4"  >
    <%@include file="summary.jsp"%>


<%
    long objectId = h.getId();
    String redirectURL = "/data/hrdonors/hrdonor?id=" + objectId;
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
<br>
<div id="associatedProtocols">
    <%@include file="/WEB-INF/jsp/tools/associatedProtocols.jsp"%>
</div>
<hr>
<div id="associatedPublications">
    <%@include file="/WEB-INF/jsp/tools/publications/associatedPublications.jsp"%>
</div>
        <div id="associatedStudies">
<jsp:include page="associatedStudies.jsp"/>
        </div>


