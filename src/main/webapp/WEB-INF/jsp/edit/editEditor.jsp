<%@ page import="com.nimbusds.jose.shaded.json.JSONValue" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<link href="/toolkit/css/reportPage.css" rel="stylesheet" type="text/css"/>
<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src = "https://code.jquery.com/jquery-1.12.1.js"></script>
<script src = "https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<html>
<script>
    $( document ).ready(function() {
        $( "#type" ).autocomplete({
            minLength: 1,
            source: <%= JSONValue.toJSONString(request.getAttribute("types")) %>
        });
        $( "#subType" ).autocomplete({
            minLength: 1,
            source: <%= JSONValue.toJSONString(request.getAttribute("subTypes")) %>
        });
        $( "#symbol" ).autocomplete({
            minLength: 1,
            source: <%= JSONValue.toJSONString(request.getAttribute("symbol")) %>
        });
        $( "#species" ).autocomplete({
            minLength: 1,
            source: <%= JSONValue.toJSONString(request.getAttribute("species")) %>
        });
        $( "#editorVariant" ).autocomplete({
            minLength: 1,
            source: <%= JSONValue.toJSONString(request.getAttribute("variant")) %>
        });
        $( "#pamPreference" ).autocomplete({
            minLength: 1,
            source: <%= JSONValue.toJSONString(request.getAttribute("pam")) %>
        });
        $( "#fusion" ).autocomplete({
            minLength: 1,
            source: <%= JSONValue.toJSONString(request.getAttribute("fusion")) %>
        });
        $( "#dsbCleavageType" ).autocomplete({
            minLength: 1,
            source: <%= JSONValue.toJSONString(request.getAttribute("cleavage")) %>
        });
        $( "#source" ).autocomplete({
            minLength: 1,
            source: <%= JSONValue.toJSONString(request.getAttribute("source")) %>
        });
        $( "#substrateTarget" ).autocomplete({
            minLength: 1,
            source: <%= JSONValue.toJSONString(request.getAttribute("substrate")) %>
        });
        $( "#activity" ).autocomplete({
            minLength: 1,
            source: <%= JSONValue.toJSONString(request.getAttribute("activity")) %>
        });
        });
</script>

<head>
    <meta charset="UTF-8">
</head>
<body>

<form:form action="/toolkit/data/editors/create" modelAttribute="editor" method="post" >
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
    <td class="header"><form:label path="type">Type: </form:label></td>
    <td class="header"><form:input path="type" id="type" autocomplete="true" size="100"/></td>
    </tr>
    <tr>
        <td class="header"><form:label path="subType">Subtype: </form:label></td>
    <td class="header"><form:input path="subType" id="subType" size="100" /></td>
    </tr>
        <tr><td class="header"><form:label path="symbol">Symbol: </form:label></td>
<td class="header"><form:input path="symbol" id="symbol" size="100"/></td>
        </tr>
    <tr>   <td class="header">  <form:label path="editorDescription">Description: </form:label></td>
        <td class="header"><form:textarea path="editorDescription" cols="100" rows="5"/></td></tr>
    <tr>
    <td class="header"><form:label path="alias">Alias: </form:label></td>
    <td class="header"><form:input path="alias" size="100"/></td>
    </tr>
    <tr><td class="header"><form:label path="species">Species: </form:label></td>
    <td class="header"><form:input path="species" id="species" size="100"/></td>
    </tr>
    <hr>

       <tr><td class="header"> <form:label path="editorVariant">Editor&nbsp;Variant: </form:label></td>
    <td class="header"><form:input path="editorVariant" id="editorVariant" size="100"/></td></tr>
      <tr> <td class="header"> <form:label path="pamPreference">Pam: </form:label></td>
          <td class="header"><form:input path="pamPreference" id="pamPreference" size="100"/></td></tr>
    <tr>    <td class="header"> <form:label path="substrateTarget">Substrate&nbsp;Target: </form:label></td>
        <td class="header"> <form:input path="substrateTarget" id="substrateTarget" size="100"/></td></tr>
    <tr>   <td class="header">  <form:label path="activity">Activity: </form:label></td>
        <td class="header"> <form:input path="activity" id="activity" size="100"/></td></tr>
    <tr>   <td class="header">  <form:label path="fusion">Fusion: </form:label></td>
        <td class="header"><form:input path="fusion" id="fusion" size="100"/></td></tr>

    <hr>

    <tr> <td class="header">  <form:label path="dsbCleavageType">Dsb&nbsp;Cleavage&nbsp;Type: </form:label></td>
        <td class="header"><form:input path="dsbCleavageType" id="dsbCleavageType" size="100"/></td></tr>
    <tr> <td class="header">   <form:label path="target_sequence">Target&nbsp;Sequence: </form:label></td>
        <td class="header"><form:textarea path="target_sequence" cols="100" rows="5"/></td></tr>
    <tr> <td class="header">    <form:label path="source">Source: </form:label></td>
        <td class="header"><form:input path="source" id="source" size="100"/></td></tr>
    <tr> <td class="header">   <form:label path="annotatedMap">Annotated&nbsp;Map: </form:label></td>
        <td class="header"><form:input path="annotatedMap" size="100"/></td></tr>

    <tr> <td class="header">   <form:label path="proteinSequence">Protein&nbsp;Sequence: </form:label></td>
        <td class="header"><form:textarea path="proteinSequence" cols="100" rows="5"/></td></tr>

    <hr>
    <tr> <td class="header">  <form:label path="targetLocus">Target&nbsp;Locus: </form:label></td>
        <td class="header"><form:input path="targetLocus" size="100"/></td></tr>
    <tr> <td class="header">   <form:label path="assembly">Genome&nbsp;Version: </form:label></td>
        <td class="header"><form:input path="assembly" size="100"/></td></tr>
    <tr> <td class="header">    <form:label path="chr">Chromosome: </form:label></td>
        <td class="header"><form:input path="chr" size="100"/></td></tr>
    <tr> <td class="header">   <form:label path="start">Start: </form:label></td>
        <td class="header"><form:input path="start" size="100"/></td></tr>

    <tr> <td class="header">   <form:label path="stop">Stop: </form:label></td>
        <td class="header"><form:input path="stop" size="100"/></td></tr>
    <tr> <td class="header">   <form:label path="strand">Strand: </form:label></td>
        <td class="header"><form:input path="strand" size="100"/></td></tr>
</table>

</form:form>
</body>
</html>