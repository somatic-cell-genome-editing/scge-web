<%@ page import="edu.mcw.scge.web.TissueMapper" %>
<%@ page import="edu.mcw.scge.web.SCGEContext" %>
<%@ page import="edu.mcw.scge.dao.implementation.ImageDao" %>
<%@ page import="edu.mcw.scge.datamodel.ExperimentRecord" %>
<%@ page import="edu.mcw.scge.datamodel.ExperimentResultDetail" %>
<%@ page import="java.util.*" %>
<%@ page import="edu.mcw.scge.datamodel.Experiment" %>
<%@ page import="edu.mcw.scge.datamodel.Person" %>
<%@ page import="edu.mcw.scge.configuration.Access" %>
<link rel="stylesheet" href="/toolkit/css/tissuemap.css">

<%
    TissueMapper tm = new TissueMapper();

    ImageDao idao = new ImageDao();

    LinkedHashMap<String,String> rootTissues = new LinkedHashMap<String,String>();
    //rootTissues.put("Other", "other");
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
   // rootTissues.put("Hematopoietic","UBERON:0002390");
    List<ExperimentRecord> records= (List<ExperimentRecord>) request.getAttribute("records");
    Access access = new Access();
    Person p = access.getUser(request.getSession());
    Experiment ex = (Experiment) request.getAttribute("experiment");
%>

    <%
        LinkedHashMap<String, Boolean> tissueEditingMap = new LinkedHashMap<String, Boolean>();
        LinkedHashMap<String, Boolean> tissueDeliveryMap = new LinkedHashMap<String, Boolean>();
        LinkedHashMap<String, Boolean> tissueBiomarkerMap = new LinkedHashMap<String, Boolean>();

        Set<String> targetTissues=new HashSet<>();
        Set<Long> targetTissueRecordIds=new HashSet<>();

        //This is a total hack and needs to be refactored
        HashMap<String,Long> targetTissues2=new HashMap<String,Long>();
        HashMap<String,Long> nonTargetTissues2=new HashMap<String,Long>();
