<%@ page import="edu.mcw.scge.process.UI" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.datamodel.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/29/2020
  Time: 4:25 PM
  To change this template use File | Settings | File Templates.
--%>

<% List<Guide> relatedGuides = (List<Guide>) request.getAttribute("guides");
    Editor editor = (Editor) request.getAttribute("editor");
    Access access= new Access();
    Person p = access.getUser(request.getSession());
    if (access.isAdmin(p) && !SCGEContext.isProduction()) {
%>
<div align="right"><a href="/toolkit/data/editors/edit?id=<%=editor.getId()%>"><button class="btn btn-primary">Edit</button></a></div>
<% } %>

<div class="col-md-2 sidenav bg-light">
    <a href="#summary">Summary</a>
    <%if(editor.getProteinSequence()!=null && !editor.getProteinSequence().equals("")){%>
    <a href="#proteinSequence">Protein Sequence</a>
    <%}%>

    <% if(relatedGuides!=null && relatedGuides.size()>0){%>
    <a href="#relatedGuides">Related Guides</a>
    <%}%>
    <a href="#associatedStudies">Projects & Experiments</a>
</div>
<main role="main" class="col-md-10 ml-sm-auto px-4"  >
 <%@include file="summary.jsp"%>

    <%if(editor.getProteinSequence()!=null && !editor.getProteinSequence().equals("")){%>
    <hr>
    <div id="proteinSequence">
        <h4 class="page-header" style="color:grey;">Protein Sequence</h4>
        <div class="container" align="center">
            <table style="width: 80%">

                <tr ><td style="width: 10%"></td><td><pre><%=UI.formatFASTA(editor.getProteinSequence())%></pre></td></tr>

            </table>
        </div>
    </div>
    <%}%>
    <%if(relatedGuides!=null && relatedGuides.size()>0){%>
    <hr>
    <div id="relatedGuides">
        <h4 class="page-header" style="color:grey;">Related Guides (<%=relatedGuides.size()%>)</h4>
        <div class="container" align="center">
            <table style="width:80%">
                <tr><td style="width: 10%"></td>
                    <td>
                        <div style="height:200px; overflow:auto;border:1px solid #E5E5E5;">
                        <%

                            for (Guide relatedGuide: relatedGuides) {
                                if (access.hasGuideAccess(relatedGuide,p) && relatedGuide.getTargetSequence()!=null) {
                        %>
                                    <a style="padding-top:3px;" href="/toolkit/data/guide/system?id=<%=relatedGuide.getGuide_id()%>"><%=relatedGuide.getTargetSequence().toUpperCase()%></a><br>
                        <%      }
                            } %>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </div>
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


    <div id="associatedProtocols">
        <%@include file="/WEB-INF/jsp/tools/associatedProtocols.jsp"%>
    </div>
    <div id="associatedPublications">
        <%@include file="/WEB-INF/jsp/tools/publications/associatedPublications.jsp"%>
    </div>

    <div id="associatedStudies">
        <jsp:include page="associatedStudies.jsp"/>
    </div>

</main>