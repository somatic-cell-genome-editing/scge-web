<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 10/1/2020
  Time: 1:14 PM
  To change this template use File | Settings | File Templates.
--%>

<link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" integrity="sha384-AYmEC3Yw5cVb3ZcuHtOA93w35dYTsvhLPVnYs9eStHfGJvOvKxVfELGroGkvsg+p" crossorigin="anonymous"/>
<style>
    td{
        font-size: 12px;
    }
</style>

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
        <th>Experiment_Name</th>
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
            <td><a href="results/${rec.experimentId}">${rec.experimentId}</a></td>
            <td>${rec.experimentName}</td>
            <td>${rec.model}</td>
            <td>${rec.targetLocus}</td>
            <td>${rec.targetLocusSymbol}</td>
            <td>${rec.editorType}</td>
            <td>${rec.guide}</td>

            <td>${rec.guideDetectionMethod}</td>
            <td></td>
            <td></td>
            <td>
                <c:if test="${rec.specificity>0}">
                    ${rec.specificity}
                </c:if>
            </td>
        </tr>
    </c:forEach>
</table>
