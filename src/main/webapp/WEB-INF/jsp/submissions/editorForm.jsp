<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 9/18/2019
  Time: 2:36 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
    .editor{
        width:50%
    }
</style>
<div class="panel panel-default" >
    <div class="panel-heading" style="background-color:#4c91cd;color:white;font-weight: bold">Editor Form</div>
    <div class="panel panel-body">
        <div class="form-group editor">
            <label for="editor-id">Editor ID</label>
            <input type="text" name="editorId" id="editor-id" value="${fn:escapeXml(editorId)}" class="form-control form-control-sm" />

        </div>
        <div class="form-group form-inline">
        <label for="editor-name">Editor Name</label>
        <input type="text" name="editorName" id="editor-name" value="${fn:escapeXml(editorName)}" class="form-control form-control-sm" />
        <label for="editor-symbol">Symbol</label>
        <input type="text" name="editorSymbol" id="editor-symbol" value="${fn:escapeXml(editorSymbol)}" class="form-control form-control-sm" />
            </div>
        <div class="form-group editor">
            <label for="editor-type">Editor Type</label>
            <input type="text" name="editorType" id="editor-type" value="${fn:escapeXml(editorType)}" class="form-control form-control-sm" />
        </div>
        <div class="form-group editor">
            <label for="editor-subtype">Editor Subtype</label>
            <input type="text" name="editorSubType" id="editor-subtype" value="${fn:escapeXml(editorSubType)}" class="form-control form-control-sm" />
        </div>


        <button type="submit" class="btn btn-success">Save</button>

    </div>
</div>