//try {
    for (ExperimentRecord er : records) {
        List<ExperimentResultDetail> erdList = er.getResultDetails();
        try {
            if (er.getIsTargetTissue() == 1) {
                if (er.getOrganSystemID() != null)
                    targetTissues.add(er.getOrganSystemID());
                targetTissueRecordIds.add(er.getExperimentRecordId());

                if ((er.getCellTypeTerm() != null && !er.getCellTypeTerm().equals(""))) {
                    if (er.getTissueTerm() != null)
                        targetTissues2.put(er.getTissueTerm() + " (" + er.getCellTypeTerm().trim() + ")", er.getExperimentRecordId());
                } else {
                    if (er.getTissueTerm() != null)
                        targetTissues2.put(er.getTissueTerm(), er.getExperimentRecordId());
                }
            } else {
                if ((er.getCellTypeTerm() != null && !er.getCellTypeTerm().equals(""))) {
                    if (er.getTissueTerm() != null)
                        nonTargetTissues2.put(er.getTissueTerm() + " (" + er.getCellTypeTerm().trim() + ")", er.getExperimentRecordId());
                } else {
                    if (er.getTissueTerm() != null)
                        nonTargetTissues2.put(er.getTissueTerm(), er.getExperimentRecordId());
                }
            }
        } catch (Exception e) {
            System.out.println("BLOCK:6");
            e.printStackTrace();
        }
        String labelTrimmed = new String();

        try {
            if (er.getCellTypeTerm() != null && !er.getCellTypeTerm().equals("") && er.getTissueTerm() != null)
                labelTrimmed = er.getCondition().replace(er.getTissueTerm(), "").replace(er.getCellTypeTerm(), "").trim();
            else if (er.getTissueTerm() != null)
                labelTrimmed = er.getCondition().replace(er.getTissueTerm(), "").trim();
            else labelTrimmed = er.getCondition().trim();
        } catch (Exception e) {
            System.out.println("BLOCK:5");
            e.printStackTrace();
        }

        String tissue = "unknown";
        String organSystemID = er.getOrganSystemID();
        String organSystem = "unknown";
        try {
        for (String rootTissue : rootTissues.keySet()) {

                if (organSystemID != null && rootTissues.get(rootTissue) != null && organSystemID.trim().equals(rootTissues.get(rootTissue))) {
                    tissue = rootTissues.get(rootTissue);
                    organSystem = rootTissue;
                    break;
                }
            }
        }catch (Exception e) {
            System.out.println("BLOCK:" + 4);
            e.printStackTrace();
        }

        String tissueTerm = er.getTissueTerm()!=null ?er.getTissueTerm().trim():null;
        String cellType = er.getCellTypeTerm()!=null?er.getCellTypeTerm().trim():null;
        boolean hasEditing = false;
        boolean hasDelivery = false;
        boolean hasBiomarker = false;
        try {
            if(erdList!=null)
        for (ExperimentResultDetail erd : erdList) {
                if(erd!=null){
                if (erd.getResultType() != null && erd.getResultType().equals("Delivery Efficiency")) {
                    hasDelivery = true;
                }
                if (erd.getResultType() != null && erd.getResultType().equals("Editing Efficiency")) {
                    hasEditing = true;
                }
                    if (erd.getResultType() != null && erd.getResultType().equals("Biomarker Detection")) {
                        hasBiomarker = true;
                    }
            }
                }
        }catch (Exception e) {
            System.out.println("BLOCK:" + 3);
            e.printStackTrace();
        }
        try {
        if (tissueTerm != null) {
                String cellTypeTerm="";
                if (cellType != null && !cellType.equals("")) {
                    cellTypeTerm+=" (" + cellType + ")";
                }
                    if (hasDelivery) {
                        String url = "/toolkit/data/experiments/experiment/" + ex.getExperimentId() + "?resultType=Delivery&tissue=" + tissueTerm + "&cellType=" + cellType;
                        tm.addDelivery(organSystem, tissueTerm +cellTypeTerm , url);
                    }
                    if (hasEditing) {
                        String url = "/toolkit/data/experiments/experiment/" + ex.getExperimentId() + "?resultType=Editing&tissue=" + tissueTerm + "&cellType=" + cellType;
                        tm.addEditing(organSystem, tissueTerm + cellTypeTerm, url);
                    }
                    if (hasBiomarker) {
                        String url = "/toolkit/data/experiments/experiment/" + ex.getExperimentId() + "?resultType=Biomarker&tissue=" + tissueTerm + "&cellType=" + cellType;
                        tm.addBiomarker(organSystem, tissueTerm + cellTypeTerm, url);
                    }

            }
        }catch (Exception e) {
            System.out.println("BLOCK:" + 2);
            e.printStackTrace();
        }
        try {
            if(erdList!=null)
        for (ExperimentResultDetail erd : erdList) {
            if (erd != null) {
                if (erd.getResultType() != null && erd.getResultType().equals("Delivery Efficiency") && tissue != null) {
                    tissueDeliveryMap.put(tissue + "-" + labelTrimmed, true);
                }
                if (erd.getResultType() != null && erd.getResultType().equals("Editing Efficiency") && tissue != null) {
                    tissueEditingMap.put(tissue + "-" + labelTrimmed, true);
                }
                if (erd.getResultType() != null && erd.getResultType().equals("Biomarker Detection") && tissue != null) {
                    tissueBiomarkerMap.put(tissue + "-" + labelTrimmed, true);
                }
            }
        }
        }catch (Exception e) {
            System.out.println("BLOCK:" + 1);
            e.printStackTrace();
        }
    }
//}catch (Exception e){
//    System.out.println("OVERALLLLLLLLLLLLLLLLLLLLLL");
//    e.printStackTrace();
//}
    %>
