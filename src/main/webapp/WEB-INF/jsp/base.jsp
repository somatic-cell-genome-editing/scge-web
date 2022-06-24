<%@ page import="edu.mcw.scge.datamodel.Person" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.dao.implementation.PersonDao" %>
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
    <!--link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css" integrity="sha384-AYmEC3Yw5cVb3ZcuHtOA93w35dYTsvhLPVnYs9eStHfGJvOvKxVfELGroGkvsg+p" crossorigin="anonymous"/-->

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css" rel="stylesheet" type="text/css"/>

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
        .text-responsive {
            font-size: calc(100% + 1vw + 1vh);
        }
        #home-page-search{

         /*   background-image: linear-gradient(to bottom right, #0469bd, #ebeff2);*/

        }
        .navbar-custom {
         /*   background-color: #17a2b8!important;*/
            background-color: #1a80b6!important ;
        }
        /* change the brand and text color */
        .navbar-custom .navbar-brand,
        .navbar-custom .navbar-text {
            color: white;
        }
        /* change the link color */
        .navbar-custom .navbar-nav .nav-link {
            color:white;
            font-size: 16px;
        }
        /* change the color of active or hovered links */
        .navbar-custom .nav-item.active .nav-link,
        .navbar-custom .nav-item:hover .nav-link {
            color: #1a80b6;
            background-color: #bee5fa;
        }
        .navbar-custom .navbar-toggler{
            background-color: lightgrey;
            color:black;
        }
        .navbar-custom .navbar-toggler-icon{
            color:#FFFFFF;
        }

    </style>
<script>
 /*   var action='${action}';
    $(function () {
        var element=document.getElementById(action);

            element.style.border= "1px solid #bee5fa";
           element.style.color= "#1a80b6";


    })
*/
</script>
</head>

<body>














<style>
    input[type="email"] {
        width: 100%;
        height: 30px;
        font-size: large;
        background-color : #f1f1f1;

    }
    .hideMe {
        bottom: 104px;
        right: 42px;
        position: fixed;
        opacity: .8;
        background-color: red;
        color: white;
        border-radius: 5px;
        border: none;
        text-align: center;
        display:table-cell;
        vertical-align:middle;
        box-sizing: border-box;
    }
    .hiddenBtns {
        bottom: 25px;
        right: 35px;
        height: 50px;
        width: 50px;
        position: fixed;
        z-index: 500;
        box-sizing: border-box;
    }
    .openLikeBtn{
        height: 50px;
        width: 50px;
        position: fixed;
        background-size: 100%;
        border: white;
        background-image: url("/toolkit/images/mailChat.png");
        border-radius: 24px;
        cursor: pointer;
        opacity: .7;
        box-sizing: border-box;
    }
    /* Button used to open the chat form - fixed at the bottom of the page */
    .open-button {
        background-color: #2865A3;
        color: white;
        padding: 3px 10px;
        border: none;
        cursor: pointer;
        position: fixed;
        bottom: 23px;
        right: 45px;
        width: 145px;
        height: 40px;
        font-size: 13pt;
        border-radius: 10px;
        box-sizing: border-box;
    }

    /* The popup chat - hidden by default */
    .chat-popup {
        display: none;
        position: fixed;
        bottom: 30px;
        right: 20px;
        border: 3px solid #f1f1f1;
        z-index: 501;
        box-sizing: border-box;
        background-color:#5D8DAF;
        color:white;
        width:500px;
        height:500px;
        border-radius:10px;
    }

    /* Add styles to the form container */
    .form-container {
        max-width: 500px;
        padding: 10px;
        ackground-color: white;
        box-sizing: border-box;
        white-space: normal;
    }

    /* Full-width textarea */
    .form-container textarea {
        width: 100%;
        padding: 15px;
        margin: 5px 20px 22px 0;
        border: none;
        background: white;
        resize: none;
        min-height: 200px;
        font-size: large;
        box-sizing: border-box;
    }

    /* When the textarea gets focus, do something */
    .form-container textarea:focus {
        background-color: #ddd;
        outline: none;
    }

    /* Set a style for the submit/send button */
    .form-container .btn {
        background-color: #2865A3;
        color: white;
        padding: 16px 20px;
        border: none;
        cursor: pointer;
        width: 100%;
        margin-bottom:10px;
        opacity: 0.8;
        font-size: large;
        box-sizing: border-box;
    }

    .closeForm {
        position: absolute;
        top: 10px;
        right: 10px;
        background-color: #770C0E;
        color: white;
        border:0px solid black;

    }
    /* Add some hover effects to buttons */
    .form-container .btn:hover, .open-button:hover {
        opacity: 1;
    }
