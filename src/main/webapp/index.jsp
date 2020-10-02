<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 8/9/2019
  Time: 3:33 PM
  To change this template use File | Settings | File Templates.
--%>
<%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 8/9/2019
  Time: 3:33 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html >
<head>
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Somatic Cell Gene Editing</title>
  <meta property="og:title" content="Somatic Cell Gene Editing"/>
  <meta property="og:type" content="article"/>
  <meta property="og:url" content="https://scge.mcw.edu/"/>
  <meta property="og:site_name" content="Somatic Cell Gene Editing"/>
  <meta property="og:description" content="The goal of the SCGE program is to accelerate the development of safer and more effective methods to edit the genomes of disease-relevant somatic cells and tissues in patients.  For ethical, legal and safety reasons, the SCGE program does not support any research activities on genome editing in reproductive (germ) cells.
Goals"/>

  <meta property="og:image" content="https://scge.mcw.edu/wp-content/uploads/2019/03/SCGElogo-50.jpg"/>
  <!-- This site uses the Google Analytics by MonsterInsights plugin v7.10.0 - Using Analytics tracking - https://www.monsterinsights.com/ -->
  <script type="text/javascript" data-cfasync="false">
    var mi_version         = '7.10.0';
    var mi_track_user      = true;
    var mi_no_track_reason = '';

    var disableStr = 'ga-disable-UA-150985023-1';

    /* Function to detect opted out users */
    function __gaTrackerIsOptedOut() {
      return document.cookie.indexOf(disableStr + '=true') > -1;
    }

    /* Disable tracking if the opt-out cookie exists. */
    if ( __gaTrackerIsOptedOut() ) {
      window[disableStr] = true;
    }

    /* Opt-out function */
    function __gaTrackerOptout() {
      document.cookie = disableStr + '=true; expires=Thu, 31 Dec 2099 23:59:59 UTC; path=/';
      window[disableStr] = true;
    }

    if ( mi_track_user ) {
      (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
                (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
              m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
      })(window,document,'script','//www.google-analytics.com/analytics.js','__gaTracker');

      __gaTracker('create', 'UA-150985023-1', 'auto');
      __gaTracker('set', 'forceSSL', true);
      __gaTracker('require', 'displayfeatures');
      __gaTracker('send','pageview');
    } else {
      console.log( "" );
      (function() {
        /* https://developers.google.com/analytics/devguides/collection/analyticsjs/ */
        var noopfn = function() {
          return null;
        };
        var noopnullfn = function() {
          return null;
        };
        var Tracker = function() {
          return null;
        };
        var p = Tracker.prototype;
        p.get = noopfn;
        p.set = noopfn;
        p.send = noopfn;
        var __gaTracker = function() {
          var len = arguments.length;
          if ( len === 0 ) {
            return;
          }
          var f = arguments[len-1];
          if ( typeof f !== 'object' || f === null || typeof f.hitCallback !== 'function' ) {
            console.log( 'Not running function __gaTracker(' + arguments[0] + " ....) because you are not being tracked. " + mi_no_track_reason );
            return;
          }
          try {
            f.hitCallback();
          } catch (ex) {

          }
        };
        __gaTracker.create = function() {
          return new Tracker();
        };
        __gaTracker.getByName = noopnullfn;
        __gaTracker.getAll = function() {
          return [];
        };
        __gaTracker.remove = noopfn;
        window['__gaTracker'] = __gaTracker;
      })();
    }
  </script>
  <!-- / Google Analytics by MonsterInsights -->

  <style type="text/css">
    img.wp-smiley,
    img.emoji {
      display: inline !important;
      border: none !important;
      box-shadow: none !important;
      height: 1em !important;
      width: 1em !important;
      margin: 0 .07em !important;
      vertical-align: -0.1em !important;
      background: none !important;
      padding: 0 !important;
    }
  </style>
  <link rel='stylesheet' id='tribe-common-skeleton-style-css'  href='https://scge.mcw.edu/wp-content/plugins/the-events-calendar/common/src/resources/css/common-skeleton.min.css?ver=4.9.21' type='text/css' media='all' />
  <link rel='stylesheet' id='tribe-tooltip-css-css'  href='https://scge.mcw.edu/wp-content/plugins/the-events-calendar/common/src/resources/css/tooltip.min.css?ver=4.9.21' type='text/css' media='all' />
  <link rel='stylesheet' id='rs-plugin-settings-css'  href='https://scge.mcw.edu/wp-content/plugins/revslider/public/assets/css/rs6.css?ver=6.1.3' type='text/css' media='all' />
  <style id='rs-plugin-settings-inline-css' type='text/css'>
    #rs-demo-id {}
  </style>
  <link rel='stylesheet' id='avada-stylesheet-css'  href='https://scge.mcw.edu/wp-content/themes/Avada/assets/css/style.min.css?ver=6.1.1' type='text/css' media='all' />
  <link rel='stylesheet' id='child-style-css'  href='https://scge.mcw.edu/wp-content/themes/Avada-Child-Theme/style.css?ver=5.3' type='text/css' media='all' />
  <!--[if IE]>
  <link rel='stylesheet' id='avada-IE-css'  href='https://scge.mcw.edu/wp-content/themes/Avada/assets/css/ie.min.css?ver=6.1.1' type='text/css' media='all' />
  <style id='avada-IE-inline-css' type='text/css'>
    .avada-select-parent .select-arrow{background-color:#ffffff}
    .select-arrow{background-color:#ffffff}
  </style>
  <![endif]-->
  <link rel='stylesheet' id='fusion-dynamic-css-css'  href='common/css/fusion-styles.css' type='text/css' media='all' />
  <link rel='stylesheet' id='sccss_style-css'  href='https://scge.mcw.edu/?sccss=1&#038;ver=5.3' type='text/css' media='all' />
  <script type='text/javascript' src='https://scge.mcw.edu/wp-includes/js/jquery/jquery.js?ver=1.12.4-wp'></script>

  <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">

  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/google-analytics-for-wordpress/assets/js/frontend.min.js?ver=7.10.0'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/revslider/public/assets/js/revolution.tools.min.js?ver=6.0'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/revslider/public/assets/js/rs6.min.js?ver=6.1.3'></script>
  <link rel='https://api.w.org/' href='https://scge.mcw.edu/wp-json/' />
  <link rel="EditURI" type="application/rsd+xml" title="RSD" href="https://scge.mcw.edu/xmlrpc.php?rsd" />
  <link rel="wlwmanifest" type="application/wlwmanifest+xml" href="https://scge.mcw.edu/wp-includes/wlwmanifest.xml" />
  <meta name="generator" content="WordPress 5.3" />
  <link rel="canonical" href="https://scge.mcw.edu/" />
  <link rel='shortlink' href='https://scge.mcw.edu/' />
  <link rel="alternate" type="application/json+oembed" href="https://scge.mcw.edu/wp-json/oembed/1.0/embed?url=https%3A%2F%2Fscge.mcw.edu%2F" />
  <meta name="tec-api-version" content="v1"><meta name="tec-api-origin" content="https://scge.mcw.edu"><link rel="https://theeventscalendar.com/" href="https://scge.mcw.edu/wp-json/tribe/events/v1/" /><style type="text/css" id="css-fb-visibility">@media screen and (max-width: 640px){body:not(.fusion-builder-ui-wireframe) .fusion-no-small-visibility{display:none !important;}}@media screen and (min-width: 641px) and (max-width: 1024px){body:not(.fusion-builder-ui-wireframe) .fusion-no-medium-visibility{display:none !important;}}@media screen and (min-width: 1025px){body:not(.fusion-builder-ui-wireframe) .fusion-no-large-visibility{display:none !important;}}</style><style type="text/css">.recentcomments a{display:inline !important;padding:0 !important;margin:0 !important;}</style><meta name="generator" content="Powered by Slider Revolution 6.1.3 - responsive, Mobile-Friendly Slider Plugin for WordPress with comfortable drag and drop interface." />
  <link rel="icon" href="https://scge.mcw.edu/wp-content/uploads/2019/01/Somatic_Cell_Graphic-190.jpg" sizes="32x32" />
  <link rel="icon" href="https://scge.mcw.edu/wp-content/uploads/2019/01/Somatic_Cell_Graphic-190.jpg" sizes="192x192" />
  <link rel="apple-touch-icon-precomposed" href="https://scge.mcw.edu/wp-content/uploads/2019/01/Somatic_Cell_Graphic-190.jpg" />
  <meta name="msapplication-TileImage" content="https://scge.mcw.edu/wp-content/uploads/2019/01/Somatic_Cell_Graphic-190.jpg" />
  <script type="text/javascript">function setREVStartSize(t){try{var h,e=document.getElementById(t.c).parentNode.offsetWidth;if(e=0===e||isNaN(e)?window.innerWidth:e,t.tabw=void 0===t.tabw?0:parseInt(t.tabw),t.thumbw=void 0===t.thumbw?0:parseInt(t.thumbw),t.tabh=void 0===t.tabh?0:parseInt(t.tabh),t.thumbh=void 0===t.thumbh?0:parseInt(t.thumbh),t.tabhide=void 0===t.tabhide?0:parseInt(t.tabhide),t.thumbhide=void 0===t.thumbhide?0:parseInt(t.thumbhide),t.mh=void 0===t.mh||""==t.mh||"auto"===t.mh?0:parseInt(t.mh,0),"fullscreen"===t.layout||"fullscreen"===t.l)h=Math.max(t.mh,window.innerHeight);else{for(var i in t.gw=Array.isArray(t.gw)?t.gw:[t.gw],t.rl)void 0!==t.gw[i]&&0!==t.gw[i]||(t.gw[i]=t.gw[i-1]);for(var i in t.gh=void 0===t.el||""===t.el||Array.isArray(t.el)&&0==t.el.length?t.gh:t.el,t.gh=Array.isArray(t.gh)?t.gh:[t.gh],t.rl)void 0!==t.gh[i]&&0!==t.gh[i]||(t.gh[i]=t.gh[i-1]);var r,a=new Array(t.rl.length),n=0;for(var i in t.tabw=t.tabhide>=e?0:t.tabw,t.thumbw=t.thumbhide>=e?0:t.thumbw,t.tabh=t.tabhide>=e?0:t.tabh,t.thumbh=t.thumbhide>=e?0:t.thumbh,t.rl)a[i]=t.rl[i]<window.innerWidth?0:t.rl[i];for(var i in r=a[0],a)r>a[i]&&0<a[i]&&(r=a[i],n=i);var d=e>t.gw[n]+t.tabw+t.thumbw?1:(e-(t.tabw+t.thumbw))/t.gw[n];h=t.gh[n]*d+(t.tabh+t.thumbh)}void 0===window.rs_init_css&&(window.rs_init_css=document.head.appendChild(document.createElement("style"))),document.getElementById(t.c).height=h,window.rs_init_css.innerHTML+="#"+t.c+"_wrapper { height: "+h+"px }"}catch(t){console.log("Failure at Presize of Slider:"+t)}};</script>
  <script type="text/javascript">
    var doc = document.documentElement;
    doc.setAttribute( 'data-useragent', navigator.userAgent );
  </script>

</head>

<body>

<div id="boxed-wrapper">
  <div class=""></div>
  <div id="wrapper" class="fusion-wrapper">
    <div id="home" style="position:relative;top:-1px;"></div>

    <header class="container-fluid">
      <div class="fusion-header-v3 fusion-logo-alignment fusion-logo-left fusion-sticky-menu- fusion-sticky-logo- fusion-mobile-logo-  fusion-mobile-menu-design-modern">

        <div class="fusion-secondary-header">
          <div class="fusion-row">
            <div class="fusion-alignleft">
              <div class="fusion-contact-info"><span class="fusion-contact-info-phone-number"></span><span class="fusion-contact-info-email-address"><a href="mailto:s&#99;g&#101;&#64;&#109;&#99;&#119;&#46;e&#100;&#117;">s&#99;g&#101;&#64;&#109;&#99;&#119;&#46;e&#100;&#117;</a></span></div>

            </div>
            <div class="fusion-alignright">

                            <span class="navbar-text navbar-right">
                                 <a href="/loginSuccess?destination=base" style="font-weight: bold"><i class="fa fa-home" style="font-size: large" title="My Dashboard"></i></a>
                              <!-- using pageContext requires jsp-api artifact in pom.xml -->
                                <c:choose>
                                  <c:when test="${userName!=null}">
                                    Logged in as:<img class="img-circle" src="${userImageUrl}" width="24">

                                    ${userName}&nbsp;
                                    <a href="logout" title="Sign out"><button class="btn btn-primary">Logout</button></a>

                                  </c:when>
                                  <c:otherwise>
                                    <a href="login/google?state=">Google Login</a>
                                  </c:otherwise>
                                </c:choose>

                            </span>
            </div>
          </div>
        </div>
        <div class="fusion-header-sticky-height"></div>
        <div class="fusion-header">
          <div class="fusion-row">
            <div class="fusion-logo" data-margin-top="-0px" data-margin-bottom="-20px" data-margin-left="0px" data-margin-right="0px">
              <a class="fusion-logo-link"  href="https://scge.mcw.edu/" >

                <!-- standard logo -->
                <img src="https://scge.mcw.edu/wp-content/uploads/2019/03/SCGElogo-50.jpg" srcset="https://scge.mcw.edu/wp-content/uploads/2019/03/SCGElogo-50.jpg 1x" width="72" height="50" alt="Somatic Cell Gene Editing Logo" data-retina_logo_url="" class="fusion-standard-logo" />


              </a>
            </div>
            <nav><ul id="" class="">
            <li> <a href="/scgeweb/toolkit/home?destination=base" style="font-weight: bold;color:orangered">Toolkit</a></li>
            <c:if test="${userName!=null}">

              <li> <a href="/scgeweb/loginSuccess?destination=base" style="font-weight: bold;color:orangered">My Dashboard</a></li>
            </c:if>
            <!--li  id="menu-item-733"  class="menu-item menu-item-type-post_type menu-item-object-page menu-item-home current-menu-item page_item page-item-17 current_page_item menu-item-733"  data-item-id="733"><a  href="https://scge.mcw.edu/" class="fusion-flex-link fusion-bar-highlight"><span class="fusion-megamenu-icon"><i class="glyphicon fa-home fas"></i></span><span class="menu-text">Home</span></a></li><li  id="menu-item-320"  class="menu-item menu-item-type-post_type menu-item-object-page menu-item-320"  data-item-id="320"><a  href="https://scge.mcw.edu/about-us/" class="fusion-flex-link fusion-bar-highlight"><span class="fusion-megamenu-icon"><i class="glyphicon fa-qrcode fas"></i></span><span class="menu-text">About</span></a></li><li  id="menu-item-749"  class="menu-item menu-item-type-custom menu-item-object-custom menu-item-has-children menu-item-749 fusion-megamenu-menu"  data-item-id="749"><a  href="#" class="fusion-flex-link fusion-bar-highlight"><span class="fusion-megamenu-icon"><i class="glyphicon fa-bezier-curve fas"></i></span><span class="menu-text">Goals by Initiatives</span></a><div class="fusion-megamenu-wrapper fusion-columns-5 columns-per-row-5 columns-5 col-span-10"><div class="row"><div class="fusion-megamenu-holder" style="width:999.996px;background-image: url(https://scge.mcw.edu/wp-content/uploads/2019/04/286-40-grey-blue-squares-HUD-gear-FULL.jpg);" data-width="999.996px"><ul role="menu" class="fusion-megamenu"><li  id="menu-item-421"  class="menu-item menu-item-type-post_type menu-item-object-page menu-item-421 fusion-megamenu-submenu fusion-megamenu-columns-5 col-lg-2 col-md-2 col-sm-2"  style="width:20%;"><div class='fusion-megamenu-title'><a href="https://scge.mcw.edu/animal_reporter/">Animal Reporter and Testing Centers</a></div><div class="fusion-megamenu-widgets-container second-level-widget"><style type="text/css" data-id="media_image-2">@media (max-width: 800px){#media_image-2{text-align:center !important;}}</style><div id="media_image-2" class="fusion-widget-mobile-align-center fusion-widget-align-center widget widget_media_image" style="text-align: center;"><a href="https://scge.mcw.edu/animal_reporter/"><img width="100" height="100" src="https://scge.mcw.edu/wp-content/uploads/2019/03/mouse.png" class="image wp-image-106  attachment-100x100 size-100x100" alt="" style="max-width: 100%; height: auto;" srcset="https://scge.mcw.edu/wp-content/uploads/2019/03/mouse-27x27.png 27w, https://scge.mcw.edu/wp-content/uploads/2019/03/mouse-66x66.png 66w, https://scge.mcw.edu/wp-content/uploads/2019/03/mouse.png 134w" sizes="(max-width: 100px) 100vw, 100px" /></a></div></div></li><li  id="menu-item-420"  class="menu-item menu-item-type-post_type menu-item-object-page menu-item-420 fusion-megamenu-submenu fusion-megamenu-columns-5 col-lg-2 col-md-2 col-sm-2"  style="width:20%;"><div class='fusion-megamenu-title'><a href="https://scge.mcw.edu/biologicalsystems/">Biological Systems Projects</a></div><div class="fusion-megamenu-widgets-container second-level-widget"><div id="media_image-3" class="widget widget_media_image"><a href="https://scge.mcw.edu/biologicalsystems/"><img width="100" height="100" src="https://scge.mcw.edu/wp-content/uploads/2019/06/biological-rev.png" class="image wp-image-1111  attachment-100x100 size-100x100" alt="" style="max-width: 100%; height: auto;" srcset="https://scge.mcw.edu/wp-content/uploads/2019/06/biological-rev-66x66.png 66w, https://scge.mcw.edu/wp-content/uploads/2019/06/biological-rev.png 134w" sizes="(max-width: 100px) 100vw, 100px" /></a></div></div></li><li  id="menu-item-419"  class="menu-item menu-item-type-post_type menu-item-object-page menu-item-419 fusion-megamenu-submenu fusion-megamenu-columns-5 col-lg-2 col-md-2 col-sm-2"  style="width:20%;"><div class='fusion-megamenu-title'><a href="https://scge.mcw.edu/deliverysystems/">Delivery Systems Projects</a></div><div class="fusion-megamenu-widgets-container second-level-widget"><div id="media_image-4" class="widget widget_media_image"><a href="https://scge.mcw.edu/deliverysystems/"><img width="100" height="100" src="https://scge.mcw.edu/wp-content/uploads/2019/03/Delivery.png" class="image wp-image-158  attachment-100x100 size-100x100" alt="" style="max-width: 100%; height: auto;" srcset="https://scge.mcw.edu/wp-content/uploads/2019/03/Delivery-27x27.png 27w, https://scge.mcw.edu/wp-content/uploads/2019/03/Delivery-66x66.png 66w, https://scge.mcw.edu/wp-content/uploads/2019/03/Delivery.png 134w" sizes="(max-width: 100px) 100vw, 100px" /></a></div></div></li><li  id="menu-item-418"  class="menu-item menu-item-type-post_type menu-item-object-page menu-item-418 fusion-megamenu-submenu fusion-megamenu-columns-5 col-lg-2 col-md-2 col-sm-2"  style="width:20%;"><div class='fusion-megamenu-title'><a href="https://scge.mcw.edu/genomeeditor/">Genome Editor Projects</a></div><div class="fusion-megamenu-widgets-container second-level-widget"><div id="media_image-6" class="widget widget_media_image"><a href="https://scge.mcw.edu/genomeeditor/"><img width="100" height="100" src="https://scge.mcw.edu/wp-content/uploads/2019/06/Editor-rev.png" class="image wp-image-1110  attachment-100x100 size-100x100" alt="" style="max-width: 100%; height: auto;" srcset="https://scge.mcw.edu/wp-content/uploads/2019/06/Editor-rev-66x66.png 66w, https://scge.mcw.edu/wp-content/uploads/2019/06/Editor-rev.png 134w" sizes="(max-width: 100px) 100vw, 100px" /></a></div></div></li><li  id="menu-item-417"  class="menu-item menu-item-type-post_type menu-item-object-page menu-item-417 fusion-megamenu-submenu fusion-megamenu-columns-5 col-lg-2 col-md-2 col-sm-2"  style="width:20%;"><div class='fusion-megamenu-title'><a href="https://scge.mcw.edu/dissemination/">Dissemination and Coordinating Center</a></div><div class="fusion-megamenu-widgets-container second-level-widget"><div id="media_image-5" class="widget widget_media_image"><a href="https://scge.mcw.edu/dissemination/"><img width="100" height="100" src="https://scge.mcw.edu/wp-content/uploads/2019/03/DCC.png" class="image wp-image-160  attachment-100x100 size-100x100" alt="" style="max-width: 100%; height: auto;" srcset="https://scge.mcw.edu/wp-content/uploads/2019/03/DCC-27x27.png 27w, https://scge.mcw.edu/wp-content/uploads/2019/03/DCC-66x66.png 66w, https://scge.mcw.edu/wp-content/uploads/2019/03/DCC.png 134w" sizes="(max-width: 100px) 100vw, 100px" /></a></div></div></li></ul></div><div style="clear:both;"></div></div></div></li><li  id="menu-item-1091"  class="menu-item menu-item-type-custom menu-item-object-custom menu-item-has-children menu-item-1091 fusion-megamenu-menu"  data-item-id="1091"><a  target="_blank" rel="noopener noreferrer" href="#" class="fusion-flex-link fusion-bar-highlight"><span class="fusion-megamenu-icon"><i class="glyphicon fa-diagnoses fas"></i></span><span class="menu-text">News &#038; Events</span></a><div class="fusion-megamenu-wrapper fusion-columns-2 columns-per-row-2 columns-2 col-span-4"><div class="row"><div class="fusion-megamenu-holder" style="width:399.9984px;background-image: url(https://scge.mcw.edu/wp-content/uploads/2019/04/286-40-grey-blue-squares-HUD-gear.jpg);" data-width="399.9984px"><ul role="menu" class="fusion-megamenu"><li  id="menu-item-1239"  class="menu-item menu-item-type-post_type menu-item-object-page menu-item-1239 fusion-megamenu-submenu fusion-megamenu-columns-2 col-lg-6 col-md-6 col-sm-6"  style="width:50%;"><div class='fusion-megamenu-title'><a href="https://scge.mcw.edu/in-the-news-archive/">In The News Archive</a></div></li><li  id="menu-item-1251"  class="menu-item menu-item-type-custom menu-item-object-custom menu-item-1251 fusion-megamenu-submenu fusion-megamenu-columns-2 col-lg-6 col-md-6 col-sm-6"  style="width:50%;"><div class='fusion-megamenu-title'><a href="https://scge.mcw.edu/events/">Meetings</a></div></li></ul></div><div style="clear:both;"></div></div></div></li><li  id="menu-item-1212"  class="menu-item menu-item-type-post_type menu-item-object-page menu-item-1212"  data-item-id="1212"><a  href="https://scge.mcw.edu/publications-3/" class="fusion-bar-highlight"><span class="menu-text">Publications</span></a></li><li  id="menu-item-387"  class="menu-item menu-item-type-post_type menu-item-object-page menu-item-387"  data-item-id="387"><a  href="https://scge.mcw.edu/contact/" class="fusion-flex-link fusion-bar-highlight"><span class="fusion-megamenu-icon"><i class="glyphicon fa-address-book fas"></i></span><span class="menu-text">Contact Us</span></a></li-->
            </ul></nav>
          </div>
        </div>
      </div>
    </header>








    <div class="fusion-footer">


      <footer id="footer" class="fusion-footer-copyright-area fusion-footer-copyright-center">
        <div class="fusion-row">
          <div class="fusion-copyright-content">

            <div class="fusion-copyright-notice">
              <div>
                This website is hosted by the SCGE DCC | Copyright 2019 SCGE | All Rights Reserved	</div>
            </div>
            <div class="fusion-social-links-footer">
            </div>

          </div> <!-- fusion-fusion-copyright-content -->
        </div> <!-- fusion-row -->
      </footer> <!-- #footer -->
    </div> <!-- fusion-footer -->



  </div> <!-- wrapper -->
</div> <!-- #boxed-wrapper -->

<a class="fusion-one-page-text-link fusion-page-load-link"></a>

<div class="avada-footer-scripts">
  <script>
    ( function ( body ) {
      'use strict';
      body.className = body.className.replace( /\btribe-no-js\b/, 'tribe-js' );
    } )( document.body );
  </script>
  <script> /* <![CDATA[ */var tribe_l10n_datatables = {"aria":{"sort_ascending":": activate to sort column ascending","sort_descending":": activate to sort column descending"},"length_menu":"Show _MENU_ entries","empty_table":"No data available in table","info":"Showing _START_ to _END_ of _TOTAL_ entries","info_empty":"Showing 0 to 0 of 0 entries","info_filtered":"(filtered from _MAX_ total entries)","zero_records":"No matching records found","search":"Search:","all_selected_text":"All items on this page were selected. ","select_all_link":"Select all pages","clear_selection":"Clear Selection.","pagination":{"all":"All","next":"Next","previous":"Previous"},"select":{"rows":{"0":"","_":": Selected %d rows","1":": Selected 1 row"}},"datepicker":{"dayNames":["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],"dayNamesShort":["Sun","Mon","Tue","Wed","Thu","Fri","Sat"],"dayNamesMin":["S","M","T","W","T","F","S"],"monthNames":["January","February","March","April","May","June","July","August","September","October","November","December"],"monthNamesShort":["January","February","March","April","May","June","July","August","September","October","November","December"],"monthNamesMin":["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],"nextText":"Next","prevText":"Prev","currentText":"Today","closeText":"Done","today":"Today","clear":"Clear"}};/* ]]> */ </script>		<script type="text/javascript">
  if(typeof revslider_showDoubleJqueryError === "undefined") {
    function revslider_showDoubleJqueryError(sliderID) {
      var err = "<div class='rs_error_message_box'>";
      err += "<div class='rs_error_message_oops'>Oops...</div>";
      err += "<div class='rs_error_message_content'>";
      err += "You have some jquery.js library include that comes after the Slider Revolution files js inclusion.<br>";
      err += "To fix this, you can:<br>&nbsp;&nbsp;&nbsp; 1. Set 'Module General Options' ->  'jQuery & OutPut Filters' -> 'Put JS to Body' to on";
      err += "<br>&nbsp;&nbsp;&nbsp; 2. Find the double jQuery.js inclusion and remove it";
      err += "</div>";
      err += "</div>";
      jQuery(sliderID).show().html(err);
    }
  }
</script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/the-events-calendar/common/src/resources/js/tribe-common.min.js?ver=4.9.21'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/the-events-calendar/common/src/resources/js/tooltip.min.js?ver=4.9.21'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/library/modernizr.js?ver=3.3.1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/library/jquery.fitvids.js?ver=1.1'></script>
  <script type='text/javascript'>
    /* <![CDATA[ */
    var fusionVideoGeneralVars = {"status_vimeo":"1","status_yt":"1"};
    /* ]]> */
  </script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/library/fusion-video-general.js?ver=1'></script>
  <script type='text/javascript'>
    /* <![CDATA[ */
    var fusionLightboxVideoVars = {"lightbox_video_width":"1280","lightbox_video_height":"720"};
    /* ]]> */
  </script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/library/jquery.ilightbox.js?ver=2.2.3'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/library/jquery.mousewheel.js?ver=3.0.6'></script>
  <script type='text/javascript'>
    /* <![CDATA[ */
    var fusionLightboxVars = {"status_lightbox":"1","lightbox_gallery":"1","lightbox_skin":"metro-white","lightbox_title":"1","lightbox_arrows":"1","lightbox_slideshow_speed":"5000","lightbox_autoplay":"","lightbox_opacity":"0.9","lightbox_desc":"1","lightbox_social":"1","lightbox_deeplinking":"1","lightbox_path":"vertical","lightbox_post_images":"1","lightbox_animation_speed":"normal"};
    /* ]]> */
  </script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/general/fusion-lightbox.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/library/imagesLoaded.js?ver=3.1.8'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/library/isotope.js?ver=3.0.4'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/library/packery.js?ver=2.0.0'></script>
  <script type='text/javascript'>
    /* <![CDATA[ */
    var avadaPortfolioVars = {"lightbox_behavior":"all","infinite_finished_msg":"<em>All items displayed.<\/em>","infinite_blog_text":"<em>Loading the next set of posts...<\/em>","content_break_point":"800"};
    /* ]]> */
  </script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/fusion-core/js/min/avada-portfolio.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/library/jquery.infinitescroll.js?ver=2.1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/fusion-core/js/min/avada-faqs.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/fusion-builder/assets/js/min/library/Chart.js?ver=2.7.1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/fusion-builder/assets/js/min/general/fusion-chart.js?ver=1'></script>
  <script type='text/javascript'>
    /* <![CDATA[ */
    var fusionBgImageVars = {"content_break_point":"800"};
    /* ]]> */
  </script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/fusion-builder/assets/js/min/general/fusion-column-bg-image.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/library/cssua.js?ver=2.1.28'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/library/jquery.waypoints.js?ver=2.0.3'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/general/fusion-waypoints.js?ver=1'></script>
  <script type='text/javascript'>
    /* <![CDATA[ */
    var fusionAnimationsVars = {"status_css_animations":"desktop"};
    /* ]]> */
  </script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/fusion-builder/assets/js/min/general/fusion-animations.js?ver=1'></script>
  <script type='text/javascript'>
    /* <![CDATA[ */
    var fusionEqualHeightVars = {"content_break_point":"800"};
    /* ]]> */
  </script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/general/fusion-equal-heights.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/fusion-builder/assets/js/min/general/fusion-column.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/library/jquery.fade.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/library/jquery.requestAnimationFrame.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/library/fusion-parallax.js?ver=1'></script>
  <script type='text/javascript'>
    /* <![CDATA[ */
    var fusionVideoBgVars = {"status_vimeo":"1","status_yt":"1"};
    /* ]]> */
  </script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/library/fusion-video-bg.js?ver=1'></script>
  <script type='text/javascript'>
    /* <![CDATA[ */
    var fusionContainerVars = {"content_break_point":"800","container_hundred_percent_height_mobile":"0","is_sticky_header_transparent":"0"};
    /* ]]> */
  </script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/fusion-builder/assets/js/min/general/fusion-container.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/fusion-builder/assets/js/min/general/fusion-content-boxes.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/fusion-builder/assets/js/min/library/jquery.countdown.js?ver=1.0'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/fusion-builder/assets/js/min/general/fusion-countdown.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/fusion-builder/assets/js/min/library/jquery.countTo.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/library/jquery.appear.js?ver=1'></script>
  <script type='text/javascript'>
    /* <![CDATA[ */
    var fusionCountersBox = {"counter_box_speed":"1000"};
    /* ]]> */
  </script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/fusion-builder/assets/js/min/general/fusion-counters-box.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/library/jquery.easyPieChart.js?ver=2.1.7'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/fusion-builder/assets/js/min/general/fusion-counters-circle.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/fusion-builder/assets/js/min/general/fusion-events.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/fusion-builder/assets/js/min/general/fusion-flip-boxes.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/fusion-builder/assets/js/min/general/fusion-gallery.js?ver=1'></script>
  <script type='text/javascript'>
    /* <![CDATA[ */
    var fusionMapsVars = {"admin_ajax":"https:\/\/scge.mcw.edu\/wp-admin\/admin-ajax.php"};
    /* ]]> */
  </script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/library/jquery.fusion_maps.js?ver=2.2.2'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/general/fusion-google-map.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/fusion-builder/assets/js/min/library/jquery.event.move.js?ver=2.0'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/fusion-builder/assets/js/min/general/fusion-image-before-after.js?ver=1.0'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/library/bootstrap.modal.js?ver=3.1.1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/fusion-builder/assets/js/min/general/fusion-modal.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/fusion-builder/assets/js/min/general/fusion-progress.js?ver=1'></script>
  <script type='text/javascript'>
    /* <![CDATA[ */
    var fusionRecentPostsVars = {"infinite_loading_text":"<em>Loading the next set of posts...<\/em>","infinite_finished_msg":"<em>All items displayed.<\/em>"};
    /* ]]> */
  </script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/fusion-builder/assets/js/min/general/fusion-recent-posts.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/fusion-builder/assets/js/min/general/fusion-syntax-highlighter.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/library/bootstrap.transition.js?ver=3.3.6'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/library/bootstrap.tab.js?ver=3.1.1'></script>
  <script type='text/javascript'>
    /* <![CDATA[ */
    var fusionTabVars = {"content_break_point":"800"};
    /* ]]> */
  </script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/fusion-builder/assets/js/min/general/fusion-tabs.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/library/jquery.cycle.js?ver=3.0.3'></script>
  <script type='text/javascript'>
    /* <![CDATA[ */
    var fusionTestimonialVars = {"testimonials_speed":"4000"};
    /* ]]> */
  </script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/fusion-builder/assets/js/min/general/fusion-testimonials.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/fusion-builder/assets/js/min/library/jquery.textillate.js?ver=2.0'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/fusion-builder/assets/js/min/general/fusion-title.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/library/bootstrap.collapse.js?ver=3.1.1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/fusion-builder/assets/js/min/general/fusion-toggles.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/library/vimeoPlayer.js?ver=2.2.1'></script>
  <script type='text/javascript'>
    /* <![CDATA[ */
    var fusionVideoVars = {"status_vimeo":"1"};
    /* ]]> */
  </script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/fusion-builder/assets/js/min/general/fusion-video.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/library/jquery.hoverintent.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/fusion-core/js/min/fusion-vertical-menu-widget.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/library/lazysizes.js?ver=4.1.5'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/library/bootstrap.tooltip.js?ver=3.3.5'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/library/bootstrap.popover.js?ver=3.3.5'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/library/jquery.carouFredSel.js?ver=6.2.1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/library/jquery.easing.js?ver=1.3'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/library/jquery.flexslider.js?ver=2.2.2'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/library/jquery.hoverflow.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/the-events-calendar/vendor/jquery-placeholder/jquery.placeholder.min.js?ver=4.9.11'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/library/jquery.touchSwipe.js?ver=1.6.6'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/general/fusion-alert.js?ver=1'></script>
  <script type='text/javascript'>
    /* <![CDATA[ */
    var fusionCarouselVars = {"related_posts_speed":"2500","carousel_speed":"2500"};
    /* ]]> */
  </script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/general/fusion-carousel.js?ver=1'></script>
  <script type='text/javascript'>
    /* <![CDATA[ */
    var fusionFlexSliderVars = {"status_vimeo":"1","slideshow_autoplay":"1","slideshow_speed":"7000","pagination_video_slide":"","status_yt":"1","flex_smoothHeight":"false"};
    /* ]]> */
  </script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/general/fusion-flexslider.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/general/fusion-popover.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/general/fusion-tooltip.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/general/fusion-sharing-box.js?ver=1'></script>
  <script type='text/javascript'>
    /* <![CDATA[ */
    var fusionBlogVars = {"infinite_blog_text":"<em>Loading the next set of posts...<\/em>","infinite_finished_msg":"<em>All items displayed.<\/em>","slideshow_autoplay":"1","lightbox_behavior":"all","blog_pagination_type":"pagination"};
    /* ]]> */
  </script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/general/fusion-blog.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/general/fusion-button.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/general/fusion-general-global.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/general/fusion.js?ver=2.1.1'></script>
  <script type='text/javascript'>
    /* <![CDATA[ */
    var avadaHeaderVars = {"header_position":"top","header_sticky":"1","header_sticky_type2_layout":"menu_only","header_sticky_shadow":"1","side_header_break_point":"800","header_sticky_mobile":"","header_sticky_tablet":"","mobile_menu_design":"modern","sticky_header_shrinkage":"","nav_height":"50","nav_highlight_border":"3","nav_highlight_style":"bar","logo_margin_top":"-0px","logo_margin_bottom":"-20px","layout_mode":"boxed","header_padding_top":"-100px","header_padding_bottom":"-100","scroll_offset":"full"};
    /* ]]> */
  </script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/assets/min/js/general/avada-header.js?ver=6.1.1'></script>
  <script type='text/javascript'>
    /* <![CDATA[ */
    var avadaMenuVars = {"site_layout":"boxed","header_position":"top","logo_alignment":"left","header_sticky":"1","header_sticky_mobile":"","header_sticky_tablet":"","side_header_break_point":"800","megamenu_base_width":"site_width","mobile_menu_design":"modern","dropdown_goto":"Go to...","mobile_nav_cart":"Shopping Cart","mobile_submenu_open":"Open submenu of %s","mobile_submenu_close":"Close submenu of %s","submenu_slideout":"1"};
    /* ]]> */
  </script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/assets/min/js/general/avada-menu.js?ver=6.1.1'></script>
  <script type='text/javascript'>
    /* <![CDATA[ */
    var fusionScrollToAnchorVars = {"content_break_point":"800","container_hundred_percent_height_mobile":"0"};
    /* ]]> */
  </script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/general/fusion-scroll-to-anchor.js?ver=1'></script>
  <script type='text/javascript'>
    /* <![CDATA[ */
    var fusionTypographyVars = {"site_width":"1200px","typography_responsive":"","typography_sensitivity":"0.6","typography_factor":"1.5","elements":"h1, h2, h3, h4, h5, h6"};
    /* ]]> */
  </script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/includes/lib/assets/min/js/general/fusion-responsive-typography.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/assets/min/js/general/avada-skip-link-focus-fix.js?ver=6.1.1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/assets/min/js/library/bootstrap.scrollspy.js?ver=3.3.2'></script>
  <script type='text/javascript'>
    /* <![CDATA[ */
    var avadaCommentVars = {"title_style_type":"double solid","title_margin_top":"0px","title_margin_bottom":"31px"};
    /* ]]> */
  </script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/assets/min/js/general/avada-comments.js?ver=6.1.1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/assets/min/js/general/avada-general-footer.js?ver=6.1.1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/assets/min/js/general/avada-quantity.js?ver=6.1.1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/assets/min/js/general/avada-scrollspy.js?ver=6.1.1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/assets/min/js/general/avada-select.js?ver=6.1.1'></script>
  <script type='text/javascript'>
    /* <![CDATA[ */
    var avadaSidebarsVars = {"header_position":"top","header_layout":"v3","header_sticky":"1","header_sticky_type2_layout":"menu_only","side_header_break_point":"800","header_sticky_tablet":"","sticky_header_shrinkage":"","nav_height":"50","sidebar_break_point":"800"};
    /* ]]> */
  </script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/assets/min/js/general/avada-sidebars.js?ver=6.1.1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/assets/min/js/library/jquery.sticky-kit.js?ver=6.1.1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/assets/min/js/general/avada-tabs-widget.js?ver=6.1.1'></script>
  <script type='text/javascript'>
    /* <![CDATA[ */
    var toTopscreenReaderText = {"label":"Go to Top"};
    /* ]]> */
  </script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/assets/min/js/library/jquery.toTop.js?ver=1.2'></script>
  <script type='text/javascript'>
    /* <![CDATA[ */
    var avadaToTopVars = {"status_totop":"desktop","totop_position":"right","totop_scroll_down_only":"0"};
    /* ]]> */
  </script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/assets/min/js/general/avada-to-top.js?ver=6.1.1'></script>
  <script type='text/javascript'>
    /* <![CDATA[ */
    var avadaSelectVars = {"avada_drop_down":"1"};
    /* ]]> */
  </script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/assets/min/js/general/avada-drop-down.js?ver=6.1.1'></script>
  <script type='text/javascript'>
    /* <![CDATA[ */
    var avadaRevVars = {"avada_rev_styles":"1"};
    /* ]]> */
  </script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/assets/min/js/general/avada-rev-styles.js?ver=6.1.1'></script>
  <script type='text/javascript'>
    /* <![CDATA[ */
    var avadaFadeVars = {"page_title_fading":"1","header_position":"top"};
    /* ]]> */
  </script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/assets/min/js/general/avada-fade.js?ver=6.1.1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/assets/min/js/library/jquery.elasticslider.js?ver=6.1.1'></script>
  <script type='text/javascript'>
    /* <![CDATA[ */
    var avadaElasticSliderVars = {"tfes_autoplay":"1","tfes_animation":"sides","tfes_interval":"3000","tfes_speed":"800","tfes_width":"150"};
    /* ]]> */
  </script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/assets/min/js/general/avada-elastic-slider.js?ver=6.1.1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/themes/Avada/assets/min/js/general/avada-events.js?ver=6.1.1'></script>
  <script type='text/javascript'>
    /* <![CDATA[ */
    var avadaFusionSliderVars = {"side_header_break_point":"800","slider_position":"below","header_transparency":"0","mobile_header_transparency":"0","header_position":"top","content_break_point":"800","status_vimeo":"1"};
    /* ]]> */
  </script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-content/plugins/fusion-core/js/min/avada-fusion-slider.js?ver=1'></script>
  <script type='text/javascript' src='https://scge.mcw.edu/wp-includes/js/wp-embed.min.js?ver=5.3'></script>
  <script type="text/javascript">
    jQuery( document ).ready( function() {
      var ajaxurl = 'https://scge.mcw.edu/wp-admin/admin-ajax.php';
      if ( 0 < jQuery( '.fusion-login-nonce' ).length ) {
        jQuery.get( ajaxurl, { 'action': 'fusion_login_nonce' }, function( response ) {
          jQuery( '.fusion-login-nonce' ).html( response );
        });
      }
    });
  </script>
</div>
</body>
</html>


