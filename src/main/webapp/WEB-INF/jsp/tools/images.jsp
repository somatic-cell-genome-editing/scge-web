<%--
  Created by IntelliJ IDEA.
  User: jdepons
  Date: 4/20/21
  Time: 10:54 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>

<div id="openseadragon1" style="width: 800px; height: 600px;"></div>
<script src="/toolkit/js/openseadragon/openseadragon.min.js"></script>
<script type="text/javascript">
    var viewer = OpenSeadragon({
        id: "openseadragon1",
        prefixUrl: "/toolkit/js/openseadragon/images/",
        tileSources: "/toolkit/common/images/tiff/sonthTiff.tif"
    });
</script>


hello

<embed width=200 height=200 src="tiffdocument.tif" type="image/tiff" negative=yes>



</body>
</html>
