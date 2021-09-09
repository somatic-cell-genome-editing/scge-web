<%@ page import="edu.mcw.scge.configuration.UserService" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.datamodel.Person" %>
<%@ page import="edu.mcw.scge.storage.ImageStore" %>

<%

    {
    Access imageCheckAccess= new Access();
    Person imageCheckPerson = imageCheckAccess.getUser(request.getSession());
    String[] imageCheckImages = ImageStore.getImages(objectType, "" + objectId, bucket);

      if (imageCheckAccess.isAdmin(imageCheckPerson)) { %>

<form action="/toolkit/uploadFile?${_csrf.parameterName}=${_csrf.token}" method="POST" enctype="multipart/form-data">
    <input type="hidden" name="type" value="<%=objectType%>"/>
    <input type="hidden" name="id" value="<%=objectId%>"/>
    <input type="hidden" name="url" value="<%=redirectURL%>"/>
    <input type="hidden" name="bucket" value="<%=bucket%>"/>
    <table cellpadding=4 style="border:1px solid #007BFF; padding:2px; margin-top:10px; margin-bottom:5px;" align="center">
        <tr>
            <td><input type="file" id="myFile<%=objectId%>" name="filename"></td>
            <td>&nbsp;</td>
            <td><input type="submit" value="Upload"></td>
        </tr>
    </table>

</form>


    <% } %>


<div id="images">
    <table align="center">
        <%
            for (int i=0; i< imageCheckImages.length; i++) {
                if (imageCheckAccess.isAdmin(imageCheckPerson)) {
        %>
        <tr>
            <td align="right">
                <form action="/toolkit/store/remove?${_csrf.parameterName}=${_csrf.token}" method="POST">
                    <input type="hidden" name="type" value="<%=objectType%>"/>
                    <input type="hidden" name="id" value="<%=objectId%>"/>
                    <input type="hidden" name="url" value="<%=redirectURL%>"/>
                    <input type="hidden" name="filename" value="<%=imageCheckImages[i]%>"/>
                    <input type="hidden" name="bucket" value="<%=bucket%>"/>
                    <input style="color:red;" type="submit" value="X"/>
                </form>
        </tr>
        <% } %>
        <tr>
            <td align="center">
                <img  style="padding-bottom:10px;" src="/toolkit/store/<%=objectType%>/<%=objectId%>/<%=bucket%>/<%=imageCheckImages[i]%>" />
            </td>
        </tr>

        <% }

        %>
    </table>
</div>

<% } %>
