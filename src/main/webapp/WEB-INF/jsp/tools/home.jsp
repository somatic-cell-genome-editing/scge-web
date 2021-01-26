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

<style>
    .borderless tbody tr td {
        padding: 1%;
        vertical-align: top;
    }
   .tools-row{
       margin-top: 2%;
   }
    td{
        font-size: 16px;
        text-align: left;


    }
    .object-count {
        font-size:30px;
        font-weight:700;
    }
    .tool-img{
        max-width: 480px;
    }
    @media screen and (max-width: 480px) {
        img {
            width: 400px;
        }
    }
    .jumbotron{
        /*	background:linear-gradient(to bottom, white 0%, #D6EAF8 100%); */
        background:linear-gradient(to bottom, white 0%, #e6f0fc 100%);
        background-color: #e6f0fc;
    }

</style>
<div class="container-fluid" align="center">
    <!--div class="jumbotron">
        <%--@include file="search.jsp"--%>
    </div-->
<!--table align="center">
    <tr>
        <td align="center"><img src="https://scge.mcw.edu/wp-content/uploads/2019/03/logo-png-1.png" border="0"/></td>
        <td align="center">
            <div class="input-group" >
            <form action="/toolkit/data/search/results"  class="form-inline my-2 my-lg-0">

                <input size=60 class="form-control "  name="searchTerm" type="search" placeholder="Search SCGE (Models, Editors, Delivery, Guides)" aria-label="Search">
                <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>

            </form>
            </div>
            <small class="form-text text-muted">Examples:&nbsp;<a href="/toolkit/data/search/results?searchTerm=Epithelium">Epithelium</a></small>

        </td>
    </tr>
</table-->
</div>
<br>

<% StatsDao sdao = new StatsDao(); %>
<link rel="canonical" href="https://getbootstrap.com/docs/4.1/examples/dashboard/">


<div class="container-fluid">
    <div class="row">
        <nav class="col-md-2 d-none d-md-block bg-light sidebar">
            <div class="sidebar-sticky">
                <ul class="nav flex-column">
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

                <h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-1 text-muted">
                    <span>Resources</span>
                    <a class="d-flex align-items-center text-muted" href="#">
                        <span data-feather="plus-circle"></span>
                    </a>
                </h6>
                <ul class="nav flex-column mb-2">
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <span data-feather="layers"></span>
                            Consortium Groups
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <span data-feather="file-text"></span>
                            Upload Docs..
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <span data-feather="file-text"></span>
                            Submit Data ..
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <span data-feather="file-text"></span>
                            Point of Contacts
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
        </nav>

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4" id="mainContent">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Stats</h1>
            </div>

            <canvas class="my-4 w-100" id="myChart" width="900" height="380"></canvas>

            <h2>Submissions</h2>
            <%@include file="../tools/studies.jsp"%>
        </main>
    </div>
</div>

<!-- Bootstrap core JavaScript
================================================== -->
<!-- Placed at the end of the document so the pages load faster -->
<!--script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script-->
<!--script>window.jQuery || document.write('<script src="../../assets/js/vendor/jquery-slim.min.js"><\/script>')</script>
<script src="../../assets/js/vendor/popper.min.js"></script>
<script src="../../dist/js/bootstrap.min.js"></script-->

<!-- Icons -->
<script src="https://unpkg.com/feather-icons/dist/feather.min.js"></script>
<script>
    feather.replace()
</script>

<!-- Graphs -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.1/Chart.min.js"></script>
<script>
    var ctx = document.getElementById("myChart");
    var myChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ["Delivery", "Editor", "SATC", "LATC", "Biological Effects"],
            datasets: [{
                label: '# of Submissions',
                data: [12, 19, 3, 5, 2],
                backgroundColor: 'rgba(255, 99, 132, 0.2)',
                borderColor: 'rgba(255,99,132,1)',
                borderWidth: 1
            },
                {
                    label: "Tier-1",
                    backgroundColor:  'rgba(54, 162, 235, 0.2)',
                    borderColor: "rgba(54, 162, 235, 1)",
                    borderWidth: 1,
                    data: [6,9,7,3,10]
                },
                {
                    label: "Tier-2",
                    backgroundColor: "rgba(255, 206, 86, 0.2)",
                    borderColor:  'rgba(255, 206, 86, 1)',
                    borderWidth: 1,
                    data: [3,10,7,4,6]
                },
                {
                    label: "Tier-3",
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    borderColor:  'rgba(75, 192, 192, 1)',
                    borderWidth: 1,
                    data: [7,3,10,7,4]
                },
                {
                    label: "Tier-4",
                    backgroundColor:   'rgba(153, 102, 255, 0.2)',
                    borderColor:    'rgba(153, 102, 255, 1)',
                    borderWidth: 1,
                    data: [6,10,7,4,6]
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
    function getMainContent(content){
        var  $contentDiv=$('#mainContent');
        var  $tmp=$contentDiv.html();
        var url;
        url="/toolkit/data/search/studies/"

        $.get(url, function (data, status) {
            $contentDiv.html(data);
        })
    }
</script>


<!--div class="container" style="width: 50%" align="center">
    <div class="row">
        <div class="col">
            <div class="row tools-row">
                <div class="col-sm-3" > <i class="fas fa-arrow-to-right" style="font-size: 50px;color:steelblue"></i></div>
                <div class="col-sm-9" style="text-align: left"> <a href="/toolkit/data/studies/search"><span class="object-count"><%=sdao.getStudyCount()%></span>&nbsp;<strong style="text-align: left">Study Submissions</strong></a></div>
            </div>

        </div>
        <div class="col">
            <div class="row tools-row">
                <div class="col-sm-3" ><img src="https://scge.mcw.edu/wp-content/uploads/2019/06/Editor-rev.png" class="tool-img" alt="" /></div>
                <div class="col-sm-9" style="text-align: left;"><a href="/toolkit/data/editors/search"><span class="object-count"><%=sdao.getEditorCount()%></span>&nbsp;<strong>Genome Editors</strong></a></div>
            </div>
        </div>
    </div>
    <div class="row tools-row" >
        <div class="col">
            <div class="row tools-row">
                <div class="col-sm-3" ><img src="https://scge.mcw.edu/wp-content/uploads/2019/03/mouse.png" class="tool-img" alt="" /></div>
                <div class="col-sm-9" style="text-align: left"><a href="/toolkit/data/models/search"><span class="object-count "><%=sdao.getModelCount()%></span>&nbsp;<strong style="text-align: left">Model&nbsp;Systems</strong></a></div>
            </div>
        </div>
        <div class="col">
            <div class="row tools-row">
                <div class="col-sm-3" ><img src="https://scge.mcw.edu/wp-content/uploads/2019/06/biological-rev.png"  class="tool-img" alt="" /></div>
                <div class="col-sm-9" style="text-align: left"><a  href="/toolkit/data/vitro/search"><span class="object-count"><%=sdao.getExperimentCount()%></span>&nbsp;<strong>Experiment Records</strong></a> </div>
            </div>

        </div>
    </div>
    <div class="row tools-row">
        <div class="col">
            <div class="row tools-row">
                <div class="col-sm-3" ><img src="https://scge.mcw.edu/wp-content/uploads/2019/03/Delivery.png" class="tool-img" alt="" /></div>
                <div class="col-sm-9" style="text-align: left" ><a href="/toolkit/data/delivery/search"><span class="object-count"><%=sdao.getDeliveryCount()%></span>&nbsp;<strong>Delivery Vehicles</strong></a></div>
            </div>

        </div>
        <div class="col">
            <div class="row tools-row">
                <div class="col-sm-3" ><img src="https://scge.mcw.edu/wp-content/uploads/2019/03/Delivery.png" class="tool-img" alt="" /></div>
                <div class="col-sm-9" style="text-align: left"><a href="/toolkit/data/guide/search"><span class="object-count"><%=sdao.getGuideCount()%></span>&nbsp;<strong>Guides</strong></a></div>
            </div>

        </div>
    </div>



</div-->








