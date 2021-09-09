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
    .summary tr th{
        width:50%;
        background-color: aliceblue;
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
    //  String resultType= (String) request.getAttribute("resultType");
    List<edu.mcw.scge.datamodel.Plot> plots= (List<Plot>) request.getAttribute("plots");
    List<Editor> comparableEditors= (List<Editor>) request.getAttribute("comparableEditors");

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
    <% if(comparableEditors!=null && comparableEditors.size()>0){%>
    <a href="#comparable">Comparable Editors</a>
    <%}%>
    <%if(images!=null && images.length>0){%>
    <a href="images">Images</a>
    <%}%>
    <% if(relatedGuides!=null && relatedGuides.size()>0){%>
    <a href="#relatedGuides">Related Guides</a>
    <%}%>


    <% if(plots!=null && plots.size()>0){%>
    <a href="#resultType"><%=plots.get(0).getTitle()%></a>
    <%}%>
    <a href="#associatedStudies">Associated Studies</a>
    <a href="#associatedExperiments">Associated Experiments</a>
    <a href="#publications">Related Publications</a>


</div>
<main role="main" class="col-md-10 ml-sm-auto px-4"  >
    <h4 class="page-header" style="color:grey;">Summary</h4>

    <div class="d-flex " id="summary" style="background-color: aliceblue">

        <div class="p-10">
            <table class="table table-sm summary" >
                <tr ><th >Symbol</th><td>&nbsp;<%=SFN.parse(editor.getSymbol())%></td></tr>
                <tr ><th >Species</th><td>&nbsp;<%=SFN.parse(editor.getSpecies())%></td></tr>
                <%if(editor.getEditorDescription()!=null && !editor.getEditorDescription().equals("")){%>
                <tr ><th class="header" >Description</th><td><%=SFN.parse(editor.getEditorDescription())%></td></tr>
                <%}%>
                <%if(editor.getType()!=null && !editor.getType().equals("")){%>
                <tr ><th class="header">Type</th><td style="white-space: nowrap"><%=editor.getType()%></td></tr>
                <%}%>
                <%if(editor.getSubType()!=null && !editor.getSubType().equals("")){%>
                <tr ><th class="header">Subtype</th><td style="white-space: nowrap"><%=editor.getSubType()%></td></tr>
                <%}%>
                <%if(editor.getAlias()!=null && !editor.getAlias().equals("")){%>

                <tr ><th class="header">Alias</th><td style="white-space: nowrap"><%=editor.getAlias()%></td></tr>
                <%}%>
                <%if(editor.getPamPreference()!=null && !editor.getPamPreference().equals("")){%>

                <tr ><th class="header">PAM</th><td style="white-space: nowrap"><%=editor.getPamPreference()%></td></tr>
                <%}%>
                <%if(editor.getEditorVariant()!=null && !editor.getEditorVariant().equals("")){%>

                <tr ><th class="header">Variant</th><td style="white-space: nowrap"><%=editor.getEditorVariant()%></td></tr>
                <%}%>
                <%if(editor.getActivity()!=null && !editor.getActivity().equals("")){%>

                <tr ><th class="header">Activity</th><td style="white-space: nowrap"><%=editor.getActivity()%></td></tr>
                <%}%>
                <%if(editor.getDsbCleavageType()!=null && !editor.getDsbCleavageType().equals("")){%>

                <tr ><th class="header">Cleavage Type</th><td style="white-space: nowrap"><%=editor.getDsbCleavageType()%></td></tr>
                <%}%>
                <%if(editor.getSource()!=null && !editor.getSource().equals("")){%>

                <tr ><th class="header">Source</th><td style="white-space: nowrap"><%=editor.getSource()%></td></tr>
                <%}%>

            </table>


        </div>
        <div class="ml-auto p-4" style="margin-right: 5%">

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
    <hr>
    <%if(editor.getProteinSequence()!=null && !editor.getProteinSequence().equals("")){%>

    <div id="proteinSequence">
        <h4 class="page-header" style="color:grey;">Protein Sequence</h4>
        <div class="container" align="center">
            <table style="">

                <tr ><td class="header"></td><td><pre><%=UI.formatFASTA(editor.getProteinSequence())%></pre></td></tr>

            </table>
        </div>
    </div>
    <hr>
    <%}%>
    <%if(comparableEditors!=null && comparableEditors.size()>0){%>
    <div id="comparable">
        <h4 class="page-header" style="color:grey;">Comparable Editors</h4>
        <div class="container" align="center">
            <table style="">
                <tr><td class="header"></td>
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
    <% if(plots!=null && plots.size()>0){%>
    <div id="resultType">
        <%
            java.util.Set<String> resulTypes=new HashSet<>();
            for(Plot p:plots){
                if(p.getTitle()!=null){
                    resulTypes.add(p.getTitle());
                }
            }
            StringBuilder resultTitle=new StringBuilder();
            boolean first=true;
            for(String r:resulTypes){
                if(first) {
                    resultTitle.append(r);
                    first=false;
                }
                else resultTitle.append("/").append(r);
            }
            if(resultTitle.equals("")){
                resultTitle.append("Efficiency");
            }
        %>
        <h4 class="page-header" style="color:grey;"><%=resultTitle.toString()%></h4>
        <%   for(Plot plot:plots){
            String resultType=plot.getTitle();
            if(resultType!=null && !resultType.equals("")){%>

        <h6 style="color:#2a6496;">Experiment: <a href="/toolkit/data/experiments/experiment/<%=plot.getExperiment().getExperimentId()%>"><%=plot.getExperiment().getName()%></a></h6>
        <%if(plot.getComparableObjects().size()>0){%>
        <div>Comparable Editors:

            <%     for(Object object:plot.getComparableObjects()){
                if( object instanceof Editor){
                    Editor cEditor= (Editor) object;
            %>
            <a href="/toolkit/data/editors/editor?id=<%=cEditor.getId()%>"><%=cEditor.getSymbol()%></a>&nbsp;
            <% } }%>
        </div>
        <% }%>
        <%@include file="plot.jsp"%>
        <hr>
        <%}}%>
    </div>

    <%  }%>
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