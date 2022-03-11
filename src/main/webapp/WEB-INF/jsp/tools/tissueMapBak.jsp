<%@ page import="java.util.TreeSet" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="io.netty.util.internal.StringUtil" %>
<%@ page import="edu.mcw.scge.web.TissueMapper" %>
<style>
    .tissue-control {
        position: relative;
    }
    .tissue-control-header-first {
        transform: rotate(-45deg);
        float: left;
        width:200px;
        margin-left:7px;
        margin-bottom:15px;
        order:1px solid black;
        text-align: left;
        font-size:18px;
    }
    .tissue-control-header {
        transform: rotate(-45deg);
        float: left;
        width:198px;
        margin-left:-155px;
        margin-bottom:15px;
        order:1px solid black;
        text-align: left;
        font-size:18px;
    }
    .tissue-control-cell {
        border: 1px solid black;
        loat:left;
        background-color:#F7F7F7;
        width:40px;
        height:40px;
        position:relative;
    }
    .triangle-topleft {
        position:absolute;
        top:0px;
        left:0px;
        width: 0;
        height: 0;
        border-top: 40px solid blue;
        border-right: 40px solid transparent;
        cursor:pointer;
    }
    .triangle-bottomright {
        position:absolute;
        top:0px;
        left:0px;
        width: 0;
        height: 0;
        border-bottom: 40px solid orange;
        border-left: 40px solid transparent;
    }
</style>
<script>
    $(function() {
        $("#grid").tablesorter({
            theme: 'blue',
            widgets: ['zebra', 'resizable', 'stickyHeaders'],
        });
    });
</script>
<%
    TissueMapper tm = new TissueMapper();

    ImageDao idao = new ImageDao();

    LinkedHashMap<String,String> rootTissues = new LinkedHashMap<String,String>();
    rootTissues.put("Reproductive", "UBERON:0000990");
    rootTissues.put("Renal/Urinary", "UBERON:0001008");
    rootTissues.put("Endocrine","UBERON:0000949");
    rootTissues.put("Haemolymphoid","UBERON:0002193");
    rootTissues.put("Gastrointestinal","UBERON:0005409");
    rootTissues.put("Liver and Biliary","UBERON:0002423");
    rootTissues.put("Respiratory","UBERON:0001004");
    rootTissues.put("Cardiovascular","UBERON:0004535");
    rootTissues.put("Musculoskeletal","UBERON:0002204");
    rootTissues.put("Integumentary","UBERON:0002416");
    rootTissues.put("Nervous","UBERON:0001016");
    rootTissues.put("Sensory","UBERON:0001032");
    rootTissues.put("Hematopoietic","UBERON:0002390");
