<%@ page import="java.util.TreeSet" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.util.ArrayList" %>
<style>
    .tissue-control {
        position: relative;
    }
    .tissue-control-header-first {
        transform: rotate(-45deg);
        float: left;
        width:200px;
        margin-left:0px;
        margin-bottom:15px;
        order:1px solid black;
        text-align: left;
        font-size:18px;
    }
    .tissue-control-header {
        transform: rotate(-45deg);
        float: left;
        width:200px;
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

    LinkedHashMap<String,String> rootTissues = new LinkedHashMap<String,String>();
    rootTissues.put("Reproductive System", "UBERON:0000990");
    rootTissues.put("Renal/Urinary System", "UBERON:0001008");
    rootTissues.put("Endocrine System","UBERON:0000949");
    rootTissues.put("Haemolymphoid System","UBERON:0002193");
    rootTissues.put("Gastrointestinal System","UBERON:0005409");
    rootTissues.put("Liver and biliary system","UBERON:0002423");
    rootTissues.put("Respiratory System","UBERON:0001004");
    rootTissues.put("Cardiovascular System","UBERON:0004535");
    rootTissues.put("Musculoskeletal System","UBERON:0002204");
    rootTissues.put("Integumentary System","UBERON:0002416");
    rootTissues.put("Nervous System","UBERON:0001016");
    rootTissues.put("Sensory System","UBERON:0001032");
    rootTissues.put("Hematopoietic System","UBERON:0002390");
%>


    <%
        HashMap<String, Boolean> tissueEditingMap = new HashMap<String, Boolean>();
        HashMap<String, Boolean> tissueDeliveryMap = new HashMap<String, Boolean>();
        HashMap<String,List<Double>> tissueEditingResults = new HashMap<>();
        HashMap<String,List<Double>> tissueDeliveryResults = new HashMap<>();
        HashMap<String,Set<String>> tissueDeliveryConditions = new HashMap<>();
        HashMap<String,Set<String>> tissueEditingConditions = new HashMap<>();
        HashMap<String,List<ExperimentResultDetail>> qualEditingResults = new HashMap<>();
        HashMap<String,List<ExperimentResultDetail>> qualDeliveryResults = new HashMap<>();
        HashMap<String,ExperimentRecord> experimentRecordHashMap = new HashMap<>();
        List<String> uniqueObjects = new ArrayList<>();
        List<Double> resultDetails = new ArrayList<>();
        Set<String> labelDetails = new TreeSet<>();
        HashMap<String,String> tissueNames = new HashMap<>();
        List<ExperimentResultDetail> qualResults = new ArrayList<>();
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

        for (Long resultId: resultDetail.keySet()) {
            List<ExperimentResultDetail> erdList = resultDetail.get(resultId);
            long expRecordId = erdList.get(0).getExperimentRecordId();
            ExperimentRecord er = experimentRecordsMap.get(expRecordId);
            experimentRecordHashMap.put(er.getExperimentName(),er);
            if(uniqueObjects.contains(er.getEditorSymbol()))
                noOfEditors++;
            if(uniqueObjects.contains(er.getDeliverySystemType()))
                noOfDelivery++;
            if(uniqueObjects.contains(er.getModelName()))
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
            String tissueName = "\"" + organSystem + ">" + tissueTerm + ">";
            if (cellType != null && !cellType.equals(""))
                tissueName += cellType + "\"";
            else tissueName += "\"";
            tissueNames.put(tissueName,er.getTissueTerm()+","+er.getCellTypeTerm());


            for (ExperimentResultDetail erd : erdList) {
                if (erd.getResultType().equals("Delivery Efficiency")) {
                    tissueDeliveryMap.put(tissue + "-" + er.getExperimentName(), true);


                    if (tissueDeliveryResults == null || !tissueDeliveryResults.containsKey(tissueName))
                        resultDetails = new ArrayList<>();
                    else resultDetails = tissueDeliveryResults.get(tissueName);
                    if (erd.getReplicate() == 0) {
                        resultDetails.add(Double.valueOf(erd.getResult()));
                        tissueDeliveryResults.put(tissueName, resultDetails);

                        if (tissueDeliveryConditions == null || !tissueDeliveryConditions.containsKey(tissueName))
                            labelDetails = new TreeSet<>();
                        else labelDetails = tissueDeliveryConditions.get(tissueName);
                        labelDetails.add("\"" + er.getExperimentName() + "\"");
                        tissueDeliveryConditions.put(tissueName, labelDetails);
                    }
                    if(erd.getUnits().contains("present")){
                        if (qualDeliveryResults == null || !qualDeliveryResults.containsKey(tissueName))
                            qualResults = new ArrayList<>();
                        else qualResults = qualDeliveryResults.get(tissueName);
                        qualResults.add(erd);
                        qualDeliveryResults.put(tissueName, qualResults);
                    }
                }
                if (erd.getResultType().equals("Editing Efficiency")) {
                    tissueEditingMap.put(tissue + "-" + er.getExperimentName(), true);

                    if(tissueEditingResults == null || !tissueEditingResults.containsKey(tissueName))
                        resultDetails = new ArrayList<>();
                    else  resultDetails = tissueEditingResults.get(tissueName);
                    if (erd.getReplicate() == 0) {
                        resultDetails.add(Double.valueOf(erd.getResult()));
                        tissueEditingResults.put(tissueName, resultDetails);

                        if(tissueEditingConditions == null || !tissueEditingConditions.containsKey(tissueName))
                            labelDetails = new TreeSet<>();
                        else  labelDetails = tissueEditingConditions.get(tissueName);
                        labelDetails.add("\""+er.getExperimentName()+"\"");
                        tissueEditingConditions.put(tissueName,labelDetails);
                    }
                    if(erd.getUnits().contains("present")){
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
<table>
<tr>
    <% if(noOfEditors == noOfRecords) {%>
    <td class="desc"   style="font-weight:700;">Editor:</td>
    <td class="desc"><a href="/toolkit/data/editors/editor?id=<%=experimentRecords.get(0).getEditorId()%>"><%=experimentRecords.get(0).getEditorSymbol()%></a></td>
    <td>&nbsp;&nbsp;&nbsp;</td>
    <%} if(noOfDelivery == noOfRecords) {%>
    <td class="desc"  style="font-weight:700;">Delivery:</td>
    <td class="desc" ><a href="/toolkit/data/delivery/system?id=<%=experimentRecords.get(0).getDeliverySystemId()%>"><%=experimentRecords.get(0).getDeliverySystemType()%></a></td>
    <td>&nbsp;&nbsp;&nbsp;</td>
    <%} if(noOfModel == noOfRecords) {%>
    <td class="desc"   style="font-weight:700;">Model:</td>
    <td class="desc"><a href="/toolkit/data/models/model?id=<%=experimentRecords.get(0).getModelId()%>"><%=experimentRecords.get(0).getModelName()%></a></td>
    <% } %>
</tr>
</table>
<div>Organ System Overview</div>
<br><br>
<div>
    <table width="5000">
        <tr>
            <td width="40">&nbsp;</td>
            <td>

                <%
                    boolean first = true;
                    //for (String tissue: tissues) {
                    for (String tissue: rootTissues.keySet()) {
                %>
                <% if (first) { %>
                <div class="tissue-control-header-first"><a href=""><%=tissue%></a></div>
                <% first = false; %>
                <% } else { %>
                <div class="tissue-control-header"><a href=""><%=tissue%></a></div>
                <% } %>
                <%  } %>
            </td>
        </tr>
    </table>

    <table style="margin-top:50px;">

        <% for (String condition: conditions) { %>
        <tr>
            <td><%=condition%></td>

            <% for (String tissueKey: rootTissues.keySet()) {
                String tissue=rootTissues.get(tissueKey);
            %>
            <td width="40">
                <div class="tissue-control-cell">
                    <% if (tissueDeliveryMap.containsKey(tissue + "-" + condition)) { %>
                    <div class="triangle-topleft"></div>
                    <% } %>
                    <% if (tissueEditingMap.containsKey(tissue + "-" + condition)) { %>
                    <div class="triangle-bottomright"></div>
                    <% } %>
                </div>
            </td>
            <% } %>
            <td style="font-size: small">

                <%  long id = experimentRecordHashMap.get(condition).getExperimentRecordId();
                    ExperimentRecord r = experimentRecordHashMap.get(condition);
                    List<Guide> guides = guideMap.get(id);
                    String guide = "";
                    boolean fst = true;
                    for(Guide g: guides) {
                        if (!fst) { guide += ";"; }
                        guide += "<a href=\"/toolkit/data/guide/system?id="+g.getGuide_id()+"\">g("+SFN.parse(g.getGuide())+")</a>";
                        fst = false;
                    }
                    List<Vector> vectors = vectorMap.get(id);
                    String vector = "";
                    fst=true;
                    for(Vector v: vectors) {
                        if (!fst) { vector += ";"; }
                        vector += "<a href=\"/toolkit/data/vector/format?id="+v.getVectorId()+"\">v("+SFN.parse(v.getName())+")</a>";
                        fst=false;
                    }
                    if(r.getEditorSymbol() != null && noOfEditors != noOfRecords) {
                %>

                <a href="/toolkit/data/editors/editor?id=<%=r.getEditorId()%>">e(<%=SFN.parse(r.getEditorSymbol())%>)</a>&nbsp;&nbsp;
                <% } if(r.getDeliverySystemType() != null && noOfDelivery != noOfRecords) {%>
                <a href="/toolkit/data/delivery/system?id=<%=r.getDeliverySystemId()%>">ds(<%=SFN.parse(r.getDeliverySystemType())%>)</a>&nbsp;&nbsp;
                <% } if(r.getModelName() != null && noOfModel != noOfRecords) {%>
                <a href="/toolkit/data/models/model?id=<%=r.getModelId()%>">m(<%=SFN.parse(r.getModelName())%>)</a>&nbsp;&nbsp;
                <% } if(guide != "") {%>
                <%=guide%>&nbsp;&nbsp;
                <% } if(vector != "") {%>
                <%=vector%>
                <% } %>
            </td>
        </tr>
        <% } // end conditions %>
    </table>



</div>
<hr>

<div style="font-size:20px; color: #0002FC;">Select a graph below to explore the data set</div>
    <table id="grid" class="table" style="width:600px;padding-left:20px;" >
        <thead>
        <th>Organ System</th>
        <th>Delivery</th>
        <th>Editing</th>
        </thead>
    <% int i = 0,j=0;
        for (String tissueName: tissueNames.keySet()) {
            String term = tissueNames.get(tissueName);
            String[] terms = term.split(",");
            String deliveryurl = "/toolkit/data/experiments/experiment/"+ex.getExperimentId()+"?resultType=Delivery&tissue="+terms[0]+"&cellType=";
            String editingurl = "/toolkit/data/experiments/experiment/"+ex.getExperimentId()+"?resultType=Editing&tissue="+terms[0]+"&cellType=";
            if(terms.length == 2) {
                deliveryurl += terms[1];
                editingurl += terms[1];
            }
    %>
    <tr>
        <td><b><%=tissueName%></b></td>
        <td>
            <% if (tissueDeliveryConditions.containsKey(tissueName)) {%>
            <a href= "<%=deliveryurl%>">
            <div class="chart-container">
                <canvas id="canvasDelivery<%=i%>"></canvas>
            </div></a>
            <%  i++;} else if(qualDeliveryResults.containsKey(tissueName)) { %>
            <div>
                <table class="table tablesorter table-striped">
                <thead><tr>
                <th>Experiment Record Id</th>
                <th>Units</th>
                <th>Replicate</th>
                <th>Result</th>
                </tr></thead>
                <tbody>

             <%  for(ExperimentResultDetail e: qualDeliveryResults.get(tissueName) ) { %>
                <tr>
                <td><%=e.getExperimentRecordId()%></td>
                <td><%=e.getUnits()%></td>
                <td><%=e.getReplicate()%></td>
                <td><%=e.getResult()%></td>
                </tr>
             <% } %>
                </tbody>
                </table>
                </div>
            <%  } else %> <b>NO DATA</b>
        </td>
        <td>
            <% if (tissueEditingConditions.containsKey(tissueName)) {%>
            <a href= "<%=editingurl%>">
            <div class="chart-container">
                <canvas id="canvasEditing<%=j%>"></canvas>
            </div>
            </a>
            <%   j++;} else if(qualEditingResults.containsKey(tissueName)) { %>
            <div>
                <table class="table tablesorter table-striped">
                    <thead><tr>
                        <th>Experiment Record Id</th>
                        <th>Units</th>
                        <th>Replicate</th>
                        <th>Result</th>
                    </tr></thead>
                    <tbody>

                    <%  for(ExperimentResultDetail e: qualEditingResults.get(tissueName) ) { %>
                    <tr>
                        <td><%=e.getExperimentRecordId()%></td>
                        <td><%=e.getUnits()%></td>
                        <td><%=e.getReplicate()%></td>
                        <td><%=e.getResult()%></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
            <%  } else %> <b>NO DATA</b>
        </td>
    </tr>
<%}%>
</table>


<script>

   var tissueDeliveryConditions = [];
   var tissuesDelivery = [];
   var tissuesEditing = [];
   var tissueEditingConditions = [];
   var tissueDeliveryData = <%=tissueDeliveryResults.values()%>;
   tissueDeliveryConditions = <%=tissueDeliveryConditions.values()%>;
   tissuesDelivery = <%=tissueDeliveryResults.keySet()%>;
   var tissueEditingData = <%=tissueEditingResults.values()%>;
   tissueEditingConditions = <%=tissueEditingConditions.values()%>;
   tissuesEditing = <%=tissueEditingResults.keySet()%>;

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
                           fontColor: "rgb(0,75,141)",
                           callback: function(t) {
                               var maxLabelLength = 30;
                               if (t.length > maxLabelLength) return t.substr(0, maxLabelLength-20) + '...';
                               else return t;

                           }
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
           options: { events: [] }
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
</script>