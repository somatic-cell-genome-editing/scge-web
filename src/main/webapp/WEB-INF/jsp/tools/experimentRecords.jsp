<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.datamodel.*" %>
<%@ page import="edu.mcw.scge.dao.implementation.ExperimentDao" %>
<%@ page import="edu.mcw.scge.dao.implementation.ExperimentResultDao" %>
<%@ page import="java.util.*" %>
<%@ page import="edu.mcw.scge.datamodel.Vector" %>


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
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.1/Chart.min.js"></script>

<% try {  %>
<div>
    <%

        ExperimentDao edao = new ExperimentDao();
        HashMap<Integer,ExperimentRecord> experimentRecordsMap = (HashMap<Integer,ExperimentRecord>) request.getAttribute("experimentRecordsMap");
        List<ExperimentRecord> experimentRecords = new ArrayList<>(experimentRecordsMap.values());
        HashMap<Integer,Double> resultMap = (HashMap<Integer, Double>) request.getAttribute("resultMap");
        Study study = (Study) request.getAttribute("study");
        Access access = new Access();
        Person p = access.getUser(request.getSession());
        Experiment ex = (Experiment) request.getAttribute("experiment");
        //out.println(experiments.size());

        HashMap<Integer,List<ExperimentResultDetail>> resultDetail= (HashMap<Integer, List<ExperimentResultDetail>>) request.getAttribute("resultDetail");
            HashMap<Integer,List<Guide>> guideMap = (HashMap<Integer,List<Guide>>)request.getAttribute("guideMap");
            HashMap<Integer,List<Vector>> vectorMap = (HashMap<Integer,List<Vector>>)request.getAttribute("vectorMap");
        ExperimentResultDao erdao = new ExperimentResultDao();
       List<String> conditionList = edao.getExperimentRecordConditionList(ex.getExperimentId());

        List<String> tissueList = edao.getExperimentRecordTissueList(ex.getExperimentId());
        List<String> editorList = edao.getExperimentRecordEditorList(ex.getExperimentId());
        List<String> modelList = edao.getExperimentRecordModelList(ex.getExperimentId());
        List<String> deliverySystemList = edao.getExperimentRecordDeliverySystemList(ex.getExperimentId());
        List<String> resultTypeList = erdao.getResTypeByExpId(ex.getExperimentId());
        List<String> unitList = erdao.getUnitsByExpId(ex.getExperimentId());
        List<String> guideList = edao.getExperimentRecordGuideList(ex.getExperimentId());
        List<String> vectorList = edao.getExperimentRecordVectorList(ex.getExperimentId());
        List<String> cellTypeList = edao.getExperimentRecordCellTypeList(ex.getExperimentId());
      List<String> tissues = (List<String>)request.getAttribute("tissues");
    List<String> conditions = (List<String>) request.getAttribute("conditions");
        String selectedTissue = (String)request.getAttribute("tissue");
        String selectedCellType = (String)request.getAttribute("cellType");
        String selectedResultType = (String)request.getAttribute("resultType");


    %>
        <div id="recordTableContent" style="position:relative; left:0px; top:00px;">
    <table>
        <tr>
            <td class="desc" style="font-weight:700;"><%=study.getStudy()%>:</td>
            <td>&nbsp;&nbsp;&nbsp;</td>
            <td class="desc"   style="font-weight:700;">PI:</td>
            <td class="desc" ><%=study.getPi()%></td>
            <td>&nbsp;&nbsp;&nbsp;</td>
            <td class="desc"  style="font-weight:700;">Submission Date:</td>
            <td class="desc" ><%=study.getSubmissionDate()%></td>
        </tr>
    </table>

        <% if (( tissueList.size() > 0 && selectedResultType == null )) { %>
            <hr>

                <%@include file="tissueMap.jsp"%>


         <% }  %>
            <% if (tissueList.size() == 0 || selectedResultType != null) { %>
        <hr>
            <%@include file="recordsTable.jsp"%>
            <% }  %>

        </div>
<% } catch (Exception e) {
        e.printStackTrace();
 }
%>

<!--div style="float:right; width:8%;padding-bottom: 10px"><button class="btn btn-primary" >Compare</button></div-->
