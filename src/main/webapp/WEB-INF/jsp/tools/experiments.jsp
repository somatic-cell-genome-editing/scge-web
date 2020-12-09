<%@ page import="edu.mcw.scge.datamodel.Experiment" %>
<%@ page import="java.util.List" %>

<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/29/2020
  Time: 4:25 PM
  To change this template use File | Settings | File Templates.
--%>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
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
        //out.println(experiments.size());
    %>

    <table id="myTable" class="table tablesorter table-striped">
    <thead>
    <tr>
    <th>Experiment_Id</th>
    <th>Name</th>
        <th>Editor</th>
        <th>Delivery System</th>
        <th>Model</th>
        <th>Guide</th>
    </tr>
    </thead>

        <% for (Experiment exp: experiments) { %>

    <tr>
        <!--td><input class="form" type="checkbox"></td-->
        <td><%=exp.getExperimentId()%></td>
        <td><%=exp.getExperimentName()%></td>
        <td><a href="/scgeweb/toolkit/editors/editor?id=<%=exp.getEditorId()%>"><%=exp.getEditorSymbol()%></a></td>
        <td><a href="/scgeweb/toolkit/delivery/system?id=<%=exp.getDeliverySystemId()%>"><%=exp.getDeliverySystemType()%></a></td>
        <td><a href="/scgeweb/toolkit/models/model?id=<%=exp.getModelId()%>"><%=exp.getModelName()%></a></td>
        <td><a href="/scgeweb/toolkit/guide/guide?id=<%=exp.getEditorId()%>"><%=exp.getGuide()%></a></td>
    </tr>
        <% } %>
</table>
<!--div style="float:right; width:8%;padding-bottom: 10px"><button class="btn btn-primary" >Compare</button></div-->
