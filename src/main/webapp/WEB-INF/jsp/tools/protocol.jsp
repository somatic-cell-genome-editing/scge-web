<%@ page import="edu.mcw.scge.datamodel.Model" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.storage.ImageTypes" %>
<%@ page import="edu.mcw.scge.datamodel.Protocol" %>
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


<% Protocol p = (Protocol) request.getAttribute("protocol"); %>

<div>
        <table  style="width:80%">
            <tr><td class="header"><strong>Title</strong></td><td><%=p.getTitle()%></td></tr>
            <tr><td class="header"><strong>Description</strong></td><td><%=p.getDescription()%></td></tr>
            <tr><td class="header"><strong>SCGE ID</strong></td><td><%=p.getId()%></td></tr>
            <tr><td class="header"><strong>Tier</strong></td><td><%=p.getTier()%></td></tr>
            <tr><td class="header"><strong>File Download</strong></td><td><%=p.getFilename()%></td></tr>
            <tr><td class="header"><strong>Additional Information</strong></td><td><%=p.getXref()%></td></tr>
            <tr><td class="header"><strong>Keywords</strong></td><td><%=p.getKeywords()%></td></tr>
        </table>
    <hr>
</div>

<%
    long objectId = p.getId();
    String redirectURL = "/data/protocols/protocol?id=" + objectId;
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


