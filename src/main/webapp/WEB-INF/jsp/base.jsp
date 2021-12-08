<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <title>Somatic Cell Gene Editing</title>
    <link rel='dns-prefetch' href='//s.w.org' />
    <link rel="alternate" type="application/rss+xml" title="Somatic Cell Gene Editing &raquo; Feed" href="https://scge.mcw.edu/feed/" />
    <link rel="alternate" type="application/rss+xml" title="Somatic Cell Gene Editing &raquo; Comments Feed" href="https://scge.mcw.edu/comments/feed/" />
    <link rel="alternate" type="text/calendar" title="Somatic Cell Gene Editing &raquo; iCal Feed" href="https://scge.mcw.edu/events/?ical=1" />
    <meta property="og:title" content="Somatic Cell Gene Editing"/>
    <meta property="og:type" content="article"/>
    <meta property="og:url" content="https://scge.mcw.edu/"/>
    <meta property="og:site_name" content="Somatic Cell Gene Editing"/>
    <meta property="og:description" content="The goal of the SCGE program is to accelerate the development of safer and more effective methods to edit the genomes of disease-relevant somatic cells and tissues in patients.  For ethical, legal and safety reasons, the SCGE program does not support any research activities on genome editing in reproductive (germ) cells.
Goals"/>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <!-- Custom styles for this template -->
    <!--link href="css/dashboard.css" rel="stylesheet"-->
    <link href="/toolkit/common/tableSorter/css/filter.formatter.css" rel="stylesheet" type="text/css"/>
    <link href="/toolkit/common/tableSorter/css/theme.jui.css" rel="stylesheet" type="text/css"/>
    <link href="/toolkit/common/tableSorter/css/theme.blue.css" rel="stylesheet" type="text/css"/>

    <script src="/toolkit/common/tableSorter/js/tablesorter.js"> </script>
    <script src="/toolkit/common/tableSorter/js/jquery.tablesorter.widgets.js"></script>
    <link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" integrity="sha384-AYmEC3Yw5cVb3ZcuHtOA93w35dYTsvhLPVnYs9eStHfGJvOvKxVfELGroGkvsg+p" crossorigin="anonymous"/>
    <link href="/toolkit/css/scge.css" rel="stylesheet" type="text/css"/>


    <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <!--script src="https://code.jquery.com/jquery-1.12.4.js"></script-->
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

    <style>
        html {
            position: relative;
            min-height: 100%;
        }
        #wrapper {
        min-height: 100%;
    }
        #main {
            overflow:auto;
            padding-bottom:150px; /* this needs to be bigger than footer height*/
        }
        footer{
            position: relative;
        }
    </style>

</head>

<body>

<div id="devSystemWarning" style="display:none; color:white; background-color: #770C0E;font-size:26px;width:100%;padding-left:15px;padding-top:4px; padding-bottom:4px;">Development System</div>

<script>
    if (location.href.indexOf("dev.") > 0) {
        document.getElementById("devSystemWarning").style.display="block";
    }
    if (location.href.indexOf("localhost") > 0) {
        document.getElementById("devSystemWarning").innerHTML="localhost";
        document.getElementById("devSystemWarning").style.display="block";
    }
</script>

<div id="site-wrapper" style="position:relative; left:0px; top:00px;">
<nav class="navbar  flex-md-nowrap p-0 shadow" style="ackground-color: #1a80b6;background-color: black;">
    <a class="navbar-brand col-md-3 col-lg-2 mr-0 px-3" href="/toolkit/loginSuccess">
        <img src="https://scge.mcw.edu/wp-content/uploads/2019/03/logo-png-1.png" width="70" height="50" ></a>

    <form  action="/toolkit/data/search/results" class="form w-100" >
    <input class="form-control form-control-dark w-100  searchTerm" id="commonSearchTerm" name="searchTerm" type="text" placeholder="Search" aria-label="Search">
    </form>
    <ul class="navbar-nav px-3">
        <li class="nav-item text-nowrap">
            <span class="navbar-text navbar-right">
                            <!-- using pageContext requires jsp-api artifact in pom.xml -->
                            <c:choose>
                                <c:when test="${userAttributes.get('name')!=null}">
                                    <img class="img-circle" src="${userAttributes.get('picture')}" width="24">
                                    <span class="navbar-text text-white">&nbsp;${userAttributes.get('name')}&nbsp;&nbsp;</span>
                                    <a href="/toolkit/logout" title="Sign out"><button class="btn btn-primary">Logout</button></a>

                                </c:when>
                                <c:otherwise>
                                    <a href="/toolkit/login/google">Google Login</a>
                                </c:otherwise>
                            </c:choose>
                        </span>
        </li>
    </ul>
