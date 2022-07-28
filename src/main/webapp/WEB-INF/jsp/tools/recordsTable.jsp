<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.web.UI" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="edu.mcw.scge.datamodel.*" %>
<%@ page import="com.nimbusds.jose.shaded.json.JSONValue" %>
<%@ page import="edu.mcw.scge.datamodel.Vector" %>
<%@ page import="edu.mcw.scge.service.StringUtils" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>
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
    .desc {
        font-size:14px;
    }
</style>
<script>
    $(function() {
        $("#myTable").tablesorter({
            theme : 'blue',
            widgets: ['zebra','resizable', 'stickyHeaders'],
        });
        $("#myTable").tablesorter().bind("sortEnd", function (e, t) {
            if(dualAxis) {
                updateAxis();
            } else {
                update(false);
            }
        });
    });
	function download(){
        $("#myTable").tableToCSV();
    }
    function downloadSelected(){
        $("#myTable").tableSelectionToCSV();
    }
</script>

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

<div id="graphOptions" style="padding:10px;margin-bottome:15px;display:none;">

</div>


<div>
</div>

<div id="barChart">
<% if( unitList.size() == 1 && unitList.get(0).equalsIgnoreCase("signal") ) {

}  else { %>
<hr>
    <b style="font-size:16px;">Make a selection to highlight records on the chart: </b> <select name="graphFilter" id="graphFilter" onchange= "update(true)" style="padding: 5px; font-size:12px;">
    <% for(String filter: options) {%>
    <option style="padding: 5px; font-size:12px;" value=<%=filter%>><%=filter%></option>
    <%} %>
</select>
<% } %>


<br><br>
        <div class="chart-container" id = "chartDiv">
            <canvas id="resultChart" style="position: relative; height:400px; width:80vw;"></canvas>
        </div>
</div>
<hr>


    <div id="imageViewer" style="visibility:hidden; border: 1px double black; width:704px;position:fixed;top:15px; left:15px;z-index:1000;background-color:white;"></div>

    <table width="100%">
        <tr>
            <td><h3>Results</h3></td>
            <td width="100" align="right"><input type="button" style="border: 1px solid white; background-color:#007BFF;color:white;" value="Download Data Chart Below" onclick="downloadSelected()"/></td>
            <td width="100"><input type="button" style="border: 1px solid white; background-color:#007BFF;color:white;" value="Download Entire Experiment" onclick="download()"/></td>
        </tr>
    </table>
<%
    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss");
    LocalDateTime now = LocalDateTime.now();
    Experiment dExperiment = (Experiment) request.getAttribute("experiment");
    Study dStudy = (Study) request.getAttribute("study");
