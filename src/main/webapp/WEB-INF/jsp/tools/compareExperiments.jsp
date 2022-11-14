<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.web.UI" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="edu.mcw.scge.datamodel.*" %>
<%@ page import="java.util.Set" %>

<%--
  Created by IntelliJ IDEA.
  User: hsnalabolu
  Date: 04/22/2021
  Time: 8:25 AM
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
        $("#myTable").tablesorter().bind("sortEnd", function (e, t) {
            update();
        });
        $("#myTable").tablesorter().bind("filterEnd", function (e, t) {
            update();
        });
    });
</script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.1/Chart.min.js"></script>

<%
    List<Study> studies = (List<Study>) request.getAttribute("studies");
    String editor1 = (String)request.getAttribute("editor1");
    String editor2 = (String)request.getAttribute("editor2");
%>

<table>
    <%
        for(Study study:studies) {
    %>
    <tr>
        <td class="desc" style="font-weight:700;"><%=study.getStudy()%>:</td>
        <td>&nbsp;&nbsp;&nbsp;</td>
        <td class="desc"   style="font-weight:700;">PI:</td>
        <td class="desc" > <%for(Person p:study.getMultiplePis()){%>
            <%=p.getName()%><br>
            <% }%></td>
        <td>&nbsp;&nbsp;&nbsp;</td>
        <td class="desc"  style="font-weight:700;">Submission Date:</td>
        <td class="desc" ><%=study.getSubmissionDate()%></td>
    </tr>
    <% } %>
</table>
<hr>
<table>
    <%
        ExperimentRecord expr1 = (ExperimentRecord) request.getAttribute("expRecord1");
        ExperimentRecord expr2 = (ExperimentRecord) request.getAttribute("expRecord2");
        Experiment exp1 = (Experiment) request.getAttribute("exp1");
        Experiment exp2 = (Experiment) request.getAttribute("exp2");

        String units = (String) request.getAttribute("units");

        List<Guide> guides1 = (List<Guide>)request.getAttribute("guides1");
        List<Guide> guides2 = (List<Guide>)request.getAttribute("guides2");

        System.out.println(guides1);
        System.out.println(guides2);

        String guide1 = "";
        for(Guide g: guides1) {
            if(!guide1.equals(""))
                guide1 += ";\t";
            guide1 += "<a href=\"/toolkit/data/guide/system?id="+g.getGuide_id()+"\">"+SFN.parse(g.getGuide())+"</a>";
        }
        String guide2 = "";
        for(Guide g: guides2) {
            if(!guide2.equals(""))
                guide2 += ";\t";
            guide2 += "<a href=\"/toolkit/data/guide/system?id="+g.getGuide_id()+"\">"+SFN.parse(g.getGuide())+"</a>";
        }
    %>
    <tr>
        <td class="desc" style="font-weight:700;"><%=exp1.getName()%>:</td>
        <td>&nbsp;&nbsp;&nbsp;</td>
        <td class="desc"   style="font-weight:700;">Editor:</td>
        <td class="desc"><a href="/toolkit/data/editors/editor?id=<%=expr1.getEditorId()%>"><%=expr1.getEditorSymbol()%></a></td>
        <td>&nbsp;&nbsp;&nbsp;</td>
        <td class="desc"  style="font-weight:700;">Guide:</td>
        <td class="desc" ><%=guide1%></td>
        <td>&nbsp;&nbsp;&nbsp;</td>
        <td class="desc"   style="font-weight:700;">Model:</td>
        <td class="desc"><a href="/toolkit/data/models/model?id=<%=expr2.getModelId()%>"><%=expr2.getModelName()%></a></td>
    </tr>
    <tr>
        <td class="desc" style="font-weight:700;"><%=exp2.getName()%>:</td>
        <td>&nbsp;&nbsp;&nbsp;</td>
        <td class="desc"   style="font-weight:700;">Editor:</td>
        <td class="desc"><a href="/toolkit/data/editors/editor?id=<%=expr2.getEditorId()%>"><%=expr2.getEditorSymbol()%></a></td>
        <td>&nbsp;&nbsp;&nbsp;</td>
        <td class="desc"  style="font-weight:700;">Guide:</td>
        <td class="desc" ><%=guide2%></td>
        <td>&nbsp;&nbsp;&nbsp;</td>
        <td class="desc"   style="font-weight:700;">Model:</td>
        <td class="desc"><a href="/toolkit/data/models/model?id=<%=expr2.getModelId()%>"><%=expr2.getModelName()%></a></td>
    </tr>
</table>
<hr>

        <div class="chart-container" style="position: relative; height:80vh; width:80vw">
    <canvas id="myChart"></canvas>

        </div>
<div>
    <hr>
    <h3>Results</h3>

    <table id="myTable" class="table tablesorter table-striped">
        <thead>
        <tr>
            <th class="tablesorter-header" data-placeholder="Search for Delivery...">Delivery</th>
            <th><%=units%> for <%=editor1%> </th>
            <th><%=units%>Result for <%=editor2%></th>
        </tr>
        </thead>
        <% HashMap<Integer,String> labels = (HashMap<Integer,String>) request.getAttribute("labels");
            HashMap<String,Double> exp1Results= (HashMap<String, Double>) request.getAttribute("exp1Results");
            HashMap<String,Double> exp2Results= (HashMap<String, Double>) request.getAttribute("exp2Results");
            for (Integer id: labels.keySet()) {
                String label = labels.get(id);
        %>
        <tr>

            <td><a href="/toolkit/data/delivery/system?id=<%=id%>"><%=label%></a></td>
            <td><%=exp1Results.get(label)%></td>
            <td><%=exp2Results.get(label)%></td>
        </tr>
        <% } %>
    </table>
    </div>
        <script>
            var ctx = document.getElementById("myChart");
            var myChart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: ${labelNames},
                    datasets: [
                            {
                                    label: ${editor1},
                                    backgroundColor: 'rgba(255,99,132,1)',
                                    borderColor: 'rgba(255,99,132,1)',
                                    data: ${exp1Mean}
                            },
                            {
                                    label: ${editor2},
                                    backgroundColor:  'rgba(54, 162, 235, 1)',
                                    borderColor: "rgba(54, 162, 235, 1)",
                                    data: ${exp2Mean}
                            }
                    ]
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
                                labelString: ${units},
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
            var zArray=[];
            var rowLength = table.rows.length;
            var j = 0;
            for (i = 2; i < rowLength; i++){
                if(table.rows.item(i).style.display != 'none') {
                    var cells = table.rows.item(i).cells;
                    var column = cells.item(0); //points to condition column
                    var exp1 = cells.item(1);
                    var exp2 = cells.item(2);
                    xArray[j] = "\""+column.innerText+"\"";
                    yArray[j] = exp1.innerHTML;
                    zArray[j] = exp2.innerHTML;
                    j++;
                }
            }
            myChart.data.labels = xArray;
            myChart.data.datasets[0].data = yArray;
            myChart.data.datasets[1].data = zArray;
            myChart.update();
        }
        </script>
        <script src="https://unpkg.com/feather-icons/dist/feather.min.js"></script>
        <script>
            feather.replace()
        </script>
<!--div style="float:right; width:8%;padding-bottom: 10px"><button class="btn btn-primary" >Compare</button></div-->
