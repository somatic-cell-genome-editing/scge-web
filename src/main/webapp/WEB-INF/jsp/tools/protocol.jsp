<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.storage.ImageTypes" %>
<%@ page import="edu.mcw.scge.datamodel.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="edu.mcw.scge.web.SCGEContext" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/29/2020
  Time: 4:25 PM
  To change this template use File | Settings | File Templates.
--%>
<link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" integrity="sha384-AYmEC3Yw5cVb3ZcuHtOA93w35dYTsvhLPVnYs9eStHfGJvOvKxVfELGroGkvsg+p" crossorigin="anonymous"/>
<link href="/toolkit/css/reportPage.css" rel="stylesheet" type="text/css"/>

<script>
    $(function() {
        $("#myTable").tablesorter({
            theme : 'blue'

        });
    });
</script>


<%  Protocol protocol = (Protocol) request.getAttribute("protocol");
    Association protocolAssociation= (Association) request.getAttribute("protocolAssociations");
    Access access= new Access();
    Person p = access.getUser(request.getSession());
    if (access.isAdmin(p) && !SCGEContext.isProduction()) {
%>

<div align="right"><a href="/toolkit/data/protocols/edit?id=<%=protocol.getId()%>"><button class="btn btn-primary">Edit</button></a></div>
<% } %>

<div class="col-md-2 sidenav bg-light">


    <a href="#summary">Summary</a>



    <!--a href="#publications">Related Publications</a-->


</div>
<main role="main" class="col-md-10 ml-sm-auto px-4"  >
    <%@include file="summary.jsp"%>
<%
    long objectId = protocol.getId();
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
    <div>
        <%if(protocolAssociation!=null){
            if(protocolAssociation.getAssociatedEditors()!=null && protocolAssociation.getAssociatedEditors().size()>0){%>
            <h4 class="page-header" style="color:grey;">Associated Editors</h4>
            <ul>
            <%for(Editor editor:protocolAssociation.getAssociatedEditors()){%>
                <li><a href="/toolkit/data/editors/editor?id=<%=editor.getId()%>"><%=editor.getSymbol()%></a></li>
           <%}%>
            </ul>
            <%}}%>
    </div>
    <div>
        <%if(protocolAssociation!=null){
            if(protocolAssociation.getAssociatedGuides()!=null && protocolAssociation.getAssociatedGuides().size()>0){%>
        <h4 class="page-header" style="color:grey;">Associated Guides</h4>
        <ul>
            <%for(Guide guide:protocolAssociation.getAssociatedGuides()){%>
            <li><a href="/toolkit/data/guide/system?id=<%=guide.getGuide_id()%>"><%=guide.getGuide()%></a></li>
            <%}%>
        </ul>
        <%}}%>
    </div>
    <div>
        <%if(protocolAssociation!=null){
            if(protocolAssociation.getAssociatedModels()!=null && protocolAssociation.getAssociatedModels().size()>0){%>
        <h4 class="page-header" style="color:grey;">Associated Models</h4>
        <ul>
            <%for(Model model:protocolAssociation.getAssociatedModels()){%>
            <li><a href="/toolkit/data/models/model/?id=<%=model.getModelId()%>"><%=model.getDisplayName()%>&nbsp;(<%=model.getName()%>)</a></li>
            <%}%>
        </ul>
        <%}}%>
    </div>
    <div>
        <%if(protocolAssociation!=null){
            if(protocolAssociation.getAssociatedDeliverySystems()!=null && protocolAssociation.getAssociatedDeliverySystems().size()>0){%>
        <h4 class="page-header" style="color:grey;">Associated Delivery Systems</h4>
        <ul>
            <%for(Delivery delivery:protocolAssociation.getAssociatedDeliverySystems()){%>
            <li><a href="/toolkit/data/delivery/system?id=<%=delivery.getId()%>"><%=delivery.getName()%></a></li>
            <%}%>
        </ul>
        <%}}%>
    </div>
    <div>
        <%if(protocolAssociation!=null){
            if(protocolAssociation.getAssociatedVectors()!=null && protocolAssociation.getAssociatedVectors().size()>0){%>
        <h4 class="page-header" style="color:grey;">Associated Vectors</h4>
        <ul>
            <%for(edu.mcw.scge.datamodel.Vector vector:protocolAssociation.getAssociatedVectors()){%>
            <li><a href="/toolkit/data/vector/format?id=<%=vector.getVectorId()%>"><%=vector.getName()%></a></li>
            <%}%>
        </ul>
        <%}}%>
    </div>
    <div id="associatedPublications">
        <%@include file="/WEB-INF/jsp/tools/publications/associatedPublications.jsp"%>
    </div>

    <div id="associatedStudies">
        <jsp:include page="associatedStudies.jsp"/>
    </div>
</main>
