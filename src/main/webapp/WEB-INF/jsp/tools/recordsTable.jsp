
<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.datamodel.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDateTime" %>
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
<%  Gson gson=new Gson();
    ImageDao idao = new ImageDao();
    List<Plot> plots= (List<Plot>) request.getAttribute("plots");
    List<Integer> barCounts=new ArrayList<>();
    for(Plot plot:plots){
        for(String key:plot.getPlotData().keySet()){
            List<Double> values=plot.getPlotData().get(key);
            if(values!=null)
            barCounts.add(values.size());
        }

    }
    int maxBarCount=0;
    if(barCounts.size()>0)
          maxBarCount=  Collections.max(barCounts);
%>

<%@include file="recordFilters.jsp"%>

<!--div id="graphOptions" style="padding:10px;margin-bottome:15px;display:none;"></div-->
<c:if test="${fn:length(plots)>0}">

        <div id="chart-highlighter">
        <%@include file="experiment/colorByOptions.jsp"%>

        <div class="row" style="margin-bottom: 1%">
            <div id="barChart" class="col form-inline ">
                <div class="form-inline mb-2">
                <b style="font-size:16px;">Select experimental variable to highlight records on the chart: </b>
                </div>
                <select class="form-inline mb-2" name="graphFilter" id="graphFilter" onchange= "update(true)" style="padding: 5px; font-size:12px;">
                    <% for(String filter: options) {%>
                    <option  value=<%=filter%>><%=filter%></option>
                    <%} %>
                </select>
            </div>
            <div class="col">
                <div class="card-header form-check form-check-inline">
                    <div class="form-inline mb-2">
                        <label class="form-check-label">Scale</label>
                    </div>
                    <div class="form-check form-inline mb-2">
                        <input class="form-check-input" type="radio" name="y-scale-type" id="inlineRadio1"  value="linear" onchange="updateChartValues(this.value)" checked>
                        <label class="form-check-label" for="inlineRadio1">Linear</label>
                    </div>
                    <div class="form-check form-inline mb-2">
                        <input class="form-check-input" type="radio" name="y-scale-type" id="inlineRadio2" value="logarithmic" onchange="updateChartValues(this.value)">
                        <label class="form-check-label" for="inlineRadio2">Logarithmic</label>
                    </div>
                </div>

            </div>

        </div>
        <div id="legend-wrapper">
        </div>
            <br><small class="text-mute" style="text-decoration: underline"> Note:&nbsp;<span style="font-style: italic">Hover over the bars to view additional information</span></small>

        </div>

        <div>
            <%@include file="experiment/plot.jsp"%>
        </div>

</c:if>

<div id="imageViewer" style="visibility:hidden; border: 1px double black; width:704px;position:fixed;top:15px; left:15px;z-index:1000;background-color:white;"></div>
<div>
<table width="100%">
    <tr>
        <td><h3>Results</h3></td>
        <td id="downloadChartBelow" width="100" align="right" style="display:none"><input type="button" style=";border: 1px solid white; background-color:#007BFF;color:white;" value="Download Data Table Below (.CSV)" onclick="downloadSelected()"/></td>
        <td id="downloadEntireExperiment" width="100"><input type="button" style="border: 1px solid white; background-color:#007BFF;color:white;" value="Download Entire Experiment (.CSV)" onclick="download()"/></td>
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


<%@include file="experiment/experimentResultsTable.jsp"%>

