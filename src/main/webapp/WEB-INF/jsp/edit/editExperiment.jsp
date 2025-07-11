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
            $( "#name" ).autocomplete({
                minLength: 1,
                source: <%= JSONValue.toJSONString(request.getAttribute("names")) %>
            });
            $( "#type" ).autocomplete({
                minLength: 1,
                source: <%= JSONValue.toJSONString(request.getAttribute("types")) %>
            });
        });
    </script>
</head>
<body>

<form:form action="/toolkit/data/experiments/create" modelAttribute="experiment" method="post" >
    <div align="right"><form:button class="btn btn-primary">Submit</form:button></div>
    <table width="80%">
        <tr>
            <td class="header"><form:label path="experimentId">SCGE&nbsp;ID: </form:label></td>
            <td class="header"><form:input path="experimentId" readonly="true" size="100"/></td>
        </tr>
        <tr>
            <td class="header"><form:label path="studyId">Study&nbsp;ID: </form:label></td>
            <td class="header"><form:input path="studyId" readonly="true" size="100"/></td>
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
    </table>

</form:form>
</body>
</html>