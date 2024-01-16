<%@ page import="edu.mcw.scge.web.TissueMapper" %>
<%@ page import="edu.mcw.scge.datamodel.ExperimentRecord" %>
<%@ page import="edu.mcw.scge.datamodel.ExperimentResultDetail" %>
<%@ page import="java.util.*" %>
<%
    TissueMapper tm = new TissueMapper();



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

<%


    Set<String> targetTissues=new HashSet<>();
    Set<Long> targetTissueRecordIds=new HashSet<>();

    //This is a total hack and needs to be refactored
    HashMap<String,Long> targetTissues2=new HashMap<String,Long>();
    HashMap<String,Long> nonTargetTissues2=new HashMap<String,Long>();

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
    }

%>
<div class="recordFilterBlock">
<table>

    <% for (String organ: tm.getChildTerms().keySet()) {
        if (!tm.getChildTerms().get(organ).isEmpty()) {
    %>

    <tr>
        <td colspan="2"  id="<%=organ%>"><%=organ%>
            <ul>
                <% for (String childTerm: tm.getChildTerms().get(organ).keySet()) {
                    String upCaseChildTerm = childTerm.substring(0,1).toUpperCase() + childTerm.substring(1,childTerm.length());

            String tissueTermExtracted=null;
            if(upCaseChildTerm.indexOf("(")>0){
                tissueTermExtracted=upCaseChildTerm.substring(0,upCaseChildTerm.indexOf("(")).trim().toLowerCase();
            }else{
                tissueTermExtracted=upCaseChildTerm.trim().toLowerCase();
            }
        %>

       <li style="list-style-type: none"> <input type="checkbox" onclick="applyFilters(this)" name="tissue"  id="<%=tissueTermExtracted%>" value="<%=tissueTermExtracted%>" checked>
        <%=upCaseChildTerm%>
        <% if (targetTissues2.containsKey(childTerm)) { %>
        &nbsp;<span style="color:#DA70D6">(TARGET)</span>
        <%} %>
       </li>
                <%}%></ul>
        </td>
    </tr>
    <%}} %>
</table>
</div>