</div>
<script>

    var tissues = [];
    tissues= <%= gson.toJson(tissues) %>;
    var resultTypes = <%=gson.toJson(resultTypeList)%>;
    var cellTypes = [];
    <%if(cellTypeList!=null){%>
    cellTypes = <%= gson.toJson(cellTypeList) %>;
    <%}%>
  //  quantitativeSize= <%--=resultMap.size()--%>;

    $(function () {
        $("#myTable").tablesorter( {sortList: [[9, 0]]}).bind("sortEnd", function (e, t) {
            var table = e.target,
                currentSort = table.config.sortList,
                // target the first sorted column
                columnNum = currentSort[0][0],
                columnName = $(table.config.headerList[columnNum]).text();
            //  console.log(columnName +"\tINDEX:"+ columnNum);

            // if(dualAxis) {
            //     updateAxis();
            // } else {
                update(false);
            // }
        });
        if(filtersApplied() && !emptyTableRows())
            $('#downloadChartBelow').show();
        else
            $('#downloadChartBelow').hide();

    })
    function updateChartValues(value){
        update(true, value.toLowerCase())
    }
    function download(){
        $("#myTable").tableToCSV();
    }
    function downloadSelected(){
        $("#myTable").tableSelectionToCSV();
    }
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
    function getColumnIndex(table, columnName){
        var cellLength=  table.rows[1].cells.length;
        var index=0
        for(var j=0;j<cellLength;j++){
            var cellText= table.rows[1].cells[j].innerHTML;
            if(cellText.includes(columnName)){
                index=j;
            }
        }
        return index;
    }

    function update(updateColor, scaleType){
        var table = document.getElementById('myTable'); //to remove filtered rows
        var rowLength=table.rows.length;
        var sortedValues=[];
        var cellLength=  table.rows[1].cells.length;
        var recordIdIndex=0;
        var selected=0;
        var filter;
        plotRecordIds=[];
        if(typeof scaleType == 'undefined'){
           scaleType=document.querySelector('input[name="y-scale-type"]:checked').value;
        }
        if (document.getElementById("graphFilter") != null)
            filter = document.getElementById("graphFilter").value;
        //Find record id column index && selected colorBy option column index in the table
        for(var j=0;j<cellLength;j++){
            var cellText= table.rows[1].cells[j].innerHTML;
            if(cellText.includes( "Record ID")){
                recordIdIndex=j;
            }
            if(filter!='None')
                if (cellText.includes(filter)) { //check the column of selected filter
                    selected = j; // selected filter column index of colorBy
                }
        }
        // to implement color by selected, generate map<colorBy_column_value,  List<record_id>>
        var colorByRecords={}
        var filterValues=[];
        var legendValues=[];
        var legendValuesTruncated=[];

            for(var i=2;i<rowLength;i++) {
                recordId = table.rows[i].cells.item(recordIdIndex).innerHTML;
                if (table.rows.item(i).style.display != 'none') {
                    var valueObj = {};
                    valueObj.id = recordId;
                    sortedValues.push(valueObj);
                }

                if (filter!='None') {
                var cells = table.rows.item(i).cells;
                var value = cells.item(selected).innerText.trim();
                if (filterValues.length == 0 || filterValues.indexOf(value) == -1) {
                    filterValues.push(value);

                }
                if (table.rows.item(i).style.display != 'none') {
                    if(legendValues.indexOf(value)==-1)
                    legendValues.push(value)
                }
                colorByRecords[value] = colorByRecords[value] || [];
                colorByRecords[value].push(recordId);
            }
        }
    
            var legendDiv = document.getElementById("legend-wrapper")
            if(filterValues.length>0 && filter!='None') {
                filterValues.sort();
                var legendHtml = " <div class='card' style='margin-bottom: 5px'><div class='card-header'>Legend</div><div class='card-body'> <div id='legend'>"
                +   "<div class=row>";
                for (var v in legendValues) {
                    // console.log(legendValues[e] + "\t" + colorPalette[e])
                   var e= filterValues.indexOf(legendValues[v]);
                    var backgroundColor;
                    var borderColor;
                    if(e>30){
                        backgroundColor=colorPalette2[e];
                        borderColor=colorPalette2[e];
                    }else{
                        backgroundColor=colorPalette[e];
                        borderColor=colorPalette[e];
                    }
                    var displayVal;
                    if(legendValues[v].toString().length>15){
                        displayVal=legendValues[v].toString().substring(0,5)+".."+legendValues[v].toString().substring(legendValues[v].toString().length-10)
                    }else {
                        displayVal=legendValues[v];
                    }

                    legendHtml += "<div class='col-2'><div class='row'><div class='col-1' style='padding-top: 5px'><div  style='height:10px;width:20px;border:1px solid gray;background-color:" + backgroundColor + "'></div></div>&nbsp;<div class='col'><small class='text-muted text-nowrap' title='"+legendValues[v]+"'>"
                    legendHtml += displayVal
                    legendHtml += "</small></div></div></div>"
                }
                legendHtml += "</div></div> </div> </div>"
                legendDiv.innerHTML = legendHtml;
            }else{
                legendDiv.innerHTML = "";
            }

        var plotsSize=<%=plots.size()%>;
        <%

        int c=0;

        for(Plot plot:plots){
            Map<String, List<Double>> plotData=plot.getPlotData();
            List<Double> values=new ArrayList<>();
            for(Map.Entry entry:plotData.entrySet()){
                values.addAll((Collection<? extends Double>) entry.getValue());
            }
        %>
        // creating array of bars
        var  arrayLabel=<%=gson.toJson(plot.getTickLabels())%>;
        var  arrayData =<%=values%>;
        var  recordIds=<%=plot.getRecordIds()%>;
        var replicateSize=<%=plot.getReplicateResult().size()%>;
        var replicateResults=<%=gson.toJson(plot.getReplicateResult())%>;
        //   var noneColor=getRandomColor();
        var color=colorPalette[0];

        var  arrayOfObj = arrayLabel.map(function(d, i) {
            var reps=[];
            var dataArray=null;

            var filtered=true;
            for(var v in sortedValues){
                var sortedVal = sortedValues[v];
                if (sortedVal.id == recordIds[i]) {
                    filtered = false;

                }

            }
            if(filtered==false){
                dataArray=arrayData[i];
                for(var key in replicateResults){
                    if (replicateResults.hasOwnProperty(key)) {
                        var rr = replicateResults[key];
                        reps.push(rr[i])
                    }
                }
            }
            if(filter!='None'){
                for(var c in colorByRecords){
                    if(colorByRecords.hasOwnProperty(c)){
                        var colorRecIds=colorByRecords[c];
                        for(var id in colorRecIds) {
                            if (colorRecIds[id]==(recordIds[i])) {
                                var index = filterValues.indexOf(c);
                                if(index>30)
                                color=colorPalette2[index]
                                else
                                    color=colorPalette[index]

                            }
                        }

                    }
                }

            }
            return {
                label: d,
                data: dataArray ,
                recordId:recordIds[i],
                bgColor:color,
                replicates:reps
            };
        });

        var  sortedArrayOfObj=sortByValues(sortedValues, arrayOfObj);
        var  newArrayLabel = [];
        var  newArrayData = [];
        var newArrayIndividuals=[];
        var bgColorArray=[];
        var k=0;
        var data=[];

        var  plotRecordIds=[];
        // generating updated data for the plots from the sorted objects
        sortedArrayOfObj.forEach(function(d){
            newArrayLabel.push(d.label);
            newArrayData.push(d.data);
            bgColorArray.push(d.bgColor);
            plotRecordIds.push(d.recordId);
            newArrayIndividuals[k]=(d.replicates);
            k++;

        });



        data.push({
            label:"Value",
            data: newArrayData,
            recordIds:plotRecordIds,
            backgroundColor: bgColorArray,
        });

        var counter=0;
        if(newArrayIndividuals.length>0) {
            for(var p=0;p<replicateSize;p++) {
                var sortedArray = [];
                for (var q = 0; q < newArrayIndividuals.length; q++) {
                    var array = newArrayIndividuals[q];
                    if(typeof array!='undefined')
                        sortedArray.push(array[p])
                }
                data.push({
                    label: "Replicate - " + counter,
                    data: sortedArray,
                    type: "scatter",
                    backgroundColor: "red",
                    showLine: false


                });
                counter++;
            }

        }
     //   console.log("DATA:"+ JSON.stringify(data))

        if(plotsSize==1){

            if(newArrayData.length>0){
                myChart<%=c%>.data.labels=newArrayLabel;
                myChart<%=c%>.data.datasets = data;
                myChart<%=c%>.options.scales.x.ticks.display = newArrayLabel.length<120;
                myChart<%=c%>.options.scales.y.type = scaleType;

                myChart<%=c%>.update();
                document.getElementById("chartDiv<%=c%>").style.display = "block";
                document.getElementById("resultChart<%=c%>").style.display = "block";
                document.getElementById("image<%=c%>").style.display = "block";
            }else{
                document.getElementById("chartDiv<%=c%>").style.display="none";
                document.getElementById("resultChart<%=c%>").style.display = "none";
                document.getElementById("image<%=c%>").style.display = "none";
            }
        }else {
            if(newArrayData.length>0) {
                myChart<%=c%>.data.labels = newArrayLabel;
                myChart<%=c%>.data.datasets = data;
                myChart<%=c%>.options.scales.x.ticks.display = newArrayLabel.length < 120;
                myChart<%=c%>.options.scales.y.type = scaleType;

                myChart<%=c%>.update();
                document.getElementById("chartDiv<%=c%>").style.display = "block";
                document.getElementById("resultChart<%=c%>").style.display = "block";
                document.getElementById("image<%=c%>").style.display = "block";

            }else{
                document.getElementById("chartDiv<%=c%>").style.display="none";
                document.getElementById("resultChart<%=c%>").style.display = "none";
                document.getElementById("image<%=c%>").style.display = "none";
            }
        }
        <%c++;}%>

    }
    function sortByValues(sortedValues, arrayOfObj) {
        var sortedObjArray=[];
        var index=0;
        for(var i=0;i<sortedValues.length;i++){
            for(var j=0;j<arrayOfObj.length;j++){

                if(arrayOfObj[j].recordId==sortedValues[i].id) {

                    sortedObjArray[index] = arrayOfObj[j];
                    index++;
                    break;

                }
            }

        }

        return sortedObjArray;
    }



    function containsAnyLetters(str) {
        return /[a-zA-Z]/.test(str);
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
    function applyAllFilters(_this, name, columnName) {
        var elms = document.getElementsByName(name);
        if (_this.checked) {
            elms.forEach(function(ele) {
                ele.checked=true;
                applyFilters(ele, true,columnName);
            });
        }else {
            elms.forEach(function(ele) {
                ele.checked=false;
                applyFilters(ele, true,columnName);
            });
        }
        update(true)
    }
    function filtersApplied() {
        var table = document.getElementById('myTable');
        var rowLength = table.rows.length;
        for (i = 2; i < rowLength; i++) {
            if( table.rows.item(i).style.display == "none"){
                return true;
            }
        }
        return false;
    }
    function emptyTableRows() {
        var table = document.getElementById('myTable');
        var rowLength = table.rows.length;
        var hiddenRows=0;

        for (i = 2; i < rowLength; i++) {
            if (table.rows.item(i).style.display == "none") {
                hiddenRows+=1;
            }
        }
    //    console.log("TABLE ROW LENGTH:"+ rowLength +"\thidden rows:"+ hiddenRows)
        return rowLength == hiddenRows + 2;
    }
    function applyFilters(obj, initialLoad, columnName) {
        var table = document.getElementById('myTable'); //to remove filtered rows
        var columnIndex=getColumnIndex(table, columnName)
        var rowLength = table.rows.length;
        for (i = 2; i < rowLength; i++) {
            var cells = table.rows.item(i).cells;
      //      for (k = 0; k < cells.length; k++) {
                //    console.log("innser = " + cells.item(k).innerText + "!" + obj.id);
                if (cells.item(columnIndex).innerText.toLowerCase().includes(obj.id.toString().toLowerCase()) || (cells.item(columnIndex).innerHTML.toLowerCase().search(">" + obj.id.toString().toLowerCase() + "<") > -1)) {
                    //   if ((cells.item(k).innerText.trim() == obj.id) || (cells.item(k).innerHTML.search(">" + obj.id + "<") > -1)) {
                    if (obj.checked) {
                        cells.item(columnIndex).off = false;
                        var somethingOff = false;
                        for (j = 0; j < cells.length; j++) {
                            if (cells.item(j).off == true && j != columnIndex) {
                                somethingOff = true;
                                break;
                            }
                        }
                        if (somethingOff) {
                            table.rows.item(i).style.display = "none";
                        } else {
                            table.rows.item(i).style.display = "";
                        }
                    } else {
                        cells.item(columnIndex).off = true;
                        table.rows.item(i).style.display = "none";
                    }
                }
           // }

        }
        if (filtersApplied() &&  !emptyTableRows())
            $('#downloadChartBelow').show();
        else
            $('#downloadChartBelow').hide();
        if (emptyTableRows()) {
            $('#chart-highlighter').hide();
            table.style.display="none";
        }
        else
        {
        $('#chart-highlighter').show();
        table.style.display="block";
        }

        if(!initialLoad){
            update(true)
        }
    }

    var dualAxis = false;
    function load() {
     //   console.log("in load");
        var elms = document.getElementsByName("tissue");
        elms.forEach(function(ele) {
            applyFilters(ele, true, 'Tissue');
        });
        var elms = document.getElementsByName("checkcelltype");
        elms.forEach(function(ele) {
            applyFilters(ele,true, 'Cell Type');
        });
        var elms = document.getElementsByName("checkeditor");
        elms.forEach(function(ele) {
            applyFilters(ele,true, 'Editor');
        });
        var elms = document.getElementsByName("checktargetlocus");
        elms.forEach(function(ele) {
            applyFilters(ele,true, 'Target Locus');
        });
        var elms = document.getElementsByName("checkguide");
        elms.forEach(function(ele) {
            applyFilters(ele,true, 'Guide');
        });
        var elms = document.getElementsByName("checkdelivery");
        elms.forEach(function(ele) {
            applyFilters(ele,true, 'Delivery');
        });
        var elms = document.getElementsByName("checkmodel");
        elms.forEach(function(ele) {
            applyFilters(ele,true, 'Model');
        });
        var elms = document.getElementsByName("checksex");
        elms.forEach(function(ele) {
            applyFilters(ele,true, 'Sex');
        });
        // var elms = document.getElementsByName("checkresulttype");
        // elms.forEach(function(ele) {
        //     applyFilters(ele,true);
        // });
        // var elms = document.getElementsByName("checkunits");
        // elms.forEach(function(ele) {
        //     applyFilters(ele);
        // });
        var elms = document.getElementsByName("checkvector");
        elms.forEach(function(ele) {
            applyFilters(ele,true, 'Vector');
        });
        var elms = document.getElementsByName("checkhrdonor");
        elms.forEach(function(ele) {
            applyFilters(ele,true, 'HR Donor');
        });
        if(elms.length==0){
            if (document.getElementById("graphFilter") != null) {
                filter = document.getElementById("graphFilter").value;
                if (filter != 'None' || filtersApplied())
                    update(true)
            }
        }

        document.getElementById("charts").style.visibility="visible"

        document.getElementById("spinner").style.visibility = "hidden";

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
        if(document.getElementById("chartDiv")!=null){
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
                    if (cells.item(aveIndex - 1).innerText.toLowerCase() != "signal") {
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
    }

    setTimeout("load()",500);

</script>

<% String bucket="belowExperimentTable1"; %>
<div id="associatedPublications">
    <%@include file="/WEB-INF/jsp/tools/publications/associatedPublications.jsp"%>
</div>
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


<!--div id="associatedPublications"-->
    <%--@include file="/WEB-INF/jsp/tools/publications/associatedPublications.jsp"--%>
<!--/div-->
<script src="https://unpkg.com/feather-icons/dist/feather.min.js"></script>
<script>
    feather.replace()
</script>


<% String modalFilePath="/toolkit/images/experimentHelpModal.png"; %>
<%@include file="modal.jsp"%>
<!--div style="float:right; width:8%;padding-bottom: 10px"><button class="btn btn-primary" >Compare</button></div-->