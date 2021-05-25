<%@ page import="edu.mcw.scge.web.UI" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.datamodel.*" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.dao.implementation.ExperimentResultDao" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 10/20/2020
  Time: 8:40 AM
  To change this template use File | Settings | File Templates.
--%>

<link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" integrity="sha384-AYmEC3Yw5cVb3ZcuHtOA93w35dYTsvhLPVnYs9eStHfGJvOvKxVfELGroGkvsg+p" crossorigin="anonymous"/>
<script>
    $(function() {
        $("#myTable").tablesorter({
            theme : 'blue'

        });
        $("#samplesTable").tablesorter({
            theme : 'blue'

        });
        $("#resultsTable").tablesorter({
            theme : 'blue'

        });
    });

</script>
<script src="https://d3js.org/d3.v4.js"></script>
<style>
    /* disable text selection */
    svg *::selection {
        background : transparent;
    }

    svg *::-moz-selection {
        background:transparent;
    }

    svg *::-webkit-selection {
        background:transparent;
    }
    rect.selection {
        stroke          : #333;
        stroke-dasharray: 4px;
        stroke-opacity  : 0.5;
        fill            : transparent;
    }

    rect.cell-border {
        stroke: gray;
        stroke-width:0.3px;
    }

    rect.cell-selected {
        stroke: rgb(51,102,153);
        stroke-width:0.5px;
    }

    rect.cell-hover {
        stroke: #F00;
        stroke-width:0.3px;
    }

    text.mono {
        font-size: 9pt;
        font-family: Consolas, courier;
        fill: #aaa;
    }

    text.text-selected {
        fill: #000;
    }

    text.text-highlight {
        fill: red;
    }
    text.text-hover {
        fill: #00C;
    }
    .tooltip {
        position: absolute;
        width: 200px;
        height: auto;
        padding: 10px;
        background-color: white;
        -webkit-border-radius: 10px;
        -moz-border-radius: 10px;
        border-radius: 10px;
        -webkit-box-shadow: 4px 4px 10px rgba(0, 0, 0, 0.4);
        -moz-box-shadow: 4px 4px 10px rgba(0, 0, 0, 0.4);
        box-shadow: 4px 4px 10px rgba(0, 0, 0, 0.4);
        pointer-events: none;
    }

    .tooltip.hidden {
        display: none;
    }

    .tooltip p {
        margin: 0;
        font-family: sans-serif;
        font-size: 12px;
        line-height: 20px;
    }
    .header{
        font-weight: bold;
        font-size: 12px;
        color:steelblue;
        width: 25%;
        background-color: #ECECF9;
    }
    td{
        padding-left:1%;
    }
    .heatmapCell {
        font-size:14px;
        border:1px solid black;
        text-align:center;
        width:30px;height:20px;

    }
</style>

<div>
    <div>
        <table style="width:80%">

            <tbody>
            <tr><td class="header"><strong>Experiment</strong></td><td>${experiment.experimentName}</td></tr>

            </tbody>
        </table>

    </div>

    <hr>
    <div>
        <table style="width:80%">

            <%

                List<Delivery> dList = (List<Delivery>)request.getAttribute("deliveryList");
                Delivery d =new Delivery();
                if(dList!=null && dList.size()>0)
                    d=dList.get(0);

                List<Editor> editorList = (List<Editor>)request.getAttribute("editorList");
                Editor e = new Editor();
                if(editorList != null && editorList.size() > 0)
                    e=editorList.get(0);

                List<Guide> guideList = (List<Guide>)request.getAttribute("guideList");
                String guide = "";
                for(Guide g: guideList) {
                    guide += "<a href=\"/toolkit/data/guide/system?id="+g.getGuide_id()+"\">"+g.getGuide()+"</a>";
                    guide += ";\t";
                }

                List<Vector> vectorList = (List<Vector>)request.getAttribute("vectorList");
                String vector = "";
                for(Vector v: vectorList) {
                    vector += "<a href=\"/toolkit/data/vector/format?id="+v.getVectorId()+"\">"+v.getName()+"</a>";
                    vector += ";\t";
                }
                List<ApplicationMethod> methods = (List<ApplicationMethod>)request.getAttribute("applicationMethod");
                ApplicationMethod a = new ApplicationMethod();
                if(methods !=null && methods.size() > 0)
                    a = methods.get(0);
            %>
                <tr><td class="header"><strong>Editor</strong></td><td><a href="/toolkit/data/editors/editor?id=<%=e.getId()%>"><%=SFN.parse(e.getSymbol())%></a></td></tr>
                <tr><td class="header"><strong>Delivery System</strong></td><td><a href="/toolkit/data/delivery/system?id=<%=d.getId()%>"><%=SFN.parse(d.getType())%></a></td></tr>
                <tr><td class="header"><strong>Delivery System Subtype</strong></td><td><%=SFN.parse(d.getSubtype())%></td></tr>
                <tr><td class="header"><strong>Guide</strong></td><td><%=guide%></td></tr>
            <tr><td class="header"><strong>Vector</strong></td><td><%=vector%></td></tr>
            </tbody>
        </table>
    </div>
    <hr>


    <hr>
    <div>