%>
    <div id="fileCitation" style="display:none;">SCGE Toolkit downloaded on: <%=dtf.format(now)%>; Please cite the Somatic Cell Genome Editing Consortium Toolkit NIH HG010423 when using publicly accessible data in formal presentation or publication. SCGE Experment ID: <%=dExperiment.getExperimentId()%>. PI: <%=dStudy.getPi().replaceAll(","," ")%></div>
    <table id="myTable" class="table tablesorter table-striped table-sm">
        <caption style="display:none;"><%=ex.getName().replaceAll(" ","_")%></caption>
        <thead>
    <tr>
        <th>Condition<%--=request.getAttribute("uniqueFields").toString()--%></th>
    <%  for(String option:headers) { %>
        <th><%=option%></th>
    <% } %>
        <c:if test="${objectSizeMap['dosage']>0}">

        <th>Dosage</th>
        </c:if>
        <% if (resultTypeList.size() > 0 ) { %><th>Result Type</th><% } %>
        <% if (unitList.size() > 0 ) {  %><th>Units</th><% } %>
        <th id="result">Result/Mean</th>
        <th>Image</th>
    </tr>
    </thead>

        <%
            int rowCount =1;
            for (Long resultId: resultDetail.keySet()) {
                List<ExperimentResultDetail> ers = resultDetail.get(resultId);
                long expRecordId = ers.get(0).getExperimentRecordId();
                ExperimentRecord exp = experimentRecordsMap.get(expRecordId);
                String experimentName=exp.getExperimentName();
                //if(resultTypeList.size()>1) {
                //    experimentName+=" ("+ers.get(0).getResultType()+") ";
               // }

                boolean hadTerm = false;
                boolean hadCell = false;
                if (!SFN.parse(exp.getTissueTerm()).equals("") ) {
                    experimentName+=" (" + exp.getTissueTerm();
                    hadTerm = true;
                }


                if (!SFN.parse(exp.getCellType()).equals("")) {
                    if (!hadTerm) {
                        experimentName+=" (";
                    }else {
                        experimentName+="/";
                    }

                    experimentName+=exp.getCellTypeTerm();
                    hadCell = true;
                }

                if (hadTerm || hadCell) {
                    experimentName+=")";
                }


                List<Guide> guides = guideMap.get(exp.getExperimentRecordId());
                String guide = "";
                String targetLocus="";
                Set<String> targetLocusSet=new HashSet<>();
                boolean fst = true;
                for(Guide g: guides) {
                    if (!fst) { guide += ";";  }
                    guide += "<a href=\"/toolkit/data/guide/system?id="+g.getGuide_id()+"\">"+SFN.parse(g.getGuide())+"</a>";
                   if( g.getTargetLocus()!=null)
                    if(! targetLocusSet.contains(g.getTargetLocus())) {
                        targetLocusSet.add(g.getTargetLocus());
                        if(!fst) {
                            targetLocus += ";";
                        }
                        targetLocus += SFN.parse(g.getTargetLocus()) + "</a>";

                    }
                    fst = false;
                }
                List<Vector> vectors = vectorMap.get(exp.getExperimentRecordId());
                String vector = "";
                fst=true;
                for(Vector v: vectors) {
                    if (!fst) { vector += ";"; }
                    vector += "<a href=\"/toolkit/data/vector/format?id="+v.getVectorId()+"\">"+SFN.parse(v.getName())+"</a>";
                    fst=false;
                }

        %>

        <% if (access.hasStudyAccess(exp.getStudyId(),p.getId())) {
        %>
        <tr>
        <td id="<%=SFN.parse(exp.getExperimentName())%>"><a href="/toolkit/data/experiments/experiment/<%=exp.getExperimentId()%>/record/<%=exp.getExperimentRecordId()%>/"><%=SFN.parse(experimentName)%></a></td>


            <% if (tissueList.size() > 0 ) { %><td><%=SFN.parse(exp.getTissueTerm())%></td><% } %>
        <% if (cellTypeList.size() > 0) { %><td><%=SFN.parse(exp.getCellTypeTerm())%></td><% } %>
            <% if (sexList.size() > 0) { %><td><%=SFN.parse(exp.getSex())%></td><% } %>
        <% if (editorList.size() > 0 ) { %><td><a href="/toolkit/data/editors/editor?id=<%=exp.getEditorId()%>"><%=UI.replacePhiSymbol(exp.getEditorSymbol())%></a></td><% } %>
            <% if (hrdonorList.size() > 0) { %><td><a href="/toolkit/data/hrdonors/hrdonor?id=<%=exp.getHrdonorId()%>"><%=SFN.parse(exp.getHrdonorName())%></a></td><% } %>
            <% if (modelList.size() > 0 ) { %><td><a href="/toolkit/data/models/model?id=<%=exp.getModelId()%>"><%=SFN.parse(exp.getModelName())%></a></td><% } %>
        <% if (deliverySystemList.size() > 0 ) { %><td><a href="/toolkit/data/delivery/system?id=<%=exp.getDeliverySystemId()%>"><%=SFN.parse(exp.getDeliverySystemName())%></a></td><% } %>
            <% if (guideList.size() > 0 ) { %><td><%=targetLocus%></td><% } %>

            <% if (guideList.size() > 0 ) { %><td><%=guide%></td><% } %>
        <% if (vectorList.size() > 0 ) { %><td><%=vector%></td><% } %>
        <c:if test="${objectSizeMap['dosage']>0 }">

        <td><%=exp.getDosage()%></td>
        </c:if>
        <% if (resultTypeList.size() > 0 ) { %><td><%=ers.get(0).getResultType()%></td><% } %>
        <% if (unitList.size() > 0 ) { %><td><%=ers.get(0).getUnits()%></td><% } %>
            <% for(ExperimentResultDetail e:ers) {
                    if(e.getReplicate() == 0) { %>
            <td><%=e.getResult()%></td>
            <% } } for(ExperimentResultDetail e:ers) {
                    if(e.getReplicate() != 0) { %>
            <td style="display: none"><%=e.getResult()%></td>
            <%}}%>
            <%
                List<Image> images = idao.getImage(exp.getExperimentRecordId(),"main1");
                if (images.size() > 0) {
            %>
            <td align="center"><a href="/toolkit/data/experiments/experiment/<%=exp.getExperimentId()%>/record/<%=exp.getExperimentRecordId()%>/"><img onmouseover="imageMouseOver(this,'<%=StringUtils.encode(images.get(0).getLegend())%>','<%=images.get(0).getTitle()%>')" onmouseout="imageMouseOut(this)" id="img<%=rowCount%>" src="<%=images.get(0).getPath()%>" height="1" width="1"></a></td>
            <% rowCount++;
                }else { %>
            <td></td>
            <%}%>

        </tr>

     <% }} %>