</style>


<div id="hiddenBtns" class="hiddenBtns" style="display: block;">
    <button type="button" class="openLikeBtn" onclick="openForm()"></button>
</div>

<div class="chat-popup" id="messageVue">
    <form class="form-container">
        <button type="button" id="close" onclick="closeForm()" class="closeForm">x</button>
        <h2 id="headMsg">Contact SCGE</h2>
        <input type="hidden" name="subject" value="Help and Feedback Form">
        <input type="hidden" name="found" value="0">

        <label><b>Your email</b></label>
        <br><input type="email" name="email" v-model="email" >
        <br>
        <br><label><b style="">Message</b></label>
        <textarea placeholder="Type message.." name="comment" v-model="message"></textarea>

        <button type="button" id="sendEmail" class="btn" v-on:click="sendMail">Send</button>

    </form>
</div>




<script src="https://unpkg.com/vue@2"></script>
<script src="https://unpkg.com/axios/dist/axios.min.js"></script>
<script>
function openForm() {
    document.getElementById("messageVue").style.display = "block";
    document.getElementById("headMsg").innerText = 'How can we help?';
}

function closeForm() {
    document.getElementById("messageVue").style.display = "none";
    document.getElementById("sendEmail").disabled = false;
}

// window.onload = function () {
var messageVue = new Vue({
    el: '#messageVue',
    data: {
        email: '',
        message: '',
    },
    methods: {
        sendMail: function () {
            if (this.message === '' || !this.message) {
                alert("There is no message entered.");
                return;
            }
            if (this.email === '' || !this.email) {
                alert("No email provided.");
                return;
            }
            if (!emailValidate(this.email)) {
                alert("Not a valid email address.");
                return;
            }
            document.getElementById("sendEmail").disabled = true;

            axios.post('/toolkit/data/feedback',
                    {

                        email: messageVue.email,
                        message: messageVue.message,
                        webPage: window.location.href
                    })
                .then(function (response) {
                    closeForm();
                }).catch(function (error) {
                console.log(error)
            })
        }
    } // end methods
});

function emailValidate(message) {
    var re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(message);
}


// };

</script>













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

<%

    Access access = new Access();
    Person person = access.getUser(request.getSession());

%>
<div id="site-wrapper" style="position:relative; left:0px; top:00px;">
    <nav class="navbar navbar-expand-lg flex-md-nowrap p-0 shadow" style="background-color: black" >
        <a class="navbar-brand col-md-3 col-lg-2 mr-0 px-3" href="/toolkit/loginSuccess">
            <img src="/toolkit/images/scge-logo-70w.png" width="70" height="50" ></a>
                <!--div class="input-group col-sm-4"-->
                    <form class="form-inline" action="/toolkit/data/search/results" >

                        <div class="input-group"  style="padding-top:2%;width: 100%">
                            <input  class="form-control form-control-sm border-secondary" type="search" id="commonSearchTerm" name="searchTerm" placeholder="Enter Search Term ...." value=""/>
                            <div class="input-group-append">
                                <button class="btn btn-outline-secondary btn-sm" type="submit" >
                                    <i class="fa fa-search"></i>
                                </button>
                            </div>

                        </div>

                        <small class="form-text text-light" style="font-size: 11px;">Examples:&nbsp;<a class="text-light" style="font-size: 11px;" href="/toolkit/data/search/results?searchTerm=Epithelium">Epithelium</a> <a class="text-light" href="/toolkit/data/search/results?searchTerm=crispr" style="font-size: 11px;" >CRISPR</a>,
                            <a class="text-light" style="font-size: 11px;" href="/toolkit/data/search/results?searchTerm=aav" >AAV</a>, <a class="text-light" style="font-size: 11px;" href="/toolkit/data/search/results?searchTerm=ai9" >Ai9</a>
                        </small>
                    </form>
                <!--/div-->

            <ul class="navbar-nav ml-auto" style="padding-right: 2%">

                <li class="nav-item text-nowrap text-responsive">
                    <a class="nav-link" href="https://scge.mcw.edu/contact/" style="font-weight: 400;font-size: 16px;color:#FFFFFF"><i class="fa fa-phone" aria-hidden="true"></i>Contact</a>
                </li>
                <c:if test="${userAttributes.get('name')!=null}">

                    <li class="nav-item text-nowrap">   <a class="nav-link" href="/toolkit/db?destination=base" style="font-weight: 400;font-size: 16px;color:#FFFFFF"><i class="fas fa-th"></i>&nbsp;My&nbsp;Dashboard</a></li>
                    <%if(access.isAdmin(person)){%>
                    <li class="nav-item dropdown text-nowrap">
                        <a class="nav-link dropdown-toggle" href="/toolkit/admin" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="font-weight: 400;font-size: 16px;color:#FFFFFF">
                            <i class="fas fa-th"></i>&nbsp;Admin
                        </a>
                        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <a class="dropdown-item" href="/toolkit/admin/users">Manage Users</a>
                            <a class="dropdown-item" href="/toolkit/admin">Sudo User</a>
                            <a class="dropdown-item" href="/toolkit/admin/groupOverview">Groups Overview</a>
                            <a class="dropdown-item" href="/toolkit/data/studies/search">Study Browser</a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="/toolkit/admin/studyTierUpdates">Study Tier Updates</a>
                        </div>
                    </li>
                    <%}%>
                    <!--li class="nav-item" style="padding-top: 5px"><a href="/toolkit/data/dataSubmission"><button type="button" class="btn btn-sm">Upload Docs</button></a>
                    </li-->
                </c:if>

                <li class="nav-item text-nowrap my-2 my-sm-0" style="padding-right: 1%">

                    <!-- using pageContext requires jsp-api artifact in pom.xml -->
                    <c:choose>
                        <c:when test="${userAttributes.get('name')!=null}">
                            <img class="rounded-circle" src="${userAttributes.get('picture')}" width="24">
                            <span class="text-light" >&nbsp;${userAttributes.get('name')}&nbsp;&nbsp;</span>
                            <a href="/toolkit/logout" title="Sign out"><button class="btn btn-primary btn-sm">Logout</button></a>

                        </c:when>
                        <c:otherwise>
                            <a href="/toolkit/login/google">Google Login</a>
                        </c:otherwise>
                    </c:choose>

                </li>
            </ul>


    </nav>
