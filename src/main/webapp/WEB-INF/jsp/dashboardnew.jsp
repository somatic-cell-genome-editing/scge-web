<link rel="canonical" href="https://getbootstrap.com/docs/4.1/examples/dashboard/">


<div class="container-fluid">
    <div class="row">
        <nav class="col-md-2 d-none d-md-block bg-light sidebar">
            <div class="sidebar-sticky">
                <ul class="nav flex-column">
                    <!--li class="nav-item">
                        <a class="nav-link active" href="#" onclick="getMainContent('home')">
                            <span data-feather="home"></span>
                            Dashboard <span class="sr-only">(current)</span>
                        </a>
                    </li-->
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <span data-feather="file"></span>
                            My Studies
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/toolkit/data/studies/search">
                            <span data-feather="file"></span>
                            All Studies
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <span data-feather="users"></span>
                            My Group
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <span data-feather="users"></span>
                            Working Groups
                        </a>
                    </li>
                    <!--li class="nav-item">
                        <a class="nav-link" href="#">
                            <span data-feather="bar-chart-2"></span>
                            Reports
                        </a>
                    </li-->
                    <!--li class="nav-item">
                        <a class="nav-link" href="#">
                            <span data-feather="layers"></span>
                            Consortium Groups
                        </a>
                    </li-->
                </ul>

                <h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-1 text-muted">
                    <span>Resources</span>
                    <a class="d-flex align-items-center text-muted" href="#">
                        <span data-feather="plus-circle"></span>
                    </a>
                </h6>
                <!--ul class="nav flex-column mb-2">
                    <li class="nav-item">
                        <a class="nav-link" href="#">
                            <span data-feather="file-text"></span>
                            <%--=s.getStudyId()--%>..
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

                </ul-->
            </div>
        </nav>

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4" id="mainContent">
            <h2>My Submissions</h2>
            <%@include file="dashboardElements/myStudies.jsp"%>
        </main>
    </div>
</div>

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

