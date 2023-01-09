<%@ page import="edu.mcw.scge.datamodel.Protocol" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<link href="/toolkit/css/reportPage.css" rel="stylesheet" type="text/css"/>
<html>
<head>
    <meta charset="UTF-8">
</head>
<body>
<% String act = (String) request.getAttribute("action");
    Protocol p = (Protocol) request.getAttribute("protocol");
%>
<form:form action="/toolkit/data/protocols/create" modelAttribute="protocol" method="post" enctype="multipart/form-data">
  <div align="right"><form:button class="btn btn-primary">Submit</form:button></div>
<table width="80%">
    <tr>
        <td class="header"><form:label path="id">SCGE ID: </form:label></td>
        <td class="header"><form:input path="id" readonly="true" size="100"/></td>
    </tr>
    <tr>
        <td class="header"><form:label path="tier">Tier: </form:label></td>
        <td class="header"><form:radiobutton path="tier" value="1"/>&nbsp;1
            <form:radiobutton path="tier" value="2"/>&nbsp;2
            <form:radiobutton path="tier" value="3"/>&nbsp;3
            <form:radiobutton path="tier" value="4"/>&nbsp;4</td>
    </tr>
    <tr>
    <td class="header"><form:label path="title">Title: </form:label></td>
    <td class="header"><form:input path="title" size="100"/></td>
    </tr>
    <tr>  <%
        if(act.contains("Update")) { %>
            <td class="header">  <form:label path="filename">File: </form:label></td>
        <td class="header"><a href="/toolkit/files/protocol/<%=p.getFilename()%>"><%=p.getFilename()%></a>
       <form:input type="file" path="file" size="100"/></td>
     <%   } else {
    %> <td class="header">  <form:label path="file">File Name: </form:label></td>
        <td class="header"><form:input type="file" path="file" size="100"/></td>
        <%}%>
    </tr>
    <tr>
        <td class="header"><form:label path="description">Description: </form:label></td>
    <td class="header"><form:textarea path="description" cols="100" rows="5"/></td>
    </tr>
    <tr>
    <td class="header"><form:label path="xref">XRef: </form:label></td>
    <td class="header"><form:input path="xref" size="100"/></td>
    </tr>
    <tr><td class="header"><form:label path="keywords">Keywords: </form:label></td>
    <td class="header"><form:input path="keywords" size="100"/></td>
    </tr>
</table>

</form:form>
</body>
</html>