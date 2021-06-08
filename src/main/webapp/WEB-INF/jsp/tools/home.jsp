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
    .card-header{
        font-weight: bold;
        border:0;
        color:#017dc4

    }

</style>
<div class="row">
    <div class="col-sm-3">



        <div class="card shadow">
            <div class="card-header ">
                Browse Studies by Initiative
            </div>
            <div class="card-body">

                <ul class="nav flex-column mb-2">
                    <li class="nav-item">
                        <a class="nav-link text-secondary" href="/toolkit/data/studies/search?initiative=7">
                            <span data-feather="layers"></span>
                            Genome Editors
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-secondary" href="/toolkit/data/studies/search?initiative=6">
                            <span data-feather="layers"></span>
                            Delivery Systems Initiative
                        </a>
                    </li>
                    <li class="card-header">Biological Effects</li>
                    <li class="nav-item">
                        <a class="nav-link text-secondary" href="/toolkit/data/studies/search?initiative=4">
                            <span data-feather="layers"></span>
                            Biological Systems
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-secondary" href="/toolkit/data/studies/search?initiative=5">
                            <span data-feather="layers"></span>
                            In Vivo Cell Tracking
                        </a>
                    </li>
                    <li class="card-header ">Animal Reporter and Testing Center</li>
                    <li class="nav-item">
                        <a class="nav-link text-secondary" href="/toolkit/data/studies/search?initiative=1">
                            <span data-feather="layers"></span>
                            Small Animal Testing Centers (SATC)              </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-secondary" href="/toolkit/data/studies/search?initiative=2">
                            <span data-feather="layers"></span>
                            Large Animal Reporter (LAR)
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-secondary" href="/toolkit/data/studies/search?initiative=3">
                            <span data-feather="layers"></span>
                            Large Animal Testing Centers (LATC)
                        </a>
                    </li>
                </ul>
            </div>
        </div>








    </div>
    <div class="col-sm-6">
        <div class="card">
            <div class="card-header" >
                Study Counts by Tier
            </div>
            <div class="card-body">

                <canvas class="my-4 w-100" id="myChart" width="900" height="380"></canvas>
            </div>
        </div>
    </div>
    <div class="col-sm-3">

        <!---   studies by initiative card -->

        <div class="card">
            <div class="card-header" >
                Browse SCGE
            </div>
            <div class="card-body">
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link text-secondary" href="/toolkit/data/studies/search">
                            <img src="/toolkit/images/studyIcon.png" width="30" height="30" alt="" />
                            All Studies&nbsp;<span class="object-count"><%=sdao.getStudyCount()%></span> <span class="sr-only">(current)</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-secondary" href="/toolkit/data/editors/search">
                            <img src="https://scge.mcw.edu/wp-content/uploads/2019/06/Editor-rev.png" width="30" height="30" alt="" />
                            Genome Editors&nbsp;<span class="object-count"><%=sdao.getEditorCount()%></span> <span class="sr-only">(current)</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-secondary" href="/toolkit/data/models/search">
                            <img src="https://scge.mcw.edu/wp-content/uploads/2019/03/mouse.png" width="30" height="30" alt="" />
                            Model&nbsp;Systems&nbsp; <span class="object-count "><%=sdao.getModelCount()%></span>
                        </a>

                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-secondary" href="/toolkit/data/delivery/search">
                            <img src="https://scge.mcw.edu/wp-content/uploads/2019/03/Delivery.png" width="30" height="30" alt="" />
                            Delivery Systems &nbsp;<span class="object-count"><%=sdao.getDeliveryCount()%></span>                       </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-secondary" href="/toolkit/data/guide/search">
                            <img src="/toolkit/images/guideIcon.png" width="30" height="30" alt="" />
                            Guides &nbsp; <span class="object-count"><%=sdao.getGuideCount()%></span>                       </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-secondary" href="/toolkit/data/vector/search">
                            <img src="/toolkit/images/guideIcon.png" width="30" height="30" alt="" />
                            Vectors &nbsp; <span class="object-count"><%=sdao.getVectorCount()%></span>                       </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-secondary" href="/toolkit/data/experiments/search">
                            <img src="/toolkit/images/experimentIcon.png" width="30" height="30" alt="" />
                            Experiments&nbsp;<span class="object-count"><%=sdao.getExperimentCount()%></span>                        </a>
                    </li>


                    <!--li class="nav-item">
                        <a class="nav-link" href="#">
                            <span data-feather="bar-chart-2"></span>
                            Reports
                        </a>
                    </li-->

                </ul>

            </div>
        </div>




        <!-- end studies by initiative card -->
    </div>
