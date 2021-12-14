<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<link href="/toolkit/css/reportPage.css" rel="stylesheet" type="text/css"/>
<html>
<head>
    <meta charset="UTF-8">
</head>
<body>

<form:form action="/toolkit/data/models/create" modelAttribute="model" method="post" >
  <div align="right"><form:button class="btn btn-primary">Submit</form:button></div>
<table width="80%">
    <tr>
        <td class="header"><form:label path="modelId">SCGE ID: </form:label></td>
        <td class="header"><form:input path="modelId" readonly="true" size="100"/></td>
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
    <td class="header"><form:input path="name" size="100"/></td>
    </tr>
    <tr>   <td class="header">  <form:label path="displayName">Display Name: </form:label></td>
        <td class="header"><form:input path="displayName" size="100"/></td></tr>
    <tr>
        <td class="header"><form:label path="description">Description: </form:label></td>
    <td class="header"><form:textarea path="description" cols="100" rows="5"/></td>
    </tr>
        <tr><td class="header"><form:label path="type">Type: </form:label></td>
<td class="header">
    <form:radiobutton path="type" value="Cell"/>&nbsp;Cell</br>
    <form:radiobutton path="type" value="Animal"/>&nbsp;Animal</td>
        </tr>
    <tr>
    <td class="header"><form:label path="subtype">Subtype: </form:label></td>
    <td class="header"><form:input path="subtype" size="100"/></td>
    </tr>
    <tr><td class="header"><form:label path="strainAlias">Alias: </form:label></td>
    <td class="header"><form:input path="strainAlias" size="100"/></td>
    </tr>
    <hr>

       <tr><td class="header"> <form:label path="parentalOrigin">Parental&nbsp;Origin: </form:label></td>
    <td class="header"><form:input path="parentalOrigin" size="100"/></td></tr>
      <tr> <td class="header"> <form:label path="organism">Species: </form:label></td>
    <td class="header"><form:radiobutton path="organism" value="Mouse"/>&nbsp;Mouse</br>
        <form:radiobutton path="organism" value="Human"/>&nbsp;Human</td></tr>
    <tr>    <td class="header"> <form:label path="source">Source: </form:label></td>
        <td class="header"> <form:input path="source" size="100"/></td></tr>
    <tr>   <td class="header">  <form:label path="rrid">RRID: </form:label></td>
        <td class="header"> <form:input path="rrid" size="100"/></td></tr>


    <hr>


    <tr> <td class="header">  <form:label path="transgene">Transgene: </form:label></td>
        <td class="header"><form:input path="transgene" size="100"/></td></tr>
    <tr> <td class="header">   <form:label path="transgeneDescription">Transgene Description: </form:label></td>
        <td class="header"><form:textarea path="transgeneDescription" cols="100" rows="5s"/></td></tr>
    <tr> <td class="header">    <form:label path="transgeneReporter">Reporter: </form:label></td>
        <td class="header"><form:input path="transgeneReporter" size="100"/></td></tr>
    <tr> <td class="header">   <form:label path="annotatedMap">Annotated Map: </form:label></td>
        <td class="header"><form:input path="annotatedMap" size="100"/></td></tr>


</table>

</form:form>
</body>
</html>