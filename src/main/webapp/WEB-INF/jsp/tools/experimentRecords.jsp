<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.web.UI" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="edu.mcw.scge.datamodel.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="edu.mcw.scge.dao.implementation.ExperimentRecordDao" %>
<%@ page import="edu.mcw.scge.dao.implementation.ExperimentDao" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="edu.mcw.scge.dao.implementation.OntologyXDAO" %>
<%@ page import="edu.mcw.scge.dao.implementation.ExperimentResultDao" %>

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
    .desc {
        font-size:14px;
    }
</style>
<script>
    $(function() {
        $("#myTable").tablesorter({
            theme : 'blue',
            widgets: ['zebra',"filter",'resizable', 'stickyHeaders'],
        });
        $("#myTable").tablesorter().bind("sortEnd", function (e, t) {
            update();
        });
        $("#myTable").tablesorter().bind("filterEnd", function (e, t) {
            update();
        });
    });
</script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.1/Chart.min.js"></script>


<div>
    <%
        ExperimentDao edao = new ExperimentDao();
        List<ExperimentRecord> experimentRecords = (List<ExperimentRecord>) request.getAttribute("experimentRecords");
        Study study = (Study) request.getAttribute("study");
        Access access = new Access();
        Person p = access.getUser(request.getSession());
        Experiment ex = (Experiment) request.getAttribute("experiment");
        //out.println(experiments.size());
        HashMap<Integer,List<ExperimentResultDetail>> resultDetail= (HashMap<Integer, List<ExperimentResultDetail>>) request.getAttribute("resultDetail");
            HashMap<Integer,List<Guide>> guideMap = (HashMap<Integer,List<Guide>>)request.getAttribute("guideMap");
            HashMap<Integer,List<Vector>> vectorMap = (HashMap<Integer,List<Vector>>)request.getAttribute("vectorMap");

    %>

    <table>
        <tr>
            <td class="desc" style="font-weight:700;"><%=study.getStudy()%>:</td>
            <td>&nbsp;&nbsp;&nbsp;</td>
            <td class="desc"   style="font-weight:700;">PI:</td>
            <td class="desc" ><%=study.getPi()%></td>
            <td>&nbsp;&nbsp;&nbsp;</td>
            <td class="desc"  style="font-weight:700;">Submission Date:</td>
            <td class="desc" ><%=study.getSubmissionDate()%></td>
        </tr>
    </table>

