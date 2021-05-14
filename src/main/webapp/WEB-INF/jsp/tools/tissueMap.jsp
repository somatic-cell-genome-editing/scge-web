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

<%
    List<String> tissues = (List<String>)request.getAttribute("tissues");
    List<String> conditions = (List<String>) request.getAttribute("conditions");

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


        for (ExperimentRecord er : experimentRecords) {
            String tissue = "unknown";
            String organSystem = er.getOrganSystemID();

            for (String rootTissue : rootTissues.keySet()) {
                System.out.println("organ system = " + organSystem + " organ system - " + rootTissues.get(rootTissue) );

                if (organSystem.equals(rootTissues.get(rootTissue))) {
                    tissue = rootTissues.get(rootTissue);
                    break;
                }
            }

            List<ExperimentResultDetail> erdList = resultDetail.get(er.getExperimentRecordId());

            for (ExperimentResultDetail erd : erdList) {
                if (erd.getResultType().equals("Delivery Efficiency")) {
                    tissueDeliveryMap.put(tissue, true);
                }
                if (erd.getResultType().equals("Editing Efficiency")) {
                    tissueEditingMap.put(tissue, true);
                }
            }

        }
    %>


    <table style="margin-top:50px;">

        <% for (String condition: conditions) { %>
        <tr>
            <td><%=condition%></td>

            <% for (String tissue: rootTissues.keySet()) { %>

            <td width="40">
                <div class="tissue-control-cell">
                    <% if (tissueDeliveryMap.containsKey(tissue)) { %>
                    <div class="triangle-topleft"></div>
                    <% } %>
                    <% if (tissueEditingMap.containsKey(tissue)) { %>
                    <div class="triangle-bottomright"></div>
                    <% } %>
                </div>
            </td>
            <% } %>
        </tr>
        <% } // end conditions %>
    </table>


</div>