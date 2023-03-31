<%@ page import="edu.mcw.scge.datamodel.Experiment" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.datamodel.Study" %>
<%@ page import="edu.mcw.scge.process.UI" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.datamodel.Person" %>
<%@ page import="edu.mcw.scge.dao.implementation.StudyDao" %>
<%@ page import="edu.mcw.scge.storage.ImageTypes" %>
<%@ page import="edu.mcw.scge.service.StringUtils" %>
<%@ page import="edu.mcw.scge.dao.implementation.GrantDao" %>
<%@ page import="edu.mcw.scge.dao.implementation.PersonDao" %>
<%@ page import="java.util.*" %>
<%@ page import="edu.mcw.scge.web.SCGEContext" %>

<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/29/2020
  Time: 4:25 PM
  To change this template use File | Settings | File Templates.
--%>

<link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css"
      integrity="sha384-AYmEC3Yw5cVb3ZcuHtOA93w35dYTsvhLPVnYs9eStHfGJvOvKxVfELGroGkvsg+p" crossorigin="anonymous"/>
<style>
    #scge-details td {
        white-space: nowrap;
    }

    .desc {
        font-size: 14px;
    }

    .scge-details-label {
        color: black;
        font-weight: bold;
    }

    table tr, table tr td {
        background-color: transparent;
    }

</style>
<script>
    $(function () {
        $("#myTable").tablesorter({
            theme: 'blue'

        });

    });
</script>
<div class="container-fluid">
    <%
        ImageDao idao = new ImageDao();
        int rowCount = 1;
        Access access = new Access();
        StudyDao sdao = new StudyDao();
        Person p = access.getUser(request.getSession());
