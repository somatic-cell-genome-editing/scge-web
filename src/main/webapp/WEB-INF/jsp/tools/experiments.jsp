<%@ page import="edu.mcw.scge.datamodel.Experiment" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.datamodel.Study" %>
<%@ page import="edu.mcw.scge.web.UI" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.datamodel.Person" %>
<%@ page import="edu.mcw.scge.dao.implementation.StudyDao" %>
<%@ page import="edu.mcw.scge.storage.ImageTypes" %>
<%@ page import="edu.mcw.scge.service.StringUtils" %>
<%@ page import="edu.mcw.scge.dao.implementation.GrantDao" %>
<%@ page import="edu.mcw.scge.dao.implementation.PersonDao" %>
<%@ page import="java.util.*" %>

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
        color: #2a6496;
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

        for (Map.Entry entry : studyExperimentMap.entrySet()) {
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


    <div class="container-fluid">

        <div class="container-fluid" style="margin-top: 1%;">

            <% if (study != null) { %>
            <div >
                <div>
                    <%
                        GrantDao grantDao = new GrantDao();
                        PersonDao personDao = new PersonDao();
                        if (study.getGroupId() == 1410 || study.getGroupId() == 1412) {// 1410-Baylor;1412-Jackson
                            if (study.getStudy().equalsIgnoreCase(grantDao.getGrantByGroupId(study.getGroupId()).getGrantTitle())) {%>
                    <%=study.getStudy()%>
                    <% } else {%>
                    <strong>VALIDATION&nbsp;-</strong>&nbsp;<%=study.getStudy()%>
                    <% }%>
                    <%}%>
                </div>
                <span class="scge-details-label">Submission - SCGE ID:<%=study.getStudyId()%></span>&nbsp;Submission
                Date:<%=study.getSubmissionDate()%>&nbsp;Status:
                <%if (experiments.size() > 0) {%>
                <span style="color:green;font-weight: bold">Processed</span>
                <%} else {%>
                <span style="color:red;font-weight: bold">Received</span>
                <%}%>
            </div>
            <hr style="border:2px solid grey">
            <div align="right"  >
                <table style="width: 30%">
                    <tr>
                        <td>
                            <%
                                try {
                                    if(access.isAdmin(p)){%>
                                    <div><a href="/toolkit/data/experiments/edit?studyId=<%=study.getStudyId()%>"><button class="btn btn-primary btn-sm">Create&nbsp;Experiment</button></a></div>
                                    <%}
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                            %>
                        </td>
                        <td>

                            <button class="btn btn-primary btn-sm" type="button"
                                    onclick="javascript:location.href='/toolkit/download/<%=study.getStudyId()%>'"><i
                                    class='fas fa-download'></i>&nbsp;View & Download Submitted files
                            </button>
                        </td>
                    </tr>
                </table>

                <% } %>

                <%if (experiments.size() > 0) {%>


                <table class="table bg-light">
                    <thead>
                    <tr>
                        <th>Tier</th>

                        <th>Experiment Name</th>
                        <th>Type</th>
                        <th>Description</th>
                        <!--<th>SCGE ID</th>-->
                    </tr>
                    </thead>

                    <%
                        for (Experiment exp : experiments) {
                            Study s = sdao.getStudyById(exp.getStudyId()).get(0);
                    %>

                    <% if (access.hasStudyAccess(s, p)) { %>

                    <tr>
                        <td width="10"><%=s.getTier()%>
                        </td>
                        <td><a href="/toolkit/data/experiments/experiment/<%=exp.getExperimentId()%>">
                            <%=exp.getName()%></a><br>
                            <%@include file="validations.jsp"%></td>
                        <td style="white-space: nowrap"><%=exp.getType()%>
                        </td>
                        <td><%=SFN.parse(exp.getDescription())%>
                        </td>
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