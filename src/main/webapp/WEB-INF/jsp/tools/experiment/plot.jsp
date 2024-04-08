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
<%@ page import="edu.mcw.scge.web.Colors" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    #spinner   {

        animation: spin 1s linear infinite;
        color: red;
    }

    .inline{
        display: flex;
    }
    .spinner i{
        margin-top: 10px;
        margin-left: 50px;


    }
</style>
<div>
    <p class="spinner" id="spinner">Loading...<i class="fa fa-spinner fa-spin" style="font-size:24px;color:dodgerblue"></i></p>
</div>
<%
    List<String> rgbColors=new ArrayList<>();
    Map<Integer, String> colors=Colors.colors;
    for(int i: Colors.colors.keySet()){
        rgbColors.add(colors.get(i));
    }
%>

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
    <%--var colorPalette2=<%=gson.toJson(rgbColors)%>--%>
    var randomColors=[]
    randomColors= <%=gson.toJson(rgbColors)%>
    var colorPalette2=[];
        for(var clr in randomColors){
            var flag=false;
            for(var i=0;i<colorPalette.length;i++){
                if(colorPalette[i]==randomColors[clr]){
                    flag=true;
                    break;

                }
            }
            if(!flag){
                colorPalette2.push(randomColors[clr])
            }
        }
     //  console.log("COLOR PALETTE 2:"+ colorPalette2)
    function  generateDataSets(mean, replicates, recordIds, replicateResultSize, index) {
        var backgroundColor;
        var borderColor;
        if(index>30){
            backgroundColor=colorPalette2[index];
            borderColor=colorPalette2[index];
        }else{
            backgroundColor=colorPalette[index];
            borderColor=colorPalette[index];
        }

        var data=[];
        $.each(mean, function(i, val) {
            //     $("#" + i).append(document.createTextNode(" - " + val));
            data.push({
                label:"Mean",
                data: val,
                backgroundColor: backgroundColor,
                borderColor: borderColor,
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
        var avgIndex = table.rows.item(1).cells.length -1-<%=resultTypeRecords.size()%>;
        for (i = 2; i < rowLength; i++) {
            if (table.rows.item(i).style.display !== 'none') {
               var recordIdColValue = table.rows[i].cells.item(recordIdIndex).innerHTML;
                if (recordIdColValue == recordId) {
                    for(k = 1;k < avgIndex;k++){
                        var label = table.rows.item(1).cells.item(k).innerText;
                        var value = table.rows.item(i).cells.item(k).innerText;
                        detail.push("<span style='color:yellow'>"+label+"</span>" + ': ' + value) ;
                    }
                }

            }
        }
        return detail;
    }
    function generateData(plot) {
        var jsonStr=JSON.stringify(plot)
        var plotJson=(JSON).parse(jsonStr)
      //  console.log("PLOTJSONSTR:"+ (plotJson))
        var plotDataStr= JSON.stringify(plotJson.plotData);
        var plotData=new Map(Object.entries(JSON.parse(plotDataStr)))
      //  console.log("plotData:"+ plotData)
        var recordIds=[];
        recordIds= plotJson.recordIds

        var data=[];
        color=colorPalette[0];
        for(let [key, value] of plotData){
            data.push({
                label: '\'' + key + '\'',
                data: value,
                recordIds: recordIds,
                backgroundColor: color,
                borderColor: color,
                borderWidth: 1
            });

        }
        var replicateResultStr= JSON.stringify(plotJson.replicateResult)
        var replicateResult=new Map(Object.entries( JSON.parse(replicateResultStr)))
        for(let[key, value] of replicateResult){

            data.push({
                label: "Replicate - " + key,
                data: value,
                type: "scatter",
                backgroundColor: "red",
                showLine: false

            })

        }
       // console.log("DATA:"+ data);
        return data;
    }

</script>

<div id="charts" style="visibility: hidden">
<%int cellCount=0;
    if(plots.size()>1 && maxBarCount<10){%>
   <div>
     <%
         int chartHeight=400;
         int chartWidth=90;
         if(plots.size()>3) {
             chartHeight = chartHeight / (plots.size() / 3);
         }
         int plotSize=plots.size();
         int width=25;
         int columnSize=4;
         String colClass="col-sm-4";
         if(plotSize==2){
             width=35;
             columnSize=5;
             colClass="col-md-auto";
         }
         int rows=plotSize/3;
         if(plotSize%3!=0 )
             rows=rows+1;

         for (int r=0; r<rows;r++ ){%>
       <div class="row justify-content-md-center">
         <% for(int c=0;c<plots.size() && cellCount<plots.size() && c<3;c++){%>
           <div class="<%=colClass%>">

               <div class="chart-container" id="chartDiv<%=cellCount%>"  >
               <canvas  id="resultChart<%=cellCount%>" style="display:block; position: relative; height:<%=width+5%>vh;width: <%=width%>vw;padding-top: 5%" ></canvas>

               </div>
               <a id="image<%=cellCount%>"><button class="btn btn-light btn-sm"><i class="fa fa-download"></i> Download Graph</button></a>

           </div>
            <%cellCount++;}%>
       </div>
       <%}%>
   </div>
    <%}else{ if(maxBarCount>10 && plots.size()>1){
            for(int c=0;c<plots.size() && cellCount<plots.size();c++){%>
    <div  class="justify-content-md-center">
                <div class="chart-container" id="chartDiv<%=cellCount%>"  >
                    <canvas  id="resultChart<%=cellCount%>" style="display:block; position: relative; height:60vh;width: 60vw;padding-top: 5%" ></canvas>

                </div>
        <a id="image<%=cellCount%>"><button class="btn btn-light btn-sm"><i class="fa fa-download"></i> Download Graph</button></a>

    </div>

           <%cellCount++;}}
        if(plots.size()==1){%>
<div class="justify-content-md-center">
    <div>

    <div class="chart-container" id="chartDiv<%=cellCount%>">
        <canvas  id="resultChart<%=cellCount%>" style="position: relative; height:60vh; width:60vw;" ></canvas>

    </div>
        <a id="image<%=cellCount%>"><button class="btn btn-light btn-sm"><i class="fa fa-download"></i> Download Graph</button></a>

    </div>
</div>
   <%}}%>
</div>
<script>
    /*plugin to change the chart background to white in download image*/
    Chart.register({
        id: 'customBackground',
        beforeDraw: (chart, args, opts) => {
            const ctx = chart.canvas.getContext('2d');
            ctx.save();
            ctx.globalCompositeOperation = 'destination-over';
            ctx.fillStyle = 'white';
            ctx.fillRect(0, 0, chart.width, chart.height);
            ctx.restore();
        }
    })
</script>
     <%
         int i=0;
         for(Plot plot: plots){
             boolean tickDisplay= plot.getTickLabels().size() <= 120;
             String plotJson=gson.toJson(plot);
             if(i<=plots.size()-1){
     %>
<script>

    var plotJson=<%=plotJson%>
    var ctx<%=i%> = document.getElementById("resultChart<%=i%>");
     //plotRecordIds=<%--=plot.getRecordIds()--%>;
    var myChart<%=i%> = new Chart(ctx<%=i%>, {
        type: 'bar',
        data: {
            labels: plotJson.tickLabels,
            datasets: generateData(plotJson)
        },
        options: {
            responsive: true,
            scaleShowValues: true,
            maintainAspectRatio: false,

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
                        minRotation: 70 ,// angle in degrees
                        fontSize: 10,
                        autoSkip: false,
                        display:<%=tickDisplay%>,
                        callback: function(val, index) {
                            // Hide every 2nd tick label
                            var t=this.getLabelForValue(val);
                            var maxLabelLength = 30;
                            if (t.length > maxLabelLength) {
                                var tokenLength=t.length/3;
                                var token1=t.substr(0, t.indexOf(" "));
                                var token2='';
                                if(t.indexOf(",")>0)
                                  token2=  t.substr(t.indexOf(",")+1, t.substr(t.indexOf(",")+1).trim().indexOf("(")+1).trim();
                                var token3='';
                                if(t.indexOf("(")>0) {
                                    var tmp = t.substr(t.indexOf("(") + 1, t.substr(t.indexOf("(") + 1).indexOf(")"));
                                    var tmp1=tmp;
                                    if(tmp.indexOf('/')>0){
                                        tmp1=tmp.substr(0, tmp.indexOf('/'))
                                    }
                                    if(tmp1.indexOf(" ")>0)
                                        tmp1=tmp1.substr(0, tmp1.indexOf(" "));
                                    token3=tmp1;
                                }
                                var token4='';
                                if(t.indexOf("/")>0){
                                    token4= t.substr(t.indexOf("/")+1, t.substr(t.indexOf("/")+1).indexOf(")"));
                                }

                              /*  console.log("TICK:"+t +"\tLENGTH:"+tokenLength);
                                console.log("TOKEN1:"+token1);
                                console.log("TOKEN2:"+token2);

                                console.log("TOKEN3:"+token3);
                                console.log("TOKEN4:"+token4);*/
                                var newLabel=token1;
                                if(typeof token2!='undefined' && token2!='')
                                    newLabel+="..."+token2;
                                if(typeof token3!='undefined' && token3!='')
                                    newLabel+="..."+token3;
                                if(typeof token4!='undefined' && token4!='')
                                    newLabel+="..."+token4;
                              //  console.log("NEW LABEL:"+ newLabel);
                              //  return t.substr(0, maxLabelLength) + '...';
                                return newLabel
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
                        text: [plotJson.yaxisLabel]


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
                    text: plotJson.title,
                    color:plotJson.titleColor,
                    font: {
                        size:16
                    }
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
                    },

            }
            ,
            animation: {
                onComplete: function (context) {
                    var a=document.getElementById("image<%=i%>")
                    a.href=context.chart.toBase64Image();
                    a.download='<%=plot.getTitle().replaceAll(" ", "_")%>.png'
                }
            }
        }
    });


</script>
     <%i++;}}%>

<script src="https://unpkg.com/feather-icons/dist/feather.min.js"></script>
<script>feather.replace()</script>


