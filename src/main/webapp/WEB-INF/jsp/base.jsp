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

    <meta property="og:image" content="https://scge.mcw.edu/wp-content/uploads/2019/03/SCGElogo-50.jpg"/>


    <link rel='stylesheet' id='avada-stylesheet-css'  href='https://scge.mcw.edu/wp-content/themes/Avada/assets/css/style.min.css?ver=6.1.1' type='text/css' media='all' />

    <!--[if IE]>
    <link rel='stylesheet' id='avada-IE-css'  href='https://scge.mcw.edu/wp-content/themes/Avada/assets/css/ie.min.css?ver=6.1.1' type='text/css' media='all' />
    <style id='avada-IE-inline-css' type='text/css'>
        .avada-select-parent .select-arrow{background-color:#ffffff}
        .select-arrow{background-color:#ffffff}
    </style>
    <![endif]-->
    <link rel='stylesheet' id='fusion-dynamic-css-css'  href='/scgeweb/common/css/scge_nav_header.css' type='text/css' media='all' />

    <!--style>
        .footer {
            position: fixed;
            left: 0;
            bottom: 0;
            width: 100%;
            color: white;
            text-align: center;
            padding-top: 20%;
        }
    </style-->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <!-- Custom styles for this template -->
    <!--link href="css/dashboard.css" rel="stylesheet"-->
    <link href="https://rgd.mcw.edu/rgdweb/common/tableSorter/css/filter.formatter.css" rel="stylesheet" type="text/css"/>
    <link href="https://rgd.mcw.edu/rgdweb/common/tableSorter/css/theme.jui.css" rel="stylesheet" type="text/css"/>
    <link href="https://rgd.mcw.edu/rgdweb/common/tableSorter/css/theme.blue.css" rel="stylesheet" type="text/css"/>

    <script src="https://rgd.mcw.edu/rgdweb/common/tableSorter/js/tablesorter.js"> </script>
    <script src="https://rgd.mcw.edu/rgdweb/common/tableSorter/js/jquery.tablesorter.widgets.js"></script>
    <link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" integrity="sha384-AYmEC3Yw5cVb3ZcuHtOA93w35dYTsvhLPVnYs9eStHfGJvOvKxVfELGroGkvsg+p" crossorigin="anonymous"/>
 <style>
    html, body {
        height: 100%;
        font-size: small;
    }

    #wrapper {
    min-height: 100%;
    }

    #main {
    overflow:auto;
    padding-bottom:150px; /* this needs to be bigger than footer height*/
    }

    .footer {
    position: relative;
    margin-top: -150px; /* negative value of footer height */
    height: 150px;
    clear:both;
    padding-top:20px;
    }
    .sidebarItemDiv{
        margin:1%;

    }
     .card{
         padding:1%;
         border:1px solid white;
     }
     .sidebar-wrapper{
         border: 2px solid gainsboro ;
     }
 </style>
</head>