<!--nav class="navbar  flex-md-nowrap p-0 shadow" style="ackground-color: #1a80b6;background-color: black;">
    <a class="navbar-brand col-md-3 col-lg-2 mr-0 px-3" href="/toolkit/loginSuccess">
        <img src="https://scge.mcw.edu/wp-content/uploads/2019/03/logo-png-1.png" width="70" height="50" ></a>

    <!--form  action="/toolkit/data/search/results" class="form" >
    <input class="form-control form-control-dark  searchTerm" id="commonSearchTerm" name="searchTerm" type="text" placeholder="Search" aria-label="Search">
    </form-->
    <!--div class="input-group col-sm-4">
        <form  action="/toolkit/data/search/results" >

        <div class="input-group"  style="padding-top:1%">
            <input  name="searchTerm" class="form-control form-control-sm border-secondary" type="search"  placeholder="Enter Search Term ...." value=""/>
            <div class="input-group-append">
                <button class="btn btn-outline-secondary btn-sm" type="submit" >
                    <i class="fa fa-search"></i>
                </button>
            </div>

        </div>

        <small class="form-text text-light" style="font-size: 11px;">Examples:&nbsp;<a class="text-light" style="font-size: 11px;" href="/toolkit/data/search/results?searchTerm=Epithelium">Epithelium</a> <a class="text-light" href="/toolkit/data/search/results?searchTerm=crispr" style="font-size: 11px;" >CRISPR</a>,
            <a class="text-light" style="font-size: 11px;" href="/toolkit/data/search/results?searchTerm=aav" >AAV</a>, <a class="text-light" style="font-size: 11px;" href="/toolkit/data/search/results?searchTerm=ai9" >Ai9</a>
        </small>
    </form>
    </div>

