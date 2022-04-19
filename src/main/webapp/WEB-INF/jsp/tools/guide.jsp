<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.web.UI" %>
<%@ page import="edu.mcw.scge.storage.ImageTypes" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="edu.mcw.scge.datamodel.*" %>
<%@ page import="com.nimbusds.jose.shaded.json.JSONValue" %>
<%@ page import="java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/29/2020
  Time: 4:25 PM
  To change this template use File | Settings | File Templates.
--%>
<link href="/toolkit/css/reportPage.css" rel="stylesheet" type="text/css"/>

<!--style>
    .table{
        border:1px solid white;
    }
   .table td, .table th{

        border: 1px solid white;
        padding: 0;
    }
    .sidenav {
        width: auto;
        position: fixed;
        z-index: 1;
        overflow-x: hidden;

    }

    .sidenav a {
        padding: 6px 8px 6px 16px;
        text-decoration: none;
        font-size: 15px;
        color: #2196F3;
        display: block;
    }

    .sidenav a:hover {
        color: #064579;
    }

</style-->

<% Guide g = (Guide) request.getAttribute("guide"); %>
<% List<Editor> relatedEditors = (List<Editor>) request.getAttribute("editors");
    List<OffTarget> offTargets = (List<OffTarget>) request.getAttribute("offTargets");
    List<OffTargetSite> offTargetSites = (List<OffTargetSite>) request.getAttribute("offTargetSites");

%>

<%
    Access access= new Access();
    Person p = access.getUser(request.getSession());

    if (access.isAdmin(p)) {
%>

<div align="right"><a href="/toolkit/data/guide/edit?id=<%=g.getGuide_id()%>"><button class="btn btn-primary">Edit</button></a></div>
<% } %>

<div class="col-md-2 sidenav bg-light">
    <input type="hidden" id="otherGuides" value="">

        <a href="#summary">Summary</a>

    <%if(g.getSpecies()!=null && g.getSpecies().equalsIgnoreCase("human")){%>
    <a href="#sequenceViewer">Sequence Viewer</a>
    <%}%>
    <% if(relatedEditors!=null && relatedEditors.size()>0){%>
    <a href="#editor">Related Editor</a>
    <%}%>
    <%if(!SFN.parse(g.getVectorId()).equals("")){%>
    <a href="#vector">Vector</a>
    <%}%>
    <%if(offTargets!=null && offTargets.size()>0){%>
        <a href="#offTargets">Off Targets</a>
    <%}%>
        <a href="#associatedStudies">Associated Studies</a>
        <a href="#associatedExperiments">Associated Experiments</a>


</div>
<main role="main" class="col-md-10 ml-sm-auto px-4"  >
    <div id="summary">
    <h4 class="page-header" style="color:grey;">Summary</h4>

