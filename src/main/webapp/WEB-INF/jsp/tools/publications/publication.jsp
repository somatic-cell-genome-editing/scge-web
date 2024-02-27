<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 2/26/2024
  Time: 3:32 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.storage.ImageTypes" %>
<%@ page import="edu.mcw.scge.datamodel.*" %>
<%@ page import="java.util.Vector" %>
<%@ page import="edu.mcw.scge.web.SCGEContext" %>
<%@ page import="edu.mcw.scge.datamodel.publications.Reference" %>
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


<%  Reference publication = (Reference) request.getAttribute("publication");
    Association association= (Association) request.getAttribute("publicationAssoications");
    Access access= new Access();
    Person p = access.getUser(request.getSession());
    if (access.isAdmin(p) && !SCGEContext.isProduction()) {
%>

<%--<div align="right"><a href="/toolkit/data/protocols/edit?id=<%=publication.getKey()%>"><button class="btn btn-primary">Edit</button></a></div>--%>
<% } %>


<div class="container"  >
<%--    <%@include file="../summary.jsp"%>--%>
    <h4>${pub.reference.title}</h4>
    <%@include file="referenceDetails.jsp"%>
    <hr>
    <%
        long objectId = publication.getKey();
        String redirectURL = "/data/publications/publication?id=" + objectId;
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
        <%if(association!=null){
            if(association.getAssociatedEditors()!=null && association.getAssociatedEditors().size()>0){%>
        <h4 class="page-header" style="color:grey;">Associated Editors</h4>
        <ul>
            <%for(Editor editor:association.getAssociatedEditors()){%>
            <li><a href="/toolkit/data/editors/editor?id=<%=editor.getId()%>"><%=editor.getSymbol()%></a></li>
            <%}%>
        </ul>
        <%}}%>
    </div>
    <div>
        <%if(association!=null){
            if(association.getAssociatedGuides()!=null && association.getAssociatedGuides().size()>0){%>
        <h4 class="page-header" style="color:grey;">Associated Guides</h4>
        <ul>
            <%for(Guide guide:association.getAssociatedGuides()){%>
            <li><a href="/toolkit/data/guide/system?id=<%=guide.getGuide_id()%>"><%=guide.getGuide()%></a></li>
            <%}%>
        </ul>
        <%}}%>
    </div>
    <div>
        <%if(association!=null){
            if(association.getAssociatedModels()!=null && association.getAssociatedModels().size()>0){%>
        <h4 class="page-header" style="color:grey;">Associated Models</h4>
        <ul>
            <%for(Model model:association.getAssociatedModels()){%>
            <li><a href="/toolkit/data/models/model/?id=<%=model.getModelId()%>"><%=model.getDisplayName()%>&nbsp;(<%=model.getName()%>)</a></li>
            <%}%>
        </ul>
        <%}}%>
    </div>
    <div>
        <%if(association!=null){
            if(association.getAssociatedDeliverySystems()!=null && association.getAssociatedDeliverySystems().size()>0){%>
        <h4 class="page-header" style="color:grey;">Associated Delivery Systems</h4>
        <ul>
            <%for(Delivery delivery:association.getAssociatedDeliverySystems()){%>
            <li><a href="/toolkit/data/delivery/system?id=<%=delivery.getId()%>"><%=delivery.getName()%></a></li>
            <%}%>
        </ul>
        <%}}%>
    </div>
    <div>
        <%if(association!=null){
            if(association.getAssociatedVectors()!=null && association.getAssociatedVectors().size()>0){%>
        <h4 class="page-header" style="color:grey;">Associated Vectors</h4>
        <ul>
            <%for(edu.mcw.scge.datamodel.Vector vector:association.getAssociatedVectors()){%>
            <li><a href="/toolkit/data/vector/format?id=<%=vector.getVectorId()%>"><%=vector.getName()%></a></li>
            <%}%>
        </ul>
        <%}}%>
    </div>
<%--    <div id="associatedPublications">--%>
<%--        <%@include file="/WEB-INF/jsp/tools/publications/associatedPublications.jsp"%>--%>
<%--    </div>--%>

    <div id="associatedStudies">
        <jsp:include page="../associatedStudies.jsp"/>
    </div>
</div>
