<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="edu.mcw.scge.dao.spring.CountQuery" %>
<%@ page import="edu.mcw.scge.dao.implementation.StatsDao" %>
<%@ page import="edu.mcw.scge.storage.ImageCache" %>
<%@ page import="edu.mcw.scge.service.DataAccessService" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<%@ page import="edu.mcw.scge.datamodel.Person" %><%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 5/8/2020
  Time: 2:05 PM
  To change this template use File | Settings | File Templates.
--%>

<% StatsDao sdao = new StatsDao();

    //preload the image cache
   ImageCache ic = ImageCache.getInstance();
    Access access= new Access();
    Person p = access.getUser(request.getSession());
%>
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
    .data-items .card{
        border:0px solid gray;
    }
    .circle-icon {
        background: #34cceb;
        padding:15px;
        border-radius: 50%;
    }


</style>

<div align="center">
<h2>Toolkit Data organization (Click icons to explore)</h2>

<div class="card col-lg-12" style="padding:10px;border:5px solid gainsboro;border-radius: 20px">
    <div class="row ">
        <div class="col-lg-3 data-items">
            <h3>PROJECTS</h3>
            <ul>
                <li style="font-style: italic;list-style-type: none">Initiative based</li>
                <li style="font-style: italic;list-style-type: none">Collaborative</li>
            </ul>
            <div class="card">
                <div class="card-body">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link text-secondary" href="/toolkit/data/search/results/Project?searchTerm=">
                                <table>
                                    <tr>
                                        <td>
                                            <div class="rounded" ><i class="fa-solid fa-diagram-project fa-3x circle-icon" ></i></div>
                                        </td>
                                        <td class="card-label">
                                            Explore All Projects
                                        </td>
                                    </tr>
                                </table>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
            <%
                try {
                    if(DataAccessService.existsTier4COF || access.isAdmin(p) ){%>
            <div class="card">
                <div class="card-body">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link text-secondary" href="/toolkit/data/search/results/Project?searchTerm=&facetSearch=true&unchecked=&selectedFiltersJson=%7B%7D&selectedView=list&initiative=Collaborative+Opportunity+Fund">
                                <table>
                                    <tr>
                                        <td>
                                            <div class="rounded" ><i class="fa-solid fa-users fa-3x circle-icon" ></i></div>
                                        </td>
                                        <td class="card-label">
                                            Explore Collaborative Opportunity Fund Projects
                                        </td>
                                    </tr>
                                </table>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
            <%}
            } catch (Exception e) {
                e.printStackTrace();
            }
            %>
            <%
                try {
                    if(DataAccessService.existsTier4AAV || access.isAdmin(p) ){%>
            <div class="card">
                <div class="card-body">
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link text-secondary" href="/toolkit/data/search/results/Project?searchTerm=&facetSearch=true&unchecked=&selectedFiltersJson=%7B%7D&selectedView=list&initiative=AAV+tropism">
                                <table>
                                    <tr>
                                        <td>
                                            <div class="rounded"><img src="/toolkit/images/experiments.png"  class="card-image"  alt="" style="background-color: transparent"/></div>
                                        </td>
                                        <td class="card-label">
                                            Explore AAV Tropism Projects
                                        </td>
                                    </tr>
                                </table>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
            <%}
            } catch (Exception e) {
                e.printStackTrace();
            }
            %>
        </div>
        <div class="card col-8" style="margin:10px;padding:10px;border:5px solid dodgerblue;border-radius: 20px">
        <div class="row">
            <div class="col-lg-3 data-items">
                <h3>EXPERIMENTS</h3>
                <ul>
                    <li style="font-style: italic;list-style-type: none">In vivo</li>
                    <li style="font-style: italic;list-style-type: none">In vitro</li>
                    <li style="font-style: italic;list-style-type: none">Validation studies</li>
                </ul>
                <div class="card" style="margin-top:40%" >
                    <div class="card-body" >
                        <ul class="nav flex-column">
                            <li class="nav-item">
                                <a class="nav-link text-secondary" href="/toolkit/data/search/results/Experiment?searchTerm=">
                                    <table border="0">
                                        <tr>
                                            <td><img src="/toolkit/images/studies.png" class="card-image" alt=""/></td>
                                            <td class="card-label">
                                                Explore Data
                                            </td>
                                        </tr>
                                    </table>


                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="card col-lg-8" style="margin:10px;padding:10px;border:5px solid crimson;border-radius: 20px">
            <h3>OBJECTS</h3>
                <div class="row">
                    <div class="col-sm-6 data-items">


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

                    </div> <!--close col -->
                    <div class="col-sm-6 data-items" >


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

                        <!-- end studies by initiative card -->
                    </div>
                </div>
            </div>
        </div>
    </div>
    </div>
</div>
</div>
<script src="https://unpkg.com/feather-icons/dist/feather.min.js"></script>
<script>
    feather.replace()
</script>