<div class="d-flex bg-light" >

    <div class="p-2">
        <table class="table table-sm summary">
            <tr ><th class="header">Lab Id</th><td>&nbsp;<%=SFN.parse(g.getGrnaLabId())%></td></tr>
            <tr ><th class="header">Species</th><td>&nbsp;<%=SFN.parse(g.getSpecies())%></td></tr>
        <tr ><th  class="header" >Target Locus</th><td>&nbsp;<%=SFN.parse(g.getTargetLocus())%></td></tr>
            <tr ><th class="header">Target Sequence</th><td>&nbsp;<%=SFN.parse(g.getTargetSequence())%></td></tr>
            <tr ><th class="header" style=" white-space: nowrap;">Target Sequence&nbsp;+ PAM</th><td>&nbsp;<%=SFN.parse(g.getPam())%></td></tr>
            <tr ><th class="header">Assembly</th><td>&nbsp;<%=SFN.parse(g.getAssembly())%></td></tr>
            <tr ><th class="header" >Strand</th><td>&nbsp;<%=SFN.parse(g.getStrand())%></td></tr>
            <tr><th class="header">Guide Location:</th><td>&nbsp;<%=g.getChr()+":"+g.getStart()+".."+g.getStop()%></td></tr>
        <tr ><th >Description</th><td>&nbsp;<%=SFN.parse(g.getGuideDescription())%></td></tr>
                <tr ><th class="header" >Spacer Sequence</th><td>&nbsp;<%=SFN.parse(g.getSpacerSequence())%></td></tr>
                <tr ><th class="header">Spacer Length</th><td>&nbsp;<%=SFN.parse(g.getSpacerLength())%></td></tr>
                    <tr ><th class="header" >Guide Sequence</th><td>&nbsp;<%=SFN.parse(g.getFullGuide())%></td></tr>
                <tr ><th class="header" >Modifications</th><td>&nbsp;<%=SFN.parse(g.getModifications())%></td></tr>
                <tr ><th class="header">Repeat Sequence</th><td>&nbsp;<%=SFN.parse(g.getRepeatSequence())%></td></tr>
                <tr ><th class="header">Anti-Repeat Sequence</th><td>&nbsp;<%=SFN.parse(g.getAntiRepeatSequence())%></td></tr>
                <tr ><th class="header">Stemloop 1 Sequence</th><td>&nbsp;<%=SFN.parse(g.getStemloop1Sequence())%></td></tr>
                <tr ><th class="header">Stemloop 2 Sequence</th><td>&nbsp;<%=SFN.parse(g.getStemloop2Sequence())%></td></tr>
                <tr ><th class="header">Stemloop 3 Sequence</th><td>&nbsp;<%=SFN.parse(g.getStemloop3Sequence())%></td></tr>
            <tr ><th class="header">Source</th><td>&nbsp;<%=SFN.parse(g.getSource())%></td></tr>
            <tr ><th class="header">Full Guide Sequence</th><td>&nbsp;<%=SFN.parse(g.getFullGuide())%></td></tr>
            <tr ><th class="header">Guide Compatability</th><td>&nbsp;<%=SFN.parse(g.getGuideCompatibility())%></td></tr>
            <tr ><th class="header">Chromosome</th><td>&nbsp;<%=SFN.parse(g.getChr())%></td></tr>
            <tr ><th class="header">Start</th><td>&nbsp;<%=SFN.parse(g.getStart())%></td></tr>
            <tr ><th class="header">Stop</th><td>&nbsp;<%=SFN.parse(g.getStop())%></td></tr>
            <tr ><th class="header">Guide Format</th><td>&nbsp;<%=SFN.parse(g.getGuideFormat())%></td></tr>
            <tr ><th class="header">Has Standard Scaffold Sequence</th><td>&nbsp;<%=SFN.parse(g.getStandardScaffoldSequence())%></td></tr>
            <tr ><th class="header">Forward Primer</th><td>&nbsp;<%=SFN.parse(g.getForwardPrimer())%></td></tr>
            <tr ><th class="header">Reverse Primer</th><td>&nbsp;<%=SFN.parse(g.getReversePrimer())%></td></tr>
            <tr ><th class="header">Linker Sequence</th><td>&nbsp;<%=SFN.parse(g.getLinkerSequence())%></td></tr>
            <tr ><th class="header">Specificity Ratio</th><td>&nbsp;<%=SFN.parse(g.getSpecificityRatio())%></td></tr>

    </table>
    </div>
    <div class="ml-auto p-2" style="margin-right: 5%">

        <div class="card">
            <div class="card-header">Guide</div>
            <div class="card-body">
        <table >
            <tr ><th class="scge-details-label">SCGE ID</th><td>&nbsp;<%=g.getGuide_id()%></td></tr>

        </table>
            </div>
        </div>

    </div>