<table  style="width:80%">

    <tbody>
    <tr><td class="header"><strong>Model Species</strong></td><td>${model.organism}</td></tr>
        <tr><td class="header"><strong>Model Name</strong></td><td><a href="/toolkit/data/models/model?id=${model.modelId}">${model.name}</a></td></tr>
    </tbody>
</table>
    </div>
    <hr>
    <div>

    </div>
    <hr>
    <div>
        <table style="width:80%">

            <tbody>

                <tr><td class="header"><strong>Application Method</strong></td><td><%=a.getApplicationType()%></td></tr>
                <tr><td class="header"><strong>Application Site</strong></td><td><%=SFN.parse(a.getSiteOfApplication())%></td></tr>
                <tr><td class="header"><strong>Dosage</strong></td><td><%=SFN.parse(a.getDosage())%></td></tr>
                <tr><td class="header"><strong>Injection Frequency</strong></td><td><%=SFN.parse(a.getInjectionFrequency())%></td></tr>
                <tr><td class="header"><strong>Injection Rate</strong></td><td><%=SFN.parse(a.getInjectionRate())%></td></tr>
                <tr><td class="header"><strong>Injection Volume</strong></td><td><%=SFN.parse(a.getInjectionVolume())%></td></tr>
                <tr><td class="header"><strong>Days post injection</strong></td><td><%=SFN.parse(a.getDaysPostInjection())%></td></tr>
                <tr><td class="header"><strong>Editor Format</strong></td><td><%=a.getEditorFormat()%></td></tr>
                <tr><td class="header"><strong>Antidote Id</strong></td><td><%=SFN.parse(a.getAntidoteId())%></td></tr>
                <tr><td class="header"><strong>Antidote Description</strong></td><td><%=SFN.parse(a.getAntidoteDescription())%></td></tr>
            </tbody>
        </table>
    </div>
    <hr>
    <hr>
    <%
        ExperimentResultDao erdao = new ExperimentResultDao();
        List<ExperimentResultDetail> resultDetail = erdao.getResultsByExperimentRecId(446);

        for (ExperimentResultDetail erd: resultDetail ) {
        %>
            <%=erd.getAssayDescription()%><br>
            <%=erd.get%>


       <% }  %>




    %>


    <div class="row">
        <div class="col-lg-3">
            <table width="600"><tr><td><h3>Result Detail</h3></td><td align="right"></td></tr></table>
        </div>
    </div>
    <div id="results">
        <table id="resultsTable" class="table tablesorter table-striped" style="width:50%;">
            <thead><tr>
                <th>Sample Count</th>
                <th>Units</th>
                <th>Assay Description</th>
                <th>Result Type</th>
                <th>Replicate</th>
                <th>Result</th>
            </tr></thead>
            <tbody>

            <c:forEach items="${experimentResults}" var="r">
                <tr>
                    <td>${r.numberOfSamples}</td>
                    <td>${r.units}</td>
                    <td>${r.assayDescription}</td>
                    <td>${r.resultType}</td>
                    <td>${r.replicate}</td>
                    <td>${r.result}</td>
                </tr>

            </c:forEach>
            </tbody>
        </table>
    </div>
