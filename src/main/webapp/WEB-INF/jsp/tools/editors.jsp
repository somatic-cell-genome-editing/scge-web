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
<div style="float:left;width:20%"><p style="color:steelblue;font-weight: bold;font-size: 20px">Editors: ${fn:length(editors)}</p></div>

</div>
    <table id="myTable" class="table tablesorter table-striped">
        <thead>
        <th>Symbol</th>
        <th>Type</th>
        <th>Subtype</th>
        <th>Variant</th>




        <th>Species</th>
        <th>PAM Preference</th>
        <th>Fusion</th>
        <th>Activity</th>
        <th>DSB Cleavage Type</th>
        <th>Protein Format</th>
        <th>Source</th>
        <th>Editor_Id</th>
    </tr>
    </thead>
<c:forEach items="${editors}" var="rec">
    <tr>
        <td><a href="editor?id=${rec.id}">${rec.symbol}</a></td>
        <td>${rec.type}</td>
        <td>${rec.subType}</td>
        <td>${rec.editorVariant}</td>





        <td>${rec.species}</td>
        <td>${rec.pamPreference}</td>
        <td>${rec.fusion}</td>
        <td>${rec.activity}</td>
        <td>${rec.dsbCleavageType}</td>
        <td>${rec.proteinFormat}</td>
        <td>${rec.source}</td>
        <td>${rec.id}</td>
    </tr>
</c:forEach>
</table>
