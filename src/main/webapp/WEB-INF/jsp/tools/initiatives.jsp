<script>
    $(function () {
        $(".more").hide();
        $(".moreLink").on("click", function(e) {

            var $this = $(this);
            var parent = $this.parent();
            var $content=parent.find(".more");
            var linkText = $this.text();

            if(linkText === "More..."){
                linkText = "Hide...";
                $content.show();
            } else {
                linkText = "More...";
                $content.hide();
            }
            $this.text(linkText);
            return false;

        });
    })
</script>
<style>
    .card-label {
        font-weight: bold;
        border: 0;
        color: #017dc4;
        font-size:22px;
        padding-left:20px;
    }
    .card-image {
        height:85px;
        width:85px;
    }
    .card-body {
        padding: 0.25rem;
    }

    .card {
        margin-bottom:10px;
    }
.initiative-description{
    text-align: left;
}
</style>

<div align="center" id="initiatives"><h2>Somatic Cell Genome Editing (SCGE) Program Initiatives</h2></div>
<hr>
<div class="row justify-content-center" style="text-align: center" align="center">

        <!---   studies by initiative card -->
    <div class="col-sm-2">
        <div class="card h-100 " >
            <div class="card-body" >


                          <img src="/toolkit/images/mouse3.png" class="card-image" alt=""/>
                            <div><h5>Animal Reporting and<br> Testing Centers</h5></div>
                             <div class="initiative-description">
                                 The initiative goal is to create and use new animal (mouse, pig, marmoset and rhesus macaque) reporter models <span class="more"> to accelerate the translation of genome editing technologies into treatments for human diseases. The animal model systems are based on normal, non-diseased animals.</span><a href="#" class="moreLink" title="Click to see more" >More...</a>
                             </div>


            </div>
            <div class="card-footer" style="background-color: transparent">
                <p style="padding-top: 10px"><a  href="/toolkit/data/search/results/Experiment?searchTerm=&facetSearch=true&initiative=Animal+Reporter+and+Testing+Center"><button class="btn btn-sm btn-secondary">View Experiments in Toolkit</button></a></p>
                <p><a  href="https://scge.mcw.edu/animal-reporter-and-testing-centers/"><button class="btn btn-sm btn-secondary">Learn more</button></a></p>

            </div>
        </div>
    </div>

    <div class="col-sm-2">
        <div class="card h-100 ">
            <div class="card-body" >


                            <img src="/toolkit/images/Editor-rev.png"  class="card-image" alt=""/>
                        <div><h5>Genome Editor <br/>Projects</h5></div>
                            <div class="initiative-description">
                                This initiative supports the development of innovative genome editing systems with improved <span class="more"> specificity, efficiency or functionality over currently available systems, including the identification of complexes with novel enzymatic activities and substrate specificities.</span><a href="#" class="moreLink" title="Click to see more" >More...</a>
                            </div>


            </div>
            <div class="card-footer" style="background-color: transparent">
                <p style="padding-top: 10px"><a  href="/toolkit/data/search/results/Experiment?searchTerm=&facetSearch=true&initiative=Genome+Editors"><button class="btn btn-sm btn-secondary">View Experiments in Toolkit</button></a></p>
                <p><a  href="https://scge.mcw.edu/genome-editor-projects/"><button class="btn btn-sm btn-secondary">Learn more</button></a></p>

            </div>
        </div>

    </div>
    <div class="col-sm-2">
        <div class="card h-100 " >
            <div class="card-body">

                            <img src="/toolkit/images/Delivery.png"  class="card-image"  alt=""/>
                        <div><h5>Delivery Systems <br/>Initiative</h5></div>
                            <div class="initiative-description">
                                The initiative goal is to support the development and evaluation of innovative approaches to deliver <span class="more">genome editing machinery into somatic cells, with the ultimate goal of accelerating the development of genome editing therapeutics to treat human disease.  Funded projects are focusing on a wide array of disease-relevant cell types and testing multiple technologies for delivery to these cell types.</span><a href="#" class="moreLink" title="Click to see more" >More...</a>
                            </div>

            </div>
            <div class="card-footer" style="background-color: transparent">
                <p style="padding-top: 10px"><a href="/toolkit/data/search/results/Experiment?searchTerm=&facetSearch=true&initiative=Delivery+Systems"><button class="btn btn-sm btn-secondary">View Experiments in Toolkit</button>
                </a></p><p>
                <a  href="https://scge.mcw.edu/delivery-systems-projects/"><button class="btn btn-sm btn-secondary">Learn more</button></a></p>
            </div>
        </div>

    </div>

    <div class="col-sm-2">
        <div class="card h-100 ">
            <div class="card-body">

                            <img src="/toolkit/images/biological-rev.png"   class="card-image" alt=""/>
                            <div><h5>Biological Effects</h5></div>
                            <div class="initiative-description">
                                <strong>Biological Systems:</strong> The initiative goal is to support the development, validation and testing of new and existing human cell- and tissue-based <span class="more"> platforms that can provide information on the safety of genome editing technologies and delivery systems. These models will be used for preclinical testing of editing, delivery and efficacy.</span><a href="#" class="moreLink" title="Click to see more" >More...</a>
                            </div><div class="initiative-description">
                                <br> <strong>In Vivo Cell Tracking Projects</strong>The objective of the program is to support the development of tools and technologies that will enable longitudinal monitoring and tracking of <span class="more"> genome edited cells in humans to better assess the safety and efficacy of genome editing therapies. This will be accomplished through the development of innovative non-invasive technologies to label and track genome-edited cells in vivo, ideally in a clinically-relevant matter that has the potential to assess long-term safety in genome editing clinical trial participants.</span><a href="#" class="moreLink" title="Click to see more" >More...</a>

                            </div>


            </div>
            <div class="card-footer" style="background-color: transparent">
                <p style="padding-top: 10px"><a href="/toolkit/data/search/results/Experiment?searchTerm=&facetSearch=true&initiative=Biological+Effects"><button class="btn btn-sm btn-secondary">View Experiments in Tookit</button>
                </a></p><p>
                <a  href="https://scge.mcw.edu/biological-effects-projects/"><button class="btn btn-sm btn-secondary">Learn more</button></a>
            </p>
            </div>
        </div>
    </div>
