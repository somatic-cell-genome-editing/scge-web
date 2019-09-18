<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">


    <title>SCGE - Dashboard</title>

    <!-- Bootstrap core CSS -->
    <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">

    <!-- Custom styles for this template -->
    <link href="/scge/css/dashboard.css" rel="stylesheet">
    <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
    <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>

</head>

<body>

<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container-fluid">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <img src="https://scge.mcw.edu/wp-content/uploads/2019/03/SCGElogo-50.jpg" srcset="https://scge.mcw.edu/wp-content/uploads/2019/03/SCGElogo-50.jpg 1x" width="72" height="50" alt="Somatic Cell Gene Editing Logo" data-retina_logo_url="" class="fusion-standard-logo" /><a class="navbar-brand" href="#">SCGE</a>
        </div>
        <div id="navbar" class="navbar-collapse collapse">

            <p class="navbar-text navbar-right">
                <c:choose>
                    <c:when test="${not empty token}">
                        <!-- using pageContext requires jsp-api artifact in pom.xml -->
                        <a href="logout" title="Sign out">
                            <c:if test="${not empty userImageUrl}">
                                <img class="img-circle" src="${userImageUrl}" width="24">
                            </c:if>
                                ${fn:escapeXml(userEmail)}
                        </a>
                    </c:when>
                    <c:when test="${isAuthConfigured}">
                        <a href="login">Login</a>
                    </c:when>
                </c:choose>
            </p>
            <ul class="nav navbar-nav navbar-right">
                <li><a href="success?destination=base">Dashboard</a></li>
                <!--li><a href="#">Settings</a></li-->
                <li><a href="#">Profile</a></li>
                <li><a href="#">Help</a></li>
            </ul>
            <form class="navbar-form navbar-right">
                <input type="text" class="form-control" placeholder="Search...">
            </form>
        </div>
    </div>
</nav>
<c:if test="${destination!='create'}">
<div class="container-fluid">
    <div class="row">
        <div class="col-sm-2 col-md-2 sidebar">
            <ul class="nav nav-sidebar">
                <li class="active"><a href="success?destination=base">Overview <span class="sr-only">(current)</span></a></li>
                <c:if test="${isGeneralAdmin}">
                    <li><a href="unauthorizedUsers">New user requests</a></li>
                    <li><a href="memberProfile">Update member profile</a></li>
                </c:if>
            </ul>
            <c:if test="${isGroupAdmin}">
            <ul class="nav nav-sidebar">

                <li><a href="#">Create new group</a></li>
                <li><a href="#">Add members to group</a></li>
                <li><a href="#">Delete Group</a></li>

            </ul>
            </c:if>
            <!--ul class="nav nav-sidebar">
                <li><a href="joinGroup">Join the Group</a></li>
                <li><a href="leaveGroup">Leave the Group</a></li>
                <li><a href="groups">List groups</a></li>
                <li><a href="members">List members</a></li>

            </ul-->
            <ul class="nav nav-sidebar">
                <li><a href="dataSubmission">Submit data</a></li>
                <!--li><a href="#">Update data</a></li-->
            </ul>
        </div>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <!--h1 class="page-header">Dashboard</h1-->

                <c:choose>
                    <c:when test="${action!=null}">
            <h1 class="page-header" style="color:grey">${action}  </h1>
                    </c:when>
                    <c:otherwise>
            <h1 class="page-header" style="color:grey">Dashboard</h1>
                        <p>Welcome to Somatic Cell Genome Editing</p>
                    </c:otherwise>
                </c:choose>

            <c:import url="/${page}.jsp" />

        </div>
    </div>
</div>
</c:if>
<c:if test="${destination=='create'}">
    <div class="container">
        <h4 style="color:cornflowerblue">Welcome to Somatic Cell Genome Editing</h4>
    </div>

    <c:import url="/${page}.jsp" />
</c:if>
<!-- Bootstrap core JavaScript
================================================== -->
<!-- Placed at the end of the document so the pages load faster -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>

</body>
</html>
