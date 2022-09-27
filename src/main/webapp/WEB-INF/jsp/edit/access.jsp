<%@ page import="edu.mcw.scge.datamodel.Person" %>
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
        <h4 class="text-white">Change Access Tier</h4>
    </div>
    <div class="card-body" align="left">
    <!--form id="tier2Formz"-->
        <div class="card">
        Selected Experiment: <input type="text" value="<%=s.getStudy()%>" disabled/>
            <div class="row">
            <div class="col">
                <label>
                    Lab:
                    <input type="text" class="form-control" value="<%=s.getLabName()%>" disabled>
                </label>
            </div>
            <div class="col">

                    Principal Investigator:
                    <div  class="card form-control" style="height: fit-content" >
                        <%if(s.getPi()!=null){%>
                        <%=s.getPi()%>
                        <%}else{%>
                            <ul>
                           <% for(Person pi:s.getMultiplePis()){
                            %>
                                <li><%=pi.getName()%></li>


                        <%}%>
                            </ul>
                        <%}%>
                    </div>

            </div>
        </div>
    <div class="form-inline">
    Access Tier:<div class="form-check form-check-inline">
    <input class="form-check-input" type="radio" name="tier<%=s.getStudyId()%>" id="study<%=s.getStudyId()%>-tier1" value="1">
    <label class="form-check-label" for="study<%=s.getStudyId()%>-tier1">1</label>
    </div>
    <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="tier<%=s.getStudyId()%>" id="study<%=s.getStudyId()%>-tier2" value="2" >
        <label class="form-check-label" for="study<%=s.getStudyId()%>-tier2">2</label>
    </div>
    <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="tier<%=s.getStudyId()%>" id="study<%=s.getStudyId()%>-tier3" value="3" >
        <label class="form-check-label" for="study<%=s.getStudyId()%>-tier3">3 </label>
    </div>
    <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="tier<%=s.getStudyId()%>" id="study<%=s.getStudyId()%>-tier4" value="4" >
        <label class="form-check-label" for="study<%=s.getStudyId()%>-tier4">4 </label>
        </div>

    </div>
        </div>


        <div class="form-group group-dropdown-list card" >
            <label for="groupSelect-study<%=s.getStudyId()%>">Select Group</label>
                <select id="groupSelect-study<%=s.getStudyId()%>" class="groupSelect form-control" multiple="multiple" disabled>
                <c:forEach items="${groupsMap1}" var="m">
                    <!--p><a href="members?group=$-{m.key}" style="font-weight:bold">{m.key}</a></p-->
                        <c:choose>
                            <c:when test="${!fn:contains(DCCNIHAncestorGroupIds, m.key.groupId)}">
                            <optgroup label="${m.key.groupName}">
                                <c:forEach items="${m.value}" var="sg">
                                    <option value="${sg.groupId}">${sg.groupName}</option>
                                </c:forEach>
                            </optgroup >
                            </c:when>
                        </c:choose>



                </c:forEach>
            </select>
        </div>

        <div class="card">
            <span style="font-weight: bold">Groups you selected to share... </span>

            <c:forEach items="${groupMembersMap}" var="map">

                        <div class="group form-group" id="group${map.key.groupId}-study<%=s.getStudyId()%>" style="display: none">
                            <div class="form-group">
                                <span style="color:#007bff;font-weight: 400;font-size: 1rem">${map.key.groupName}:</span>
                                <!--div class="form-check form-check-inline">&nbsp;
                                <input class="form-check-input" type="checkbox" id="all-group${map.key.groupId}-study<%=s.getStudyId()%>" value="option7" checked onchange="toggleSelectedGroupMembers(${map.key.groupId},<%=s.getStudyId()%>)" >
                                <label class="form-check-label" for="all-group${map.key.groupId}-study<%=s.getStudyId()%>" >All</label>
                            </div-->
                            </div>
                            <div class="form-group">
                                <ul class="list-inline">
                                    <c:forEach items="${map.value}" var="p">
                                <div class="form-check form-check-inline" style="display: none">
                                    <input class="form-check-input selectedGroupMember" name="member-group${map.key.groupId}-study<%=s.getStudyId()%>" type="checkbox" id="member${p.id}-group${map.key.groupId}-study<%=s.getStudyId()%>" value="${p.id}" checked>
                                    <label class="form-check-label" for="member${p.id}-group${map.key.groupId}-study<%=s.getStudyId()%>">${p.name}</label>
                                </div>
                                <li class="list-inline-item" style="justify-content: right"><i class="fas fa-circle" style="color:#00AA9E;font-size: xx-small"></i>&nbsp;&nbsp;${p.name}&nbsp;</li>
                                </c:forEach>
                                </ul>
                            </div>

                        </div>


            </c:forEach>

        </div>
        <!--div class="form-group">
        <button>Submit</button>
        </div-->
    <!--/form-->
    </div>
    <div class="card">
        <div class="card-header" style="padding-left:0 ">
            <button class="btn btn-link btn-block text-left" type="button"  aria-expanded="true" onclick="toggleDiv(<%=s.getStudyId()%>)" >
                Groups default to have access...
            </button>
        </div>
        <!--button type="button" class="btn btn-primary" onclick="toggleDiv($-{rec.studyId})">Groups that have access...</button-->
        <div class="card-body" id="collapse<%=s.getStudyId()%>" style="display: none">
            <c:forEach items="${DCCNIHMembersMap}" var="map">
                <div class="group form-group" id="group${map.key.groupId}-study<%=s.getStudyId()%>">
                    <span style="color:steelblue;">${map.key.groupName}:</span>
                    <c:forEach items="${map.value}" var="p">
                        <span>${p.name}</span>
                    </c:forEach>
                </div>
            </c:forEach>
        </div>
    </div>
    </div>


