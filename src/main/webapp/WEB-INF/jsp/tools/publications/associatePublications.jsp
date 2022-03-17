<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.configuration.UserService" %><%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 3/15/2022
  Time: 12:18 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Access access = new Access();
    UserService userService = new UserService();
%>
<div class="container" style="height: available"  align="right">
    <form action="/toolkit/data/publications/associate?objectId=<%=request.getAttribute("objectId")%>&${_csrf.parameterName}=${_csrf.token}" method="post">
    <% if (access.isAdmin(userService.getCurrentUser(request.getSession()))) { %>
    <button class="btn btn-primary btn-sm" type="submit">Submit</button>
    <%}%>
    <table class="table">
    <c:forEach items="${publications}" var="pub">
        <tr><td>
            <div>
                <div class="row">
                        <div class="col-xs-1">
                            <input type="checkbox" name="refKey" value="${pub.reference.key}"/>&nbsp;
                        </div>
                        <div class="col-xs-2">
                            <label>Association Type
                                <select class="form-control form-control-sm" name="associationType${pub.reference.key}">
                                    <option value="assoicated">Associated</option>
                                    <option value="related">Related</option>
                                </select>
                            </label>
                        </div>
                        <div class="col">
                            <h5> <a href="/toolkit/data/experiments/study/${pub.articleIds[0].scgeId}" >${pub.reference.title}</a></h5>

                        </div>
                    </div>

                    <%@include file="referenceDetails.jsp"%>
            </div>
                </td></tr>


    </c:forEach>
    </table>
        <c:if test="${fn:length(publications)>3}">
    <% if (access.isAdmin(userService.getCurrentUser(request.getSession()))) { %>
    <button class="btn btn-primary btn-sm" type="submit">Submit
    </button>
    <%}%>
        </c:if>
    </form>
</div>
