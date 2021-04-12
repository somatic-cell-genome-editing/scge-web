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
        Access access = new Access();
        Person p = access.getUser(request.getSession());

    %>

        <div class="chart-container" style="position: relative; height:80vh; width:80vw">
    <canvas id="resultChart"></canvas>

        </div>

    <table id="myTable" class="table tablesorter table-striped">
    <thead>
    <tr>
    <th>Name</th>
        <th>Tissue</th>
        <th>Cell Type</th>
        <th>Editor</th>
        <th>Model</th>
        <th>Delivery System</th>
        <th>Guide</th>
        <th>Vector</th>
        <th>Result Type</th>
        <th>Units</th>
        <th>Result in %</th>
    </tr>
    </thead>

        <% HashMap<Integer,Double> resultMap = (HashMap<Integer, Double>) request.getAttribute("resultMap");
            HashMap<Integer,List<ExperimentResultDetail>> resultDetail= (HashMap<Integer, List<ExperimentResultDetail>>) request.getAttribute("resultDetail");
            HashMap<Integer,String> labels = (HashMap<Integer, String>) request.getAttribute("experiments");
            for (ExperimentRecord exp: experimentRecords) {
        %>

        <% //if (access.hasStudyAccess(exp.getStudyId(),p.getId())) { %>
    <tr>
        <!--td><input class="form" type="checkbox"></td-->


        <td><a href="/toolkit/data/experiments/experiment/<%=exp.getExperimentId()%>/record/<%=exp.getExperimentRecordId()%>/"><%=labels.get(exp.getExperimentRecordId()).replace("\"","")%></a></td>
        <td><%=SFN.parse(exp.getTissueId())%></td>
        <td><%=SFN.parse(exp.getCellType())%></td>
        <td><a href="/toolkit/data/editors/editor?id=<%=exp.getEditorId()%>"><%=UI.replacePhiSymbol(exp.getEditorSymbol())%></a></td>
        <td><a href="/toolkit/data/models/model?id=<%=exp.getModelId()%>"><%=SFN.parse(exp.getModelName())%></a></td>
        <td><a href="/toolkit/data/delivery/system?id=<%=exp.getDeliverySystemId()%>"><%=SFN.parse(exp.getDeliverySystemType())%></a></td>
        <td><a href="/toolkit/data/guide/guide?id=<%=exp.getGuideId()%>"><%=SFN.parse(exp.getGuide())%></a></td>
        <td><a href="/toolkit/data/vector/format?id=<%=exp.getVectorId()%>"><%=SFN.parse(exp.getVector())%></a></td>
        <td><%=resultDetail.get(exp.getExperimentRecordId()).get(0).getResultType()%></td>
        <td><%=resultDetail.get(exp.getExperimentRecordId()).get(0).getUnits()%></td>
        <td><%=resultMap.get(exp.getExperimentRecordId())%></td>
    </tr>
        <% } %>
     <% //} %>
</table>
        <script>
            var ctx = document.getElementById("resultChart");
            var myChart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: ${experiments.values()},
                    datasets: generateData()
                },
                options: {
                    responsive: true,
                    scales: {
                        xAxes: [{
                            gridLines: {
                                offsetGridLines: true // à rajouter
                            }
                        },
                        ],
                        yAxes: [{
                            ticks: {
                                beginAtZero: true
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
                        j++;
                    }

                }

                myChart.data.labels = xArray;
                myChart.data.datasets[0].data = yArray;
                myChart.update();
            }

            function generateData() {
                var data=[];
                data.push({
                    label: "Mean",
                    data: ${plotData.get("Mean")},
                    backgroundColor: 'rgba(255, 99, 132, 0.2)',
                    borderColor: 'rgba(255,99,132,1)',
                    borderWidth: 1
                });
                return data;
            }
        </script>
        <script src="https://unpkg.com/feather-icons/dist/feather.min.js"></script>
        <script>
            feather.replace()
        </script>

<!--div style="float:right; width:8%;padding-bottom: 10px"><button class="btn btn-primary" >Compare</button></div-->
