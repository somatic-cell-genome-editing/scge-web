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
    function getDetails(index) {
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
         int rows=plotSize/3;
         if(plotSize%3!=0 )
             rows=rows+1;

         for (int r=0; r<rows;r++ ){

     %>
       <tr>
         <% for(int c=0;c<plots.size() && c<3;c++){%>
           <td style="height:<%=chartHeight%>px">
           <div class="chart-container bg-light" style="height:30vh;width: 25vw" id="chartDiv<%=cellCount%>">
               <canvas  id="resultChart<%=cellCount%>" ></canvas>
           </div>
           </td>
            <%cellCount++;}%>
       </tr>
       <%}%>
   </table>
    <%}else{ if(plots.size()==1){%>
    <div class="chart-container bg-light" style="height:60vh; width:60vw">
        <canvas  id="resultChart<%=cellCount%>" ></canvas>
    </div>
   <%}}%>
     <%
         int i=0;
         for(Plot plot: plots){
             if(i<=plots.size()-1){
     %>
<script>
    var ctx = document.getElementById("resultChart<%=i%>");
     myChart<%=i%> = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: <%=gson.toJson(plot.getTickLabels())%>,
            datasets: generateData()
        },
        options: {
            responsive: true,
            scaleShowValues: true,


            title: {
                display: true,

              //  text: [<%--=plot.getTitle()--%>],
                color:"#FF8C00"
            },

            scales: {
                xAxes: [{
                    gridLines: {
                        color: "rgba(0, 0, 0, 0)"
                    },

                    scaleLabel: {
                        display: true,
                        fontSize: 14,
                        fontStyle: 'bold',
                        fontFamily: 'Calibri'
                    },


                    ticks:{
                        fontColor: "rgb(0,75,141)",
                        fontSize: 10,
                        autoSkip: false,
                        callback: function(t) {
                            var maxLabelLength = 40;
                            if (t.length > maxLabelLength) return t.substr(0, maxLabelLength-20) + '...';
                            else return t;

                        }
                    },
                    barPercentage: 0.4
                }],
                yAxes: [{
                    id: 'delivery',
                    type: 'linear',
                    position: 'left',
                    ticks: {
                        beginAtZero: true
                    },
                    scaleLabel: {
                        display: true,
                        labelString: '<%=plot.getYaxisLabel()%>',
                        fontSize: 14,
                        fontStyle: 'bold',
                        fontFamily: 'Calibri'
                    }
                }]
            },
            tooltips: {
                callbacks: {
                    title: function(tooltipItem) {
                        return this._data.labels[tooltipItem[0].index];
                    },
                    afterLabel: function(tooltipItem) {
                        var index = tooltipItem.index;
                        return getDetails(index);

                    }

                }

            },

            hover: {
                mode: 'index',
                intersect: false
            },
            legend:{
                display:false
            }
        }
    });


    function generateData() {

        var data=[];

        <%
        boolean flag=false;
        for(String key :plot.getPlotData().keySet()){
            if(key.contains("dead")){
               flag=true;

            }}

        for(String k :plot.getPlotData().keySet()){
            String key=new String();
            if(flag){
              key=  k.replaceAll("\n", "");
            }else{
                key=k;
            }
        %>
        color=getRandomColor();
        data.push({
            label: '<%=key%>',
            data: <%=plot.getPlotData().get(key)%>,
            backgroundColor: color,
            borderColor: color,
            borderWidth: 1
        });
        <% for(Map.Entry entry:plot.getReplicateResult().entrySet()){
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
        <%}}%>

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


