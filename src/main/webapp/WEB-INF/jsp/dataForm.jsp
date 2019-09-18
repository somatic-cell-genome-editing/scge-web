<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 8/23/2019
  Time: 10:09 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<div class="container">
    <h3>
        <c:out value="${action}" /> member
    </h3>

    <form method="POST" action="${destination}" >

        <div class="form-group">
            <label for="studyName">Study Name</label>
            <input type="text" name="studyName" id="studyName" value="${fn:escapeXml(studyName)}" class="form-control" />
        </div>
        <div class="form-group">
            <label for="studyType">Study Type</label>
            <input type="text" name="studyType" id="studyType" value="${fn:escapeXml(studyType)}" class="form-control" />
        </div>
        <div class="form-group">
            <label for="experimentName">Experiment Name</label>
            <input type="text" name="experimentName" id="experimentName" value="${fn:escapeXml(ExperimentName)}" class="form-control" />
        </div>
        <div class="form-group">
            <label for="description">Description</label>
            <input type="text" name="description" id="description" value="${fn:escapeXml(description)}" class="form-control" />
        </div>



        <button type="submit" class="btn btn-success">Save</button>
    </form>
</div>
