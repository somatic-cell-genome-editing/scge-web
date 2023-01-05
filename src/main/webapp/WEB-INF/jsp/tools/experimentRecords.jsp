<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.datamodel.*" %>
<%@ page import="edu.mcw.scge.dao.implementation.ExperimentDao" %>
<%@ page import="edu.mcw.scge.dao.implementation.ExperimentResultDao" %>
<%@ page import="java.util.*" %>
<%@ page import="edu.mcw.scge.datamodel.Vector" %>
<%@ page import="edu.mcw.scge.storage.ImageTypes" %>


<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/29/2020
  Time: 4:25 PM
  To change this template use File | Settings | File Templates.
--%>


<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
<link href="/toolkit/common/tableSorter/css/filter.formatter.css" rel="stylesheet" type="text/css"/>
<link href="/toolkit/common/tableSorter/css/theme.jui.css" rel="stylesheet" type="text/css"/>
<link href="/toolkit/common/tableSorter/css/theme.blue.css" rel="stylesheet" type="text/css"/>

<script src="/toolkit/common/tableSorter/js/tablesorter.js"> </script>
<script src="/toolkit/common/tableSorter/js/jquery.tablesorter.widgets.js"></script>
<link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" integrity="sha384-AYmEC3Yw5cVb3ZcuHtOA93w35dYTsvhLPVnYs9eStHfGJvOvKxVfELGroGkvsg+p" crossorigin="anonymous"/>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.1/Chart.min.js"></script>


