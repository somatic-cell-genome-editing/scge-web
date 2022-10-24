<%@ page import="edu.mcw.scge.datamodel.Guide" %>
<%@ page import="edu.mcw.scge.datamodel.Delivery" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.datamodel.Vector" %>
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

<% Vector v = (Vector) request.getAttribute("vector"); %>
<%
    Access access= new Access();
    Person p = access.getUser(request.getSession());

    if (access.isAdmin(p)) {
%>

<div align="right"><a href="/toolkit/data/vector/edit?id=<%=v.getVectorId()%>"><button class="btn btn-primary">Edit</button></a></div>
<% } %>
<div class="col-md-2 sidenav bg-light">

    <a href="#summary">Summary</a>

    <a href="#associatedProtocols">Protocols</a>

    <a href="#associatedStudies">Projects & Experiments</a>
    <!--a href="#publications">Related Publications</a-->


</div>
<main role="main" class="col-md-10 ml-sm-auto px-4"  >
    <div id="summary">
        <h4 class="page-header" style="color:grey;">Summary</h4>

        <div class="d-flex bg-light" >
            <div class="col-7">

        <table class="table table-sm summary">
            <tr><td class="header">Name</td><td><%=v.getName()%></td></tr>
            <tr><td class="header">Description</td><td><%=SFN.parse(v.getDescription())%></td></tr>
            <tr><td class="header" width="150">Type</td><td><%=v.getType()%></td></tr>
            <tr><td class="header">Subtype</td><td><%=SFN.parse(v.getSubtype())%></td></tr>

            <tr><td colspan="2"><hr></td></tr>

            <tr><td class="header">Source</td><td><%=SFN.parse(v.getSource())%></td></tr>
            <tr><td class="header">Catalog</td><td></td></tr>
            <tr><td class="header">RRID</td><td></td></tr>
            <tr><td colspan="2"><hr></td></tr>


            <tr><td class="header">Genome Serotype</td><td><%=SFN.parse(v.getGenomeSerotype())%></td></tr>
            <tr><td class="header">Capsid Serotype</td><td><%=SFN.parse(v.getCapsidSerotype())%></td></tr>
            <tr><td class="header">Capsid Variant</td><td><%=SFN.parse(v.getCapsidVariant())%></td></tr>

            <!--
            <% if (v.getSource().toLowerCase().equals("addgene")) { %>
                <tr><td class="header">Stock/Catalog/RRID</td><td><a href="https://www.addgene.org/<%=SFN.parse(v.getLabId())%>/">https://www.addgene.org/<%=SFN.parse(v.getLabId())%>/</a></td></tr>
            <% } else {%>
                <tr><td class="header">Stock/Catalog/RRID</td><td><%=SFN.parse(v.getLabId())%></td></tr>
            <% } %>

            -->
            <tr><td colspan="2"><hr></td></tr>

            <tr><td class="header">Annotated Map</td><td><%=SFN.parse(v.getAnnotatedMap())%></td></tr>

        </table>
    </div>
            <div class="ml-auto col-3" style="margin-right: 5%">

                <div class="card">
                    <!--<div class="card-header">SCGE ID</div>-->
                    <div class="card-body">
                        <table >
                            <tr ><th class="scge-details-label" style="color:black;">SCGE:<%=v.getVectorId()%></th></tr>

                        </table>
                    </div>
                </div>
            </div>
</div>
    </div>
<%
    long objectId = v.getVectorId();
    String redirectURL = "/data/vector/format?id=" + objectId;
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
<hr>
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