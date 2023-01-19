<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 11/26/2022
  Time: 6:39 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.util.List" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="edu.mcw.scge.datamodel.Plot" %>
<%@ page import="java.util.Map" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<script>
    colorPalette = [
        'rgba(230, 159, 0, 0.5)', 'rgba(86, 180, 233, 0.5)', 'rgba(0, 158, 115, 0.5)', 'rgba(240, 228, 66, 0.5)',
        'rgba(0, 114, 178, 0.5)', 'rgba(213, 94, 0, 0.5)', 'rgba(204, 121, 167, 0.5)', 'rgba(0, 0, 0, 0.5)',
        'rgba(233, 150, 122, 0.5)', 'rgba(139, 0, 139, 0.5)', 'rgba(169, 169, 169, 0.5)', 'rgba(220, 20, 60, 0.5)',
        'rgba(100, 149, 237, 0.5)', 'rgba(127, 255, 0, 0.5)', 'rgba(0, 0, 128, 0.5)', 'rgba(255, 222, 173, 0.5)',
        'rgba(128, 0, 0, 0.5)', 'rgba(224, 255, 255, 0.5)', 'rgba(32, 178, 170, 0.5)', 'rgba(160, 82, 45, 0.5)',
        'rgba(238, 130, 238, 0.5)', 'rgba(154, 205, 50, 0.5)', 'rgba(219, 112, 147, 0.5)', 'rgba(199, 21, 133, 0.5)',
        'rgba(102, 205, 170, 0.5)', 'rgba(240, 128, 128, 0.5)', 'rgba(222, 184, 135, 0.5)', 'rgba(95, 158, 160, 0.5)',
        'rgba(189, 183, 107, 0.5)', 'rgba(0, 100, 0, 0.5)', 'rgba(0, 191, 255, 0.5)', 'rgba(255, 0, 255, 0.5)',
        'rgba(218, 165, 32, 0.5)', 'rgba(75, 0, 130, 0.5)'
    ];
    function  generateDataSets(mean, replicates, recordIds, replicateResultSize, index) {

        var data=[];
        $.each(mean, function(i, val) {
            //     $("#" + i).append(document.createTextNode(" - " + val));
            data.push({
                label:"Mean",
                data: val,
                backgroundColor: colorPalette[index],
                borderColor: colorPalette[index],
                borderWidth: 1,
                recordIds:recordIds,
                replicateResultSize:replicateResultSize
            });
        });

        $.each(replicates, function(i, val) {
            data.push({
                label: "Replicate - "+i,
                data:val,
                type: "scatter",
                backgroundColor:"red",
                showLine: false

            });


        });


        return data;
    }
    function getRandomColor() {
        var trans = '0.5'; // 50% transparency
        var color = 'rgba(';
        for (var i = 0; i < 3; i++) {
            color += Math.floor(Math.random() * 255) + ',';
        }
        color += trans + ')'; // add the transparency
        return color;
    }
    function getDetailsOLD(index) {
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
    function getDetails(recordId) {
      //  var recordId=plotRecordIds[index];
        var table = document.getElementById('myTable');
        var recordIdIndex=0;
        var cellLength=  table.rows[1].cells.length;
        for(var j=0;j<cellLength;j++){
            var cellText= table.rows[1].cells[j].innerHTML;
            if(cellText.includes( "Record ID")){
                recordIdIndex=j;
            }
        }

        var detail = [];
        var rowLength = table.rows.length;
        var avgIndex = table.rows.item(1).cells.length -3;
        for (i = 2; i < rowLength; i++) {
            if (table.rows.item(i).style.display !== 'none') {
               var recordIdColValue = table.rows[i].cells.item(recordIdIndex).innerHTML;
                if (recordIdColValue == recordId) {
                    for(k = 1;k < avgIndex-2;k++){
                        var label = table.rows.item(1).cells.item(k).innerText;
                        var value = table.rows.item(i).cells.item(k).innerText;
                        detail.push(label + ':' + value) ;
                    }
                }

            }
        }
        return detail;
    }

</script>

<%
    int cellCount=0;
    if(plots.size()>1){
%>
   <table style="height: 400px;width:100%">
     <%
         int chartHeight=400;
         int chartWidth=90;
         if(plots.size()>3) {
             chartHeight = chartHeight / (plots.size() / 3);
         }
         int plotSize=plots.size();
         int width=25;

         if(plotSize==2){
             width=35;
         }
         int rows=plotSize/3;
         if(plotSize%3!=0 )
             rows=rows+1;

         for (int r=0; r<rows;r++ ){

     %>
       <tr>
         <% for(int c=0;c<plots.size() && c<3;c++){%>
           <td style="height:<%=chartHeight%>px">
           <div class="chart-container bg-light" id="chartDiv<%=cellCount%>"  style="display:block; position: relative; height:<%=width%>vh;width: <%=width%>vw">
               <canvas  id="resultChart<%=cellCount%>" style=" " ></canvas>
           </div>
           </td>
            <%cellCount++;}%>
       </tr>
       <%}%>
   </table>
    <%}else{ if(plots.size()==1){%>
    <div class="chart-container bg-light" id="chartDiv<%=cellCount%>" style="display: block; height:60vh; width:60vw;">
        <canvas  id="resultChart<%=cellCount%>" style="position: relative; height:60vh; width:60vw;" ></canvas>
    </div>
   <%}}%>
     <%
         int i=0;
         for(Plot plot: plots){
             if(i<=plots.size()-1){
     %>
<script>
    var ctx = document.getElementById("resultChart<%=i%>");
     //plotRecordIds=<%--=plot.getRecordIds()--%>;
     myChart<%=i%> = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: <%=gson.toJson(plot.getTickLabels())%>,
            datasets: generateData()
        },
        options: {
            responsive: true,
            scaleShowValues: true,


            scales: {
                x: {
                    grid: {
                        color: "rgba(0, 0, 0, 0)"
                    },

                    scaleLabel: {
                        display: true,
                        fontSize: 14,
                        fontStyle: 'bold',
                        fontFamily: 'Calibri'
                    },


                    ticks: {
                        fontSize: 10,
                        autoSkip: false,
                        callback: function(val, index) {
                            // Hide every 2nd tick label
                            var t=this.getLabelForValue(val);

                            var maxLabelLength = 40;
                            if (t.length > maxLabelLength) {
                                return t.substr(0, maxLabelLength - 20) + '...';
                            }
                            return t;
                        }
                    }
                },
                y: {
                    ticks: {
                        beginAtZero: true
                    },
                    title: {
                        display: true,
                        text: [<%=plot.getYaxisLabel()%>]

                    }
                }
            },


            hover: {
                mode: 'index',
                intersect: false
            },
            plugins: {
                legend: {
                    display: false
                }
                ,
                title: {
                    display: true,

                    //  text: [<%--=plot.getTitle()--%>],
                    text: '<%=plot.getTitle()%>',
                    color: "#FF8C00"
                },

                    tooltip:{
                        enabled:false,

                        external:function (context){
                            let tooltipEl = document.getElementById('chartjs-tooltip');

                            // Create element on first render
                            if (!tooltipEl) {
                                tooltipEl = document.createElement('div');
                                tooltipEl.id = 'chartjs-tooltip';
                                tooltipEl.innerHTML = '<table></table>';
                                document.body.appendChild(tooltipEl);
                            }

                            // Hide if no tooltip
                            const tooltipModel = context.tooltip;
                            if (tooltipModel.opacity === 0) {
                                tooltipEl.style.opacity = 0;
                                return;
                            }

                            // Set caret Position
                            tooltipEl.classList.remove('above', 'below', 'no-transform');
                            if (tooltipModel.yAlign) {
                                tooltipEl.classList.add(tooltipModel.yAlign);
                            } else {
                                tooltipEl.classList.add('no-transform');
                            }

                            function getBody(bodyItem) {
                                return bodyItem.lines;
                            }

                            // Set Text
                            if (tooltipModel.body) {
                                const titleLines = tooltipModel.title || [];
                                const bodyLines = tooltipModel.body.map(getBody);
                                var details="";

                                if (tooltipModel.dataPoints.length) {
                                    var index=tooltipModel.dataPoints[0].dataIndex;
                                    var recordIds=tooltipModel.dataPoints[0].dataset.recordIds;
                                    if(typeof recordIds!='undefined') {
                                        var recordId = tooltipModel.dataPoints[0].dataset.recordIds[index];
                                        details = getDetails(recordId);
                                    }
                                }
                                let innerHtml = '<thead>';

                                titleLines.forEach(function(title) {
                                    innerHtml += '<tr><th>' + title + '</th></tr>';
                                });
                                innerHtml += '</thead><tbody>';

                                bodyLines.forEach(function(body, i) {
                                    const colors = tooltipModel.labelColors[i];
                                    let style = 'background:' + colors.backgroundColor;
                                    style += '; border-color:' + colors.borderColor;
                                    style += '; border-width: 2px';
                                    const span = '<span style="' + style + '">' + body + '</span>';
                                    innerHtml += '<tr><td>' + span + '</td></tr>';

                                    for(var item=0;item<details.length;item++)
                                        innerHtml += '<tr><td >' +details[item] + '</td></tr>';
                                    //innerHtml += '</tbody>';
                                });
                                innerHtml += '</tbody>';

                                let tableRoot = tooltipEl.querySelector('table');
                                tableRoot.innerHTML = innerHtml;
                            }

                            const position = context.chart.canvas.getBoundingClientRect();
                            const bodyFont = Chart.helpers.toFont(tooltipModel.options.bodyFont);

                            // Display, position, and set styles for font
                            tooltipEl.style.opacity = 1;
                            tooltipEl.style.position = 'absolute';
                            tooltipEl.style.left = position.left + window.pageXOffset + tooltipModel.caretX + 'px';
                            tooltipEl.style.top = position.top + window.pageYOffset + tooltipModel.caretY + 'px';
                            tooltipEl.style.font = bodyFont.string;
                            tooltipEl.style.padding = tooltipModel.padding + 'px ' + tooltipModel.padding + 'px';
                            tooltipEl.style.pointerEvents = 'none';
                            tooltipEl.style.color='white';
                            tooltipEl.style.backgroundColor= 'rgba(0, 0, 0, 0.7)';
                        }
                    }



            }
        }
    });


    function generateData() {

        var data=[];
        color=colorPalette[0];
        <%for(String key:plot.getPlotData().keySet()){%>
        data.push({
            label: '<%=key%>>',
            data: <%=plot.getPlotData().get(key)%>,
            recordIds:<%=plot.getRecordIds()%>,
            backgroundColor: color,
            borderColor: color,
            borderWidth: 1
        });
        <%} for(Map.Entry entry:plot.getReplicateResult().entrySet()){
            int replicate=(int) entry.getKey();
            List<Double> values=(List<Double>) entry.getValue();
        %>
        data.push({
            label: "Replicate - <%=replicate%>",
            data: <%=values%>,
            type: "scatter",
            backgroundColor:"red",
            showLine: false

        })
        <%}%>

        return data;
    }
     function getRandomColor() {
        var trans = '0.5'; // 50% transparency
        var color = 'rgba(';
        for (var i = 0; i < 3; i++) {
            color += Math.floor(Math.random() * 255) + ',';
        }
        color += trans + ')'; // add the transparency
        return color;
    }
</script>
         <%i++;}}%>

<script src="https://unpkg.com/feather-icons/dist/feather.min.js"></script>
<script>

    feather.replace()
</script>


