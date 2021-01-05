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
<script>
    $(function() {
        $("#myTable").tablesorter({
            theme : 'blue'

        });
    });
</script>
<script src="/toolkit/js/edit.js"></script>
<div>
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
        <th>Raw_Data</th>
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
            <form class="form-row" id="editStudy${rec.studyId}" action="/toolkit/edit/access" >
                <div class="col  tiers">
                    <input type="hidden" name="tier" id="tier-study-${rec.studyId}" value="${rec.tier}"/>
                    <input type="hidden" name="studyId" id="study-${rec.studyId}" value="${rec.studyId}"/>
                    <input type="hidden" name="groupMembersjson" id="study-${rec.studyId}-json"/>
                    <input type="hidden" name="groupIdsJson" id="study-${rec.studyId}-groupIdsJson"/>


                    <input type="button" id="updateTier-study${rec.studyId}" class="form-control" onclick="changeAccess($(this),${rec.studyId} , ${rec.tier})" value="Update Tier">
                </div>
                <%@include file="../dashboardElements/tier2Modal.jsp"%>

            </form>
            <div>
                <script>
                    $(document).ready(function () {

                        $("#groupSelect-study${rec.studyId}").multiselect({
                            buttonWidth: '100%',

                            onChange: function(option, checked, select) {
                                //      alert('Changed option ' + $(option).val() + '.');
                                $('#SaveChangesTier2-study${rec.studyId}').prop('disabled', false)
                                var value= ($(option).val());
                                //   alert("VALUE: "+ value);
                                var $div="#group"+value+"-study${rec.studyId}";
                                // alert($div)

                                //  $($div).show(2000);
                                $($div).toggle()
                            }
                        });
                        var valArr=${rec.associatedGroups}
                            console.log("PRE SELECTED GROUPS:"+ valArr);
                        var i = 0, size = valArr.length;
                        for(i; i < size; i++){
                            $("#groupSelect-study${rec.studyId}").multiselect().find(":checkbox[value='"+valArr[i]+"']").attr("checked","checked");
                            $("#groupSelect-study${rec.studyId} option[value='" + valArr[i] + "']").attr("selected", 1);
                            $("#groupSelect-study${rec.studyId}").multiselect("refresh");
                            var $div="#group"+valArr[i]+"-study${rec.studyId}";
                            $($div).show();
                        }
                    })
                    function enableGroupSelect(studyId, tier){
                        var selectBtn='#groupSelect-study'+studyId
                        if(tier===2) {
                            $(selectBtn).multiselect('enable')
                        }
                    }
                    function enableSaveChanges(studyId, tier){
                        $('#SaveChangesTier2-study'+studyId).prop('disabled', false)
                        if(tier==='2')
                        $('#groupSelect-study'+studyId).multiselect('enable')
                        else{
                            $('#groupSelect-study'+studyId).multiselect('disable')

                        }
                    }
                    function setParameters(studyId,tier){
                        console.log("TIER: "+ tier);
                        $('#tier-study-'+studyId).val(tier);
                    }
                    function appendGroups(studyId){
                        var values=$('#groupSelect-study'+studyId).val() || [];
                       // alert(values.join(","))
                        var json="{\"selected\":[";
                        var flag=true;
                        $.each(values, function( index, value ) {
                          //  alert( index + ": " + value );
                            if(flag){
                                flag=false;
                                json=json+"{\"groupId\":\""+value+"\", \"members\":["
                            }else{
                                json=json+",{\"groupId\":\""+value+"\", \"members\":["
                            }
                            var first=true;
                            var _name='member-group'+value+'-study'+studyId;
                            $.each($('input[name='+_name+']:checked'), function() {
                          //   console.log("GROUP-"+ value+":\t"+$(this).val());
                                if(first) {
                                    json = json + $(this).val() ;
                                    first=false;
                                }
                                else
                                    json=json+","+$(this).val();

                            });

                            json=json+"]}"
                        });
                        json=json+"]}"
                        $('#study-'+studyId+'-json').val(json);
                        console.log(json);
                    }
                    function appendGroupIds(studyId){
                        var values=$('#groupSelect-study'+studyId).val() || [];
                        // alert(values.join(","))
                        var json="{\"selected\":[";
                        var flag=true;
                        $.each(values, function( index, value ) {
                            //  alert( index + ": " + value );
                            if(flag){
                                flag=false;
                                json=json+value
                            }else{
                                json=json+","+value
                            }

                        });
                        json=json+"]}"
                        $('#study-'+studyId+'-groupIdsJson').val(json);
                        console.log(json);
                    }
                </script>

            </div>
        </td>
            <td style="width: 10%">
                    ${rec.tier}
            </td>
        </c:if>
        <td><a href="/toolkit/data/experiments/search/${rec.studyId}">${rec.study}</a></td>
        <td>${rec.type}</td>
        <td>${rec.labName}</td>
        <td>${rec.pi}</td>
        <td>${rec.submitter}</td>
        <td><a href="${rec.rawData}">link</a></td>
        <td>${rec.submissionDate}</td>
        <td>${rec.studyId}</td>


</c:forEach>
    </tr>
</table>
</div>