<!-- JD NEW -->
    <hr>
    <div class="row">
        <div class="col-lg-3">
            <table width="600"><tr><td><h3>Tissue Signal Map</h3></td><td align="right"><button class="btn" id="summaryResultsTableBtn" onclick="showTable()">Show Table</button></td></tr></table>

        </div>
    </div>
    <div id="summaryTable2" style="float:left;padding-right:30px;">
        <table id="myTable2" class="able ablesorter table-striped" style="width:400px;" border="0">
            <thead><tr>
                <th>Biological&nbsp;System</th>
                <th>Tissue</th>
                <th>Signal</th>
            </tr></thead>
            <tbody>


            <%
                List<AnimalTestingResultsSummary> results= (List<AnimalTestingResultsSummary>)request.getAttribute("results");
                int count=0;
                boolean columnOne = true;
                for (AnimalTestingResultsSummary r: results) {
                    count++;
            %>

                <tr>
                    <td><%=r.getParentTissueTerm()%></td>
                    <td><%=r.getTissueTerm()%></td>
                    <td>

                        <table border="0" cellpadding="0" cellspacing="0">
                            <tr>

                                <%
                                   String color="white";
                                    if ((Double.parseDouble(r.getSignalPresent()) / (double)r.getNumberOfSamples()) < .5) {
                                    color="black";
                                }

                                %>

                                <td style="padding:0px;margin:0px;"><div class="heatmapCell" style="font-size:10px; color:<%=color%>;border:1px solid black;text-align:center;width:30px;height:20px;background-color:<%=UI.getRGBValue("blue",Integer.parseInt(r.getSignalPresent()),r.getNumberOfSamples())%>"> <%=Integer.parseInt(r.getSignalPresent())%>/<%=r.getNumberOfSamples()%></div></td>
                                <td style="padding:0px;margin:0px;"><div class="heatmapCell"  style="font-size:10px; color:<%=color%>;border:1px solid black;text-align:center;width:30px;height:20px;background-color:<%=UI.getRGBValue("green",Integer.parseInt(r.getSignalPresent()),r.getNumberOfSamples())%>"> <%=Integer.parseInt(r.getSignalPresent())%>/<%=r.getNumberOfSamples()%></div></td>
                            </tr>
                            <tr>
                                <td style="padding:0px;margin:0px;"><div class="heatmapCell"  style="font-size:10px; border:1px solid black;text-align:center;width:30px;height:20px;background-color:<%=UI.getRGBValue("red",1,255)%>"></div></td>
                                <td style="padding:0px;margin:0px;"><div class="heatmapCell"  style="font-size:10px; color:<%=color%>;border:1px solid black;text-align:center;width:30px;height:20px;background-color:<%=UI.getRGBValue("rd",Integer.parseInt(r.getSignalPresent()),r.getNumberOfSamples())%>"> <%=Integer.parseInt(r.getSignalPresent())%>/<%=r.getNumberOfSamples()%></div></td>
                            </tr>
                        </table>
                        <!--
                        <table border="1" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td style="padding:0px;margin:0px;">d</td>
                                <td style="padding:0px;margin:0px;">d</td>
                            </tr>
                            <tr>
                                <td style="padding:0px;margin:0px;">f</td>
                                <td style="padding:0px;margin:0px;">g</td>
                            </tr>
                        </table>
-->
                    </td>

                    <!--
                    <td><%=r.getNumberOfSamples()%></td>
                    <td><%=r.getSignal()%></td>
                    <td><%=r.getSignalPresent()%></td>
                    <td><%=r.getSignalDescription()%></td>
                    <td><%=r.getImageLink()%></td>
                    <td><%=r.getPercentCellsInROIWithSginal()%></td>
                    <td><%=r.getRoi()%></td>
                    <td><%=r.getROICoordinates()%></td>
                    -->
                </tr>


            <%
                if ((count > (results.size() /2) && columnOne) ) {
                    columnOne = false;
                    %>
            </tbody></table></div>
            <div id="summaryTable3" style="">
            <table id="myTable3" class="able ablesorter table-striped" style="width:400px;" border="0">
                <thead><tr>
                    <th>Biological&nbsp;System</th>
                    <th>Tissue</th>
                    <th>Signal</th>
                </tr></thead>
                <tbody>
                <%} %>

                <% } %>

            </tbody>
        </table>
    </div>


    <hr>
    <div id="summaryTable" style="display: none">
        <table id="myTable" class="table tablesorter table-striped" style="width:50%">
            <thead><tr>
                <th>Organ System</th>
                <th>Tissue</th>
                <th>Sample Count</th>
                <th>Abesent/Present</th>
                <th>Number Present</th>
                <th>Signal Description</th>
                <th>Image</th>
                <th>Percent With Signal</th>
                <th>ROI</th>
                <th>ROI Coordinates</th>

            </tr></thead>
            <tbody>

            <c:forEach items="${results}" var="r">
                <tr>
                    <td>${r.parentTissueTerm}</td>
                    <td>${r.tissueTerm}</td>
                    <td>${r.numberOfSamples}</td>

                    <td>${r.signal}</td>
                    <td>${r.signalPresent}</td>
                    <td>${r.signalDescription}</td>
                    <td>${r.imageLink}</td>
                    <td>${r.percentCellsInROIWithSginal}</td>
                    <td>${r.roi}</td>
                    <td>${r.ROICoordinates}</td>
                </tr>

            </c:forEach>
            </tbody>
        </table>
    </div>
    <hr>

    <%@include file="graph.jsp"%>
    <div >
        <c:forEach items="${results}" var="r">
        <div class="satcResults  card" id="${r.tissueTerm}" style="display: none">
        <div  class="container" style="padding:1%">
           <table>
               <tr>
                <td class="header">Parent Tissue</td>   <td><h3>${r.parentTissueTerm}</h3></td>
               </tr>
               <tr>
                   <td class="header">Tissue</td> <td>${r.tissueTerm}</td></tr>
               <tr>
                <td class="header">Number of samples</td>                    <td>${r.numberOfSamples}</td>

               </tr>
