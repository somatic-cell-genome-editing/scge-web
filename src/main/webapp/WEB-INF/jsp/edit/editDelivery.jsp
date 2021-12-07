<%@ page import="com.nimbusds.jose.shaded.json.JSONValue" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<link href="/toolkit/css/reportPage.css" rel="stylesheet" type="text/css"/>
<html>
<head>
    <meta charset="UTF-8">
    <link href="/toolkit/css/reportPage.css" rel="stylesheet" type="text/css"/>
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <script src = "https://code.jquery.com/jquery-1.12.1.js"></script>
    <script src = "https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <script>
        $( document ).ready(function() {
            $( "#name" ).autocomplete({
                minLength: 1,
                source: <%= JSONValue.toJSONString(request.getAttribute("name")) %>
            });
            $( "#type" ).autocomplete({
                minLength: 1,
                source: <%= JSONValue.toJSONString(request.getAttribute("type")) %>
            });
            $( "#subtype" ).autocomplete({
                minLength: 1,
                source: <%= JSONValue.toJSONString(request.getAttribute("subType")) %>
            });
            $( "#source" ).autocomplete({
                minLength: 1,
                source: <%= JSONValue.toJSONString(request.getAttribute("source")) %>
            });
            $( "#labId" ).autocomplete({
                minLength: 1,
                source: <%= JSONValue.toJSONString(request.getAttribute("labId")) %>
            });
        });
    </script>


</head>
<body>

<form:form action="/toolkit/data/delivery/create" modelAttribute="delivery" method="post" >
  <div align="right"><form:button class="btn btn-primary">Submit</form:button></div>
<table width="80%">
    <tr>
        <td class="header"><form:label path="id">SCGE&nbsp;ID: </form:label></td>
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
    <td class="header"><form:label path="name">Name: </form:label></td>
    <td class="header"><form:input path="name" id="name" size="100"/></td>
    </tr>
    <tr>
        <td class="header"><form:label path="description">Description: </form:label></td>
    <td class="header"><form:textarea path="description" cols="100" rows="5"/></td>
    </tr>
        <tr><td class="header"><form:label path="type">Type: </form:label></td>
<td class="header"><form:input path="type" id="type" size="100"/></td>
        </tr>
    <tr>
    <td class="header"><form:label path="subtype">Subtype: </form:label></td>
    <td class="header"><form:input path="subtype" id="subtype" size="100"/></td>
    </tr>
    <tr>    <td class="header"> <form:label path="source">Source: </form:label></td>
        <td class="header"> <form:input path="source" id="source" size="100"/></td></tr>
    <tr>   <td class="header">  <form:label path="labId">Lab ID: </form:label></td>
        <td class="header"> <form:input path="labId" id="labId" size="100"/></td></tr>
    <tr><td class="header"><form:label path="rrid">RRID: </form:label></td>
        <td class="header"><form:input path="rrid" id="rrid" size="100"/></td>
    </tr>
    <hr>

       <tr><td class="header"> <form:label path="molTargetingAgent">Mol Targeting Agent: </form:label></td>
    <td class="header"><form:input path="molTargetingAgent" id="molTargetingAgent" size="100"/></td></tr>
    <tr> <td class="header">    <form:label path="sequence">Sequence: </form:label></td>
        <td class="header"><form:textarea path="sequence" id="sequence" cols="100" rows="5"/></td></tr>
    <tr> <td class="header">   <form:label path="annotatedMap">Annotated&nbsp;Map: </form:label></td>
        <td class="header"><form:input path="annotatedMap" size="100"/></td></tr>
<hr>
    <tr> <td class="header">    <form:label path="npSize">Np Size: </form:label></td>
        <td class="header"><form:input path="npSize" id="npSize" size="100"/></td></tr>
    <tr> <td class="header">   <form:label path="npPolydispersityIndex">Np Polydispersity Index: </form:label></td>
        <td class="header"><form:input path="npPolydispersityIndex" size="100"/></td></tr>
    <tr> <td class="header">   <form:label path="zetaPotential">Zeta Potential: </form:label></td>
        <td class="header"><form:input path="zetaPotential" size="100"/></td></tr>
</table>

</form:form>
</body>
</html>