%>

    <%
        LinkedHashMap<String, Boolean> tissueEditingMap = new LinkedHashMap<String, Boolean>();
        LinkedHashMap<String, Boolean> tissueDeliveryMap = new LinkedHashMap<String, Boolean>();
        LinkedHashMap<String,Set<Double>> tissueEditingResults = new LinkedHashMap<>();
        LinkedHashMap<String,Set<Double>> tissueDeliveryResults = new LinkedHashMap<>();
        LinkedHashMap<String,Set<String>> tissueDeliveryConditions = new LinkedHashMap<>();
        LinkedHashMap<String,Set<String>> tissueEditingConditions = new LinkedHashMap<>();
        LinkedHashMap<String,List<ExperimentResultDetail>> qualEditingResults = new LinkedHashMap<>();
        LinkedHashMap<String,List<ExperimentResultDetail>> qualDeliveryResults = new LinkedHashMap<>();
        LinkedHashMap<String,ExperimentRecord> experimentRecordHashMap = new LinkedHashMap<>();
        List<String> uniqueObjects = new ArrayList<>();
        Set<Double> resultDetails = new TreeSet<>();
        Set<String> labelDetails = new TreeSet<>();
        LinkedHashMap<String,String> tissueNames = new LinkedHashMap<>();
        Map<String, Long> tissueNameNIdMap=new HashMap<>();
        LinkedHashMap<String,String> tissueLabels = new LinkedHashMap<>();
        List<ExperimentResultDetail> qualResults = new ArrayList<>();

        LinkedHashMap<String, LinkedHashMap<String,String>> organs = new LinkedHashMap<>();

        List<Set<String>> deliveryConditions = new ArrayList<>();
        List<Set<String>> editingConditions = new ArrayList<>();
        List<String> deliveryNames = new ArrayList<>();
        List<String> editingNames = new ArrayList<>();
        List<Set<Double>> deliveryResults = new ArrayList<>();
        List<Set<Double>> editingResults = new ArrayList<>();

        int noOfRecords = experimentRecords.size();
        int noOfEditors = 0;
        int noOfDelivery = 0;
        int noOfModel = 0;
        if(editorList != null && editorList.size() == 1)
            uniqueObjects.add(editorList.get(0));
        if(deliverySystemList != null && deliverySystemList.size() == 1)
            uniqueObjects.add(deliverySystemList.get(0));
        if(modelList != null && modelList.size() == 1)
            uniqueObjects.add(modelList.get(0));
        if(guideList != null  && guideList.size() == 1 && !guideMap.values().contains(null))
            uniqueObjects.add(guideList.get(0));
        if(vectorList != null && vectorList.size() == 1 && vectorMap.values().contains(null))
            uniqueObjects.add(vectorList.get(0));
        Set<String> targetTissues=new HashSet<>();
        Set<Long> targetTissueRecordIds=new HashSet<>();

        for (Long resultId: resultDetail.keySet()) {
            List<ExperimentResultDetail> erdList = resultDetail.get(resultId);
            long expRecordId = erdList.get(0).getExperimentRecordId();
            ExperimentRecord er = experimentRecordsMap.get(expRecordId);
            if(er.getIsTargetTissue()==1){
                targetTissues.add(er.getOrganSystemID());
                targetTissueRecordIds.add(er.getExperimentRecordId());
            }
            experimentRecordHashMap.put(er.getExperimentName(), er);
            String labelTrimmed = new String();


            if (er.getCellTypeTerm() != null && er.getTissueTerm() != null)
                labelTrimmed = er.getCondition().toString().replace(er.getTissueTerm(), "").replace(er.getCellTypeTerm(), "").trim();
            else if (er.getTissueTerm() != null)
                labelTrimmed = er.getCondition().toString().replace(er.getTissueTerm(), "").trim();
            else labelTrimmed = er.getCondition().toString().trim();


            if (uniqueObjects.contains(er.getEditorSymbol()))
                noOfEditors++;
            if (uniqueObjects.contains(er.getDeliverySystemType()))
                noOfDelivery++;
            if (uniqueObjects.contains(er.getModelName()))
                noOfModel++;

            String tissue = "unknown";
            String organSystemID = er.getOrganSystemID();
            String organSystem = "unknown";
            for (String rootTissue : rootTissues.keySet()) {
                if (organSystemID.equals(rootTissues.get(rootTissue))) {
                    //System.out.println("found a tissue");
                    tissue = rootTissues.get(rootTissue);
                    organSystem = rootTissue;
                    break;
                }
            }



            String tissueTerm = er.getTissueTerm();
            String cellType = er.getCellTypeTerm();



            if (cellType != null) {
                tm.addChild(organSystem, tissueTerm + ":" + cellType,null);
            }else {
                tm.addChild(organSystem, tissueTerm, null);
            }


            String tissueName = "\"" + organSystem + ">" + tissueTerm + ">";
            if (cellType != null && !cellType.equals(""))
                tissueName += cellType + "\"";
            else tissueName += "\"";
            tissueNames.put(tissueName, er.getTissueTerm() + "," + er.getCellTypeTerm());
            tissueNameNIdMap.put(tissueName, er.getExperimentRecordId());
            String tissueLabel = organSystem + "<br><br>" + tissueTerm + "<br><br>";
            if (cellType != null && !cellType.equals(""))
                tissueLabel += cellType;
            tissueLabels.put(tissueName, tissueLabel);


            for (ExperimentResultDetail erd : erdList) {
                if (erd.getResultType().equals("Delivery Efficiency")) {
                    tissueDeliveryMap.put(tissue + "-" + labelTrimmed, true);


                    if (tissueDeliveryResults == null || !tissueDeliveryResults.containsKey(tissueName))
                        resultDetails = new TreeSet<>();
                    else resultDetails = tissueDeliveryResults.get(tissueName);
                    if (erd.getReplicate() == 0 && !erd.getUnits().equalsIgnoreCase("signal")) {
                        resultDetails.add(Double.valueOf(erd.getResult()));
                        tissueDeliveryResults.put(tissueName, resultDetails);

                        if (tissueDeliveryConditions == null || !tissueDeliveryConditions.containsKey(tissueName))
                            labelDetails = new TreeSet<>();
                        else labelDetails = tissueDeliveryConditions.get(tissueName);
                        labelDetails.add("\"" + er.getExperimentName() + "\"");
                        tissueDeliveryConditions.put(tissueName, labelDetails);
                    }
                    if(erd.getUnits().contains("signal") && erd.getReplicate() == 0){
                        if (qualDeliveryResults == null || !qualDeliveryResults.containsKey(tissueName))
                            qualResults = new ArrayList<>();
                        else qualResults = qualDeliveryResults.get(tissueName);
                        qualResults.add(erd);
                        qualDeliveryResults.put(tissueName, qualResults);
                    }
                }
                if (erd.getResultType().equals("Editing Efficiency")) {
                    tissueEditingMap.put(tissue + "-" + labelTrimmed, true);

                    if(tissueEditingResults == null || !tissueEditingResults.containsKey(tissueName))
                        resultDetails = new TreeSet<>();
                    else  resultDetails = tissueEditingResults.get(tissueName);
                    if (erd.getReplicate() == 0 && !erd.getUnits().equalsIgnoreCase("signal")) {
                        resultDetails.add(Double.valueOf(erd.getResult()));
                        tissueEditingResults.put(tissueName, resultDetails);

                        if(tissueEditingConditions == null || !tissueEditingConditions.containsKey(tissueName))
                            labelDetails = new TreeSet<>();
                        else  labelDetails = tissueEditingConditions.get(tissueName);
                        labelDetails.add("\""+er.getExperimentName()+"\"");
                        tissueEditingConditions.put(tissueName,labelDetails);
                    }
                    if(erd.getUnits().contains("signal") && erd.getReplicate() == 0){
                        if (qualEditingResults == null || !qualEditingResults.containsKey(tissueName))
                            qualResults = new ArrayList<>();
                        else qualResults = qualEditingResults.get(tissueName);
                        qualResults.add(erd);
                        qualEditingResults.put(tissueName, qualResults);
                    }
                }
            }
        }

    %>