<tr>
                <td class="header">Signal</td>                    <td>${r.signal}</td>

</tr>
               <tr>
                <td class="header">Signal Present</td>                    <td>${r.signalPresent}</td>

               </tr>
               <tr>
                <td class="header">Signal Description</td>                    <td>${r.signalDescription}</td>

               </tr>
               <tr>
                <td class="header">Image Link</td>                    <td>${r.imageLink}</td>

               </tr>
               <tr>
                <td class="header">Percent cells in ROI with sginal</td>                    <td>${r.percentCellsInROIWithSginal}</td>

               </tr>
               <tr>
                <td class="header">ROI</td>                    <td>${r.roi}</td>

               </tr>
               <tr>
                <td class="header">ROI Coordinates</td>                    <td>${r.ROICoordinates}</td>

               </tr>







           </table>
        </div>
            <hr>
            <div class="row">
                <div class="col-lg-6" >
        <table id="samplesTable" class="table tablesorter" >
            <thead>
            <tr><th>Sample</th><th>Sex</th><th>Signal</th></tr>
            </thead>
            <tbody>
            <c:forEach items="${r.samples}" var="s">
            <tr>

                <td>${s.sampleId}</td> <td>${s.sex}</td> <td>${s.signal}</td>

            </tr>
            </c:forEach>
            </tbody>
        </table>
                </div>
                <div class="col-lg-6">
                    <table>
                        <tr>
                            <td style="padding:1px"><img src="/toolkit/common/ksnow/heart.png" width="100px" height="100px" alt=""/></td>
                            <td style="padding:1px"><img src="/toolkit/common/ksnow/heart_ch00.png" width="100px" height="100px" alt=""/></td>
                            <td style="padding:1px"><img src="/toolkit/common/ksnow/heart_ch01.png" width="100px" height="100px" alt=""/></td></tr>
                        <tr>
                            <td style="padding:1px"><img src="/toolkit/common/ksnow/liver.png" width="100px" height="100px" alt=""/></td>
                            <td style="padding:1px"><img src="/toolkit/common/ksnow/liver_ch00.png" width="100px" height="100px" alt=""/></td>
                            <td style="padding:1px"><img src="/toolkit/common/ksnow/liver_ch01.png" width="100px" height="100px" alt=""/></td></tr>
                    </table>
                </div>
            </div>

        </div>
        </c:forEach>
    </div>
</div>
<script>
function showTable() {
    var btn=$("#summaryResultsTableBtn");
    var btnTxt=btn.text();
    if(btnTxt==="Show Table"){
        btn.text("Hide Table");
    }else{
        btn.text("Show Table")

    }
    var _div=document.getElementById('summaryTable');
    if(_div.style.display === "none"){
    _div.style.display="block";
    }else{
    _div.style.display="none";
    }

    var _div=document.getElementById('summaryTable2');
    if(_div.style.display === "none"){
        _div.style.display="block";
    }else{
        _div.style.display="none";
    }

    var _div=document.getElementById('summaryTable3');
    if(_div.style.display === "none"){
        _div.style.display="block";
    }else{
        _div.style.display="none";
    }


}
</script>