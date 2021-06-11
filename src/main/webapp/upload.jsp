<%--
  Created by IntelliJ IDEA.
  User: jdepons
  Date: 4/21/21
  Time: 11:18 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>

<form action="uploadFile?${_csrf.parameterName}=${_csrf.token}" method="POST" enctype="multipart/form-data">
    <input type="file" id="myFile" name="filename">
    <input type="submit">
</form>


</body>
</html>
