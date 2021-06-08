<%@ page import="edu.mcw.scge.datamodel.Experiment" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.datamodel.Study" %>
<%@ page import="edu.mcw.scge.web.UI" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.datamodel.Person" %>
<%@ page import="edu.mcw.scge.dao.implementation.StudyDao" %>

<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/29/2020
  Time: 4:25 PM
  To change this template use File | Settings | File Templates.
--%>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
<link href="/common/tableSorter/css/filter.formatter.css" rel="stylesheet" type="text/css"/>
<link href="/common/tableSorter/css/theme.jui.css" rel="stylesheet" type="text/css"/>
<link href="/common/tableSorter/css/theme.blue.css" rel="stylesheet" type="text/css"/>

<script src="/common/tableSorter/js/tablesorter.js"> </script>
<script src="/common/tableSorter/js/jquery.tablesorter.widgets.js"></script>
<link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" integrity="sha384-AYmEC3Yw5cVb3ZcuHtOA93w35dYTsvhLPVnYs9eStHfGJvOvKxVfELGroGkvsg+p" crossorigin="anonymous"/>
<style>
    td{
        font-size: 12px;
    }
    .desc {
        font-size:14px;
    }
</style>
<script>
    $(function() {
        $("#myTable").tablesorter({
            theme : 'blue'

        });
    });
</script>


<% try { %>


<div>
    <%
        Access access = new Access();
        StudyDao sdao = new StudyDao();
        Person p = access.getUser(request.getSession());
        List<Experiment> experiments = (List<Experiment>) request.getAttribute("experiments");
        Study study = null;
        System.out.println("1");
        if (request.getAttribute("study") != null) {
            study = (Study) request.getAttribute("study");
        }
        System.out.println("2");

    %>

    <% if (study != null) { %>
    <table width="95%">
    <tr>
        <td>
    <table>
        <tr>
            <td class="desc" style="font-weight:700;"><%=study.getStudy()%>:</td>
            <td>&nbsp;&nbsp;&nbsp;</td>
            <td class="desc"   style="font-weight:700;">PI:</td>
            <td class="desc" ><%=study.getPi()%></td>
            <td>&nbsp;&nbsp;&nbsp;</td>
            <td class="desc"  style="font-weight:700;">Submission Date:</td>
            <td class="desc" ><%=UI.formatDate(study.getSubmissionDate())%></td>
            <%
                if(study.getStudyId() == 1013) {
            %>
            <td>&nbsp;&nbsp;&nbsp;</td>
            <td class="desc" style="font-weight:700;" ><a href="/toolkit/data/experiments/experiment/compareExperiments/8/9">Compare experiments</a></td>
            <%}%>
        </td>
            </td>
        </tr>
    </table>
        </td>
        <td align="right">
            <input type="button" value="Download Submitted Data" onclick="javascript:location.href='/toolkit/download/<%=study.getStudyId()%>'"/>
        </td>
    </tr>
</table>

<% } %>

    <table id="myTable" class="table tablesorter table-striped">
    <thead>
    <tr>
        <th>Tier</th>
        <th>Study</th>
    <th>Name</th>
    <th>Type</th>
        <th>Contact PI</th>
        <th>SCGE ID</th>
    </tr>
    </thead>

        <% for (Experiment exp: experiments) {
            System.out.println(exp.getStudyId());
            Study s = sdao.getStudyById(exp.getStudyId()).get(0);
        %>

        <% if (access.hasStudyAccess(s,p)) { %>

    <tr>
        <td width="10"><%=s.getTier()%></td>
        <td><%=s.getStudy()%></td>
        <td><a href="/toolkit/data/experiments/experiment/<%=exp.getExperimentId()%>"><%=exp.getName()%></a></td>
        <td><%=exp.getType()%></td>
        <td><%=s.getPi()%></td>
        <td><%=exp.getExperimentId()%></td>
    </tr>
        <% } %>
        <% } %>
    </table>


            <%
    int objectId = study.getStudyId();
    String objectType="study";
    String redirectURL = "/data/experiments/study/" + objectId;
%>




<%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>



    <% } catch (Exception es) {
            es.printStackTrace();

        } %>