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
<link href="/common/tableSorter/css/filter.formatter.css" rel="stylesheet" type="text/css"/>
<link href="/common/tableSorter/css/theme.jui.css" rel="stylesheet" type="text/css"/>
<link href="/common/tableSorter/css/theme.blue.css" rel="stylesheet" type="text/css"/>

<script src="/common/tableSorter/js/tablesorter.js"> </script>
<script src="/common/tableSorter/js/jquery.tablesorter.widgets.js"></script>
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

<% Model m = (Model) request.getAttribute("model"); %>


<div>
    <div>
        <table  style="width:80%">
            <tr ><td class="header"><strong>SCGE ID</strong></td><td><%=m.getModelId()%></td></tr>
            <tr><td class="header"><strong>Name</strong></td><td><%=m.getName()%></td></tr>
            <tr><td class="header"><strong>Description</strong></td><td><%=SFN.parse(m.getDescription())%></td></tr>
            <tr><td class="header"><strong>Type</strong></td><td><%=m.getType()%></td></tr>
            <tr><td class="header"><strong>Subtype</strong></td><td><%=SFN.parse(m.getSubtype())%></td></tr>
            <tr><td class="header"><strong>Alias</strong></td><td></td></tr>
        </table>
        <hr>

        <table style="width:80%">
            <tr><td class="header"><strong>Parental&nbsp;Origin</strong></td><td><%=SFN.parse(m.getParentalOrigin())%></td></tr>
            <tr><td class="header"><strong>Organism</strong></td><td><%=m.getOrganism()%></td></tr>
            <tr><td class="header"><strong>Source</strong></td><td><%=SFN.parse(m.getSource())%></td></tr>
        </table>
        <hr>

        <table style="width:80%">
            <tr><td class="header"><strong>Transgene</strong></td><td><%=SFN.parse(m.getTransgene())%></td></tr>
            <tr><td class="header"><strong>Transgene Description</strong></td><td><%=SFN.parse(m.getTransgeneDescription())%></td></tr>
            <tr><td class="header"><strong>Reporter</strong></td><td><%=SFN.parse(m.getTransgeneReporter())%></td></tr>
        <tr><td class="header"><strong>Annotated Map</strong></td><td><%=SFN.parse(m.getAnnotatedMap())%></td></tr>

        </table>
    </div>
    <hr>
</div>

<%
    long objectId = m.getModelId();
    String objectType= ImageTypes.MODEL;
    String redirectURL = "/data/models/model?id=" + objectId;
    String bucket="main";

%>

<%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
<br>
<jsp:include page="associatedStudies.jsp"/>
<br>
<hr>
<jsp:include page="associatedExperiments.jsp"/>
