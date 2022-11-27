<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.datamodel.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="com.nimbusds.jose.shaded.json.JSONValue" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
  Created by IntelliJ IDEA.
  User: hsnalabolu
  Date: 05/21/2021
  Time: 4:37 PM
  To change this template use File | Settings | File Templates.
--%>
<script src="/toolkit/common/js/jquery.tabletoCSV.js"> </script>

<style>
    td{
        font-size: 12px;
    }
    .tablesorter.target tr td{
        border:3px solid #DA70D6;
    }
</style>


<% ImageDao idao = new ImageDao();
    List<String> options = new ArrayList<>();
    List<String> headers = new ArrayList<>();
    options.add("None");
    if (tissueList.size() > 0 ) {
        headers.add("Tissue");
        if(tissueList.size() > 1 && tissueList.size() != resultDetail.keySet().size())
            options.add("Tissue");
    }if (cellTypeList.size() > 0) {
        headers.add("Cell Type");
        if(cellTypeList.size() > 1 && cellTypeList.size() != resultDetail.keySet().size())
            options.add("Cell Type");
    }if (sexList.size() > 0) {
        headers.add("Sex");
        if(sexList.size() > 1)
            options.add("Sex");
    }if (editorList.size() > 0 ) {
        headers.add("Editor");
        if(editorList.size() > 1 && editorList.size() != resultDetail.keySet().size())
            options.add("Editor");
    }if (hrdonorList.size() > 0 ){
        headers.add("Hr Donor");
        if(hrdonorList.size() > 1 && hrdonorList.size() != resultDetail.keySet().size())
            options.add("Hr Donor");
    }if (modelList.size() > 0 ) {
        headers.add("Model");
        if(modelList.size() > 1 && modelList.size() != resultDetail.keySet().size())
            options.add("Model");
    }if (deliverySystemList.size() > 0 ) {
        headers.add("Delivery System");
        if (deliverySystemList.size() > 1 && deliverySystemList.size() != resultDetail.keySet().size())
            options.add("Delivery System");
    }if (guideList.size() > 0 ) {
        headers.add("Target Locus");
        if (guideTargetLocusList.size() > 1 && guideTargetLocusList.size() != resultDetail.keySet().size())
            options.add("Target Locus");
    }if (guideList.size() > 0 ) {
        headers.add("Guide");
        if (guideList.size() > 1 && guideList.size() != resultDetail.keySet().size())
            options.add("Guide");
    }if (vectorList.size() > 0 ) {
        headers.add("Vector");
        if (vectorList.size() > 1 && vectorList.size() != resultDetail.keySet().size())
            options.add("Vector");
    }
    if (unitList.size() > 0 ) {
        if (unitList.size() > 1 && unitList.size() != resultDetail.keySet().size())
            options.add("Units");
    }
%>

<% try {  %>

<%@include file="recordFilters.jsp"%>

<div id="graphOptions" style="padding:10px;margin-bottome:15px;display:none;"></div>

<c:if test="${fn:length(plotData['Mean'])>0}">
<div id="barChart">

    <% if( options.size() > 1 ) {%>
    <hr>
    <b style="font-size:16px;">Make a selection to highlight records on the chart: </b>
    <select name="graphFilter" id="graphFilter" onchange= "update(true)" style="padding: 5px; font-size:12px;">
    <% for(String filter: options) {%>
    <option style="padding: 5px; font-size:12px;" value=<%=filter%>><%=filter%></option>
    <%} %>
    </select>
    <% } %>
    <%for(int i=0;i<resultTypeSet.size();i++){%>
    <div class="chart-container" style="display:none;" id = "chartDiv<%=i%>">
        <canvas id="resultChart<%=i%>" style="position: relative; height:400px; width:80vw;"></canvas>
    </div>
   <%}%>

</div>

</c:if>

<div id="imageViewer" style="visibility:hidden; border: 1px double black; width:704px;position:fixed;top:15px; left:15px;z-index:1000;background-color:white;"></div>
<script> entireExperimentRecordCount=<%=experimentRecordsMap.size()%></script>
<table width="100%">
    <tr>
        <td><h3>Results</h3></td>
        <td id="downloadChartBelow" width="100" align="right" style="display:none"><input type="button" style=";border: 1px solid white; background-color:#007BFF;color:white;" value="Download Data Chart Below" onclick="downloadSelected()"/></td>
        <td id="downloadEntireExperiment" width="100"><input type="button" style="border: 1px solid white; background-color:#007BFF;color:white;" value="Download Entire Experiment" onclick="download()"/></td>
    </tr>
</table>
<%
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");
    LocalDateTime now = LocalDateTime.now();
    Experiment dExperiment = (Experiment) request.getAttribute("experiment");
    Study dStudy = (Study) request.getAttribute("study");
%>
<div id="fileCitation" style="display:none;">SCGE Toolkit downloaded on: <%=dtf.format(now)%>; Please cite the Somatic Cell Genome Editing Consortium Toolkit NIH HG010423 when using publicly accessible data in formal presentation or publication. SCGE Experment ID: <%=dExperiment.getExperimentId()%>. PI:
    <%for(Person pi:dStudy.getMultiplePis()){%>
    <%=pi.getName().replaceAll(","," ")%>
    <% }%>

</div>
<script>
     chartLabels=${experiments}
     optionsSize= <%=options.size()%>;
     dataSetsSize=${replicateResult.keySet().size()}
    replicateDataSet=${replicateResult.values()}
    meanPlotData=${plotData.get("Mean")}
     var tissues = [];
     tissues= <%= JSONValue.toJSONString(tissues) %>;
     var resultTypes = [];
     resultTypes= <%=JSONValue.toJSONString(resultTypeList)%>
     var cellTypes = [];
     cellTypes = <%= JSONValue.toJSONString(cellTypeList) %>;
     quantitativeSize= <%=resultMap.size()%>
</script>
<%@include file="experimentTable.jsp"%>


<%
    long objectId = ex.getExperimentId();
    String redirectURL = "/data/experiments/experiment/" + ex.getExperimentId();
    String bucket="belowExperimentTable1";
%>

<div id="associatedProtocols">
    <%@include file="/WEB-INF/jsp/tools/associatedProtocols.jsp"%>
</div>

<hr>

<%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
<% bucket="belowExperimentTable2"; %>
<%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
<% bucket="belowExperimentTable3"; %>
<%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
<% bucket="belowExperimentTable4"; %>
<%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
<% bucket="belowExperimentTable5"; %>
<%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>


<div id="associatedPublications">
    <%@include file="/WEB-INF/jsp/tools/publications/associatedPublications.jsp"%>
</div>
<script src="/toolkit/js/experiment.js"></script>
<script src="https://unpkg.com/feather-icons/dist/feather.min.js"></script>
<script>
    feather.replace()
</script>

<% } catch (Exception e) {
    e.printStackTrace();
}
%>
<% String modalFilePath="/toolkit/images/experimentHelpModal.png"; %>
<%@include file="modal.jsp"%>
<!--div style="float:right; width:8%;padding-bottom: 10px"><button class="btn btn-primary" >Compare</button></div-->