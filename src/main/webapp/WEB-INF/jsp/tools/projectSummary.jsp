<%@ page import="edu.mcw.scge.datamodel.Experiment" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.datamodel.Study" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %><%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 7/24/2023
  Time: 12:40 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  LinkedHashMap<Study, List<Experiment>> studyExperimentMap = (LinkedHashMap<Study, List<Experiment>>) request.getAttribute("studyExperimentMap");
  Map<Long, List<Experiment>> validationExperimentsMap = new HashMap<>();
  if (request.getAttribute("validationExperimentsMap") != null)
    validationExperimentsMap = (Map<Long, List<Experiment>>) request.getAttribute("validationExperimentsMap");
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
<hr class="my-4">
<div class="card" style="margin-bottom: 10px;background-color: transparent;border-color:transparent">

    <span style="font-weight: bold">Summary of data submissions:</span>
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
<%}%>