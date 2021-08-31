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
<h4 class="page-header" style="color:grey;">Associated SCGE Experiment Records</h4>
<%
        List<ExperimentRecord> experiments = (List<ExperimentRecord>) request.getAttribute("experimentRecords");
        Study study = (Study) request.getAttribute("study");
        Access localStudyAccess = new Access();
        Person localStudyPerson = new UserService().getCurrentUser(request.getSession());
        StudyDao sdao = new StudyDao();

        //out.println(experiments.size());
        %>
    <table id="myTable-2" class="tablesorter">
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
        <tbody>
        <% HashMap<Integer,List<Guide>> guideMap = (HashMap<Integer,List<Guide>>)request.getAttribute("guideMap");
        HashMap<Integer,List<Vector>> vectorMap = (HashMap<Integer,List<Vector>>)request.getAttribute("vectorMap");
            for (ExperimentRecord exp: experiments) {
                List<Guide> guideList = guideMap.get(exp.getExperimentRecordId());
                String guide = "";
                for(Guide g: guideList) {
                    System.out.println("here 3");
                    guide += "<a href=\"/toolkit/data/guide/system?id="+g.getGuide_id()+"\">"+SFN.parse(g.getGuide())+"</a>";
                    guide += ";\t";
                }
                List<Vector> vectorList = vectorMap.get(exp.getExperimentRecordId());
                String vector = "";
                for(Vector v: vectorList) {

                    vector += "<a href=\"/toolkit/data/vector/format?id="+v.getVectorId()+"\">"+SFN.parse(v.getName())+"</a>";
                    vector += ";\t";
                }
        %>
                <%
                    List<Study> studies = sdao.getStudyById(exp.getStudyId());

                    if (studies.size() > 0 ) {

                    Study s = studies.get(0);%>
                <% if(localStudyAccess.hasStudyAccess(s,localStudyPerson)) { %>
                    <tr>
                        <!--td><input class="form" type="checkbox"></td-->

                        <td><a href="/toolkit/data/experiments/group/<%=s.getGroupId()%>"><%=SFN.parse(s.getStudy())%></a></td>
                        <td><a href="/toolkit/data/experiments/experiment/<%=exp.getExperimentId()%>/record/<%=exp.getExperimentRecordId()%>"><%=SFN.parse(exp.getExperimentName())%></a></td>
                        <td><%=SFN.parse(exp.getTissueId())%></td>
                        <td><%=SFN.parse(exp.getCellType())%></td>
                        <td><a href="/toolkit/data/editors/editor?id=<%=exp.getEditorId()%>"><%=UI.replacePhiSymbol(exp.getEditorSymbol())%></a></td>
                        <td><a href="/toolkit/data/models/model?id=<%=exp.getModelId()%>"><%=SFN.parse(exp.getModelName())%></a></td>
                        <td><a href="/toolkit/data/delivery/system?id=<%=exp.getDeliverySystemId()%>"><%=SFN.parse(exp.getDeliverySystemType())%></a></td>
                        <td><%=vector%></td>
                        <td><%=guide%></td>
                        <td><%=exp.getExperimentRecordId()%></td>
                    </tr>
                <% } %>
                <% } %>
        <% } %>
        </tbody>
    </table>

