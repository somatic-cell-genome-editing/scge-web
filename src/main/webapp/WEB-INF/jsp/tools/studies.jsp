<%@ page import="edu.mcw.scge.datamodel.Study" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="edu.mcw.scge.datamodel.Person" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.process.UI" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="edu.mcw.scge.web.SCGEContext" %>
<%@ page import="edu.mcw.scge.dao.implementation.*" %>
<%@ page import="edu.mcw.scge.datamodel.Experiment" %>
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
<script src="/toolkit/js/study/tablefilters.js"></script>
<script src="/toolkit/js/edit.js"></script>


<% List<Study> studies = (List<Study>) request.getAttribute("studies");
    Map<String, Map<Integer, List<Study>>> sortedStudies= (Map<String, Map<Integer, List<Study>>>) request.getAttribute("sortedStudies");
    Map<Integer, Integer> tierUpdateMap= (Map<Integer, Integer>) request.getAttribute("tierUpdateMap");
    Person person = (Person) request.getAttribute("person");
    GrantDao grantDao = new GrantDao();
    ExperimentRecordDao erdao = new ExperimentRecordDao();
%>
<c:if test="${action!='Dashboard'}">
<!--table align="center">
    <tr>
        <td align="center"><img height="100" width="100" src="/toolkit/images/studyIcon.png" border="0"/></td>
        <td align="center">
            <form class="form-inline my-2 my-lg-0">
                <input size=60 class="form-control " name="searchTerm" type="search" placeholder="Search Studies" aria-label="Search">
                <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
            </form>
        </td>
    </tr>
</table-->
</c:if>
<br>

<div >
    <table id="myTable-1" class="tablesorter table table-sm">
        <thead>
        <tr><th class="tablesorter-header filter-false"></th>
            <th class="tablesorter-header filter-false" width="20">Tier</th>
            <th class="tablesorter-header">SCGE ID</th>
            <th class="tablesorter-header">Grant Title</th>
            <th class="tablesorter-header filter-false">No. of Submissions</th>
            <th class="tablesorter-header">Initiative</th>
            <th class="tablesorter-header">Contact PI</th>

            <th class="tablesorter-header filter-false" >Submission Date</th>
            <th class="tablesorter-header filter-false" >Last Updated Date</th>
            <th class="tablesorter-header filter-false" >Status</th>
        </tr>
        </thead>
