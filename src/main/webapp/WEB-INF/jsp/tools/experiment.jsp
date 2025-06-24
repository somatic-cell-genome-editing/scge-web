<%@ page import="edu.mcw.scge.process.UI" %>
<%@ page import="edu.mcw.scge.datamodel.*" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.storage.ImageTypes" %>
<%@ page import="java.util.*" %>
<%@ page import="edu.mcw.scge.datamodel.Vector" %>
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
        background-color: #ECECF9;
        padding:3px;
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

    Access access= new Access();
    Person p = access.getUser(request.getSession());


List<Delivery> dList = (List<Delivery>) request.getAttribute("deliveryList");
List<Editor> editorList = (List<Editor>) request.getAttribute("editorList");
List<Guide> guideList = (List<Guide>) request.getAttribute("guideList");
List<Vector> vectorList = (List<Vector>) request.getAttribute("vectorList");
List<ApplicationMethod> methods = (List<ApplicationMethod>) request.getAttribute("applicationMethod");
List<Antibody> antibodyList = (List<Antibody>) request.getAttribute("antibodyList");
Set<String> unitList = (Set<String>) request.getAttribute("unitList");
ExperimentRecord experimentRecord = (ExperimentRecord) request.getAttribute("experimentRecord");
Model model = (Model) request.getAttribute("model");
Experiment experiment = (Experiment) request.getAttribute("experiment");
List<ExperimentResultDetail> experimentResults = (List<ExperimentResultDetail>)request.getAttribute("experimentResults");
ExperimentResultDetail detail = experimentResults.get(0);

    java.util.Map<Long, List<Experiment>> validationExperimentsMap = new HashMap<>();
    if (request.getAttribute("validationExperimentsMap") != null)
        validationExperimentsMap = (Map<Long, List<Experiment>>) request.getAttribute("validationExperimentsMap");
    Map<Long, List<Experiment>> experimentsValidatedMap = new HashMap<>();
    if (request.getAttribute("experimentsValidatedMap") != null)
        experimentsValidatedMap = (Map<Long, List<Experiment>>) request.getAttribute("experimentsValidatedMap");
//req.setAttribute("reporterElements", reporterElements);
//req.setAttribute("experimentResults",experimentResults);
//req.setAttribute("results", results);
%>

<table width="100%" border="0">
    <tr>
        <td valign="top" >



<div>
        <table >
            <tbody>
            <tr><td width="200" class="header"><strong>Experiment</strong></td><td><%=experiment.getName()%></td></tr>
            <tr><td width="200" class="header"><strong>Experiment Condition</strong></td><td><%=experimentRecord.getExperimentRecordName()%></td></tr>
            <tr>
                <td class="header"><b>Assay&nbsp;Description:</b> </td><td><%=detail.getAssayDescription()%></td>
            </tr>
            <tr>
                <td class="header"><b>Tissue&nbsp;Measured:</b></td><td><%=SFN.parse(experimentRecord.getTissueTerm())%></td>
            </tr>
            <% if(experimentRecord.getCellTypeTerm()!=null && !experimentRecord.getCellTypeTerm().equals("") && !experimentRecord.getCellTypeTerm().equals("unspecified")){%>
            <tr>
                <td class="header"><b>Cell Type&nbsp;:</b></td><td><%=SFN.parse(experimentRecord.getCellTypeTerm())%></td>
            </tr>
            <%}%>
            <tr>
                <td class="header"><b>Measurement&nbsp;Type:</b></td><td><%=detail.getResultType()%></td>
            </tr>

            <tr><td width="200" class="header"><strong>Record ID</strong></td><td><%=experimentRecord.getExperimentRecordId()%></td></tr>

            <tr><td colspan="2"><hr></td></tr>

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
                <tr><td width="200" class="header"><strong>Editor</strong></td><td><a href="/toolkit/data/editors/editor?id=<%=e.getId()%>"><%=SFN.parse(e.getSymbol())%></a></td></tr>
                <tr><td  class="header"><strong>Delivery System</strong></td><td><a href="/toolkit/data/delivery/system?id=<%=d.getId()%>"><%=SFN.parse(d.getName())%></a></td></tr>
                <tr><td  class="header"><strong>Delivery&nbsp;System&nbsp;Subtype</strong></td><td><%=SFN.parse(d.getType())%></td></tr>
                <tr><td class="header"><strong>Guide</strong></td><td><%=guide%></td></tr>
            <tr><td width="150" class="header"><strong>Vector</strong></td><td><%=vector%></td></tr>
            <tr><td colspan="2"><hr></td></tr>


    <tr><td class="header"><strong>Model Species</strong></td><td><%=SFN.parse(model.getOrganism())%></td></tr>
        <tr><td class="header"><strong>Model Name</strong></td><td><a href="/toolkit/data/models/model?id=${model.modelId}"><%=SFN.parse(model.getName())%></a></td></tr>
            <tr><td colspan="2"><hr></td></tr>
            <%
                if(experimentRecord.getAge()!=null && !experimentRecord.getAge().equals("")){
            %>
            <tr><td class="header"><strong>Sample Age</strong></td><td><%=experimentRecord.getAge()%></td></tr>
            <%}%>
            <%
                if(experimentRecord.getSex()!=null && !experimentRecord.getSex().equals("")){
            %>
            <tr><td class="header"><strong>Sample Sex</strong></td><td><%=experimentRecord.getSex()%></td></tr>
            <%}%>
            <tr><td colspan="2"><hr></td></tr>


                <tr><td class="header"><strong>Application&nbsp;Method</strong></td><td><%=a.getApplicationType()%></td></tr>
                <tr><td class="header"><strong>Application&nbsp;Site</strong></td><td><%=SFN.parse(a.getSiteOfApplication())%></td></tr>
                <tr><td class="header"><strong>Dosage</strong></td><td><%=SFN.parse(a.getDosage())%></td></tr>
                <tr><td class="header"><strong>Injection&nbsp;Frequency</strong></td><td><%=SFN.parse(a.getInjectionFrequency())%></td></tr>
                <tr><td class="header"><strong>Injection&nbsp;Rate</strong></td><td><%=SFN.parse(a.getInjectionRate())%></td></tr>
                <tr><td class="header"><strong>Injection&nbsp;Volume</strong></td><td><%=SFN.parse(a.getInjectionVolume())%></td></tr>
                <tr><td class="header"><strong>Days&nbsp;post&nbsp;injection</strong></td><td><%=SFN.parse(a.getDaysPostInjection())%></td></tr>
                <tr><td class="header"><strong>Editor Format</strong></td><td><%=SFN.parse(a.getEditorFormat())%></td></tr>
                <tr><td class="header"><strong>Antidote Id</strong></td><td><%=SFN.parse(a.getAntidoteId())%></td></tr>
                <tr><td class="header"><strong>Antidote&nbsp;Description</strong></td><td><%=SFN.parse(a.getAntidoteDescription())%></td></tr>
                <tr><td colspan="2"><hr></td></tr>
