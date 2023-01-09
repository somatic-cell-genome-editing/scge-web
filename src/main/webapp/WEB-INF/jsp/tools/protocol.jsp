<%@ page import="edu.mcw.scge.datamodel.Model" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.storage.ImageTypes" %>
<%@ page import="edu.mcw.scge.datamodel.Protocol" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/29/2020
  Time: 4:25 PM
  To change this template use File | Settings | File Templates.
--%>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>

<link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" integrity="sha384-AYmEC3Yw5cVb3ZcuHtOA93w35dYTsvhLPVnYs9eStHfGJvOvKxVfELGroGkvsg+p" crossorigin="anonymous"/>
<link href="/toolkit/css/reportPage.css" rel="stylesheet" type="text/css"/>

<script>
    $(function() {
        $("#myTable").tablesorter({
            theme : 'blue'

        });
    });
</script>


<% Protocol p = (Protocol) request.getAttribute("protocol"); %>


<%
    Access access= new Access();
    Person person = access.getUser(request.getSession());

    if (access.isAdmin(person)) {
%>

<div align="right"><a href="/toolkit/data/protocols/edit?id=<%=p.getId()%>"><button class="btn btn-primary">Edit</button></a></div>
<% } %>

<div class="col-md-2 sidenav bg-light">


    <a href="#summary">Summary</a>



    <!--a href="#publications">Related Publications</a-->


</div>
<main role="main" class="col-md-10 ml-sm-auto px-4"  >
    <div id="summary">
        <h4 class="page-header" style="color:grey;">Summary</h4>

        <div class="d-flex bg-light" >

        <table  style="width:100%">
            <tr ><td class="header" valign="top">Title</td><td><%=p.getTitle()%></td></tr>
            <tr><td class="header"  valign="top">Description</td><td><%=p.getDescription()%></td></tr>
            <tr><td class="header" valign="top">Tier</td><td><%=p.getTier()%></td></tr>
            <tr><td class="header" valign="top">File Download</td><td><a href="/toolkit/files/protocol/<%=p.getFilename()%>"><%=p.getFilename()%></a></td></tr>
            <tr><td class="header" valign="top">Additional Information</td><td><%=p.getXref()%></td></tr>
            <tr><td class="header" valign="top">Keywords</td><td><%=p.getKeywords()%></td></tr>
        </table>



            <div class="ml-auto col-3" style="margin-right: 5%">

                <div class="card">
                    <div class="card-body">
                        <table >
                            <tr ><th class="scge-details-label"><%=p.getId()%></th></tr>

                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
<%
    long objectId = p.getId();
    String redirectURL = "/data/protocols/protocol?id=" + objectId;
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

</main>
