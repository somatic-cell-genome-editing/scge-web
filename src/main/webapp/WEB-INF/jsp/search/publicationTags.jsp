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
<style>
    .data-tags ul{
        padding: 0;
        margin: 0;
    }

</style>
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

    if(association!=null){%>
    <details>

        <!-- html summary tag is used here -->
        <summary><small>SCGE data tags...</small></summary>
        <p>
        <div class="card" >
        <div class="card-body">
            <div class="container data-tags">
            <%if(association.getAssociatedModels().size()>0 ) {%>
            <div class="row">
                <div class="col-sm-2"><strong>Organisms:</strong></div>
                <div class="col">
                    <ul><li style="list-style-type: none">
                        <%for(Model model:association.getAssociatedModels()){%>
                        <%=model.getOrganism()%>;
                        <%}%>
                    </li>
                    </ul>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-2"><strong>Models:</strong></div>
                <div class="col">
                    <ul><li style="list-style-type: none">
                        <%for(Model model:association.getAssociatedModels()){%>
                        <a href="/toolkit/data/models/model/?id=<%=model.getModelId()%>"><%=model.getDisplayName()%></a>;
                        <%}%>
                    </li></ul>
                </div>
            </div>
            <% }%>
            <%if(association.getAssociatedEditors().size()>0){%>
            <div class="row">
                <div class="col-sm-2"><strong>Editors</strong></div>
                <div class="col">
                    <ul><li style="list-style-type: none">
                        <%for(Editor editor:association.getAssociatedEditors()){%>
                        <a href="/toolkit/data/editors/editor?id=<%=editor.getId()%>"><%=editor.getSymbol()%></a>;
                        <% }%>
                    </li></ul>
                </div>
            </div>
            <% }%>

            <%if(association.getAssociatedDeliverySystems().size()>0){%>
            <div class="row">
                <div class="col-sm-2  text-nowrap"><strong>Delivery System</strong></div>
                <div class="col">
                    <ul><li style="list-style-type: none">
                        <%for(Delivery delivery:association.getAssociatedDeliverySystems()){%>
                        <a href="/toolkit/data/delivery/system?id=<%=delivery.getId()%>"><%=delivery.getName()%></a>;
                        <%}%>
                    </li></ul>
                </div>
            </div>
            <%}%>

            <%if(association.getAssociatedVectors().size()>0){%>
            <div class="row">
                <div class="col-sm-2"><strong>Vectors</strong></div>
                <div class="col">
                    <ul><li style="list-style-type: none">
                    <%for(Vector vector:association.getAssociatedVectors()){%>
                    <a href="/toolkit/data/vector/format?id=<%=vector.getVectorId()%>"><%=vector.getName()%></a>;
                    <%}%>
                    </li></ul>
                </div>
            </div>
            <% }%>
            <%if(association.getAssociatedGuides().size()>0){%>
            <div class="row">
                <div class="col-sm-2"><strong>Guides</strong></div>
                <div class="col">
                    <ul><li style="list-style-type: none">
                    <%for(Guide guide:association.getAssociatedGuides()){%><a href=""><%=guide.getGuide()%></a>;<%}%>
                    </li></ul>
                </div>
            </div>
            <%}%>
            <%if(studyNames.size()>0 || experimentNames.size()>0){%>
            <%if(hit.get("category").toString().equalsIgnoreCase("Publication")){%>
            <div class="row">
                <div class="col-sm-2"><strong>Projects</strong></div>
                <div class="col">
                    <ul><%for(Map.Entry entry:studyNames.entrySet()){%>
                        <li style="list-style-type: none;margin-left: 0"><a class="search-results-anchor" href="/toolkit/data/experiments/study/<%=entry.getKey()%>"><%=entry.getValue()%></a></li>
                        <%}%>
                    </ul>
                </div>
            </div>
            <%}}%>
        </div>
    </div>
    </div>
        </p>
    </details>
<%}%>