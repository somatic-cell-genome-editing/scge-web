<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 11/2/2020
  Time: 8:03 AM
  To change this template use File | Settings | File Templates.
--%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.16/css/bootstrap-multiselect.css" type="text/css"/>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.16/js/bootstrap-multiselect.js"></script>

<script>


        $('#groupSelect').multiSelect();
</script>

<div class="wrapper" align="center">
<div class="card"  style=" border:1px solid gainsboro;padding:0" align="left">
    <div class="card-header text-white" style="background-color: #00AA9E;text-align: center;font-weight: bold">
        Change Access Teir
    </div>
    <div class="card-body">
    <form id="tier2Form${rec.studyId}">
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

    Access Tier: <div class="form-check form-check-inline">
    <input class="form-check-input" type="radio" name="inlineRadioOptions" id="inlineRadio1" value="option1" disabled>
    <label class="form-check-label" for="inlineRadio1">1</label>
</div>
    <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="inlineRadioOptions" id="inlineRadio2" value="option2" checked>
        <label class="form-check-label" for="inlineRadio2">2</label>
    </div>
    <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="inlineRadioOptions" id="inlineRadio3" value="option3" disabled>
        <label class="form-check-label" for="inlineRadio3">3 </label>
    </div>
    <div class="form-check form-check-inline">
        <input class="form-check-input" type="radio" name="inlineRadioOptions" id="inlineRadio4" value="option3" disabled>
        <label class="form-check-label" for="inlineRadio4">4 </label>
    </div>
        <div class="form-group">
            <label for="groupSelect">Select Group</label>
                <select id="groupSelect" class="form-control" multiple="multiple" >
                <option selected>Choose...</option>
                <!--option>Group1</option>
                <option>Group2</option>
                <option>Group3</option>
                <option>Group4</option-->
                <c:forEach items="${groupsMap1}" var="m">
                    <!--p><a href="members?group=$-{m.key}" style="font-weight:bold">{m.key}</a></p-->

                        <c:forEach items="${m.value}" var="sg">
                            <option value="${sg.groupId}">${sg.groupName}</option>
                        </c:forEach>


                </c:forEach>
            </select>
        </div>
       <div class="form-group">
        Select Members:<div class="form-check form-check-inline">
           <input class="form-check-input" type="checkbox" id="all" value="option7" checked>
           <label class="form-check-label" for="all" >All</label>
       </div><br>
       </div>

        <div class="card">
            <c:forEach items="${groupMembersMap}" var="map">
                <div class="group form-group" id="group${map.key}" style="display: none">
                    <c:forEach items="${map.value}" var="p">
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="checkbox" id="member${p.id}" value="option3" checked>
                            <label class="form-check-label" for="member${p.id}">${p.name}</label>
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
</div>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.16/css/bootstrap-multiselect.css" type="text/css"/>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.16/js/bootstrap-multiselect.js"></script>