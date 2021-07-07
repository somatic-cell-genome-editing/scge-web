<div id="like_button_container"></div>
<h3>Required: <%=g.getChr().replace("chr", "")+":"+g.getStart()+".."+g.getStop()%></h3>
<hr>
<div class="viewer-border">
    <h3>13:32315508..32400268</h3>
    <svg className="viewer" id="viewerActnFly"/>
</div>
<script src="https://unpkg.com/react@17/umd/react.development.js" crossorigin></script>
<script src="https://unpkg.com/react-dom@17/umd/react-dom.development.js" crossorigin></script>

<!-- Load our React component. -->
<!--script src="/toolkit/js/react/like_button.js"></script-->
<script>
 //   var range="13:32315508..32400268";
 //   createCoVExample("NC_045512.2:17894..28259", "SARS-CoV-2", "covidExample1", TRACK_TYPE.ISOFORM, false);

</script>
<link rel="stylesheet" href="/toolkit/js/sequenceViewer/GenomeFeatureViewer.css">

<link href="/toolkit/js/sequenceViewer/GenomeFeatureViewer.css" type="text/css">

<script src="https://d3js.org/d3.v7.min.js"></script>
<script src="/toolkit/js/sequenceViewer/RenderFunctions.js"></script>

<script src="/toolkit/js/sequenceViewer/services/ApolloService.js"></script>
<script src="/toolkit/js/sequenceViewer/services/ConsequenceService.js"></script>
<script src="/toolkit/js/sequenceViewer/services/LegenedService.js"></script>
<script src="/toolkit/js/sequenceViewer/services/TrackService.js"></script>
<script src="/toolkit/js/sequenceViewer/services/VariantService.js"></script>

<script src="/toolkit/js/sequenceViewer/tracks/IsoformAndVariantTrack.js"></script>
<script src="/toolkit/js/sequenceViewer/tracks/IsoformEmbeddedVariantTrack.js"></script>

<script src="/toolkit/js/sequenceViewer/tracks/IsoformTrack.js"></script>

<script src="/toolkit/js/sequenceViewer/tracks/ReferenceTrack.js"></script>

<script src="/toolkit/js/sequenceViewer/tracks/TrackTypeEnum.js"></script>

<script src="/toolkit/js/sequenceViewer/tracks/VariantTrack.js"></script>

<script src="/toolkit/js/sequenceViewer/tracks/VariantTrackGlobal.js"></script>


<script src="/toolkit/js/sequenceViewer/Drawer.js"></script>
<script src="/toolkit/js/sequenceViewer/GenomeFeatureViewer.js"></script>
<script src="/toolkit/js/sequenceViewer/demo/index.js"></script>
