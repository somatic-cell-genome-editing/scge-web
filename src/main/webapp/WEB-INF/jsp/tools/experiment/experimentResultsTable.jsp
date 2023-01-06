<%@ page import="edu.mcw.scge.datamodel.Vector" %>
<%@ page import="java.util.Map" %>
<%@ page import="edu.mcw.scge.service.StringUtils" %>
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


<table id="myTable">
    <thead>
    <!--tr class="tablesorter-ignoreRow hasSpan" role="row">
        <th colspan="$-{fn:length(tableColumns)+3}" data-column="0" scope="col" role="columnheader" class="tablesorter81a8a255b0035columnselectorhasSpan" data-col-span="$-{fn:length(tableColumns)+3}" style="background-color: whitesmoke"></th>
        <th colspan="$-{fn:length(resultTypeRecords)}" data-column="$-{fn:length(tableColumns)+3}" scope="col" role="columnheader" class="tablesorter81a8a255b0035columnselectorhasSpan" data-col-span="$-{fn:length(resultTypeRecords)}" style="background-color: orange">Results</th>

    </tr-->
    <tr>
        <th>Record Id</th>
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
            <th>${resultType.key}</th>
        </c:forEach>
        <th>Image</th>


    </tr>
    </thead>
    <tbody>
    <%  int rowCount =1;
        for(ExperimentRecord record:records){%>
    <tr>

        <td><%=record.getExperimentRecordId()%></td>
        <td><a href="/toolkit/data/experiments/experiment/<%=record.getExperimentId()%>/record/<%=record.getExperimentRecordId()%>/"><%=record.getExperimentRecordName()%></a></td>

        <c:if test="${tableColumns.tissueTerm!=null}">
        <td><%=record.getTissueTerm()%></td>
        </c:if>
        <c:if test="${tableColumns.cellTypeTerm!=null}">
        <td><%=record.getCellTypeTerm()%></td>
        </c:if>
        <c:if test="${tableColumns.sex!=null}">
            <td><%=record.getSex()%></td>
        </c:if>

        <c:if test="${tableColumns.editorSymbol!=null}">
            <td>
                <%if(record.getEditorId()>0){%>
                <a href="/toolkit/data/editors/editor?id=<%=record.getEditorId()%>"><%=record.getEditorSymbol()%></a>
                <%}%>
            </td>
        </c:if>
        <c:if test="${tableColumns.hrDonor!=null}">
            <td>
                <%if(record.getHrdonorId()>0){%>
                <a href="/toolkit/data/hrdonors/hrdonor?id=<%=record.getHrdonorId()%>"><%=record.getHrdonorName()%></a>
            <%}%>
            </td>
        </c:if>
        <c:if test="${tableColumns.modelDisplayName!=null}">

            <td>
                <%if(record.getModelId()>0){%>
                <a href="/toolkit/data/models/model?id=<%=record.getModelId()%>"><%=record.getModelDisplayName()%></a>
            <%}%>
            </td>
        </c:if>
        <c:if test="${tableColumns.deliverySystemName!=null}">
            <td>
                <%if(record.getDeliverySystemId()>0){%>
                <a href="/toolkit/data/delivery/system?id=<%=record.getDeliverySystemId()%>"><%=record.getDeliverySystemName()%></a>
                <%}%>
            </td>
        </c:if>
        <c:if test="${tableColumns.targetLocus!=null}">
            <td>
            <%if(record.getGuides()!=null) {
                    boolean first = true;
                    for (Guide guide : record.getGuides()) {
                        if (first) {
                            first = false;
                            if (guide.getTargetLocus() != null){%>
                               <%=guide.getTargetLocus()%>
                          <%} } else {
                            if (guide.getTargetLocus() != null){%>
                           ;&nbsp;<%=guide.getTargetLocus()%>

                       <%} }
                    }
                }%>
            </td>
        </c:if>
        <c:if test="${tableColumns.guide!=null}">
            <td>
                <%if(record.getGuides()!=null) {
                    boolean first = true;
                    for (Guide guide : record.getGuides()) {
                        if (first) {
                            first = false;
                            if (guide.getGuide_id() >0){%>
                <a href="/toolkit/data/guide/system?id=<%=guide.getGuide_id()%>"><%=guide.getGuide()%></a>
                <%} } else {
                    if (guide.getGuide_id() >0){%>
                ;&nbsp;<a href="/toolkit/data/guide/system?id=<%=guide.getGuide_id()%>"><%=guide.getGuide()%></a>

                <%} }
                }
                }%>
            </td>
        </c:if>

        <c:if test="${tableColumns.vector!=null}">
            <td>
        <%
            boolean firstVector=true;
        if(record.getVectors()!=null)
        for(Vector v:record.getVectors()){
                if (firstVector) {
                    firstVector = false;
         %>
                <a href="/toolkit/data/vector/format?id=<%=v.getVectorId()%>"><%=v.getName()%></a>
                <%}else {%>
                <a href="/toolkit/data/vector/format?id=<%=v.getVectorId()%>">;&nbsp;<%=v.getName()%></a>
                <%  }
                }
                %>

           </td>
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
                    for(ExperimentRecord rtRecord:rtRecords){
                        if(rtRecord.getExperimentRecordId()==record.getExperimentRecordId()){
                            for(ExperimentResultDetail erd: record.getResultDetails()){
                                if(erd.getReplicate()==0){
                                    if(erd.getUnits()!=null && resultTypeKey.contains(erd.getUnits())){
                                        result=erd.getResult();
                                    }
                                }else{
                                    if(erd.getUnits()!=null && resultTypeKey.contains(erd.getUnits()) &&!erd.getResult().equalsIgnoreCase("nan"))
                                    replicates.append(erd.getReplicate()).append(" (").append(erd.getUnits()).append(")").append(":").append(erd.getResult()).append("<br>");
                                }

                            }
                        }
                    }%>

        <td>
            <button type="button" class="btn btn-light btn-sm" data-container="body" data-trigger="hover click" data-toggle="popover" data-placement="bottom" data-popover-content="#popover-<%=record.getExperimentRecordId()%><%=popover%>" title="Replicate Values" style="background-color: transparent">
                        <span style="text-decoration:underline">
                          <%=result%>

                        </span>
            </button>
            <div style="display: none" id="popover-<%=record.getExperimentRecordId()%><%=popover%>">
                <div class="popover-body">

                  <%=replicates.toString()%>

                </div>
            </div>




        </td>
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
<%}%>
    </tbody>
</table>