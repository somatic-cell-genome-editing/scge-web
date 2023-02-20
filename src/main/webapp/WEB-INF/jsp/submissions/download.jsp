<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="edu.mcw.scge.datamodel.Study" %>
<%@ page import="edu.mcw.scge.process.UI" %>
<%@ page import="edu.mcw.scge.datamodel.Person" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 10/8/2020
  Time: 3:08 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    ArrayList<String> files = (ArrayList<String>) request.getAttribute("files");
    Study study = (Study) request.getAttribute("study");
%>

    <div style="float:right">
        <button style="margin-bottom:15px;" class="btn btn-primary btn-sm" type="button"
                onclick="javascript:location.href='/toolkit/data/experiments/group/${study.groupId}'">Go to Project
        </button>
    </div>

<table>
    <tr>
        <td style="font-weight:700">Study ID:</td><td>&nbsp;&nbsp;</td><td><%=study.getStudyId()%></td>
    </tr>
    <tr>
        <td style="font-weight:700">Name:</td><td>&nbsp;&nbsp;</td><td><%=study.getStudy()%></td>
    </tr>
    <tr>
        <td style="font-weight:700">PI:</td><td>&nbsp;&nbsp;</td><td>
        <%for(Person p:study.getMultiplePis()){%>
        <%=p.getName()%><br>
       <% }%>
      </td>
    </tr>
    <tr>
        <td style="font-weight:700">Institution:</td><td>&nbsp;&nbsp;</td><td><%=study.getLabName()%><br></td>
    </tr>
    <tr>
        <td style="font-weight:700">Submission Date:</td><td>&nbsp;&nbsp;</td><td><%=UI.formatDate(study.getSubmissionDate())%></td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>

    <% if (files.size() ==0) { %>
        <tr>
            <td>0 files currently avaiable for this study</td>
        </tr>
    <% } %>

        <% for (String file: files) {
            String[] fileParts = file.split("/");

        %>
          <tr>
              <td></td>
              <td></td>
              <td>
            <li>
                <a href="<%=file%>"><script>document.write(unescape('<%=fileParts[fileParts.length -1]%>'))</script></a>
            </li>
              </td>
          </tr>
        <% } %>
</table>