</div>
</div>
    <hr>


    <%
        long objectId = g.getGuide_id();
        String redirectURL = "/data/guide/system?id=" + objectId;
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

    <%if(g.getSpecies()!=null && g.getSpecies().equalsIgnoreCase("human")){

    %>
    <script>
        //  var range="13:32315508..32400268";

        //  var range="<%--=g.getChr().replace("chr", "")+":"+g.getStart()+".."+g.getStop()--%>";

        var chr='<%=g.getChr().replace("chr", "")%>';
        var start="<%=g.getStart()%>";
        var stop="<%=g.getStop()%>";
        var guideId="<%=g.getGuide_id()%>";
        var guide='<%=new Gson().toJson(g)%>';

    </script>
    <div id="sequenceViewer">
        <h4 class="page-header" style="color:grey;">Sequence Viewer</h4>
        <%@include file="sequenceViewer.jsp"%>

    </div>
    <hr>
    <%}%>

   <% if(relatedEditors!=null && relatedEditors.size()>0){%>
    <div id="editor">
    <h4 class="page-header" style="color:grey;">Related Editor</h4>
    <table class="table report-section" style="width:80%">
        <tr>
            <td style="width:50%" >
                <table class="table report-section" style="width:100%">
                    <tr>
                        <td style="width:50%"> Related Editors</td>
                        <td >
                                <%for (Editor relatedEditor: relatedEditors) { %>
                            <a href="/toolkit/data/editors/editor?id=<%=relatedEditor.getId()%>" ><%=UI.replacePhiSymbol(relatedEditor.getSymbol())%></a><br>
                            <% } %>
                        </td>
                    </tr>
                </table>
            </td>
            <td style="width:50%" ></td>
        </tr>
    </table>

    </div>
    <hr>
    <%}%>

    <%if(!SFN.parse(g.getVectorId()).equals("")){%>
    <div id="vector">
        <h4 class="page-header" style="color:grey;">Vector Details</h4>
        <table style="width:80%">
            <tr>
                <td style="width:50%">
                    <table class="table report-section" style="width:100%">

                        <tr ><td style="width:50%" >Ivt Construct Source</td><td><%=SFN.parse(g.getIvtConstructSource())%></td></tr>
                        <tr ><td style="width:50%" >Vector Id</td><td><%=SFN.parse(g.getVectorId())%></td></tr>
                        <tr ><td style="width:50%">Vector Name</td><td><%=SFN.parse(g.getVectorName())%></td></tr>
                        <tr ><td style="width:50%">Vector Description</td><td><%=SFN.parse(g.getVectorDescription())%></td></tr>
                        <tr ><td style="width:50%">Vector Type</td><td><%=SFN.parse(g.getVectorType())%></td></tr>

                        <tr ><td style="width:50%" >Annotated Map</td><td><%=SFN.parse(g.getAnnotatedMap())%></td></tr>

                    </table>
                </td>
                <td style="width:50%">
                    <%
                        objectId = g.getGuide_id();
                        redirectURL = "/data/guide/system?id=" + objectId;
                        bucket="vectorDetails1";
                    %>
                    <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
                    <% bucket="vectorDetails2"; %>
                    <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
                    <% bucket="vectorDetails3"; %>
                    <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
                    <% bucket="vectorDetails4"; %>
                    <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
                    <% bucket="vectorDetails5"; %>
                    <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
                </td>
            </tr>
        </table>


    </div>
    <hr>
    <%}%>
    <%HashMap<String,Integer> changeSeq = new HashMap<>();
        List<String> labels = new ArrayList<>();
        HashMap<String,Integer> guideSeq = new HashMap<>();
		boolean guideData = false;
        if(offTargets!=null && offTargets.size()>0){
            for(OffTargetSite o:offTargetSites){
                String label = o.getChromosome() +"-"+ o.getStart();
                if(o.getSeqType().equalsIgnoreCase("Change_seq")) {
                    changeSeq.put(label, o.getNoOfReads());
                    if(!guideSeq.containsKey(label))
                        guideSeq.put(label,null);
                } else {
					guideData = true;
                    guideSeq.put(label,o.getNoOfReads());
                    if(!changeSeq.containsKey(label))
                        changeSeq.put(label,null);
                }
                labels.add(label);
            }
    %>
    <%if(offTargets!=null && offTargets.size()>0){%>
    <div id="offTargets">
        <h4 class="page-header" style="color:grey;">Off Targets</h4>
        <table style="width:80%">
            <tr>
                <td style="width:50%">
                    <table class="table report-section" >
                        <tr><th style="width:50%">Detection Method</th><th style="width:50%">No. of sites detected</th></tr>
                        <%for (OffTarget offTarget: offTargets) { %>
                        <tr>
                            <td><%=offTarget.getDetectionMethod()%></td>
                            <td><%=offTarget.getNoOfSitesDetected()%><br>

                            </td>
                        </tr>
                        <% } %>
                    </table>

                </td>
                <td style="width:50%">
                    <%
                        objectId = g.getGuide_id();
                        redirectURL = "/data/guide/system?id=" + objectId;
                        bucket="offTargets1";
                    %>
                    <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
                    <% bucket="offTargets2"; %>
                    <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
                    <% bucket="offTargets3"; %>
                    <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
                    <% bucket="offTargets4"; %>
                    <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
                    <% bucket="offTargets5"; %>
                    <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
                </td>
            </tr>

        </table>
        <% } %>
        <h4 class="page-header" style="color:grey;">Specificity</h4>
        <table class="table" style="width:80%">
            <tr > <td style="width:50%">
                <table class="table report-section">
                    <tr><th style="width:50%">Specificity Ratio</th><td><%=SFN.parse(g.getSpecificityRatio())%></td></tr>
            </table>
            </td>
                <td style="width:50%"></td>
            </tr>

        </table>
    </div>
    <hr>

    <div class="chart-container" >
        <h4 class="page-header" style="color:grey;">Off Target Sites</h4>
        <canvas id="offTargetChart" style="position: relative; height:60vh; width:65vw;"></canvas>
    </div>
    <%}%>
    <br>

    <div id="associatedProtocols">
        <%@include file="/WEB-INF/jsp/tools/associatedProtocols.jsp"%>
    </div>
    <div id="associatedPublications">
        <%@include file="/WEB-INF/jsp/tools/publications/associatedPublications.jsp"%>
    </div>
    <div id="associatedStudies">
    <jsp:include page="associatedStudies.jsp"/>
    </div>
    <div id="associatedExperiments">
    <jsp:include page="associatedExperiments.jsp"/>
    </div>
