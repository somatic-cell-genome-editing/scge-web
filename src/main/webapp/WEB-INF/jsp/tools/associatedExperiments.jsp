<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.configuration.UserService" %>
<%@ page import="edu.mcw.scge.web.UI" %>
<%@ page import="edu.mcw.scge.dao.implementation.StudyDao" %>
<%@ page import="edu.mcw.scge.datamodel.*" %>
<%@ page import="java.util.HashMap" %>
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
            <th>Tissue</th>
            <th>Cell Type</th>
            <th>Editor</th>
            <th>Model</th>
            <th>Delivery System</th>
            <th>Vector</th>
            <th>Guide</th>
            <th>Record ID</th>
        </tr>
        </thead>

        <% HashMap<Integer,List<Guide>> guideMap = (HashMap<Integer,List<Guide>>)request.getAttribute("guideMap");
            for (ExperimentRecord exp: experiments) {
                List<Guide> guideList = guideMap.get(exp.getExperimentRecordId());
                String guide = "";
                for(Guide g: guideList) {
                    guide += "<a href=\"/toolkit/data/guide/system?id="+g.getGuide_id()+"\">"+SFN.parse(g.getGuide())+"</a>";
                    guide += ";\t";
                }%>
                <% Study s = sdao.getStudyById(exp.getStudyId()).get(0); %>
                <% if(localStudyAccess.hasStudyAccess(s,localStudyPerson)) { %>
                    <tr>
                        <!--td><input class="form" type="checkbox"></td-->

                        <td><a href="/toolkit/data/experiments/study/<%=exp.getStudyId()%>"><%=SFN.parse(s.getStudy())%></a></td>
                        <td><a href="/toolkit/data/experiments/experiment/<%=exp.getExperimentId()%>/record/<%=exp.getExperimentRecordId()%>"><%=SFN.parse(exp.getExperimentName())%></a></td>
                        <td><%=SFN.parse(exp.getTissueId())%></td>
                        <td><%=SFN.parse(exp.getCellType())%></td>
                        <td><a href="/toolkit/data/editors/editor?id=<%=exp.getEditorId()%>"><%=UI.replacePhiSymbol(exp.getEditorSymbol())%></a></td>
                        <td><a href="/toolkit/data/models/model?id=<%=exp.getModelId()%>"><%=SFN.parse(exp.getModelName())%></a></td>
                        <td><a href="/toolkit/data/delivery/system?id=<%=exp.getDeliverySystemId()%>"><%=SFN.parse(exp.getDeliverySystemType())%></a></td>
                        <td><a href="/toolkit/data/vector/format?id=<%=exp.getVectorId()%>"><%=SFN.parse(exp.getVector())%></a></td>
                        <td><%=guide%></td>
                        <td><%=exp.getExperimentRecordId()%></td>
                    </tr>
                <% } %>
        <% } %>
    </table>

    <% } %>