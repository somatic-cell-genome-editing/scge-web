<%@ page import="edu.mcw.scge.datamodel.Vector" %>
<%@ page import="java.util.Map" %>
<%@ page import="edu.mcw.scge.service.StringUtils" %>
<%@ page import="edu.mcw.scge.service.ProcessUtils" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 11/23/2022
  Time: 2:56 PM
  To change this template use File | Settings | File Templates.
--%>
<script>
    $(function () {
        $('[data-toggle="popover"]').popover({
            html: true,
            content: function () {
                var content = $(this).attr("data-popover-content");
                return $(content).children(".popover-body").html();
            }

        })
            .on("focus", function () {
                $(this).popover("show");
            }).on("focusout", function () {
            var _this = this;
            if (!$(".popover:hover").length) {
                $(this).popover("hide");
            } else {
                $('.popover').mouseleave(function () {
                    $(_this).popover("hide");
                    $(this).off('mouseleave');
                });
            }
        });
    })
</script>
<% ProcessUtils processUtils=new ProcessUtils();%>

<table id="myTable">
    <caption style="display:none;"><%=ex.getName().replaceAll(" ","_")%></caption>
    <thead>
    <tr class="tablesorter-ignoreRow hasSpan" role="row">
        <th data-sorter="false" colspan="<%=tableColumns.size()%>" data-column="0" scope="col" role="columnheader" class="tablesorter81a8a255b0035columnselectorhasSpan" data-col-span="<%=tableColumns.size()%>" style="background-color: white"></th>
        <%if(resultTypeColumnCount.get("editing efficiency")!=null && resultTypeColumnCount.get("editing efficiency")>0){%>
        <th data-sorter="false" colspan="<%=resultTypeColumnCount.get("editing efficiency")%>" data-column="<%=tableColumns.size()%>" scope="col" role="columnheader" class="tablesorter81a8a255b0035columnselectorhasSpan" data-col-span="<%=resultTypeColumnCount.get("editing efficiency")%>" style="background-color: orange;text-align: center">Editing Efficiency</th>
       <%}%>
        <%if(resultTypeColumnCount.get("delivery efficiency")!=null && resultTypeColumnCount.get("delivery efficiency")>0){
            int dataColumn=tableColumns.size();
            if(resultTypeColumnCount.get("editing efficiency")!=null)
                dataColumn=dataColumn+resultTypeColumnCount.get("editing efficiency");
        %>
        <th  data-sorter="false" colspan="<%=resultTypeColumnCount.get("delivery efficiency")%>" data-column="<%=dataColumn%>" scope="col" role="columnheader" class="tablesorter81a8a255b0035columnselectorhasSpan" data-col-span="<%=resultTypeColumnCount.get("delivery efficiency")%>" style="background-color: blue;color:white;text-align: center" >Delivery Efficiency</th>
        <%}%>
        <%if(resultTypeColumnCount.get("other")!=null && resultTypeColumnCount.get("other")>0){
            int dataColumn=tableColumns.size();
            if(resultTypeColumnCount.get("editing efficiency")!=null)
            dataColumn=dataColumn+resultTypeColumnCount.get("editing efficiency");
            if(resultTypeColumnCount.get("delivery efficieny")!=null)
            dataColumn=dataColumn+resultTypeColumnCount.get("delivery efficiency");
        %>
        <th data-sorter="false" colspan="<%=resultTypeColumnCount.get("other")%>" data-column="<%=dataColumn%>" scope="col" role="columnheader" class="tablesorter81a8a255b0035columnselectorhasSpan" data-col-span="<%=resultTypeColumnCount.get("other")%>" style="background-color: lightgrey;text-align: center">Other Measurement</th>
        <%}%>

    </tr>
    <tr>
        <th style="display: none">Record Id</th>
        <th>Condition</th>

        <c:if test="${tableColumns.tissueTerm!=null}">
        <th>Tissue</th>
        </c:if>
        <c:if test="${tableColumns.cellTypeTerm!=null}">
        <th>Cell Type</th>
        </c:if>
        <c:if test="${tableColumns.sex!=null}">
            <th>Sex</th>
        </c:if>
        <c:if test="${tableColumns.editorSymbol!=null}">
        <th>Editor</th>
        </c:if>
        <c:if test="${tableColumns.hrDonor!=null}">
            <th>HR Donor</th>
        </c:if>
        <c:if test="${tableColumns.modelDisplayName!=null}">
        <th>Model</th>
        </c:if>
        <c:if test="${tableColumns.deliverySystemName!=null}">
        <th>Delivery</th>
        </c:if>
        <c:if test="${tableColumns.targetLocus!=null}">
        <th>Target Locus</th>
        </c:if>
        <c:if test="${tableColumns.guide!=null}">
        <th>Guide</th>
        </c:if>
        <c:if test="${tableColumns.vector!=null}">
        <th>Vector</th>
        </c:if>

        <c:if test="${tableColumns.dosage!=null}">
        <th>Dosage</th>
        </c:if>
        <c:if test="${tableColumns.injectionFrequency!=null}">
        <th>Injection Frequency</th>
        </c:if>


        <c:forEach items="${resultTypeRecords}" var="resultType">
            <th><span style="display: none">${fn:substring(resultType.key, 0, fn:indexOf(resultType.key, "(" ))}</span> ${fn:replace(fn:substring(resultType.key, fn:indexOf(resultType.key, "(" )+1,fn:indexOf(resultType.key,")")), "(","")}</th>
        </c:forEach>
        <th data-sorter="false">Image</th>


    </tr>
    </thead>
    <tbody>


    <%  int rowCount =1;
        for(ExperimentRecord record:records){ %>
    <% if (access.hasStudyAccess(record.getStudyId(),p.getId())) {
        String border=new String();
        String target=new String();
        if(tissuesTarget.contains(record.getTissueTerm())){
            border="3px solid #DA70D6";
            target="Target Tissue";
        }else{
            border="";
        }

    %>
    <tr title="<%=target%>">

        <td style="display: none"><%=record.getExperimentRecordId()%></td>
        <td><a href="/toolkit/data/experiments/experiment/<%=record.getExperimentId()%>/record/<%=record.getExperimentRecordId()%>/"><%=record.getExperimentRecordName()%></a></td>

        <c:if test="${tableColumns.tissueTerm!=null}">
        <td style="border:<%=border%>"><%=record.getTissueTerm()%></td>
        </c:if>
        <c:if test="${tableColumns.cellTypeTerm!=null}">
        <td><%if(!record.getCellTypeTerm().equalsIgnoreCase("unspecified")){%><%=record.getCellTypeTerm()%><%}%></td>
        </c:if>
        <c:if test="${tableColumns.sex!=null}">
            <td><%if(record.getSex()!=null && !record.getSex().equals("null")){%><%=record.getSex()%><%}%></td>
        </c:if>

        <c:if test="${tableColumns.editorSymbol!=null}">
            <td><%if(record.getEditorId()>0){%><a href="/toolkit/data/editors/editor?id=<%=record.getEditorId()%>"><%=record.getEditorSymbol()%></a><%}%></td>
        </c:if>
        <c:if test="${tableColumns.hrDonor!=null}">
            <td><%if(record.getHrdonorId()>0){%><a href="/toolkit/data/hrdonors/hrdonor?id=<%=record.getHrdonorId()%>"><%=record.getHrdonorName()%></a><%}%></td>
        </c:if>
        <c:if test="${tableColumns.modelDisplayName!=null}">
            <%if(record.getModelId()>0 && record.getModelDisplayName()!=null && !record.getModelDisplayName().equals("")){%>
            <td><a href="/toolkit/data/models/model?id=<%=record.getModelId()%>"><%=record.getModelDisplayName()%></a></td>
            <%}else{ if(record.getModelName()!=null && !record.getModelName().equals("") && record.getModelId()>0){%>
                <td><a href="/toolkit/data/models/model?id=<%=record.getModelId()%>"><%=record.getModelName()%></a><%}}%></td>
        </c:if>
        <c:if test="${tableColumns.deliverySystemName!=null}">
            <td><%if(record.getDeliverySystemId()>0){%><a href="/toolkit/data/delivery/system?id=<%=record.getDeliverySystemId()%>"><%=record.getDeliverySystemName()%></a><%}%></td>
        </c:if>
        <c:if test="${tableColumns.targetLocus!=null}">
            <%  StringBuilder sb=new StringBuilder();
                if(record.getGuides()!=null) {
                boolean first = true;
                Set<String> targetLocus=new HashSet<>();
                for (Guide guide : record.getGuides()) {
                    if(guide.getTargetLocus() != null){
                        targetLocus.add(guide.getTargetLocus().trim());
                    }}

                for(String locus:targetLocus){
                    if (first) {
                        first = false;
                        if (locus != null){
                        sb.append(locus);
                    } } else if (locus != null){
                    sb.append(";").append(locus);

            }}}%>
            <td><%=sb.toString()%></td>
        </c:if>
        <c:if test="${tableColumns.guide!=null}">
            <td><%if(record.getGuides()!=null) { boolean first = true;for (Guide guide : record.getGuides()) { if (first) { first = false;if (guide.getGuide_id() >0){%><a href="/toolkit/data/guide/system?id=<%=guide.getGuide_id()%>"><%=guide.getGuide()%></a><%} } else { if (guide.getGuide_id() >0){%>;&nbsp;<a href="/toolkit/data/guide/system?id=<%=guide.getGuide_id()%>"><%=guide.getGuide()%></a><%} } } }%></td>
        </c:if>

        <c:if test="${tableColumns.vector!=null}">
            <td><%boolean firstVector=true;if(record.getVectors()!=null) for(Vector v:record.getVectors()){ if (firstVector) { firstVector = false;%><a href="/toolkit/data/vector/format?id=<%=v.getVectorId()%>"><%=v.getName()%></a><%}else {%><a href="/toolkit/data/vector/format?id=<%=v.getVectorId()%>">;&nbsp;<%=v.getName()%></a><%  } }%></td>
        </c:if>

        <c:if test="${tableColumns.dosage!=null}">
        <td><%=record.getDosage()%></td>
        </c:if>
        <c:if test="${tableColumns.injectionFrequency!=null}">
        <td><%=record.getInjectionFrequency()%></td>
        </c:if>
        <%
                int popover=0;
                for(Map.Entry resultType: resultTypeRecords.entrySet()){
                    String result="";
                    StringBuilder replicates=new StringBuilder();
                    String resultTypeKey= (String) resultType.getKey();
                    List<ExperimentRecord> rtRecords= (List<ExperimentRecord>) resultType.getValue();
                    int actualRepCount=0;
                    for(ExperimentRecord rtRecord:rtRecords){
                        if(rtRecord.getExperimentRecordId()==record.getExperimentRecordId()){
                            for(ExperimentResultDetail erd: record.getResultDetails()){
                                String resultKey=processUtils.getResultKey(erd);
                                if(erd.getReplicate()==0){
                                    if(erd.getUnits()!=null && resultTypeKey.equalsIgnoreCase(resultKey)){
                                        result=erd.getResult();
                                    }
                                }else{
                                    if(erd.getUnits()!=null && resultTypeKey.equalsIgnoreCase(resultKey) && !erd.getResult().equalsIgnoreCase("nan") && !erd.getResult().equals("")) {
                                        // replicates.append(erd.getReplicate()).append(" (").append(erd.getUnits()).append(")").append(":").append(erd.getResult()).append("<br>");
                                        replicates.append(" ").append(erd.getResult()).append(";<br>");
                                        actualRepCount++;
                                    }
                                }

                            }
                        }
                    }%>

        <td><% if(result!=null && !result.equals("")){%><button type="button" class="btn btn-light btn-sm" data-container="body" data-trigger="hover click" data-toggle="popover" data-placement="bottom" data-popover-content="#popover-<%=record.getExperimentRecordId()%><%=popover%>" title="Replicate Values <%=actualRepCount%>" style="background-color: transparent"><span style="display: none">Result:</span><span style="text-decoration:underline"><%=result%></span><span style="display: none"> | Replicates:</span></button><div style="display: none" id="popover-<%=record.getExperimentRecordId()%><%=popover%>"><div class="popover-body"><%=replicates.toString()%></div></div><%}%></td>
        <%popover++;}%>
        <%
            List<Image> images = idao.getImage(record.getExperimentRecordId(),"main1");
            if (images.size() > 0) {
        %>
        <td align="center"><a href="/toolkit/data/experiments/experiment/<%=record.getExperimentId()%>/record/<%=record.getExperimentRecordId()%>/"><img onmouseover="imageMouseOver(this,'<%=StringUtils.encode(images.get(0).getLegend())%>','<%=images.get(0).getTitle()%>')" onmouseout="imageMouseOut(this)" id="img<%=rowCount%>" src="https://scge.mcw.edu<%=images.get(0).getPath()%>" height="1" width="1"></a></td>
        <% rowCount++;
        }else { %>
        <td></td>
        <%}%>
    </tr>
<%}}%>
    </tbody>
</table>