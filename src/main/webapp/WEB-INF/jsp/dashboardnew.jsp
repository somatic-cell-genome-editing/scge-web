<%@ page import="edu.mcw.scge.dao.implementation.PersonDao" %>
<%@ page import="edu.mcw.scge.configuration.UserService" %>
<link rel="canonical" href="https://getbootstrap.com/docs/4.1/examples/dashboard/">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!--div align="center">
    <!c:forEach items="$-{personInfoList}" var="i"-->
        <!--p style="padding: 0;" class="text-muted">
            <strong>Initiative:</strong> $--{i.groupName} &nbsp;
            <strong>User Group:</strong> $--{i.subGroupName}</p-->
    <!--/c:forEach-->
<!--/div-->

<%
    List<Study> studyList = (List<Study>) request.getAttribute("studies");
    List<Study> studiesShared = (List<Study>) request.getAttribute("studiesShared");
    List<PersonInfo> personInfoRecords = (List<PersonInfo>) request.getAttribute("personInfoRecords");
%>
<div class="container-fluid">
    <div class="row">
        <nav class="col-md-2 d-none d-md-block bg-light sidebar">
            <div class="sidebar-sticky">
                <ul class="nav flex-column">
                    <!--li class="nav-item">
                        <a class="nav-link active" href="#" onclick="getMainContent('home')">
                            <span data-feather="home"></span>
                            Dashboard <span class="sr-only">(current)</span>
                        </a>
                    </li-->
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <span data-feather="file"></span>
                            My Studies
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/toolkit/data/studies/search">
                            <span data-feather="file"></span>
                            All Studies
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <span data-feather="users"></span>
                            My Group
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <span data-feather="users"></span>
                            Working Groups
                        </a>
                    </li>

                </ul>

                <h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-1 text-muted">
                    <span>Resources</span>
                    <a class="d-flex align-items-center text-muted" href="#">
                        <span data-feather="plus-circle"></span>
                    </a>
                </h6>
                <!--ul class="nav flex-column mb-2">
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <span data-feather="file-text"></span>
                            <%--=s.getStudyId()--%>..
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <span data-feather="file-text"></span>
                            Submit Data ..
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <span data-feather="file-text"></span>
                            Point of Contacts
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <span data-feather="file-text"></span>
                            Forms
                        </a>
                    </li>

                </ul-->
            </div>
        </nav>

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4" id="mainContent">
            <h2>My Studies</h2>
            <% if (studyList.size() ==0) { %>
                You have not submitted any studies
            <% } else { %>
                <%@include file="tools/studies.jsp"%>
            <% } %>
        </main>
        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4" id="mainContent2">
            <h2>Studies Shared with Me</h2>
            <% if (studiesShared.size() ==0) { %>
                0 Studies shared with me
            <% } else {%>
            <table id="myTable2" class="tablesorter">
                <thead>
                <tr><th></th>
                    <th>Tier</th>
                    <th>Name</th>
                    <th>Institution</th>
                    <th>Contact PI</th>
                    <th>Submission Date</th>
                </tr>
                </thead>

            <%  UserService userService = new UserService();
                for (Study shared: studiesShared) { %>

                <tr>
                    <td>
                    </td>
                    <td>
                        <%=shared.getTier()%>
                    </td>
                    <td><%if(new Access().hasStudyAccess(shared,userService.getCurrentUser(request.getSession()))) {  %>
                        <a href="/toolkit/data/experiments/study/<%=shared.getStudyId()%>"><%=shared.getStudy()%></a>
                        <%} else { %>
                        <%=shared.getStudy()%>
                        <% } %>
                    </td>
                    <td><%=shared.getLabName()%></td>
                    <td><%=shared.getPi()%></td>
                    <td><%=UI.formatDate(shared.getSubmissionDate())%></td>
                </tr>
            <%}%>
            </table>
            <% } %>
        </main>

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4" id="mainContent3">
            <h2>Groups I'm a Member Of</h2>

            <% for (PersonInfo pi: personInfoRecords) { %>
                <p style="padding: 0;" class="text-muted">
                <strong>Initiative:</strong> <%=pi.getGroupName()%> &nbsp;
                <strong>User Group:</strong> <%=pi.getSubGroupName()%></p>
            <% } %>

        </main>

    </div>
</div>

<!-- Icons -->
<script src="https://unpkg.com/feather-icons/dist/feather.min.js"></script>
<script>
    feather.replace()
</script>

