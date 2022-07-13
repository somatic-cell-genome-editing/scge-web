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

<script>
    $(function() {
        $("#myTable").tablesorter({
            theme : 'blue'

        });
    });
</script>
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
    <%@include file="search.jsp"%>
</div>
<div class="row">
    <div class="col-md-3" >
        <h4>Filter By Delivery System</h4>
        <ul class="list-group">
        <c:forEach items="${aggregations.deliveryAggs}" var="bkt">

            <li class="list-group-item"><a href="">${bkt.key}</a> (${bkt.docCount})</li>

        </c:forEach>
        </ul>
        <h4>Filter By Editor</h4>
        <ul class="list-group">
            <c:forEach items="${aggregations.editorAggs}" var="bkt">

                <li class="list-group-item"><a href="">${bkt.key}</a> (${bkt.docCount})</li>

            </c:forEach>
        </ul>
        <h4>Filter By Tissue</h4>
        <ul class="list-group">
            <c:forEach items="${aggregations.tissueAggs}" var="bkt">

                <li class="list-group-item"><a href="">${bkt.key}</a> (${bkt.docCount})</li>

            </c:forEach>
        </ul>
        <h4>Filter By Organism</h4>
        <ul class="list-group">
            <c:forEach items="${aggregations.organismAggs}" var="orgBkt">

                <li class="list-group-item"><a href="">${orgBkt.key}</a> (${orgBkt.docCount})</li>

            </c:forEach>
        </ul>
    </div>
    <div class="col-md-9">

    <table id="myTable" class="tablesorter">
        <thead>
        <tr>
            <th>Organism</th>
            <th>Animal model</th>
            <th>Editor</th>
            <th>Type of editing</th>
            <th>Delivery vehicle</th>
            <th>Target tissue</th>
            <th>Route of administration</th>
            <th>PI</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${sr.hits.hits}" var="hit">
            <tr>
                <td>${hit.sourceAsMap.organism}</td>
                <td>
                    <c:set var="first" value="true"/>
                    <c:forEach items="${hit.sourceAsMap.animalModels}" var="item">
                        <c:choose>
                            <c:when test="${first=='true'}">
                                ${item}
                                <c:set var="first" value="false"/>
                            </c:when>
                            <c:otherwise>
                                | <br> ${item}

                            </c:otherwise>
                        </c:choose>

                    </c:forEach>
                        </td>
                <td>${hit.sourceAsMap.editor}</td>
                <td>
                    <c:set var="first" value="true"/>
                    <c:forEach items="${hit.sourceAsMap.editTypes}" var="item">
                        <c:choose>
                            <c:when test="${first=='true'}">
                                ${item}
                                <c:set var="first" value="false"/>
                            </c:when>
                            <c:otherwise>
                                | <br> ${item}

                            </c:otherwise>
                        </c:choose>

                    </c:forEach>
                </td>
                <td>
                    <c:set var="first" value="true"/>
                    <c:forEach items="${hit.sourceAsMap.deliveryVehicles}" var="item">
                        <c:choose>
                            <c:when test="${first=='true'}">
                                ${item}
                                <c:set var="first" value="false"/>
                            </c:when>
                            <c:otherwise>
                                | <br> ${item}

                            </c:otherwise>
                        </c:choose>

                    </c:forEach>
                </td>
                <td>
                    <c:set var="first" value="true"/>
                    <c:forEach items="${hit.sourceAsMap.targetTissue}" var="item">
                        <c:choose>
                            <c:when test="${first=='true'}">
                                ${item}
                                <c:set var="first" value="false"/>
                            </c:when>
                            <c:otherwise>
                                | <br> ${item}

                            </c:otherwise>
                        </c:choose>

                    </c:forEach>
                </td>
                <td>
                    <c:set var="first" value="true"/>
                    <c:forEach items="${hit.sourceAsMap.routeOfAdministration}" var="item">
                        <c:choose>
                            <c:when test="${first=='true'}">
                                ${item}
                                <c:set var="first" value="false"/>
                            </c:when>
                            <c:otherwise>
                                | <br> ${item}

                            </c:otherwise>
                        </c:choose>

                    </c:forEach>
                </td>
                <td>${hit.sourceAsMap.pi}</td>
            </tr>
        </c:forEach>

        </tbody>
    </table>
    </div>
    </div>