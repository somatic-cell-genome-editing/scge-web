<div class="container-fluid  jumbotron"  id="home-page-search" style="background-color: #f7f8fa;padding-top: 20px;padding-bottom: 20px">

    <div class="row d-flex justify-content-center" align="center">
        <div style="text-align: center"><h2><img src="/toolkit/images/scge-logo-200w.png" width="150" style="padding-top: 0;margin-top: 0" alt="SCGE"/><span>Somatic Cell Genome Editing (SCGE) Toolkit</span></h2></div>
    </div>

    <div>
        <p class="lead">
            SCGE toolkit serve as the hub to promote the novel strategies and technologies that are funded by NIH Common Fund's Somatic Cell Genome Editing (SCGE) program.
        </p>

            <div>
        <ul>
            <li>Toolkit team work cooperatively with all groups to facilitate their scientific endeavors.</li>
            <li>Build pipelines and processes to collect, integrate, and distribute data through the SCGE Toolkit,</li>
            <li>The data includes ..
                <ul>
                    <li>Intended and unintended biological effects of gene editing</li>
                    <li>Validations using unique preclinical model systems by animal testing centers</li>
                    <li>Published and unpublished data for the community to explore and build upon</li>
                </ul>
            </li>

        </ul>
                <p>The goal of the SCGE program is to accelerate the development of safer and more effective methods to edit the genomes of disease-relevant somatic cells and tissues in patients.</p>
                <c:if test="${action!='About SCGE Toolkit'}"><a href="/toolkit/data/initiatives" title="About SCGE Toolkit"><button class="btn btn-primary btn-sm" style="">Learn more about the SCGE Toolkit</button>&nbsp;</a></c:if><a target="_blank" href="https://scge.mcw.edu/" title="About SCGE Program"><button class="btn btn-primary btn-sm" style="">Learn more about the SCGE Program</button></a>

            </div>



    </div>
</div>
<c:if test="${action!='About SCGE Toolkit'}">
<div class="card" style="overflow-x:auto;border:0px solid white" align="center">


       <h2>Toolkit Data Overview</h2>
        <hr>
    <%@include file="hierarchical-overview.jsp"%>

</div>
</c:if>
