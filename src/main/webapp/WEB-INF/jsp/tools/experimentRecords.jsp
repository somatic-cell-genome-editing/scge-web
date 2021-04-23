<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.web.UI" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="edu.mcw.scge.datamodel.*" %>

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
        List<ExperimentRecord> experimentRecords = (List<ExperimentRecord>) request.getAttribute("experimentRecords");
        Study study = (Study) request.getAttribute("study");
        Access access = new Access();
        Person p = access.getUser(request.getSession());
Experiment ex = (Experiment) request.getAttribute("experiment");
        //out.println(experiments.size());
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
        <th>Tissue</th>
        <th>Cell Type</th>
        <th class="tablesorter-header" data-placeholder="Search for editor...">Editor</th>
        <th>Model</th>
        <th>Delivery System</th>
        <th>Guide</th>
        <th>Vector</th>
        <th>Result Type</th>
        <th>Units</th>
        <th>Result</th>
    </tr>
    </thead>

        <% HashMap<Integer,Double> resultMap = (HashMap<Integer, Double>) request.getAttribute("resultMap");
            HashMap<Integer,List<ExperimentResultDetail>> resultDetail= (HashMap<Integer, List<ExperimentResultDetail>>) request.getAttribute("resultDetail");
            HashMap<Integer,List<Guide>> guideMap = (HashMap<Integer,List<Guide>>)request.getAttribute("guideMap");
            HashMap<Integer,List<Vector>> vectorMap = (HashMap<Integer,List<Vector>>)request.getAttribute("vectorMap");
            for (ExperimentRecord exp: experimentRecords) {
                List<Guide> guideList = guideMap.get(exp.getExperimentRecordId());
                String guide = "";
                for(Guide g: guideList) {
                    guide += "<a href=\"/toolkit/data/guide/system?id="+g.getGuide_id()+"\">"+SFN.parse(g.getGuide())+"</a>";
                    guide += ";\t";
                }
                List<Vector> vectorList = vectorMap.get(exp.getExperimentRecordId());
                String vector = "";
                for(Vector v: vectorList) {
                    vector += "<a href=\"/toolkit/data/vector/format?id="+v.getVectorId()+"\">"+SFN.parse(v.getName())+"</a>";
                    vector += ";\t";
                }
        %>

        <% if (access.hasStudyAccess(exp.getStudyId(),p.getId())) { %>
    <tr>
        <!--td><input class="form" type="checkbox"></td-->


        <td><a href="/toolkit/data/experiments/experiment/<%=exp.getExperimentId()%>/record/<%=exp.getExperimentRecordId()%>/"><%=SFN.parse(exp.getExperimentName())%></a></td>
        <td><%=SFN.parse(exp.getTissueId())%></td>
        <td><%=SFN.parse(exp.getCellType())%></td>
        <td><a href="/toolkit/data/editors/editor?id=<%=exp.getEditorId()%>"><%=UI.replacePhiSymbol(exp.getEditorSymbol())%></a></td>
        <td><a href="/toolkit/data/models/model?id=<%=exp.getModelId()%>"><%=SFN.parse(exp.getModelName())%></a></td>
        <td><a href="/toolkit/data/delivery/system?id=<%=exp.getDeliverySystemId()%>"><%=SFN.parse(exp.getDeliverySystemType())%></a></td>
        <td><%=guide%></td>
        <td><%=vector%></td>
        <td><%=resultDetail.get(exp.getExperimentRecordId()).get(0).getResultType()%></td>
        <td><%=resultDetail.get(exp.getExperimentRecordId()).get(0).getUnits()%></td>
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