<%  int id=1;
    StudyDao studyDao=new StudyDao();
    ExperimentDao experimentDao=new ExperimentDao();
    PersonDao personDao=new PersonDao();
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
        List<Study> studies1= (List<Study>) e.getValue();
        List<Study> studiesByGroupId=studyDao.getStudiesByGroupId(groupId);
  %>
     <% if(studies1.size()>1 || studies1.get(0).getGroupId()==1410){%>

            <tr class="header1" style="display:table-row;">
                <td class="toggle" style="cursor:pointer;text-align:center;" width="20"><i class="fa fa-plus-circle expand" aria-hidden="true" style="font-size:medium;color:green" title="Click to expand"></i></td>
                <td></td>
                <td></td>
                <td ><a href="/toolkit/data/experiments/group/<%=studies1.get(0).getGroupId()%>"><%=grantDao.getGrantByGroupId(studies1.get(0).getGroupId()).getGrantTitle()%></a></td>
                <td><%=studies1.size()%></td>
                <td><%=UI.correctInitiative(grantDao.getGrantByGroupId(studies1.get(0).getGroupId()).getGrantInitiative())%></td>
                <td>
                    <%for(Person pi:studiesByGroupId.get(0).getMultiplePis()){%>
                    <%=pi.getName().replaceAll(","," ")%>&nbsp;<small class="text-muted">(<%=pi.getInstitutionName()%>)</small><br>
                    <% }%>
                    <%--=studyDao.getStudiesByGroupId(groupId).get(0).getPiLastName()%>,&nbsp;<%=studyDao.getStudiesByGroupId(groupId).get(0).getPiFirstName()--%></td>

                <td></td>
                <td></td>
                <td></td>
            </tr>

    <%}%>
        <% for (Study s: studies1) {
            boolean hasRecords=false;
        if (erdao.getExperimentRecordsByStudyId(s.getStudyId()).size() > 0) {
            hasRecords=true;
        }else{

            List<Experiment> experiments=experimentDao.getExperimentsByStudy(s.getStudyId());
            if(experiments!=null && experiments.size()>0){
                hasRecords=true;
            }
        }
            if(studies1.size()>1 || studies1.get(0).getGroupId()==1410) {%>
        <tr class="tablesorter-childRow" >
                <%}else{%>
        <tr class="header1" style="display:table-row;">
        <%}%>
        <td><% if ((access.canUpdateTier(person,s) && !SCGEContext.isTest()) || (SCGEContext.isTest() && access.isDeveloper(person) )){%>

                    <form class="form-row" id="editStudy<%=s.getStudyId()%>" action="/toolkit/edit/access">
                        <div class="col  tiers">
                            <input type="hidden" name="tier" id="tier-study-<%=s.getStudyId()%>" value="<%=tierUpdateMap.get(s.getStudyId())%>"/>
                            <input type="hidden" name="studyId" id="study-<%=s.getStudyId()%>" value="<%=s.getStudyId()%>"/>
                            <input type="hidden" name="groupMembersjson" id="study-<%=s.getStudyId()%>-json"/>
                            <input type="hidden" name="groupIdsJson" id="study-<%=s.getStudyId()%>-groupIdsJson"/>
                            <%if(hasRecords){%>
                            <input type="button" id="updateTier-study<%=s.getStudyId()%>" class="form-control" onclick="changeAccess($(this),<%=s.getStudyId()%> , <%=tierUpdateMap.get(s.getStudyId())%>)" value="Update Tier">
                            <%}%>
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
                <td><%=s.getStudyId()%></td>

            <td>

                <%if(access.hasStudyAccess(s,person)) {
                        if(studies1.get(0).getGroupId()==1410 || studies1.get(0).getGroupId()==1412){// 1410-Baylor;1412-Jackson
                            if(s.getIsValidationStudy()!=1){%>
                <%if(hasRecords){%><a href="/toolkit/data/experiments/group/<%=studies1.get(0).getGroupId()%>#<%=s.getStudyId()%>"><%}%><%=s.getStudy()%> - SCGE-<%=s.getStudyId()%><%if(hasRecords){%></a><%}%>
                           <% }else{%>
                <strong>VALIDATION -</strong>&nbsp; <%if(hasRecords){%><a href="/toolkit/data/experiments/group/<%=studies1.get(0).getGroupId()%>#<%=s.getStudyId()%>"><%}%><%=s.getStudy()%> - SCGE-<%=s.getStudyId()%> <%if(hasRecords){%></a><%}%>
                          <%  }%>
                        <%}else{%>
                            <%if(hasRecords){%><a href="/toolkit/data/experiments/group/<%=s.getGroupId()%>#<%=s.getStudyId()%>"><%}%><%=s.getStudy()%><%if(hasRecords){%></a><%}%>
                        <%}%>
                <%} else {
                    if(s.getIsValidationStudy()!=1){%>
                            <%=s.getStudy()%> - SCGE-<%=s.getStudyId()%>
                        <% }else{%>
                            <strong>VALIDATION -</strong>&nbsp;<%=s.getStudy()%> - SCGE-<%=s.getStudyId()%>
                        <%  }
                }%>


            </td>
            <td>
                <%if(studies1.size()<=1){ %>
                <%=studies1.size()%>
                <%}%>
            </td>
            <td>
                <%if(studies1.size()<=1){ %>
                <%=UI.correctInitiative(grantDao.getGrantByGroupId(s.getGroupId()).getGrantInitiative())%>
                <%}%>
            </td>
            <td style="white-space: nowrap;width:15%">
                <%if(studies1.size()<=1){
                    for(Person pi:s.getMultiplePis())  {%>
                <%=pi.getFirstName()%>,&nbsp;<%=pi.getLastName()%>&nbsp;<small class="text-muted">(<%=pi.getInstitutionName()%>)</small><br>
                   <% }}%>
            </td>

            <td><%=UI.formatDate(s.getSubmissionDate())%></td>
            <td>
                <%if( s.getLastModifiedDate()!=null){%>
                <%=UI.formatDate(s.getLastModifiedDate())%>
                <%}%>
            </td>
            <td>
            <%if (!hasRecords) { %>
                Received
                <%}else{%>
                <span style="color:green" >Processed</span>
               <%} %>
</td>
</tr>

<%}%>

<%}%>

</div>
<%}%>
</table>
</div>
