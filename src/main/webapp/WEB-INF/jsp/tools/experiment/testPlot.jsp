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
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.1/Chart.min.js"></script>
<script>

</script>
<%
    List<Plot> plots= (List<Plot>) request.getAttribute("plots");
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
         if(plots.size()>=3){
             chartWidth=chartWidth/3;
         }else{
             chartWidth=chartWidth/plots.size();

         }
         for (int r=0; r<(plots.size()/3);r++ ){%>
       <tr>
         <% for(int c=0;c<plots.size() && c<3;c++){%>
           <td style="height:<%=chartHeight%>px">
           <div class="chart-container bg-light" style="height:30vh;width: 30vw">
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
    var myChart = new Chart(ctx, {
        type: 'bar',
        <%Gson gson=new Gson();%>
        data: {
            labels: <%=gson.toJson(plot.getTickLabels())%>,
            datasets: generateData()
        },
        options: {
            responsive: true,
            scaleShowValues: true,


            title: {
                display: true,

                text: '<%=plot.getTitle()%>',
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
                        return tooltipItem.index;

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


