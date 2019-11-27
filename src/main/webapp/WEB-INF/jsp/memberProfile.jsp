<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/6/2019
  Time: 2:38 PM
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<script
        src="https://code.jquery.com/jquery-3.4.1.min.js"
        integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
        crossorigin="anonymous"></script>
<style>
    .scge-admin-table-label{
        width:10%
    }
    .scge-admin-table-value{
        width:20%
    }

</style>
<div class="container">
    <h3>
      <c:out value="${action}" /> Member Profile
    </h3>


        <div class="panel panel-default form-group"  >
            <form class="form form-inline" method="POST" action="${destination}" >
                <label for="scge-member"> Select the member </label>
                    <select class="form-group" id="scge-member" name="scgemember">

                            <c:choose>
                                <c:when test="${member!=null}">
                                    <c:forEach items="${members}" var="m">
                                        <c:choose>
                                            <c:when test="${m.id==member.id}">
                                                <option value="${m.id}" selected>${m.name}</option>

                                            </c:when>

                                            <c:otherwise>
                                                <option value="${m.id}">${m.name}</option>
                                            </c:otherwise>
                                        </c:choose>

                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${members}" var="m">
                                     <option value="${m.id}">${m.name}</option>
                                     </c:forEach>
                                </c:otherwise>
                            </c:choose>
                           </select>

                <span><button type="submit" class="form-group btn btn-default btn-xs">Submit</button></span>
            </form>
        </div>
    <c:if test="${member!=null}">
        <div class="panel panel-default form-group" style="padding:1%">
            <%@include file="profile.jsp"%>
        </div>
    </c:if>
</div>

