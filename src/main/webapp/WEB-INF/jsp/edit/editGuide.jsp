<%@ page import="" %>
<%@ page import="net.minidev.json.JSONValue" %>
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
            $( "#guide" ).autocomplete({
                minLength: 2,
                source: <%= JSONValue.toJSONString(request.getAttribute("guides")) %>
            });
            $( "#grnaLabId" ).autocomplete({
                minLength: 1,
                source: <%= JSONValue.toJSONString(request.getAttribute("grnaLabId")) %>
            });
            $( "#species" ).autocomplete({
                minLength: 1,
                source: <%= JSONValue.toJSONString(request.getAttribute("species")) %>
            });
            $( "#targetLocus" ).autocomplete({
                minLength: 1,
                source: <%= JSONValue.toJSONString(request.getAttribute("targetLocus")) %>
            });
            $( "#source" ).autocomplete({
                minLength: 1,
                source: <%= JSONValue.toJSONString(request.getAttribute("source")) %>
            });
            $( "#guideFormat" ).autocomplete({
                minLength: 1,
                source: <%= JSONValue.toJSONString(request.getAttribute("guideFormat")) %>
            });
        });
    </script>


</head>
<body>

<form:form action="/toolkit/data/guide/create" modelAttribute="guide" method="post" >
  <div align="right"><form:button class="btn btn-primary">Submit</form:button></div>
