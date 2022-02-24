<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 2/23/22
  Time: 4:38 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% if (experimentsValidatedMap != null && experimentsValidatedMap.size() > 0) {%>

    <% if (experimentsValidatedMap.get(exp.getExperimentId()) != null) {
        for (Experiment experiment : experimentsValidatedMap.get(exp.getExperimentId())) {%>

        <button class="btn btn-success btn-sm" onclick="window.location.href='/toolkit/data/experiments/study/<%=experiment.getStudyId()%>'">View Experiment Validated</button>

    <%}%>
    <!--button class="btn btn-success btn-sm">
        <a href="/toolkit/data/compare/delivery/<%=exp.getExperimentId()%>/<%=((List<Experiment>)experimentsValidatedMap.get(exp.getExperimentId())).get(0).getExperimentId()%>">Compare</a>
    </button-->

    <%}%>


<% } else {
    if (validationExperimentsMap != null && validationExperimentsMap.size() > 0) {%>


    <% if (validationExperimentsMap.get(exp.getExperimentId()) != null) {
        for (Experiment experiment : validationExperimentsMap.get(exp.getExperimentId())) { %>

        <button class="btn btn-success btn-sm" onclick="window.location.href='/toolkit/data/experiments/study/<%=experiment.getStudyId()%>'">View Validation</button>

    <%}%>
    <!--button class="btn btn-success btn-sm"><a href="/toolkit/data/compare/delivery/<%=exp.getExperimentId()%>/<%=((List<Experiment>)validationExperimentsMap.get(exp.getExperimentId())).get(0).getExperimentId()%>>">Compare</a>
    </button-->

    <%} %>


<% }
}%>

