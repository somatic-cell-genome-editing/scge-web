<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/18/2019
  Time: 11:21 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div class="panel panel-default" >
    <div class="panel-heading" style="background-color:#4c91cd;color:white;font-weight: bold">Cell Line Form</div>
    <div class="panel panel-body">
        <div class="form-group form-inline">
            <label for="cl-id">Cell Line ID</label>
            <input type="text" name="clId" id="cl-id" value="${fn:escapeXml(cellLineId)}" class="form-control" />
            <label for="cl-name">Cell Line Name</label>
            <input type="text" name="clName" id="cl-name" value="${fn:escapeXml(cellLineName)}" class="form-control" />
            <label for="cl-type">Cell Line Type</label>
            <input type="text" name="clType" id="cl-type" value="${fn:escapeXml(cellLineType)}" class="form-control" />
        </div>
        <div class="form-group form-inline">
            <label for="cl-strain">Cell Line Strain</label>
            <input type="text" name="clStrain" id="cl-strain" value="${fn:escapeXml(cellLineStrain)}" class="form-control" />
        </div>
        <div class="form-group form-inline">
            <label for="cl-organism">Organism</label>
            <input type="text" name="clOrganism" id="cl-organism" value="${fn:escapeXml(cellLineOrganism)}" class="form-control" />
            <label for="cl-sex">Sex</label>
            <input type="text" name="clSex" id="cl-sex" value="${fn:escapeXml(cellLineSex)}" class="form-control" />
            <label for="cl-age">Age</label>
            <input type="text" name="clAge" id="cl-age" value="${fn:escapeXml(cellLineAge)}" class="form-control" />
        </div>
        <div class="form-group form-inline">
            <label for="cl-cellType">Cell Type</label>
            <input type="text" name="clCellType" id="cl-cellType" value="${fn:escapeXml(cellLineCellType)}" class="form-control" />
            <label for="cl-disease">Disease</label>
            <input type="text" name="clDisease" id="cl-disease" value="${fn:escapeXml(cellLineDisease)}" class="form-control" />
        </div>

        <div class="form-group form-inline">
            <label for="cl-passageNumber">Passage Number</label>
            <input type="text" name="clPassageNumber" id="cl-passageNumber" value="${fn:escapeXml(cellLinePassageNumber)}" class="form-control" />
            <label for="cl-source">Source</label>
            <input type="text" name="clSource" id="cl-source" value="${fn:escapeXml(cellLineSource)}" class="form-control" />
            <label for="cl-availability">Availability</label>
            <input type="text" name="clAvailability" id="cl-availability" value="${fn:escapeXml(cellLineAvailability)}" class="form-control" />
        </div>
        <button type="submit" class="btn btn-success">Save</button>

    </div>
</div>