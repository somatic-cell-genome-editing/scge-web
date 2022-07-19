<%@ page import="edu.mcw.scge.datamodel.Model" %>
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
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>

<link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" integrity="sha384-AYmEC3Yw5cVb3ZcuHtOA93w35dYTsvhLPVnYs9eStHfGJvOvKxVfELGroGkvsg+p" crossorigin="anonymous"/>
<link href="/toolkit/css/reportPage.css" rel="stylesheet" type="text/css"/>

<script>
    $(function() {
        $("#myTable").tablesorter({
            theme : 'blue'

        });
    });
</script>

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

        <table  class="table table-sm summary">
            <tr><td class="header">Name</td><td><%=m.getDisplayName()%></td></tr>
            <tr><td class="header">Alias</td><td></td></tr>
            <tr><td class="header">Official Name</td><td></td></tr>
            <tr><td class="header">Species</td><td><%=m.getOrganism()%></td></tr>
            <tr><td class="header">Type</td><td><%=m.getType()%></td></tr>
            <tr><td class="header">Subtype</td><td><%=SFN.parse(m.getSubtype())%></td></tr>
            <tr><td class="header">Description</td><td><%=SFN.parse(m.getDescription())%></td></tr>
            <tr><td class="header">Parental&nbsp;Origin</td><td><%=SFN.parse(m.getParentalOrigin())%></td></tr>
            <tr><td colspan="2"><hr></td></tr>

            <tr><td class="header">Source</td><td><%=SFN.parse(m.getSource())%></td></tr>
            <tr><td class="header">Catalog</td><td></td></tr>
            <tr><td class="header">RRID</td><td><%=SFN.parse(m.getRrid())%></td></tr>

            <tr><td colspan="2"><hr></td></tr>

            <tr><td class="header">Transgene</td><td><%=SFN.parse(m.getTransgene())%></td></tr>
            <tr><td class="header">Transgene Description</td><td><%=SFN.parse(m.getTransgeneDescription())%></td></tr>
            <tr><td class="header">Reporter</td><td><%=SFN.parse(m.getTransgeneReporter())%></td></tr>
        <tr><td class="header">Annotated Map</td><td><%=SFN.parse(m.getAnnotatedMap())%></td></tr>

        </table>

        </div>

        <div class="ml-auto col-3" style="margin-right: 5%">

            <div class="card">
                <!--<div class="card-header">Model</div>-->
                <div class="card-body">
                    <table >
                        <tr ><th class="scge-details-label" style="color:black;">SCGE:<%=m.getModelId()%></th></tr>

                    </table>
                </div>
            </div>
        </div>
        </div>
    </div>

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

<br>
<div id="associatedPublications">
    <%@include file="/WEB-INF/jsp/tools/publications/associatedPublications.jsp"%>
</div>
<br>
    <div id="associatedStudies">
<jsp:include page="associatedStudies.jsp"/>
    </div>
<br>
    <div id="associatedExperiments">
<jsp:include page="associatedExperiments.jsp"/>
    </div>

</main>