<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 10/8/2020
  Time: 3:08 PM
  To change this template use File | Settings | File Templates.
--%>
<!--form
action="datasubmission/upload"
method="post"
enctype="multipart/form-data">
<input type="text" name="description" />
<input type="file" name="file" accept="video/*"/>
<input type="submit" />
</form-->

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<h3>${message}</h3>

<div>
    <form method="POST" enctype="multipart/form-data" action="uploadFile?${_csrf.parameterName}=${_csrf.token}">
        <table>
            <tr><td>File to upload:</td><td><input type="file" name="file" /></td></tr>
            <tr><td></td><td><input type="submit" value="Upload" /></td></tr>
        </table>
    </form>
</div>
<div>
    <ul>
        <c:forEach items="${files}" var="file">
        <li>
            <a href="${file}">${file}</a>

        </li>
        </c:forEach>
    </ul>
</div>

