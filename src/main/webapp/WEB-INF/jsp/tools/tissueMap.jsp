<%@ page import="java.util.TreeSet" %>
<%@ page import="java.util.Set" %>
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

%>
<div>Organ System Overview</div>
<br><br>
<div style="position:relative;margin-left:100px;">
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


    <%
        HashMap<String, Boolean> tissueEditingMap = new HashMap<String, Boolean>();
        HashMap<String, Boolean> tissueDeliveryMap = new HashMap<String, Boolean>();
        OntologyXDAO oxdao = new OntologyXDAO();
        HashMap<String,List<Double>> tissueEditingResults = new HashMap<>();
        HashMap<String,List<Double>> tissueDeliveryResults = new HashMap<>();
        HashMap<String,Set<String>> tissueDeliveryConditions = new HashMap<>();
        HashMap<String,Set<String>> tissueEditingConditions = new HashMap<>();
        List<Double> resultDetails = new ArrayList<>();
        Set<String> labelDetails = new TreeSet<>();

        for (ExperimentRecord er : experimentRecords) {
            String tissue = "unknown";
            String organSystem = er.getOrganSystemID();
            for (String rootTissue : rootTissues.keySet()) {
                if (organSystem.equals(rootTissues.get(rootTissue))) {
                    System.out.println("found a tissue");
                    tissue = rootTissues.get(rootTissue);
                    break;
                }
            }
            String tissueName = "\""+tissue+"\"";

            if(!tissue.equals("unknown")) {
            List<ExperimentResultDetail> erdList = resultDetail.get(er.getExperimentRecordId());

            for (ExperimentResultDetail erd : erdList) {
                if (erd.getResultType().equals("Delivery Efficiency")) {
                    tissueDeliveryMap.put(tissue + "-" + er.getExperimentName(), true);


                    if (tissueDeliveryResults == null || !tissueDeliveryResults.containsKey(tissueName))
                        resultDetails = new ArrayList<>();
                    else resultDetails = tissueDeliveryResults.get(tissueName);
                    if (erd.getReplicate() == 0) {
                        resultDetails.add(Double.valueOf(erd.getResult()));
                        tissueDeliveryResults.put(tissueName, resultDetails);
                    }
                    if(tissueDeliveryConditions == null || !tissueDeliveryConditions.containsKey(tissueName))
                        labelDetails = new TreeSet<>();
                    else  labelDetails = tissueDeliveryConditions.get(tissueName);
                    labelDetails.add("\""+er.getExperimentName()+"\"");
                    tissueDeliveryConditions.put(tissueName,labelDetails);
                }
                if (erd.getResultType().equals("Editing Efficiency")) {
                    tissueEditingMap.put(tissue + "-" + er.getExperimentName(), true);

                    if(tissueEditingResults == null || !tissueEditingResults.containsKey(tissueName))
                        resultDetails = new ArrayList<>();
                    else  resultDetails = tissueEditingResults.get(tissueName);
                    if (erd.getReplicate() == 0) {
                        resultDetails.add(Double.valueOf(erd.getResult()));
                        tissueEditingResults.put(tissueName, resultDetails);
                    }
                    if(tissueEditingConditions == null || !tissueEditingConditions.containsKey(tissueName))
                        labelDetails = new TreeSet<>();
                    else  labelDetails = tissueEditingConditions.get(tissueName);
                    labelDetails.add("\""+er.getExperimentName()+"\"");
                    tissueEditingConditions.put(tissueName,labelDetails);
                }
            }
            }
        }
    %>


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
        </tr>
        <% } // end conditions %>
    </table>



</div>
<div>
    <table id="grid" class="table tablesorter" style="height:600px; width:600px;">
        <thead>
        <th>Organ System</th>
        <th>Delivery</th>
        <th>Editing</th>
        </thead>
        <tr>
    <% int i = 0,j=0;
        for (String tissueKey: rootTissues.keySet()) {
        String tissue=rootTissues.get(tissueKey);
    %>
    <tr>
        <td><%=tissueKey%></td>
        <td>
            <% if (tissueDeliveryConditions.containsKey("\""+tissue+"\"")) {%>
            <div class="chart-container">
                <canvas id="canvasDelivery<%=i%>"></canvas>
            </div>
            <%  i++;}%>
        </td>
        <td>
            <% if (tissueEditingConditions.containsKey("\""+tissue+"\"")) {%>
            <div class="chart-container">
                <canvas id="canvasEditing<%=j%>"></canvas>
            </div>
            <%   j++;}%>
        </td>
    </tr>
<%}%>
</table>
</div>
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

   console.log(tissuesDelivery.length);
   console.log(tissuesEditing.length);
   function generateDeliveryData(index){
       var data=[];
       data.push({
           label: "Mean",
           data: tissueDeliveryData[index],
           backgroundColor: 'rgba(255, 206, 99, 0.6)',
           borderColor:    'rgba(255, 206, 99, 0.8)',
           borderWidth: 1
       });
       console.log(tissueDeliveryData[index]);
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
       console.log(tissueEditingData[index]);
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
           }
       });
   }
</script>