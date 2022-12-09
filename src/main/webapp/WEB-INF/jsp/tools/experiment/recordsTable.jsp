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
        <th colspan="${fn:length(tableColumns)+3}" data-column="0" scope="col" role="columnheader" class="tablesorter81a8a255b0035columnselectorhasSpan" data-col-span="${fn:length(tableColumns)+3}" style="background-color: whitesmoke"></th>
        <th colspan="${fn:length(resultTypeRecords)}" data-column="${fn:length(tableColumns)+3}" scope="col" role="columnheader" class="tablesorter81a8a255b0035columnselectorhasSpan" data-col-span="${fn:length(resultTypeRecords)}" style="background-color: orange">Results</th>

    </tr-->
    <tr>
        <th>Record Id</th>
        <th>Condition</th>
        <c:if test="${tableColumns.sex!=null}">
        <th>Sex</th>
        </c:if>
        <c:if test="${tableColumns.tissueTerm!=null}">
        <th>Tissue</th>
        </c:if>
        <c:if test="${tableColumns.cellTypeTerm!=null}">
        <th>Cell Type</th>
        </c:if>
        <c:if test="${tableColumns.age!=null}">
        <th>Age</th>
        </c:if>
        <c:if test="${tableColumns.genoType!=null}">
        <th>Genotype</th>
        </c:if>
        <c:if test="${tableColumns.editorSymbol!=null}">
        <th>Editor</th>
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
        <c:if test="${tableColumns.hrDonor!=null}">
        <th>HR Donor</th>
        </c:if>
        <c:if test="${tableColumns.dosage!=null}">
        <th>Dosage</th>
        </c:if>
        <c:if test="${tableColumns.injectionFrequency!=null}">
        <th>Injection Frequency</th>
        </c:if>
        <th>No. of Replicates</th>

        <c:forEach items="${resultTypeRecords}" var="resultType">
            <th>${resultType.key}</th>
        </c:forEach>
        <th>Image</th>


    </tr>
    </thead>
    <tbody></tbody>
<c:forEach items="${records}" var="record">
    <tr>
        <td>${record.experimentRecordId}</td>
        <td>${record.experimentRecordName}</td>
        <c:if test="${tableColumns.sex!=null}">
        <td>${record.sex}</td>
        </c:if>
        <c:if test="${tableColumns.tissueTerm!=null}">
        <td>${record.tissueTerm}</td>
        </c:if>
        <c:if test="${tableColumns.cellTypeTerm!=null}">
        <td>${record.cellTypeTerm}</td>
        </c:if>
        <c:if test="${tableColumns.age!=null}">
        <td>${record.age}</td>
        </c:if>
        <c:if test="${tableColumns.genoType!=null}">
        <td>${record.genotype}</td>
        </c:if>
        <c:if test="${tableColumns.editorSymbol!=null}">
        <td>${record.editorSymbol}</td>
        </c:if>
        <c:if test="${tableColumns.modelDisplayName!=null}">
        <td>${record.modelDisplayName}</td>
        </c:if>
        <c:if test="${tableColumns.deliverySystemName!=null}">
        <td>${record.deliverySystemName}</td>
        </c:if>
        <c:if test="${tableColumns.targetLocus!=null}">
        <td>

            <c:set var="first" value="true"/>
            <c:forEach items="${record.guides}" var="guide">
                <c:choose>
                    <c:when test="${first=='true'}">
                        <c:set var="first" value="false"/>
                        ${guide.targetLocus}
                    </c:when>
                    <c:otherwise>
                        ;${guide.targetLocus}
                    </c:otherwise>
                </c:choose>

            </c:forEach>

        </td>
        </c:if>
        <c:if test="${tableColumns.guide!=null}">
        <td>
            <c:set var="first" value="true"/>
            <c:forEach items="${record.guides}" var="guide">
                <c:choose>
                    <c:when test="${first=='true'}">
                        <c:set var="first" value="false"/>
                        ${guide.guide}
                    </c:when>
                    <c:otherwise>
                        ;${guide.guide}
                    </c:otherwise>
                </c:choose>

            </c:forEach>
        </td>
        </c:if>
        <c:if test="${tableColumns.vector!=null}">
        <td>
            <c:set var="first" value="true"/>
            <c:forEach items="${record.vectors}" var="vector">
                <c:choose>
                    <c:when test="${first=='true'}">
                        <c:set var="first" value="false"/>
                        ${vector.name}
                    </c:when>
                    <c:otherwise>
                        ;${vector.name}
                    </c:otherwise>
                </c:choose>

            </c:forEach>

        </td>
        </c:if>
        <c:if test="${tableColumns.hrDonor!=null}">
        <td>${record.hrdonorName}</td>
        </c:if>
        <c:if test="${tableColumns.dosage!=null}">
        <td>${record.dosage}</td>
        </c:if>
        <c:if test="${tableColumns.injectionFrequency!=null}">
        <td>${record.injectionFrequency}</td>
        </c:if>
        <td>


            <button type="button" class="btn btn-light btn-sm" data-container="body" data-trigger="hover click" data-toggle="popover" data-placement="bottom" data-popover-content="#popover-${record.experimentRecordId}" title="Replicate Values" style="background-color: transparent">
                        <span style="text-decoration:underline">
                            <c:forEach items="${record.resultDetails}" var="erd">
                                <c:if test="${erd.replicate==0}">
                                    ${erd.numberOfSamples}
                                </c:if>
                            </c:forEach>

                        </span>
            </button>
            <div style="display: none" id="popover-${record.experimentRecordId}">
                <div class="popover-body">
                    <c:forEach items="${record.resultDetails}" var="r">
                        <c:if test="${r.replicate!=0 && !fn:containsIgnoreCase(r.result, 'nan' )}">
                            ${r.replicate}&nbsp;(${r.units}):&nbsp;${r.result}<br>
                        </c:if>
                    </c:forEach>
                </div>
            </div>



        </td>

        <c:forEach items="${resultTypeRecords}" var="resultType">

            <td>
            <c:forEach items="${resultType.value}" var="rt">
                <c:if test="${rt.experimentRecordId==record.experimentRecordId}">
                    <c:forEach items="${record.resultDetails}" var="erd">
                        <c:if test="${erd.replicate==0 && fn:contains(resultType.key, erd.units)}">
                             ${erd.result}

                        </c:if>
                    </c:forEach>
                </c:if>

            </c:forEach>
            </td>
        </c:forEach>
        <td></td>
    </tr>
</c:forEach>
</table>