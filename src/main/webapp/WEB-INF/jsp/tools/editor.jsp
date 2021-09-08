<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.web.UI" %>
<%@ page import="edu.mcw.scge.storage.ImageStore" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.configuration.UserService" %>
<%@ page import="edu.mcw.scge.storage.ImageTypes" %>
<%@ page import="edu.mcw.scge.datamodel.*" %>
<%@ page import="java.util.*" %>
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

<link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" integrity="sha384-AYmEC3Yw5cVb3ZcuHtOA93w35dYTsvhLPVnYs9eStHfGJvOvKxVfELGroGkvsg+p" crossorigin="anonymous"/>
<style>
    .table{
        border:1px solid white;
    }
    .table td, .table th{

        border-color: transparent;

    }
    .header{
        width:30%;
        background-color: aliceblue;
        padding-left: 20px;
        font-weight: bold;
    }
    .summary tr th, .summary tr td{

        padding-top: 0;
        padding-bottom: 0;
    }
    .sidenav {
        width: auto;
        position: fixed;
        z-index: 1;
        overflow-x: hidden;

    }

    .sidenav a {
        padding: 6px 8px 6px 16px;
        text-decoration: none;
        font-size: 15px;
        color: #2196F3;
        display: block;
    }

    .sidenav a:hover {
        color: #064579;
    }
    .header{
        white-space: nowrap;

    }
    .scge-details-label{
        color:#2a6496;
        font-weight: bold;
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
<%
    long objectId = editor.getId();
    String objectType= ImageTypes.EDITOR;
    String redirectURL = "/data/editors/editor?id=" + objectId;
    String bucket="main";
    String[] images = ImageStore.getImages(objectType, "" + objectId, bucket);

%>
<div class="col-md-2 sidenav bg-light">
    <a href="#summary">Summary</a>
    <%if(editor.getProteinSequence()!=null && !editor.getProteinSequence().equals("")){%>
    <a href="#proteinSequence">Protein Sequence</a>
    <%}%>

    <%if(images!=null && images.length>0){%>
    <a href="images">Images</a>
    <%}%>
    <% if(relatedGuides!=null && relatedGuides.size()>0){%>
    <a href="#relatedGuides">Related Guides</a>
    <%}%>



    <a href="#associatedStudies">Associated Studies</a>
    <a href="#associatedExperiments">Associated Experiments</a>
    <a href="#publications">Related Publications</a>


</div>
<main role="main" class="col-md-10 ml-sm-auto px-4"  >
    <div id="summary">
        <h4 class="page-header" style="color:grey;">Summary</h4>

    <div class="d-flex bg-light" >

        <div class="col-7">
            <table class="table table-sm summary" >
                <tr ><td class="header" >Symbol</td><td>&nbsp;<%=SFN.parse(editor.getSymbol())%></td></tr>
                <tr ><td class="header">Species</td><td>&nbsp;<%=SFN.parse(editor.getSpecies())%></td></tr>
                <%if(editor.getEditorDescription()!=null && !editor.getEditorDescription().equals("")){%>
                <tr ><td class="header" >Description</td><td><%=SFN.parse(editor.getEditorDescription())%></td></tr>
                <%}%>
                <%if(editor.getType()!=null && !editor.getType().equals("")){%>
                <tr ><td class="header">Type</td><td style="white-space: nowrap"><%=editor.getType()%></td></tr>
                <%}%>
                <%if(editor.getSubType()!=null && !editor.getSubType().equals("")){%>
                <tr ><td class="header">Subtype</td><td style="white-space: nowrap"><%=editor.getSubType()%></td></tr>
                <%}%>
                <%if(editor.getAlias()!=null && !editor.getAlias().trim().equals("")){%>

                <tr ><td class="header">Alias</td><td style="white-space: nowrap"><%=editor.getAlias()%></td></tr>
                <%}%>
                <%if(editor.getPamPreference()!=null && !editor.getPamPreference().equals("")){%>

                <tr ><th class="header">PAM</th><td style="white-space: nowrap"><%=editor.getPamPreference()%></td></tr>
                <%}%>
                <%if(editor.getEditorVariant()!=null && !editor.getEditorVariant().equals("")){%>

                <tr ><td class="header">Variant</td><td style="white-space: nowrap"><%=editor.getEditorVariant()%></td></tr>
                <%}%>
                <%if(editor.getActivity()!=null && !editor.getActivity().equals("")){%>

                <tr ><td class="header">Activity</td><td style="white-space: nowrap"><%=editor.getActivity()%></td></tr>
                <%}%>
                <%if(editor.getDsbCleavageType()!=null && !editor.getDsbCleavageType().equals("")){%>

                <tr ><td class="header">Cleavage Type</td><td style="white-space: nowrap"><%=editor.getDsbCleavageType()%></td></tr>
                <%}%>
                <%if(editor.getSource()!=null && !editor.getSource().equals("")){%>

                <tr ><td class="header">Source</td><td style="white-space: nowrap"><%=editor.getSource()%></td></tr>
                <%}%>

            </table>


        </div>
        <div class="ml-auto col-3" style="margin-right: 5%">

            <div class="card">
                <div class="card-header">Genome Editor</div>
                <div class="card-body">
                    <table >
                        <tr ><th class="scge-details-label">SCGE:<%=editor.getId()%></th></tr>

                    </table>
                </div>
            </div>

        </div>
    </div>
</div>
    <hr>
    <%if(editor.getProteinSequence()!=null && !editor.getProteinSequence().equals("")){%>

    <div id="proteinSequence">
        <h4 class="page-header" style="color:grey;">Protein Sequence</h4>
        <div class="container" align="center">
            <table style="">

                <tr ><td></td><td><pre><%=UI.formatFASTA(editor.getProteinSequence())%></pre></td></tr>

            </table>
        </div>
    </div>
    <hr>
    <%}%>
   
    <%if(relatedGuides!=null && relatedGuides.size()>0){%>
    <div id="relatedGuides">
        <h4 class="page-header" style="color:grey;">Related Guides (<%=relatedGuides.size()%>)</h4>
        <div class="container" align="center">
            <table style="width:80%">
                <tr><td class="header"></td>
                    <td>
                        <%for (Guide relatedGuide: relatedGuides) { %>
                        <a href="/toolkit/data/guide/system?id=<%=relatedGuide.getGuide_id()%>"><%=relatedGuide.getTargetSequence().toUpperCase()%></a><br>
                        <% } %>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <hr>
    <%}%>

    <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
    <hr>

    <div id="associatedStudies">
        <jsp:include page="associatedStudies.jsp"/>
    </div>

    <div id="associatedExperiments">
        <jsp:include page="associatedExperiments.jsp"/>
    </div>
    <div id="publications">
        <h4 class="page-header" style="color:grey;">Related Publications</h4>
        Coming soon...
    </div>
</main>