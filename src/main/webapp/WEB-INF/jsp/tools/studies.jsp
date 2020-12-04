<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/29/2020
  Time: 4:25 PM
  To change this template use File | Settings | File Templates.
--%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.16/css/bootstrap-multiselect.css" type="text/css"/>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.16/js/bootstrap-multiselect.js"></script>

<style>
    td{
        font-size: 12px;
    }
    .tiers{
        padding:0;
    }
    #updateTier{
        padding: 0;
    }
    .dropdown-menu {
        max-height: 200px;
        width:100%;
        overflow-y: auto;
        overflow-x: auto;
    }

</style>
<script src="/scgeweb/js/edit.js"></script>

<div>
<div style="float:left;width:20%"><p style="color:steelblue;font-weight: bold;font-size: 20px">Studies: ${fn:length(studies)}</p></div>

<!--div style="float:right; width:8%;padding-bottom: 10px"><button class="btn btn-primary" >Compare</button></div-->
</div>
    <table id="myTable" class="tablesorter">
    <thead>
    <tr><!--th>Select</th-->
        <!--th>Action</th-->
        <c:if test="${userName!=null}">
            <th>Action</th>
            <th>Tier</th>
        </c:if>

        <th>Study_Name</th>
        <th>Type</th>
        <th>Laboratory</th>
        <th>PI</th>
        <th>Submitter</th>
        <th>Submission_Date</th>

        <th>Study_ID</th>

    </tr>
    </thead>
    <c:forEach items="${studies}" var="rec">
    <tr>
        <!--td><input class="form" type="checkbox"></td-->
        <!--td><button class="btn btn-outline-secondary btn-sm">Edit</button></td-->
        <c:if test="${userName!=null}">
        <td>
            <form class="form-row" id="editStudy${rec.studyId}" action="edit/access">


            <div class="col  tiers">
            <input type="button" id="updateTier-study${rec.studyId}" class="form-control" onclick="changeAccess($(this),${rec.studyId} , ${rec.tier})" value="Update Tier">
        </div>
            </form></td>
            <div>
                <%@include file="../dashboardElements/tierOtherModal.jsp"%>

            </div>
            <div>
                <script>
                    $(document).ready(function () {
                        $("#groupSelect-study${rec.studyId}").multiselect({
                            buttonWidth: '100%',
                            onChange: function(option, checked, select) {
                                //      alert('Changed option ' + $(option).val() + '.');
                                var value= ($(option).val());
                                //     alert("VALUE: "+ value);
                                var $div="#group"+value+"-study${rec.studyId}";
                                // alert($div)

                                //  $($div).show(2000);
                                $($div).toggle()
                            }
                        });
                    })
                    function enableGroupSelect(studyId, tier){
                        var selectBtn='#groupSelect-study'+studyId
                        if(tier===2) {
                            $(selectBtn).multiselect('enable')
                        }
                    }
                    function enableSaveChanges(studyId, tier){
                        $('#SaveChangesTier2-study'+studyId).prop('disabled', false)
                        console.log("TIER: "+ tier);
                        if(tier==='2')
                        $('#groupSelect-study'+studyId).multiselect('enable')
                        else{
                            $('#groupSelect-study'+studyId).multiselect('disable')

                        }
                    }
                </script>
                <%@include file="../dashboardElements/tier2Modal.jsp"%>

            </div>
        </c:if>
        <td style="width: 10%">
            ${rec.tier}
        </td>
        <td><a href="/scgeweb/toolkit/studies/search/${rec.studyId}">${rec.study}</a></td>
        <td>${rec.type}</td>
        <td>${rec.labName}</td>
        <td>${rec.pi}</td>
        <td>${rec.submitter}</td>
        <td>${rec.submissionDate}</td>
        <td>${rec.studyId}</td>
    </tr>

</c:forEach>

</table>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.16/css/bootstrap-multiselect.css" type="text/css"/>
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.16/js/bootstrap-multiselect.js"></script>
<!--div style="float:right; width:8%;padding-bottom: 10px"><button class="btn btn-primary" >Compare</button></div-->
