<%@ page import="java.util.TreeSet" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="io.netty.util.internal.StringUtil" %>
<%@ page import="edu.mcw.scge.web.TissueMapper" %>
<%@ page import="sun.awt.image.ImageWatched" %>
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
    rootTissues.put("Connective Tissue", "UBERON:0002384");
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

        //This is a total hack and needs to be refactored
        HashMap<String,Long> targetTissues2=new HashMap<String,Long>();
        HashMap<String,Long> nonTargetTissues2=new HashMap<String,Long>();

        for (Long resultId: resultDetail.keySet()) {
            List<ExperimentResultDetail> erdList = resultDetail.get(resultId);
            long expRecordId = erdList.get(0).getExperimentRecordId();
            ExperimentRecord er = experimentRecordsMap.get(expRecordId);
            if(er.getIsTargetTissue()==1){
                targetTissues.add(er.getOrganSystemID());
                targetTissueRecordIds.add(er.getExperimentRecordId());

                if (er.getCellType() !=null && !er.getCellType().equals("") ) {
                    System.out.println("1 adding " + er.getTissueTerm() + " (" + er.getCellTypeTerm() + ") with recored id " + er.getExperimentRecordId() );
                    targetTissues2.put(er.getTissueTerm() + " (" + er.getCellType() + ")", er.getExperimentRecordId());
                }else {
                    System.out.println("2 adding " + er.getTissueTerm() + " with recored id " + er.getExperimentRecordId() );
                    targetTissues2.put(er.getTissueTerm(), er.getExperimentRecordId());
                }
            }else {
                if (er.getCellType() !=null && !er.getCellType().equals("") ) {
                    nonTargetTissues2.put(er.getTissueTerm() + " (" + er.getCellType() + ")", er.getExperimentRecordId());
                }else {
                    nonTargetTissues2.put(er.getTissueTerm(), er.getExperimentRecordId());
                }
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
            boolean hasEditing = false;
            boolean hasDelivery=false;
            for (ExperimentResultDetail erd : erdList) {
                if (erd.getResultType().equals("Delivery Efficiency")) {
                    hasDelivery = true;
                }
                if (erd.getResultType().equals("Editing Efficiency")) {
                    hasEditing=true;
                }
            }


            if (cellType != null) {
                if (hasDelivery) {
                    String url = "/toolkit/data/experiments/experiment/"+ex.getExperimentId()+"?resultType=Delivery&tissue=" + tissueTerm + "&cellType=" + cellType;
                    tm.addDelivery(organSystem, tissueTerm + " (" + cellType + ")", url);
                }
                if (hasEditing) {
                    String url = "/toolkit/data/experiments/experiment/"+ex.getExperimentId()+"?resultType=Editing&tissue=" + tissueTerm + "&cellType=" + cellType;
                    tm.addEditing(organSystem, tissueTerm + " (" + cellType + ")", url);
                }
            }else {
                if (hasDelivery) {
                    String url = "/toolkit/data/experiments/experiment/"+ex.getExperimentId()+"?resultType=Delivery&tissue=" + tissueTerm + "&cellType=";
                    tm.addDelivery(organSystem, tissueTerm, url);
                }
                if (hasEditing) {
                    String url = "/toolkit/data/experiments/experiment/"+ex.getExperimentId()+"?resultType=Editing&tissue=" + tissueTerm + "&cellType=";
                    tm.addEditing(organSystem, tissueTerm, url);
                }
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



    <table align="right">
        <tr>
            <td> <div style="border-color:blue;background-color: blue;width:20px;height:20px "></div></td><td>Delivery Efficiency</td>
        </tr>
        <tr>
            <td><div style="border-color:orange;background-color: orange;width:20px;height:20px "></div></td><td>Editing Efficiency</td>
        </tr>
        <tr>
            <td><div style="border-color:orange;background-color: #DA70D6;width:20px;height:20px "></div></td><td>Target Tissue</td>
        </tr>

    </table>





<h6 style="color:#1A80B6;">Organ System Overview</h6>
<br><br>


<table align="center">
    <tr>
        <td>


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


        </td>
    </tr>
    <tr><td>&nbsp;</td></tr>
    <tr><td><hr></td></tr>
    <tr><td>&nbsp;
        <%if (access.isAdmin(p)) {%>
        <div align="right">
            <form id="updateTargetTissueForm" action="/toolkit/data/experiments/update/experiment/<%=ex.getExperimentId()%>">
                <input type="hidden" name="experimentRecordIds" id= "experimentRecordIds" value=""/>
                <button class="btn btn-primary btn-sm" onclick="updateTargetTissue()">Update Target Tissue</button>
            </form>
        </div>
        <% } %>

    </td></tr>
    <tr>
        <td>





<table align="center" tyle="border:1px solid #F7F7F7;margin-left:30px;" border="0" width="700">
    <tr>
        <td colspan="2" style="font-size:16px; font-weight:700;">Analyze Data Sets Available for this Experiment</td><td style="font-size:16px; font-weight:700;" align="center">Delivery</td><td style="font-size:16px; font-weight:700;" align="center">Editing</td>
    </tr>
    <% for (String organ: tm.getChildTerms().keySet()) {
        if (!tm.getChildTerms().get(organ).isEmpty()) {
    %>

    <tr>
        <td colspan="2" style="font-size:20px;padding-top:10px;" id="<%=organ%>"><%=organ%></td>
        <td></td><td></td>
    </tr>
    <tr>
            <% for (String childTerm: tm.getChildTerms().get(organ).keySet()) {
                    String upCaseChildTerm = childTerm.substring(0,1).toUpperCase() + childTerm.substring(1,childTerm.length());
            %>

    <tr>


        <td width="100">&nbsp;</td><td style="padding-right:5px; border-bottom:1px solid black;border-color:#770C0E; font-size:14px;">

    <% if (access.isAdmin(p)) {
        if (targetTissues2.containsKey(childTerm)) { %>
    <input type="checkbox" name="targetTissue" value="<%=targetTissues2.get(childTerm)%>" checked>
    <% } else { %>
    <input type="checkbox" name="targetTissue" value="<%=nonTargetTissues2.get(childTerm)%>">
    <% }
    }
    %>
    <%=upCaseChildTerm%>
    <% if (targetTissues2.containsKey(childTerm)) { %>
    &nbsp;<span style="color:#DA70D6">(TARGET)</span>
    <%} %>
    </td>
            <% if (tm.hasDelivery(organ,childTerm)) { %>
                <td width="75" style="border-bottom:1px solid black;border-color:#770C0E;" align="center"><input onclick="location.href='<%=tm.getDeliveryURL(organ,childTerm)%>'" type="button" style="margin-left:5px;border:0px solid black; font-size:10px; background-color:#007BFF;color:white;border-radius: 5px;" value="View Delivery Data"/></td>
            <% } else { %>
                <td width="75"  style="border-bottom:1px solid black;border-color:#770C0E;" align="center">n/a</td>
            <% } %>

            <% if (tm.hasEditing(organ,childTerm)) { %>
                <td width="75" style="border-bottom:1px solid black;border-color:#770C0E;" align="center"><input onClick="location.href='<%=tm.getEditingURL(organ,childTerm)%>'" type="button" style="margin-left:5px;border:0px solid black; font-size:10px; background-color:#FFA500;color:white;border-radius: 5px;" value="View Editing Data"></td>
            <% } else { %>
                <td width="75" style="border-bottom:1px solid black;border-color:#770C0E;" align="center">n/a</td>
            <% } %>


            <% } %>
    <%}
    } %>
    </tr>
    </td>
    </tr>
</table>


        </td>
    </tr>
</table>


<hr>



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