<table width="80%">
    <tr>
        <td class="header"><form:label path="guide_id">SCGE ID: </form:label></td>
        <td class="header"><form:input path="guide_id" readonly="true" size="100"/></td>
    </tr>
    <tr>
        <td class="header"><form:label path="tier">Tier: </form:label></td>
        <td class="header"><form:radiobutton path="tier" value="1"/>&nbsp;1
            <form:radiobutton path="tier" value="2"/>&nbsp;2
            <form:radiobutton path="tier" value="3"/>&nbsp;3
            <form:radiobutton path="tier" value="4"/>&nbsp;4</td>
    </tr>
    <tr>
    <td class="header"><form:label path="guide">Guide: </form:label></td>
    <td class="header"><form:input path="guide" id="guide" size="100"/></td>
    </tr>
    <tr>
        <td class="header"><form:label path="guideDescription">Description: </form:label></td>
    <td class="header"><form:textarea path="guideDescription" cols="100" rows="5"/></td>
    </tr>
    <tr> <td class="header"> <form:label path="species">Species: </form:label></td>
        <td class="header"><form:input path="species" id="species" size="100"/></td></tr>
    <tr><td class="header"><form:label path="grnaLabId">Lab Id: </form:label></td>
    <td class="header"><form:input path="grnaLabId" id="grnaLabId" size="100"/></td>
    </tr>
    <tr>    <td class="header"> <form:label path="source">Source: </form:label></td>
        <td class="header"> <form:input path="source" id="source" size="100"/></td></tr>
    <tr> <td class="header">  <form:label path="fullGuide">Full&nbsp;Guide&nbsp;Sequence: </form:label></td>
        <td class="header"><form:textarea path="fullGuide" cols="100" rows="5"/></td></tr>
    <tr> <td class="header">  <form:label path="guideCompatibility">Guide Compatibility: </form:label></td>
        <td class="header"><form:input path="guideCompatibility" size="100"/></td></tr>
    <hr>

    <tr> <td class="header">  <form:label path="targetLocus">Target&nbsp;Locus: </form:label></td>
        <td class="header"><form:input path="targetLocus" id="targetLocus" size="100"/></td></tr>
    <tr> <td class="header">  <form:label path="targetSequence">Target&nbsp;Sequence: </form:label></td>
        <td class="header"><form:textarea path="targetSequence" cols="100" rows="5"/></td></tr>
    <tr> <td class="header">  <form:label path="pam">Target Sequence+PAM: </form:label></td>
        <td class="header"><form:textarea path="pam" cols="100" rows="5"/></td></tr>
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
    <tr> <td class="header">   <form:label path="guideFormat">Guide Format: </form:label></td>
        <td class="header"><form:input path="guideFormat" id="guideFormat" size="100"/></td></tr>
    <tr> <td class="header">    <form:label path="modifications">Modifications: </form:label></td>
        <td class="header"><form:input path="modifications" size="100"/></td></tr>
    <tr> <td class="header">   <form:label path="standardScaffoldSequence">Standard Scaffold Sequence: </form:label></td>
        <td class="header"><form:input path="standardScaffoldSequence" size="100"/></td></tr>

    <hr>
    <tr> <td class="header">  <form:label path="spacerLength">Spacer Length: </form:label></td>
        <td class="header"><form:input path="spacerLength" size="100"/></td></tr>
    <tr> <td class="header">   <form:label path="spacerSequence">Spacer Sequence: </form:label></td>
        <td class="header"><form:textarea path="spacerSequence" cols="100" rows="5"/></td></tr>
    <tr> <td class="header">    <form:label path="repeatSequence">Repeat Sequence: </form:label></td>
        <td class="header"><form:textarea path="repeatSequence" cols="100" rows="5"/></td></tr>
    <tr> <td class="header">   <form:label path="forwardPrimer">Forward Primer: </form:label></td>
        <td class="header"><form:input path="forwardPrimer" size="100"/></td></tr>
    <tr> <td class="header">    <form:label path="reversePrimer">Reverse Primer: </form:label></td>
        <td class="header"><form:input path="reversePrimer" size="100"/></td></tr>
    <tr> <td class="header">   <form:label path="linkerSequence">Linker Sequence: </form:label></td>
        <td class="header"><form:textarea path="linkerSequence" cols="100" rows="5"/></td></tr>
    <tr> <td class="header">    <form:label path="antiRepeatSequence">Anti Repeat Sequence: </form:label></td>
        <td class="header"><form:textarea path="antiRepeatSequence" cols="100" rows="5"/></td></tr>
    <tr> <td class="header">    <form:label path="stemloop1Sequence">StemLoop 1 Sequence: </form:label></td>
        <td class="header"><form:textarea path="stemloop1Sequence" cols="100" rows="5"/></td></tr>
    <tr> <td class="header">    <form:label path="stemloop2Sequence">StemLoop 2 Sequence: </form:label></td>
        <td class="header"><form:textarea path="stemloop2Sequence" cols="100" rows="5"/></td></tr>
    <tr> <td class="header">    <form:label path="stemloop3Sequence">StemLoop 3 Sequence: </form:label></td>
        <td class="header"><form:textarea path="stemloop3Sequence" cols="100" rows="5"/></td></tr>
    <hr>

    <tr> <td class="header">  <form:label path="ivtConstructSource">IVT Construct Score: </form:label></td>
        <td class="header"><form:input path="ivtConstructSource" size="100"/></td></tr>
    <tr> <td class="header">   <form:label path="vectorDescription">Vector Description: </form:label></td>
        <td class="header"><form:textarea path="vectorDescription" cols="100" rows="5s"/></td></tr>
    <tr> <td class="header">    <form:label path="vectorId">Vector ID: </form:label></td>
        <td class="header"><form:input path="vectorId" size="100"/></td></tr>
    <tr> <td class="header">   <form:label path="vectorName">Vector Name: </form:label></td>
        <td class="header"><form:input path="vectorName" size="100"/></td></tr>
    <tr> <td class="header">    <form:label path="vectorType">Vector Type: </form:label></td>
        <td class="header"><form:input path="vectorType" size="100"/></td></tr>
    <tr> <td class="header">   <form:label path="annotatedMap">Annotated Map: </form:label></td>
        <td class="header"><form:input path="annotatedMap" size="100"/></td></tr>
    <tr> <td class="header">    <form:label path="specificityRatio">Specificity Ratio: </form:label></td>
        <td class="header"><form:input path="specificityRatio" size="100"/></td></tr>
</table>

</form:form>
</body>
</html>