<%@ page import="edu.mcw.scge.configuration.UserService" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.datamodel.Person" %>
<%@ page import="edu.mcw.scge.storage.ImageStore" %>
<%@ page import="edu.mcw.scge.dao.implementation.ImageDao" %>
<%@ page import="edu.mcw.scge.datamodel.Image" %>
<%@ page import="java.util.List" %>


<script src="//cdn.quilljs.com/1.3.6/quill.min.js"></script>

<!-- Theme included stylesheets -->
<link href="//cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
<link href="//cdn.quilljs.com/1.3.6/quill.bubble.css" rel="stylesheet">

<%
    {

    Access imageCheckAccess= new Access();
    Person imageCheckPerson = imageCheckAccess.getUser(request.getSession());
    ImageDao imageCheckIDao = new ImageDao();

    List<Image> images = imageCheckIDao.getImage(objectId,bucket);

      if (imageCheckAccess.isAdmin(imageCheckPerson)) { %>

        <% if (images.size() == 0) {%>

        <div id="<%=bucket%>form" style="display:none;">
        <form action="/toolkit/uploadFile?${_csrf.parameterName}=${_csrf.token}" method="POST" onsubmit="return <%=bucket%>addLegend()" enctype="multipart/form-data">
            <input type="hidden" name="id" value="<%=objectId%>"/>
            <input type="hidden" name="url" value="<%=redirectURL%>"/>
            <input type="hidden" name="bucket" value="<%=bucket%>"/>
            <table cellpadding=4 style="border:1px solid #007BFF; padding:2px; margin-top:10px; margin-bottom:5px;" align="center">
                <tr>
                    <td colspan="3" align="center"><input type="text" size=52 name="title" placeholder="Title"/></td>
                </tr>
                <tr>
                    <td><input type="file" id="<%=bucket%>file" name="filename"></td>
                    <td>&nbsp;</td>
                    <td><input type="submit" value="Upload"></td>
                </tr>
                <input type="hidden" id="<%=bucket%>Legend" name="legend" value="">
                <tr>
                    <td colspan="3"><div id="<%=bucket%>Editor"></div></td>
                </tr>
            </table>
        </form>
        </div>
<table align="center"><tr><td><a href="javascript:return void(0)" onclick="document.getElementById('<%=bucket%>form').style.display='block'; this.style.display='none';">Add&nbsp;image...</a></td></tr></table>
<script>
//var <%=bucket%>editor = new Quill('.<%=bucket%>Editor');  // First matching element will be used
var <%=bucket%>container = document.getElementById('<%=bucket%>Editor');

var <%=bucket%>options = {
    debug: 'info',

    modules: {
        //toolbar: '#toolbar'
        toolbar: [
            [{ "font": [] }, { "size": ["small", false, "large", "huge"] }], // custom dropdown

            ["bold", "italic", "underline", "strike","code"],

            [{ "color": [] }, { "background": [] }],

            [{ "script": "sub" }, { "script": "super" }],

            [{ "header": 1 }, { "header": 2 }, "blockquote", "code-block"],

            [{ "list": "ordered" }, { "list": "bullet" }, { "indent": "-1" }, { "indent": "+1" }],

            [{ "direction": "rtl" }, { "align": [] }],

            ["link", "image", "video", "formula"],

            ["clean"]
        ]
    },
    placeholder: 'Compose a legend...',
    //readOnly: false,
    theme: 'snow'
};

function <%=bucket%>addLegend() {
    if (document.getElementById("<%=bucket%>file").value == "") {
        alert("Please select a file");
        return false;
    }

    if (<%=bucket%>editor.getText().trim() != "") {
        document.getElementById("<%=bucket%>Legend").value=<%=bucket%>editor.root.innerHTML;
    }

    return true;
}


var <%=bucket%>editor = new Quill(<%=bucket%>container, <%=bucket%>options);
</script>

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
                <div style="border:1px double black; padding:5px; "><img  onload="resizeThis_<%=bucket%><%=image.getPosIndex()%>(this)" style="padding-bottom:10px;" src="/toolkit/store/<%=image.getScgeId()%>/<%=image.getBucket()%>/<%=image.getFileName()%>" /></div>
            </td>
        </tr>
        <% if (image.getLegend() != null && image.getLegend().trim().length() > 0) { %>
        <tr>
            <td><div style="border:1px solid black;padding:5px;"><%=image.getLegend()%></div></td>
        </tr>

        <% if (imageCheckAccess.isAdmin(imageCheckPerson)) { %>
        <form action="/toolkit/store/updateLegend?${_csrf.parameterName}=${_csrf.token}" method="POST">
            <input type="hidden" name="id" value="<%=objectId%>"/>
            <input type="hidden" name="url" value="<%=redirectURL%>"/>
            <input type="hidden" name="bucket" value="<%=bucket%>"/>
        <tr>
            <td><textarea name="legend" rows="4" cols="70"><%=image.getLegend()%></textarea></td>
        </tr>
        <tr>
            <td><input type="submit" value="Save"/></td>
        </tr>
        </form>
        <% } %>

        <% } %>
    </table>
</div>

<script>

    function resizeThis_<%=bucket%><%=image.getPosIndex()%>(img) {
            if (img) {
                //get the height to 60
                var goal=600;
                var width = img.naturalWidth;

                if (width < goal) {
                    return;
                }

                var diff = width - goal;
                var percentDiff = 1 - (diff / width);
                img.width=goal;
                img.height=parseInt(img.naturalHeight * percentDiff);

            }

    }
</script>



<% } %>
<% } %>
