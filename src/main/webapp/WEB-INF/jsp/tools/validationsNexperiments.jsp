<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 6/2/2023
  Time: 11:52 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.util.stream.Collectors" %>
<%@ page import="edu.mcw.scge.datamodel.Experiment" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<% if (experimentsValidatedMap != null && experimentsValidatedMap.size() > 0) {%>

<% if (experimentsValidatedMap.get(ex.getExperimentId()) != null) {%>


    <div class="">
        <span style="font-weight: bold">Original Experiment/s that are being validated:</span>
        <% for (Experiment experiment : experimentsValidatedMap.get(ex.getExperimentId())) {%>
        <a href="/toolkit/data/experiments/experiment/<%=experiment.getExperimentId()%>"><%=experiment.getName()%></a>
        <%}%>
    </div>
<%}} else {
    if (validationExperimentsMap != null && validationExperimentsMap.size() > 0) {
         if (validationExperimentsMap.get(ex.getExperimentId()) != null) {
             List<Long> experimentIds=new ArrayList<>();
             for (Experiment experiment : validationExperimentsMap.get(ex.getExperimentId())) {
                 if(!experimentIds.contains(experiment.getExperimentId())){
                     experimentIds.add(experiment.getExperimentId());
                 }}%>


    <div class="">
        <span style="font-weight: bold;">Validation:&nbsp;</span>

        <% for (Experiment experiment : validationExperimentsMap.get(ex.getExperimentId())) { %>
        <a href="/toolkit/data/experiments/experiment/<%=experiment.getExperimentId()%>"><%=experiment.getName()%></a>

<%}%>
    </div>
<%}}} %>



