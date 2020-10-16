<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 8/15/2019
  Time: 2:53 PM
  To change this template use File | Settings | File Templates.
--%>
<div class="container">
<h4>Study Details: </h4>
<form>
    <label>
        Principal Investigator:
        <input type="text" value="Mindy Dwinel">
    </label>
    <label>
        Institution/Lab:
        <input type="text" value="DCC"/>
    </label>

        Select Study:
        <Select type="">
            <option>New Study</option>
            <option>Change Sequence Reads</option>
            <option>Cre Control</option>
            <option>TLR2 Characterization</option>
        </Select>

    <button type="submit">Next</button>
</form>

</div>
<div class="container">
    <%@include file="uploadForm.jsp"%>
</div>
