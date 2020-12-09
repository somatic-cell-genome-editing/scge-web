<%@ page import="edu.mcw.scge.datamodel.Guide" %>
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
<link href="https://rgd.mcw.edu/rgdweb/common/tableSorter/css/filter.formatter.css" rel="stylesheet" type="text/css"/>
<link href="https://rgd.mcw.edu/rgdweb/common/tableSorter/css/theme.jui.css" rel="stylesheet" type="text/css"/>
<link href="https://rgd.mcw.edu/rgdweb/common/tableSorter/css/theme.blue.css" rel="stylesheet" type="text/css"/>

<script src="https://rgd.mcw.edu/rgdweb/common/tableSorter/js/tablesorter.js"> </script>
<script src="https://rgd.mcw.edu/rgdweb/common/tableSorter/js/jquery.tablesorter.widgets.js"></script>
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

<% Guide g = (Guide) request.getAttribute("guide"); %>

<div>
    <div>
        <table  style="width:80%">

            <tbody>
            <tr><td class="header"><strong>ID</strong></td><td><%=g.getGuide_id()%></td></tr>
            <tr><td class="header"><strong>Guide</strong></td><td><%=g.getGuide()%></td></tr>
            <tr><td class="header"><strong>Species</strong></td><td><%=g.getSpecies()%></td></tr>
            <tr><td class="header"><strong>Target Locus</strong></td><td><%=g.getTargetLocus()%></td></tr>
            <tr><td class="header"><strong>Target Sequence</strong></td><td><%=g.getTargetSequence()%></td></tr>
            <tr><td class="header"><strong>PAM</strong></td><td><%=g.getPam()%></td></tr>
            <tr><td class="header"><strong>Assembly</strong></td><td><%=g.getAssembly()%></td></tr>
            <tr><td class="header"><strong>Chr</strong></td><td><%=g.getChr()%></td></tr>
            <tr><td class="header"><strong>Start</strong></td><td><%=g.getStart()%></td></tr>
            <tr><td class="header"><strong>Stop</strong></td><td><%=g.getStop()%></td></tr>
            <tr><td class="header"><strong>Strand</strong></td><td><%=g.getStrand()%></td></tr>
            <tr><td class="header"><strong>GRna Lab ID</strong></td><td><%=g.getGrnaLabId()%></td></tr>
            <tr><td class="header"><strong>GRna Format</strong></td><td><%=g.getgRnaFormat()%></td></tr>
            <tr><td class="header"><strong>Spacer Sequence</strong></td><td><%=g.getSpacerSequence()%></td></tr>
            <tr><td class="header"><strong>Spacer Length</strong></td><td><%=g.getSpacerLength()%></td></tr>
            <tr><td class="header"><strong>Repeat Sequence</strong></td><td><%=g.getRepeatSequence()%></td></tr>
            <tr><td class="header"><strong>Detection Method</strong></td><td><%=g.getDetectionMethod()%></td></tr>
            <tr><td class="header"><strong>Forward Primer</strong></td><td><%=g.getForwardPrimer()%></td></tr>
            <tr><td class="header"><strong>Linker Sequence</strong></td><td><%=g.getLinkerSequence()%></td></tr>
            <tr><td class="header"><strong>Anti-Repeat Sequence</strong></td><td><%=%>></td></tr>
            <tr><td class="header"><strong>Stemloop 1 Sequence</strong></td><td><%=%>></td></tr>
            <tr><td class="header"><strong>Stemloop 2 Sequence</strong></td><td><%=%>></td></tr>
            <tr><td class="header"><strong>Stemloop 3 Sequence</strong></td><td><%=%>></td></tr>
            <tr><td class="header"><strong>Source</strong></td><td><%=%>></td></tr>

            </tbody>
        </table>
    </div>
    <hr>
</div>

<%@include file="associatedStudies.jsp"%>