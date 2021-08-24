<%@ page import="edu.mcw.scge.datamodel.Study" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="edu.mcw.scge.datamodel.Person" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.web.UI" %>
<%@ page import="edu.mcw.scge.dao.implementation.GrantDao" %>
<%@ page import="edu.mcw.scge.dao.implementation.ExperimentRecordDao" %>
<%@ page import="java.util.HashMap" %>
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
    optgroup{
       color:#1A80B6;
        font-weight: bold
    }
    td{
        display:table-cell
    }
    .tablesorter-childRow td{
        background-color: lightcyan;
    }
</style>
<script>
    $(function() {
        for(var i=1;i<10; i++) {
            $("#myTable-"+i).tablesorter({
                theme: 'blue',
                cssChildRow:"tablesorter-childRow",

            });

        }
        $('.tablesorter-childRow td').hide();

        $('.tablesorter').delegate('.toggle', 'click' ,function() {
            if($(this).find('.fa').hasClass("fa-plus-circle")){
                $(this).find('.fa').removeClass("fa-plus-circle");
                $(this).find('.fa').addClass("fa-minus-circle");
                $(this).find('.fa').css('color', 'red');
                $(this).find('.fa').prop('title', 'Click to collapse');
            }else{
                $(this).find('.fa').removeClass("fa-minus-circle");
                $(this).find('.fa').addClass("fa-plus-circle");
                $(this).find('.fa').css('color', 'green');
                $(this).find('.fa').prop('title', 'Click to expand');
            }
            // use "nextUntil" to toggle multiple child rows
            // toggle table cells instead of the row
            $(this).closest('tr').nextUntil('tr:not(.tablesorter-childRow)').find('td').toggle();
            // in v2.5.12, the parent row now has the class tablesorter-hasChildRow
            // so you can use this code as well
            // $(this).closest('tr').nextUntil('tr.tablesorter-hasChildRow').find('td').toggle();

            return false;
        });

    });
</script>
<script src="/toolkit/js/edit.js"></script>


<% List<Study> studies = (List<Study>) request.getAttribute("studies");
    Map<String, Map<Integer, List<Study>>> sortedStudies= (Map<String, Map<Integer, List<Study>>>) request.getAttribute("sortedStudies");
    Map<Integer, Integer> tierUpdateMap= (Map<Integer, Integer>) request.getAttribute("tierUpdateMap");
    Person person = (Person) request.getAttribute("person");
    GrantDao grantDao = new GrantDao();
    ExperimentRecordDao erdao = new ExperimentRecordDao();
%>
<c:if test="${action!='Dashboard'}">
<table align="center">
    <tr>
        <td align="center"><img height="100" width="100" src="/toolkit/images/studyIcon.png" border="0"/></td>
        <td align="center">
            <form class="form-inline my-2 my-lg-0">
                <input size=60 class="form-control " name="searchTerm" type="search" placeholder="Search Studies" aria-label="Search">
                <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
            </form>
        </td>
    </tr>
</table>
</c:if>
<br>
<div >
    <table id="myTable-1" class="tablesorter">
        <thead>
        <tr><th></th>
            <th width="20">Tier</th>
            <th>Grant Title</th>
            <th>Initiative</th>
            <th>Contact PI</th>
            <th>Institution</th>

            <th>Submission Date</th>
            <th>Last Updated Date</th>
        </tr>
        </thead>
