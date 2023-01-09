<%@ page import="edu.mcw.scge.configuration.SecurityConfiguration" %>
<%
    if (SecurityConfiguration.REQUIRE_AUTHENTICATION) {
%>
    <jsp:include page="login.jsp" />
<%
    }else {
%>
<jsp:include page="loginSuccess" />

<% } %>