<%--    <div class="col-sm-2">--%>
<%--        <div class="card h-100 ">--%>
<%--            <div class="card-body">--%>

<%--                            <img src="/toolkit/images/biological-rev.png"   class="card-image" alt=""/>&nbsp;--%>
<%--                            <div><h5>Biological Effects <br>(In Vivo Cell Tracking Projects)</h5></div>--%>
<%--                        <div class="initiative-description">The objective of the program is to support the development of tools and technologies that will enable longitudinal monitoring and tracking of <span class="more"> genome edited cells in humans to better assess the safety and efficacy of genome editing therapies. This will be accomplished through the development of innovative non-invasive technologies to label and track genome-edited cells in vivo, ideally in a clinically-relevant matter that has the potential to assess long-term safety in genome editing clinical trial participants.</span><a href="#" class="moreLink" title="Click to see more" >More...</a>--%>
<%--                            </div>--%>

<%--            </div>--%>
<%--            <div class="card-footer" style="background-color: transparent">--%>
<%--                <p style="padding-top: 10px"><a  href="/toolkit/data/search/results/Experiment?searchTerm=&facetSearch=true&initiative=Biological+Effects"><button class="btn btn-sm btn-secondary">View Experiments in Toolkit</button>--%>
<%--                </a></p><p>--%>
<%--                <a  href="https://scge.mcw.edu/biological-effects-projects/"><button class="btn btn-sm btn-secondary">Learn more</button></a>--%>
<%--            </p>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>
        <!-- end studies by initiative card -->
    </div>
<hr>

<div class="container">
    <%@include file="toolkitTeam.jsp"%>

</div>