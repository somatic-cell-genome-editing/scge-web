<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 8/15/2019
  Time: 2:53 PM
  To change this template use File | Settings | File Templates.
--%>
<div class="container">
<h4>Initiative Details: </h4>
<form>
    <label>
        Principal Investigator:
        <input type="text" value="Mindy Dwinel" disabled name="pi">
    </label>
    <label>
        Institution/Lab:
        <input name="initiative" type="text" value="DCC" disabled/>
    </label>

        Select Study:
        <Select type="" id="study">
            <option value="0">New Study</option>
            <option value="1000">Change Sequence Reads</option>
            <option value="1001">Cre Control</option>
            <option value="1002">TLR2 Characterization</option>
        </Select>

    <!--button type="submit">Next</button-->
</form>

</div>
<div class="container">
    <%@include file="uploadForm.jsp"%>
</div>
