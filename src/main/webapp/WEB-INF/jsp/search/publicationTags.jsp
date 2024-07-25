<%@ page import="edu.mcw.scge.dao.implementation.AssociationDao" %>
<%@ page import="edu.mcw.scge.datamodel.Association" %>
<%@ page import="edu.mcw.scge.datamodel.Model" %>
<%@ page import="edu.mcw.scge.datamodel.Editor" %>
<%@ page import="edu.mcw.scge.datamodel.Delivery" %>
<%@ page import="edu.mcw.scge.datamodel.Vector" %><%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 6/11/2024
  Time: 12:19 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    AssociationDao associationDao=new AssociationDao();

    Association association=null;
    if(hit.get("id")!=null) {
        int refKey = (int) hit.get("id");
        try {
             association= associationDao.getPublicationAssociations(refKey);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

    }

    if(association!=null){

%>
<br><strong>SCGE data tags...</strong>

<div class="container">
    <%
        if(association.getAssociatedModels().size()>0 ) {%>
    <strong>Organisms:</strong>
    <%
        for(Model model:association.getAssociatedModels()){%>
    <%=model.getOrganism()%>;
    <%}%>
    <br><strong>Models:</strong>
    <%
        for(Model model:association.getAssociatedModels()){%>
    <a href="/toolkit/data/models/model/?id=<%=model.getModelId()%>"><%=model.getDisplayName()%></a>;
        <%}%>

       <% }%>
    <%
        if(association.getAssociatedEditors().size()>0){
    %>
    <br>  <strong>Editors</strong>
    <%
        for(Editor editor:association.getAssociatedEditors()){
    %>
    <a href="/toolkit/data/editors/editor?id=<%=editor.getId()%>"><%=editor.getSymbol()%></a>;
    <% }}%>
    <%
        if(association.getAssociatedDeliverySystems().size()>0){
    %>
    <br>  <strong>Delivery System</strong>
    <%
        for(Delivery delivery:association.getAssociatedDeliverySystems()){%>
    <a href="/toolkit/data/delivery/system?id=<%=delivery.getId()%>"><%=delivery.getName()%></a>;
    <%}}%>
    <%
        if(association.getAssociatedVectors().size()>0){
    %>
    <br>  <strong>Vectors</strong>
    <%
        for(Vector vector:association.getAssociatedVectors()){%>
    <a href="/toolkit/data/vector/format?id=<%=vector.getVectorId()%>"><%=vector.getName()%></a>;
    <%}}%>
    <%
        if(association.getAssociatedGuides().size()>0){
    %>
    <br>  <strong>Guides</strong>
    <%
        for(Guide guide:association.getAssociatedGuides()){%>
    <a href=""><%=guide.getGuide()%></a>;
    <%}}%>
    <%
        if(studyNames.size()>0 || experimentNames.size()>0){%>
    <%if(hit.get("category").toString().equalsIgnoreCase("Publication")){%>
    <div style="padding-top: 1%">
        
        <strong>Projects</strong>
        <ul>
            <%for(Map.Entry entry:studyNames.entrySet()){%>
            <li><a class="search-results-anchor" href="/toolkit/data/experiments/study/<%=entry.getKey()%>"><%=entry.getValue()%></a>
            </li>

            <%}%>
        </ul>



    </div>

    <%}}%>
    <%}%>


</div>