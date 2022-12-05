<%@ page import="edu.mcw.scge.service.StringUtils" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.datamodel.Vector" %><%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 11/22/2022
  Time: 1:23 PM
  To change this template use File | Settings | File Templates.
--%>
<table id="myTable" class="table tablesorter table-striped table-sm">
    <caption style="display:none;"><%=ex.getName().replaceAll(" ","_")%></caption>
    <thead>
    <tr>
        <th>Condition<%--=request.getAttribute("uniqueFields").toString()--%></th>
        <%  for(String option:headers) { %>
        <th><%=option%></th>
        <% } %>
        <c:if test="${objectSizeMap['dosage']>0}">

            <th>Dosage</th>
        </c:if>
        <% if (resultTypeNunits!=null && resultTypeNunits.size() > 0 ) {
            for(Map.Entry resultType:resultTypeNunits.entrySet()){
                List<String> units= (List<String>) resultType.getValue();
                for(String unit:units){
                    if(unit.toLowerCase().contains("signal")){



        %>
        <th><%=resultType.getKey()%>&nbsp;(<%=unit%>)</th><%

            } }
        for(String unit:units){
            if(!unit.toLowerCase().contains("signal")){%>
        <th><%=resultType.getKey()%>&nbsp;(<%=unit%>)</th>

        <% } } }} %>
        <% if (unitList.size() > 0 ) {  %><!--th>Units</th--><% } %>
        <!--th id="result">Result/Mean</th-->
        <th>Image</th>
    </tr>
    </thead>

    <%
        int rowCount =1;
        for (Long resultId: resultDetail.keySet()) {
            List<ExperimentResultDetail> ers = resultDetail.get(resultId);
            long expRecordId = ers.get(0).getExperimentRecordId();
            ExperimentRecord exp = experimentRecordsMap.get(expRecordId);
            String experimentName=exp.getExperimentName();
            //if(resultTypeList.size()>1) {
            //    experimentName+=" ("+ers.get(0).getResultType()+") ";
            // }
            boolean hadTerm = false;
            boolean hadCell = false;
            if (!SFN.parse(exp.getTissueTerm()).equals("") ) {
                experimentName+=" (" + exp.getTissueTerm();
                hadTerm = true;
            }
            if (!SFN.parse(exp.getCellType()).equals("")) {
                if (!hadTerm) {
                    experimentName+=" (";
                }else {
                    experimentName+="/";
                }
                experimentName+=exp.getCellTypeTerm();
                hadCell = true;
            }
            if (hadTerm || hadCell) {
                experimentName+=")";
            }
            List<Guide> guides = guideMap.get(exp.getExperimentRecordId());
            String guide = "";
            String targetLocus="";
            Set<String> targetLocusSet=new HashSet<>();
            boolean fst = true;
            for(Guide g: guides) {
                if (!fst) { guide += ";"; targetLocus+=";"; }
                guide += "<a href=\"/toolkit/data/guide/system?id="+g.getGuide_id()+"\">"+SFN.parse(g.getGuide())+"</a>";
                if( g.getTargetLocus()!=null)
                    if(! targetLocusSet.contains(g.getTargetLocus())) {
                        targetLocusSet.add(g.getTargetLocus());
                        targetLocus += SFN.parse(g.getTargetLocus()) + "</a>";
                    }
                fst = false;
            }
            List<Vector> vectors = vectorMap.get(exp.getExperimentRecordId());
            String vector = "";
            fst=true;
            for(Vector v: vectors) {
                if (!fst) { vector += ";"; }
                vector += "<a href=\"/toolkit/data/vector/format?id="+v.getVectorId()+"\">"+SFN.parse(v.getName())+"</a>";
                fst=false;
            }
    %>

    <% if (access.hasStudyAccess(exp.getStudyId(),p.getId())) {
        String border=new String();
        String target=new String();
        if(tissuesTarget.contains(exp.getTissueTerm())){
            border="3px solid #DA70D6";
            target="Target Tissue";
        }else{
            border="";
        }

    %>
    <tr title="<%=target%>">
        <td id="<%=SFN.parse(exp.getExperimentName())%>" ><a href="/toolkit/data/experiments/experiment/<%=exp.getExperimentId()%>/record/<%=exp.getExperimentRecordId()%>/"><%=SFN.parse(experimentName)%></a></td>


        <% if (tissueList.size() > 0 ) { %><td style="border:<%=border%>"><%=SFN.parse(exp.getTissueTerm())%></td><% } %>
        <% if (cellTypeList.size() > 0) { %><td><%=SFN.parse(exp.getCellTypeTerm())%></td><% } %>
        <% if (sexList.size() > 0) { %><td><%=SFN.parse(exp.getSex())%></td><% } %>
        <% if (editorList.size() > 0 ) { %><td><a href="/toolkit/data/editors/editor?id=<%=exp.getEditorId()%>"><%=SFN.parse(exp.getEditorSymbol())%></a></td><% } %>
        <% if (hrdonorList.size() > 0) { %><td><a href="/toolkit/data/hrdonors/hrdonor?id=<%=exp.getHrdonorId()%>"><%=SFN.parse(exp.getHrdonorName())%></a></td><% } %>
        <% if (modelList.size() > 0 ) { %><td><a href="/toolkit/data/models/model?id=<%=exp.getModelId()%>"><%=SFN.parse(exp.getModelName())%></a></td><% } %>
        <% if (deliverySystemList.size() > 0 ) { %><td><a href="/toolkit/data/delivery/system?id=<%=exp.getDeliverySystemId()%>"><%=SFN.parse(exp.getDeliverySystemName())%></a></td><% } %>
        <% if (guideList.size() > 0 ) { %><td><%=targetLocus%></td><% } %>

        <% if (guideList.size() > 0 ) { %><td><%=guide%></td><% } %>
        <% if (vectorList.size() > 0 ) { %><td><%=vector%></td><% } %>
        <c:if test="${objectSizeMap['dosage']>0 }">

            <td><%=exp.getDosage()%></td>
        </c:if>
        <% if (resultTypeSet.size() > 0 ) {
            for(Map.Entry resultType:resultTypeNunits.entrySet()){
                List<String> units= (List<String>) resultType.getValue();
                for(String unit:units){
                    if(unit.toLowerCase().contains("signal")){

        %>
        <td>
            <%       for(ExperimentResultDetail result:ers){
                if(result.getResultType().equalsIgnoreCase((String) resultType.getKey()) && result.getExperimentRecordId()==exp.getExperimentRecordId() && result.getReplicate()==0 && result.getUnits().equalsIgnoreCase(unit)){


            %>
            <%=result.getResult()%>

            <%     } }%>
        </td>
        <%  }}
            for(String unit:units) {
                if (!unit.toLowerCase().contains("signal")) {%>
        <td>
            <%       for(ExperimentResultDetail result:ers){
                if(result.getResultType().equalsIgnoreCase((String) resultType.getKey()) && result.getExperimentRecordId()==exp.getExperimentRecordId() && result.getReplicate()==0 && result.getUnits().equalsIgnoreCase(unit)){


            %>
            <%=result.getResult()%>

            <%     }
            }%>
        </td>
        <%}
        }
        }} %>
        <% if (unitList.size() > 0 ) { %><!--td><%--=ers.get(0).getUnits()--%></td--><% } %>
        <% for(ExperimentResultDetail e:ers) {
            if(e.getReplicate() == 0) { %>
        <!--td><%--=e.getResult()--%></td-->
        <% } } for(ExperimentResultDetail e:ers) {
            if(e.getReplicate() != 0) { %>
        <!--td style="display: none"><%--=e.getResult()--%></td-->
        <%}}%>
        <%
            List<Image> images = idao.getImage(exp.getExperimentRecordId(),"main1");
            if (images.size() > 0) {
        %>
        <td align="center"><a href="/toolkit/data/experiments/experiment/<%=exp.getExperimentId()%>/record/<%=exp.getExperimentRecordId()%>/"><img onmouseover="imageMouseOver(this,'<%=StringUtils.encode(images.get(0).getLegend())%>','<%=images.get(0).getTitle()%>')" onmouseout="imageMouseOut(this)" id="img<%=rowCount%>" src="<%=images.get(0).getPath()%>" height="1" width="1"></a></td>
        <% rowCount++;
        }else { %>
        <td></td>
        <%}%>

    </tr>

    <% }} %>
</table>