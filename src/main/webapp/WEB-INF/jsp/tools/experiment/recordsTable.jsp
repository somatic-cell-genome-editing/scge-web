<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 11/23/2022
  Time: 2:56 PM
  To change this template use File | Settings | File Templates.
--%>
<table id="myTable">
    <thead>
    <tr>
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



    </tr>
    </thead>
    <tbody></tbody>
<c:forEach items="${records}" var="record">
    <tr>
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
            <c:forEach items="${record.guides}" var="guide">
                ${guide.targetLocus}<br>
            </c:forEach>
        </td>
        </c:if>
        <c:if test="${tableColumns.guide!=null}">
        <td>
            <c:forEach items="${record.guides}" var="guide">
                ${guide.guide}<br>
            </c:forEach>
        </td>
        </c:if>
        <c:if test="${tableColumns.vector!=null}">
        <td> <c:forEach items="${record.vectors}" var="vector">
            ${vector.name}<br>
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


            <c:forEach items="${record.resultDetails}" var="erd">
                <c:if test="${erd.replicate==0}">
                    <td>${erd.numberOfSamples}</td>
                    <!--td>${erd.resultType}</td>
                    <td> ${erd.result} (${erd.units}  </td-->

                </c:if>
            </c:forEach>
        <c:forEach items="${resultTypeRecords}" var="resultType">
            <td>
            <c:forEach items="${resultType.value}" var="rt">
                <c:if test="${rt.experimentRecordId==record.experimentRecordId}">
                    <c:forEach items="${record.resultDetails}" var="erd">
                        <c:if test="${erd.replicate==0}">
                             ${erd.result}

                        </c:if>
                    </c:forEach>
                </c:if>

            </c:forEach>
            </td>
        </c:forEach>

    </tr>
</c:forEach>
</table>