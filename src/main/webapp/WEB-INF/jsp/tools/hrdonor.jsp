<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.storage.ImageTypes" %>
<%@ page import="edu.mcw.scge.datamodel.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" integrity="sha384-AYmEC3Yw5cVb3ZcuHtOA93w35dYTsvhLPVnYs9eStHfGJvOvKxVfELGroGkvsg+p" crossorigin="anonymous"/>
<style>
    td{
        font-size: 12px;
        padding-left:1%;
    }
    .header{
        font-weight: bold;
        font-size: 12px;
        color:steelblue;
        width: 25%;
        background-color: #ECECF9;
    }

</style>
<script>
    $(function() {
        $("#myTable").tablesorter({
            theme : 'blue'

        });
    });
</script>

<% HRDonor h = (HRDonor) request.getAttribute("hrdonor"); %>

<%
    Access access= new Access();
    Person p = access.getUser(request.getSession());
%>

<div>
    <div>
        <table  style="width:80%">

            <tbody>
            <tr><td class="header"><strong>SCGE ID</strong></td><td><%=h.getId()%></td></tr>
            <tr><td class="header"><strong>Name</strong></td><td><%=h.getLabId()%></td></tr>
            <tr><td class="header"><strong>Description</strong></td><td><%=SFN.parse(h.getDescription())%></td></tr>
            <tr><td class="header"><strong>Source</strong></td><td><%=SFN.parse(h.getSource())%></td></tr>
            <tr><td class="header" width="150"><strong>Type</strong></td><td><%=SFN.parse(h.getType())%></td></tr>
            <tr><td class="header"><strong>Modification</strong></td><td><%=SFN.parse(h.getModification())%></td></tr>
            <tr><td class="header"><strong>Sequence</strong></td><td><%=SFN.parse(h.getSequence())%></td></tr>


        </table>

    </div>
    <hr>
</div>

<%
    long objectId = h.getId();
                            String redirectURL = "/data/hrdonors/hrdonor?id=" + objectId;
    String bucket="main1";
%>
<%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
<% bucket="main2"; %>
<%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
<% bucket="main3"; %>
<%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
<% bucket="main4"; %>
<%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
<% bucket="main5"; %>
<%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
<br>
<div id="associatedProtocols">
    <%@include file="/WEB-INF/jsp/tools/associatedProtocols.jsp"%>
</div>

<br>
<jsp:include page="associatedStudies.jsp"/>
<br>
<hr>
<jsp:include page="associatedExperiments.jsp"/>