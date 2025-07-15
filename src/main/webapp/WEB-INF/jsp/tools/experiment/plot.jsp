<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 11/26/2022
  Time: 6:39 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.util.List" %>

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

  resultTypeRecordsSize=<%=resultTypeRecords.size()%>;
</script>

<div>
    <p class="spinner" id="spinner">Loading...<i class="fa fa-spinner fa-spin" style="font-size:24px;color:dodgerblue"></i></p>
</div>
<div id="charts" style="visibility: hidden">
<%int cellCount=0;
    if(plots.size()>1 && maxBarCount<=10){%>
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

           <%cellCount++;}
    }
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



