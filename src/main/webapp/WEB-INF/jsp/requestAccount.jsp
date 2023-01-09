<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.service.Data" %><%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 1/27/2021
  Time: 6:15 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Home</title>
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
    <script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <!------ Include the above in your HEAD tag ---------->
    <style>

        /* BASIC */

        body {
            background-color: #56baed;
            background-image: url("../common/images/genomeEditing.jpg");
            background-size: auto;
            background-repeat: no-repeat;
        }

        body {
            font-family: "Poppins", sans-serif;
            height: 100vh;
        }

        a {
            color: #92badd;
            display:inline-block;
            text-decoration: none;
            font-weight: 400;
        }

        h2 {
            text-align: center;
            font-size: 16px;
            font-weight: 600;
            text-transform: uppercase;
            display:inline-block;
            margin: 40px 8px 10px 8px;
            color: #cccccc;
        }



        /* STRUCTURE */

        .wrapper {
            display: flex;
            align-items: center;
            flex-direction: column;
            justify-content: center;
            width: 100%;
            min-height: 100%;
            padding: 20px;
        }

        #formContent {
            -webkit-border-radius: 10px 10px 10px 10px;
            border-radius: 10px 10px 10px 10px;
            background: #fff;
            padding: 30px;
            width: 90%;
            max-width: 450px;
            position: relative;
            padding: 0px;
            -webkit-box-shadow: 0 30px 60px 0 rgba(0,0,0,0.3);
            box-shadow: 0 30px 60px 0 rgba(0,0,0,0.3);
            text-align: center;
        }

        #formFooter {
            background-color: #f6f6f6;
            border-top: 1px solid #dce8f1;
            padding: 25px;
            text-align: center;
            -webkit-border-radius: 0 0 10px 10px;
            border-radius: 0 0 10px 10px;
        }



        /* TABS */

        h2.inactive {
            color: #cccccc;
        }

        h2.active {
            color: #0d0d0d;
            border-bottom: 2px solid #5fbae9;
        }



        /* FORM TYPOGRAPHY*/

        input[type=button], input[type=submit], input[type=reset]  {
            background-color: #56baed;
            border: none;
            color: white;
            padding: 15px 80px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            text-transform: uppercase;
            font-size: 13px;
            -webkit-box-shadow: 0 10px 30px 0 rgba(95,186,233,0.4);
            box-shadow: 0 10px 30px 0 rgba(95,186,233,0.4);
            -webkit-border-radius: 5px 5px 5px 5px;
            border-radius: 5px 5px 5px 5px;
            margin: 5px 20px 40px 20px;
            -webkit-transition: all 0.3s ease-in-out;
            -moz-transition: all 0.3s ease-in-out;
            -ms-transition: all 0.3s ease-in-out;
            -o-transition: all 0.3s ease-in-out;
            transition: all 0.3s ease-in-out;
        }

        input[type=button]:hover, input[type=submit]:hover, input[type=reset]:hover  {
            background-color: #39ace7;
        }

        input[type=button]:active, input[type=submit]:active, input[type=reset]:active  {
            -moz-transform: scale(0.95);
            -webkit-transform: scale(0.95);
            -o-transform: scale(0.95);
            -ms-transform: scale(0.95);
            transform: scale(0.95);
        }

        input[type=text] {
            background-color: #f6f6f6;
            border: none;
            color: #0d0d0d;
            padding: 15px 32px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            margin: 5px;
            width: 85%;
            border: 2px solid #f6f6f6;
            -webkit-transition: all 0.5s ease-in-out;
            -moz-transition: all 0.5s ease-in-out;
            -ms-transition: all 0.5s ease-in-out;
            -o-transition: all 0.5s ease-in-out;
            transition: all 0.5s ease-in-out;
            -webkit-border-radius: 5px 5px 5px 5px;
            border-radius: 5px 5px 5px 5px;
        }

        input[type=text]:focus {
            background-color: #fff;
            border-bottom: 2px solid #5fbae9;
        }

        input[type=text]:placeholder {
            color: #cccccc;
        }



        /* ANIMATIONS */

        /* Simple CSS3 Fade-in-down Animation */
        .fadeInDown {
            -webkit-animation-name: fadeInDown;
            animation-name: fadeInDown;
            -webkit-animation-duration: 1s;
            animation-duration: 1s;
            -webkit-animation-fill-mode: both;
            animation-fill-mode: both;
        }

        @-webkit-keyframes fadeInDown {
            0% {
                opacity:50%;
                -webkit-transform: translate3d(0, -100%, 0);
                transform: translate3d(0, -100%, 0);
            }
            100% {
                opacity: 1;
                -webkit-transform: none;
                transform: none;
            }
        }

        @keyframes fadeInDown {
            0% {
                opacity: 0;
                -webkit-transform: translate3d(0, -100%, 0);
                transform: translate3d(0, -100%, 0);
            }
            100% {
                opacity: 1;
                -webkit-transform: none;
                transform: none;
            }
        }

        /* Simple CSS3 Fade-in Animation */
        @-webkit-keyframes fadeIn { from { opacity:0; } to { opacity:1; } }
        @-moz-keyframes fadeIn { from { opacity:0; } to { opacity:1; } }
        @keyframes fadeIn { from { opacity:0; } to { opacity:1; } }

        .fadeIn {
            opacity:0;
            -webkit-animation:fadeIn ease-in 1;
            -moz-animation:fadeIn ease-in 1;
            animation:fadeIn ease-in 1;

            -webkit-animation-fill-mode:forwards;
            -moz-animation-fill-mode:forwards;
            animation-fill-mode:forwards;

            -webkit-animation-duration:1s;
            -moz-animation-duration:1s;
            animation-duration:1s;
        }

        .fadeIn.first {
            -webkit-animation-delay: 0.4s;
            -moz-animation-delay: 0.4s;
            animation-delay: 0.4s;
        }

        .fadeIn.second {
            -webkit-animation-delay: 0.6s;
            -moz-animation-delay: 0.6s;
            animation-delay: 0.6s;
        }

        .fadeIn.third {
            -webkit-animation-delay: 0.8s;
            -moz-animation-delay: 0.8s;
            animation-delay: 0.8s;
        }

        .fadeIn.fourth {
            -webkit-animation-delay: 1s;
            -moz-animation-delay: 1s;
            animation-delay: 1s;
        }

        /* Simple CSS3 Fade-in Animation */
        .underlineHover:after {
            display: block;
            left: 0;
            bottom: -10px;
            width: 0;
            height: 2px;
            background-color: #56baed;
            content: "";
            transition: width 0.2s;
        }

        .underlineHover:hover {
            color: #0d0d0d;
        }

        .underlineHover:hover:after{
            width: 100%;
        }



        /* OTHERS */

        *:focus {
            outline: none;
        }

        #icon {
            width:60%;
        }

    </style>

