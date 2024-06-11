<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 6/11/2024
  Time: 12:19 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if(experimentNames.size()>0){
%>
<br><strong>SCGE data tags...</strong>
<%}%>
<div class="container">
<%
    if(hit.get("modelOrganism")!=null) {%>
    <strong>Organisms:</strong>
    <%
        List<String> modelOrganisms= (List<String>) hit.get("modelOrganism");
      for(String model:modelOrganisms){%>
          <%=model%>
      <%}}
    if(hit.get("modelName")!=null) {%>
<br><strong>Models:</strong>
<%
        List<String> modelNameMap=  (List<String>) hit.get("modelName");
        for(String model:modelNameMap){%>
            <%=model%>
       <% }}

    if(hit.get("editorSymbol")!=null) {
        %>
  <br>  <strong>Editors</strong>
<%
        List<String> editorSymbol=  (List<String>) hit.get("editorSymbol");
        for(String editor:editorSymbol){
            %>
            <%=editor%>
       <% }}

%>

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



</div>