</nav-->
<%
    try {
        if(access.isConsortiumMember(person.getId())){%>
        <!--nav class="navbar navbar-expand-lg navbar-light bg-light static-top " >
            <div class="container-fluid">
                <!--a class="navbar-brand"  href="https://scge.mcw.edu/" >
                    <img src="https://scge.mcw.edu/wp-content/uploads/2019/03/SCGElogo-50.jpg" srcset="https://scge.mcw.edu/wp-content/uploads/2019/03/SCGElogo-50.jpg 1x" width="72" height="50" alt="Somatic Cell Gene Editing Logo" data-retina_logo_url="" class="fusion-standard-logo" style="background-color: transparent"/>
                </a-->

                <!--button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarResponsive">

                    <ul class="navbar-nav ml-auto">


                        <c:if test="${userAttributes.get('name')!=null}">

                            <li class="nav-item text-nowrap">   <a class="nav-link" href="/toolkit/db?destination=base" style="font-weight: 400;font-size: 16px"><i class="fas fa-th"></i>&nbsp;My&nbsp;Dashboard</a></li>
    <%if(access.isAdmin(person)){%>
                            <li class="nav-item dropdown text-nowrap">
                                <a class="nav-link dropdown-toggle" href="/toolkit/admin" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" style="font-weight: 400;font-size: 16px">
                                    <i class="fas fa-th"></i>&nbsp;Admin
                                </a>
                                <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                                    <a class="dropdown-item" href="/toolkit/admin/users">Manage Users</a>
                                    <a class="dropdown-item" href="/toolkit/admin">Sudo User</a>
                                    <a class="dropdown-item" href="/toolkit/admin/groupOverview">Groups Overview</a>
                                    <a class="dropdown-item" href="/toolkit/data/studies/search">Study Browser</a>
                                    <div class="dropdown-divider"></div>
                                    <a class="dropdown-item" href="/toolkit/admin/studyTierUpdates">Study Tier Updates</a>
                </div>
                            </li>
                            <%}%>
                            <!--li class="nav-item" style="padding-top: 5px"><a href="/toolkit/data/dataSubmission"><button type="button" class="btn btn-sm">Upload Docs</button></a>
                            </li-->
                        </c:if>

                        <!--li class="nav-item text-nowrap my-2 my-sm-0">

                            <!-- using pageContext requires jsp-api artifact in pom.xml -->
                            <c:choose>
                                <c:when test="${userAttributes.get('name')!=null}">
                                    <!--img class="img-circle" src="${userAttributes.get('picture')}" width="24">
                                    <span class="navbar-text">&nbsp;${userAttributes.get('name')}&nbsp;&nbsp;</span>
                                    <a href="/toolkit/logout" title="Sign out"><button class="btn btn-primary">Logout</button></a>

                                </c:when>
                                <c:otherwise>
                                    <a href="/toolkit/login/google">Google Login</a>
                                </c:otherwise>
                            </c:choose>

                        </li>
                    </ul>
                </div>
            </div>
        </nav-->
         <%}
 } catch (Exception e) {
     e.printStackTrace();
 }
 %>
    <nav class="navbar navbar-expand-lg  navbar-custom static-top" style="color: white" >
        <div class="container-fluid">
            <!--a class="navbar-brand"  href="https://scge.mcw.edu/" >
                <img src="https://scge.mcw.edu/wp-content/uploads/2019/03/SCGElogo-50.jpg" srcset="https://scge.mcw.edu/wp-content/uploads/2019/03/SCGElogo-50.jpg 1x" width="72" height="50" alt="Somatic Cell Gene Editing Logo" data-retina_logo_url="" class="fusion-standard-logo" style="background-color: transparent"/>
            </a-->
            <a class="navbar-brand" href="/toolkit/loginSuccess?destination=base" style="font-weight: 400;font-size: 16px">
                <i class="fas fa-home"></i>Home</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
                <!--span class="navbar-toggler-icon" ></span-->
                Menu
            </button>
            <div class="collapse navbar-collapse" id="navbarResponsive">

                <ul class="navbar-nav">

                    <li class="nav-item  text-nowrap text-responsive Studies" id="Studies">
                        <a class="nav-link" href="/toolkit/data/search/results/Study/Experiment?searchTerm=" >Studies <span class="sr-only">(current)</span></a>
                    </li>
                    <li class="nav-item  text-nowrap text-responsive" id="Genome Editors">
                        <a class="nav-link" href="/toolkit/data/search/results/Genome%20Editor?searchTerm=" >Genome Editors <span class="sr-only">(current)</span></a>
                    </li>
                    <li class="nav-item text-nowrap text-responsive" id="Model Systems">
                        <a class="nav-link" href="/toolkit/data/search/results/Model%20System?searchTerm=" >Model Systems</a>
                    </li>
                    <li class="nav-item text-nowrap text-responsive" id="Delivery Systems">
                        <a class="nav-link" href="/toolkit/data/search/results/Delivery%20System?searchTerm=" >Delivery Systems</a>
                    </li>
                    <li class="nav-item text-nowrap text-responsive Guides" id="Guides">
                        <a class="nav-link" href="/toolkit/data/search/results/Guide?searchTerm=" >Guides</a>
                    </li>
                    <li class="nav-item text-nowrap text-responsive Vectors" id="Vectors">
                        <a class="nav-link" href="/toolkit/data/search/results/Vector?searchTerm=" >Vectors</a>
                    </li>
                    <li class="nav-item text-nowrap text-responsive Protocols" id="Protocols">
                        <a class="nav-link Protocols" href="/toolkit/data/protocols/search" >Protocols</a>
                    </li>
                    <li class="nav-item text-nowrap text-responsive Publications" id="Publications">
                        <a class="nav-link Publications" href="/toolkit/data/publications/search" >Publications</a>
                    </li>

                    <li class="nav-item dropdown text-nowrap">
                    <div class="btn-group">
                        <button type="button" class="btn btn-primary"><a href="/toolkit/data/initiatives" style="color:#FFFFFF;font-size: 16px">Initiatives</a></button>
                        <button type="button" class="btn btn-primary dropdown-toggle dropdown-toggle-split" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <span class="sr-only">Toggle Dropdown</span>
                        </button>
                        <div class="dropdown-menu">
                            <a class="dropdown-item" href="/toolkit/data/search/results/Study?searchTerm=&facetSearch=true&typeBkt=Small+Animal+Testing+Center+(SATC)&typeBkt=Large+Animal+Reporter+(LAR)&typeBkt=Large+Animal+Testing+Center+(LATC)">Animal Reporter And Testing Center Initiative</a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="/toolkit/data/search/results/Study?searchTerm=&facetSearch=true&typeBkt=In+Vivo+Cell+Tracking">Biological Effects (In Vivo Cell Tracking Projects)</a>
                            <a class="dropdown-item" href="/toolkit/data/search/results/Study?searchTerm=&facetSearch=true&typeBkt=Biological+Effects+Initiative&typeBkt=Biological+Systems">Biological Effects (Biological Systems)</a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="/toolkit/data/search/results/Study?searchTerm=&facetSearch=true&typeBkt=Delivery+Systems+Initiative">Delivery Systems Initiative</a>
                            <a class="dropdown-item" href="/toolkit/data/search/results/Study?searchTerm=&facetSearch=true&typeBkt=Genome+Editors">Genome Editor Projects</a>

                        </div>
                    </div>
                    </li>
                        <!--li class="nav-item" style="padding-top: 5px"><a href="/toolkit/data/dataSubmission"><button type="button" class="btn btn-sm">Upload Docs</button></a>
                        </li-->



                </ul>
            </div>
        </div>
    </nav>


    <div id="main">
        <% if (request.getAttribute("crumbtrail") != null) {%>
        <div class="container-fluid" style="padding-bottom: 2%"><%=request.getAttribute("crumbtrail")%></div>
        <%}%>
        <c:if test="${destination!='create'}">
            <div class="" style="margin-top: 0;padding-top: 0">
                <div class="container-fluid">

                    <!--h1 class="page-header">Dashboard</h1-->
                    <c:choose>
                        <c:when test="${action!=null}">
                            <h4 style="color:#1A80B6;">${action}  </h4>
                    <c:if test="${study!=null && study.pi!=null}">
                    <small><strong>PI:</strong> ${study.pi}&nbsp; &nbsp;
                        <c:if test="${fn:length( publication.articleIds)>0}">
                        <span style="color:orange; font-weight: bold">Publication IDs:</span>
                        <c:forEach items="${publication.articleIds}" var="id">

                            <c:choose>
                                <c:when test="${id.url=='' || id.url==null}">
                                    ${id.id};&nbsp;

                                </c:when>
                                <c:otherwise>
                                    <a href="${id.url}${id.id}">${id.id}</a>;&nbsp;

                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        </c:if>

                    </small>
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

                                <c:if test="${crumbTrailMap!=null && (searchTerm!=null && searchTerm!='')}">
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
                                <!--div style=";width:100%" align="center" -->
                                    <%--@include file="tools/search.jsp"--%>
                                        <div class="container-fluid" align="center" id="home-page-search" style="background-color: #FFFFFF;">


                                            <table align="center">
                                                <tr>
                                                    <td><img src="/toolkit/images/scge-logo-200w.png" border="0"/></td>
                                                    <td>
                                                        <div>
                                                        <form action="/toolkit/data/search/results"  class="form-inline my-2 my-lg-0">
                                                            <input size=60 class="form-control searchTerm" id="searchTerm" name="searchTerm" type="search" placeholder="Search SCGE (Models, Editors, Delivery, Guides)" aria-label="Search">
                                                            <button class="btn btn-outline-secondary" type="submit">
                                                                <i class="fa fa-search"></i>
                                                            </button>                                                            <br>
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
                                <!--/div-->

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


    </script>
    <script src="/toolkit/js/search/autocomplete.js"></script>

</footer>
</body>
</html>
