<%@ page import="edu.mcw.scge.datamodel.Study" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="edu.mcw.scge.datamodel.Person" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.web.UI" %>
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
    optgroup{
       color:cornflowerblue;
        font-weight: bold
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
    Person person = (Person) request.getAttribute("person");
%>
<c:if test="${action!='Dashboard'}">
<table align="center">
    <tr>
        <td align="center"><img height="100" width="100" src="/toolkit/images/studyIcon.png" border="0"/></td>
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

        <%
            Access access = new Access();
        %>

        <% for (Study s: studies) { %>
        <tr>
            <td>
                <% if (access.canUpdateTier(person,s)){%>
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
            <td><%if(access.hasStudyAccess(s,person)) {  %>
                    <a href="/toolkit/data/experiments/study/<%=s.getStudyId()%>"><%=s.getStudy()%></a>
                <%} else { %>
                    <%=s.getStudy()%>
                <% } %>
            </td>
            <td><%=s.getLabName()%></td>
            <td><%=s.getPi()%></td>
            <td><%=UI.formatDate(s.getSubmissionDate())%></td>
        </tr>
        <%}%>
    </table>
</div>