<div class="row container-fluid">

    <div class="col-lg-4" style="background-color: #f7f8fa;padding-top: 10px">


        <div>
            <div style="text-align: center">
            <h5>Analyze Data Sets Available for this Experiment</h5>
            </div>
            <hr>
            <div>
                <div class="row">
                    <div class="col-5">
                        <%if (access.isAdmin(p) && !SCGEContext.isProduction()) {%>
                        <form id="updateTargetTissueForm" action="/toolkit/data/experiments/update/experiment/<%=ex.getExperimentId()%>">
                            <input type="hidden" name="experimentRecordIds" id= "experimentRecordIds" value=""/>
                            <button class="btn btn-warning btn-sm" onclick="updateTargetTissue()">Update Target Tissue</button>
                        </form>
                        <% } %>
                    </div>
                    <div class="col-7" style="border:1px solid grey;padding-top: 2px;padding-bottom: 2px">
                        <div class="row">
                            <div class="col-6 text-no-wrap" >
                            View Tissues:
                            </div>
                            <div class="col-2" >
                                <a href="/toolkit/data/experiments/experiment/<%=ex.getExperimentId()%>?resultType=all"><button class="btn btn-primary btn-sm">All</button></a>
                            </div>
                            <div class="col-4" >
                                <form id="viewSelectedTissues" action="/toolkit/data/experiments/experiment/<%=ex.getExperimentId()%>">
                                    <input type="hidden" name="selectedTissues" id= "selectedTissues" value=""/>
                                    <button class="btn btn-primary btn-sm" onclick="viewSelectedTissues()">Selected</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
                <% for (String organ: tm.getChildTerms().keySet()) {
                    if (!tm.getChildTerms().get(organ).isEmpty()) {
                %>
            <span  style=";padding-top:10px;" id="<%=organ%>"><input id="<%=organ%>" type="checkbox" onchange="checkTissues('<%=organ%>', this)">&nbsp;<%=organ%></span>

            <% for (String childTerm: tm.getChildTerms().get(organ).keySet()) {
                String upCaseChildTerm = childTerm.substring(0,1).toUpperCase() + childTerm.substring(1,childTerm.length());
                String tissueTermExtracted=null;
                if(upCaseChildTerm.indexOf("(")>0){
                    tissueTermExtracted=upCaseChildTerm.substring(0,upCaseChildTerm.indexOf("(")).trim().toLowerCase();
                }else{
                    tissueTermExtracted=upCaseChildTerm.trim().toLowerCase();
                }
            %>
                <li style="list-style-type: none;margin-left:5%">
                    <table style="width: 100%">
                        <tr>
                    <td style="width: 70%;"><input type="checkbox" name="<%=organ%>" class="selectedTissue" value="<%=tissueTermExtracted%>">
                    <%=upCaseChildTerm%>
                    <% if (targetTissues2.containsKey(childTerm)) { %>
                    &nbsp;<span style="color:red;font-weight: bold">(TARGET)</span>
                    <%} %>
                    </td>

                            <td>
                    <% if (access.isAdmin(p) && !SCGEContext.isProduction()) {
                        if (targetTissues2.containsKey(childTerm)) { %>
                    <input type="checkbox" name="targetTissue" value="<%=targetTissues2.get(childTerm)%>" checked>Target Check
                    <% } else { %>
                    <input type="checkbox" name="targetTissue" value="<%=nonTargetTissues2.get(childTerm)%>">Target Check
                    <% }}%>

                            </td>
                        </tr>
                    </table>
                </li>

                <% } %>
                    <%}} %>



    </div>
