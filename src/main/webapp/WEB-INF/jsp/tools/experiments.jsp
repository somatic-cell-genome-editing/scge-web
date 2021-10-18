<%@ page import="edu.mcw.scge.datamodel.Experiment" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.datamodel.Study" %>
<%@ page import="edu.mcw.scge.web.UI" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.datamodel.Person" %>
<%@ page import="edu.mcw.scge.dao.implementation.StudyDao" %>
<%@ page import="edu.mcw.scge.storage.ImageTypes" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.LinkedHashMap" %>

<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/29/2020
  Time: 4:25 PM
  To change this template use File | Settings | File Templates.
--%>

<link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" integrity="sha384-AYmEC3Yw5cVb3ZcuHtOA93w35dYTsvhLPVnYs9eStHfGJvOvKxVfELGroGkvsg+p" crossorigin="anonymous"/>
<style>
   #scge-details td{
       white-space: nowrap;
   }
    .desc {
        font-size:14px;
    }
   .scge-details-label{
       color:#2a6496;
         font-weight: bold;
   }
   table tr, table tr td{
       background-color: transparent;
   }
</style>
<script>
    $(function() {
        $("#myTable").tablesorter({
            theme : 'blue'

        });

    });
</script>
<div class="container">
<%
    Access access = new Access();
    StudyDao sdao = new StudyDao();
    Person p = access.getUser(request.getSession());
//    List<Experiment> experiments = (List<Experiment>) request.getAttribute("experiments");
    LinkedHashMap<Study, List<Experiment>> studyExperimentMap= (LinkedHashMap<Study, List<Experiment>>) request.getAttribute("studyExperimentMap");
    for(Map.Entry entry:studyExperimentMap.entrySet()) {
        Study study = ((Study) entry.getKey());
        List<Experiment> experiments= (List<Experiment>) entry.getValue();

%>
    <%if(study.getStudyId()==1026){%>
    <!--h4 class="page-header" style="color:grey;">Study Overview</h4>

    <div class="card" style="border:1px solid white">
        Specific aims: 1) to predict which unintended editing sites have biological effects on human T-cells by integrating large-scale genome-wide activity and epigenomic profiles with state-of-the-art deep learning models and 2) to develop a human primary T-cell platform to detect functional effects of genome editing by measuring clonal representation, off-target mutation frequencies, immunogenicity, or gene expression.

    </div>

    <hr-->
    <%}%>
<div>


    <div class="card" style="margin-top: 1%" >

        <% if (study != null) { %>
        <div class="card-header"><span class="scge-details-label">Submission SCGE-<%=study.getStudyId()%></span>&nbsp;Submission Date:<%=study.getSubmissionDate()%>&nbsp;Status: <%if(experiments.size()>0){%>
            <span style="color:green;font-weight: bold" >Processed</span>
            <%}else{%>
            <span style="color:red;font-weight: bold" >Received</span>
        <%}%>
        </div>
        <div class="card-body">
        <table width="95%">
        <tr>
            <td align="right">
                <button class="btn btn-primary btn-sm" type="button" onclick="javascript:location.href='/toolkit/download/<%=study.getStudyId()%>'"><i class='fas fa-download'></i>&nbsp;Download Submitted Data</button>
            </td>
        </tr>
        </table>

        <% } %>

        <%if(experiments.size()>0){%>
        <h4 class="page-header" style="color:grey;">Experiments</h4>

        <table class="table bg-light" >
        <thead>
        <tr>
        <th>Tier</th>

        <th>Name</th>
        <th>Type</th>
        <th>Description</th>
        <th>SCGE ID</th>
        </tr>
        </thead>

        <% for (Experiment exp: experiments) {
            System.out.println(exp.getStudyId());
            Study s = sdao.getStudyById(exp.getStudyId()).get(0);
        %>

        <% if (access.hasStudyAccess(s,p)) { %>

        <tr>
            <td width="10"><%=s.getTier()%></td>
            <td><a href="/toolkit/data/experiments/experiment/<%=exp.getExperimentId()%>"><%=exp.getName()%></a></td>
            <td style="white-space: nowrap"><%=exp.getType()%></td>
            <td><%=SFN.parse(exp.getDescription())%></td>
            <td><%=exp.getExperimentId()%></td>
        </tr>
        <% } %>
        <% } %>
        </table>
            <hr>
            <%}%>
            <%
                long objectId = study.getStudyId();
                String objectType= ImageTypes.STUDY;
                String redirectURL = "/data/experiments/study/" + objectId;
                String bucket="main";
            %>
            <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>


    </div>
    </div>
</div>
<%}%>
</div>