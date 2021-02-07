<%@ page import="edu.mcw.scge.dao.spring.CountQuery" %>
<%@ page import="edu.mcw.scge.dao.implementation.StatsDao" %><%--
  Created by IntelliJ IDEA.
  User: jthota
  Date: 5/8/2020
  Time: 2:05 PM
  To change this template use File | Settings | File Templates.
--%>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
<% StatsDao sdao = new StatsDao(); %>
<style>
    .card-header{
     /*  background-color:#66bced ;

        background:linear-gradient(to bottom, white 0%, #e6f0fc 100%);*/
      /*  background-color: #e6f0fc;
        color:darkslategray;*/
        font-weight: bold;
        border:0;

    }
   .card{
       /* border:0;*/

    }


</style>
<div class="row">
    <div class="col-sm-3">
        <div class="card">
            <div class="card-header" >
                Browse
            </div>
            <div class="card-body">
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link active" href="/toolkit/data/studies/search">
                            <img src="https://scge.mcw.edu/wp-content/uploads/2019/06/Editor-rev.png" width="30" height="30" alt="" />
                            <strong>Studies</strong>&nbsp;<span class="object-count"><%=sdao.getStudyCount()%></span> <span class="sr-only">(current)</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="/toolkit/data/editors/search">
                            <img src="https://scge.mcw.edu/wp-content/uploads/2019/06/Editor-rev.png" width="30" height="30" alt="" />
                            <strong>Genome Editors</strong>&nbsp;<span class="object-count"><%=sdao.getEditorCount()%></span> <span class="sr-only">(current)</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/toolkit/data/models/search">
                            <img src="https://scge.mcw.edu/wp-content/uploads/2019/03/mouse.png" width="30" height="30" alt="" />
                            <strong style="text-align: left">Model&nbsp;Systems</strong>&nbsp; <span class="object-count "><%=sdao.getModelCount()%></span>
                        </a>

                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/toolkit/data/delivery/search">
                            <img src="https://scge.mcw.edu/wp-content/uploads/2019/03/Delivery.png" width="30" height="30" alt="" />
                            <strong>Delivery Vehicles</strong> &nbsp;<span class="object-count"><%=sdao.getDeliveryCount()%></span>                       </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/toolkit/data/guide/search">
                            <img src="https://scge.mcw.edu/wp-content/uploads/2019/06/Editor-rev.png" width="30" height="30" alt="" />
                            <strong>Guides</strong> &nbsp; <span class="object-count"><%=sdao.getGuideCount()%></span>                       </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/toolkit/data/vitro/search">
                            <img src="https://scge.mcw.edu/wp-content/uploads/2019/06/Editor-rev.png" width="30" height="30" alt="" />
                            <strong>Experiment Records</strong>&nbsp;<span class="object-count"><%=sdao.getExperimentCount()%></span>                        </a>
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
    </div>
    <div class="col-sm-6">
        <div class="card">
            <div class="card-header" >
                Submissions
            </div>
            <div class="card-body">

                <canvas class="my-4 w-100" id="myChart" width="900" height="380"></canvas>
            </div>
        </div>
    </div>
    <div class="col-sm-3">
    <div class="card shadow">
        <div class="card-header ">
            Studies by Initiative
        </div>
        <div class="card-body">

            <ul class="nav flex-column mb-2">
                <li class="nav-item">
                    <a class="nav-link" href="/toolkit/data/studies/search?initiative=1">
                        <span data-feather="layers"></span>
                        Rodent Testing Center               </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/toolkit/data/studies/search?initiative=2">
                        <span data-feather="file-text"></span>
                        Large Animal Reporter
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/toolkit/data/studies/search?initiative=3">
                        <span data-feather="file-text"></span>
                        Large Animal Testing Center
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/toolkit/data/studies/search?initiative=4">
                        <span data-feather="file-text"></span>
                        Cell & Tissue Platform
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/toolkit/data/studies/search?initiative=5">
                        <span data-feather="file-text"></span>
                        In Vivo Cell Tracking
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/toolkit/data/studies/search?initiative=6">
                        <span data-feather="file-text"></span>
                        Delivery Vehicle Initiative
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/toolkit/data/studies/search?initiative=7">
                        <span data-feather="file-text"></span>
                        New Editors Initiative
                    </a>
                </li>
            </ul>
        </div>
    </div>
    </div>
</div>
<div class="row">
    <div class=" col-sm-3">
<div class="card " >
    <div class="card-header  " >
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
        <div class="card-header" >
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
          //  labels: ${labels},
            labels:
            ["Biological-Vitro","Editors","LAC","Biological-vivo","LATC","Delivery","SATC"],
            datasets: [{
                label: '# of Submissions',
                data: ${plotData.get("Submissions")},
                backgroundColor: 'rgba(255, 99, 132, 0.2)',
                borderColor: 'rgba(255,99,132,1)',
                borderWidth: 1
            },
                {
                    label: "Tier-1",
                    backgroundColor:  'rgba(54, 162, 235, 0.2)',
                    borderColor: "rgba(54, 162, 235, 1)",
                    borderWidth: 1,
                    data: ${plotData.get("Tier-1")}
                },
                {
                    label: "Tier-2",
                    backgroundColor: "rgba(255, 206, 86, 0.2)",
                    borderColor:  'rgba(255, 206, 86, 1)',
                    borderWidth: 1,
                    data: ${plotData.get("Tier-2")}
                },
                {
                    label: "Tier-3",
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    borderColor:  'rgba(75, 192, 192, 1)',
                    borderWidth: 1,
                    data: ${plotData.get("Tier-3")}
                },
                {
                    label: "Tier-4",
                    backgroundColor:   'rgba(153, 102, 255, 0.2)',
                    borderColor:    'rgba(153, 102, 255, 1)',
                    borderWidth: 1,
                    data: ${plotData.get("Tier-4")}
                }
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