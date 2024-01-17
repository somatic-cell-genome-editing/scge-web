<%@ page import="java.util.TreeSet" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="io.netty.util.internal.StringUtil" %>
<%@ page import="edu.mcw.scge.web.TissueMapper" %>
<%@ page import="sun.awt.image.ImageWatched" %>
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
    rootTissues.put("Hematopoietic","UBERON:0002390");
%>

    <% Gson gson=new Gson();
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

                if (organSystemID != null && rootTissues.get(rootTissue) != null && organSystemID.equals(rootTissues.get(rootTissue))) {
                    tissue = rootTissues.get(rootTissue);
                    organSystem = rootTissue;
                    break;
                }
            }
        }catch (Exception e) {
            System.out.println("BLOCK:" + 4);
            e.printStackTrace();
        }

        String tissueTerm = er.getTissueTerm();
        String cellType = er.getCellTypeTerm();
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

                if (cellType != null && !cellType.equals("")) {
                    if (hasDelivery) {
                        String url = "/toolkit/data/experiments/experiment/" + ex.getExperimentId() + "?resultType=Delivery&tissue=" + tissueTerm + "&cellType=" + cellType;
                        tm.addDelivery(organSystem, tissueTerm + " (" + cellType + ")", url);
                    }
                    if (hasEditing) {
                        String url = "/toolkit/data/experiments/experiment/" + ex.getExperimentId() + "?resultType=Editing&tissue=" + tissueTerm + "&cellType=" + cellType;
                        tm.addEditing(organSystem, tissueTerm + " (" + cellType + ")", url);
                    }
                    if (hasBiomarker) {
                        String url = "/toolkit/data/experiments/experiment/" + ex.getExperimentId() + "?resultType=Biomarker&tissue=" + tissueTerm + "&cellType=" + cellType;
                        tm.addBiomarker(organSystem, tissueTerm + " (" + cellType + ")", url);
                    }
                } else {
                    if (hasDelivery) {
                        String url = "/toolkit/data/experiments/experiment/" + ex.getExperimentId() + "?resultType=Delivery&tissue=" + tissueTerm + "&cellType=";
                        tm.addDelivery(organSystem, tissueTerm, url);
                    }
                    if (hasEditing) {
                        String url = "/toolkit/data/experiments/experiment/" + ex.getExperimentId() + "?resultType=Editing&tissue=" + tissueTerm + "&cellType=";
                        tm.addEditing(organSystem, tissueTerm, url);
                    }

                    if (hasBiomarker) {
                        String url = "/toolkit/data/experiments/experiment/" + ex.getExperimentId() + "?resultType=Biomarker&tissue=" + tissueTerm + "&cellType=";
                        tm.addBiomarker(organSystem, tissueTerm, url);
                    }
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

<div style="text-align: center"><h4>Organ&nbsp;System&nbsp;Overview</h4></div>
<div style="margin-left:70%"> <a href="/toolkit/data/experiments/experiment/<%=ex.getExperimentId()%>?resultType=all"><button class="btn btn-primary btn-sm">View Experimental Details</button></a></div>
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
                                        for (String tissue: rootTissues.keySet()) {
                                            String tissueTerm=rootTissues.get(tissue);
                                            String displayTissue= "";
                                            if(!tm.getChildTerms().get(tissue).isEmpty()){
                                                displayTissue="<a href='#"+tissue+"'>"+tissue+"</a>";
                                            }else displayTissue=tissue;
                                    %>
                                    <% if (first) { if(targetTissues.contains(tissueTerm)){ %>
                                    <div class="tissue-control-header-first" style="color:orchid"><%=displayTissue%></div>
                                    <%}else{%>
                                    <div class="tissue-control-header-first"><%=displayTissue%></div>
                                    <%}%>
                                    <% first = false; %>
                                    <% } else { if(targetTissues.contains(tissueTerm)) {%>
                                    <div class="tissue-control-header" style="color:orchid"><%=displayTissue%></div>

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

                            <% for (String condition: conditions) { %>
                            <tr>
                                <td  width="65"></td>

                                <% for (String tissueKey: rootTissues.keySet()) {
                                    String tissue=rootTissues.get(tissueKey);
                                    if(targetTissues.contains(tissue)){%>
                                <td width="40" style="border:1px solid black;">
                                    <div class="tissue-control-cell">
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
                                </td>
                                <%}else{%>
                                <td width="40" style="border:1px solid black;">
                                    <div class="tissue-control-cell" style="padding: 2px">
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
        <td>
            <table style="border:1px solid black;" border="1" align="center">
                <tr>
                    <td style="padding:10px;">
                        <table>
                            <tr>
                                <td>Legend:</td>
                                <td>&nbsp;</td>
                                <td align="center">
                                    <table>
                                        <tr>
                                            <td><div style="border:1px solid black;"> <div class="legend-delivery"></div></div></td><td>Delivery Efficiency</td>
                                        </tr>
                                        <tr>
                                            <td><div style="border:1px solid black;"><div class="legend-editing"></div></div></td><td>Editing Efficiency</td>
                                        </tr>
                                        <tr>
                                            <td><div style="border:1px solid black;"><div class="legend-biomarker"></div></div></td><td>Biomarker Detection</td>
                                        </tr>
                                        <tr>
                                            <td><div style="border:3px solid #DA70D6;background-color: white;width:22px;height:22px "></div></td><td>Target Tissue</td>
                                        </tr>
                                        <tr>
                                            <td><div style="border:1px solid black;background-color: #F7F7F7;width:22px;height:22px "></div></td><td>Not Available</td>
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
    <tr><td><hr></td></tr>
    <tr><td>&nbsp;
        <div >
        <div class="row" style="margin-left:50%">

        <div class="col">
            <%if (access.isAdmin(p) && !SCGEContext.isProduction()) {%>
            <form id="updateTargetTissueForm" action="/toolkit/data/experiments/update/experiment/<%=ex.getExperimentId()%>">
                <input type="hidden" name="experimentRecordIds" id= "experimentRecordIds" value=""/>
                <button class="btn btn-warning btn-sm" onclick="updateTargetTissue()">Update Target Tissue</button>
            </form>
            <% } %>
        </div>

        <div class="col" >
            <form id="viewSelectedTissues" action="/toolkit/data/experiments/experiment/<%=ex.getExperimentId()%>">
                <input type="hidden" name="selectedTissues" id= "selectedTissues" value=""/>
                <button class="btn btn-primary btn-sm" onclick="viewSelectedTissues()">View Selected Tissues</button>
            </form>
        </div>
        </div>
        </div>
    </td>

    </tr>
    <tr>
        <td>
            <table align="center" tyle="border:1px solid #F7F7F7;margin-left:30px;" border="0" width="700">
                <tr>
                    <td colspan="2" style="font-size:16px; font-weight:700;">Analyze Data Sets Available for this Experiment</td><!--td style="font-size:16px; font-weight:700;" align="center">Delivery</td><td style="font-size:16px; font-weight:700;" align="center">Editing</td-->
                    <!--td> <a href="/toolkit/data/experiments/experiment/<%=ex.getExperimentId()%>?resultType=all"><button class="btn btn-primary btn-sm">View Experimental Details</button></a></td-->

                </tr>
                <% for (String organ: tm.getChildTerms().keySet()) {
                    if (!tm.getChildTerms().get(organ).isEmpty()) {
                %>

                <tr>
                    <td colspan="2" style="font-size:20px;padding-top:10px;" id="<%=organ%>"><input id="<%=organ%>" type="checkbox" onchange="checkTissues('<%=organ%>', this)">&nbsp;<%=organ%></td>
                    <td></td><td></td>
                </tr>
                <tr>
                        <% for (String childTerm: tm.getChildTerms().get(organ).keySet()) {
                    String upCaseChildTerm = childTerm.substring(0,1).toUpperCase() + childTerm.substring(1,childTerm.length());
            %>

                <tr>


                    <td width="100">&nbsp;</td><td style="padding-right:5px; border-bottom:1px solid black;border-color:#770C0E; font-size:14px;">
                    <%
                        String tissueTermExtracted=null;
                        if(upCaseChildTerm.indexOf("(")>0){
                            tissueTermExtracted=upCaseChildTerm.substring(0,upCaseChildTerm.indexOf("(")).trim().toLowerCase();
                        }else{
                            tissueTermExtracted=upCaseChildTerm.trim().toLowerCase();
                        }
                    %>

                    <input type="checkbox" name="<%=organ%>" class="selectedTissue" value="<%=tissueTermExtracted%>">
                    <a href="/toolkit/data/experiments/experiment/<%=ex.getExperimentId()%>?tissue=<%=tissueTermExtracted%>"><%=upCaseChildTerm%></a>
                    <% if (targetTissues2.containsKey(childTerm)) { %>
                    &nbsp;<span style="color:#DA70D6">(TARGET)</span>
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
                <% } %>
                    <%}} %>
                </tr>

            </table>
        </td>
    </tr>
</table>


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