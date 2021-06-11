<%@ page import="edu.mcw.scge.datamodel.Study" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.datamodel.Guide" %>
<%@ page import="edu.mcw.scge.datamodel.Editor" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.web.UI" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="edu.mcw.scge.storage.ImageStore" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.configuration.UserService" %>
<%@ page import="edu.mcw.scge.datamodel.Person" %>
<%@ page import="edu.mcw.scge.storage.ImageTypes" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/29/2020
  Time: 4:25 PM
  To change this template use File | Settings | File Templates.
--%>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
<link href="/common/tableSorter/css/filter.formatter.css" rel="stylesheet" type="text/css"/>
<link href="/common/tableSorter/css/theme.jui.css" rel="stylesheet" type="text/css"/>
<link href="/common/tableSorter/css/theme.blue.css" rel="stylesheet" type="text/css"/>

<script src="/common/tableSorter/js/tablesorter.js"> </script>
<script src="/common/tableSorter/js/jquery.tablesorter.widgets.js"></script>
<link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" integrity="sha384-AYmEC3Yw5cVb3ZcuHtOA93w35dYTsvhLPVnYs9eStHfGJvOvKxVfELGroGkvsg+p" crossorigin="anonymous"/>
<style>
    td{
        font-size: 12px;
        padding-left:1%;
    }
    .header{
        font-weight: bold;
        font-size: 12px;
        color:steelblue;
        width: 25%;
        background-color: #ECECF9;
    }

</style>
<script>
    $(function() {
        $("#myTable").tablesorter({
            theme : 'blue'

        });
    });
</script>

<% List<Guide> relatedGuides = (List<Guide>) request.getAttribute("guides");
   Editor editor = (Editor) request.getAttribute("editor");

%>


<div>
    <div>
        <table  style="width:80%">

            <tr ><td class="header"><strong>SCGE ID</strong></td><td><%=editor.getId()%></td></tr>
            <tr ><td class="header" ><strong>Name</strong></td><td><%=UI.replacePhiSymbol(editor.getSymbol())%></td></tr>
            <tr ><td class="header" ><strong>Description</strong></td><td><%=SFN.parse(editor.getEditorDescription())%></td></tr>
            <tr ><td class="header"><strong>Type</strong></td><td><%=editor.getType()%></td></tr>
            <tr ><td class="header"><strong>Subtype</strong></td><td><%=editor.getSubType()%></td></tr>
            <tr ><td class="header"><strong>Alias</strong></td><td><%=editor.getAlias()%></td></tr>

        </table>
        <hr>
        <table style="width:80%">

            <tr ><td class="header"><strong>Origin Species</strong></td><td><%=editor.getSpecies()%></td></tr>
            <tr ><td class="header"><strong>PAM</strong></td><td><%=editor.getPamPreference()%></td></tr>
            <tr ><td class="header"><strong>Variant</strong></td><td><%=editor.getEditorVariant()%></td></tr>
            <tr ><td class="header"><strong>Activity</strong></td><td><%=editor.getActivity()%></td></tr>
            <tr ><td class="header"><strong>Cleavage Type</strong></td><td><%=editor.getDsbCleavageType()%></td></tr>


        </table>
        <hr>
        <table style="width:80%">

            <tr ><td class="header"><strong>Source</strong></td><td><%=editor.getSource()%></td></tr>
            <tr ><td class="header"><strong>Stock/Catalog/RRID</strong></td><td></td></tr>
        </table>
        <hr>
        <table style="width:80%">

            <tr ><td class="header"><strong>Protein Sequence</strong></td><td><pre><%=UI.formatFASTA(editor.getProteinSequence())%></pre></td></tr>

        </table>
        <hr>
        <table style="width:80%">
            <tr><td class="header"><strong>Related Guides</strong></td>
                <td>
                    <%for (Guide relatedGuide: relatedGuides) { %>
                    <a href="/toolkit/data/guide/system?id=<%=relatedGuide.getGuide_id()%>"><%=relatedGuide.getTargetSequence()%></a><br>
                    <% } %>
                </td>
            </tr>
        </table>
    </div>
    <hr>
</div>



<%
    long objectId = editor.getId();
    String objectType= ImageTypes.EDITOR;
    String redirectURL = "/data/editors/editor?id=" + objectId;
    String bucket="main";

%>
<%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>


<br>
<jsp:include page="associatedStudies.jsp"/>
<br>
<hr>
<jsp:include page="associatedExperiments.jsp"/>