</table>


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
</div>

<div id="associatedPublications">
    <%@include file="/WEB-INF/jsp/tools/publications/associatedPublications.jsp"%>
</div>
<script>
    function resizeImages() {
        var count=1;
        while(true) {
            var img = document.getElementById("img" + count);
            if (img) {
                //get the height to 60
                var goal=75;
                var height = img.naturalHeight;
                var diff = height - goal;
                var percentDiff = 1 - (diff / height);
                img.height=goal;
                img.width=parseInt(img.naturalWidth * percentDiff);

            }else {
                break;
            }
            count++;
        }

    }

    function imageMouseOver(img, legend, title) {
        var sourceImage = document.createElement('img'),
            imgContainer = document.getElementById("imageViewer");
        sourceImage.src = img.src;
        //resizeThis(sourceImage);

        if (title != "") {
            imgContainer.innerHTML = "<div style='padding:8px;font-weight:700;font-size:18px;'>" + title + "</div>"
        }

        imgContainer.appendChild(sourceImage);
        //imgContainer.style.width=img.naturalWidth;

        if (legend != "") {
            imgContainer.innerHTML = imgContainer.innerHTML + "<div style='border:1px solid black;padding:8px;'>" + decodeHtml(legend) + "</div>";
        }
        imgContainer.style.visibility="visible";
    }

    function resizeThis(img) {
        if (img) {
            //get the height to 60
            var goal = 700;
            var width = img.naturalWidth;

            if (width < goal) {
                return;
            }

            var diff = width - goal;
            var percentDiff = 1 - (diff / width);
            img.width = goal;
            img.height = parseInt(img.naturalHeight * percentDiff);

        }
    }

    function imageMouseOut(img) {
        document.getElementById("imageViewer").innerHTML="";
        document.getElementById("imageViewer").style.visibility="hidden";
    }

    function decodeHtml(html) {
        var txt = document.createElement("textarea");
        txt.innerHTML = html;
        return txt.value;
    }

    setTimeout("resizeImages()",500);

</script>


