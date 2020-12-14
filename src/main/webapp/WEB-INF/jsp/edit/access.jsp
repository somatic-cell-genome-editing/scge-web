<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 11/2/2020
  Time: 8:03 AM
  To change this template use File | Settings | File Templates.
--%>
<style>
   /* ul li:before {

        font-family: 'FontAwesome';
        content: '\f067';
        margin:0 5px 0 -15px;
        color: #ff8000;
    }
    ul li{
       padding-right: 10px;
    }*/
</style>
<div class="wrapper card" >
    <div class="card-header" style="background-color: #00AA9E;text-align: center" >
        <h4 class="text-white">Change Access Tier</h4>
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
    Access Tier:
        <c:if test="${rec.tier==1}">
        <div class="form-check form-check-inline">
    <input class="form-check-input" type="radio" name="tier" id="study${rec.studyId}-tier1" value="1" checked>
    <label class="form-check-label" for="study${rec.studyId}-tier1">1</label>
    </div>
    <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="tier" id="study${rec.studyId}-tier2" value="2" >
        <label class="form-check-label" for="study${rec.studyId}-tier2">2</label>
    </div>
    <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="tier" id="study${rec.studyId}-tier3" value="3" >
        <label class="form-check-label" for="study${rec.studyId}-tier3">3 </label>
    </div>
    <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="tier" id="study${rec.studyId}-tier4" value="4" >
        <label class="form-check-label" for="study${rec.studyId}-tier4">4 </label>
        </div>
        </c:if>
<c:if test="${rec.tier==2}">
        <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="tier" id="study${rec.studyId}-tier1" value="1" >
            <label class="form-check-label" for="study${rec.studyId}-tier1">1</label>
        </div>
        <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="tier" id="study${rec.studyId}-tier2" value="2" checked>
            <label class="form-check-label" for="study${rec.studyId}-tier2">2</label>
        </div>
        <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="tier" id="study${rec.studyId}-tier3" value="3" >
            <label class="form-check-label" for="study${rec.studyId}-tier3">3 </label>
        </div>
        <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="tier" id="study${rec.studyId}-tier4" value="4" >
            <label class="form-check-label" for="study${rec.studyId}-tier4">4 </label>
        </div>
</c:if>
<c:if test="${rec.tier==3}">

        <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="tier" id="study${rec.studyId}-tier1" value="1" >
            <label class="form-check-label" for="study${rec.studyId}-tier1">1</label>
        </div>
        <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="tier" id="study${rec.studyId}-tier2" value="2" >
            <label class="form-check-label" for="study${rec.studyId}-tier2">2</label>
        </div>
        <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="tier" id="study${rec.studyId}-tier3" value="3" checked >
            <label class="form-check-label" for="study${rec.studyId}-tier3">3 </label>
        </div>
        <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="tier" id="study${rec.studyId}-tier4" value="4" >
            <label class="form-check-label" for="study${rec.studyId}-tier4">4 </label>
        </div>
</c:if>
        <c:if test="${rec.tier==4}">

            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="tier" id="study${rec.studyId}-tier1" value="1" >
                <label class="form-check-label" for="study${rec.studyId}-tier1">1</label>
            </div>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="tier" id="study${rec.studyId}-tier2" value="2" >
                <label class="form-check-label" for="study${rec.studyId}-tier2">2</label>
            </div>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="tier" id="study${rec.studyId}-tier3" value="3"  >
                <label class="form-check-label" for="study${rec.studyId}-tier3">3 </label>
            </div>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="tier" id="study${rec.studyId}-tier4" value="4" checked>
                <label class="form-check-label" for="study${rec.studyId}-tier4">4 </label>
            </div>
        </c:if>

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

        <div class="form-group group-dropdown-list card" >
            <label for="groupSelect-study${rec.studyId}">Select Group</label>
                <select id="groupSelect-study${rec.studyId}" class="groupSelect form-control" multiple="multiple" disabled>
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
                                <span style="color:steelblue;font-weight: 100">${map.key.groupName}:</span>
                                <!--div class="form-check form-check-inline">&nbsp;
                                <input class="form-check-input" type="checkbox" id="all-group${map.key.groupId}-study${rec.studyId}" value="option7" checked onchange="toggleSelectedGroupMembers(${map.key.groupId},${rec.studyId})" >
                                <label class="form-check-label" for="all-group${map.key.groupId}-study${rec.studyId}" >All</label>
                            </div-->
                            </div>
                            <div class="form-group">
                                <ul class="list-inline">
                                    <c:forEach items="${map.value}" var="p">
                                <div class="form-check form-check-inline" style="display: none">
                                    <input class="form-check-input selectedGroupMember" name="member-group${map.key.groupId}-study${rec.studyId}" type="checkbox" id="member${p.id}-group${map.key.groupId}-study${rec.studyId}" value="${p.id}" checked>
                                    <label class="form-check-label" for="member${p.id}-group${map.key.groupId}-study${rec.studyId}">${p.name}</label>
                                </div>
                                <li class="list-inline-item" style="justify-content: right"><i class="fas fa-circle" style="color:#00AA9E"></i>&nbsp;&nbsp;${p.name}&nbsp;</li>
                                </c:forEach>
                                </ul>
                            </div>

                        </div>


            </c:forEach>

        </div>
        <!--div class="form-group">
        <button>Submit</button>
        </div-->
    </form>
    </div>
    </div>

