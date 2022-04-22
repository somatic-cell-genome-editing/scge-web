<%@ page import="edu.mcw.scge.datamodel.Guide" %>
<%@ page import="edu.mcw.scge.datamodel.Delivery" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.storage.ImageTypes" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/29/2020
  Time: 4:25 PM
  To change this template use File | Settings | File Templates.
--%>

<link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" integrity="sha384-AYmEC3Yw5cVb3ZcuHtOA93w35dYTsvhLPVnYs9eStHfGJvOvKxVfELGroGkvsg+p" crossorigin="anonymous"/>
<link href="/toolkit/css/reportPage.css" rel="stylesheet" type="text/css"/>

<script>
    $(function() {
        $("#myTable").tablesorter({
            theme : 'blue'

        });
    });
</script>

<% Delivery d = (Delivery) request.getAttribute("system"); %>

<%
    Access access= new Access();
    Person p = access.getUser(request.getSession());

    if (access.isAdmin(p)) {
%>

<div align="right"><a href="/toolkit/data/delivery/edit?id=<%=d.getId()%>"><button class="btn btn-primary">Edit</button></a></div>
<% } %>

<div class="col-md-2 sidenav bg-light">

    <a href="#summary">Summary</a>

    <a href="#associatedProtocols">Protocols</a>

    <a href="#associatedStudies">Associated Studies</a>
    <a href="#associatedExperiments">Associated Experiments</a>
    <!--a href="#publications">Related Publications</a-->


</div>
<main role="main" class="col-md-10 ml-sm-auto px-4"  >
    <div id="summary">
        <h4 class="page-header" style="color:grey;">Summary</h4>

        <div class="d-flex bg-light" >
            <div class="col-7">

        <table class="table table-sm summary">


            <tr><td class="header">Name</td><td><%=d.getName()%></td></tr>
            <tr><td class="header">Description</td><td><%=SFN.parse(d.getDescription())%></td></tr>
            <tr><td class="header" width="150">Type</td><td><%=SFN.parse(d.getType())%></td></tr>
            <tr><td class="header">Subtype</td><td><%=SFN.parse(d.getSubtype())%></td></tr>
            <tr><td class="header">Sequence</td><td><%=SFN.parse(d.getSequence())%></td></tr>
            <tr><td class="header">Annotated&nbsp;Map</td><%=SFN.parse(d.getAnnotatedMap())%><td></td></tr>



        <%if(d.getType().equalsIgnoreCase("Nanoparticle")) { %>


            <tr><td class="header">Nanopartical&nbsp;Size</td><td><%=SFN.parse(d.getNpSize())%></td></tr>
            <tr><td class="header">Zeta&nbsp;Potential</td><td><%=SFN.parse(d.getZetaPotential())%></td></tr>
            <tr><td class="header">Poly&nbsp;Dispersity&nbsp;Index</td><td><%=SFN.parse(d.getNpPolydispersityIndex())%></td></tr>

        <%} %>

            <tr><td class="header">Source</td><td><%=SFN.parse(d.getSource())%></td></tr>
            <tr><td class="header">Stock/Catalog/RRID</td><td><%=SFN.parse(d.getRrid())%></td></tr>

        </table>
    </div>
            <div class="ml-auto col-3" style="margin-right: 5%">

                <div class="card">
                    <div class="card-header">Delivery System</div>
                    <div class="card-body">
                        <table >
                            <tr ><th class="scge-details-label">SCGE:<%=d.getId()%></th></tr>

                        </table>
                    </div>
                </div>
            </div>
</div>

<%
    long objectId = d.getId();
    String redirectURL = "/data/delivery/system?id=" + objectId;
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


        <div id="associatedStudies">
<br>
<div id="associatedPublications">
    <%@include file="/WEB-INF/jsp/tools/publications/associatedPublications.jsp"%>
</div>
<br>
<jsp:include page="associatedStudies.jsp"/>
        </div>

        <div id="associatedExperiments">
<jsp:include page="associatedExperiments.jsp"/>
        </div>

</main>