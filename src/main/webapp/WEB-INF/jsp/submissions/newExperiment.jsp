<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/18/2019
  Time: 10:41 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="panel panel-default" >
    <div class="panel-heading" style="background-color:#4c91cd;color:white;font-weight: bold">Experiment Data Submission Form</div>
    <div class="panel panel-body">

            <div class="form-group form-inline">
                <label for="exprimentName">Experiment Name</label>
                <input type="text" name="experimentName" id="exprimentName" value="${fn:escapeXml(experimentName)}" class="form-control" />
                <label for="group">Group</label>
                <input type="text" name="group" id="group" value="${fn:escapeXml(groupName)}" class="form-control" />
            </div>
                <div class="form-group">
                <span><button class="glyphicon glyphicon-plus"></button>&nbsp;&nbsp; <a href="form?formType=cellLineForm">Add Cell Line</a> </span>
                </div>
                <c:if test="${cellLineForm!=null}">
                <div>

                        <form class="form" action="${destination}">
                            <c:import url="${cellLineForm}.jsp" />
                        </form>

                    </div>
                    </c:if>
                <div class="form-group">
                    <span><button class="glyphicon glyphicon-plus"></button>&nbsp;&nbsp;<a href="form?formType=editorForm">Add Editor</a>  </span>
                </div>
                <c:if test="${editorForm!=null}">
                    <div>

                        <form class="form" action="${destination}">
                            <c:import url="${editorForm}.jsp" />
                        </form>

                    </div>
                </c:if>
                <div class="form-group">
                    <span><button class="glyphicon glyphicon-plus"></button>&nbsp;&nbsp;Add Delivery Vehicle  </span>
                </div>
                <div class="form-group">
                    <span><button class="glyphicon glyphicon-plus"></button>&nbsp;&nbsp;Add Reporter Animal  </span>
                </div>
                <div class="form-group">
                    <span>  <button class="glyphicon glyphicon-plus"></button>&nbsp;&nbsp;Add Application </span>
                </div>
                <div class="form-group">
                    <span><button class="glyphicon glyphicon-plus"></button>&nbsp;&nbsp;Add Test Method</span>
                </div>
                <div class="form-group">
                    <span> <button class="glyphicon glyphicon-plus"></button>&nbsp;&nbsp;Add Results</span>
                </div>


    </div>
</div>
