
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

    List<Integer> barCounts=new ArrayList<>();
    for(Plot plot:plots){
      Collection<List<Double>> values=  plot.getPlotData().values();
      for(List<Double> collection:values){
          barCounts.add(collection.size());
      }
//        for(String key:plot.getPlotData().keySet()){
//            List<Double> values=plot.getPlotData().get(key);
//            if(values!=null)
//            barCounts.add(values.size());
//        }

    }
    int maxBarCount=0;
    if(barCounts.size()>0)
          maxBarCount=  Collections.max(barCounts);
    List<String> options = new ArrayList<>();
%>
<%@include file="experiment/colorByOptions.jsp"%>

<%@include file="recordFilters.jsp"%>

<!--div id="graphOptions" style="padding:10px;margin-bottome:15px;display:none;"></div-->
<%if(plots.size()>0){%>

        <div id="chart-highlighter">

        <div class="row" style="margin-bottom: 1%">
            <div id="barChart" class="col-8 form-inline ">
                <div class="form-inline">
                <b style="">Select experimental variable to highlight records on the chart:&nbsp;</b>
                </div>
                <select class="form-inline mb-2" name="graphFilter" id="graphFilter" onchange= "update(false)" style="padding: 5px; font-size:12px;">
                    <% for(String filter: options) {%>
                    <option  value=<%=filter%>><%=filter%></option>
                    <%} %>
                </select>
            </div>
            <div class="col">
                <div class="card-header form-check form-check-inline">
                    <div class="form-inline mb-2"><label class="form-check-label"> Scale</label></div>
                    <div class="form-check form-inline mb-2">
                        <input class="form-check-input" type="radio" name="y-scale-type" id="inlineRadio1"  value="linear" onchange="updateChartValues(this.value)" checked>
                        <label class="form-check-label" for="inlineRadio1">Linear</label>
                    </div>
                    <div class="form-check form-inline mb-2">
                        <input class="form-check-input" type="radio" name="y-scale-type" id="inlineRadio2" value="logarithmic" onchange="updateChartValues(this.value)">
                        <label class="form-check-label" for="inlineRadio2">Logarithmic</label>
                        <span class="d-inline-block"  id="scaleHelp" tabindex="0" data-toggle="tooltip" title="A logarithmic scale (or log scale) is a method used to display numerical data that spans a broad range of values, especially when there are significant differences between the magnitudes of the numbers involved. A logarithmic scale is nonlinear, and as such numbers with equal distance between them such as 1, 2, 3, 4, 5 are not equally spaced. Equally spaced values on a logarithmic scale have exponents that increment uniformly. Examples of equally spaced values are 10, 100, 1000, 10000, and 100000 (i.e., 10^1, 10^2, 10^3, 10^4, 10^5) and 2, 4, 8, 16, and 32 (i.e., 2^1, 2^2, 2^3, 2^4, 2^5).">&nbsp;<i class="fa fa-question-circle" aria-hidden="true"></i></span>
                    </div>
                </div>

            </div>

        </div>
        <div id="legend-wrapper">
        </div><br><small class="text-mute" style="text-decoration: underline"> Note:&nbsp;<span style="font-style: italic">Hover over the bars to view additional information</span></small>

        </div>

        <div>
            <%@include file="experiment/plot.jsp"%>
        </div>

<%}%>

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
<script src="/toolkit/js/chart/plot.js"></script>

<script>
    $(function () {
        $('[data-toggle="tooltip"]').tooltip();
    })

    <%--var tissues = [];--%>
    <%--tissues= <%= gson.toJson(tissues) %>;--%>
    <%--var resultTypes = <%=gson.toJson(resultTypeList)%>;--%>
    <%--var cellTypes = [];--%>
    <%--<%if(cellTypeList!=null){%>--%>
    <%--cellTypes = <%= gson.toJson(cellTypeList) %>;--%>
    <%--<%}%>--%>
  //  quantitativeSize= <%--=resultMap.size()--%>;


    function update(initialLoad, scaleType){
        console.log("update call ...")
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
        drawLegend(filterValues, legendValues, filter)
        <%

        int c=0;

        for(Plot plot:plots){
         boolean tickDisplay= plot.getTickLabels().size() <= 120;
         String  plotTitle= plot.getTitle(),
           yAxisLabel=plot.getYaxisLabel(),
           titleColor=plot.getTitleColor();
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

            if(newArrayData.length>0){
                if(initialLoad) {
                    myChart<%=c%> = drawResultChart(newArrayLabel, data, <%=c%>, <%=tickDisplay%>, '<%=plotTitle%>', <%=yAxisLabel%>, '<%=titleColor%>')
                }else {
                    myChart<%=c%>.data.labels=newArrayLabel;
                    myChart<%=c%>.data.datasets = data;
                    myChart<%=c%>.options.scales.x.ticks.display = newArrayLabel.length<120;
                    myChart<%=c%>.options.scales.y.type = scaleType;

                    myChart<%=c%>.update();
                }
                document.getElementById("chartDiv<%=c%>").style.display = "block";
                document.getElementById("resultChart<%=c%>").style.display = "block";
                document.getElementById("image<%=c%>").style.display = "block";
            }else{
                if(initialLoad){
                    myChart<%=c%> = drawResultChart([], [], <%=c%>, <%=tickDisplay%>, '<%=plotTitle%>', <%=yAxisLabel%>, '<%=titleColor%>')
                }
                document.getElementById("chartDiv<%=c%>").style.display="none";
                document.getElementById("resultChart<%=c%>").style.display = "none";
                document.getElementById("image<%=c%>").style.display = "none";
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


    setTimeout("load(true)",500);


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
<% String modalFilePath="/toolkit/images/experimentHelpModal.png"; %>
<%@include file="modal.jsp"%>
