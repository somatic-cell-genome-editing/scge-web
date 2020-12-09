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
            <tr><td class="header"><strong>Model Type</strong></td><td>${model.type}</td></tr>
            <tr><td class="header"><strong>Strain</strong></td><td>${model.name}</td></tr>
            <tr><td class="header"><strong>Short Name</strong></td><td>${model.shortName}</td></tr>
            <tr><td class="header"><strong>Organism</strong></td><td>${model.organism}</td></tr>
            <tr><td class="header"><strong>GenoType</strong></td><td>${model.genotype}</td></tr>
            <tr><td class="header"><strong>Stock Number/Stable ID</strong></td><td>${model.stockNumber}</td></tr>
            <tr><td class="header"><strong>Age</strong></td><td>${model.age}</td></tr>
            <tr><td class="header"><strong>Age Range</strong></td><td>${model.ageRange}</td></tr>
            </tbody>
        </table>
    </div>
    <hr>
</div>

<jsp:include page="associatedStudies.jsp"/>
