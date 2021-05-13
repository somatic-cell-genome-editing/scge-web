<%@ page import="edu.mcw.scge.datamodel.Guide" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.datamodel.Editor" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.web.UI" %>
<%@ page import="edu.mcw.scge.datamodel.OffTarget" %>
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

<% Guide g = (Guide) request.getAttribute("guide"); %>
<% List<Editor> relatedEditors = (List<Editor>) request.getAttribute("editors");
    List<OffTarget> offTargets = (List<OffTarget>) request.getAttribute("offTargets");
%>

<div>
    <div>
        <table  style="width:80%">


            <tr ><td class="header"><strong>SCGE ID</strong></td><td><%=g.getGuide_id()%></td></tr>
            <tr ><td class="header"><strong>Name</strong></td><td><%=SFN.parse(g.getGrnaLabId())%></td></tr>
            <tr ><td class="header"><strong>Description</strong></td><td><%=SFN.parse(g.getGuideDescription())%></td></tr>
            <tr ><td class="header"><strong>Type</strong></td><td></td></tr>
            <tr ><td class="header" width="150"><strong>Subtype</strong></td><td></td></tr>
            <tr ><td class="header" width="150"><strong>Alias</strong></td><td></td></tr>
        </table>
        <hr>
        <table style="width:80%">
            <tr ><td class="header"><strong>Species</strong></td><td><%=SFN.parse(g.getSpecies())%></td></tr>
            <tr ><td class="header"><strong>Target Locus</strong></td><td><%=SFN.parse(g.getTargetLocus())%></td></tr>
            <tr ><td class="header"><strong>Target Sequence</strong></td><td><%=SFN.parse(g.getTargetSequence())%></td></tr>
            <tr ><td class="header"><strong>Target Sequence + PAM</strong></td><td><%=SFN.parse(g.getPam())%></td></tr>
            <tr ><td class="header"><strong>Assembly</strong></td><td><%=SFN.parse(g.getAssembly())%></td></tr>
            <tr ><td class="header"><strong>Chromosome</strong></td><td><%=SFN.parse(g.getChr())%></td></tr>
            <tr ><td class="header"><strong>Chromosome Start</strong></td><td><%=SFN.parse(g.getStart())%></td></tr>
            <tr ><td class="header"><strong>Chromosome Stop</strong></td><td><%=SFN.parse(g.getStop())%></td></tr>
            <tr ><td class="header"><strong>Strand</strong></td><td><%=SFN.parse(g.getStrand())%></td></tr>
        </table>
        <hr>
        <table style="width:80%">
            <tr ><td class="header"><strong>Spacer Sequence</strong></td><td><%=SFN.parse(g.getSpacerSequence())%></td></tr>
            <tr ><td class="header"><strong>Spacer Length</strong></td><td><%=SFN.parse(g.getSpacerLength())%></td></tr>
            <tr ><td class="header"><strong>Modifications</strong></td><td><%=SFN.parse(g.getModifications())%></td></tr>
            <tr ><td class="header"><strong>Repeat Sequence</strong></td><td><%=SFN.parse(g.getRepeatSequence())%></td></tr>
            <tr ><td class="header"><strong>Anti-Repeat Sequence</strong></td><td><%=SFN.parse(g.getAntiRepeatSequence())%></td></tr>
            <tr ><td class="header"><strong>Stemloop 1 Sequence</strong></td><td><%=SFN.parse(g.getStemloop1Sequence())%></td></tr>
            <tr ><td class="header"><strong>Stemloop 2 Sequence</strong></td><td><%=SFN.parse(g.getStemloop2Sequence())%></td></tr>
            <tr ><td class="header"><strong>Stemloop 3 Sequence</strong></td><td><%=SFN.parse(g.getStemloop3Sequence())%></td></tr>
        </table>
        <hr>
        <table style="width:80%">
            <tr><td class="header"><strong>Related Editors</strong></td>
                <td>
                    <%for (Editor relatedEditor: relatedEditors) { %>
                    <a href="/toolkit/data/editors/editor?id=<%=relatedEditor.getId()%>" ><%=UI.replacePhiSymbol(relatedEditor.getSymbol())%></a><br>
                    <% } %>
                </td>
            </tr>
            <tr ><td class="header"><strong>Ivt Construct Source</strong></td><td><%=SFN.parse(g.getIvtConstructSource())%></td></tr>
            <tr ><td class="header"><strong>Vector Id</strong></td><td><%=SFN.parse(g.getVectorId())%></td></tr>
            <tr ><td class="header"><strong>Vector Name</strong></td><td><%=SFN.parse(g.getVectorName())%></td></tr>
            <tr ><td class="header"><strong>Vector Description</strong></td><td><%=SFN.parse(g.getVectorDescription())%></td></tr>
            <tr ><td class="header"><strong>Vector Type</strong></td><td><%=SFN.parse(g.getVectorType())%></td></tr>
            <tr ><td class="header"><strong>Annotated Map</strong></td><td><%=SFN.parse(g.getAnnotatedMap())%></td></tr>
            <tr ><td class="header"><strong>Specificity Ratio</strong></td><td><%=SFN.parse(g.getSpecificityRatio())%></td></tr>
        </table>
        <hr>
        <table style="width:80%">
            <tr><td class="header"><strong>Off Targets</strong></td>
                <td>
                    <%for (OffTarget offTarget: offTargets) { %>
                    <b>Detection Method:</b> <%=offTarget.getDetectionMethod()%> <b>; No of Sites Detected: </b> <%=offTarget.getNoOfSitesDetected()%><br>
                    <% } %>
                </td>
            </tr>
        </table>
    </div>
    <hr>
</div>

<br>
<jsp:include page="associatedStudies.jsp"/>
<br>
<hr>
<jsp:include page="associatedExperiments.jsp"/>