<%  int id=1;
    for(Map.Entry entry:sortedStudies.entrySet()){
    String grantInitiative= (String) entry.getKey();
    Map<Integer, List<Study>> groupedStudies= (Map<Integer, List<Study>>) entry.getValue();
    %>
<div>


        <%
            Access access = new Access();
        %>
  <%  for(Map.Entry e:groupedStudies.entrySet()){
        int groupId= (int) e.getKey();
        List<Study> studies1= (List<Study>) e.getValue();%>
     <% if(studies1.size()>1){%>

            <tr class="header1" style="display:table-row;">
                <td class="toggle" style="cursor:pointer;text-align:center;" width="20"><i class="fa fa-plus-circle expand" aria-hidden="true" style="font-size:medium;color:green" title="Click to expand"></i></td>
                <td></td>
                <td ><%=studies1.get(0).getStudy()%><span style="color:orange;font-weight: bold"><%="("+studies1.size()+" submissions)"%></span></td>
                <td><%=UI.correctInitiative(grantDao.getGrantByGroupId(studies1.get(0).getGroupId()).getGrantInitiative())%></td>
                <td><%=UI.formatName(studies1.get(0).getPi())%></td>
                <td><%=studies1.get(0).getLabName()%></td>
                <td></td>
                <td></td>
            </tr>

    <%}%>
        <% for (Study s: studies1) {
            if(studies1.size()>1) {%>
        <tr class="tablesorter-childRow" >
                <%}else{%>
        <tr class="header1" style="display:table-row;">
        <%}%>
        <td><% if (access.canUpdateTier(person,s)){%>
                    <form class="form-row" id="editStudy<%=s.getStudyId()%>" action="edit/access">
                        <div class="col  tiers">
                            <input type="hidden" name="tier" id="tier-study-<%=s.getStudyId()%>" value="<%=tierUpdateMap.get(s.getStudyId())%>"/>
                            <input type="hidden" name="studyId" id="study-<%=s.getStudyId()%>" value="<%=s.getStudyId()%>"/>
                            <input type="hidden" name="groupMembersjson" id="study-<%=s.getStudyId()%>-json"/>
                            <input type="hidden" name="groupIdsJson" id="study-<%=s.getStudyId()%>-groupIdsJson"/>
                            <input type="button" id="updateTier-study<%=s.getStudyId()%>" class="form-control" onclick="changeAccess($(this),<%=s.getStudyId()%> , <%=tierUpdateMap.get(s.getStudyId())%>)" value="Update Tier">
                        </div>
                    </form>
                <div>
                    <div class="modal" id="tier2Modal<%=s.getStudyId()%>">
                        <%@include file="../dashboardElements/tier2Modal.jsp"%>
                    </div>
                    <script>
                        $(document).ready(function () {
                            buildModel(<%=s.getStudyId()%>, <%=s.getAssociatedGroups()%>, <%=tierUpdateMap.get(s.getStudyId())%>)

                        })
                    </script>
                </div>
                        <%}%>

                </td>
                <td width="20">
                    <%=s.getTier()%>
                </td>

            <%  boolean hasRecords=false;
                if (erdao.getExperimentRecordsByStudyId(s.getStudyId()).size() > 0) {
                      hasRecords=true;
               }
            %>
            <td>

                <%if(access.hasStudyAccess(s,person)) {if(studies1.size()>1) { %>
                    <%-- if (!hasRecords) { %>
                    <%=s.getStudy()%>
                        <span style="font-size:10px;">(Submission Received: Processing)</span>
                    <% } else { --%>
                        <a href="/toolkit/data/experiments/study/<%=s.getStudyId()%>">Submission SCGE-<%=s.getStudyId()%></a>
                    <%-- } --%>
                    <%}else{%>
                    <a href="/toolkit/data/experiments/study/<%=s.getStudyId()%>"><%=s.getStudy()%></a>

                <%}%>
                <%} else { if(studies1.size()>1){ %>
                    Submission SCGE-<%=s.getStudyId()%>
                <%}else%>
                <%=s.getStudy()%>

                <% } %>
            </td>
            <td>
                <%if(studies1.size()<=1){ %>
                <%=UI.correctInitiative(grantDao.getGrantByGroupId(s.getGroupId()).getGrantInitiative())%>
                <%}%>
            </td>
            <td style="white-space: nowrap;width:15%">
                <%if(studies1.size()<=1){ %>
                <%=UI.formatName(s.getPi())%>
                <%}%>
            </td>
            <td>
                <%if(studies1.size()<=1){ %>
                <%=s.getLabName()%>
                <%}%>
            </td>
            <td><%=UI.formatDate(s.getSubmissionDate())%></td>
            <td>
                <%if( s.getLastModifiedDate()!=null){%>
                <%=UI.formatDate(s.getLastModifiedDate())%>
                <%}%>
            </td>

        </tr>

        <%}%>

            <%}%>

</div>
<%}%>
    </table>
</div>
