<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 11/2/2020
  Time: 8:03 AM
  To change this template use File | Settings | File Templates.
--%>

<div class="wrapper card" >
    <div class="card-header" style="background-color: #00AA9E;text-align: center" >
        <h4 class="text-white">Change Access Teir</h4>

    </div>
    <div class="card-body" align="left">
    <form id="tier2Form${rec.studyId}">
        <div class="card">
        Selected Experiment: <input type="text" value="${rec.study}" disabled/>
            <div class="row">
            <div class="col">
                <label>
                    Lab:
                    <input type="text" class="form-control" value="${rec.labName}">
                </label>
            </div>
            <div class="col">
                <label>
                    Principal Investigator:
                    <input type="text" class="form-control" value="${rec.pi}">
                </label>
            </div>
        </div>
    <div class="form-inline">
    Access Tier: <div class="form-check form-check-inline">
    <input class="form-check-input" type="radio" name="inlineRadioOptions" id="study${rec.studyId}-tier1" value="option1" disabled>
    <label class="form-check-label" for="study${rec.studyId}-tier1">1</label>
    </div>
    <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="inlineRadioOptions" id="study${rec.studyId}-tier2" value="option2" checked>
        <label class="form-check-label" for="study${rec.studyId}-tier2">2</label>
    </div>
    <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="inlineRadioOptions" id="study${rec.studyId}-tier3" value="option3" disabled>
        <label class="form-check-label" for="study${rec.studyId}-tier3">3 </label>
    </div>
    <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="inlineRadioOptions" id="study${rec.studyId}-tier4" value="option3" disabled>
        <label class="form-check-label" for="study${rec.studyId}-tier4">4 </label>
        </div>
        </div>
        </div>

        <div class="card">
            <div class="card-header" style="padding-left:0 ">
                <button class="btn btn-link btn-block text-left" type="button"  aria-expanded="true" onclick="toggleDiv(${rec.studyId})" >
                Groups default to have access...
                </button>
            </div>
            <!--button type="button" class="btn btn-primary" onclick="toggleDiv($-{rec.studyId})">Groups that have access...</button-->
            <div class="card-body" id="collapse${rec.studyId}" style="display: none">
            <c:forEach items="${DCCNIHMembersMap}" var="map">
                <div class="group form-group" id="group${map.key.groupId}-study${rec.studyId}">
                    <span style="color:steelblue;">${map.key.groupName}:</span>
                    <c:forEach items="${map.value}" var="p">
                            <span>${p.name}</span>
                    </c:forEach>
                </div>
            </c:forEach>
            </div>
        </div>

        <div class="form-group group-dropdown-list card">
            <label for="groupSelect-study${rec.studyId}">Select Group</label>
                <select id="groupSelect-study${rec.studyId}" class="groupSelect form-control" multiple="multiple"  >
                <option value="0" selected>Choose...</option>
                <c:forEach items="${groupsMap1}" var="m">
                    <!--p><a href="members?group=$-{m.key}" style="font-weight:bold">{m.key}</a></p-->
                        <c:choose>
                            <c:when test="${m.key!=31 && m.key!=33}">
                                <c:forEach items="${m.value}" var="sg">
                                    <option value="${sg.groupId}">${sg.groupName}</option>
                                </c:forEach>
                            </c:when>
                        </c:choose>



                </c:forEach>
            </select>
        </div>

        <div class="card">
            <span style="font-weight: bold">Groups you selected to share... </span>

            <c:forEach items="${groupMembersMap}" var="map">

                        <div class="group form-group" id="group${map.key.groupId}-study${rec.studyId}" style="display: none">
                            <div class="form-group">
                                <span style="color:steelblue;">${map.key.groupName}:</span><div class="form-check form-check-inline">&nbsp;
                                <input class="form-check-input" type="checkbox" id="all-group${map.key.groupId}-study${rec.studyId}" value="option7" checked>
                                <label class="form-check-label" for="all-group${map.key.groupId}-study${rec.studyId}" >All</label>
                            </div><br>
                            </div>
                            <c:forEach items="${map.value}" var="p">
                                <div class="form-check form-check-inline">
                                    <input class="form-check-input" type="checkbox" id="member${p.id}-group${map.key.groupId}-study${rec.studyId}" value="option3" checked>
                                    <label class="form-check-label" for="member${p.id}-group${map.key.groupId}-study${rec.studyId}">${p.name}</label>
                                </div>
                            </c:forEach>

                        </div>


            </c:forEach>

        </div>
        <!--div class="form-group">
        <button>Submit</button>
        </div-->
    </form>
    </div>
    </div>