//    List<Experiment> experiments = (List<Experiment>) request.getAttribute("experiments");
        LinkedHashMap<Study, List<Experiment>> studyExperimentMap = (LinkedHashMap<Study, List<Experiment>>) request.getAttribute("studyExperimentMap");
        Map<Long, List<Experiment>> validationExperimentsMap = new HashMap<>();
        if (request.getAttribute("validationExperimentsMap") != null)
            validationExperimentsMap = (Map<Long, List<Experiment>>) request.getAttribute("validationExperimentsMap");
        Map<Long, List<Experiment>> experimentsValidatedMap = new HashMap<>();
        if (request.getAttribute("experimentsValidatedMap") != null)
            experimentsValidatedMap = (Map<Long, List<Experiment>>) request.getAttribute("experimentsValidatedMap");
        boolean isProcessed=false;
        int totalExperiments=0;
        for (Map.Entry entry : studyExperimentMap.entrySet()) {
            List<Experiment> experiments = (List<Experiment>) entry.getValue();
            if(experiments.size()>0){
                isProcessed=true;
                totalExperiments+=experiments.size();
            }
        }
        if(isProcessed){
%>

    <div class="card" style="margin-bottom: 10px">
        <div class="card-header">
            <span style="font-weight: bold">Summary of data submissions:</span>

        </div>
        <div class="card-body">
    <ul>
    <%
        for (Map.Entry entry : studyExperimentMap.entrySet()) {
            Study study = ((Study) entry.getKey());
            String validation="";
            if(study.getIsValidationStudy()==1)
                validation+="validation";
            if(study.getIsValidationStudy()!=1 && (study.getGroupId()==1410 || study.getGroupId()==1412))
                validation+="new model";
            List<Experiment> experiments = (List<Experiment>) entry.getValue();
            if(experiments.size()>0){
            %>

        <li>
           Data for <%=experiments.size()%>&nbsp;<%=validation%> experiments were submitted on <%=study.getSubmissionDate()%>&nbsp;<span style="font-weight: bold"><a href="#<%=study.getStudyId()%>">SCGE ID:<%=study.getStudyId()%></a></span>
        </li>

       <% }} if(validationExperimentsMap.size()>0){%>
        <li><%=validationExperimentsMap.size()%> of <%=totalExperiments%> experiments have been validated</li>
        <%}%>
    </ul>
        </div>

    </div>
    <%}%>
    <div class="card-header" style="margin-bottom: 10px"><span style="font-weight: bold">Submissions Details:</span></div>
    <%    for (Map.Entry entry : studyExperimentMap.entrySet()) {
            Study study = ((Study) entry.getKey());
            List<Experiment> experiments = (List<Experiment>) entry.getValue();

    %>
    <%if (study.getStudyId() == 1026) {%>
    <!--h4 class="page-header" style="color:grey;">Study Overview</h4>

    <div class="card" style="border:1px solid white">
        Specific aims: 1) to predict which unintended editing sites have biological effects on human T-cells by integrating large-scale genome-wide activity and epigenomic profiles with state-of-the-art deep learning models and 2) to develop a human primary T-cell platform to detect functional effects of genome editing by measuring clonal representation, off-target mutation frequencies, immunogenicity, or gene expression.

    </div>

    <hr-->
    <%}%>
    <div id="imageViewer"
         style="visibility:hidden; border: 1px double black; width:704px;position:fixed;top:15px; left:15px;z-index:1000;background-color:white;"></div>


    <div class="container-fluid bg-light shadow p-3 mb-5 bg-white rounded" id="<%=study.getStudyId()%>">

        <div class="container-fluid" style="margin-top: 1%;">

            <% if (study != null) { %>

            <div >
                <table width="95%">
                    <tr>
                        <td>
                            <div >
                                <div>
                                    <%
                                        if(study.getGroupId()==1410 || study.getGroupId()==1412){
                                        if (study.getIsValidationStudy()!=1)// 1410-Baylor;1412-Jackson
                                             {%>
                                    <strong>NEW MODEL DEVELOPMENT&nbsp;-</strong>&nbsp;<%=study.getStudy()%>
                                    <% } else {%>
                                    <strong>VALIDATION&nbsp;-</strong>&nbsp;<%=study.getStudy()%>
                                    <% }
                                        }else{%>
                                    <%=study.getStudy()%>
                                  <%}%>
                                </div>
                                <span  class="scge-details-label">SCGE ID:<%=study.getStudyId()%></span>&nbsp;-&nbsp;Submission
                                Date:&nbsp;<%=study.getSubmissionDate()%>&nbsp;
                            </div>

                        </td>
                        <td>
                            <%
                                try {
                                    if(access.isAdmin(p) && !SCGEContext.isProduction()){%>
                                    <div><a href="/toolkit/data/experiments/edit?studyId=<%=study.getStudyId()%>"><button style="margin-bottom:15px;" class="btn btn-primary btn-sm">Create&nbsp;Experiment</button></a></div>
                                    <%}
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                            %>
                        </td>
                        <td>

                            <button style="margin-bottom:15px;" class="btn btn-primary btn-sm" type="button"
                                    onclick="javascript:location.href='/toolkit/download/<%=study.getStudyId()%>'"><i
                                    class='fas fa-download'></i>&nbsp;Download Submitted files
                            </button>
                        </td>
                    </tr>
                </table>

                <% } %>

                <%if (experiments.size() > 0) {%>


                <table class="table bg-light">
                    <thead>
                    <tr>
                        <!--<th>Tier</th>-->

                        <th style="width: 300px">Experiment Name</th>
                        <th style="width: 100px;">Type</th>
                        <th style="width: 500px">Description</th>
                        <!--th class="project-page-details-table"></th-->
                        <!--<th>SCGE ID</th>-->
                    </tr>
                    </thead>

                    <%
                        for (Experiment exp : experiments) {
                            Study s = sdao.getStudyById(exp.getStudyId()).get(0);
                    %>

                    <% if (access.hasStudyAccess(s, p)) { %>

                    <tr>
                        <!--<td width="10"><%=s.getTier()%>-->

                        <td class="project-page-details-table experiment-name"><a href="/toolkit/data/experiments/experiment/<%=exp.getExperimentId()%>">
                            <%=exp.getName()%></a><br>
                            <%@include file="validations.jsp"%>
                        </td>
                        <td class="project-page-details-table experiment-type" style="white-space: nowrap"><%=exp.getType()%>
                        </td>
                        <td class="project-page-details-table experiment-description"><%=SFN.parse(exp.getDescription())%></td>
                        <!--<td><%=exp.getExperimentId()%></td>-->



                    </tr>
                    <%
                        List<Image> images = idao.getImage(exp.getExperimentId());
                        if (images.size() > 0) {
                    %>

                    <tr style="border-top: 1px red">
                        <td colspan="5" align="right" style="border-top:2px blueviolet">
                            <table>
                                <tr>
                                    <% for (Image image : images) { %>
                                    <td><a href="/toolkit/data/experiments/experiment/<%=exp.getExperimentId()%>"><img
                                            onmouseover="imageMouseOver(this,'<%=StringUtils.encode(image.getLegend())%>', '<%=image.getTitle()%>')"
                                            onmouseout="imageMouseOut(this)" id="img<%=rowCount%>"
                                            src="<%=image.getPath()%>" height="1" width="1"></a></td>

                                    <% rowCount++;
                                    }
                                    %>
                                </tr>
                            </table>
                        </td>

                    </tr>
                    <%
                        }
                    %>

                    <% } %>
                    <% } %>
                </table>


                <%}%>
                <%
                    long objectId = study.getStudyId();
                    String redirectURL = "/data/experiments/study/" + objectId;
                    String bucket = "main1";
                %>
                <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp" %>
                <% bucket = "main2"; %>
                <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp" %>
                <% bucket = "main3"; %>
                <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp" %>
                <% bucket = "main4"; %>
                <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp" %>
                <% bucket = "main5"; %>
                <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp" %>
                <% bucket = "main6"; %>
                <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp" %>


            </div>
        </div>
    </div>

    <%}%>
