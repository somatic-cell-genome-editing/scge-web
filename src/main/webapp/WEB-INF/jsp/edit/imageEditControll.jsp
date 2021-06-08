<%@ page import="edu.mcw.scge.configuration.UserService" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.datamodel.Person" %>
<%@ page import="edu.mcw.scge.storage.ImageStore" %>




<%
    UserService imageCheckUserService=new UserService();
    Access imageCheckAccess= new Access();
    Person imageCheckPerson = imageCheckAccess.getUser(request.getSession());
%>

<% System.out.println("im here sddddsd");  %>

<% if (imageCheckAccess.isAdmin(imageCheckPerson)) { %>
<table cellpadding=4 style="border:1px solid #007BFF; background-color:#ECECF9; padding:2px; margin-top:10px; margin-bottom:5px;" align="center">
    <form action="/toolkit/uploadFile?${_csrf.parameterName}=${_csrf.token}" method="POST" enctype="multipart/form-data">
        <input type="hidden" name="type" value="<%=objectType%>"/>
        <input type="hidden" name="id" value="<%=objectId%>"/>
        <input type="hidden" name="url" value="<%=redirectURL%>"/>
        <tr>
            <td><input type="file" id="myFile" name="filename"></td>
            <td>&nbsp;</td>
            <td><input type="submit"></td>
        </tr>
    </form>
</table>

<% } %>
<% System.out.println("im here dddsdfsd");  %>

<table align="center">
    <%
        String[] images = ImageStore.getImages(objectType, "" + objectId);

        for (int i=0; i< images.length; i++) {

            if (imageCheckAccess.isAdmin(imageCheckPerson)) {
    %>
    <tr>
        <td align="right">
            <form action="/toolkit/store/remove?${_csrf.parameterName}=${_csrf.token}" method="POST">
                <input type="hidden" name="type" value="<%=objectType%>"/>
                <input type="hidden" name="id" value="<%=objectId%>"/>
                <input type="hidden" name="url" value="<%=redirectURL%>"/>
                <input type="hidden" name="filename" value="<%=images[i]%>"/>
                <input style="color:red;" type="submit" value="X"/>
            </form>
    </tr>
    <% } %>
    <tr>
        <td align="center">
            <img style="padding-bottom:10px;" src="/toolkit/store/<%=objectType%>/<%=objectId%>/<%=images[i]%>" />
        </td>
    </tr>

    <% } %>
</table>
<% System.out.println("im here sddddddddddfsd");  %>

