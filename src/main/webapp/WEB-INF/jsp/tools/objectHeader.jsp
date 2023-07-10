<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="edu.mcw.scge.datamodel.*" %>
<%@ page import="edu.mcw.scge.dao.implementation.ExperimentDao" %>
<%@ page import="edu.mcw.scge.configuration.Access" %><%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 7/6/2023
  Time: 4:14 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String action=null;
  String description=null;
  boolean list=false;
  if(request.getAttribute("action")!=null)
          action=request.getAttribute("action").toString();
  if(action!=null && action.equalsIgnoreCase("Genome Editors")) {
    description = "Genome editing, also called gene editing, is an area of research seeking to modify genes of living organisms to improve our understanding of gene function and develop ways to use it to treat genetic or acquired diseases.";
    list=true;
  }
  if(action!=null && action.equalsIgnoreCase("Model Systems")) {
    description = "Model systems are particular species of animals that substitute for humans or other animals. Model Systems used in SCGE projects include animal models (Mouse, Pig, etc.,), cell lines, organoids";
    list=true;
  }
  if(action!=null && action.equalsIgnoreCase("Guides")) {
    description = "Guide RNA  is a piece of RNA that functions as a guide for targeting enzymes in gene editing.";
    list=true;
  }
  if(action!=null && action.equalsIgnoreCase("Delivery Systems")) {
    description = "Novel gene delivery systems.";
    list=true;
  }
  if(action!=null && action.equalsIgnoreCase("Vectors")) {
    description = "Vectors include adenovirus, adeno-associated virus, retrovirus, and lentivirus.";
    list=true;
  }
  if(action!=null && action.equalsIgnoreCase("Protocols")) {
    description = "The procedures or rules that are being used in somatic cell genome editing techniques.";
    list=true;
  }
  if(action!=null && action.contains("Experiment:")) {
    Experiment experiment = (Experiment) request.getAttribute("experiment");
    description = experiment.getDescription();
    Study study = (Study) request.getAttribute("study");
    list=true;
  }
%>

<div class="jumbotron page-header" style="background-color: #f7f8fa;padding-top: 20px;padding-bottom: 20px" >
  <h1 class="display-4"><%=action%><%if(request.getParameter("initiative")!=null){%>&nbsp;of&nbsp;<%=request.getParameter("initiative")%><%}%></h1>
  <p class="lead">
    <%if(action!=null && action.contains("Experiment:")){%>
    <c:if test="${study!=null && ( study.multiplePis!=null)}">
      <small><strong>PI:</strong>  &nbsp;
        <c:forEach items="${study.multiplePis}" var="pi">
          ${pi.name}&nbsp;
        </c:forEach>
        <c:if test="${fn:length( publication.articleIds)>0}">
          <span style="color:orange; font-weight: bold">Publication IDs:</span>
          <c:forEach items="${publication.articleIds}" var="id">

            <c:choose>
              <c:when test="${id.url=='' || id.url==null}">
                ${id.id};&nbsp;

              </c:when>
              <c:otherwise>
                <a href="${id.url}${id.id}">${id.id}</a>;&nbsp;

              </c:otherwise>
            </c:choose>
          </c:forEach>
        </c:if>
        <c:if test="${nihReporterLink!=null}">
          <a href="${nihReporterLink}" target="_blank"><img src="/toolkit/images/nihReport.png" alt="NIH Report" > </a>
        </c:if>
      </small>


    </c:if>
    <%}else{ if(description!=null){%>
    <%=description%>
    <%}
    if(action!=null && action.equalsIgnoreCase("About SCGE Toolkit")){%>
    <%@include file="aboutUs.jsp"%>
    <%}
    }%>
  </p>
  <%if(list){%>
  <hr class="my-4">
  <%}%>
  <%if(action!=null && action.contains("Experiment:")){%>
  <%
    Study study = (Study) request.getAttribute("study");
    List<ExperimentRecord> records= (List<ExperimentRecord>) request.getAttribute("records");
    Map<java.lang.String, List<ExperimentRecord>> resultTypeRecords= (Map<java.lang.String, List<ExperimentRecord>>) request.getAttribute("resultTypeRecords");
    Map<java.lang.String, Integer> resultTypeColumnCount= (Map<java.lang.String,Integer>) request.getAttribute("resultTypeColumnCount");
    Map<String, List<String>> tableColumns=(Map<String, List<String>>) request.getAttribute("tableColumns");
    //   HashMap<Long,ExperimentRecord> experimentRecordsMap = (HashMap<Long,ExperimentRecord>) request.getAttribute("experimentRecordsMap");
    ExperimentDao edao = new ExperimentDao();

    List<Experiment> experiments=new ArrayList<>();
    if(study.getGroupId()!=1410 && study.getGroupId()!=1412) // 1410 and 1412 are SATC projects and each submission is a different group's validation.
      experiments=   edao.getExperimentsByGroup(study.getGroupId());
    else
      experiments=edao.getExperimentsByStudy(study.getStudyId());
    Access access = new Access();
    Person p = access.getUser(request.getSession());
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
  <%}else{ if(list){%>
  <p>This page contains list of <%=action.toLowerCase()%> that are being used in SCGE consortium projects  and <%=action.toLowerCase()%> that are newly developed by SCGE consortium projects. </p>

  <% }}%>

</div>

