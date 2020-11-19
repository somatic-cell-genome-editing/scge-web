<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/29/2020
  Time: 4:25 PM
  To change this template use File | Settings | File Templates.
--%>

<style>
    td{
        font-size: 12px;
    }
</style>
<script src="/scgeweb/js/edit.js"></script>

<div>
<div style="float:left;width:20%"><p style="color:steelblue;font-weight: bold;font-size: 20px">Studies: ${fn:length(studies)}</p></div>

<!--div style="float:right; width:8%;padding-bottom: 10px"><button class="btn btn-primary" >Compare</button></div-->
</div>
    <table id="myTable" class="table tablesorter table-striped">
    <thead>
    <tr><!--th>Select</th-->
        <!--th>Action</th-->
        <th>Tier</th>
        <th>Study_Name</th>
        <th>Type</th>
        <th>Laboratory</th>
        <th>PI</th>
        <th>Submitter</th>
        <th>Raw Data</th>
        <td>Ref</td>
        <th>Submission_Date</th>
        <th>Study_ID</th>
    </tr>
    </thead>
<c:forEach items="${studies}" var="rec">
    <tr>
        <!--td><input class="form" type="checkbox"></td-->
        <!--td><button class="btn btn-outline-secondary btn-sm">Edit</button></td-->
        <td>
            <form id="editStudy${rec.studyId}" action="edit/access">
                <input type="hidden" name="studyId" value="${rec.studyId}"/>
                <c:choose>
                    <c:when test="${studyId==rec.studyId}">

                            <c:if test="${tier=='1'}">
                                <select name="tier" class="tiers" onchange="changeAccess($(this),${rec.studyId} )">
                                    <option style="font-weight:700;font-size:20px" value="1" selected>1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                </select>
                            </c:if>
                        <c:if test="${tier=='2'}">
                            <select name="tier" class="tiers" onchange="changeAccess($(this),${rec.studyId} )">
                                <option style="font-weight:700;font-size:20px" value="1" >1</option>
                                <option value="2" selected>2</option>
                                <option value="3">3</option>
                                <option value="4">4</option>
                            </select>
                        </c:if>
                        <c:if test="${tier=='3'}">
                            <select name="tier" class="tiers" onchange="changeAccess($(this),${rec.studyId} )">
                                <option style="font-weight:700;font-size:20px" value="1" >1</option>
                                <option value="2">2</option>
                                <option value="3" selected>3</option>
                                <option value="4">4</option>
                            </select>
                        </c:if>
                        <c:if test="${tier=='4'}">
                            <select name="tier" class="tiers" onchange="changeAccess($(this),${rec.studyId} )">
                                <option style="font-weight:700;font-size:20px" value="1" >1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4" selected>4</option>
                            </select>
                        </c:if>

                    </c:when>
                    <c:otherwise>
                        <select name="tier" class="tiers" onchange="changeAccess($(this),${rec.studyId} )">
                            <option style="font-weight:700;font-size:20px" value="1">1</option>
                            <option value="2">2</option>
                            <option value="3">3</option>
                            <option value="4">4</option>
                        </select>
                    </c:otherwise>
                </c:choose>

            </form>
        <td><a href="/scgeweb/toolkit/studies/search/${rec.studyId}">${rec.study}</a></td>
        <td>${rec.type}</td>
        <td>${rec.labName}</td>
        <td>${rec.pi}</td>
        <td>${rec.submitter}</td>
        <td><a href="${rec.rawData}">link</a></td>
        <td><a href="${rec.reference}">ref</a></td>
        <td>${rec.submissionDate}</td>
        <td>${rec.studyId}</td>
    </tr>
    <div>
        <%@include file="../dashboardElements/tierOtherModal.jsp"%>

    </div>
    <div>
        <%@include file="../dashboardElements/tier2Modal.jsp"%>

    </div>
</c:forEach>

</table>


<!--div style="float:right; width:8%;padding-bottom: 10px"><button class="btn btn-primary" >Compare</button></div-->
