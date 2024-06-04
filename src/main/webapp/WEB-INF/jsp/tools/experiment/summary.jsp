<%@ page import="edu.mcw.scge.datamodel.publications.Publication" %>
<%@ page import="edu.mcw.scge.datamodel.publications.ArticleId" %>
<%@ page import="edu.mcw.scge.dao.implementation.ProtocolDao" %><%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 6/16/2023
  Time: 3:31 PM
  To change this template use File | Settings | File Templates.
--%>

<%
  HashMap<String,String> deliveryAssay = (HashMap<String,String>) request.getAttribute("deliveryAssay");
  HashMap<String,String> editingAssay = (HashMap<String,String>) request.getAttribute("editingAssay");
  HashMap<String,String> biomarkerAssay = (HashMap<String,String>) request.getAttribute("biomarkerAssay");
%>
<div class="jumbotron" id="experiment-summary" style="margin-top:0;padding-top:10px;padding-bottom: 5px;background-color: transparent;">
  <%if(ex.getDescription()!=null && !ex.getDescription().equals("")){%>
  <div class=""><b>Description:&nbsp;</b><%=ex.getDescription()%></div>
  <%}%>
  <% if (deliveryAssay.size() != 0) { %>
  <div class=""><b>Delivery Assays:</b>
    <% if(deliveryAssay.size()==1){%>
    <%=deliveryAssay.keySet().toArray()[0]%>
    <% }else{%>
    <ul>
      <%for (String assay: deliveryAssay.keySet()) { %>
      <li><%=assay%></li>
      <%}%>
    </ul>
    <%} %>
  </div>
  <% } %>
  <% if (editingAssay.size() != 0) { %>
  <div class=""><b>Editing Assay:</b>
    <% if(editingAssay.size()==1){%>
    <%=editingAssay.keySet().toArray()[0]%>
    <%}else{%>
    <ul>
      <%for (String assay: editingAssay.keySet()) { %>
      <li><%=assay%></li>
      <%}%>
      </ul>
    <%}%>
  </div>
  <% } %>
  <% if (biomarkerAssay.size() != 0) { %>
  <div class=""><b>Biomarker Assay:</b>
    <% if(biomarkerAssay.size()==1){%>
    <%=biomarkerAssay.keySet().toArray()[0]%>
    <%}else{%>
    <ul>
      <%for (String assay: biomarkerAssay.keySet()) { %>
      <li><%=assay%></li>
      <%}%>
    </ul>
    <%} %>
  </div>
  <% } %>
  <div class=""><b>Parent Project:&nbsp;</b><a href="/toolkit/data/experiments/group/${study.groupId}?selectedStudy=<%=study.getStudyId()%>">${study.study}</a><br>
      <ul style="list-style-type: none">
        <%if(experiments.size()>1){%>
        <li style="text-decoration: none">
          <details>
            <summary>Other experiments in this project:&nbsp;<%=experiments.size()-1%></summary>
            <ul>
              <% for(Experiment experiment:experiments){
                if(experiment.getExperimentId()!=ex.getExperimentId()){%>
              <li><a href="/toolkit/data/experiments/experiment/<%=experiment.getExperimentId()%>?selectedStudy=<%=experiment.getStudyId()%>"><%=experiment.getName()%></a></li>
              <%}}%>
            </ul>

          </details>
        </li>
        <%}%>
      </ul>
  </div>
  <div><b>Download:&nbsp;</b><a href="/toolkit/download/${study.studyId}">Submitted files</a></div>

  <%List<Publication> publications= (List<Publication>) request.getAttribute("associatedPublications");
  if(publications!=null && publications.size()>0){%>
  <div><b>Publications:&nbsp;</b>
    <ul>
    <%
      for(Publication publication:publications){
      String pmid= null;
       for(ArticleId id:publication.getArticleIds()){
         if(id.getIdType().equalsIgnoreCase("pubmed")){
           pmid=id.getId();}}
    %>
      <li><%=publication.getReference().getTitle()%><%if(pmid!=null){%> <a href="https://pubmed.ncbi.nlm.nih.gov/<%=pmid%>" target="_blank" title="PubMed">NCBI</a></li><%}%>
   <%}%>
    </ul>
  </div>
  <%}%>
    <%@include file="../validationsNexperiments.jsp"%>


</div>
<% ProtocolDao pdao = new ProtocolDao();
  List<Protocol> localProtocols = pdao.getProtocolsForObject(objectId);
  if((publications!=null && publications.size()>0 || (localProtocols!=null && localProtocols.size()>0)) &&  request.getParameter("resultType")!=null){%>
Jump to:&nbsp;<%if(publications!=null && publications.size()>0){%><a href="#associatedPublications">Publications</a>&nbsp;<%}%><%if(localProtocols!=null && localProtocols.size()>0){%>|&nbsp;<a href="#associatedProtocols">Protocols</a><%}%>
<%}%>