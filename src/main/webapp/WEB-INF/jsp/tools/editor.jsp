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







    <table id="myTable" class="tablesorter">
        <tr>
            <td><h4>Editor_Id</h4></td>
            <td>${editor.id}</td>
        </tr>
        <tr>
            <td><h4>Symbol</h4></td>
            <td>${editor.symbol}</td>
        </tr>
        <tr>
            <td><h4>Type</h4></td>
            <td>${editor.type}</td>
        </tr>
        <tr>
            <td><h4>Subtype</h4></td>
            <td>${editor.subType}</td>
        </tr>
        <tr>
            <td><h4>Alias</h4></td>
            <td>${editor.alias}</td>
        </tr>
        <tr>
            <td><h4>Species</h4></td>
            <td>${editor.species}</td>
        </tr>
        <tr>
        <td><h4>PAM Preference</h4></td>
            <td>${editor.pamPreference}</td>
        </tr>
        <tr>
            <td><h4>Accession</h4></td>
            <td>${editor.accession}</td>
        </tr>
        <tr>
        <td><h4>Variant</h4></td>
            <td>${editor.editorVariant}</td>
        </tr>
        <tr>
            <td><h4>Substrate Target</h4></td>
            <td>${editor.substrateTarget}</td>
        </tr>
        <tr>
            <td><h4>Overhang</h4></td>
            <td>${editor.overhang}</td>
        </tr>
        <tr>
        <td><h4>Fusion</h4></td>
            <td>${editor.fusion}</td>
        </tr>
        <tr>
        <td><h4>Activity</h4></td>
            <td>${editor.activity}</td>
        </tr>
        <tr>
        <td><h4>DSB Cleavage Type</h4></td>
            <td>${editor.dsbCleavageType}</td>
        </tr>
        <tr>
        <td><h4>Protein Format</h4></td>
            <td>${editor.proteinFormat}</td>
        </tr>
        <tr>
            <td><h4>Note</h4></td>
            <td>${editor.note}</td>
        </tr>
        <tr>
            <td><h4>Protein Format</h4></td>
            <td>${editor.proteinFormat}</td>
        </tr>
        <tr>
            <td><h4>Add Gene</h4></td>
            <td><a href="${editor.addGeneLink}">${editor.addGeneLink}</a></td>
        </tr>
        <tr>
            <td><h4>Source</h4></td>
            <td>${editor.source}</td>
        </tr>
    
</table>