<h6 style="color:#1A80B6;">Organ System Overview</h6>
<br><br>
<div>
    <table align="center">
        <tr>
            <td>
                <table >
                    <tr>
                        <td width="40">&nbsp;</td>
                        <td>

                            <%
                                boolean first = true;
                                //for (String tissue: tissues) {
                                for (String tissue: rootTissues.keySet()) {
                                    String tissueTerm=rootTissues.get(tissue);
                            %>
                            <% if (first) { if(targetTissues.contains(tissueTerm)){ %>
                            <div class="tissue-control-header-first" style="color:orchid"><a href="#<%=tissue%>"><%=tissue%></a></div>
                           <%}else{%>
                            <div class="tissue-control-header-first"><a href="#<%=tissue%>"><%=tissue%></a></div>
                            <%}%>
                            <% first = false; %>
                            <% } else { if(targetTissues.contains(tissueTerm)) {%>
                            <div class="tissue-control-header" style="color:orchid"><a href="#<%=tissue%>"><%=tissue%></a></div>

                            <%}else{%>
                            <div class="tissue-control-header"><a href="#<%=tissue%>"><%=tissue%></a></div>
                            <% }} %>
                            <%  } %>
                        </td>
                    </tr>
                </table>

            </td>
        </tr>
        <tr>
            <td>
                <table style="margin-top:50px;">

                    <% for (String condition: conditions) { %>
                    <tr>
                        <td  width="65"></td>

                        <% for (String tissueKey: rootTissues.keySet()) {
                            String tissue=rootTissues.get(tissueKey);
                            if(targetTissues.contains(tissue)){%>
                        <td width="40" style="border:5px solid orchid">
                            <div class="tissue-control-cell">
                                <% if (tissueDeliveryMap.containsKey(tissue + "-" + condition)) { %>
                                <div class="triangle-topleft" ></div>
                                <% } %>
                                <% if (tissueEditingMap.containsKey(tissue + "-" + condition)) { %>
                                <div class="triangle-bottomright"></div>
                                <% } %>
                            </div>
                        </td>
                          <%}else{%>
                        <td width="40">
                            <div class="tissue-control-cell">
                                <% if (tissueDeliveryMap.containsKey(tissue + "-" + condition)) { %>
                                <div class="triangle-topleft" ></div>
                                <% } %>
                                <% if (tissueEditingMap.containsKey(tissue + "-" + condition)) { %>
                                <div class="triangle-bottomright"></div>
                                <% } %>
                            </div>
                        </td>
                        <% } }%>
                        <td style="font-size: small">

                            <%=condition%>
                        </td>
                    </tr>
                    <% } // end conditions %>
                </table>

            </td>
        </tr>
    </table>