</head>
<body>
hello
<%  String msg = (String) request.getAttribute("msg"); %>

<% if (msg == null) { %>
<div style="color:#ED7D17; font-size:16px;padding: 15px;margin:10px;background-color:#ECE8E5;" >
    SCGE Toolkit Accounts are currently available to consortium members only<br>
    Questions regarding access can be mailed to scge@mcw.edu
</div>
<% } %>

<div class="wrapper fadeInDown" style="background-color:#F1EDEA" >

    <table>
        <% if (msg != null) { %>
        <tr>
            <td colspan=2>
                <div style="padding:10px; font-size:26px;color:#ED7D17;"><%=msg%></div>
            </td>
        </tr>
        <%
            }
        %>

        <tr>
            <td>
                <form action="requestAccount?${_csrf.parameterName}=${_csrf.token}" method="post">

                    <div style="border:1px solid black; padding: 5px;">
    <table border="0" width="500">
        <tr>
            <td width="150">First Name</td><td><input name="firstName" type="text" value=""/></td>
        </tr>
        <tr>
            <td>Last Name</td><td><input name="lastName" type="text" value=""/></td>
        </tr>
        <tr>
            <td width="150">Email Address tied to Google Account (Institutional email address is recommended)</td><td width="350"><input name="googleEmail" type="text" value=""/></td>
        </tr>
        <tr>
            <td>Institution</td><td><input name="institution" type="text" value=""/></td>
        </tr>
        <tr>
            <td>Institutional Email Address (if different than Email address registered to Google account)</td><td><input name="institutionalEmail" type="text" value=""/></td>
        </tr>
        <tr>
            <td>Principal Investigator</td><td><input name="pi" type="text" value=""/></td>
        </tr>
        <tr>
            <td colspan="2" align="center"><input type="submit" value="Submit Access Request"/></td>
        </tr>
    </table>
                    </div>
                    <input type="hidden" name="action" value="request"/>
                </form>
            </td><td valign="top">

<div style="border:1px solid black; padding:5px; margin:5px;">
    <table>

        <tr><td>The SCGE toolkit uses <b>Google</b> as its authentication provider</td></tr>

        <tr><td><br>To gain access you must have an account at <a href="https://www.google.com" style="font-weight:700;">https://www.google.com</a><br><br></td></tr>

        <tr><td>It is recommended that you create a Google account using your institutional email address (i.e. jane.doe@harvard.edu).  This will assist us in verifying your identity.  Instructions on creating a Google account can be found here...<a href="https://support.google.com/accounts/answer/27441?hl=en" style="font-weight:700;">Create a Google Account - Google Account Help</a>  </td></tr>

        <tr><td><br>If you have questions, please contact <a href="mailto:scge@mcw.edu" style="font-weight:700;">scge@mcw.edu</a></td></tr>

        <tr><td><br>Thank You!</td></tr>

    </table>

</div>


        </td>
        </tr>
    </table>

</div>
<div>
    <p style="color: darkorange;"><strong>Background image credit:</strong>&nbsp;National Human Genome Research Institute</p>
</div>
</body>
</html>

