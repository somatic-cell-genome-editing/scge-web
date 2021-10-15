<%@ page import="edu.mcw.scge.web.UI" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.datamodel.*" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.storage.ImageTypes" %>
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

<% try { %>

<%
List<Delivery> dList = (List<Delivery>) request.getAttribute("deliveryList");
List<Editor> editorList = (List<Editor>) request.getAttribute("editorList");
List<Guide> guideList = (List<Guide>) request.getAttribute("guideList");
List<Vector> vectorList = (List<Vector>) request.getAttribute("vectorList");
List<ApplicationMethod> methods = (List<ApplicationMethod>) request.getAttribute("applicationMethod");
ExperimentRecord experimentRecord = (ExperimentRecord) request.getAttribute("experimentRecord");
Model model = (Model) request.getAttribute("model");
Experiment experiment = (Experiment) request.getAttribute("experiment");
List<ExperimentResultDetail> experimentResults = (List<ExperimentResultDetail>)request.getAttribute("experimentResults");
//req.setAttribute("reporterElements", reporterElements);
//req.setAttribute("experimentResults",experimentResults);
//req.setAttribute("results", results);
%>


<div>
    <div>
        <table style="width:80%">

            <tbody>
            <tr><td class="header"><strong>Experiment</strong></td><td><%=experiment.getName()%></td></tr>
            <tr><td class="header"><strong>Record ID</strong></td><td><%=experimentRecord.getExperimentRecordId()%></td></tr>

            </tbody>
        </table>

    </div>

    <hr>
    <div>
        <table style="width:80%">

            <%

                Delivery d =new Delivery();
                if(dList!=null && dList.size()>0)
                    d=dList.get(0);

                Editor e = new Editor();
                if(editorList != null && editorList.size() > 0)
                    e=editorList.get(0);

                String guide = "";

                boolean first = true;

                for(Guide g: guideList) {
                    if (first==true) {
                        first=false;
                    }else {
                        guide += ";\t";
                    }
                    guide += "<a href=\"/toolkit/data/guide/system?id="+g.getGuide_id()+"\">"+g.getGuide()+"</a>";

                }

                String vector = "";
                for(Vector v: vectorList) {
                    vector += "<a href=\"/toolkit/data/vector/format?id="+v.getVectorId()+"\">"+v.getName()+"</a>";
                    vector += ";\t";
                }
                ApplicationMethod a = new ApplicationMethod();
                if(methods !=null && methods.size() > 0)
                    a = methods.get(0);
            %>
                <tr><td class="header"><strong>Editor</strong></td><td><a href="/toolkit/data/editors/editor?id=<%=e.getId()%>"><%=SFN.parse(e.getSymbol())%></a></td></tr>
                <tr><td class="header"><strong>Delivery System</strong></td><td><a href="/toolkit/data/delivery/system?id=<%=d.getId()%>"><%=SFN.parse(d.getName())%></a></td></tr>
                <tr><td class="header"><strong>Delivery System Subtype</strong></td><td><%=SFN.parse(d.getType())%></td></tr>
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
    <tr><td class="header"><strong>Model Species</strong></td><td><%=model.getOrganism()%></td></tr>
        <tr><td class="header"><strong>Model Name</strong></td><td><a href="/toolkit/data/models/model?id=${model.modelId}"><%=model.getName()%></a></td></tr>
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


    <div class="row">
        <div class="col-lg-3">
            <table width="600"><tr><td><h3>Experimental Record Detail</h3></td><td align="right"></td></tr></table>
        </div>
    </div>
    <br>

        <%ExperimentResultDetail detail = experimentResults.get(0);%>
    <table align="center" width="800">
        <tr>
            <td><b>Number of Samples:</b> </td><td>&nbsp;&nbsp;</td><td><%=detail.getNumberOfSamples()%></td>
        </tr>
        <tr>
            <td><b>Assay Description:</b> </td><td>&nbsp;&nbsp;</td><td><%=detail.getAssayDescription()%></td>
        </tr>
        <tr>
            <td><b>Tissue Measured:</b></td><td>&nbsp;&nbsp;</td><td><%=SFN.parse(experimentRecord.getTissueTerm())%></td>
        </tr>
        <tr>
            <td><b>Measurement Type:</b></td><td>&nbsp;&nbsp;</td><td><%=detail.getResultType()%></td>
        </tr>
        <tr>
            <td><b>Measurment Units:</b></td><td>&nbsp;&nbsp;</td><td><%=detail.getUnits()%></td>
        </tr>
    </table>

        <%
    long objectId = experimentRecord.getExperimentRecordId();
    String redirectURL = "/toolkit/data/experiments/experiment/" + experiment.getExperimentId() + "/record/" + objectId;
    String bucket="main";
%>
    <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>

    <br>
        <table width="800">
            <thead><tr>
                <th>Replicate</th>
                <th>Result</th>
            </tr></thead>
            <tbody>
              <% for (ExperimentResultDetail erd: experimentResults) { %>
                <tr>
                    <% if (erd.getReplicate() == 0) { %>

                    <td>Mean</td>
                    <% } else {%>
                    <td><%=erd.getReplicate()%></td>

                    <% } %>
                    <td><%=UI.formatNumber(erd.getResult(),2)%></td>
                </tr>
                <% } %>
            </tbody>
        </table>


    <% } catch (Exception e) {
        e.printStackTrace();

    }%>