<hr>
<!--Brain  UBERON:0000955-->

        <style>
            .tissue-control {
                position: relative;
            }
            .tissue-control-header-first {
                transform: rotate(-45deg);
                float: left;
                width:200px;
                margin-left:0px;
                margin-bottom:15px;
                order:1px solid black;
                text-align: left;
                font-size:18px;
            }
            .tissue-control-header {
                transform: rotate(-45deg);
                float: left;
                width:200px;
                margin-left:-155px;
                margin-bottom:15px;
                order:1px solid black;
                text-align: left;
                font-size:18px;
            }
            .tissue-control-cell {
                border: 1px solid black;
                loat:left;
                background-color:#F7F7F7;
                width:40px;
                height:40px;
                position:relative;
            }
            .triangle-topleft {
                position:absolute;
                top:0px;
                left:0px;
                width: 0;
                height: 0;
                border-top: 40px solid blue;
                border-right: 40px solid transparent;
                cursor:pointer;
            }
            .triangle-bottomright {
                position:absolute;
                top:0px;
                left:0px;
                width: 0;
                height: 0;
                border-bottom: 40px solid orange;
                border-left: 40px solid transparent;
            }
        </style>

            <%
            List<String> tissues = (List<String>)request.getAttribute("tissues");
            List<String> conditions = (List<String>) request.getAttribute("conditions");

           LinkedHashMap<String,String> rootTissues = new LinkedHashMap<String,String>();
           rootTissues.put("Reproductive System", "UBERON:0000990");
           rootTissues.put("Renal/Urinary System", "UBERON:0001008");
           rootTissues.put("Endocrine System","UBERON:0000949");
           rootTissues.put("Haemolymphoid System","UBERON:0002193");
           rootTissues.put("Gastrointestinal System","UBERON:0005409");
           rootTissues.put("Liver and biliary system","UBERON:0002423");
           rootTissues.put("Respiratory System","UBERON:0001004");
           rootTissues.put("Cardiovascular System","UBERON:0004535");
           rootTissues.put("Musculoskeletal System","UBERON:0002204");
           rootTissues.put("Integumentary System","UBERON:0002416");
           rootTissues.put("Nervous System","UBERON:0001016");
           rootTissues.put("Sensory System","UBERON:0001032");

        %>
        <div>Organ System Overview</div>
        <br><br>
        <div style="position:relative;margin-left:100px;">
            <table width="5000">
                <tr>
                    <td width="40">&nbsp;</td>
                    <td>

                        <%
                            boolean first = true;
                            //for (String tissue: tissues) {
                              for (String tissue: rootTissues.keySet()) {
                        %>
                                <% if (first) { %>
                                    <div class="tissue-control-header-first"><a href=""><%=tissue%></a></div>
                                    <% first = false; %>
                                <% } else { %>
                                    <div class="tissue-control-header"><a href=""><%=tissue%></a></div>
                                <% } %>
                        <%  } %>
                    </td>
                </tr>
            </table>


            <%
               try {

                   HashMap<String, Boolean> tissueEditingMap = new HashMap<String, Boolean>();
                   HashMap<String, Boolean> tissueDeliveryMap = new HashMap<String, Boolean>();
                   OntologyXDAO oxdao = new OntologyXDAO();


                   for (ExperimentRecord er : experimentRecords) {
                       String tissue = "unknown";
                       String organSystem = er.getOrganSystemID();

                       for (String rootTissue : rootTissues.keySet()) {
                           System.out.println("organ system = " + organSystem + " organ system - " + rootTissues.get(rootTissue) );

                           if (organSystem.equals(rootTissues.get(rootTissue))) {
                               tissue = rootTissues.get(rootTissue);
                               break;
                           }
                       }

                       List<ExperimentResultDetail> erdList = resultDetail.get(er.getExperimentRecordId());

                       for (ExperimentResultDetail erd : erdList) {
                           if (erd.getResultType().equals("Delivery Efficiency")) {
                               tissueDeliveryMap.put(tissue, true);
                           }
                           if (erd.getResultType().equals("Editing Efficiency")) {
                               tissueEditingMap.put(tissue, true);
                           }
                       }

                   }
            %>


            <table style="margin-top:50px;">

                <% for (String condition: conditions) { %>
                    <tr>
                        <td><%=condition%></td>

                    <% for (String tissue: rootTissues.keySet()) { %>

                        <td width="40">
                            <div class="tissue-control-cell">
                                <% if (tissueDeliveryMap.containsKey(tissue)) { %>
                                    <div class="triangle-topleft"></div>
                                <% } %>
                                <% if (tissueEditingMap.containsKey(tissue)) { %>
                                    <div class="triangle-bottomright"></div>
                                <% } %>
                             </div>
                        </td>
                     <% } %>
                </tr>
                <% } // end conditions %>
            </table>


        </div>
<%
        }catch (Exception e) {
        e.printStackTrace();
        }
%>

<hr>
        <%
        ExperimentResultDao erdao = new ExperimentResultDao();
        List<String> conditionList = edao.getExperimentRecordConditionList(ex.getExperimentId());
        List<String> tissueList = edao.getExperimentRecordTissueList(ex.getExperimentId());
        /*
        List<String> cellTypeList = edao.getExperimentRecordCellTypeList(ex.getExperimentId());
        */
        List<String> editorList = edao.getExperimentRecordEditorList(ex.getExperimentId());
        List<String> modelList = edao.getExperimentRecordModelList(ex.getExperimentId());
        List<String> deliverySystemList = edao.getExperimentRecordDeliverySystemList(ex.getExperimentId());
        List<String> resultTypeList = erdao.getResTypeByExpId(ex.getExperimentId());
        List<String> unitList = erdao.getUnitsByExpId(ex.getExperimentId());


        List<String> guideList = edao.getExperimentRecordGuideList(ex.getExperimentId());
        List<String> vectorList = edao.getExperimentRecordVectorList(ex.getExperimentId());

        %>



