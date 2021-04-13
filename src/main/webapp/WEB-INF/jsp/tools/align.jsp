<%--
  Created by IntelliJ IDEA.
  User: jdepons
  Date: 4/13/21
  Time: 11:04 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>

<% String alignment = (String) request.getAttribute("alignment"); %>
<pre>
<%=alignment%>
</pre>

</body>
</html>
