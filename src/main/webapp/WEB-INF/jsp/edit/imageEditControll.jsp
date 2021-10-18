<%@ page import="edu.mcw.scge.configuration.UserService" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.datamodel.Person" %>
<%@ page import="edu.mcw.scge.storage.ImageStore" %>
<%@ page import="edu.mcw.scge.dao.implementation.ImageDao" %>
<%@ page import="edu.mcw.scge.datamodel.Image" %>
<%@ page import="java.util.List" %>

<%
    {

    Access imageCheckAccess= new Access();
    Person imageCheckPerson = imageCheckAccess.getUser(request.getSession());
    ImageDao imageCheckIDao = new ImageDao();

    List<Image> images = imageCheckIDao.getImage(objectId,bucket);

      if (imageCheckAccess.isAdmin(imageCheckPerson)) { %>

        <% if (images.size() == 0) {%>

        <div id="<%=bucket%>form" style="display:none;">
        <form action="/toolkit/uploadFile?${_csrf.parameterName}=${_csrf.token}" method="POST" enctype="multipart/form-data">
            <input type="hidden" name="id" value="<%=objectId%>"/>
            <input type="hidden" name="url" value="<%=redirectURL%>"/>
            <input type="hidden" name="bucket" value="<%=bucket%>"/>
            <table cellpadding=4 style="border:1px solid #007BFF; padding:2px; margin-top:10px; margin-bottom:5px;" align="center">
                <tr>
                    <td colspan="3" align="center"><input type="text" size=52 name="title" placeholder="Title"/></td>
                </tr>
                <tr>
                    <td><input type="file" id="myFile<%=objectId%>" name="filename"></td>
                    <td>&nbsp;</td>
                    <td><input type="submit" value="Upload"></td>
                </tr>
                <tr>
                    <td colspan="3"><textarea name="legend" rows="5" cols="50" placeholder="Legend"></textarea></td>
                </tr>
            </table>
        </form>
        </div>
<table align="center"><tr><td><a href="javascript:return void(0)" onclick="document.getElementById('<%=bucket%>form').style.display='block'; this.style.display='none';">Add image...</a></td></tr></table>
        <% } %>

    <% } %>

<% if (images.size() > 0) {
    Image image = images.get(0);
%>
<div id="images">
    <table align="center" width="100px">
        <%
            if (imageCheckAccess.isAdmin(imageCheckPerson)) {
        %>
        <tr>
            <td align="right">
                <form action="/toolkit/store/remove?${_csrf.parameterName}=${_csrf.token}" method="POST">
                    <input type="hidden" name="id" value="<%=objectId%>"/>
                    <input type="hidden" name="url" value="<%=redirectURL%>"/>
                    <input type="hidden" name="bucket" value="<%=bucket%>"/>
                    <input style="color:red;" type="submit" value="X"/>
                </form>
        </tr>
        <% } %>
        <% if (image.getTitle() != null && image.getTitle().length() > 0) { %>
        <tr>
            <td style="font-size:24px;"><%=image.getTitle()%></td>
        </tr>
        <% }%>
        <tr>
            <td align="center">
                <img  style="padding-bottom:10px;" src="/toolkit/store/<%=image.getScgeId()%>/<%=image.getBucket()%>/<%=image.getFileName()%>" />
            </td>
        </tr>
        <% if (image.getLegend() != null && image.getLegend().length() > 0) { %>
        <tr>
            <td><div style="border:1px solid black;padding:5px;"><%=image.getLegend()%></div></td>
        </tr>
        <% } %>
    </table>
</div>



<% } %>
<% } %>