<div>Filter Options</div>
     <table style="margin-left:150px;">
         <tr>
             <td valign="top">
                 <table>

                         <tr>
                             <td style="font-size:18px; background-color:#F7F7F7;">Conditions</td>
                         </tr>
                     <% for (String condition: conditionList) { %>
                         <tr>
                             <td><input onclick="applyFilters(this)" id="<%=condition%>" type="checkbox" checked>&nbsp;<%=condition%></td>
                         </tr>
                     <% } %>

                 </table>

             </td>
             <td>
                 &nbsp;
             </td>
             <% if (tissueList.size() > 0 ) { %>
             <td valign="top">
                 <table>
                     <tr>
                         <td style="font-size:18px; background-color:#F7F7F7;">Tissues</td>
                     </tr>
                     <% for (String tissue: tissues) { %>
                     <tr>
                         <td><input onclick="applyFilters(this)"  id="<%=tissue%>" type="checkbox" checked>&nbsp;<%=tissue%></td>
                     </tr>
                     <% } %>

                 </table>

             </td>
             <td>
                 &nbsp;
             </td>
             <% } %>
             <% if (editorList.size() > 0) { %>
             <td valign="top">
                 <table>
                     <tr>
                         <td style="font-size:18px; background-color:#F7F7F7;">Editors</td>
                     </tr>
                     <% for (String editor: editorList) { %>
                     <tr>
                         <td><input onclick="applyFilters(this)"  id="<%=editor%>" type="checkbox" checked>&nbsp;<%=editor%></td>
                     </tr>
                     <% } %>

                 </table>

             </td>
             <td>
                 &nbsp;
             </td>
             <% } %>
             <% if (deliverySystemList.size() > 0 ) { %>
             <td valign="top">
                 <table>
                     <tr>
                         <td style="font-size:18px; background-color:#F7F7F7;">Delivery Systems</td>
                     </tr>
                     <% for (String system: deliverySystemList) { %>
                     <tr>
                         <td><input onclick="applyFilters(this)"  id="<%=system%>" type="checkbox" checked>&nbsp;<%=system%></td>
                     </tr>
                     <% } %>

                 </table>

             </td>
             <td>
                 &nbsp;
             </td>
             <% } %>
             <% if (modelList.size() > 0 ) { %>
             <td valign="top">
                 <table>
                     <tr>
                         <td style="font-size:18px; background-color:#F7F7F7;">Models</td>
                     </tr>
                     <% for (String model: modelList) { %>
                     <tr>
                         <td><input onclick="applyFilters(this)"  id="<%=model%>" type="checkbox" checked>&nbsp;<%=model%></td>
                     </tr>
                     <% } %>

                 </table>

             </td>
             <td>
                 &nbsp;
             </td>
             <% } %>
             <% if (guideList.size() > 0 ) { %>
             <td valign="top">
                 <table>
                     <tr>
                         <td style="font-size:18px; background-color:#F7F7F7;">Models</td>
                     </tr>
                     <% for (String guide: guideList) { %>
                     <tr>
                         <td><input onclick="applyFilters(this)"  id="<%=guide%>" type="checkbox" checked>&nbsp;<%=guide%></td>
                     </tr>
                     <% } %>

                 </table>

             </td>
             <td>
                 &nbsp;
             </td>
             <% } %>
             <% if (vectorList.size() > 0 ) { %>
             <td valign="top">
                 <table>
                     <tr>
                         <td style="font-size:18px; background-color:#F7F7F7;">Models</td>
                     </tr>
                     <% for (String vector: vectorList) { %>
                     <tr>
                         <td><input onclick="applyFilters(this)"  id="<%=vector%>" type="checkbox" checked>&nbsp;<%=vector%></td>
                     </tr>
                     <% } %>

                 </table>

             </td>
             <td>
                 &nbsp;
             </td>
             <% } %>
             <% if (resultTypeList.size() > 0 ) { %>
             <td valign="top">
                 <table>
                     <tr>
                         <td style="font-size:18px; background-color:#F7F7F7;">Result Types</td>
                     </tr>
                     <% for (String resultType: resultTypeList) { %>
                     <tr>
                         <td><input onclick="applyFilters(this)"  id="<%=resultType%>" type="checkbox" checked>&nbsp;<%=resultType%></td>
                     </tr>
                     <% } %>

                 </table>

             </td>
             <td>
                 &nbsp;
             </td>
             <% } %>
             <% if (unitList.size() > 0 ) { %>
             <td valign="top">
                 <table>
                     <tr>
                         <td style="font-size:18px; background-color:#F7F7F7;">Units</td>
                     </tr>
                     <% for (String unit: unitList) { %>
                     <tr>
                         <td><input onclick="applyFilters(this)"  id="<%=unit%>" type="checkbox" checked>&nbsp;<%=unit%></td>
                     </tr>
                     <% } %>

                 </table>

             </td>
             <% } %>
         </tr>
     </table>


  <hr>

        <table width="600"><tr><td style="font-weight:700;"><%=ex.getName()%></td><td align="right"></td></tr></table>
        <div class="chart-container" style="position: relative; height:80vh; width:80vw">
    <canvas id="resultChart"></canvas>

        </div>
