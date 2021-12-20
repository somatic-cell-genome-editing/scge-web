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
<style>
    td{
        font-size: 12px;
        padding-left:1%;
    }
    .header{
        font-weight: bold;
        font-size: 12px;
        color:steelblue;
        width: 25%;
        background-color: #ECECF9;
    }

</style>
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
<div>
    <div>
        <table  style="width:80%">

            <tbody>
            <tr><td class="header"><strong>SCGE ID</strong></td><td><%=v.getVectorId()%></td></tr>
            <tr><td class="header"><strong>Name</strong></td><td><%=v.getName()%></td></tr>
            <tr><td class="header"><strong>Description</strong></td><td><%=SFN.parse(v.getDescription())%></td></tr>
            <tr><td class="header" width="150"><strong>Type</strong></td><td><%=v.getType()%></td></tr>
            <tr><td class="header"><strong>Subtype</strong></td><td><%=SFN.parse(v.getSubtype())%></td></tr>
            <tr><td class="header"><strong>Alias</strong></td><td></td></tr>
        </table>
        <hr>
        <table style="width:80%">

            <tr><td class="header"><strong>Variant</strong></td><td><%=SFN.parse(v.getCapsidVariant())%></td></tr>
            <tr><td class="header"><strong>Source</strong></td><td><%=SFN.parse(v.getSource())%></td></tr>
            <tr><td class="header"><strong>Stock/Catalog/RRID</strong></td><td><%=SFN.parse(v.getLabId())%></td></tr>
        </table>
        <hr>
        <table style="width:80%">
            <tr><td class="header"><strong>Annotated Map</strong></td><td><%=SFN.parse(v.getAnnotatedMap())%></td></tr>
            </tbody>
        </table>
    </div>
    <hr>
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
<jsp:include page="associatedProtocols.jsp"/>
<br>
<jsp:include page="associatedStudies.jsp"/>
<br>
<hr>
<jsp:include page="associatedExperiments.jsp"/>