</nav>
<nav class="navbar navbar-expand-lg navbar-light bg-light static-top">
    <div class="container">
        <!--a class="navbar-brand"  href="https://scge.mcw.edu/" >
            <img src="https://scge.mcw.edu/wp-content/uploads/2019/03/SCGElogo-50.jpg" srcset="https://scge.mcw.edu/wp-content/uploads/2019/03/SCGElogo-50.jpg 1x" width="72" height="50" alt="Somatic Cell Gene Editing Logo" data-retina_logo_url="" class="fusion-standard-logo" style="background-color: transparent"/>
        </a-->
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarResponsive">
            <% if (request.getAttribute("crumbtrail") != null) {%>
                <div><%=request.getAttribute("crumbtrail")%></div>
            <%}%>
            <ul class="navbar-nav ml-auto">
                <li class="nav-item active">

                    <a class="nav-link" href="/toolkit/loginSuccess?destination=base" style="font-weight: 400;font-family: Offside;font-size: 16px">
                        <i class="fas fa-home"></i>Home</a>
                </li>
                <c:if test="${userAttributes.get('name')!=null}">

                    <li class="nav-item">   <a class="nav-link" href="/toolkit/db?destination=base" style="font-weight: 400;font-family: Offside;font-size: 16px"><i class="fas fa-th"></i>&nbsp;My&nbsp;Dashboard</a></li>

                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="/toolkit/admin" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="font-weight: 400;font-family: Offside;font-size: 16px">
                            <i class="fas fa-th"></i>&nbsp;Admin
                        </a>
                        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <a class="dropdown-item" href="/toolkit/admin/users">Manage Users</a>
                            <a class="dropdown-item" href="/toolkit/admin">Sudo User</a>
                            <a class="dropdown-item" href="/toolkit/admin/groupOverview">Groups Overview</a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="/toolkit/admin/studyTierUpdates">Study Tier Updates</a>
                        </div>
                    </li>
                    <!--li class="nav-item" style="padding-top: 5px"><a href="/toolkit/data/dataSubmission"><button type="button" class="btn btn-sm">Upload Docs</button></a>
                    </li-->
                </c:if>

                <li class="nav-item">
                    <a class="nav-link" href="https://scge.mcw.edu/contact/" style="font-weight: 400;font-family: Offside;font-size: 16px"><i class="fa fa-phone" aria-hidden="true"></i>Contact</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

    <div id="main">
        <c:if test="${destination!='create'}">
            <div class="" style="margin-top: 0;padding-top: 0">
                <div class="container-fluid">

                    <!--h1 class="page-header">Dashboard</h1-->
                    <c:choose>
                        <c:when test="${action!=null}">
                            <h4 style="color:#1A80B6;">${action}  </h4>
                    <c:if test="${study!=null && study.pi!=null}">
                    <small><strong>PI:</strong> ${study.pi}&nbsp; &nbsp;<!--span style="color:orange; font-weight: bold">Publication ID:</span><a href="">XXXXXXXX</a></small-->
                    </c:if>     <hr>
                            <c:if test="${action=='Dashboard'}">
                                <div align="right">
                                    <c:forEach items="${personInfoList}" var="i">
                                        <p style="padding: 0;" class="text-muted">
                                            <strong>Initiative:</strong> ${i.groupName} &nbsp;
                                            <strong>User Group:</strong> ${i.subGroupName}</p>
                                    </c:forEach>
                                </div>
                            </c:if>
                    <div style="margin-top: 0;padding-top:0">
                        <!--nav aria-label="breadcrumb" id="breadcrumb"></nav-->
                        <nav aria-label="breadcrumb" >

                                <c:if test="${crumbTrailMap!=null}">
                                    <ol class="breadcrumb">
                                    <li class="breadcrumb-item"><a href="/toolkit/loginSuccess?destination=base">Home</a></li>

                                    <c:forEach items="${crumbTrailMap}" var="item">
                                        <li class="breadcrumb-item">
                                            <c:forEach items="${item.value}" var="trail">
                                                <c:if test="${item.value!=null}">
                                                    <a href="${trail.value}">
                                                </c:if>
                                                ${trail.key}
                                                <c:if test="${item.value!=null}">
                                                    </a>
                                                </c:if>


                                            </c:forEach>
                                        </li>
                                    </c:forEach>
                                    </ol>
                                </c:if>
                                <!--li class="breadcrumb-item">${action}</li-->


                        </nav>

                        </c:when>
                        <c:otherwise>
                            <!--h4 class="page-header" style="color:grey;">Dashboard</h4-->
                            <!--h1 class="page-header" style="color:grey;">Dashboard<span style="float:right"><a href="dataSubmission"><button class="btn btn-success btn-sm">Submit Data</button></a>&nbsp;<a href="dataSubmission"><button class="btn btn btn-outline-secondary btn-sm">Upload Docs</button></a></span></h1-->
                                <div style=";width:100%" align="center" >
                                    <%--@include file="tools/search.jsp"--%>
                                        <div class="container" align="center">


                                            <table align="center">
                                                <tr>
                                                    <td><img src="https://scge.mcw.edu/wp-content/uploads/2019/03/logo-png-1.png" border="0"/></td>
                                                    <td>
                                                        <div>
                                                        <form action="/toolkit/data/search/results"  class="form-inline my-2 my-lg-0">
                                                            <input size=60 class="form-control searchTerm" id="searchTerm" name="searchTerm" type="search" placeholder="Search SCGE (Models, Editors, Delivery, Guides)" aria-label="Search">
                                                            <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
                                                            <br>
                                                        </form>

                                                        </div>
                                                        <div>
                                                            <small class="form-text text-muted" style="font-size: 11px">Examples:<a href="/toolkit/data/search/results?searchTerm=Epithelium">Epithelium</a> <a href="/toolkit/data/search/results?searchTerm=crispr" >CRISPR</a>,
                                                                <a href="/toolkit/data/search/results?searchTerm=aav" >AAV</a>, <a href="/toolkit/data/search/results?searchTerm=ai9" >Ai9</a>
                                                            </small>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                </div>

                            <!--div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                                <h1 class="h2">Toolkit</h1>
                                <div class="btn-toolbar mb-2 mb-md-0">
                                    <div class="btn-group mr-2">
                                        <button class="btn btn-sm btn-outline-secondary">Submit Data</button>
                                        <button class="btn btn-sm btn-outline-secondary"> <span data-feather="upload"></span>Upload Docs</button>
                                    </div>
                                    <button class="btn btn-sm btn-outline-secondary dropdown-toggle">
                                        <span data-feather="file"></span>
                                            Forms
                                    </button>
                                </div>
                            </div-->
                            <!--div style="text-align: center; ;height:50px" >
                            <h4>Welcome to Somatic Cell Genome Editing</h4>
                            </div-->
                        </c:otherwise>
                    </c:choose>
                        <c:if test="${status!=null}">
                           <strong>${status}</strong><hr>
                        </c:if>
                        <c:if test="${page!=null}">
                        <c:import url="${page}.jsp" />
                        </c:if>
                    </div>
                </div>
            </div>
        </c:if>
    </div>
</div>


<footer id="sticky-footer" class="py-4 bg-dark text-white-50">
    <div class="container text-center">
        <small>Copyright &copy; This website is hosted by the SCGE DCC | Copyright 2019 SCGE | All Rights Reserved</small>
    </div>
    <!-- Bootstrap core JavaScript
================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->

    <!--script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script-->
    <!--script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script-->
    <script>
        $.ajaxSetup({
            beforeSend : function(xhr, settings) {
                if ( settings.type == 'PUT'
                    || settings.type == 'DELETE') {
                    if (!(/^http:.*/.test(settings.url) || /^https:.*/
                        .test(settings.url))) {
                        // Only send the token to relative URLs i.e. locally.
                        xhr.setRequestHeader("X-XSRF-TOKEN",
                            Cookies.get('XSRF-TOKEN'));
                    }
                }
            }
        });

    </script>
    <script src="/toolkit/js/search/autocomplete.js"></script>

</footer>
</body>
</html>
