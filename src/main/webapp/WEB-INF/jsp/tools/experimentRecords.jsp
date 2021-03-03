<%@ page import="edu.mcw.scge.datamodel.Experiment" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.datamodel.Study" %>
<%@ page import="edu.mcw.scge.datamodel.ExperimentRecord" %>
<%@ page import="edu.mcw.scge.web.UI" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.datamodel.Person" %>

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
            theme : 'blue'

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

        <div>
    <canvas id="resultChart" width="1000" height="400"></canvas>

        </div>

    <table id="myTable" class="table tablesorter table-striped">
    <thead>
    <tr>
    <th>Name</th>
        <th>Editor</th>
        <th>Model</th>
        <th>Delivery System</th>
        <th>Vector</th>
        <th>Guide</th>
    </tr>
    </thead>

        <% for (ExperimentRecord exp: experimentRecords) { %>

        <% if (access.hasStudyAccess(exp.getStudyId(),p.getId())) { %>
    <tr>
        <!--td><input class="form" type="checkbox"></td-->


        <td><a href="/toolkit/data/experiments/experiment/<%=exp.getExperimentId()%>/record/<%=exp.getExperimentRecordId()%>/"><%=SFN.parse(exp.getExperimentName())%></a></td>
        <td><a href="/toolkit/data/editors/editor?id=<%=exp.getEditorId()%>"><%=UI.replacePhiSymbol(exp.getEditorSymbol())%></a></td>
        <td><a href="/toolkit/data/models/model?id=<%=exp.getModelId()%>"><%=SFN.parse(exp.getModelName())%></a></td>
        <td><a href="/toolkit/data/delivery/system?id=<%=exp.getDeliverySystemId()%>"><%=SFN.parse(exp.getDeliverySystemType())%></a></td>
        <td></td>
        <td><a href="/toolkit/data/guide/guide?id=<%=exp.getGuideId()%>"><%=SFN.parse(exp.getGuide())%></a></td>
    </tr>
        <% } %>
     <% } %>
</table>

        <script>
            var ctx = document.getElementById("resultChart");
            var myChart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: ${experiments},
                    datasets: [{
                        label: 'Replicate 1',
                        data: ${plotData.get("Replicate-1")},
                        backgroundColor: 'rgba(255, 99, 132, 0.2)',
                        borderColor: 'rgba(255,99,132,1)',
                        borderWidth: 1
                    },
                    {
                        label: "Replicate 2",
                        data: ${plotData.get("Replicate-2")},
                        backgroundColor:  'rgba(54, 162, 235, 0.2)',
                        borderColor: "rgba(54, 162, 235, 1)",
                        borderWidth: 1
                    },
                    {
                        label: "Replicate 3",
                        data: ${plotData.get("Replicate-3")},
                        backgroundColor: "rgba(255, 206, 86, 0.2)",
                        borderColor:  'rgba(255, 206, 86, 1)',
                        borderWidth: 1
                    },
                    {
                        label: "Mean",
                        data: ${plotData.get("Mean")},
                        borderColor:    'rgba(153, 102, 255, 1)',
                        borderWidth: 1,
                        type: "scatter"
                    }
                    ]
                },
                options: {
                    responsive: false,
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
        </script>
        <script src="https://unpkg.com/feather-icons/dist/feather.min.js"></script>
        <script>
            feather.replace()
        </script>
<!--div style="float:right; width:8%;padding-bottom: 10px"><button class="btn btn-primary" >Compare</button></div-->