<div>
<hr>
    <h3>Results</h3>
    <table id="myTable" class="table tablesorter table-striped">
    <thead>
    <tr>
        <th>Name</th>
        <% if (tissueList.size() > 0 ) { %><th>Tissue</th><% } %>
        <th>Cell Type</th>
        <% if (editorList.size() > 0 ) { %><th class="tablesorter-header" data-placeholder="Search for editor...">Editor</th><% } %>
        <% if (modelList.size() > 0 ) { %><th>Model</th><% } %>
        <% if (deliverySystemList.size() > 0 ) { %><th>Delivery System</th><% } %>
        <% if (guideList.size() > 0 ) { %><th>Guide</th> <% } %>
        <% if (vectorList.size() > 0 ) { %><th>Vector</th><% } %>
        <% if (resultTypeList.size() > 0 ) { %><th>Result Type</th><% } %>
        <% if (unitList.size() > 0 ) { %><th>Units</th><% } %>
        <th>Result</th>
    </tr>
    </thead>

        <% HashMap<Integer,Double> resultMap = (HashMap<Integer, Double>) request.getAttribute("resultMap");
            //HashMap<Integer,List<ExperimentResultDetail>> resultDetail= (HashMap<Integer, List<ExperimentResultDetail>>) request.getAttribute("resultDetail");
            for (ExperimentRecord exp: experimentRecords) {
                List<Guide> guides = guideMap.get(exp.getExperimentRecordId());
                String guide = "";
                boolean fst = true;
                for(Guide g: guides) {
                    if (!fst) { guide += ";"; }
                    guide += "<a href=\"/toolkit/data/guide/system?id="+g.getGuide_id()+"\">"+SFN.parse(g.getGuide())+"</a>";
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

        <% if (access.hasStudyAccess(exp.getStudyId(),p.getId())) { %>
    <tr>
        <!--td><input class="form" type="checkbox"></td-->

        <td id="<%=SFN.parse(exp.getExperimentName())%>"><a href="/toolkit/data/experiments/experiment/<%=exp.getExperimentId()%>/record/<%=exp.getExperimentRecordId()%>/"><%=SFN.parse(exp.getExperimentName())%></a></td>
        <% if (tissueList.size() > 0 ) { %><td><%=SFN.parse(exp.getTissueTerm())%></td><% } %>
        <td><%=SFN.parse(exp.getCellTypeTerm())%></td>
        <% if (editorList.size() > 0 ) { %><td><a href="/toolkit/data/editors/editor?id=<%=exp.getEditorId()%>"><%=UI.replacePhiSymbol(exp.getEditorSymbol())%></a></td><% } %>
        <% if (modelList.size() > 0 ) { %><td><a href="/toolkit/data/models/model?id=<%=exp.getModelId()%>"><%=SFN.parse(exp.getModelName())%></a></td><% } %>
        <% if (deliverySystemList.size() > 0 ) { %><td><a href="/toolkit/data/delivery/system?id=<%=exp.getDeliverySystemId()%>"><%=SFN.parse(exp.getDeliverySystemType())%></a></td><% } %>
        <% if (guideList.size() > 0 ) { %><td><%=guide%></td><% } %>
        <% if (vectorList.size() > 0 ) { %><td><%=vector%></td><% } %>
        <% if (resultTypeList.size() > 0 ) { %><td><%=resultDetail.get(exp.getExperimentRecordId()).get(0).getResultType()%></td><% } %>
        <% if (unitList.size() > 0 ) { %><td><%=resultDetail.get(exp.getExperimentRecordId()).get(0).getUnits()%></td><% } %>
        <td><%=resultMap.get(exp.getExperimentRecordId())%></td>
        <%for(ExperimentResultDetail e:resultDetail.get(exp.getExperimentRecordId())) {%>
        <td style="display: none"><%=e.getResult()%></td>
        <%}%>
    </tr>
        <% } %>
     <% } %>
</table>
</div>
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
                    scales: {
                        xAxes: [{
                            gridLines: {
                                offsetGridLines: true // à rajouter
                            },
                            scaleLabel: {
                                display: true,
                                labelString: 'Experiment Conditions',
                                fontSize: 14,
                                fontStyle: 'bold',
                                fontFamily: 'Calibri'
                            }
                        },
                        ],
                        yAxes: [{
                            ticks: {
                                beginAtZero: true
                            },
                            scaleLabel: {
                                display: true,
                                labelString: ${efficiency},
                                fontSize: 14,
                                fontStyle: 'bold',
                                fontFamily: 'Calibri'
                            }
                        }]
                    }
                }
            });

            function update(){
                var table = document.getElementById('myTable'); //to remove filtered rows
                var xArray=[];
                var yArray=[];
                var rowLength = table.rows.length;
                var j = 0;
                for (i = 2; i < rowLength; i++){
                    if(table.rows.item(i).style.display != 'none') {
                        var cells = table.rows.item(i).cells;
                        var cellLength = cells.length;
                        var column = cells.item(0); //points to condition column
                        var avg = cells.item(10);
                        xArray[j] = column.innerText;
                        yArray[j] = avg.innerHTML;
                        for(k = 11;k<cellLength;k++){
                            var arr = [];
                            if(j != 0)
                                arr = myChart.data.datasets[k-10].data;

                            arr.push(cells.item(k).innerHTML);
                            myChart.data.datasets[k-10].data = arr;
                        }
                        j++;
                    }

                }

                myChart.data.labels = xArray;
                myChart.data.datasets[0].data = yArray;
                myChart.update();

            }

            function applyFilters(obj)  {
                var table = document.getElementById('myTable'); //to remove filtered rows
                var rowLength = table.rows.length;
                for (i = 1; i < rowLength; i++){
                        var cells = table.rows.item(i).cells;
                        var cellLength = cells.length;
                        var column = cells.item(0); //points to condition column
                        var avg = cells.item(10);
                        for (k=0; k<cells.length;k++ ) {

                            if (cells.item(k).innerHTML == obj.id || (cells.item(k).innerHTML.search(">" + obj.id + "<") > -1)) {
                                //alert(table.rows.item(i).style.display);
                               if (obj.checked) {
                                   cells.item(k).off=false;
                                  // console.log(JSON.stringify(cells.item(k)));
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


                               // alert("found it");
                            }
                            //if(table.rows.item(i).style.display != 'none') {
                            //alert(cells.item(k));
                            //alert (obj.id + " " + cells.item(k).innerHTML + document.getElementById(cells.item(k).innerHTML.replace("\s","-")));
                            //cells.item(k).innerHTML;
                        }
                }
                update();
            }


            function generateData() {
                var noOfDatasets=${replicateResult.keySet().size()}
                var dataSet = ${replicateResult.values()};
                var data=[];
                data.push({
                    label: "Mean",
                    data: ${plotData.get("Mean")},
                    backgroundColor: 'rgba(255, 206, 99, 0.6)',
                    borderColor:    'rgba(255, 206, 99, 0.8)',
                    borderWidth: 1
                });
                for(var i=0;i< noOfDatasets;i++){
                    data.push({
                        data: dataSet[i],
                        label: "Replicate: "+(i+1),
                        backgroundColor: 'rgba(255,99,132,1)',
                        borderColor: 'rgba(255,99,132,1)',
                        type: "scatter",
                        showLine: false
                    });
                }
                return data;
            }
        </script>
        <script src="https://unpkg.com/feather-icons/dist/feather.min.js"></script>
        <script>
            feather.replace()
        </script>



<!--div style="float:right; width:8%;padding-bottom: 10px"><button class="btn btn-primary" >Compare</button></div-->
