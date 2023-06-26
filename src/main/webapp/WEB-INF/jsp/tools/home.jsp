<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="edu.mcw.scge.dao.spring.CountQuery" %>
<%@ page import="edu.mcw.scge.dao.implementation.StatsDao" %>
<%@ page import="edu.mcw.scge.storage.ImageCache" %>
<%@ page import="edu.mcw.scge.service.DataAccessService" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.datamodel.Person" %><%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 5/8/2020
  Time: 2:05 PM
  To change this template use File | Settings | File Templates.
--%>

<% StatsDao sdao = new StatsDao();

    //preload the image cache
   ImageCache ic = ImageCache.getInstance();
    Access access= new Access();
    Person p = access.getUser(request.getSession());
%>
<style>
    .card-label {
        font-weight: bold;
        border: 0;
        color: #017dc4;
        font-size:20px;
        padding-left:20px;
    }
    .card-image {
        height:80px;
        width:80px;
    }
    .card-body {
        padding: 0.25rem;
    }
    .card {
        border:0px solid black;
    }
    .circle-icon {
        background: #34cceb;
        padding:15px;
        border-radius: 50%;
    }


</style>

<%@include file="hierarchical-chart.jsp"%>

<script src="https://unpkg.com/feather-icons/dist/feather.min.js"></script>
<script>
    feather.replace()
</script>