<%@ page import="edu.mcw.scge.configuration.UserService" %>
<%@ page import="org.elasticsearch.cluster.coordination.Publication" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 3/7/2022
  Time: 10:37 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Access access = new Access();
    UserService userService = new UserService();
%>
<div style="margin-bottom:20px;">Directory of publications related and associated to data in the SCGE Toolkit</div>
<div class="container" style="height: available"  align="right">
    <form action="/toolkit/data/publications/associate?${_csrf.parameterName}=${_csrf.token}" method="post">
    <div align="right">
    <div class="row" style="width: 20%">
        <div class="col-xs-1"  align="right">
            <% if (access.isAdmin(userService.getCurrentUser(request.getSession()))) { %>
            <button class="btn btn-primary btn-sm" type="button"
                    onclick="javascript:location.href='/toolkit/data/publications/add'">Add Publication
            </button>
            <%}%>
        </div>
        <div class="col-xs-1" align="right">
            <% if (access.isAdmin(userService.getCurrentUser(request.getSession()))) { %>
            &nbsp;<button class="btn btn-primary btn-sm"   onclick="selectedRefKey(event)" >Associate</button>
            <% } %>
        </div>
    </div>
    </div>

    <table class="table">
    <c:forEach items="${publications}" var="pub">

        <tr>
            <td >
                <div>
                    <c:set var="pmid" value=""/>
                    <c:forEach items="${pub.articleIds}" var="id">
                        <c:if test="${id.idType=='pubmed'}">
                            <c:set var="pmid" value="${id.id}"/>
                        </c:if>
                    </c:forEach>
                    <h5> <% if (access.isAdmin(userService.getCurrentUser(request.getSession()))) { %>

                            <input type="checkbox" name="refKey" value="${pub.reference.key}"/>&nbsp;

                        <%}%>
                            ${pub.reference.title}<a href="https://pubmed.ncbi.nlm.nih.gov/${pmid}" target="_blank" >NCBI</a></h5>

           <%@include file="referenceDetails.jsp"%>
                </div>
            </td></tr>
    </c:forEach>
    </table>
    </form>
</div>

<script>
    function selectedRefKey(event) {

        var flag=false;
        $.each($('input[name="refKey"]'), function () {
            var _this = $(this);
           if( $(this).is(":checked")){
               flag=true;

           }

        });
       if(flag){
           $(this).submit();
       }else{
           event.preventDefault();
           alert("Please select the references to make associations")

       }
    }
</script>