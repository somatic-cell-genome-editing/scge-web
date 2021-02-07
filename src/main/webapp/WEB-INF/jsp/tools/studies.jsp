<%@ page import="edu.mcw.scge.datamodel.Study" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Map" %>
<%@ page import="edu.mcw.scge.datamodel.PersonInfo" %>
<%@ page import="edu.mcw.scge.datamodel.Person" %>
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





<% List<Study> studies = (List<Study>) request.getAttribute("studies");
    Map<Integer, Integer> tierUpdateMap= (Map<Integer, Integer>) request.getAttribute("tierUpdateMap");
    List<PersonInfo> personInfoRecords= (List<PersonInfo>) request.getAttribute("personInfoRecords");
%>
<c:if test="${action!='Dashboard'}">
<table align="center">
    <tr>
        <td align="center"><img height="100" width="100" src="https://scge.mcw.edu/wp-content/uploads/2019/06/Editor-rev.png" border="0"/></td>
        <td align="center">
            <form class="form-inline my-2 my-lg-0">
                <input size=60 class="form-control " type="search" placeholder="Search Studies" aria-label="Search">
                <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
            </form>
        </td>
    </tr>
</table>
</c:if>
<br>


<div>
    <table id="myTable" class="tablesorter">
        <thead>
        <tr><th></th>
            <th width="20">Tier</th>
            <th>Name</th>
            <th>Institution</th>
            <th>Contact PI</th>
            <th>Submission Date</th>
        </tr>
        </thead>

        <% for (Study s: studies) {
        boolean hasUpdateAction=false;
            for(PersonInfo i:personInfoRecords){
                if(s.getGroupId()==i.getSubGroupId()){
                    hasUpdateAction=true;
                }
            }
        %>
        <tr>
            <!--td><input class="form" type="checkbox"></td-->
            <!--td><button class="btn btn-outline-secondary btn-sm">Edit</button></td-->

                <td>

                    <!--c:if test="$-{userAttributes.get('name')!=null && personInfoRecords.get(0).personId==personId}"-->
                    <c:if test="${userAttributes.get('name')!=null}">

                    <%if(hasUpdateAction){%>
                    <form class="form-row" id="editStudy<%=s.getStudyId()%>" action="edit/access">
                        <div class="col  tiers">
                            <% int tier=0;
                                if(tierUpdateMap!=null && tierUpdateMap.get(s.getStudyId())!=null){
                                    tier=tierUpdateMap.get(s.getStudyId());
                                }
                                else
                                    tier=s.getTier();
                            %>
                            <input type="hidden" name="tier" id="tier-study-<%=s.getStudyId()%>" value="<%=tier%>"/>
                            <input type="hidden" name="studyId" id="study-<%=s.getStudyId()%>" value="<%=s.getStudyId()%>"/>
                            <input type="hidden" name="groupMembersjson" id="study-<%=s.getStudyId()%>-json"/>
                            <input type="hidden" name="groupIdsJson" id="study-<%=s.getStudyId()%>-groupIdsJson"/>
                            <input type="button" id="updateTier-study<%=s.getStudyId()%>" class="form-control" onclick="changeAccess($(this),<%=s.getStudyId()%> , <%=s.getTier()%>)" value="Update Tier">
                        </div>
                    </form>
                    <div>
                        <%@include file="../dashboardElements/tier2Modal.jsp"%>
                        <script>
                            $(document).ready(function () {
                                $("#groupSelect-study<%=s.getStudyId()%>").multiselect({
                                    buttonWidth: '100%',
                                    onChange: function(option, checked, select) {
                                        $('#SaveChangesTier2-study<%=s.getStudyId()%>').prop('disabled', false)
                                        var value= ($(option).val());
                                        var $div="#group"+value+"-study<%=s.getStudyId()%>";
                                        //  $($div).show(2000);
                                        $($div).toggle()
                                    }
                                });
                                var valArr = <%=s.getAssociatedGroups()%>;
                                var i = 0, size = valArr.length;
                                for (i; i < size; i++) {
                                    $("#groupSelect-study<%=s.getStudyId()%>").multiselect('select', valArr[i]);
                                    var $div="#group"+valArr[i]+"-study<%=s.getStudyId()%>";
                                    $($div).show()
                                }
                                $('input:radio[name="tier<%=s.getStudyId()%>"]').filter('[value=<%=s.getTier()%>]').attr('checked', true)

                                $('input[name=tier<%=s.getStudyId()%>]').on('change', function () {
                                    var tier=$(this).val();
                                    setParameters(studyId, tier)
                                    enableSaveChanges(studyId, tier.trim());

                                })
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
                                $('#study-'+studyId+'-memberJson').val(json);
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
                        <%}%>
                    </c:if>

                </td>
                <td width="20">
                    <%=s.getTier()%>
                </td>
            <td><%if(hasUpdateAction)  {%><a href="/toolkit/data/experiments/study/<%=s.getStudyId()%>"><%}%><%=s.getStudy()%>
                <%if(hasUpdateAction)  {%></a><%}%>
            </td>
            <td><%=s.getLabName()%></td>
            <td><%=s.getPi()%></td>
            <td><%=s.getSubmissionDate()%></td>
        </tr>
        <%}%>


    </table>
</div>