</div>
<div class="row">
    <div class=" col-sm-3">
<div class="card " >
    <div class="card-header " >
        Quick Links
    </div>
    <div class="card-body">
        <!--ul class="nav flex-column mb-2">
            <li class="nav-item">
                <a class="nav-link" href="#">
                    <span data-feather="layers"></span>
                    Point of Contact                </a>
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

        </ul-->
    </div>
</div>
    </div>
    <div class="col-sm-9" style="margin-top:1%">
    <div class="card" >
        <div class="card-header " >
            Updates/Upcoming Features ..
        </div>
        <div class="card-body">
            <!--ul class="nav flex-column mb-2">
                <li class="nav-item">
                    <a class="nav-link" href="#">
                        <span data-feather="layers"></span>
                       Online Data Submission               </a>
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

            </ul-->
        </div>
    </div>
    </div>
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.1/Chart.min.js"></script>

<script>
    var ctx = document.getElementById("myChart");
    var myChart = new Chart(ctx, {
        type: 'bar',
        data: {
           labels: ${labels},
         /*   labels:
            ["Biological Systems","Genome Editors","LAR","in vivo Cell Tracking"
                ,"LATC","Delivery Systems","SATC"],*/
            datasets: [
                <c:set var="first" value="true"/>
                <c:set var="color" value="0"/>
                <c:forEach items="${plotData}" var="p">
                <c:choose>
                <c:when test="${first=='true'}">
                {
                    label: '# ${p.key}',
                    data: ${p.value},
                    backgroundColor: 'rgba(255, 99, 132, 0.2)',
                    borderColor: 'rgba(255,99,132,1)',
                    borderWidth: 1
                }
                <c:set var="first" value="false"/>
                <c:set var="color" value="${color+20}"/>
                </c:when>
                <c:otherwise >
                ,{
                    label: '${p.key}',
                    data: ${p.value},
                    <c:if test="${p.key=='Tier-3'}" >
                    backgroundColor:   'rgba(153, 102, 255, 0.2)',
                    borderColor:    'rgba(153, 102, 255, 1)',
                    </c:if>
                    <c:if test="${p.key=='Tier-1'}" >
                    backgroundColor:  'rgba(54, 162, 235, 0.2)',
                    borderColor: "rgba(54, 162, 235, 1)",
                    </c:if>
                    <c:if test="${p.key=='Tier-2'}" >
                    backgroundColor: "rgba(255, 206, 86, 0.2)",
                    borderColor:  'rgba(255, 206, 86, 1)',
                    </c:if>
                    <c:if test="${p.key=='Tier-4'}" >
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    borderColor:  'rgba(75, 192, 192, 1)',
                    </c:if>
                    borderWidth: 1
                }
                <c:set var="color" value="${color+25}"/>
                </c:otherwise>
                </c:choose>
                </c:forEach>
            ]
        },
        options: {
            responsive: false,
            scales: {
                xAxes: [{

                    gridLines: {
                        offsetGridLines: true // à rajouter
                    }
                },
                ],
                yAxes: [{
                    ticks: {
                        beginAtZero: true
                    }
                }]
            }
        }
    });
</script>

<script src="https://unpkg.com/feather-icons/dist/feather.min.js"></script>
<script>
    feather.replace()
</script>