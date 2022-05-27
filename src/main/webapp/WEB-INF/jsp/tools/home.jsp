<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="edu.mcw.scge.dao.spring.CountQuery" %>
<%@ page import="edu.mcw.scge.dao.implementation.StatsDao" %><%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 5/8/2020
  Time: 2:05 PM
  To change this template use File | Settings | File Templates.
--%>

<% StatsDao sdao = new StatsDao(); %>
<style>
    .card-label {
        font-weight: bold;
        border: 0;
        color: #017dc4;
        font-size:20px;
        padding-left:20px;
    }
    .card-image {
        height:80px;
        width:80px;
    }
    .card-body {
        padding: 0.25rem;
    }
    .card {
        border:0px solid black;
    }

</style>

<img src="/toolkit/images/toolkit-logo-1-200.png"/>
<br><br>
<img src="/toolkit/images/toolkit-logo-2-200.png"/>
<br><br>
<img src="/toolkit/images/toolkit-logo-1-70.png"/>
<br>



<div class="row" style="width:1000px;margin:auto;">
    <div class="col-sm-4" >

        <!---   studies by initiative card -->

        <div class="card" >
            <div class="card-body" >
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link text-secondary" href="/toolkit/data/search/results/Study?searchTerm=">
                            <table border="0">
                                <tr>
                                    <td><img src="/toolkit/images/studies.png" class="card-image" alt=""/></td>
                                    <td class="card-label">
                                        Browse&nbsp;Studies
                                    </td>
                                </tr>
                            </table>


                        </a>
                    </li>
                </ul>
            </div>
        </div>



        <div class="card">
            <div class="card-body">
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link text-secondary" href="/toolkit/data/search/results/Genome%20Editor?searchTerm=">
                            <table>
                                <tr>
                                    <td>
                                        <img src="/toolkit/images/Editor-rev.png"  class="card-image" alt=""/>
                                    </td>
                                    <td class="card-label">
                                        Genome&nbsp;Editors
                                    </td>
                                </tr>
                                </table>
                        </a>
                    </li>
                </ul>
            </div>
        </div>

        <div class="card">
            <div class="card-body">
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link text-secondary" href="/toolkit/data/search/results/Model%20System?searchTerm=">
                            <table>
                                <tr>
                                    <td>
                                        <img src="/toolkit/images/mouse.png"  class="card-image" alt=""/>

                                    </td>
                                    <td class="card-label">
                                        Model&nbsp;Systems
                                    </td>
                                </tr>
                            </table>

                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </div> <!--close col -->
    <div class="col-sm-4" >


        <div class="card">
            <div class="card-body">
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link text-secondary" href="/toolkit/data/search/results/Delivery%20System?searchTerm=">
                            <table>
                                <tr>
                                    <td>
                            <img src="/toolkit/images/Delivery.png"  class="card-image"  alt=""/>
                                    </td>
                                    <td class="card-label" >
                                        Delivery&nbsp;Systems
                                    </td>
                                </tr>
                                </table>
                        </a>
                    </li>
                </ul>
            </div>
        </div>



        <div class="card">
            <div class="card-body">
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link text-secondary" href="/toolkit/data/search/results/Guide?searchTerm=">
                            <table>
                                <tr>
                                    <td>
                            <img src="/toolkit/images/guide.png"   class="card-image" alt=""/>
                                    </td>
                                    <td class="card-label">
                                        Guides
                                    </td>
                                </tr>
                            </table>
                        </a>
                    </li>
                </ul>
            </div>
        </div>


        <div class="card">
            <div class="card-body">
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link text-secondary" href="/toolkit/data/search/results/Vector?searchTerm=">
                            <table>
                                <tr>
                                    <td>
                            <img src="/toolkit/images/vector.png"  class="card-image"  alt=""/>
                                    </td>
                                    <td class="card-label">
                                        Vectors
                                    </td>
                                </tr>
                            </table>
                        </a>
                    </li>
                </ul>
            </div>
        </div>

    </div> <!--close col -->
    <div class="col-sm-4">

        <div class="card">
            <div class="card-body">
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link text-secondary" href="/toolkit/data/protocols/search">
                            <table>
                                <tr>
                                    <td>
                            <img src="/toolkit/images/protocols.png"  class="card-image"  alt=""/>
                                    </td>
                                    <td class="card-label">
                                        Protocols
                                    </td>
                                </tr>
                            </table>
                        </a>
                    </li>
                </ul>
            </div>
        </div>


        <div class="card">
            <div class="card-body">
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link text-secondary" href="/toolkit/data/publications/search">
                            <table>
                                <tr>
                                    <td>
                                        <img src="/toolkit/images/publication.png"  class="card-image"  alt=""/>
                                    </td>
                                    <td class="card-label">
                                        Publications
                                    </td>
                                </tr>
                            </table>
                        </a>
                    </li>
                </ul>
            </div>
        </div>


        <div class="card">
            <div class="card-body">
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link text-secondary" href="/toolkit/data/initiatives">
                            <table>
                                <tr>
                                    <td>
                                        <img src="/toolkit/images/initiative.png"  class="card-image"  alt=""/>
                                    </td>
                                    <td class="card-label">
                                        SCGE&nbsp;Initiatives
                                    </td>
                                </tr>
                            </table>
                        </a>
                    </li>
                </ul>
            </div>
        </div>


        <!-- end studies by initiative card -->
    </div>
</div>
</td></tr></table>
<!--

<div class="row">
    <div class=" col-sm-3">
        <div class="card ">
            <div class="card-header ">
                Quick Links
            </div>
            <div class="card-body">
                <ul class="nav flex-column mb-2">
                <li class="nav-item">
                    <a class="nav-link" href="#">
                        <span data-feather="layers"></span>
                        Point of Contact </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">
                        <span data-feather="file-text"></span>
                        Consortium Groups
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">
                        <span data-feather="file-text"></span>
                        Upload Docs
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">
                        <span data-feather="file-text"></span>
                        Forms
                    </a>
                </li>

                </ul>
            </div>
        </div>
    </div>
    <div class="col-sm-9" style="margin-top:1%">
        <div class="card">
            <div class="card-header ">
                Updates/Upcoming Features ..
            </div>
            <div class="card-body">
                <ul class="nav flex-column mb-2">
                <li class="nav-item">
                    <a class="nav-link" href="#">
                        <span data-feather="layers"></span>
                        Online Data Submission </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">
                        <span data-feather="file-text"></span>
                        Upload Docs
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="#">
                        <span data-feather="file-text"></span>
                        Forms
                    </a>
                </li>

                </ul>
            </div>
        </div>
    </div>
</div>
-->

<script src="https://unpkg.com/feather-icons/dist/feather.min.js"></script>
<script>
    feather.replace()
</script>