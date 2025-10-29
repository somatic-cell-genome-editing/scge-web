<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="edu.mcw.scge.datamodel.*" %>
<%@ page import="edu.mcw.scge.dao.implementation.ExperimentDao" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.dao.implementation.StudyDao" %><%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 7/6/2023
  Time: 4:14 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Access access = new Access();
    Person p = null;
    try {
        p = access.getUser(request.getSession());
    } catch (Exception e) {
        throw new RuntimeException(e);
    }
  String action=null;
  String description=null;
  boolean list=false;
  if(request.getAttribute("action")!=null)
          action=request.getAttribute("action").toString();
  if(action!=null && action.equalsIgnoreCase("Genome Editors")) {
    description = "Genome Editors are the tools used by researchers for genome editing, also called gene editing, to modify genes of living organisms to improve our understanding of gene function and develop ways to use it to treat genetic or acquired diseases. Below is information about the various genome editors, reporters, and other reagents used and developed by SCGE consortium projects.";
    list=true;
  }
  if(action!=null && action.equalsIgnoreCase("Model Systems")) {
    description = "Model Systems are cells and animals of particular species (e.g., mouse, pig, human cultured cells) that substitute for humans in research for developing and understanding safe approaches to genome editing. Below is information about cell and animal models used and developed by SCGE consortium projects.";
    list=true;
  }
  if(action!=null && action.equalsIgnoreCase("Guides")) {
    description = "Guide RNA is a piece of RNA that functions as a guide for targeting certain Genome Editor enzymes for gene and genome editing. This page contains information about guide RNAs used and developed by SCGE consortium projects. ";
    list=true;
  }
  if(action!=null && action.equalsIgnoreCase("Delivery Systems")) {
    description = "Delivery Systems include various technologies to deliver Genome Editors into cells and tissues of cells and animals, and one day humans, to treat genetic or acquired diseases. This page contains information about in vitro and in vivo delivery systems used and developed by SCGE consortium projects. ";
    list=true;
  }
  if(action!=null && action.equalsIgnoreCase("Vectors")) {
    description = "Vectors include DNA and engineered viruses harnessed by researchers to introduce Genome Editors into cells and tissues. This page contains information about vectors used and developed by SCGE consortium projects. ";
    list=true;
  }
  if(action!=null && action.equalsIgnoreCase("Protocols")) {
    description = "This page contains protocols deposited by SCGE consortium laboratories. ";
    list=true;
  }
  if(action!=null && action.equalsIgnoreCase("Publications")) {
    description = "List of publications associated or related to SCGE program funded projects. <a href='https://scge.mcw.edu/publications/' target='_blank' title='All publications'><i class=\"fa fa-external-link\" aria-hidden=\"true\"></i></a><br>Below is the list of publications tagged with SCGE toolkit data ..";
    list=true;
  }
  if(action!=null && action.contains("Experiment:")) {
    Experiment experiment = (Experiment) request.getAttribute("experiment");
    description = experiment.getDescription();
//    Study study = (Study) request.getAttribute("study");
    list=true;
  }
  if(action!=null && action.contains("Project:")) {
    //Experiment experiment = (Experiment) request.getAttribute("experiment");
    if(request.getAttribute("projectDescription")!=null)
    description = (String) request.getAttribute("projectDescription");


    list=true;
  }
  Study study = null;
  Publication publication=null;
  if(action!=null && (action.contains("Experiment:") || action.contains("Project:"))) {
    if (request.getAttribute("study") != null)
      study = (Study) request.getAttribute("study");

    if(request.getAttribute("publication")!=null){
      publication= (Publication) request.getAttribute("publication");
    }
  }
  String nihReporterLink= (String) request.getAttribute("nihReporterLink");
