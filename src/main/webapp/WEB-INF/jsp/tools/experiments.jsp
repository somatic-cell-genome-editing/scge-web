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
    }
</style>
<script>
    $(function() {
        $("#myTable").tablesorter({
            theme : 'blue'

        });
    });
</script>
<div >
    <%@include file="search.jsp"%>
</div>


<div>
<div style="float:left;width:20%"><p style="color:steelblue;font-weight: bold;font-size: 20px">Experiments: ${fn:length(experimentRecords)}</p></div>

<!--div style="float:right; width:8%;padding-bottom: 10px"><button class="btn btn-primary" >Compare</button></div-->
</div>
    <table id="myTable" class="table tablesorter table-striped">
    <thead>
    <tr><!--th>Select</th-->
    <th>Experiment_Id</th>
    <th>Model</th>
        <th>Target_Locus</th>
        <th>Locus site</th>
        <th>Editor</th>
        <th>Guide</th>
        <th>Dectection_Method</th>
        <th>Measuring_Method</th>
        <th>Activity</th>
        <th>Specificity</th>
    </tr>
    </thead>
<c:forEach items="${experimentRecords}" var="rec">
    <tr>
        <!--td><input class="form" type="checkbox"></td-->
        <td>${rec.experimentId}</td>
        <td>${rec.model}</td>
        <td>${rec.targetLocus}</td>
        <td>${rec.targetLocusSymbol}</td>
        <td>${rec.editorType}</td>
        <td>${rec.guide}</td>

        <td>${rec.guideDetectionMethod}</td>
        <td>CHANGE-seq</td>
        <td></td>
        <td>${rec.specificity}</td>
    </tr>
</c:forEach>
</table>
<!--div style="float:right; width:8%;padding-bottom: 10px"><button class="btn btn-primary" >Compare</button></div-->
