


<%@ page import="edu.mcw.scge.storage.FileUploadController" %>

Welcome to bulk image upload

<form action="bulkUpload">
<table>
    <tr>
        <td>Directory Containing Images</td>
        <td><input name="dir" type="text" value="/Users/jdepons/imagesAron/imageFiles"/></td>
    </tr>
    <tr>
        <td>Index File</td>
        <td><input name="index" type="text" value="/Users/jdepons/imagesAron/index.csv"/></td>
    </tr>
    <tr>
        <td>Bucket</td>
        <td><input name="bucket" type="text" value="main1"/></td>
    </tr>
    <tr>
        <td>File Type</td>
        <td><input name="type" type="text" value="png"/></td>
    </tr>
    <tr>
        <td colspan="2" align="center"><input type="submit" value="Upload Images"/></td>
    </tr>
</table>
</form>


asdfasd
<%
  if (request.getParameter("dir") !=null) {

      FileUploadController.handleFileUploadBatch(request, response);

  }
    //System.out.println("hello");

%>






