
<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.dao.implementation.EditorDao" %>
<%@ page import="edu.mcw.scge.datamodel.Editor" %><%--
  Created by IntelliJ IDEA.
  User: jdepons
  Date: 9/24/20
  Time: 3:40 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Editors</title>
</head>
<body>

<%

    out.print("Hello World");

      EditorDao edao = new EditorDao();
      List<Editor> editors = edao.getAllEditors();

    //for (Editor e: editors) {
%>
<%
//    }
%>


</body>
</html>
