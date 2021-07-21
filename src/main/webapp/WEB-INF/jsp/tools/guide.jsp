<%@ page import="edu.mcw.scge.datamodel.Guide" %>
<%@ page import="edu.mcw.scge.web.SFN" %>
<%@ page import="edu.mcw.scge.datamodel.Editor" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.web.UI" %>
<%@ page import="edu.mcw.scge.datamodel.OffTarget" %>
<%@ page import="edu.mcw.scge.storage.ImageTypes" %>
<%@ page import="com.google.gson.Gson" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/29/2020
  Time: 4:25 PM
  To change this template use File | Settings | File Templates.
--%>

<style>
    .table{
        border:1px solid white;
    }
   .table td, .table th{

        border: 1px solid white;
        padding: 0;
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

</style>

<% Guide g = (Guide) request.getAttribute("guide"); %>
<% List<Editor> relatedEditors = (List<Editor>) request.getAttribute("editors");
    List<OffTarget> offTargets = (List<OffTarget>) request.getAttribute("offTargets");
%>



<%
    long objectId = g.getGuide_id();
    String objectType= ImageTypes.GUIDE;
    String redirectURL = "/data/guide/system?id=" + objectId;
    String bucket="topRight";
    String[] images = ImageStore.getImages(objectType, "" + objectId, bucket);


%>
<div class="col-md-2 sidenav bg-light">

        <a href="#summary">Summary</a>
        <%if(images!=null && images.length>0){%>
        <a href="images">Images</a>
        <%}%>
    <%if(g.getSpecies()!=null && g.getSpecies().equalsIgnoreCase("human")){%>
    <a href="#sequenceViewer">Sequence Viewer</a>
    <%}%>
    <% if(relatedEditors!=null && relatedEditors.size()>0){%>
    <a href="#editor">Related Editor</a>
    <%}%>
    <%if(!SFN.parse(g.getVectorId()).equals("")){%>
    <a href="#vector">Vector</a>
    <%}%>
    <%if(offTargets!=null && offTargets.size()>0){%>
        <a href="#offTargets">Off Targets</a>
    <%}%>
        <a href="#associatedStudies">Associated Studies</a>
        <a href="#associatedExperiments">Associated Experiments</a>


</div>
<main role="main" class="col-md-10 ml-sm-auto px-4"  >
    <h4 class="page-header" style="color:grey;">Summary</h4>

<div class="d-flex bg-light" id="summary" >
    <div class="p-2">
        <table class="table">
            <%if(!SFN.parse(g.getTargetLocus()).equals("")){%>
        <tr ><th  class="field-name" >Target Locus</th><td>&nbsp;<%=SFN.parse(g.getTargetLocus())%></td></tr>
        <%}%>
            <%if(!SFN.parse(g.getTargetSequence()).equals("")){%>
            <tr ><th>Target Sequence</th><td>&nbsp;<%=SFN.parse(g.getTargetSequence())%></td></tr>
            <%}%>
            <%if(!SFN.parse(g.getPam()).equals("")){%>

            <tr ><th style=" white-space: nowrap;">Target Sequence&nbsp;+ PAM</th><td>&nbsp;<%=SFN.parse(g.getPam())%></td></tr>
            <%}%>
            <%if(!SFN.parse(g.getAssembly()).equals("")){%>
            <tr ><th>Assembly</th><td>&nbsp;<%=SFN.parse(g.getAssembly())%></td></tr>
            <%}%>
                <%if(!SFN.parse(g.getStrand()).equals("")){%>
            <tr ><th >Strand</th><td>&nbsp;<%=SFN.parse(g.getStrand())%></td></tr>
            <%}%>
            <% if(g.getChr()!=null && g.getStart()!=null && g.getStop()!=null){%>

            <tr><th>Guide Location:</th><td>&nbsp;<%=g.getChr()+":"+g.getStart()+".."+g.getStop()%></td></tr>
            <%}%>
            <% if(g.getGuideDescription()!=null && !g.getGuideDescription().equals("")){%>
        <tr ><th >Description</th><td>&nbsp;<%=SFN.parse(g.getGuideDescription())%></td></tr>
        <%}%>

                <tr ><th >Spacer Sequence</th><td>&nbsp;<%=SFN.parse(g.getSpacerSequence())%></td></tr>
                <tr ><th >Spacer Length</th><td>&nbsp;<%=SFN.parse(g.getSpacerLength())%></td></tr>
                <% if(!SFN.parse(g.getModifications()).equals("")){%>
                <tr ><th >Modifications</th><td>&nbsp;<%=SFN.parse(g.getModifications())%></td></tr>
                <%}%>
                <% if(!SFN.parse(g.getRepeatSequence()).equals("")){%>
                <tr ><th >Repeat Sequence</th><td>&nbsp;<%=SFN.parse(g.getRepeatSequence())%></td></tr>
                <%}%>
                <% if(!SFN.parse(g.getAntiRepeatSequence()).equals("")){%>
                <tr ><th >Anti-Repeat Sequence</th><td>&nbsp;<%=SFN.parse(g.getAntiRepeatSequence())%></td></tr>
                <%}%>
                <% if(!SFN.parse(g.getStemloop1Sequence()).equals("")){%>
                <tr ><th >Stemloop 1 Sequence</th><td>&nbsp;<%=SFN.parse(g.getStemloop1Sequence())%></td></tr>
                <%}%>
                <% if(!SFN.parse(g.getStemloop2Sequence()).equals("")){%>
                <tr ><th >Stemloop 2 Sequence</th><td>&nbsp;<%=SFN.parse(g.getStemloop2Sequence())%></td></tr>
                <%}%>
                <% if(!SFN.parse(g.getStemloop3Sequence()).equals("")){%>
                <tr ><th >Stemloop 3 Sequence</th><td>&nbsp;<%=SFN.parse(g.getStemloop3Sequence())%></td></tr>
                <%}%>

    </table>
    </div>
    <div class="ml-auto p-2" style="margin-right: 5%">

        <div class="card">
            <div class="card-header">Guide</div>
            <div class="card-body">
        <table >
            <tr ><th >SCGE ID</th><td>&nbsp;<%=g.getGuide_id()%></td></tr>
            <tr ><th >Name</th><td>&nbsp;<%=SFN.parse(g.getGrnaLabId())%></td></tr>
            <tr ><th >Species</th><td>&nbsp;<%=SFN.parse(g.getSpecies())%></td></tr>
        </table>
            </div>
        </div>
        <%@include file="/WEB-INF/jsp/edit/imageEditControll.jsp"%>

    </div>

</div>
    <div id="images">
    <table align="center">
        <%
            for (int i=0; i< images.length; i++) {

                if (imageCheckAccess.isAdmin(imageCheckPerson)) {
        %>
        <tr>
            <td align="right">
                <form action="/toolkit/store/remove?${_csrf.parameterName}=${_csrf.token}" method="POST">
                    <input type="hidden" name="type" value="<%=objectType%>"/>
                    <input type="hidden" name="id" value="<%=objectId%>"/>
                    <input type="hidden" name="url" value="<%=redirectURL%>"/>
                    <input type="hidden" name="filename" value="<%=images[i]%>"/>
                    <input type="hidden" name="bucket" value="<%=bucket%>"/>
                    <input style="color:red;" type="submit" value="X"/>
                </form>
        </tr>
        <% } %>
        <tr>
            <td align="center">
                <img  style="padding-bottom:10px;" src="/toolkit/store/<%=objectType%>/<%=objectId%>/<%=bucket%>/<%=images[i]%>" />
            </td>
        </tr>

        <% }
        %>
    </table>
    </div>
    <hr>
    <%if(g.getSpecies()!=null && g.getSpecies().equalsIgnoreCase("human")){

    %>
    <script>
        //  var range="13:32315508..32400268";

        //  var range="<%--=g.getChr().replace("chr", "")+":"+g.getStart()+".."+g.getStop()--%>";

        var chr='<%=g.getChr().replace("chr", "")%>';
        var start="<%=g.getStart()%>";
        var stop="<%=g.getStop()%>";
        var guide='<%=new Gson().toJson(g)%>';

    </script>
    <div id="sequenceViewer">
        <h4 class="page-header" style="color:grey;">Sequence Viewer</h4>
        <%@include file="sequenceViewer.jsp"%>

    </div>
    <hr>
    <%}%>

   <% if(relatedEditors!=null && relatedEditors.size()>0){%>
    <div id="editor">
    <h4 class="page-header" style="color:grey;">Related Editor</h4>
    <table class="table">
        <tr><td >Related Editors</td>
            <td>
                <%for (Editor relatedEditor: relatedEditors) { %>
                <a href="/toolkit/data/editors/editor?id=<%=relatedEditor.getId()%>" ><%=UI.replacePhiSymbol(relatedEditor.getSymbol())%></a><br>
                <% } %>
            </td>
        </tr>
    </table>

    </div>
    <hr>
    <%}%>


    <%if(!SFN.parse(g.getVectorId()).equals("")){%>
    <div id="vector">
        <h4 class="page-header" style="color:grey;">Vector Details</h4>
            <table class="table">

            <tr ><td >Ivt Construct Source</td><td><%=SFN.parse(g.getIvtConstructSource())%></td></tr>
            <tr ><td >Vector Id</td><td><%=SFN.parse(g.getVectorId())%></td></tr>
            <tr ><td >Vector Name</td><td><%=SFN.parse(g.getVectorName())%></td></tr>
            <tr ><td >Vector Description</td><td><%=SFN.parse(g.getVectorDescription())%></td></tr>
            <tr ><td >Vector Type</td><td><%=SFN.parse(g.getVectorType())%></td></tr>

            <tr ><td >Annotated Map</td><td><%=SFN.parse(g.getAnnotatedMap())%></td></tr>

        </table>
    </div>
    <hr>
    <%}%>
    <%if(offTargets!=null && offTargets.size()>0){%>
    <div id="offTargets">
        <h4 class="page-header" style="color:grey;">Off Targets</h4>
        <table class="table" >
            <tr><th>Detection Method</th><th>No. of sites detected</th></tr>
            <%for (OffTarget offTarget: offTargets) { %>
            <tr>
                <td><%=offTarget.getDetectionMethod()%></td>
                <td><%=offTarget.getNoOfSitesDetected()%><br>

                </td>
            </tr>
            <% } %>
        </table>
        <h4 class="page-header" style="color:grey;">Specificity</h4>
        <table class="table">
            <tr ><th >Specificity Ratio</th><td><%=SFN.parse(g.getSpecificityRatio())%></td></tr>

        </table>
    </div>
    <hr>
    <%}%>
    <div id="associatedStudies">
    <jsp:include page="associatedStudies.jsp"/>
    </div>
    <div id="associatedExperiments">
    <jsp:include page="associatedExperiments.jsp"/>
    </div>
</main>