<body>
<div id="wrapper" class="fusion-wrapper">
    <div id="home" style="position:relative;top:-1px;"></div>

        <div class="fusion-header-v3 fusion-logo-alignment fusion-logo-left fusion-sticky-menu- fusion-sticky-logo- fusion-mobile-logo-  fusion-mobile-menu-design-modern">

            <div class="fusion-secondary-header">
                <div class="fusion-row">
                    <div class="fusion-alignleft">
                        <div class="fusion-contact-info"><span class="fusion-contact-info-phone-number"></span><span class="fusion-contact-info-email-address"><a href="mailto:s&#99;g&#101;&#64;&#109;&#99;&#119;&#46;e&#100;&#117;">s&#99;g&#101;&#64;&#109;&#99;&#119;&#46;e&#100;&#117;</a></span></div>

                    </div>


                    <div style="float:right">

                        <!--div class="g-signin2" data-onsuccess="onSignIn" data-theme="dark"></div-->
                        <div id="navbar">

                            <span class="navbar-text navbar-right">

                                <!-- using pageContext requires jsp-api artifact in pom.xml -->
                                <c:choose>
                                    <c:when test="${userName!=null}">
                                        Logged in as:<img class="img-circle" src="${userImageUrl}" width="24">

                                        ${userName}&nbsp;
                                        <a href="/scgeweb/logout" title="Sign out"><button class="btn btn-primary">Logout</button></a>

                                    </c:when>
                                    <c:otherwise>
                                        <a href="/scgeweb/login/google">Google Login</a>
                                    </c:otherwise>
                                </c:choose>

                            </span>

                        </div>

                    </div>
                </div>

            </div>
            <div class="fusion-header-sticky-height"></div>

            <nav class="navbar navbar-expand-lg navbar-light bg-light">
                    <a class="navbar-brand"  href="https://scge.mcw.edu/" >


                    <img src="https://scge.mcw.edu/wp-content/uploads/2019/03/SCGElogo-50.jpg" srcset="https://scge.mcw.edu/wp-content/uploads/2019/03/SCGElogo-50.jpg 1x" width="72" height="50" alt="Somatic Cell Gene Editing Logo" data-retina_logo_url="" class="fusion-standard-logo" />


                </a>
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul class="navbar-nav mr-auto">
                        <li class="nav-item active">
                            <a class="nav-link" href="https://scge.mcw.edu/" style="font-size: 16px;">Home <span class="sr-only">(current)</span></a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/scgeweb/toolkit/home?destination=base" style="font-weight: bold;color:orangered;font-size: 16px">ToolKit</a>
                        </li>

                        <c:if test="${userName!=null}">
                            <li class="nav-item">   <a class="nav-link" href="/scgeweb/loginSuccess?destination=base" style="font-weight: bold;color:orangered;font-size: 16px">My Dashboard</a></li>
                        <!--li class="nav-item" style="padding-top: 5px"><a href="dataSubmission"><button type="button" class="btn btn-sm">Submit Data</button></a>
                        </li-->
                        </c:if>


                    </ul>
                    <form class="form-inline my-2 my-lg-0">
                        <input class="form-control mr-sm-2" type="search" placeholder="Search" aria-label="Search">
                        <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
                    </form>
                </div>
            </nav>
        </div>
    <div id="main">
        <c:if test="${destination!='create'}">

            <div class="" style="margin-top: 0;padding-top: 0">

                <c:choose>
                <c:when test="${action=='Animal Reporter Models'}">
                <div class="container-fluid">
                    </c:when>
                    <c:otherwise>
                    <div class="container-fluid">
                        </c:otherwise>
                        </c:choose>

                        <!--h1 class="page-header">Dashboard</h1-->
                        <c:choose>
                            <c:when test="${action!=null}">
                                <h4 class="page-header" style="color:grey;">${action}  </h4>
                            </c:when>
                            <c:otherwise>
                                <!--h4 class="page-header" style="color:grey;">Dashboard</h4-->
                                <h1 class="page-header" style="color:grey;">Dashboard<span style="float:right"><a href="dataSubmission"><button class="btn btn-success btn-sm">Submit Data</button></a></span></h1>

                                <!--div style="text-align: center; ;height:50px" >
                                <h4>Welcome to Somatic Cell Genome Editing</h4>
                                </div-->
                            </c:otherwise>
                        </c:choose>
                        <hr>
                        <div style="margin-top: 0;padding-top:0">
                            <c:import url="/${page}.jsp" />
                        </div>
                    </div>

                </div>
            </div>
        </c:if>

        <c:if test="${destination=='create'}">
            <!--div class="container">
            <h4 style="color:cornflowerblue">Welcome to Somatic Cell Genome Editing</h4>
            </div-->

            <c:import url="/${page}.jsp" />
        </c:if>

    </div>
</div>
<div class="fusion-clearfix"></div>


        <footer id="footer" class="fusion-footer-copyright-area fusion-footer-copyright-center">
            <div class="fusion-row">
                <div class="fusion-copyright-content">

                    <div class="fusion-copyright-notice">
                        <div style="text-align: center">
                            This website is hosted by the SCGE DCC | Copyright 2019 SCGE | All Rights Reserved	</div>
                    </div>


                </div> <!-- fusion-fusion-copyright-content -->
            </div> <!-- fusion-row -->
        </footer> <!-- #footer -->


<!-- Bootstrap core JavaScript
================================================== -->
<!-- Placed at the end of the document so the pages load faster -->

<!--script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script-->
<!--script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script-->
    <script>
    $.ajaxSetup({
    beforeSend : function(xhr, settings) {
    if (settings.type == 'POST' || settings.type == 'PUT'
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
</body>
</html>