</div>
    <div class="col-lg-8">
        <div style="text-align: center"><h4>Organ&nbsp;System&nbsp;Overview</h4></div>
        <div style="margin-top: 10%">

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
                                                    for (String tissue: rootTissues.keySet()) {
                                                        String tissueTerm=rootTissues.get(tissue);
                                                        String displayTissue= "";
                                                        if(!tm.getChildTerms().get(tissue).isEmpty()){
                                                            displayTissue="<a href='#"+tissue+"'>"+tissue+"</a>";
                                                        }else displayTissue=tissue;
                                                %>
                                                <% if (first) { if(targetTissues.contains(tissueTerm)){ %>
                                                <div class="tissue-control-header-first" style="color:orangered"><%=displayTissue%></div>
                                                <%}else{%>
                                                <div class="tissue-control-header-first"><%=displayTissue%></div>
                                                <%}%>
                                                <% first = false; %>
                                                <% } else { if(targetTissues.contains(tissueTerm)) {%>
                                                <div class="tissue-control-header" style="color:orangered"><%=displayTissue%></div>

                                                <%}else{%>
                                                <div class="tissue-control-header"><%=displayTissue%></div>
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

                                        <%  LinkedHashSet<String> conditions = (LinkedHashSet<String>) request.getAttribute("conditions");
                                            for (String condition: conditions) { %>
                                        <tr>
                                            <td  width="65"></td>

                                            <% for (String tissueKey: rootTissues.keySet()) {
                                                String tissue=rootTissues.get(tissueKey);
                                                if(targetTissues.contains(tissue)){%>
                                            <td width="40" style="border:5px dashed red">
                                                <div class="tissue-control-cell">
                                                    <div class="tissue-control-cell-2">
                                                        <% if (tissueDeliveryMap.containsKey(tissue + "-" + condition)
                                                                && !tissueBiomarkerMap.containsKey(tissue + "-" + condition)
                                                                && !tissueEditingMap.containsKey(tissue + "-" + condition)) { %>
                                                        <div class="triangle-d" ></div>
                                                        <% } %>
                                                        <% if (tissueEditingMap.containsKey(tissue + "-" + condition)
                                                                && !tissueBiomarkerMap.containsKey(tissue + "-" + condition)
                                                                && !tissueDeliveryMap.containsKey(tissue + "-" + condition)) { %>
                                                        <div class="triangle-e"></div>
                                                        <% } %>
                                                        <% if (tissueBiomarkerMap.containsKey(tissue + "-" + condition)
                                                                && !tissueDeliveryMap.containsKey(tissue + "-" + condition)
                                                                && !tissueEditingMap.containsKey(tissue + "-" + condition)
                                                        ) { %>
                                                        <div class="triangle-b"></div>
                                                        <% } %>
                                                        <% if (tissueBiomarkerMap.containsKey(tissue + "-" + condition)
                                                                && tissueDeliveryMap.containsKey(tissue + "-" + condition)
                                                                && !tissueEditingMap.containsKey(tissue + "-" + condition)) { %>
                                                        <div class="triangle-db"></div>
                                                        <% } %>
                                                        <% if (tissueBiomarkerMap.containsKey(tissue + "-" + condition)
                                                                && tissueEditingMap.containsKey(tissue + "-" + condition)
                                                                && !tissueDeliveryMap.containsKey(tissue + "-" + condition)) { %>
                                                        <div class="triangle-eb"></div>
                                                        <% } %>
                                                        <% if (!tissueBiomarkerMap.containsKey(tissue + "-" + condition)
                                                                && tissueDeliveryMap.containsKey(tissue + "-" + condition)
                                                                && tissueEditingMap.containsKey(tissue + "-" + condition)) { %>
                                                        <div class="triangle-ed"></div>
                                                        <% } %>
                                                        <% if (tissueBiomarkerMap.containsKey(tissue + "-" + condition)
                                                                && tissueDeliveryMap.containsKey(tissue + "-" + condition)
                                                                && tissueEditingMap.containsKey(tissue + "-" + condition)) { %>
                                                        <div class="triangle-edb"></div>
                                                        <% } %>
                                                    </div>
                                                </div>
                                            </td>
                                            <%}else{%>
                                            <td width="40">
                                                <div class="tissue-control-cell">
                                                    <div class="tissue-control-cell-2">
                                                        <% if (tissueDeliveryMap.containsKey(tissue + "-" + condition)
                                                                && !tissueBiomarkerMap.containsKey(tissue + "-" + condition)
                                                                && !tissueEditingMap.containsKey(tissue + "-" + condition)) { %>
                                                        <div class="cell-wrapper"><div class="triangle-d" ></div></div>
                                                        <% } %>
                                                        <% if (tissueEditingMap.containsKey(tissue + "-" + condition)
                                                                && !tissueBiomarkerMap.containsKey(tissue + "-" + condition)
                                                                && !tissueDeliveryMap.containsKey(tissue + "-" + condition)) { %>
                                                        <div class="cell-wrapper"><div class="triangle-e"></div></div>
                                                        <% } %>
                                                        <% if (tissueBiomarkerMap.containsKey(tissue + "-" + condition)
                                                                && !tissueDeliveryMap.containsKey(tissue + "-" + condition)
                                                                && !tissueEditingMap.containsKey(tissue + "-" + condition)
                                                        ) { %>
                                                        <div class="cell-wrapper"><div class="triangle-b"></div></div>
                                                        <% } %>
                                                        <% if (tissueBiomarkerMap.containsKey(tissue + "-" + condition)
                                                                && tissueDeliveryMap.containsKey(tissue + "-" + condition)
                                                                && !tissueEditingMap.containsKey(tissue + "-" + condition)) { %>
                                                        <div class="cell-wrapper"><div class="triangle-db"></div></div>
                                                        <% } %>
                                                        <% if (tissueBiomarkerMap.containsKey(tissue + "-" + condition)
                                                                && tissueEditingMap.containsKey(tissue + "-" + condition)
                                                                && !tissueDeliveryMap.containsKey(tissue + "-" + condition)) { %>
                                                        <div class="cell-wrapper"><div class="triangle-eb"></div></div>
                                                        <% } %>
                                                        <% if (!tissueBiomarkerMap.containsKey(tissue + "-" + condition)
                                                                && tissueDeliveryMap.containsKey(tissue + "-" + condition)
                                                                && tissueEditingMap.containsKey(tissue + "-" + condition)) { %>
                                                        <div class="cell-wrapper"><div class="triangle-ed"></div></div>
                                                        <% } %>
                                                        <% if (tissueBiomarkerMap.containsKey(tissue + "-" + condition)
                                                                && tissueDeliveryMap.containsKey(tissue + "-" + condition)
                                                                && tissueEditingMap.containsKey(tissue + "-" + condition)) { %>
                                                        <div class="cell-wrapper"><div class="triangle-edb"></div></div>
                                                        <% } %>
                                                    </div>
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
                        <table style="border:1px solid black;margin-top: 10%"  align="center">
                            <tr>
                                <td style="padding:10px;">
                                    <table>
                                        <tr>
                                            <td><strong>Legend:</strong></td>
                                            <td>&nbsp;</td>
                                            <td align="center">
                                                <table>
                                                    <tr>
                                                        <td><div style="border:1px solid black;"> <div class="legend-delivery"></div></div></td><td>&nbsp;<small>Delivery Efficiency</small></td>
                                                    </tr><tr>
                                                        <td><div style="border:1px solid black;"><div class="legend-editing"></div></div></td><td>&nbsp;<small>Editing Efficiency</small></td>
                                                </tr><tr>
                                                        <td><div style="border:1px solid black;"><div class="legend-biomarker"></div></div></td><td>&nbsp;<small>Biomarker Detection</small></td>
                                                </tr><tr>
                                                        <td><div style="border:3px dashed red;background-color: white;width:15px;height:15px "></div></td><td>&nbsp;<small>Target Tissue</small></td>
                                                </tr><tr>
                                                        <td><div style="border:1px solid black;background-color: #F7F7F7;width:15px;height:15px "></div></td><td>&nbsp;<small>Not Available</small></td>
                                                    </tr>

                                                </table>

                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</div>
<script>
    function checkTissues(organClass, _this){
        var elms = document.getElementsByName(organClass);

        if(_this.checked){
            elms.forEach(function(ele) {
                ele.checked=true;

            });
         }else {
            elms.forEach(function(ele) {
                ele.checked=false;

            });


         }

    }
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
   function viewSelectedTissues() {
       var selectedTissues=[];
       $.each($('input[class="selectedTissue"]'), function() {
           var _this = $(this);
           var val = _this.val();
           if(_this.is(":checked"))
               selectedTissues.push(val);

       });
       if(selectedTissues.length>0){
           $('#selectedTissues').val(selectedTissues)
       }
       // alert("selectedTissues: "+ selectedTissues)
   }

</script>