<div>
        <%
    List<ExperimentRecord> records= (List<ExperimentRecord>) request.getAttribute("records");
    Map<java.lang.String, List<ExperimentRecord>> resultTypeRecords= (Map<java.lang.String, List<ExperimentRecord>>) request.getAttribute("resultTypeRecords");

        HashMap<Long,ExperimentRecord> experimentRecordsMap = (HashMap<Long,ExperimentRecord>) request.getAttribute("experimentRecordsMap");
        ExperimentDao edao = new ExperimentDao();
        Study study = (Study) request.getAttribute("study");
        Access access = new Access();
        Person p = access.getUser(request.getSession());
        Experiment ex = (Experiment) request.getAttribute("experiment");
    %>

    <table><tr><td style="font-size:18px;"><%=ex.getDescription()%></td></tr></table>
    <div id="recordTableContent" style="position:relative; left:0px; top:00px;padding-top:20px;">

            <%
                HashMap<String,String> deliveryAssay = (HashMap<String,String>) request.getAttribute("deliveryAssay");
                HashMap<String,String> editingAssay = (HashMap<String,String>) request.getAttribute("editingAssay");
            %>

            <div style="padding:10px; border:1px solid black; background-color: #F7F7F7;font-size:12px;">

            <% if (deliveryAssay.size() != 0) { %>
                <table>
                    <tr>
                        <td valign="top" width="150"><span style="width:100px; ;font-weight:700;">Delivery Assays:</span></td>
                        <td><%
                            int count=1;
                            for (String assay: deliveryAssay.keySet()) { %>
                            <span style="adding-left:20px;"><b>-</b>&nbsp;<%=assay%></span><br>
                            <%
                                count++;
                            } %>
                        </td>
                    </tr>
                </table>


            <% } %>
            <% if (editingAssay.size() != 0) { %>
                    <table>
                        <tr>
                            <td valign="top" width="150"><span style=";margin-top:10px;font-weight:700;">Editing Assay:</span></td>
                            <td> <%
                                int count=1;
                                for (String assay: editingAssay.keySet()) { %>
                                <span style="adding-left:20px;"><b>-</b>&nbsp;<%=assay%></span><br>
                                <%
                                    count++;
                                } %>
                            </td>
                        </tr>
                    </table>


            <% } %>
            </div>
            <br>

            <% if (experimentRecordsMap.isEmpty()) { %>
                    <%
                        long objectId = ex.getExperimentId();
                        String redirectURL = "/data/experiments/experiment/" + ex.getExperimentId();
                        String bucket="belowExperimentTable1";
                    %>

                    <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
                    <% bucket="belowExperimentTable2"; %>
                    <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
                    <% bucket="belowExperimentTable3"; %>
                    <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
                    <% bucket="belowExperimentTable4"; %>
                    <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
                    <% bucket="belowExperimentTable5"; %>
                    <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>

            <% return;
               }%>

            <%
                List<ExperimentRecord> experimentRecords = new ArrayList<>(experimentRecordsMap.values());
                HashMap<Long,Double> resultMap = (HashMap<Long, Double>) request.getAttribute("resultMap");

                TreeMap<Long,List<ExperimentResultDetail>> resultDetail= (TreeMap<Long, List<ExperimentResultDetail>>) request.getAttribute("resultDetail");
                HashMap<Long,List<Guide>> guideMap = (HashMap<Long,List<Guide>>)request.getAttribute("guideMap");
                HashMap<Long,List<Vector>> vectorMap = (HashMap<Long,List<Vector>>)request.getAttribute("vectorMap");
                ExperimentResultDao erdao = new ExperimentResultDao();
                List<String> conditionList = edao.getExperimentRecordConditionList(ex.getExperimentId());

           //     List<String> tissueList = edao.getExperimentRecordTissueList(ex.getExperimentId());
                List<String> tissueList = (List<String>) request.getAttribute("tissues");
                List<String> editorList = edao.getExperimentRecordEditorList(ex.getExperimentId());
                List<String> modelList = edao.getExperimentRecordModelList(ex.getExperimentId());
                List<String> deliverySystemList = edao.getExperimentRecordDeliverySystemList(ex.getExperimentId());
                List<String> resultTypeList = erdao.getResTypeByExpId(ex.getExperimentId());
                Set<String> resultTypeSet = (Set<String>) request.getAttribute("resultTypesSet");
                Map<String, List<String>> resultTypeNunits = (Map<String, List<String>>) request.getAttribute("resultTypeNUnits");

                List<String> unitList = erdao.getUnitsByExpId(ex.getExperimentId());
                List<String> guideList = edao.getExperimentRecordGuideList(ex.getExperimentId());
                List<String> guideTargetLocusList=edao.getExperimentRecordGuideTargetLocusList(ex.getExperimentId());
                List<String> vectorList = edao.getExperimentRecordVectorList(ex.getExperimentId());
                List<String> cellTypeList = edao.getExperimentRecordCellTypeList(ex.getExperimentId());
                List<String> sexList = edao.getExperimentRecordSexList(ex.getExperimentId());
                List<String> hrdonorList = edao.getExperimentRecordHrdonorList(ex.getExperimentId());
                List<String> tissues = (List<String>)request.getAttribute("tissues");

                List<String> tissuesTarget = (List<String>)request.getAttribute("tissuesTarget");
                List<String> tissuesNonTarget = (List<String>)request.getAttribute("tissuesNonTarget");

                LinkedHashSet<String> conditions = (LinkedHashSet<String>) request.getAttribute("conditions");
                String selectedTissue = (String)request.getAttribute("tissue");
                String selectedCellType = (String)request.getAttribute("cellType");
                String selectedResultType = (String)request.getAttribute("resultType");

                for (int i =0; i< cellTypeList.size(); i++) {
                    if (cellTypeList.get(i) == null) {
                        cellTypeList.set(i,"unspecified");
                    }
                }

                if (cellTypeList.size() == 1 && cellTypeList.get(0).equals("unspecified")) {
                    cellTypeList = new ArrayList<String>();
                }
            %>



            <% if (( tissueList.size() > 0 && selectedResultType == null && request.getAttribute("viewAll")!="true")) { %>

                <%@include file="tissueMap.jsp"%>


         <% }else{  %>




            <%@include file="recordsTable.jsp"%>

<%}%>

        </div>





<!--div style="float:right; width:8%;padding-bottom: 10px"><button class="btn btn-primary" >Compare</button></div-->
