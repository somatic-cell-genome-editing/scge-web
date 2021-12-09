<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.web.UI" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="edu.mcw.scge.datamodel.*" %>
<%@ page import="com.nimbusds.jose.shaded.json.JSONValue" %>
<%@ page import="edu.mcw.scge.datamodel.Vector" %>
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
            if(dualAxis)
                updateAxis();
            else update();
        });
    });
	function download(){
        $("#myTable").tableToCSV();
    }
</script>

<% ImageDao idao = new ImageDao(); %>


<% try {  %>

        <%@include file="recordFilters.jsp"%>

        <!--table width="600"><tr><td style="font-weight:700;"><%=ex.getName()%></td><td align="right"></td></tr></table-->
       <% //if(resultMap != null && resultMap.size()!= 0) {%>
        <div class="chart-container" id = "chartDiv">
    <canvas id="resultChart" style="position: relative; height:80vh; width:80vw;"></canvas>

        </div>
<% //}%>
<div>
<hr>

    <%
        long objectId = ex.getExperimentId();
        String redirectURL = "/data/experiments/experiment/" + ex.getExperimentId();
        String bucket="aboveExperimentTable1";
    %>
    <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
    <% bucket="aboveExperimentTable2"; %>
    <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
    <% bucket="aboveExperimentTable3"; %>
    <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
    <% bucket="aboveExperimentTable4"; %>
    <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
    <% bucket="aboveExperimentTable5"; %>
    <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>

    <table width="90%">
        <tr>
            <td><h3>Results</h3></td>
        </tr>
    </table>

    <table id="myTable" class="table tablesorter table-striped table-sm">
    <thead>
    <tr>
        <th>Condition<%=request.getAttribute("uniqueFields").toString()%></th>
        <th></th>
        <% if (tissueList.size() > 0 ) { %><th>Tissue</th><% } %>
        <% if (cellTypeList.size() > 0) { %><th>Cell Type</th><% } %>
        <% if (sexList.size() > 0) { %><th>Sex</th><% } %>
        <% if (editorList.size() > 0 ) { %><th>Editor</th><% } %>
        <% if (modelList.size() > 0 ) { %><th>Model</th><% } %>
        <% if (deliverySystemList.size() > 0 ) { %><th>Delivery System</th><% } %>
        <% if (guideList.size() > 0 ) { %><th>Target Locus</th> <% } %>
        <% if (guideList.size() > 0 ) { %><th>Guide</th> <% } %>

        <% if (vectorList.size() > 0 ) { %><th>Vector</th><% } %>
        <c:if test="${objectSizeMap['dosage']>0}">

        <td>Dosage</td>
        </c:if>
        <% if (resultTypeList.size() > 0 ) { %><th>Result Type</th><% } %>
        <% if (unitList.size() > 0 ) { %><th>Units</th><% } %>
        <th id="result">Result</th>
    </tr>
    </thead>

        <%
            int rowCount =1;
            for (Long resultId: resultDetail.keySet()) {
                List<ExperimentResultDetail> ers = resultDetail.get(resultId);
                long expRecordId = ers.get(0).getExperimentRecordId();
                ExperimentRecord exp = experimentRecordsMap.get(expRecordId);
                String experimentName=exp.getExperimentName();
                if(resultTypeList.size()>1) {
                    experimentName+=" ("+ers.get(0).getResultType()+") ";
                }

                List<Guide> guides = guideMap.get(exp.getExperimentRecordId());
                String guide = "";
                String targetLocus="";
                Set<String> targetLocusSet=new HashSet<>();
                boolean fst = true;
                for(Guide g: guides) {
                    if (!fst) { guide += ";"; targetLocus+=";"; }
                    guide += "<a href=\"/toolkit/data/guide/system?id="+g.getGuide_id()+"\">"+SFN.parse(g.getGuide())+"</a>";
                   if( g.getTargetLocus()!=null)
                    if(! targetLocusSet.contains(g.getTargetLocus())) {
                        targetLocusSet.add(g.getTargetLocus());
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

        <%
            List<Image> images = idao.getImage(exp.getExperimentRecordId(),"main1");
            if (images.size() > 0) {
        %>
                <td><a href="/toolkit/data/experiments/experiment/<%=exp.getExperimentId()%>/record/<%=exp.getExperimentRecordId()%>/"><img onmouseover="imageMouseOver(this)" onmouseout="imageMouseOut(this)" id="img<%=rowCount%>" src="<%=images.get(0).getPath()%>" height="1" width="1"></a></td>
         <% }else { %>
              <td></td>
         <%}%>

            <% if (tissueList.size() > 0 ) { %><td><%=SFN.parse(exp.getTissueTerm())%></td><% } %>
        <% if (cellTypeList.size() > 0) { %><td><%=SFN.parse(exp.getCellTypeTerm())%></td><% } %>
            <% if (sexList.size() > 0) { %><td><%=SFN.parse(exp.getSex())%></td><% } %>
        <% if (editorList.size() > 0 ) { %><td><a href="/toolkit/data/editors/editor?id=<%=exp.getEditorId()%>"><%=UI.replacePhiSymbol(exp.getEditorSymbol())%></a></td><% } %>
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
        </tr>
        <% rowCount++; %>
     <% }} %>
</table>

    <%
        bucket="belowExperimentTable1";
    %>
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


<script>
    function resizeImages() {

        //var found=true;
        var count=1;
        while(true) {
            var img = document.getElementById("img" + count);
            if (img) {
                //alert(img.clientWidth);
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

    function imageMouseOver(img) {
        img.height=img.naturalHeight;
        img.width=img.naturalWidth;
    }
    function imageMouseOut(img) {
        img.height=75;
        img.width=75;

    }


    resizeImages();
</script>


<script>
            var ctx = document.getElementById("resultChart");
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

            function getDetails(index) {
                var table = document.getElementById('myTable');
                var j = 0;
                var detail = [];
                var rowLength = table.rows.length;
                var avgIndex = table.rows.item(0).cells.length -1;
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
            function update(){
                var table = document.getElementById('myTable'); //to remove filtered rows
                var xArray=[];
                var yArray=[];
                var rowLength = table.rows.length;
                var j = 0;

                var aveIndex = table.rows.item(0).cells.length -1;
                var replicate = [];
                for (var i = 1; i < rowLength; i++){
                    if(table.rows.item(i).style.display != 'none') {

                            var cells = table.rows.item(i).cells;
                            if (cells.item(aveIndex - 1).innerText != "signal") {
                            var cellLength = cells.length;
                            var column = cells.item(0); //points to condition column
                            var avg = cells.item(aveIndex);
                            xArray[j] = column.innerText;
                            yArray[j] = avg.innerHTML;
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
                    backgroundColor: 'rgba(255, 206, 99, 0.6)',
                    borderColor:    'rgba(255, 206, 99, 0.8)',
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

                var aveIndex = table.rows.item(0).cells.length -1;
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
               // alert(elms);

/*
                var table = document.getElementById('myTable'); //to remove filtered rows
                var rowLength = table.rows.length;
                for (i = 1; i < rowLength; i++){
                    if(_this.checked)

                        table.rows.item(i).style.display = '';

                    else {
                        table.rows.item(i).style.display = 'none';
                    }
                }
  */
                //update();

              //  $('input[name='+name+']').prop('checked', _this.checked);

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
                            if (cells.item(k).innerHTML.includes( obj.id) || (cells.item(k).innerHTML.search(">" + obj.id + "<") > -1)) {
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
                if(dualAxis)
                        updateAxis();
                else update();
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
                for (var i = 0; i < tissues.length; i++) {
                    console.log(tissues[i]);
                    applyFilters(document.getElementById(tissues[i]));
                }
                for (var i = 0; i < resultTypes.length; i++) {
                    applyFilters(document.getElementById(resultTypes[i]));
                }
                for (var i = 0; i < cellTypes.length; i++) {
                    applyFilters(document.getElementById(cellTypes[i]));
                }
            }


            function updateAxis(){
                var table = document.getElementById('myTable'); //to remove filtered rows
                var labels=[];
                var editing=[];
                var delivery=[];
                var rowLength = table.rows.length;
                var j = 0;

                var aveIndex = table.rows.item(0).cells.length -1;

                for (var i = 1; i < rowLength; i++){
                    if(table.rows.item(i).style.display != 'none') {

                        var cells = table.rows.item(i).cells;
                        if (cells.item(aveIndex - 1).innerText != "signal") {
                            var cellLength = cells.length;
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
            window.onload=load();
            var quantitative = 0;
            quantitative = <%=resultMap.size()%>;
            console.log(quantitative);
            if(quantitative == 0) {
                document.getElementById("chartDiv").style.display = "none";
                document.getElementById("resultChart").style.display = "none";
            }



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