</div>




<hr>


<table border="0" align="center" style="border:1px solid #F7F7F7;">
    <tr>
        <td colspan="5" style="font-size:12px;">Analyze Data Sets Available for this Experiment</td>
    </tr>
    <% for (String organ: tm.getChildTerms().keySet()) {  %>
    <tr>
        <td colspan="2" style="font-size:20px;" id="<%=organ%>"><%=organ%></td><td></td><td></td><td></td>
    </tr>
    <tr>

            <% for (String childTerm: tm.getChildTerms().get(organ).keySet()) { %>
    <tr><td width="100" >&nbsp;</td><td style="border-bottom:1px solid black;border-color:#770C0E; font-size:14px;"><%=childTerm%></td><td></td><td><a href="">View Editing Data</a></td><td>&nbsp;</td><td><a href="">View Delivery Data</a></td></tr>
    <% } %>
    <% } %>
    </tr>
    </td>
    </tr>
</table>




<%if (access.isAdmin(p)) {%>
<div align="right">
    <form id="updateTargetTissueForm" action="/toolkit/data/experiments/update/experiment/<%=ex.getExperimentId()%>">
        <input type="hidden" name="experimentRecordIds" id= "experimentRecordIds" value=""/>
        <button class="btn btn-primary btn-sm" onclick="updateTargetTissue()">Update Target Tissue</button>
    </form>
</div>
<% } %>




Browse Datasets from this Experiment
<table  align="center" style="padding-left:20px;" border="1" cellpadding="6">
    <thead>
    <th style="background-color:#F7F7F7; color:#212528; font-size:18px;">Organ System</th>
    <th style="background-color:#F7F7F7; color:#212528; font-size:18px;">Delivery</th>
    <th style="background-color:#F7F7F7; color:#212528; font-size:18px;">Editing</th>
    </thead>
    <% int i2 = 0,j2=0;
        int rowCount2=1;
        for (String tissueName2: tissueNames.keySet()) {
            String term2 = tissueNames.get(tissueName2);
            long experimentRecordId2=tissueNameNIdMap.get(tissueName2);
            String[] terms2 = term2.split(",");
            String deliveryurl2 = "/toolkit/data/experiments/experiment/"+ex.getExperimentId()+"?resultType=Delivery&tissue="+terms2[0]+"&cellType=";
            String editingurl2 = "/toolkit/data/experiments/experiment/"+ex.getExperimentId()+"?resultType=Editing&tissue="+terms2[0]+"&cellType=";
            if(terms2.length == 2) {
                deliveryurl2 += terms2[1];
                editingurl2 += terms2[1];
            }

    %>
    <tr>

        <td>
            <%if (access.isAdmin(p)) {
                if(targetTissueRecordIds.contains(experimentRecordId2)){%>
            <input type="checkbox" name="targetTissue" value="<%=experimentRecordId2%>" checked>

                <%}else{%>
            <input type="checkbox" name="targetTissue" value="<%=experimentRecordId2%>">

                <%}%>

            <% } %>

            <%if(targetTissueRecordIds!=null && targetTissueRecordIds.contains(experimentRecordId2)){%>
                <span style="color: orchid;font-weight: bold;font-size:16px"><%=tissueLabels.get(tissueName2).replaceAll("\\s", "&nbsp;")%></span>
            <%}else{%>
                <span style="font-size:16px; font-weight:700;"><%=tissueLabels.get(tissueName2).replaceAll("\\s", "&nbsp;")%></span>
            <%}%>

        </td>
        <td >
            <% if (tissueDeliveryConditions.containsKey(tissueName2)) {
                deliveryConditions.add(tissueDeliveryConditions.get(tissueName2));
                deliveryResults.add(tissueDeliveryResults.get(tissueName2));
                deliveryNames.add(tissueName2);
            %>
            <a href= "<%=deliveryurl2%>">
                Delivery</a>
            <% } %>

        </td>
        <td >
            <% if (tissueEditingConditions.containsKey(tissueName2)) {
                editingConditions.add(tissueEditingConditions.get(tissueName2));
                editingResults.add(tissueEditingResults.get(tissueName2));
                editingNames.add(tissueName2);
            %>
            <a href= "<%=editingurl2%>">
                Editing
            </a>
            <% } %>
        </td>
    </tr>
<% } %>
</table>











