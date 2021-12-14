<%@ page import="edu.mcw.scge.datamodel.Person" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.mcw.scge.dao.implementation.PersonDao" %>
<%@ page import="edu.mcw.scge.dao.implementation.GroupDAO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    List<Person> people = (List<Person>)request.getAttribute("people");
    Person person = (Person) request.getAttribute("person");
%>

<div class="container-fluid">

    <div class="row">

        <nav class="col-md-2 d-none d-md-block bg-light sidebar position-fixed" id="sticky-sidebar">

            <div class="sidebar-sticky">
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link" href="/toolkit/admin">
                            <span data-feather="file"></span>
                            Sudo User
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/toolkit/admin/users">
                            <span data-feather="users"></span>
                            Manage Users                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/toolkit/admin/groupOverview">
                            <span data-feather="file"></span>
                            Groups Overview
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/toolkit/admin/studyTierUpdates">
                            <span data-feather="file"></span>
                            Study Tier Updates
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/toolkit/admin/seccheck">
                            <span data-feather="file"></span>
                            Security Check
                        </a>
                    </li>

                </ul>

                <h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-1 text-muted">
                    <span>Resources</span>
                    <a class="d-flex align-items-center text-muted" href="#">
                        <span data-feather="plus-circle"></span>
                    </a>
                </h6>

            </div>
        </nav>

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4" id="mainContent" style="border:1px solid #E5E5E5;padding-top:10px; padding-bottom:10px;">

            You are logged in as <b><%=person.getName()%></b>
            <br><br>
            <table>
                <tr>
                    <td>Become User</td>
                    <td>&nbsp;</td>
                    <td>
                        <form action="admin/sudo" method="get">
                            <select name="person">
                                <% for (Person p: people) { %>
                                <option value="<%=p.getId()%>"><%=p.getName()%></option>

                                <% } %>
                            </select>
                            <input type="submit">
                        </form>
                    </td>
                </tr>
            </table>
        </main>
    </div>
</div>

<br>

<!--a href="/toolkit/admin/users" style="font-size:20px;"/>Manage Users</a><br><br>
<a href="/toolkit/admin/groupOverview"  style="font-size:20px;" />Group Overview</a><br>
<a href="/toolkit/admin/studyTierUpdates"  style="font-size:20px;" />Study Tier Updates</a-->











