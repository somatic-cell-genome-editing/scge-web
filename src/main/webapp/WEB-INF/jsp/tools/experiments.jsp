<%@ page import="edu.mcw.scge.datamodel.Experiment" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.web.StringForNull" %>
<%@ page import="edu.mcw.scge.datamodel.Study" %>

<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/29/2020
  Time: 4:25 PM
  To change this template use File | Settings | File Templates.
--%>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
<link href="/common/tableSorter/css/filter.formatter.css" rel="stylesheet" type="text/css"/>
<link href="/common/tableSorter/css/theme.jui.css" rel="stylesheet" type="text/css"/>
<link href="/common/tableSorter/css/theme.blue.css" rel="stylesheet" type="text/css"/>

<script src="/common/tableSorter/js/tablesorter.js"> </script>
<script src="/common/tableSorter/js/jquery.tablesorter.widgets.js"></script>
<link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" integrity="sha384-AYmEC3Yw5cVb3ZcuHtOA93w35dYTsvhLPVnYs9eStHfGJvOvKxVfELGroGkvsg+p" crossorigin="anonymous"/>
<style>
    td{
        font-size: 12px;
    }
</style>
<script>
    $(function() {
        $("#myTable").tablesorter({
            theme : 'blue'

        });
    });
</script>

<div>
    <%
        List<Experiment> experiments = (List<Experiment>) request.getAttribute("experiments");
        Study study = (Study) request.getAttribute("study");
        //out.println(experiments.size());
    %>

    <table>
        <tr>
            <td style="font-weight:700;"><%=study.getStudy()%>:</td>
            <td>&nbsp;&nbsp;&nbsp;</td>
            <td  style="font-weight:700;">PI:</td>
            <td><%=study.getPi()%></td>
            <td>&nbsp;&nbsp;&nbsp;</td>
            <td style="font-weight:700;">Submission Date:</td>
            <td><%=study.getSubmissionDate()%></td>
        </tr>
    </table>



    <table id="myTable" class="table tablesorter table-striped">
    <thead>
    <tr>
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

        <td><a href="/toolkit/data/studies/search/results/<%=exp.getExperimentId()%>"><%=StringForNull.parse(exp.getExperimentName())%></a></td>
        <td><a href="/toolkit/data/editors/editor?id=<%=exp.getEditorId()%>"><%=StringForNull.parse(exp.getEditorSymbol())%></a></td>
        <td><a href="/toolkit/data/delivery/system?id=<%=exp.getDeliverySystemId()%>"><%=StringForNull.parse(exp.getDeliverySystemType())%></a></td>
        <td><a href="/toolkit/data/models/model?id=<%=exp.getModelId()%>"><%=StringForNull.parse(exp.getModelName())%></a></td>
        <td><a href="/toolkit/data/guide/guide?id=<%=exp.getGuideId()%>"><%=StringForNull.parse(exp.getGuide())%></a></td>
        <td><%=exp.getExperimentId()%></td>
    </tr>
        <% } %>
</table>
<!--div style="float:right; width:8%;padding-bottom: 10px"><button class="btn btn-primary" >Compare</button></div-->
