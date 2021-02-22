<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 5/19/2020
  Time: 2:28 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" integrity="sha384-AYmEC3Yw5cVb3ZcuHtOA93w35dYTsvhLPVnYs9eStHfGJvOvKxVfELGroGkvsg+p" crossorigin="anonymous"/>


<style>
    td{
        font-size: 11px;

    }
    .list-group-item{
        padding: 2px;
        font-size: 12px;
        border: 1px solid white;
    }
    h4{
        color:#2a6496;
        font-weight: bold;
    }
    a{
        color:darkgray;
        text-decoration: underline;
    }
</style>
<div >
    <%--@include file="../tools/search.jsp"--%>
</div>
<div class="row">
    <div class="col-md-3" >
        <%@include file="sidebar.jsp"%>
    </div>
    <div class="col-md-9" id="results">
        <%@include file="resultsTable.jsp"%>

    </div>
</div>