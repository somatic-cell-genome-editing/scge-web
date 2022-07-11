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
<link href="/toolkit/css/reportPage.css" rel="stylesheet" type="text/css"/>

<script>
    $(function() {
        $("#myTable").tablesorter({
            theme : 'blue'

        });
    });
</script>

<% List<Guide> relatedGuides = (List<Guide>) request.getAttribute("guides");
    Editor editor = (Editor) request.getAttribute("editor");
    List<Editor> comparableEditors= (List<Editor>) request.getAttribute("comparableEditors");

%>


<%
    Access access= new Access();
    Person p = access.getUser(request.getSession());

    if (access.isAdmin(p)) {
%>
<div align="right"><a href="/toolkit/data/editors/edit?id=<%=editor.getId()%>"><button class="btn btn-primary">Edit</button></a></div>
<% } %>

<div class="col-md-2 sidenav bg-light">
    <a href="#summary">Summary</a>
    <%if(editor.getProteinSequence()!=null && !editor.getProteinSequence().equals("")){%>
    <a href="#proteinSequence">Protein Sequence</a>
    <%}%>

    <% if(comparableEditors!=null && comparableEditors.size()>0){%>
    <a href="#comparable">Comparable Editors</a>
    <%}%>
    <% if(relatedGuides!=null && relatedGuides.size()>0){%>
    <a href="#relatedGuides">Related Guides</a>
    <%}%>



    <a href="#associatedStudies">Associated Studies</a>
    <a href="#associatedExperiments">Associated Experiments</a>
    <!--a href="#publications">Related Publications</a-->


</div>
<main role="main" class="col-md-10 ml-sm-auto px-4"  >
    <div id="summary">
        <h4 class="page-header" style="color:grey;">Summary</h4>

    <div class="d-flex bg-light" >

        <div class="col-7">
            <table class="table table-sm summary" >
                <tr ><td class="header" >Symbol</td><td><%=SFN.parse(editor.getSymbol())%></td></tr>
                <tr ><td class="header" >Description</td><td><%=SFN.parse(editor.getEditorDescription())%></td></tr>
                <tr ><td class="header">Species</td><td><%=SFN.parse(editor.getSpecies())%></td></tr>
                <tr ><td class="header">Type</td><td style="white-space: nowrap"><%=SFN.parse(editor.getType())%></td></tr>
                <tr ><td class="header">Subtype</td><td style="white-space: nowrap"><%=SFN.parse(editor.getSubType())%></td></tr>
                <tr ><td class="header">Alias</td><td style="white-space: nowrap"><%=SFN.parse(editor.getAlias())%></td></tr>
                <tr><td colspan="2"><hr></td></tr>
                <tr ><td class="header">Activity</td><td style="white-space: nowrap"><%=SFN.parse(editor.getActivity())%></td></tr>
                <tr ><td class="header">Substrate</td><td style="white-space: nowrap"><%=SFN.parse(editor.getSubstrateTarget())%></td></tr>
                <tr ><td class="header">DSB Cleavage Type</td><td style="white-space: nowrap"><%=SFN.parse(editor.getDsbCleavageType())%></td></tr>
                <tr ><th class="header">PAM</th><td style="white-space: nowrap"><%=SFN.parse(editor.getPamPreference())%></td></tr>
                <tr ><td class="header">Variant</td><td style="white-space: nowrap"><%=SFN.parse(editor.getEditorVariant())%></td></tr>
                <tr ><td class="header">Fusion</td><td style="white-space: nowrap"><%=SFN.parse(editor.getFusion())%></td></tr>
                <tr ><td class="header">Annotated Map</td><td style="white-space: nowrap"><%=SFN.parse(editor.getAnnotatedMap())%></td></tr>
                <tr><td colspan="2"><hr></td></tr>

                <tr ><td class="header">Source</td><td style="white-space: nowrap"><%=SFN.parse(editor.getSource())%></td></tr>
                <tr ><td class="header">Catalog</td><td style="white-space: nowrap"><%=SFN.parse(editor.getCatalog())%></td></tr>
                <tr ><td class="header">RRID</td><td style="white-space: nowrap"><%=SFN.parse(editor.getRrid())%></td></tr>
                <tr><td colspan="2"><hr></td></tr>
                <tr ><td class="header">Target Locus</td><td style="white-space: nowrap"><%=SFN.parse(editor.getTargetLocus())%></td></tr>
                <tr ><td class="header">Target Sequence</td><td style="white-space: nowrap"><%=SFN.parse(editor.getTarget_sequence())%></td></tr>


                <tr ><td class="header">Position</td><td style="white-space: nowrap">
                    <% if (!SFN.parse(editor.getChr()).equals("")) {%>
                    <%=SFN.parse(editor.getAssembly())%>/<%=SFN.parse(editor.getChr())%>:<%=SFN.parse(editor.getStart())%>-<%=SFN.parse(editor.getStop())%> (<%=SFN.parse(editor.getStrand())%>)
                    <%}%>
                </td></tr>

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
            <table style="width: 80%">

                <tr ><td style="width: 10%"></td><td><pre><%=UI.formatFASTA(editor.getProteinSequence())%></pre></td></tr>

            </table>
        </div>
    </div>
    <hr>
    <%}%>
    <%if(comparableEditors!=null && comparableEditors.size()>0){%>
    <div id="comparable">
        <h4 class="page-header" style="color:grey;">Comparable Editors</h4>
        <div class="container" align="center">
            <table style="width: 80%">
                <tr><td style="width: 10%"></td>
                    <td>
                        <%for (Editor cEditor: comparableEditors) { %>
                        <a href="/toolkit/data/editors/editor?id=<%=cEditor.getId()%>"><%=cEditor.getSymbol()%></a><br>
                        <% } %>
                    </td>
                </tr>
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
                <tr><td style="width: 10%"></td>
                    <td>
                        <div style="height:200px; overflow:scroll;border:1px solid #E5E5E5;">
                        <%for (Guide relatedGuide: relatedGuides) { %>
                        <a style="padding-top:3px;" href="/toolkit/data/guide/system?id=<%=relatedGuide.getGuide_id()%>"><%=relatedGuide.getTargetSequence().toUpperCase()%></a><br>
                        <% } %>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <hr>
    <%}%>
    <%
        long objectId = editor.getId();
        String redirectURL = "/data/editors/editor?id=" + objectId;
        String bucket="main1";
    %>
    <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
    <% bucket="main2"; %>
    <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
    <% bucket="main3"; %>
    <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
    <% bucket="main4"; %>
    <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
    <% bucket="main5"; %>
    <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>
    <hr>

    <div id="associatedProtocols">
        <%@include file="/WEB-INF/jsp/tools/associatedProtocols.jsp"%>
    </div>
    <div id="associatedPublications">
        <%@include file="/WEB-INF/jsp/tools/publications/associatedPublications.jsp"%>
    </div>

    <div id="associatedStudies">
        <jsp:include page="associatedStudies.jsp"/>
    </div>
    <div id="associatedExperiments">
        <jsp:include page="associatedExperiments.jsp"/>
    </div>




    <!--div id="publications">
        <h4 class="page-header" style="color:grey;">Related Publications</h4>
        Coming soon...
    </div-->
</main>