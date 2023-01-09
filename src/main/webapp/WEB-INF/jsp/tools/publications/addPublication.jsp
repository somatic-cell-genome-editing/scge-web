<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page import="edu.mcw.scge.datamodel.publications.Publication" %><%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 3/14/2022
  Time: 10:16 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div class="card">

    <div class="card-body">
        <h6 style="color: green">${message}</h6>
        <form action="/toolkit/data/publications/add?${_csrf.parameterName}=${_csrf.token}" method="post">

            <div class="form-group">
                <label>Enter PubMed Identifier:
                    <input class="form-control form-control-sm" type="text" name="identifier" placeholder="Enter Id..">
                </label>
            </div>
            <div class="form-group">
                <button class="btn btn-sm btn-primary" type="submit">Submit</button>
            </div>
        </form>
    </div>
</div>