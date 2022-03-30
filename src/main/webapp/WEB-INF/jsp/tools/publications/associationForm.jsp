<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 3/22/2022
  Time: 1:53 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script>
    <c:if test="${selectedStudyId!=null}">
    var selectedStudyId=${selectedStudyId}
    </c:if>
    $(function () {
        $('#selectSubmission').on('change', function () {
            $('#pubAssociationForm').submit();
        });

        if(typeof selectedStudyId!="undefined" && selectedStudyId!='')
            $('#selectSubmission').val(selectedStudyId)
    });


</script>
<div class="container-fluid">
    <div class="card">
        <div class="card-body">
            <form action="/toolkit/data/publications/associate/study/" id="pubAssociationForm">

                <div  style="background-color: aliceblue"><h6>References selected :</h6>
                    <ul>
                        <c:forEach  items="${references}" var="ref">
                            <input type="hidden" name="refKey" value="${ref.key}">
                            <li><a href="">${ref.title}</a></li>
                        </c:forEach>
                    </ul>
                </div>
                <div id="studyList">
                    <label><h6>Select Submission</h6>
                    <select style="text-wrap: normal;overflow: auto;width:80%" id="selectSubmission" name="studyId">
                        <option value="0"></option>
                        <c:forEach items="${studies}" var="study">
                            <option value="${study.studyId}">${study.study}(SCGE-${study.studyId})</option>
                        </c:forEach>
                    </select>
                </label>
                </div>
                <c:if test="${selectedStudyId!=null && selectedStudyId>0}">
                <div id="experimentList">
                    <h6>Select Experiment:</h6>
                    <table>
                    <c:forEach items="${experiments}" var="experiment">
                        <tr ><td style="width:60%"> <input type="checkbox" name="experimentCheck" value="${experiment.experimentId}"><a href="/toolkit/data/experiments/experiment/${experiment.experimentId}">&nbsp;${experiment.name}</a></td>
                            <td>
                                <input type="radio" name="experimentRadio" value="associated">&nbsp;Associated
                                <input type="radio" name="experimentRadio" value="related">&nbsp;Related
                            </td>
                            </tr>

                    </c:forEach>
                    </table>
                    <hr>
                </div>
                    <c:if test="${fn:length(objectMap)>0}">
                        <c:forEach items="${objectMap}" var="object">
                            <c:if test="${fn:length(object.value)>0}">
                                <c:set var="url" value=""/>
                                <c:if test="${object.key=='Editor'}">
                                    <c:set var="url" value="/toolkit/data/editors/editor?id="/>
                                </c:if>
                                <c:if test="${object.key=='Guide'}">
                                    <c:set var="url" value="/toolkit/data/guide/system?id="/>
                                </c:if>
                                <c:if test="${object.key=='Delivery'}">
                                    <c:set var="url" value="/toolkit/data/delivery/system?id="/>
                                </c:if>
                                <c:if test="${object.key=='Model'}">
                                    <c:set var="url" value="/toolkit/data/models/model/?id="/>
                                </c:if>
                                <c:if test="${object.key=='Vector'}">
                                    <c:set var="url" value="/toolkit/data/vector/format/?id="/>
                                </c:if>
                                <c:if test="${object.key=='HRDonor'}">
                                    <c:set var="url" value=""/>
                                </c:if>
                            <h6><input type="checkbox">&nbsp;${object.key}</h6>
                                <table>
                            <c:forEach items="${object.value}" var="obj">
                                <tr ><td> <input type="checkbox" name="" value="${obj.key}"><a href="${url}${obj.key}">&nbsp;${obj.value}</a></td>
                                    <td>
                                        <input type="radio" name="" value="associated">&nbsp;Associated
                                        <input type="radio" name="" value="related">&nbsp;Related
                                    </td>
                                </tr>
                            </c:forEach>
                                </table>
                                <hr>
                            </c:if>
                        </c:forEach>


                    </c:if>
                </c:if>
               <div>&nbsp;</div>
                <div>&nbsp;</div>
                <button class="btn btn-primary btn-sm">Make Association</button>
            </form>
        </div>
    </div>
</div>
