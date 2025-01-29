<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.process.UI" %>
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

<% Guide g = (Guide) request.getAttribute("guide"); %>
<% List<Editor> relatedEditors = (List<Editor>) request.getAttribute("editors");
    List<OffTarget> offTargets = (List<OffTarget>) request.getAttribute("offTargets");
    List<OffTargetSite> offTargetSites = (List<OffTargetSite>) request.getAttribute("offTargetSites");
    List<Guide> synonymousGuides = (List<Guide>) request.getAttribute("synonymousGuides");
    Access access= new Access();
    Person p = access.getUser(request.getSession());
    if (access.isAdmin(p) && !SCGEContext.isProduction()) {
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
    <a href="#editor">Related Editors</a>
    <%}%>
    <%if(!SFN.parse(g.getVectorId()).equals("")){%>
    <a href="#vector">Vector</a>
    <%}%>
    <%if(offTargets!=null && offTargets.size()>0){%>
    <a href="#offTargets">Off Targets</a>
    <%}%>
    <a href="#associatedStudies">Projects & Experiments</a>


</div>
<main role="main" class="col-md-10 ml-sm-auto px-4"  >
 <%@include file="summary.jsp"%>
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




    <% if (synonymousGuides.size()>0) { %>

    <div id="synonymousGuides">
        <h4 class="page-header" style="color:grey;">Other guides that target The same sequence</h4>
        <table class="table report-section" style="width:80%">
            <tr>
                <td style="width:50%" >
                    <table class="table report-section" style="width:100%">
                        <tr>
                            <td >
                                <% for (Guide tmpGuide: synonymousGuides) { %>
                                <li><a href="/toolkit/data/guide/system?id=<%=tmpGuide.getGuide_id()%>"><%=SFN.parse(tmpGuide.getGuide())%></a></li>
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
    <% } %>



    <% if(relatedEditors!=null && relatedEditors.size()>0){%>
    <div id="editor">
        <h4 class="page-header" style="color:grey;">Related Editors</h4>
        <table class="table report-section" style="width:80%">
            <tr>
                <td style="width:50%" >
                    <table class="table report-section" style="width:100%">
                        <tr>
                            <td >
                                <%for (Editor relatedEditor: relatedEditors) { %>
                                <li><a href="/toolkit/data/editors/editor?id=<%=relatedEditor.getId()%>" ><%=UI.replacePhiSymbol(relatedEditor.getSymbol())%></a></li><br>
                                <% } %>
                            </td>
                        </tr>
                    </table>
                </td>
                <td style="width:50%" ></td>
            </tr>
        </table>

    </div>
    <%}%>

    <%if(!SFN.parse(g.getVectorId()).equals("")){%>
    <hr>
    <div id="vector">
        <h4 class="page-header" style="color:grey;">Vector Details</h4>
        <table style="width:95%">
            <tr>
                <td style="width:60%">
                    <table class="table report-section" style="width:100%">

                        <tr ><td style="width:50%" >Ivt Construct Source</td><td><%=SFN.parse(g.getIvtConstructSource())%></td></tr>
                        <tr ><td style="width:50%" >Vector Id</td><td><%=SFN.parse(g.getVectorId())%></td></tr>
                        <tr ><td style="width:50%">Vector Name</td><td><%=SFN.parse(g.getVectorName())%></td></tr>
                        <tr ><td style="width:50%">Vector Description</td><td><%=SFN.parse(g.getVectorDescription())%></td></tr>
                        <tr ><td style="width:50%">Vector Type</td><td><%=SFN.parse(g.getVectorType())%></td></tr>

                        <tr ><td style="width:50%" >Annotated Map</td><td><%=SFN.parse(g.getAnnotatedMap())%></td></tr>

                    </table>
                </td>
                <td style="width:40%">
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

    <%}%>
    <%LinkedHashMap<String,Integer> changeSeq = new LinkedHashMap<>();
        List<String> labels = new ArrayList<>();
        LinkedHashMap<String,Integer> guideSeq = new LinkedHashMap<>();
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
        <table style="width:95%">
            <tr>
                <td style="width:60%">
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
                <td style="width:40%">
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
        <table class="table" style="width:95%">
            <tr > <td style="width:60%">
                <table class="table report-section">
                    <tr><th style="width:50%">Specificity Ratio</th><td><%=SFN.parse(g.getSpecificityRatio())%></td></tr>
                </table>
            </td>
                <td style="width:40%"></td>
            </tr>

        </table>
    </div>
    <hr>

    <div class="chart-container" >
        <h4 class="page-header" style="color:grey;">Off Target Sites</h4>
        <span style="font-weight: bold">Pan and Zoom Graph</span>
        <canvas id="offTargetChart" style="position: relative; height:60vh; width:65vw;"></canvas>
    </div>
    <button class="btn btn-sm btn-info" onclick="resetZoom()">Reset</button>
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

</main>
<%
    int maxChangeSeq = Integer.MIN_VALUE;
    for (Map.Entry<String, Integer> entry : changeSeq.entrySet()) {
        if (entry!=null && entry.getValue()!=null && entry.getValue() > maxChangeSeq) {
            maxChangeSeq = entry.getValue();
        }
    }
    int maxGuideSeq = Integer.MIN_VALUE;
    for (Map.Entry<String, Integer> entry : guideSeq.entrySet()) {
        if (entry!=null && entry.getValue()!=null && entry.getValue() > maxGuideSeq) {
            maxGuideSeq = entry.getValue();
        }
    }
%>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.1.2/dist/chart.umd.min.js"></script>
<script src="/toolkit/common/js/chartjs-plugin-zoom.js"></script>
<script src="/toolkit/common/js/hammer.min.js"></script>
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
                    yAxisID: 'y',
                    backgroundColor: 'rgba(6,69,121,1)',
                    borderColor: 'rgba(6,69,121,1)',
                    borderWidth: 1
                },
                {
                    label: 'GuideSeq',
                    data: <%=guideSeq.values()%>,
                    yAxisID: 'y2',
                    backgroundColor: 'rgba(255,99,132,1)',
                    borderColor: 'rgba(255,99,132,1)',
                    borderWidth: 1
                }
            ]
        },
        options: {
            responsive: true,
            scales: {
                xAxes: [
                    {
                    gridLines: {
                        offsetGridLines: true
                    },
                    title: {
                        display: true,
                        labelString: 'Off target sites',
                        fontSize: 14,
                        fontStyle: 'bold',
                        fontFamily: 'Calibri'
                    },
                },
                ],

                  y:  {
                    id: 'changeSeq',
                    type: 'linear',
                    position: 'left',
                    ticks: {
                        beginAtZero: true
                    },
                    title: {
                        display: true,
                        text: 'No of ChangeSeq Reads',
                        fontSize: 14,
                        fontStyle: 'bold',
                        fontFamily: 'Calibri'
                    },
                    min:0,
                      max:<%=maxChangeSeq%>
                },
                y2:    {
                        id: 'guideSeq',
                        type: 'linear',
                        position: 'right',
                        display: <%=guideData%>,
                        ticks: {
                            beginAtZero: true
                        },
                        title: {
                            display: true,
                            text: 'No of GuideSeq Reads',
                            fontSize: 14,
                            fontStyle: 'bold',
                            fontFamily: 'Calibri'
                        },
                    min:0,
                    max:<%=maxGuideSeq%>
                    }

            },
            plugins:{
                zoom: {
                    pan: {
                        enabled: true,
                        mode: 'x',
                        modifierKey: 'ctrl',
                    },
                    zoom: {
                        drag: {
                            enabled: true
                        },
                        mode: 'x',
                    },
                    limits: {
                        y: {min: 0, max: <%=maxChangeSeq%>},
                        y2: {min: 0, max: <%=maxGuideSeq%>}
                    }
                }
            }
        }
    });
    function resetZoom() {
        window.myChart.resetZoom();
    }
</script>