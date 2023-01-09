<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/8/2021
  Time: 3:16 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.configuration.UserService" %>
<%@ page import="edu.mcw.scge.web.UI" %>
<%@ page import="edu.mcw.scge.dao.implementation.StudyDao" %>
<%@ page import="edu.mcw.scge.datamodel.*" %>
<%@ page import="java.util.HashMap" %>
<script>
    $(function() {
        $("#myTable-2").tablesorter({
            theme : 'blue'

        });
    });
</script>
<%
    List<Experiment> experiments = (List<Experiment>) request.getAttribute("experiments");
    if(experiments!=null && experiments.size()>0){
        %>

<hr>
<h4 class="page-header" style="color:grey;">Associated SCGE Experiments</h4>
<%

        //out.println(experiments.size());
%>
<table id="myTable-2" class="tablesorter">
    <thead>
    <tr>
        <th>Experiment Name</th>


    </tr>
    </thead>
    <tbody>
    <%
        for (Experiment exp: experiments) {%>
    <tr><td><a href="/toolkit/data/experiments/experiment/<%=exp.getExperimentId()%>"><%=exp.getName()%></a></td></tr>
    <% } %>
    </tbody>
</table>

<%}%>
