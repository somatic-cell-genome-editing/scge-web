<%@ page import="edu.mcw.scge.datamodel.Study" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.configuration.UserService" %>
<%@ page import="edu.mcw.scge.datamodel.Person" %>
<%@ page import="edu.mcw.scge.dao.implementation.GrantDao" %>
<%@ page import="edu.mcw.scge.dao.implementation.ExperimentDao" %>
<%@ page import="edu.mcw.scge.process.UI" %>
<%@ page import="edu.mcw.scge.datamodel.Experiment" %>
<%@ page import="java.util.*" %>
<%@ page import="edu.mcw.scge.datamodel.Grant" %>

<script>
    $(function() {
        $("#myTable-1").tablesorter({
            theme : 'blue'

        });

    });
</script>
<style>
    .caret::before {
        content: "\2BC6";
        color: black;
        display: inline-block;
        margin-right: 6px;
    }

    .caret-down::before {
        -ms-transform: rotate(270deg); /* IE 9 */
        -webkit-transform: rotate(270deg); /* Safari */'
    transform: rotate(270deg);
    }

</style>
<%
    Access localExpAccess = new Access();
    Person localExpPerson = new UserService().getCurrentUser(request.getSession());
    List<Study> studies = (List<Study>)request.getAttribute("studies");
    Map<Integer, List<Experiment>> projectNexperiments= (Map<Integer, List<Experiment>>) request.getAttribute("studyExperimentsMap");
    if (studies.size() > 0) {
    %>
<hr>
<h4 class="page-header" style="color:grey;">Projects & Experiments</h4> This <%=request.getAttribute("action")%> is being used

<%
   Access localStudyAccess = new Access();
   Person localStudyPerson = new UserService().getCurrentUser(request.getSession());
    GrantDao grantDao = new GrantDao();
%>
<table id="myTable-1" class="tablesorter">
    <thead>
    <tr><!--th>Select</th-->
        <!--th>Action</th-->
        <th>Project</th>
        <th>Initiative</th>
        <th>Contact PI</th>
        <th></th>
    </tr>
    </thead>
    <tbody>
    <%
        Set<Integer> groupIds=new HashSet<>();
        for (Study s: studies) {
            if(!groupIds.contains(s.getGroupId())){
                groupIds.add(s.getGroupId());
                List<Experiment> experiments = new ArrayList<>();
                if(projectNexperiments.get(s.getGroupId())!=null){
                    experiments.addAll(projectNexperiments.get(s.getGroupId()));
                }
                Grant grant=grantDao.getGrantByGroupId(s.getGroupId());

    %>
    <% if (localStudyAccess.hasStudyAccess(s,localStudyPerson)) { %>
        <tr>
            <td>

                <div>

                    <ul class="myUL">
                        <li><span class="caret"><a href="/toolkit/data/experiments/group/<%=s.getGroupId()%>"><%=grant.getGrantTitle()%></a></span>

                                <ul class="nested active" id="">
                                    <li style="text-decoration: none"><span class="caret">Experiments</span>
                                        <div class="card" style="background-color: #f0ffff;border:transparent">
                                        <ul class="nested active">
                                    <%
                                        for(Experiment experiment:experiments){
                                            if (localExpAccess.hasExperimentAccess(experiment.getExperimentId(),localExpPerson.getId())) {
                                    %>

                                    <li><span><a class="search-results-anchor" href="/toolkit/data/experiments/experiment/<%=experiment.getExperimentId()%>"><%=experiment.getName()%></a></span></li>
                                    <%}}%>

                                </ul> </div>

                                    </li>
                                </ul>

                        </li>
                    </ul>

                </div>
            </td>
            <td><%=UI.correctInitiative(grantDao.getGrantByGroupId(s.getGroupId()).getGrantInitiative())%></td>
            <td>
                <%for(Person pi:s.getMultiplePis()){%>
                <%=pi.getName()%>
               <% }%>


                <br>(<%=s.getLabName()%>)</td>
            <%
                String pattern = "MM/dd/yyyy";
                SimpleDateFormat format = new SimpleDateFormat(pattern);
            %>
            <!--td><%--=format.format(s.getSubmissionDate())--%></td-->
            <td>


                    <a href="<%=grant.getNihReporterLink()%>" target="_blank"><img src="/toolkit/images/nihReport.png" alt="NIH Report" > </a>

            </td>
        </tr>
    <% } }%>
    <% } %>
    </tbody>
</table>

<% } %>