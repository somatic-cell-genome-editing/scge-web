<%@ page import="edu.mcw.scge.datamodel.Guide" %>
<%@ page import="edu.mcw.scge.datamodel.Delivery" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
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

<% Delivery d = (Delivery) request.getAttribute("system"); %>

<div>
    <div>
        <table  style="width:80%">

            <tbody>
            <tr><td class="header"><strong>SCGE ID</strong></td><td><%=d.getId()%></td></tr>
            <tr><td class="header"><strong>Name</strong></td><td><%=d.getName()%></td></tr>
            <tr><td class="header"><strong>Description</strong></td><td><%=SFN.parse(d.getDescription())%></td></tr>
            <tr><td class="header" width="150"><strong>Type</strong></td><td><%=SFN.parse(d.getType())%></td></tr>
            <tr><td class="header"><strong>Subtype</strong></td><td><%=SFN.parse(d.getSubtype())%></td></tr>
            <tr><td class="header"><strong>Alias</strong></td><td></td></tr>

        </table>
        <hr>
        <table style="width:80%">

            <tr><td class="header"><strong>Mol&nbsp;Targeting&nbsp;Agent</strong></td><td><%=SFN.parse(d.getMolTargetingAgent())%></td></tr>
            <tr><td class="header"><strong>Mol&nbsp;Targeting&nbsp;Agent Details</strong></td><td></td></tr>
        </table>
        <hr>
        <table style="width:80%">
            <tr><td class="header"><strong>Source</strong></td><td><%=SFN.parse(d.getSource())%></td></tr>
            <tr><td class="header"><strong>Stock/Catalog/RRID</strong></td><td><%=SFN.parse(d.getRrid())%></td></tr>
            </tbody>
        </table>
    </div>
    <hr>
</div>

<br>
<jsp:include page="associatedStudies.jsp"/>
<br>
<hr>
<jsp:include page="associatedExperiments.jsp"/>