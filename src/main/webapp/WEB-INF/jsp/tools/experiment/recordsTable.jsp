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
        <th>ExperimentType</th>
        <th>Tissue</th>
        <th>Cell Type</th>
        <th>Model</th>
        <th>Age</th>
        <th>Sex</th>
        <th>Genotype</th>
        <th>Editor</th>
        <th>Delivery</th>
        <th>Guide</th>
        <th>Vector</th>
        <th>HR Donor</th>
        <th>Applciation Method</th>
        <th>Dosage</th>
        <th>Injection Frequency</th>
        <th>No. of Replicates</th>
        <th>Result Type</th>
        <th>Result</th>

    </tr>
    </thead>
    <tbody></tbody>
<c:forEach items="${records}" var="record">
    <tr>
        <td>${record.experimentRecordName}</td>
        <td>${record.experimentType}</td>
        <td>${record.tissueTerm}</td>
        <td>${record.cellTypeTerm}</td>
        <td>${record.modelDisplayName}</td>
        <td>${record.age}</td>
        <td>${record.sex}</td>
        <td>${record.genotype}</td>

        <td>${record.editorSymbol}</td>
        <td>${record.deliverySystemName}</td>
        <td>
            <c:forEach items="${record.guides}" var="guide">
                ${guide.guide}<br>
            </c:forEach>
        </td>
        <td> <c:forEach items="${record.vectors}" var="vector">
            ${vector.name}<br>
        </c:forEach>
        </td>
        <td>${record.hrdonorName}</td>
        <td>Applciation Method</td>
        <td>${record.dosage}</td>
        <td>${record.injectionFrequency}</td>


            <c:forEach items="${record.resultDetails}" var="erd">
                <c:if test="${erd.replicate==0}">
                    <td>${erd.numberOfSamples}</td>
                    <td>${erd.resultType}</td>
                    <td> ${erd.result} (${erd.units}  </td>

                </c:if>
            </c:forEach>

    </tr>
</c:forEach>
</table>