</main>

<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.1/Chart.min.js"></script>

<script>
    var ctx = document.getElementById("offTargetChart");
    var myChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: <%= JSONValue.toJSONString(labels) %>,
            datasets: [
                {
                    label: 'ChangeSeq',
                    data: <%=changeSeq.values()%>,
                    yAxisID: 'changeSeq',
                    backgroundColor: 'rgba(6,69,121,1)',
                    borderColor: 'rgba(6,69,121,1)',
                    borderWidth: 1
                },
                {
                    label: 'GuideSeq',
                    data: <%=guideSeq.values()%>,
                    yAxisID: 'guideSeq',
                    backgroundColor: 'rgba(255,99,132,1)',
                    borderColor: 'rgba(255,99,132,1)',
                    borderWidth: 1
                }
            ]
        },
        options: {
            responsive: true,
            scales: {
                xAxes: [{
                    gridLines: {
                        offsetGridLines: true
                    },
                    scaleLabel: {
                        display: true,
                        labelString: 'Off target sites',
                        fontSize: 14,
                        fontStyle: 'bold',
                        fontFamily: 'Calibri'
                    },
                },
                ],
                yAxes: [{
                    id: 'changeSeq',
                    type: 'linear',
                    position: 'left',
                    ticks: {
                        beginAtZero: true
                    },
                    scaleLabel: {
                        display: true,
                        labelString: 'No of ChangeSeq Reads',
                        fontSize: 14,
                        fontStyle: 'bold',
                        fontFamily: 'Calibri'
                    },
                },
                    {
                        id: 'guideSeq',
                        type: 'linear',
                        position: 'right',
                        display: <%=guideData%>,
                        ticks: {
                            beginAtZero: true
                        },
                        scaleLabel: {
                            display: true,
                            labelString: 'No of GuideSeq Reads',
                            fontSize: 14,
                            fontStyle: 'bold',
                            fontFamily: 'Calibri'
                        },
                    }
                ]
            }
        }
    });
</script>