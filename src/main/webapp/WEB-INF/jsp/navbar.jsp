<nav class="navbar navbar-expand-lg  navbar-custom static-top" style="color: white" >
    <div class="container-fluid">
        <!--a class="navbar-brand"  href="https://scge.mcw.edu/" >
            <img src="https://scge.mcw.edu/wp-content/uploads/2019/03/SCGElogo-50.jpg" srcset="https://scge.mcw.edu/wp-content/uploads/2019/03/SCGElogo-50.jpg 1x" width="72" height="50" alt="Somatic Cell Gene Editing Logo" data-retina_logo_url="" class="fusion-standard-logo" style="background-color: transparent"/>
        </a-->
        <a class="navbar-brand" href="/toolkit/loginSuccess?destination=base" style="font-weight: 400;font-size: 16px">
            <i class="fas fa-tools"></i>&nbsp;Home</a>

        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
            <!--span class="navbar-toggler-icon" ></span-->
            Menu
        </button>
        <div class="collapse navbar-collapse" id="navbarResponsive">

            <ul class="navbar-nav">

                <li class="nav-item  text-nowrap text-responsive Studies" id="Studies">
                    <a class="nav-link" href="/toolkit/data/search/results/Experiment?searchTerm=" >Experiments <span class="sr-only">(current)</span></a>
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

<c:if test="${action==null}">
    <li class="nav-item dropdown text-nowrap">
        <div class="btn-group">
            <button type="button" class="btn btn-primary"><a href="/toolkit/data/initiatives" style="color:#FFFFFF;font-size: 16px">About SCGE</a></button>
        </div>

    </li>
                <li class="nav-item  text-nowrap text-responsive">
                    <a class="nav-link" href="https://scge.mcw.edu/" style="font-weight: 400;font-size: 16px">
                        <i class="fas fa-home"></i>&nbsp;SCGE Consortium Home</a>
                </li>
                <!--li class="nav-item" style="padding-top: 5px"><a href="/toolkit/data/dataSubmission"><button type="button" class="btn btn-sm">Upload Docs</button></a>
                </li-->
</c:if>


            </ul>
        </div>
    </div>
</nav>