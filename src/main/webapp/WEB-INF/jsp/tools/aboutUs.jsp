<c:if test="${(action!=null && action=='') || action==null}">
<div class="container-fluid  jumbotron"  id="home-page-search" style="background-color: #f7f8fa;padding-top: 20px;padding-bottom: 20px">

    <div class="row d-flex justify-content-center" align="center">
        <div style="text-align: center"><h2><img src="/toolkit/images/scge-logo-200w.png" width="150" style="padding-top: 0;margin-top: 0" alt="SCGE"/><span>Somatic Cell Genome Editing (SCGE) Toolkit</span></h2></div>
    </div>

    <div>
        <p class="lead">
            Somatic Cell Genome Editing (SCGE) toolkit serve as the hub to promote the novel strategies and technologies that are funded by NIH Common Fund's Somatic Cell Genome Editing (SCGE) program. The goal of the SCGE program is to accelerate the development of safer and more effective methods to edit the genomes of disease-relevant somatic cells and tissues in patients.
        </p>
        <hr class="my-4">
        <p>The Toolkit team works cooperatively with funded groups to facilitate their scientific endeavors by building pipelines and processes to collect, integrate, visualize, and distribute data, including </p>
            <div>
                <ul>
                    <li>Intended and unintended biological effects of gene editing in vivo and in vitro using a variety of genome editors, guides, novel delivery systems, and model systems</li>
                    <li>Independent validation studies by animal testing centers of novel delivery systems using unique preclinical animal models.  </li>
                    <li>Published and unpublished data for the community to explore and build upon.</li>
                </ul>
                <c:if test="${(action!=null && action!='About SCGE Toolkit') || action==null}"><a href="/toolkit/data/initiatives" title="About SCGE Toolkit"><button class="btn btn-primary btn-sm" style="">Learn more about the SCGE Toolkit</button>&nbsp;</a></c:if><a target="_blank" href="https://scge.mcw.edu/" title="About SCGE Program"><button class="btn btn-primary btn-sm" style="">Learn more about the SCGE Program</button></a>

            </div>
    </div>

</div>
</c:if>
<c:if test="${action!=null && action=='About SCGE Toolkit'}">
    <div class="container-fluid  jumbotron"  id="home-page-search" style="background-color: #f7f8fa;padding-top: 20px;padding-bottom: 20px">
        <div class="row">
            <div class="col-lg-8">
                <p>The <a href="https://commonfund.nih.gov/editing" target="_blank" title="Somatic Cell Genome Editing | NIH Common Fund">Somatic Cell Gene Editing (SCGE)</a> Consortium is supported by the NIH Common Fund through cooperative agreements by multiple National Institutes of Health (NIH) institutes to advance genome editing technologies to the clinic. In addition to five additional scientific initiatives (<a href="#initiatives">below</a>), the SCGE Dissemination and Coordinating Center (DCC) was funded (U24HG010423) to facilitate consortium interactions and scientific exchange and to <a href="https://grants.nih.gov/grants/guide/rfa-files/RFA-RM-18-018.html" target="_blank">collect and disseminate</a> consortium generated data through the SCGE Toolkit to the broader biomedical research community.  </p>
                <hr class="my-4">
                <p>The <a href="#toolkitTeam">Toolkit team</a> collects data and metadata from funded consortium laboratories, reviews, curates and standardizes data for loading into the Toolkit, works with the submitting laboratory and NIH program staff to certify data loading, and then makes data publicly accessible.  </p>
            </div>
            <div class="col">
                <img src="/toolkit/images/toolkit_overview.png" alt="Toolkit Overview"/>
            </div>
        </div>
    </div>
    <div class="card" style="overflow-x:auto;border:0px solid white;padding-top: 2%" align="center">
        <h2>Toolkit Data Processing Pipeline</h2>
        <hr>
    <div class="container" style="text-align: center">
        <img src="/toolkit/images/toolkit_processing.png" alt="Toolkit Data Processing Pipeline" width="70%"/>
    <%--@include file="hierarchical-overview.jsp"--%>
    </div>
</div>
</c:if>
