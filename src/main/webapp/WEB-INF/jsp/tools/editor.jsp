<%@ page import="edu.mcw.scge.datamodel.Study" %>
<%@ page import="java.util.List" %>
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


<div>
    <div>
        <table  style="width:80%">

            <tbody>
            <tr><td class="header"><strong>Editor ID</strong></td><td>${editor.id}</td></tr>
            <tr><td class="header"><strong>Symbol</strong></td><td>${editor.symbol}</td></tr>
            <tr><td class="header"><strong>Type</strong></td><td>${editor.type}</td></tr>
            <tr><td class="header"><strong>Subtype</strong></td><td>${editor.subType}</td></tr>
            <tr><td class="header"><strong>Alias</strong></td><td>${editor.alias}</td></tr>
            <tr><td class="header"><strong>Species</strong></td><td>${editor.species}</td></tr>
            <tr><td class="header"><strong>PAM Preference</strong></td><td>${editor.pamPreference}</td></tr>
            <tr><td class="header"><strong>Variant</strong></td><td>${editor.editorVariant}</td></tr>
            <tr><td class="header"><strong>Substrate Target</strong></td><td>${editor.substrateTarget}</td></tr>
            <tr><td class="header"><strong>Overhang</strong></td><td>${editor.overhang}</td></tr>
            <tr><td class="header"><strong>Fusion</strong></td><td>${editor.fusion}</td></tr>

            <tr><td class="header"><strong>Activity</strong></td><td>${editor.activity}</td></tr>
            <tr><td class="header"><strong>DSB Cleavage Type</strong></td><td>${editor.dsbCleavageType}</td></tr>
            <tr><td class="header"><strong>Protein Format</strong></td><td>${editor.proteinFormat}</td></tr>
            <tr><td class="header"><strong>Note</strong></td><td>${editor.note}</td></tr>
            <tr><td class="header"><strong>Protein Format</strong></td><td>${editor.proteinFormat}</td></tr>
            <tr><td class="header"><strong>Add Gene</strong></td><td><a href="${editor.addGeneLink}">${editor.addGeneLink}</a></td></tr>
            <tr><td class="header"><strong>Source</strong></td><td>${editor.source}</td></tr>


            </tbody>
        </table>
    </div>
    <hr>
</div>


<jsp:include page="associatedStudies.jsp"/>
