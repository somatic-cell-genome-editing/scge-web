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
<%
    Map<Long, List<Experiment>> validationExperimentsMap = new HashMap<>();
    if (request.getAttribute("validationExperimentsMap") != null)
        validationExperimentsMap = (Map<Long, List<Experiment>>) request.getAttribute("validationExperimentsMap");
    Map<Long, List<Experiment>> experimentsValidatedMap = new HashMap<>();
    if (request.getAttribute("experimentsValidatedMap") != null)
        experimentsValidatedMap = (Map<Long, List<Experiment>>) request.getAttribute("experimentsValidatedMap");
%>
<% if (experimentsValidatedMap != null && experimentsValidatedMap.size() > 0) {%>

<% if (experimentsValidatedMap.get(ex.getExperimentId()) != null) {
    List<Long> experimentIds=new ArrayList<>();
    for (Experiment experiment : experimentsValidatedMap.get(ex.getExperimentId())) {
        if(!experimentIds.contains(experiment.getExperimentId())){
            experimentIds.add(experiment.getExperimentId());
        }
    }
    String experimentIDS=new String();
    if(experimentIds.size()==1){
        experimentIDS= String.valueOf(experimentIds.get(0));
    }else{
        if(experimentIds.size()>0) {
            boolean first = true;
            for (long id : experimentIds) {
                if (first) {
                    experimentIDS += id;
                    first = false;
                } else
                    experimentIDS += "," + id;
            }
        }
    }%>
<div class="">
    <div class="">
    </div>
    <div class="">
        <span style="font-weight: bold">Original Experiment/s that are being validated:</span>

        <% for (Experiment experiment : experimentsValidatedMap.get(ex.getExperimentId())) {%>
<a href="/toolkit/data/experiments/experiment/<%=experiment.getExperimentId()%>"><%=experiment.getName()%></a>

<%//break;
 }%>
    </div>
</div>

<%}%>


<% } else {
    if (validationExperimentsMap != null && validationExperimentsMap.size() > 0) {%>
<% if (validationExperimentsMap.get(ex.getExperimentId()) != null) {
    List<Long> experimentIds=new ArrayList<>();

    for (Experiment experiment : validationExperimentsMap.get(ex.getExperimentId())) {
        if(!experimentIds.contains(experiment.getExperimentId())){
            experimentIds.add(experiment.getExperimentId());
        }
    }
    String experimentIDS=new String();
    if(experimentIds.size()==1){
        experimentIDS= String.valueOf(experimentIds.get(0));
    }else{
        boolean first=true;
        for(long id:experimentIds){
            if(first){
                experimentIDS+=id;
                first=false;
            }else
                experimentIDS+= ","+ id;
        }        }%>
<div class="">
    <div class="">
    </div>
    <div class="">
        <span style="font-weight: bold;">Validation:&nbsp;</span>

        <% for (Experiment experiment : validationExperimentsMap.get(ex.getExperimentId())) { %>
        <a href="/toolkit/data/experiments/experiment/<%=experiment.getExperimentId()%>"><%=experiment.getName()%></a>

<%//break;
    }%>
    </div>
</div>

<%} %>


<% }
}%>


