<%@ page import="edu.mcw.scge.datamodel.Study" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.datamodel.Experiment" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.datamodel.ExperimentRecord" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.datamodel.Person" %>
<%@ page import="edu.mcw.scge.configuration.UserService" %>
<%@ page import="edu.mcw.scge.web.UI" %>
<%@ page import="edu.mcw.scge.dao.implementation.StudyDao" %>
<h4 class="page-header" style="color:grey;">Associated SCGE Experiment Records</h4>

<div>
        <%
        List<ExperimentRecord> experiments = (List<ExperimentRecord>) request.getAttribute("experimentRecords");
        Study study = (Study) request.getAttribute("study");
        Access localStudyAccess = new Access();
        Person localStudyPerson = new UserService().getCurrentUser(request.getSession());
        StudyDao sdao = new StudyDao();

        //out.println(experiments.size());
    %>

     <% if (experiments.size() ==0) { %>
           0 Experiments Associated
     <%} else { %>

            <script>
                $(function() {
                    $("#associatedExperiments").tablesorter({
                        theme : 'blue'

                    });
                });
            </script>

            <table id="associatedExperiments" class="table tablesorter table-striped">
        <thead>
        <tr>
            <th>Study</th>
            <th>Name</th>
            <th>Editor</th>
            <th>Model</th>
            <th>Delivery System</th>
            <th>Vector</th>
            <th>Guide</th>
            <th>Record ID</th>
        </tr>
        </thead>

        <% for (ExperimentRecord exp: experiments) { %>
                <% Study s = sdao.getStudyById(exp.getStudyId()).get(0); %>
                <% if(localStudyAccess.hasStudyAccess(s,localStudyPerson)) { %>
                    <tr>
                        <!--td><input class="form" type="checkbox"></td-->

                        <td><a href="/toolkit/data/experiments/study/<%=exp.getStudyId()%>"><%=SFN.parse(s.getStudy())%></a></td>
                        <td><a href="/toolkit/data/experiments/experiment/<%=exp.getExperimentId()%>/record/<%=exp.getExperimentRecordId()%>"><%=SFN.parse(exp.getExperimentName())%></a></td>
                        <td><a href="/toolkit/data/editors/editor?id=<%=exp.getEditorId()%>"><%=UI.replacePhiSymbol(exp.getEditorSymbol())%></a></td>
                        <td><a href="/toolkit/data/models/model?id=<%=exp.getModelId()%>"><%=SFN.parse(exp.getModelName())%></a></td>
                        <td><a href="/toolkit/data/delivery/system?id=<%=exp.getDeliverySystemId()%>"><%=SFN.parse(exp.getDeliverySystemType())%></a></td>
                        <td></td>
                        <td><a href="/toolkit/data/guide/guide?id=<%=exp.getGuideId()%>"><%=SFN.parse(exp.getGuide())%></a></td>
                        <td><%=exp.getExperimentRecordId()%></td>
                    </tr>
                <% } %>
        <% } %>
    </table>

    <% } %>