</div>

<script>
    function resizeImages() {
        var count = 1;
        while (true) {
            var img = document.getElementById("img" + count);
            if (img) {
                //get the height to 60
                var goal = 75;
                var height = img.naturalHeight;
                var diff = height - goal;
                var percentDiff = 1 - (diff / height);
                img.height = goal;
                img.width = parseInt(img.naturalWidth * percentDiff);

            } else {
                break;
            }
            count++;
        }

    }

    function imageMouseOver(img, legend, title) {
        var sourceImage = document.createElement('img'),
            imgContainer = document.getElementById("imageViewer");
        sourceImage.src = img.src;
        //resizeThis(sourceImage);

        if (title != "") {
            imgContainer.innerHTML = "<div style='padding:8px;font-weight:700;font-size:18px;'>" + title + "</div>"
        }

        imgContainer.appendChild(sourceImage);
        //imgContainer.style.width=img.naturalWidth;

        if (legend != "") {
            imgContainer.innerHTML = imgContainer.innerHTML + "<div style='border:1px solid black;padding:8px;'>" + decodeHtml(legend) + "</div>";
        }
        imgContainer.style.visibility = "visible";
    }

    function resizeThis(img) {
        if (img) {
            //get the height to 60
            var goal = 700;
            var width = img.naturalWidth;

            if (width < goal) {
                return;
            }

            var diff = width - goal;
            var percentDiff = 1 - (diff / width);
            img.width = goal;
            img.height = parseInt(img.naturalHeight * percentDiff);

        }
    }

    function imageMouseOut(img) {
        document.getElementById("imageViewer").innerHTML = "";
        document.getElementById("imageViewer").style.visibility = "hidden";
    }

    function decodeHtml(html) {
        var txt = document.createElement("textarea");
        txt.innerHTML = html;
        return txt.value;
    }

    setTimeout("resizeImages()", 500);

</script>