<hr>

<div id="imageViewer" style="visibility:hidden; border: 1px double black; width:704px;position:fixed;top:15px; left:15px;z-index:1000;background-color:white;"></div>

<%if (access.isAdmin(p)) {%>
<div align="right">
    <form id="updateTargetTissueForm" action="/toolkit/data/experiments/update/experiment/<%=ex.getExperimentId()%>">
        <input type="hidden" name="experimentRecordIds" id= "experimentRecordIds" value=""/>
        <button class="btn btn-primary btn-sm" onclick="updateTargetTissue()">Update Target Tissue</button>
    </form>
</div>
<% } %>
<div style="font-size:20px; color: #1A80B6;">Select a graph below to explore the data set</div>
    <table d="grid" class="table" style="padding-left:20px;table-layout:fixed" align="center" border="1" cellpadding="6">
        <thead>
        <th style="background-color:#F7F7F7; color:#212528; font-size:18px;">Organ System</th>
        <th style="background-color:#F7F7F7; color:#212528; font-size:18px;">Delivery</th>
        <th style="background-color:#F7F7F7; color:#212528; font-size:18px;">Editing</th>
        </thead>
    <% int i = 0,j=0;
        int rowCount=1;
        for (String tissueName: tissueNames.keySet()) {
            String term = tissueNames.get(tissueName);
            long experimentRecordId=tissueNameNIdMap.get(tissueName);
            String[] terms = term.split(",");
            String deliveryurl = "/toolkit/data/experiments/experiment/"+ex.getExperimentId()+"?resultType=Delivery&tissue="+terms[0]+"&cellType=";
            String editingurl = "/toolkit/data/experiments/experiment/"+ex.getExperimentId()+"?resultType=Editing&tissue="+terms[0]+"&cellType=";
            if(terms.length == 2) {
                deliveryurl += terms[1];
                editingurl += terms[1];
            }

    %>
    <tr>

        <td>
            <%if (access.isAdmin(p)) {
                if(targetTissueRecordIds.contains(experimentRecordId)){%>
            <input type="checkbox" name="targetTissue" value="<%=experimentRecordId%>" checked>

            <%}else{%>
            <input type="checkbox" name="targetTissue" value="<%=experimentRecordId%>">

            <%}%>

            <% } %>
            <%if(targetTissueRecordIds!=null && targetTissueRecordIds.contains(experimentRecordId)){%>
               <span style="color: orchid;font-weight: bold;font-size:16px"><%=tissueLabels.get(tissueName).replaceAll("\\s", "&nbsp;")%></span>
            <%}else{%>

       <span style="font-size:16px; font-weight:700;"><%=tissueLabels.get(tissueName).replaceAll("\\s", "&nbsp;")%></span>
        <%}%>
        </td>
        <td >
            <% if (tissueDeliveryConditions.containsKey(tissueName)) {
                    deliveryConditions.add(tissueDeliveryConditions.get(tissueName));
                deliveryResults.add(tissueDeliveryResults.get(tissueName));
                deliveryNames.add(tissueName);
            %>
            <a href= "<%=deliveryurl%>">
            <div class="chart-container">
                <canvas id="canvasDelivery<%=i%>"></canvas>
            </div></a>
            <%  i++;} else if(qualDeliveryResults.containsKey(tissueName)) { %>
            <a href= "<%=deliveryurl%>">
            <div>
                <table class="table tablesorter table-striped" cellpadding="4">
                    <thead><tr>
                        <th>Condition</th>
                        <th>Result</th>
                        <th></th>
                    </tr></thead>
                    <tbody>

             <%  for(ExperimentResultDetail e: qualDeliveryResults.get(tissueName) ) { %>
                <tr>
                    <%
                        List<Image> images = idao.getImage(e.getExperimentRecordId(),"main1");
                        if (images.size() > 0) {
                    %>
                    <td><img onmouseover="imageMouseOver(this,'<%=StringUtils.encode(images.get(0).getLegend())%>','<%=images.get(0).getTitle()%>')" onmouseout="imageMouseOut(this)" id="img<%=rowCount%>" src="<%=images.get(0).getPath()%>" height="1" width="1" /></td>
                    <% }else { %>
                    <td><%=e.getExperimentConditionName()%></td>
                    <%}%>

                    <td><%=e.getResult()%></td>
                    <%
                        images = idao.getImage(e.getExperimentRecordId(),"main1");
                        if (images.size() > 0) {
                    %>
                    <td><img onmouseover="imageMouseOver(this,'<%=StringUtils.encode(images.get(0).getLegend())%>','<%=images.get(0).getTitle()%>')" onmouseout="imageMouseOut(this)" id="img<%=rowCount%>" src="<%=images.get(0).getPath()%>" height="1" width="1" /></td>
                    <% rowCount++;
                    }else { %>
                    <td></td>
                    <%}%>
                </tr>
             <% } %>
                </tbody>
                </table>
                </div></a>
            <%  } else %> <b>NO DATA</b>
        </td>
        <td >
            <% if (tissueEditingConditions.containsKey(tissueName)) {
                editingConditions.add(tissueEditingConditions.get(tissueName));
                editingResults.add(tissueEditingResults.get(tissueName));
                editingNames.add(tissueName);
            %>
            <a href= "<%=editingurl%>">
            <div class="chart-container">
                <canvas id="canvasEditing<%=j%>"></canvas>
            </div>
            </a>
            <%   j++;} else if(qualEditingResults.containsKey(tissueName)) { %>
            <a href= "<%=editingurl%>">
            <div>
                <table class="table tablesorter table-striped" cellpadding="4">
                    <thead><tr>
                        <th>Condition</th>
                        <th>Result</th>
                        <th></th>
                    </tr></thead>
                    <tbody>

                    <%  for(ExperimentResultDetail e: qualEditingResults.get(tissueName) ) { %>
                    <tr>
                        <%
                            List<Image> images = idao.getImage(e.getExperimentRecordId(),"main1");
                            if (images.size() > 0) {
                        %>
                        <td><img onmouseover="imageMouseOver(this,'<%=StringUtils.encode(images.get(0).getLegend())%>','<%=images.get(0).getTitle()%>')" onmouseout="imageMouseOut(this)" id="img<%=rowCount%>" src="<%=images.get(0).getPath()%>" height="1" width="1" /></td>
                        <% }else { %>
                            <td><%=e.getExperimentConditionName()%></td>
                        <%}%>

                        <td><%=e.getResult()%></td>
                        <%
                            images = idao.getImage(e.getExperimentRecordId(),"main1");
                            if (images.size() > 0) {
                        %>
                        <td><img onmouseover="imageMouseOver(this,'<%=StringUtils.encode(images.get(0).getLegend())%>','<%=images.get(0).getTitle()%>')" onmouseout="imageMouseOut(this)" id="img<%=rowCount%>" src="<%=images.get(0).getPath()%>" height="1" width="1" /></td>
                        <% rowCount++;
                        }else { %>
                        <td></td>
                        <%}%>

                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div></a>
            <%  } else %> <b>NO DATA</b>
        </td>
    </tr>
<%}%>
</table>

<script>
    function resizeImages() {
        var count=1;
        while(true) {
            var img = document.getElementById("img" + count);
            if (img) {
                //get the height to 60
                var goal=75;
                var height = img.naturalHeight;
                var diff = height - goal;
                var percentDiff = 1 - (diff / height);
                img.height=goal;
                img.width=parseInt(img.naturalWidth * percentDiff);

            }else {
                break;
            }
            count++;
        }

    }

    function imageMouseOver(img, legend, title) {
        var sourceImage = document.createElement('img'),
            imgContainer = document.getElementById("imageViewer");
        sourceImage.src = img.src;
        //resizeThis(sourceImage);

        if (title != "") {
            imgContainer.innerHTML = "<div style='padding:8px;font-weight:700;font-size:18px;'>" + title + "</div>"
        }

        imgContainer.appendChild(sourceImage);
        //imgContainer.style.width=img.naturalWidth;

        if (legend != "") {
            imgContainer.innerHTML = imgContainer.innerHTML + "<div style='border:1px solid black;padding:8px;'>" + decodeHtml(legend) + "</div>";
        }
        imgContainer.style.visibility="visible";
    }

    function resizeThis(img) {
        if (img) {
            //get the height to 60
            var goal = 700;
            var width = img.naturalWidth;

            if (width < goal) {
                return;
            }

            var diff = width - goal;
            var percentDiff = 1 - (diff / width);
            img.width = goal;
            img.height = parseInt(img.naturalHeight * percentDiff);

        }
    }

    function imageMouseOut(img) {
        document.getElementById("imageViewer").innerHTML="";
        document.getElementById("imageViewer").style.visibility="hidden";
    }

    function decodeHtml(html) {
        var txt = document.createElement("textarea");
        txt.innerHTML = html;
        return txt.value;
    }

    setTimeout("resizeImages()",500);

</script>
<script>
   var tissueDeliveryConditions = [];
   var tissuesDelivery = [];
   var tissuesEditing = [];
   var tissueEditingConditions = [];

   var tissueDeliveryData = <%=deliveryResults%>; //data
   tissueDeliveryConditions = <%=deliveryConditions%>; //labels
   tissuesDelivery = <%=deliveryNames%>; //each tissue


   var tissueEditingData = <%=editingResults%>;
   tissueEditingConditions = <%=editingConditions%>;
   tissuesEditing = <%=editingNames%>;

   function generateDeliveryData(index){
       var data=[];
       data.push({
           label: "Mean",
           data: tissueDeliveryData[index],
           backgroundColor: 'rgba(255, 206, 99, 0.6)',
           borderColor:    'rgba(255, 206, 99, 0.8)',
           borderWidth: 1
       });
       return data;
   }
   function generateEditingData(index){
       var data=[];
       data.push({
           label: "Mean",
           data: tissueEditingData[index],
           backgroundColor: 'rgba(255, 206, 99, 0.6)',
           borderColor:    'rgba(255, 206, 99, 0.8)',
           borderWidth: 1
       });
       return data;
   }

   var deliveryCtxs = [];
   var deliveryCharts = [];
   var editingCtxs = [];
   var editingCharts = [];

   for(var i = 0;i<tissuesDelivery.length;i++) {
       deliveryCtxs[i] = document.getElementById("canvasDelivery" + i);
       deliveryCharts[i] = new Chart(deliveryCtxs[i], {
           type: 'bar',
           data: {
               labels: tissueDeliveryConditions[i],
               datasets: generateDeliveryData(i)
           },
           options: {
               events: [],

               scales:{
                   xAxes:[{
                       gridLines: {
                           color: "rgba(0, 0, 0, 0)"
                       },
                       ticks:{
                           display:false

                           }
                   }]
               }
           }
       });
   }
   for(var i = 0;i<tissuesEditing.length;i++) {
       editingCtxs[i] = document.getElementById("canvasEditing" + i);
       editingCharts[i] = new Chart(editingCtxs[i], {
           type: 'bar',
           data: {
               labels: tissueEditingConditions[i],
               datasets: generateEditingData(i)
           },
           options: {
               events: [],
               scales:{
                   xAxes:[{
                       gridLines: {
                           color: "rgba(0, 0, 0, 0)"
                       },
                       ticks:{
                           display:false
                       }
                   }]
               }
           }
       });
   }
   function generateTissuePage(resultType,selectedTissue) {
       params = new Object();
       var form = document.createElement("form");
       var method = "POST";
       form.setAttribute("method", method);
       form.setAttribute("action", "/toolkit/data/experiments/experiment/<%=ex.getExperimentId()%>");
       params.species = this.species;
       params.genes = genes;
       params.o = this.ontology;
       for (var key in params) {
           var hiddenField = document.createElement("input");
           hiddenField.setAttribute("type", "hidden");
           hiddenField.setAttribute("name", key);
           hiddenField.setAttribute("value", params[key]);
           form.appendChild(hiddenField);
       }
       document.body.appendChild(form);
       form.submit();
   }
   function updateTargetTissue() {
       var experimentRecordIds=[];
       $.each($('input[name="targetTissue"]'), function() {
           var _this = $(this);
           var val = _this.val();
           if(_this.is(":checked"))
           experimentRecordIds.push(val);

       });
        if(experimentRecordIds.length>0){
            $('#experimentRecordIds').val(experimentRecordIds)
        }
       // alert("experimentREcordIds: "+ experimentRecordIds)
   }

</script>