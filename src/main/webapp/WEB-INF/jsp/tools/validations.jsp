<%@ page import="java.util.stream.Collectors" %><%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 2/23/22
  Time: 4:38 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% if (experimentsValidatedMap != null && experimentsValidatedMap.size() > 0) {%>

    <% if (experimentsValidatedMap.get(exp.getExperimentId()) != null) {
        List<Long> experimentIds=new ArrayList<>();
        for (Experiment experiment : experimentsValidatedMap.get(exp.getExperimentId())) {
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
            }
        }
        for (Experiment experiment : experimentsValidatedMap.get(exp.getExperimentId())) {%>
        <form action="/toolkit/data/experiments/validations/study/<%=experiment.getStudyId()%>" >
        <input  type="hidden" name="experimentIds" value="<%=experimentIDS%>"/>
            <button style="margin-top:15px;"class="btn btn-success btn-sm" type="submit">View Original Experiment(s)</button>
        </form>
    <%break;}%>
    <!--button class="btn btn-success btn-sm">
        <a href="/toolkit/data/compare/delivery/<%=exp.getExperimentId()%>/<%=((List<Experiment>)experimentsValidatedMap.get(exp.getExperimentId())).get(0).getExperimentId()%>">Compare</a>
    </button-->

    <%}%>


<% } else {
    if (validationExperimentsMap != null && validationExperimentsMap.size() > 0) {%>
    <% if (validationExperimentsMap.get(exp.getExperimentId()) != null) {
        List<Long> experimentIds=new ArrayList<>();

        for (Experiment experiment : validationExperimentsMap.get(exp.getExperimentId())) {
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
            }        }

        for (Experiment experiment : validationExperimentsMap.get(exp.getExperimentId())) { %>
    <form action="/toolkit/data/experiments/validations/study/<%=experiment.getStudyId()%>" >
        <input type="hidden" name="experimentIds" value="<%=experimentIDS%>"/>

        <button class="btn btn-warning btn-sm" type="submit">View Validation of this Experiment</button>
    </form>
    <%break;}%>
    <!--button class="btn btn-success btn-sm"><a href="/toolkit/data/compare/delivery/<%=exp.getExperimentId()%>/<%=((List<Experiment>)validationExperimentsMap.get(exp.getExperimentId())).get(0).getExperimentId()%>>">Compare</a>
    </button-->

    <%} %>


<% }
}%>

