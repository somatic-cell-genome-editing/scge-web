<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/8/2021
  Time: 3:16 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.configuration.UserService" %>

<%@ page import="edu.mcw.scge.datamodel.*" %>
<%@ page import="edu.mcw.scge.dao.implementation.ExperimentDao" %>

<script>
    $(function() {
        $("#myTable-2").tablesorter({
            theme : 'blue'

        });
    });
</script>


<%
    Access localExpAccess = new Access();
    Person localExpPerson = new UserService().getCurrentUser(request.getSession());

List<Experiment> experiments = (List<Experiment>) request.getAttribute("associatedExperiments");
    if(experiments!=null && experiments.size()>0){

        //out.println(experiments.size());
%>
<hr>
<h4 class="page-header" style="color:grey;">Associated SCGE Experiments</h4>
<table id="myTable-2" class="tablesorter">
    <thead>
    <tr>
        <th>Experiment Name</th>


    </tr>
    </thead>
    <tbody>
    <%
        ExperimentDao experimentDao=new ExperimentDao();
        for (Experiment exp: experiments) {
            if (localExpAccess.hasExperimentAccess(exp.getExperimentId(),localExpPerson.getId())) {
                List<ExperimentRecord> records=experimentDao.getExperimentRecords(exp.getExperimentId());
                System.out.println("ReCORDS SIZE:"+ records.size());
    %>

                <tr><td>
                    <%
                        if(records!=null && records.size()>0){
                    %>
                    <a href="/toolkit/data/experiments/experiment/<%=exp.getExperimentId()%>"><%=exp.getName()%></a>
                    <%}else{%>
                    <%=exp.getName()%><%}%>
                </td></tr>
    <% }}%>
    </tbody>
</table>

<%}%>
