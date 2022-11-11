<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 11/8/2022
  Time: 9:23 AM
  To change this template use File | Settings | File Templates.
--%>
<link href="/toolkit/css/reportPage.css" rel="stylesheet" type="text/css"/>

<div id="summary">
    <h4 class="page-header" style="color:grey;">Summary</h4>

    <div class="d-flex bg-light" >

        <div>
            <table class="table summary" >
                <c:set var="first" value="true"/>
                <c:forEach items="${summaryBlocks}" var="block">
                    <c:choose>
                        <c:when test="${first==true}">
                            <c:set var="first" value="false"/>
                        </c:when>
                        <c:otherwise>
                            <tr><td colspan="2"><hr></td></tr>
                        </c:otherwise>
                    </c:choose>
                    <c:forEach items="${block.value}" var="item">
                        <tr ><td class="header" >${item.key}</td><td>${item.value}</td></tr>
                    </c:forEach>
                </c:forEach>
            </table>


        </div>

    </div>
</div>