<%
            for(Antibody antibody: antibodyList) { %>
            <tr><td class="header"><strong>Antibody&nbsp;RRID</strong></td><td><%=SFN.parse(antibody.getRrid())%></td></tr>
            <tr><td class="header"><strong>Antibody&nbsp;Other&nbsp;ID</strong></td><td><%=SFN.parse(antibody.getOtherId())%></td></tr>
             <tr><td class="header"><strong>Antibody&nbsp;Description</strong></td><td><%=SFN.parse(antibody.getDescription())%></td></tr>
            <tr><td colspan="2"><hr></td></tr>
            <%            }

%>

            <% //other experiment details
                java.util.Map<String,String> otherExpRecDetails = (java.util.Map<String,String>) request.getAttribute("otherExpRecDetails");
                if( otherExpRecDetails!=null && !otherExpRecDetails.isEmpty() ) {
                    for( java.util.Map.Entry<String,String> entry: otherExpRecDetails.entrySet() ) {
            %>
                   <tr><td class="header"><b><%=entry.getKey()%>:</b></td><td><%=entry.getValue()%></td></tr>
                 <% } %>
              <tr><td colspan="2"><hr></td></tr>
            <% } %>

            <tr>
                <td colspan="2" style="color:#4984B5;font-size:26px;">Measured Values</td>
            </tr>

            <tr>
                <td><b>Samples Size:</b> </td><td><%=detail.getNumberOfSamples()%></td>
            </tr>
            <tr><td>&nbsp;</td></tr>
            <tr>
                <td class="header">Replicate</td>
                <td class="header">Result (<%=detail.getResultType()%>)</td>
            </tr>
            <tr>
                 <%
                   for(String unit: unitList) {
               %>
                     <td class="header"><b>Measurement Units:</b></td>
                     <td class="header"><%=unit%></td>
                     </tr>

                    <% for (ExperimentResultDetail erd: experimentResults) { %>
            <tr>
                <% if(erd.getUnits().equalsIgnoreCase(unit)) {
                    if (erd.getReplicate() == 0) { %>

                <td>Mean</td>
                <% } else {%>
                <td><%=erd.getReplicate()%></td>

                <% } %>
                <td><%=UI.formatNumber(erd.getResult(),2)%>&nbsp</td>
            </tr>
            <% }} %>
               <% } %>
            </tr>




            </tbody>
        </table>
    </div>

        <td>&nbsp;&nbsp;</td>
        </td>
        <td valign="top">
            <%
                long objectId = experimentRecord.getExperimentRecordId();
                String redirectURL = "/data/experiments/experiment/" + experiment.getExperimentId() + "/record/" + objectId;
                String bucket="main1";
            %>
            <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
            <% bucket="main2"; %>
            <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
            <% bucket="main3"; %>
            <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
            <% bucket="main4"; %>
            <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
            <% bucket="main5"; %>
            <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>

        </td>
    </tr>
</table>

<%objectId = experimentRecord.getExperimentId();%>

<div id="associatedProtocols">
    <%@include file="/WEB-INF/jsp/tools/associatedProtocols.jsp"%>
</div>

<div id="associatedPublications">
    <%@include file="/WEB-INF/jsp/tools/publications/associatedPublications.jsp"%>
</div>

<% } catch (Exception e) {
        e.printStackTrace();

    }%>