%>
<%if(action!=null ){%>
<div class="jumbotron page-header" style="background-color: #f7f8fa;padding-top: 20px;padding-bottom: 20px" >
  <h2><%=action%><%if(request.getParameter("initiative")!=null){%>&nbsp;of&nbsp;<%=request.getParameter("initiative")%><%}%></h2>
  <%if(!action.contains("Project:") && !action.contains("Experiment:") && description != null){%>
  <hr class="my-4">
  <%}%>
  <p class="lead">
    <%if(action.contains("Experiment:") || action.contains("Project:")){%>
<%--    <c:if test="${study!=null && ( study.multiplePis!=null)}">--%>
      <%
        if(study!=null && study.getMultiplePis()!=null){
      %>
      <small><strong>PI:</strong>  &nbsp;
<%--        <c:forEach items="${study.multiplePis}" var="pi">--%>
          <%
            for(Person pi:study.getMultiplePis()){
          %>
         <%=pi.getName()%>
          <%}%>
<%--        </c:forEach>--%>
<%--        <c:if test="${fn:length( publication.articleIds)>0}">--%>
          <%
            if(publication!=null && publication.getArticleIds()!=null && publication.getArticleIds().size()>0){
          %>
          <span style="color:orange; font-weight: bold">Publication IDs:</span>
<%--          <c:forEach items="${publication.articleIds}" var="id">--%>
            <%
              for(ArticleId id:publication.getArticleIds()){
                if(id.getUrl()==null || id.getUrl().equals("")){
            %>
          <%=id.getId()%>

            <%}else{%>
          <a href="<%=id.getUrl()%>"><%=id.getId()%></a>
                <%}}%>

        <%}%>

          <%
              if(nihReporterLink!=null){%>
          <a href="<%=nihReporterLink%>" target="_blank"><img src="/toolkit/images/nihReport.png" alt="NIH Report" > </a>
              <%}%>
      </small>
<%}%>

    <%}else{ if(description!=null){%>

    <%=description%>
    <%}
    if(action.equalsIgnoreCase("About SCGE Toolkit")){%>
    <%@include file="aboutUs.jsp"%>
    <%}
    }%>
  </p>
  <%if(list){%>
  <!--hr class="my-4"-->
  <%}%>
    <% try {
    if(access.hasStudyAccess(study, p)){
        if(action.contains("Experiment:")){%>
  <%


    //    Study study = (Study) request.getAttribute("study");
        List<ExperimentRecord> records= (List<ExperimentRecord>) request.getAttribute("records");
        Map<String, List<ExperimentRecord>> resultTypeRecords= (Map<String, List<ExperimentRecord>>) request.getAttribute("resultTypeRecords");
        Map<String, Integer> resultTypeColumnCount= (Map<String,Integer>) request.getAttribute("resultTypeColumnCount");
        Map<String, List<String>> tableColumns=(Map<String, List<String>>) request.getAttribute("tableColumns");
        //   HashMap<Long,ExperimentRecord> experimentRecordsMap = (HashMap<Long,ExperimentRecord>) request.getAttribute("experimentRecordsMap");
        ExperimentDao edao = new ExperimentDao();
        StudyDao studyDao =new StudyDao();

        List<Experiment> experiments=new ArrayList<>();
        if(study!=null ) {
            if (study.getGroupId() != 1410 && study.getGroupId() != 1412) { // 1410 and 1412 are SATC projects and each submission is a different group's validation.
                List<Study> studies = studyDao.getStudiesByGroupId(study.getGroupId());
                for (Study s : studies) {
                    if (access.hasStudyAccess(s, p)) {
                        List<Experiment> studyExperiments=edao.getExperimentsByStudy(study.getStudyId());
                        for(Experiment se:studyExperiments){
                            boolean exists=false;
                            for(Experiment e:experiments){
                                if(e.getExperimentId()==se.getExperimentId()){
                                    exists=true;
                                    break;
                                }
                            }
                            if(!exists){
                                experiments.add(se);
                            }
                        }

                    }
                }
            } else
                experiments = edao.getExperimentsByStudy(study.getStudyId());
        }
        Experiment ex = (Experiment) request.getAttribute("experiment");
        long objectId = ex.getExperimentId();
        String redirectURL = "/data/experiments/experiment/" + ex.getExperimentId();
      %>
      <%
        Map<Long, List<Experiment>> validationExperimentsMap = new HashMap<>();
        if (request.getAttribute("validationExperimentsMap") != null)
          validationExperimentsMap = (Map<Long, List<Experiment>>) request.getAttribute("validationExperimentsMap");
        Map<Long, List<Experiment>> experimentsValidatedMap = new HashMap<>();
        if (request.getAttribute("experimentsValidatedMap") != null)
          experimentsValidatedMap = (Map<Long, List<Experiment>>) request.getAttribute("experimentsValidatedMap");
%>

  <%@include file="experiment/summary.jsp"%>
  <%}else{ if(action.contains("Project:")){%>
  <!--p>This page contains list of <%--=action.toLowerCase()--%> that are being used in SCGE consortium projects  and <%--=action.toLowerCase()--%> that are newly developed by SCGE consortium projects. </p-->
  <%if(description!=null){%>
  <%=description%>
  <%}%>
  <%@include file="projectSummary.jsp"%>
  <% }}%>
    <%}} catch (Exception e) {
        throw new RuntimeException(e);
    } %>
</div>


<%}%>