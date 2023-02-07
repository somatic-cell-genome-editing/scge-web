<%@ page import="edu.mcw.scge.process.UI" %>
<%--
  Created by IntelliJ IDEA.
  User: jdepons
  Date: 11/9/20
  Time: 10:28 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>


<table border="1">
    <tr>
        <td></td>
        <td>Expt 22</td>
        <td>Expt 31</td>
        <td>Expt 45</td>
    </tr>
    <tr>
        <td>Tissue 1</td>
        <td><div style="width:30px;height:30px;background-color:<%=UI.getRGBValue("red",75,255)%>"></div></td>
        <td><div style="width:30px;height:30px;background-color:<%=UI.getRGBValue("red",255,255)%>"></div></td>
        <td><div style="width:30px;height:30px;background-color:<%=UI.getRGBValue("green",75,255)%>"></div></td>
        <td><div style="width:30px;height:30px;background-color:<%=UI.getRGBValue("green",255,255)%>"></div></td>
        <td><div style="width:30px;height:30px;background-color:<%=UI.getRGBValue("blue",75,255)%>"></div></td>
        <td><div style="width:30px;height:30px;background-color:<%=UI.getRGBValue("blue",255,255)%>"></div></td>
        <td>
            <table border="1">
                <tr>
                    <td><div style="width:30px;height:30px;background-color:<%=UI.getRGBValue("blue",75,255)%>"></div></td>
                    <td><div style="width:30px;height:30px;background-color:<%=UI.getRGBValue("green",255,255)%>"></div></td>
                </tr>
                <tr>
                    <td><div style="width:30px;height:30px;background-color:<%=UI.getRGBValue("red",255,255)%>"></div></td>
                    <td><div style="width:30px;height:30px;background-color:<%=UI.getRGBValue("red",255,255)%>"></div></td>
                </tr>
            </table>
        </td>
    </tr>
</table>




<div>a</div>
<div>b</div>



</body>
</html>
