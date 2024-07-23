<%@ page import="edu.mcw.scge.datamodel.publications.Author" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>

<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.fasterxml.jackson.core.type.TypeReference" %>
<%@ page import="edu.mcw.scge.datamodel.publications.ArticleId" %><%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 2/26/2024
  Time: 1:07 PM
  To change this template use File | Settings | File Templates.
--%>

  <%if(hit.get("authorList")!=null){
    Gson gson=new Gson();
    String json=gson.toJson(hit.get("authorList"));
    ObjectMapper mapper=new ObjectMapper();
    List<Author> authors=mapper.readValue(json, new TypeReference<List<Author>>(){});
    boolean first=true;
    StringBuilder builder=new StringBuilder();
    for(Author author:authors) {
      if(first){
        first=false;
        builder.append(author.getLastName()).append(" ").append(author.getInitials());
      }else {
        builder.append(", ").append(author.getLastName()).append(" ").append(author.getInitials());

      }
  }%>
<small><%=builder.toString()%></small><br>

<%}%>
<%if(hit.get("articleIds")!=null){
  Gson gson=new Gson();
  String json=gson.toJson(hit.get("articleIds"));
  ObjectMapper mapper=new ObjectMapper();
  List<ArticleId> articleIds=mapper.readValue(json, new TypeReference<List<ArticleId>>(){});
  boolean first=true;
  StringBuilder builder=new StringBuilder();
  for(ArticleId articleId:articleIds) {
    String url="";
    if(articleId.getIdType().equalsIgnoreCase("pubmed")){
      url+="https://pubmed.ncbi.nlm.nih.gov/";
    }else
    if(articleId.getIdType().equalsIgnoreCase("pmc")){
      url+="https://www.ncbi.nlm.nih.gov/pmc/articles/";
    }else
    if(articleId.getIdType().equalsIgnoreCase("pubmed")){
      url+="https://pubmed.ncbi.nlm.nih.gov/";
    }else
    if(articleId.getIdType().equalsIgnoreCase("doi")){
      url+="https://doi.org/";
    }
    String id="";
    if(!url.equals("")) {
       id += "<a target='_blank' href='" + url + articleId.getId() + "'>" + articleId.getId() + "</a>";
    }else{
      id+=articleId.getId();
    }
    if(first){
      first=false;
      builder.append(articleId.getIdType().toUpperCase()).append(": ").append(id);
    }else {
      builder.append(", ").append(articleId.getIdType().toUpperCase()).append(" ").append(id);

    }
  }%>
<span><%=builder.toString()%></span><br><br>

<%}%>