<script>
            var ctx = document.getElementById("resultChart");
            var colorArray = [];
            var filterValues = [];
            var myChart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: ${experiments},
                    datasets: generateData()
                },
                options: {
                    responsive: true,
                    scaleShowValues: true,
                    scales: {
                        xAxes: [{
                            gridLines: {
                                color: "rgba(0, 0, 0, 0)"
                            },

                            scaleLabel: {
                                display: true,
                                labelString: 'Experiment Conditions',
                                fontSize: 14,
                                fontStyle: 'bold',
                                fontFamily: 'Calibri'
                            },


                            ticks:{
                                fontColor: "rgb(0,75,141)",
                                fontSize: 10,
                                autoSkip: false,
                                callback: function(t) {
                                   var maxLabelLength = 40;
                                   if (t.length > maxLabelLength) return t.substr(0, maxLabelLength-20) + '...';
                                   else return t;

                               }
                            }
                        }],
                        yAxes: [{
                            id: 'delivery',
                            type: 'linear',
                            position: 'left',
                            ticks: {
                                beginAtZero: true
                            },
                            scaleLabel: {
                                display: true,
                                labelString: getLabelString(null),
                                fontSize: 14,
                                fontStyle: 'bold',
                                fontFamily: 'Calibri'
                            }
                        }, {
                            id: 'editing',
                            display: false,
                            type: 'linear',
                            position: 'right',
                            ticks: {
                                beginAtZero: true
                            },
                            scaleLabel: {
                                display: true,
                                labelString: getLabelString(null),
                                fontSize: 14,
                                fontStyle: 'bold',
                                fontFamily: 'Calibri'
                            }
                        }]
                    },
                    tooltips: {

                        callbacks: {
                            title: function(tooltipItem) {
                                return this._data.labels[tooltipItem[0].index];
                            },
                            afterLabel: function(tooltipItem) {
                                var index = tooltipItem.index;
                                return getDetails(index);
                            }

                        }

                    },

                hover: {
                    mode: 'index',
                    intersect: false
                },
                    legend: {
                        display: true
                    }
                }
            });
            function getRandomColor() {
                var letters = 'BCDEF'.split('');
                var color = '#';
                for (var i = 0; i < 6; i++ ) {
                    color += letters[Math.floor(Math.random() * letters.length)];
                }
                return color;
            }
            function getDetails(index) {
                var table = document.getElementById('myTable');
                var j = 0;
                var detail = [];
                var rowLength = table.rows.length;
                var avgIndex = table.rows.item(0).cells.length -2;
                for (i = 1; i < rowLength; i++) {
                    if (table.rows.item(i).style.display !== 'none') {
                        if (j === index) {
                            for(k = 1;k < avgIndex-2;k++){
                                var label = table.rows.item(0).cells.item(k).innerText;
                                var value = table.rows.item(i).cells.item(k).innerText;
                                detail.push(label + ':' + value) ;
                            }
                        }
                        j++;
                    }
                }
                return detail;
            }

            function update(updateColor){
                var table = document.getElementById('myTable'); //to remove filtered rows
                var xArray=[];
                var yArray=[];
                var rowLength = table.rows.length;
                var j = 0;
                var selected = 0;
                var filter = document.getElementById("graphFilter").value;
               /* var colors = ['rgba(255, 140, 102,0.5)','rgba(140, 255, 102,0.5)','rgba(102, 217, 255,0.5)','rgba(217, 102, 255,0.5)',
                    'rgba(255, 179, 102,0.5)','rgba(102, 255, 102,0.5)','rgba(102, 179, 255,0.5)','rgba(255, 102, 255,0.5)',
                    'rgba(255, 217, 102,0.5)', 'rgba(102, 255, 140,0.5)', 'rgba(102, 140, 255,0.5)','rgba(255, 102, 217,0.5)',
                    'rgba(255, 255, 102,0.5)', 'rgba(102, 255, 179,0.5)', 'rgba(102, 102, 255,0.5)', 'rgba(255, 102, 179,0.5)',
                    'rgba(217, 255, 102,0.5)', 'rgba(102, 255, 217,0.5)', 'rgba(140, 102, 255,0.5)', 'rgba(255, 102, 140,0.5)',
                    'rgba(179, 255, 102,0.5)','rgba(102, 255, 255,0.5)','rgba(179, 102, 255,0.5)','rgba(255, 102, 102,0.5)'
                ];*/

                var colors = [
                     'rgba(230, 159, 0, 0.5)','rgba(86, 180, 233, 0.5)','rgba(0, 158, 115, 0.5)','rgba(240, 228, 66, 0.5)',
                     'rgba(0, 114, 178, 0.5)','rgba(213, 94, 0, 0.5)', 'rgba(204, 121, 167, 0.5)','rgba(0, 0, 0, 0.5)',
                     'rgba(233, 150, 122, 0.5)','rgba(139, 0, 139, 0.5)','rgba(169, 169, 169, 0.5)','rgba(220, 20, 60, 0.5)',
                     'rgba(100, 149, 237, 0.5)','rgba(127, 255, 0, 0.5)','rgba(0, 0, 128, 0.5)','rgba(255, 222, 173, 0.5)',
                     'rgba(128, 0, 0, 0.5)','rgba(224, 255, 255, 0.5)','rgba(32, 178, 170, 0.5)','rgba(160, 82, 45, 0.5)',
                     'rgba(238, 130, 238, 0.5)','rgba(154, 205, 50, 0.5)','rgba(219, 112, 147, 0.5)','rgba(199, 21, 133, 0.5)',
                     'rgba(102, 205, 170, 0.5)','rgba(240, 128, 128, 0.5)','rgba(222, 184, 135, 0.5)','rgba(95, 158, 160, 0.5)',
                     'rgba(189, 183, 107, 0.5)','rgba(0, 100, 0, 0.5)', 'rgba(0, 191, 255, 0.5)','rgba(255, 0, 255, 0.5)',
                     'rgba(218, 165, 32, 0.5)','rgba(75, 0, 130, 0.5)'
                ];

                var aveIndex = table.rows.item(0).cells.length -2;
                var cells = table.rows.item(0).cells;


                for (var i = 0; i < cells.length; i++) {
                    if(cells.item(i).innerText.includes(filter)){ //check the column of selected filter
                        selected = i;
                    }
                }
                if(updateColor == true) {
                    filterValues = [];
                    for (var i = 1; i < rowLength; i++) {
                        var cells = table.rows.item(i).cells;
                        var value = cells.item(selected).innerText;
                        if (filterValues.length == 0 || filterValues.indexOf(value) == -1) {
                            filterValues.push(value);
                        }
                    }
                }
                var replicate = [];
                for (var i = 1; i < rowLength; i++){
                    if(table.rows.item(i).style.display != 'none') {

                            var cells = table.rows.item(i).cells;
                            if (cells.item(aveIndex - 1).innerText != "signal") {
                            var cellLength = cells.length-1;
                            var column = cells.item(0); //points to condition column
                            var avg = cells.item(aveIndex);
                            xArray[j] = column.innerText;
                            yArray[j] = avg.innerHTML;

                            var index = filterValues.indexOf(cells.item(selected).innerText);
                                if(filter != 'None') {
                                    if (filterValues.length <= colors.length)
                                        colorArray[j] = colors[index];
                                    else colorArray[j] = colors[0];
                                }
                                else colorArray[j] = colors[0];


                                for (var k = aveIndex + 1; k < cellLength; k++) {
                                var arr = [];
                                if (j != 0 && replicate[k - aveIndex - 1] != null)
                                    arr = replicate[k - aveIndex - 1];
                                arr.push(cells.item(k).innerHTML);
                                replicate[k - aveIndex - 1] = arr;
                            }
                            j++;
                            }
                    }

                }

                if(xArray.length > 0) {
                var data={
                    label: "Mean",
                    data: yArray,
                    yAxisID: 'delivery',
                    backgroundColor: colorArray,
                    borderWidth: 1
                };
                myChart.data.labels = xArray;
                myChart.data.datasets[0] = data;

                for(var i = 0;i < replicate.length;i++){
                    var dataSet = {
                        data: replicate[i],
                        label: "Replicate: "+(i+1),
                        yAxisID: 'delivery',
                        backgroundColor: 'rgba(255,99,132,1)',
                        borderColor: 'rgba(255,99,132,1)',
                        type: "scatter",
                        showLine: false
                    };
                    myChart.data.datasets[i+1] = dataSet;
                }

                myChart.options.scales.yAxes[1].display = false;
                myChart.options.scales.yAxes[0].scaleLabel.labelString = getLabelString(null);
                myChart.options.legend.display = false;
                myChart.update();
                    document.getElementById("chartDiv").style.display = "block";
                    document.getElementById("resultChart").style.display = "block";
                } else {
                    document.getElementById("chartDiv").style.display = "none";
                    document.getElementById("resultChart").style.display = "none";
                }

            }
            function getLabelString(result){
                var table = document.getElementById('myTable'); //to remove filtered rows
                var labelString;

                var aveIndex = table.rows.item(0).cells.length -2;
                var rowLength = table.rows.length;
                for (var i = 1; i < rowLength; i++) {
                    if (table.rows.item(i).style.display !== "none") {
                        var cells = table.rows.item(i).cells;
                        if(result != null) {
                            if( cells.item(aveIndex - 2).innerText.includes(result)) {
                                labelString = cells.item(aveIndex - 2).innerText + ' in ' + cells.item(aveIndex - 1).innerText;
                                break;
                            }
                        } else {
                            labelString = cells.item(aveIndex - 2).innerText + ' in ' + cells.item(aveIndex - 1).innerText;
                            break;
                        }
                    }
                }
                return labelString;
            }
            function applyAllFilters(_this, name) {
                var elms = document.getElementsByName(name);
                if (_this.checked) {
                    elms.forEach(function(ele) {
                        ele.checked=true;
                        applyFilters(ele);
                    });

                }else {
                    elms.forEach(function(ele) {
                        ele.checked=false;
                        applyFilters(ele);
                    });

                }
            }
            function applyFilters(obj)  {

                var table = document.getElementById('myTable'); //to remove filtered rows
                var rowLength = table.rows.length;
                for (i = 1; i < rowLength; i++){
                        var cells = table.rows.item(i).cells;
                        for (k=0; k<cells.length;k++ ) {
                            //console.log("innser = " + cells.item(k).innerText + "!");
                            //if (cells.item(k).innerText.includes( obj.id) || (cells.item(k).innerHTML.search(">" + obj.id + "<") > -1)) {
                            if ((cells.item(k).innerText == obj.id) || (cells.item(k).innerHTML.search(">" + obj.id + "<") > -1)) {
                               if (obj.checked) {
                                   cells.item(k).off=false;
                                   var somethingOff = false;
                                   for (j=0; j<cells.length;j++ ) {
                                        if (cells.item(j).off==true && j !=k) {
                                            somethingOff = true;
                                            break;
                                        }
                                   }

                                   if (somethingOff) {
                                       table.rows.item(i).style.display = "none";
                                   }else {
                                       table.rows.item(i).style.display = "";
                                   }


                               }else {
                                   cells.item(k).off = true;
                                   table.rows.item(i).style.display = "none";

                               }
                            }
                        }
                }
                if(resultTypes.length > 1){
                    dualAxis = true;
                    for (var i = 0; i < resultTypes.length; i++) {
                        if(document.getElementById((resultTypes[i])).checked == false){
                            dualAxis = false;
                        }
                    }
                }
                if(dualAxis) {
                    updateAxis();
                }else {
                    update(true);
                }
            }



            function generateData() {
                var noOfDatasets=${replicateResult.keySet().size()}
                var dataSet = ${replicateResult.values()};
                var data=[];
                data.push({
                    label: "Mean",
                    data: ${plotData.get("Mean")},
                    yAxisID: 'delivery',
                    backgroundColor: 'rgba(255, 206, 99, 0.6)',
                    borderColor:    'rgba(255, 206, 99, 0.8)',
                    borderWidth: 1
                });


                for(var i=0;i< noOfDatasets;i++){
                    data.push({
                        data: dataSet[i],
                        label: "Replicate: "+(i+1),
                        yAxisID: 'delivery',
                        backgroundColor: 'rgba(220,220,220,0.5)',
                        borderColor: 'rgba(255,99,132,1)',
                        type: "scatter",
                        showLine: false
                    });
                }
                return data;
            }
            var tissues = [];
            tissues= <%= JSONValue.toJSONString(tissues) %>;
            var resultTypes = [];
            resultTypes= <%=JSONValue.toJSONString(resultTypeList)%>
            var cellTypes = [];
            cellTypes = <%= JSONValue.toJSONString(cellTypeList) %>;
            var dualAxis = false;
            function load() {
                console.log("in load");
                var elms = document.getElementsByName("tissue");
                    elms.forEach(function(ele) {
                        applyFilters(ele);
                    });

                var elms = document.getElementsByName("checkcelltype");
                elms.forEach(function(ele) {
                    applyFilters(ele);
                });
                var elms = document.getElementsByName("checkeditor");
                elms.forEach(function(ele) {
                    applyFilters(ele);
                });
                var elms = document.getElementsByName("checktargetlocus");
                elms.forEach(function(ele) {
                    applyFilters(ele);
                });
                var elms = document.getElementsByName("checkguide");
                elms.forEach(function(ele) {
                    applyFilters(ele);
                });
                var elms = document.getElementsByName("checkdelivery");
                elms.forEach(function(ele) {
                    applyFilters(ele);
                });
                var elms = document.getElementsByName("checkmodel");
                elms.forEach(function(ele) {
                    applyFilters(ele);
                });
                var elms = document.getElementsByName("checksex");
                elms.forEach(function(ele) {
                    applyFilters(ele);
                });
                var elms = document.getElementsByName("checkresulttype");
                elms.forEach(function(ele) {
                    applyFilters(ele);
                });
                var elms = document.getElementsByName("checkunits");
                elms.forEach(function(ele) {
                    applyFilters(ele);
                });
                var elms = document.getElementsByName("checkvector");
                elms.forEach(function(ele) {
                    applyFilters(ele);
                });
                var elms = document.getElementsByName("checkhrdonor");
                elms.forEach(function(ele) {
                    applyFilters(ele);
                });

/*
            <div id="graphOptions">
                    3 different Units displayed in table<br>
                <li><a href='javascript:void(0)'>Graph Unit 1</a></li>
                <li>Graph Unit 2</li>
                <li>Graph Unit 2</li>
                <li>Display All Records (Mix Units)</li>
                </div>
*/

                var elms = document.getElementsByName("checkunits");
                var count=0;
                var graphOps = "";
                elms.forEach(function(ele) {
                    count++
                    graphOps+="<li><a href='javascript:graphUnit(\"" + ele.id + "\")'>Graph " + ele.id + "</a></li>";
                });

                graphOps+="<li><a href='javascript:graphUnit(\"all\")'>Graph All Records (Mixed Units)</a></li>";



                if(count > 1) {
                    document.getElementById("graphOptions").innerHTML=count + " Different Units Exist in Dataset<br>" + graphOps;
                    document.getElementById("barChart").style.display="none";
                    document.getElementById("graphOptions").style.display="block";
                }

            }

            function graphUnit(unit) {
                var elms = document.getElementsByName("checkunits");
                elms.forEach(function(ele) {
                    if (ele.id === unit || unit==="all") {
                        ele.checked=true;
                    }else {
                        ele.checked=false;
                    }
                    applyFilters(ele)
                    document.getElementById("barChart").style.display="block";
                });



            }


            function updateAxis(){
                var table = document.getElementById('myTable'); //to remove filtered rows
                var labels=[];
                var editing=[];
                var delivery=[];
                var rowLength = table.rows.length;
                var j = 0;

                var aveIndex = table.rows.item(0).cells.length -2;

                for (var i = 1; i < rowLength; i++){
                    if(table.rows.item(i).style.display != 'none') {

                        var cells = table.rows.item(i).cells;
                        if (cells.item(aveIndex - 1).innerText != "signal") {
                           // var cellLength = cells.length-1;
                            var column = cells.item(0); //points to condition column
                            var avg = cells.item(aveIndex);
                            labels[j] = column.innerText;
                            if (cells.item(aveIndex - 2).innerText == "Delivery Efficiency") {
                                delivery[j] = avg.innerHTML;
                                editing[j] = null;
                                j++;
                            } else {
                                editing[j] = avg.innerHTML;
                                delivery[j] = null;
                                j++;
                            }
                        }
                    }
                }

                if(labels.length > 0) {
                    var data = [];
                    data.push({
                        label: "delivery",
                        data: delivery,
                        yAxisID: 'delivery',
                        backgroundColor: 'rgba(255,99,132,1)',
                        borderColor: 'rgba(255,99,132,1)',
                        borderWidth: 1
                    });
                    data.push({
                        label: "editing",
                        data: editing,
                        yAxisID: 'editing',
                        backgroundColor: 'rgba(54, 162, 235, 1)',
                        borderColor: 'rgba(54, 162, 235, 1)',
                        borderWidth: 1
                    });

                    myChart.data.labels = labels;
                    myChart.data.datasets = data;
                    myChart.options.scales.yAxes[1].display = true;
                    myChart.options.scales.yAxes[0].scaleLabel.labelString = getLabelString('Delivery');
                    myChart.options.scales.yAxes[1].scaleLabel.labelString = getLabelString('Editing');
                    myChart.options.legend.display = true;
                    myChart.update();
                    document.getElementById("chartDiv").style.display = "block";
                    document.getElementById("resultChart").style.display = "block";
                } else {
                    document.getElementById("chartDiv").style.display = "none";
                    document.getElementById("resultChart").style.display = "none";
                }
            }
            var quantitative = 0;
            quantitative = <%=resultMap.size()%>;
            console.log(quantitative);
            if(quantitative == 0) {
                document.getElementById("chartDiv").style.display = "none";
                document.getElementById("resultChart").style.display = "none";
            }

            setTimeout("load()",500);


</script>
        <script src="https://unpkg.com/feather-icons/dist/feather.min.js"></script>
        <script>
            feather.replace()
        </script>

<% } catch (Exception e) {
        e.printStackTrace();
 }
%>

<!--div style="float:right; width:8%;padding-bottom: 10px"><button class="btn btn-primary" >Compare</button></div-->
