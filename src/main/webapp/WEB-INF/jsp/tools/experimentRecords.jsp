<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.datamodel.*" %>
<%@ page import="edu.mcw.scge.dao.implementation.ExperimentDao" %>
<%@ page import="edu.mcw.scge.dao.implementation.ExperimentResultDao" %>
<%@ page import="java.util.*" %>
<%@ page import="edu.mcw.scge.datamodel.Vector" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/29/2020
  Time: 4:25 PM
  To change this template use File | Settings | File Templates.
--%>


<link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" integrity="sha384-AYmEC3Yw5cVb3ZcuHtOA93w35dYTsvhLPVnYs9eStHfGJvOvKxVfELGroGkvsg+p" crossorigin="anonymous"/>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.1.2/dist/chart.umd.min.js"></script>


<div>
    <%

        List<ExperimentRecord> records= (List<ExperimentRecord>) request.getAttribute("records");
        Map<java.lang.String, List<ExperimentRecord>> resultTypeRecords= (Map<java.lang.String, List<ExperimentRecord>>) request.getAttribute("resultTypeRecords");
        Map<java.lang.String, Integer> resultTypeColumnCount= (Map<java.lang.String,Integer>) request.getAttribute("resultTypeColumnCount");
        Map<String, List<String>> tableColumns=(Map<String, List<String>>) request.getAttribute("tableColumns");
     //   HashMap<Long,ExperimentRecord> experimentRecordsMap = (HashMap<Long,ExperimentRecord>) request.getAttribute("experimentRecordsMap");
        ExperimentDao edao = new ExperimentDao();
        Study study = (Study) request.getAttribute("study");
        List<Experiment> experiments=new ArrayList<>();
        if(study.getGroupId()!=1410 && study.getGroupId()!=1412) // 1410 and 1412 are SATC projects and each submission is a different group's validation.
             experiments=   edao.getExperimentsByGroup(study.getGroupId());
        else
            experiments=edao.getExperimentsByStudy(study.getStudyId());
        Access access = new Access();
        Person p = access.getUser(request.getSession());
        Experiment ex = (Experiment) request.getAttribute("experiment");
        long objectId = ex.getExperimentId();
        String redirectURL = "/data/experiments/experiment/" + ex.getExperimentId();
    %>
    <%
        Map<Long, List<Experiment>> validationExperimentsMap = new HashMap<>();
        if (request.getAttribute("validationExperimentsMap") != null)
            validationExperimentsMap = (Map<Long, List<Experiment>>) request.getAttribute("validationExperimentsMap");
        Map<Long, List<Experiment>> experimentsValidatedMap = new HashMap<>();
        if (request.getAttribute("experimentsValidatedMap") != null)
            experimentsValidatedMap = (Map<Long, List<Experiment>>) request.getAttribute("experimentsValidatedMap");
    %>
    <div id="recordTableContent" style="position:relative; left:0px; top:00px;padding-top:20px;">


            <% HashMap<Long,List<Guide>> guideMap = (HashMap<Long,List<Guide>>)request.getAttribute("guideMap");
                HashMap<Long,List<Vector>> vectorMap = (HashMap<Long,List<Vector>>)request.getAttribute("vectorMap");
                ExperimentResultDao erdao = new ExperimentResultDao();
                List<String> conditionList = edao.getExperimentRecordConditionList(ex.getExperimentId());

                List<String> tissueList = (List<String>) request.getAttribute("tissues");
                List<String> editorList = tableColumns.get("editorSymbol");
                List<String> modelList = tableColumns.get("modelDisplayName");
                List<String> deliverySystemList=tableColumns.get("deliverySystemName");
                List<String> resultTypeList = erdao.getResTypeByExpId(ex.getExperimentId());
                Set<String> resultTypeSet = (Set<String>) request.getAttribute("resultTypesSet");
                Map<String, List<String>> resultTypeNunits = (Map<String, List<String>>) request.getAttribute("resultTypeNUnits");

                List<String> unitList = tableColumns.get("units");
                List<String> guideList = tableColumns.get("guide");
                List<String> guideTargetLocusList=tableColumns.get("targetLocus");
                List<String> vectorList = tableColumns.get("vector");
                List<String> cellTypeList =  tableColumns.get("cellTypeTerm");
                List<String> qualifierList =  tableColumns.get("qualifier");
                List<String> timePointList =  tableColumns.get("timePoint");

                List<String> sexList = tableColumns.get("sex");
                List<String> hrdonorList = tableColumns.get("hrDonor");
                List<String> tissues = (List<String>)request.getAttribute("tissues");

                List<String> tissuesTarget = (List<String>)request.getAttribute("tissuesTarget");
                List<String> tissuesNonTarget = (List<String>)request.getAttribute("tissuesNonTarget");

                LinkedHashSet<String> conditions = (LinkedHashSet<String>) request.getAttribute("conditions");
                String selectedTissue = (String)request.getAttribute("tissue");
                String selectedTissues =(String) request.getAttribute("selectedTissues");
                List<String> selectedTissuesList=new ArrayList<>();
                if(selectedTissues!=null) {
                    String[] selectedTissueArray = selectedTissues.split(",");
                    selectedTissuesList.addAll(Arrays.asList(selectedTissueArray));
                }
                String selectedCellType = (String)request.getAttribute("cellType");
                String selectedResultType = (String)request.getAttribute("resultType");

               /* for (int i =0; i< cellTypeList.size(); i++) {
                    if (cellTypeList.get(i) == null) {
                        cellTypeList.set(i,"unspecified");
                    }
                }*/
               if(cellTypeList==null){
                   cellTypeList=new ArrayList<>();
               }else

                if ( cellTypeList.size() == 1){
                    if(cellTypeList.get(0) == null || (cellTypeList.get(0)!=null && cellTypeList.get(0).equals("unspecified"))) {
                    cellTypeList = new ArrayList<String>();
                    }
                }
            %>
            <% if (tissueList != null && tissueList.size() > 0 && selectedTissue == null && (selectedResultType == null || !selectedResultType.equals("all"))
           && selectedTissuesList.size()==0) { %>

                <%@include file="tissueMap.jsp"%>


         <% }else{  %>

        <%@include file="recordsTable.jsp"%>

        <%}%>
    </div>
</div>





<!--div style="float:right; width:8%;padding-bottom: 10px"><button class="btn btn-primary" >Compare</button></div-->
