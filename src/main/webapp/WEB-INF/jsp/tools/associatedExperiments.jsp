<%@ page import="edu.mcw.scge.datamodel.Study" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.datamodel.Experiment" %>
<%@ page import="edu.mcw.scge.web.StringForNull" %>
<h4 class="page-header" style="color:grey;">Associated SCGE Records</h4>

<div>
        <%
        List<Experiment> experiments = (List<Experiment>) request.getAttribute("experiments");
        Study study = (Study) request.getAttribute("study");
        //out.println(experiments.size());
    %>

    <table id="myTable" class="table tablesorter table-striped">
        <thead>
        <tr>
            <th>Study</th>
            <th>Name</th>
            <th>Editor</th>
            <th>Delivery System</th>
            <th>Model</th>
            <th>Guide</th>
            <th>Record ID</th>
        </tr>
        </thead>

        <% for (Experiment exp: experiments) { %>

        <tr>
            <!--td><input class="form" type="checkbox"></td-->

            <td><a href="/toolkit/data/experiments/search/<%=exp.getStudyId()%>"><%=StringForNull.parse(exp.getStudyName())%></a></td>
            <td><a href="/toolkit/data/studies/search/results/<%=exp.getExperimentId()%>"><%=StringForNull.parse(exp.getExperimentName())%></a></td>
            <td><a href="/toolkit/data/editors/editor?id=<%=exp.getEditorId()%>"><%=StringForNull.parse(exp.getEditorSymbol())%></a></td>
            <td><a href="/toolkit/data/delivery/system?id=<%=exp.getDeliverySystemId()%>"><%=StringForNull.parse(exp.getDeliverySystemType())%></a></td>
            <td><a href="/toolkit/data/models/model?id=<%=exp.getModelId()%>"><%=StringForNull.parse(exp.getModelName())%></a></td>
            <td><a href="/toolkit/data/guide/guide?id=<%=exp.getGuideId()%>"><%=StringForNull.parse(exp.getGuide())%></a></td>
            <td><%=exp.getExperimentId()%></td>
        </tr>
        <% } %>
    </table>