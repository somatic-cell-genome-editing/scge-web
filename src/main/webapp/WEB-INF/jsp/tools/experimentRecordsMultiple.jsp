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
            <td class="desc" > <%for(Person pi:study.getMultiplePis()){%>
                <%=pi.getName()%><br>
                <% }%></td>
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

                <% HashMap deliveryMap = (HashMap) request.getAttribute("deliveryMap");
                    HashMap<Integer,List<ExperimentResultDetail>> deliveryDetail= (HashMap<Integer, List<ExperimentResultDetail>>) request.getAttribute("deliveryDetail");
                    HashMap editingMap = (HashMap) request.getAttribute("editingMap");
                    HashMap<Integer,List<ExperimentResultDetail>> editingDetail= (HashMap<Integer, List<ExperimentResultDetail>>) request.getAttribute("editingDetail");

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
                    <td><%=deliveryDetail.get(exp.getExperimentRecordId()).get(0).getResultType()%></td>
                    <td><%=deliveryDetail.get(exp.getExperimentRecordId()).get(0).getUnits()%></td>
                    <td><%=deliveryMap.get(exp.getExperimentRecordId())%></td>
                    <%for(ExperimentResultDetail e:deliveryDetail.get(exp.getExperimentRecordId())) {%>
                    <td style="display: none"><%=e.getResult()%></td>
                    <%}%>
                </tr>
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
                    <td><%=editingDetail.get(exp.getExperimentRecordId()).get(0).getResultType()%></td>
                    <td><%=editingDetail.get(exp.getExperimentRecordId()).get(0).getUnits()%></td>
                    <td><%=editingMap.get(exp.getExperimentRecordId())%></td>
                    <%for(ExperimentResultDetail e:editingDetail.get(exp.getExperimentRecordId())) {%>
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
                    barValueSpacing: 0,
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
                            id: 'delivery',
                            type: 'linear',
                            position: 'left',
                            ticks: {
                                beginAtZero: true
                            },
                            scaleLabel: {
                                display: true,
                                labelString: ${deliveryEfficiency},
                                fontSize: 14,
                                fontStyle: 'bold',
                                fontFamily: 'Calibri'
                            }
                        }, {
                            id: 'editing',
                            type: 'linear',
                            position: 'right',
                            ticks: {
                                beginAtZero: true
                            },
                            scaleLabel: {
                                display: true,
                                labelString: ${editingEfficiency},
                                fontSize: 14,
                                fontStyle: 'bold',
                                fontFamily: 'Calibri'
                            }
                        }]
                    }
                }
            });

            function generateData() {
                var noOfDatasets=${deliveryReplicate.keySet().size()}
                var dataSet = ${deliveryReplicate.values()};
                var data=[];
                data.push({
                    label: "delivery",
                    yAxisID: 'delivery',
                    data: ${deliveryPlot.get("Mean")},
                    backgroundColor: 'rgba(255,99,132,0.2)',
                    borderColor: 'rgba(255,99,132,1)',
                    borderWidth: 1
                });
                data.push({
                    label: "editing",
                    yAxisID: 'editing',
                    data: ${editingPlot.get("Mean")},
                    backgroundColor:  'rgba(54, 162, 235, 0.2)',
                    borderColor: "rgba(54, 162, 235, 1)",
                    borderWidth: 1
                });
                for(var i=0;i< noOfDatasets;i++){
                    data.push({
                        data: dataSet[i],
                        label: "Replicate: "+(i+1),
                        yAxisID: 'delivery',
                        backgroundColor: 'rgba(255,99,132,1)',
                        borderColor: 'rgba(255,99,132,1)',
                        type: "scatter",
                        showLine: false
                    });
                }
                noOfDatasets = ${editingReplicate.keySet().size()}
                dataSet = ${editingReplicate.values()};
                for(var i=0;i< noOfDatasets;i++){
                    data.push({
                        data: dataSet[i],
                        label: "Replicate: "+(i+1),
                        yAxisID: 'editing',
                        backgroundColor:  'rgba(54, 162, 235, 1)',
                        borderColor: "rgba(54, 162, 235, 1)",
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
