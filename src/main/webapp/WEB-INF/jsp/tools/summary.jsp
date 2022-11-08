<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 11/8/2022
  Time: 9:23 AM
  To change this template use File | Settings | File Templates.
--%>
<div id="summary">
    <h4 class="page-header" style="color:grey;">Summary</h4>

    <div class="d-flex bg-light" >

        <div>
            <table class="table summary" >
                <c:forEach items="${summary}" var="item">
                <tr ><td class="header" >${item.key}</td><td>${item.value}</td></tr>
                </c:forEach>
            </table>


        </div>

    </div>
</div>