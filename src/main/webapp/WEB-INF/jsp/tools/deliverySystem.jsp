<%@ page import="edu.mcw.scge.datamodel.Guide" %>
<%@ page import="edu.mcw.scge.datamodel.Delivery" %>
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
    }
</style>
<script>
    $(function() {
        $("#myTable").tablesorter({
            theme : 'blue'

        });
    });
</script>

hello

<% Delivery d = (Delivery) request.getAttribute("system"); %>

<div>
    <div>
        <table  style="width:80%">

            <tbody>
            <tr><td class="header"><strong>ID</strong></td><td><%=d.getId()%></td></tr>
            <tr><td class="header"><strong>Type</strong></td><td><%=d.getType()%></td></tr>
            <tr><td class="header"><strong>Subtype</strong></td><td><%=d.getSubtype()%></td></tr>
            <tr><td class="header"><strong>Name</strong></td><td><%=d.getName()%></td></tr>
            <tr><td class="header"><strong>Source</strong></td><td><%=d.getSource()%></td></tr>
            <tr><td class="header"><strong>Description</strong></td><td><%=d.getDescription()%></td></tr>
            <tr><td class="header"><strong>Genome Serotype</strong></td><td><%=d.getVvGenomeSerotype()%></td></tr>
            <tr><td class="header"><strong>Capsid Serotype</strong></td><td><%=d.getVvCapsidSerotype()%></td></tr>
            <tr><td class="header"><strong>Annotated Map</strong></td><td><%=d.getAnnotatedMap()%></td></tr>
            <tr><td class="header"><strong>Lab ID</strong></td><td><%=d.getLabId()%></td></tr>
            <tr><td class="header"><strong>Capsid Variant</strong></td><td><%=d.getVvCapsidVariant()%></td></tr>
            <tr><td class="header"><strong>Titer Method</strong></td><td><%=d.getTiterMethod()%></td></tr>
            <tr><td class="header"><strong>RRID</strong></td><td><%=d.getRrid()%></td></tr>
            <tr><td class="header"><strong>NP Size</strong></td><td><%=d.getNpSize()%></td></tr>
            <tr><td class="header"><strong>Mol Targeting Agent</strong></td><td><%=d.getMolTargetingAgent()%></td></tr>

            </tbody>
        </table>
    </div>
    <hr>
</div>

<%@include file="associatedStudies.jsp"%>