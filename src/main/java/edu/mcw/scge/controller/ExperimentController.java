package edu.mcw.scge.controller;

import com.google.gson.Gson;
import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.configuration.UserService;
import edu.mcw.scge.dao.implementation.*;
import edu.mcw.scge.datamodel.*;
import edu.mcw.scge.datamodel.Vector;
import edu.mcw.scge.service.db.DBService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.PathVariable;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping(value="/data/experiments")
public class ExperimentController extends UserController {
    ExperimentDao edao = new ExperimentDao();
    ExperimentRecordDao erDao=new ExperimentRecordDao();
    StudyDao sdao = new StudyDao();
    Access access=new Access();
    DBService dbService=new DBService();
    UserService userService=new UserService();
    @RequestMapping(value="/search")
    public String getAllExperiments(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        ExperimentDao edao=new ExperimentDao();

        List<Experiment>  records = edao.getAllExperiments();
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a>");
        req.setAttribute("experiments", records);
        req.setAttribute("action", "Experiments");
        req.setAttribute("page", "/WEB-INF/jsp/tools/experiments");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;

    }

    @RequestMapping(value="/study/{studyId}")
    public String getExperimentsByStudyId( HttpServletRequest req, HttpServletResponse res,
                                           @PathVariable(required = false) int studyId) throws Exception {
        Person p=userService.getCurrentUser(req.getSession());
        Study study = sdao.getStudyById(studyId).get(0);

        if(!access.isLoggedIn()) {
            return "redirect:/";
        }

        if (!access.hasStudyAccess(study,p)) {
            req.setAttribute("page", "/WEB-INF/jsp/error");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            return null;

        }

        List<Experiment> records = edao.getExperimentsByStudy(studyId);
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a> / <a href='/toolkit/data/studies/search'>Studies</a>");
        req.setAttribute("experiments", records);
        req.setAttribute("study", study);
        req.setAttribute("action", "Experiments");
        req.setAttribute("page", "/WEB-INF/jsp/tools/experiments");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        return null;
    }
    @RequestMapping(value="/experiment/experimentRecords")
    public String getAllExperimentRecords(HttpServletRequest req, HttpServletResponse res
    ) throws Exception {

        Person p = userService.getCurrentUser(req.getSession());

        if (!access.isLoggedIn()) {
            return "redirect:/";
        }

        List<ExperimentRecord> records = new ArrayList<>();
        List<ExperimentRecord> allRecords = edao.getAllExperimentRecords();
        Set<Integer> studies = new TreeSet<>();
        HashMap<Integer,String> studyNames = new HashMap<>();
        for (ExperimentRecord r : allRecords) {
            studies.add(r.getStudyId());
        }

        for (int s : studies){
            Study study = sdao.getStudyById(s).get(0);
            if(!access.hasStudyAccess(study,p))
                studies.remove(s);
            else {
                String piname = study.getPi();
                String label = piname.split(",")[0];
                int index=label.lastIndexOf(" ");
                label = label.substring(index);
                studyNames.put(s,label);
            }
        }

        if (studies.size() == 0) {
            req.setAttribute("page", "/WEB-INF/jsp/error");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            return null;
        }

        Map<String, List<Double>> plotData=new HashMap<>();
        List<Double> mean = new ArrayList<>();
        HashMap<Long,Double> resultMap = new HashMap<>();
        HashMap<Long,List<ExperimentResultDetail>> resultDetail = new HashMap<>();
        HashMap<Long,String> labels = new HashMap<>();
        int noOfSamples = 0;
        for(ExperimentRecord record:allRecords) {
            if(studies.contains(record.getStudyId())) {
                records.add(record);
                String label = studyNames.get(record.getStudyId());
                labels.put(record.getExperimentRecordId(),"\"" + label+ "-" + record.getExperimentRecordId() + "\"");
                List<ExperimentResultDetail> experimentResults = dbService.getExperimentalResults(record.getExperimentRecordId());
                resultDetail.put(record.getExperimentRecordId(), experimentResults);
                double average = 0;
                for (ExperimentResultDetail result : experimentResults) {
                    noOfSamples = result.getNumberOfSamples();
                    if (result.getResult() != null && !result.getResult().isEmpty())
                        average += Double.valueOf(result.getResult());
                }
                average = average / noOfSamples;
                average = Math.round(average * 100.0) / 100.0;
                mean.add(average);
                resultMap.put(record.getExperimentRecordId(), average);
            }
        }

        plotData.put("Mean",mean);
        req.setAttribute("experiments",labels);
        req.setAttribute("plotData",plotData);
        req.setAttribute("experimentRecords", records);
        req.setAttribute("resultDetail",resultDetail);
        req.setAttribute("resultMap",resultMap);
       // req.setAttribute("study", study);
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a> / <a href='/toolkit/data/studies/search'>Studies</a>");
        req.setAttribute("action", "All Experiment Records");
        req.setAttribute("page", "/WEB-INF/jsp/tools/allExperimentRecords");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        return null;
    }
    @RequestMapping(value="/experiment/compareExperiments/{experimentId1}/{experimentId2}")
    public String compareExperiments(HttpServletRequest req, HttpServletResponse res,
                                     @PathVariable(required = false) long experimentId1,
                                     @PathVariable(required = false) long experimentId2) throws Exception {

        Person p = userService.getCurrentUser(req.getSession());

        if (!access.isLoggedIn()) {
            return "redirect:/";
        }

        List<ExperimentRecord> exp1 = edao.getExperimentRecords(experimentId1);
        List<ExperimentRecord> exp2 = edao.getExperimentRecords(experimentId2);
        Set<Integer> studies = new TreeSet<>();
        studies.add(exp1.get(0).getStudyId());
        studies.add(exp2.get(0).getStudyId());
        List<Study> studiesList = new ArrayList<>();
        for (int s : studies){
            Study study = sdao.getStudyById(s).get(0);
            studiesList.add(study);
            if(!access.hasStudyAccess(study,p)){
                req.setAttribute("page", "/WEB-INF/jsp/error");
                req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
                return null;
            }
        }

        ExperimentRecord expr1 = exp1.get(0);
        ExperimentRecord expr2 = exp2.get(0);

        Experiment e1 = edao.getExperiment(experimentId1);
        Experiment e2 = edao.getExperiment(experimentId2);

        List<ExperimentRecord> allRecords = new ArrayList<>();
        allRecords.addAll(exp1);
        allRecords.addAll(exp2);

        HashMap<String,Double> exp1Results = new HashMap<>();
        HashMap<String,Double> exp2Results = new HashMap<>();
        List<Double> exp1Mean = new ArrayList<>();
        List<Double> exp2Mean = new ArrayList<>();
        HashMap<Long,String> labels = new HashMap<>();
        Set<String> labelNames = new TreeSet<>();
        int noOfSamples = 0;

        String editor1 = "\"" + exp1.get(0).getEditorSymbol() + "\"";
        String editor2 = "\"" + exp2.get(0).getEditorSymbol() + "\"";
        String units="";
        List<Guide> guides1 = dbService.getGuidesByExpRecId(exp1.get(0).getExperimentRecordId());
        List<Guide> guides2 = dbService.getGuidesByExpRecId(exp2.get(0).getExperimentRecordId());

        for(ExperimentRecord record:allRecords) {
            labels.put(record.getDeliverySystemId(),record.getDeliverySystemType());
            List<ExperimentResultDetail> experimentResults = dbService.getExperimentalResults(record.getExperimentRecordId());

            double average = 0;
            for (ExperimentResultDetail result : experimentResults) {
                noOfSamples = result.getNumberOfSamples();
                units = "\"" + result.getResultType() + " in " + experimentResults.get(0).getUnits() + "\"";
                if (result.getReplicate() == 0)
                    average = Double.valueOf(result.getResult());
            }

            if(experimentId1 == record.getExperimentId()) {
                exp1Results.put(record.getDeliverySystemType(), average);
            }
            else {
                exp2Results.put(record.getDeliverySystemType(),average);
            }
        }
        for(Long id:labels.keySet()) {
            String name = labels.get(id);
            exp1Mean.add(exp1Results.get(name));
            exp2Mean.add(exp2Results.get(name));
            labelNames.add("\"" + name +"\"" ); //add quotes for labels on graph
        }

        req.setAttribute("action", "Compare Experiments");
        req.setAttribute("labelNames",labelNames);
        req.setAttribute("labels",labels);
        req.setAttribute("exp1Mean",exp1Mean);
        req.setAttribute("exp2Mean",exp2Mean);
        req.setAttribute("editor1",editor1);
        req.setAttribute("editor2",editor2);
        req.setAttribute("exp1Results",exp1Results);
        req.setAttribute("exp2Results",exp2Results);
        req.setAttribute("units",units);
        req.setAttribute("studies",studiesList);
        req.setAttribute("expRecord1",expr1);
        req.setAttribute("expRecord2",expr2);
        req.setAttribute("exp1",e1);
        req.setAttribute("exp2",e2);
        req.setAttribute("guides1",guides1);
        req.setAttribute("guides2",guides2);
        req.setAttribute("page", "/WEB-INF/jsp/tools/compareExperiments");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        return null;
    }
 /*   @RequestMapping(value="/experiment/{experimentId}")
    public String getExperimentsByExperimentId(HttpServletRequest req, HttpServletResponse res,
                                               @PathVariable(required = true) long experimentId
    ) throws Exception {

        String resultType = req.getParameter("resultType");
        String tissue = req.getParameter("tissue");
        String cellType = req.getParameter("cellType");

        Person p=userService.getCurrentUser(req.getSession());

        if(!access.isLoggedIn()) {
            return "redirect:/";
        }

        List<ExperimentRecord> records = edao.getExperimentRecords(experimentId);
        Study study = sdao.getStudyById(records.get(0).getStudyId()).get(0);
        GrantDao grantDao=new GrantDao();
        Grant grant=grantDao.getGrantByGroupId(study.getGroupId());
        Experiment e = edao.getExperiment(experimentId);

        if (!access.hasStudyAccess(study,p)) {
            req.setAttribute("page", "/WEB-INF/jsp/error");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            return null;

        }
        List<String> labels=new ArrayList<>();
        Map<String, List<Double>> plotData=new HashMap<>();
        HashMap<Integer,List<Integer>> replicateResult = new HashMap<>();
        List mean = new ArrayList<>();
        HashMap<Long,Double> resultMap = new HashMap<>();
        TreeMap<Long,List<ExperimentResultDetail>> resultDetail = new TreeMap<>();
        String efficiency = null;
        int i=0;
        List values = new ArrayList<>();
        List<String> resultTypes = dbService.getResultTypes(experimentId);
        HashMap<Long,List<Guide>> guideMap = new HashMap<>();
        HashMap<Long,List<Vector>> vectorMap = new HashMap<>();

        List<ExperimentResultDetail> experimentResults = dbService.getExpResultsByExpId(experimentId);
        HashMap<Long,List<ExperimentResultDetail>> experimentResultsMap = new HashMap<>();
        for(ExperimentResultDetail er:experimentResults){
            if(experimentResultsMap != null && experimentResultsMap.containsKey(er.getResultId()))
                values = experimentResultsMap.get(er.getResultId());
            else values = new ArrayList<>();

            values.add(er);
            System.out.println(er.getResultId());
            experimentResultsMap.put(er.getResultId(),values);
        }
        HashMap<Long,ExperimentRecord> recordMap = new HashMap<>();
        Map<String, Integer> objectSizeMap=getObjectSizeMap(records);
        objectSizeMap.put("resultTypes", resultTypes.size());
        for(ExperimentRecord rec:records)
            recordMap.put(rec.getExperimentRecordId(),rec);
        for (Long resultId : experimentResultsMap.keySet()) {
            List<ExperimentResultDetail> erdList=experimentResultsMap.get(resultId);
         //   resultDetail.put(resultId, experimentResultsMap.get(resultId));
            resultDetail.put(resultId, erdList);
            long expRecId = experimentResultsMap.get(resultId).get(0).getExperimentRecordId();
            guideMap.put(expRecId, dbService.getGuidesByExpRecId(expRecId));
            vectorMap.put(expRecId, dbService.getVectorsByExpRecId(expRecId));

            if (!experimentResultsMap.get(resultId).get(0).getUnits().contains("present")) {
                ExperimentRecord record = recordMap.get(expRecId);
                StringBuilder label=getLabel(record, grant.getGrantInitiative(),objectSizeMap);
                labels.add("\"" + label + "\"");
                record.setExperimentName(label.toString());
                double average = 0;

                for (ExperimentResultDetail result : experimentResultsMap.get(resultId)) {
                    efficiency = "\"" + result.getResultType() + " in " + result.getUnits() + "\"";
                    if (result.getReplicate() != 0) {
                        values = replicateResult.get(result.getReplicate());
                        if (values == null)
                            values = new ArrayList<>();
                        if (result.getResult() == null || result.getResult().isEmpty())
                            values.add(null);
                        else {
                            values.add(Math.round(Double.valueOf(result.getResult()) * 100) / 100.0);
                        }

                        replicateResult.put(result.getReplicate(), values);
                    } else average = Double.valueOf(result.getResult());
                }
                mean.add(average);
                resultMap.put(resultId, average);

            }
        }

            plotData.put("Mean",mean);

            List<String> tissues = edao.getExperimentRecordTissueList(experimentId);
      //      List<String> conditions = edao.getExperimentRecordConditionList(experimentId);
        List<String> conditions = labels.stream().map(l->l.replaceAll("\"","")).distinct().collect(Collectors.toList());

            req.setAttribute("tissues",tissues);
            req.setAttribute("conditions",conditions);
            req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a> / <a href='/toolkit/data/studies/search'>Studies</a> / <a href='/toolkit/data/experiments/study/" + study.getStudyId() + "'>Experiments</a>");
            req.setAttribute("replicateResult",replicateResult);
            req.setAttribute("experiments",labels);
            req.setAttribute("plotData",plotData);
            req.setAttribute("efficiency",efficiency);
            req.setAttribute("experimentRecordsMap", recordMap);
            req.setAttribute("resultDetail",resultDetail);
            req.setAttribute("resultMap",resultMap);
            req.setAttribute("study", study);
            req.setAttribute("experiment",e);
            req.setAttribute("guideMap",guideMap);
            req.setAttribute("vectorMap",vectorMap);
            req.setAttribute("resultType",resultType);
            req.setAttribute("tissue",tissue);
            req.setAttribute("cellType",cellType);
            req.setAttribute("action", "Experiment Records");
            req.setAttribute("page", "/WEB-INF/jsp/tools/experimentRecords");
            req.setAttribute("objectSizeMap", objectSizeMap);
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }*/
    @RequestMapping(value="/experiment/{experimentId}")
    public String getExperimentsByExperimentId(HttpServletRequest req, HttpServletResponse res,
                                               @PathVariable(required = true) long experimentId
    ) throws Exception {

        String resultType = req.getParameter("resultType");
        String tissue = req.getParameter("tissue");
        String cellType = req.getParameter("cellType");

        Person p=userService.getCurrentUser(req.getSession());

        if(!access.isLoggedIn()) {
            return "redirect:/";
        }
        List<ExperimentRecord> records = edao.getExperimentRecords(experimentId);
        List<String> tissues = edao.getExperimentRecordTissueList(experimentId);

        Study study = sdao.getStudyById(records.get(0).getStudyId()).get(0);
        GrantDao grantDao=new GrantDao();
        Grant grant=grantDao.getGrantByGroupId(study.getGroupId());
        Map<String, Integer> objectSizeMap=getObjectSizeMap(records);
        Experiment e = edao.getExperiment(experimentId);
        if (!access.hasStudyAccess(study,p)) {
            req.setAttribute("page", "/WEB-INF/jsp/error");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            return null;

        }
        List<String> uniqueFields=getLabelFields(records, objectSizeMap, grant.getGrantInitiative());
        System.out.print("UNIQUE FIELDS:"+ uniqueFields.toString());
        List<String> labels=new ArrayList<>();
        Map<String, List<Double>> plotData=new HashMap<>();
        HashMap<Integer,List<Integer>> replicateResult = new HashMap<>();
        List mean = new ArrayList<>();
        Map<String, List<Double>> meanMap=new HashMap<>();
        HashMap<Long,Double> resultMap = new HashMap<>();
        TreeMap<Long,List<ExperimentResultDetail>> resultDetail = new TreeMap<>();
        String efficiency = null;
        int i=0;
        List values = new ArrayList<>();
        List<String> resultTypes = dbService.getResultTypes(experimentId);
        HashMap<Long,List<Guide>> guideMap = new HashMap<>();
        HashMap<Long,List<Vector>> vectorMap = new HashMap<>();

        List<ExperimentResultDetail> experimentResults = dbService.getExpResultsByExpId(experimentId);
        HashMap<Long,List<ExperimentResultDetail>> experimentResultsMap = new HashMap<>();
        for(ExperimentResultDetail er:experimentResults){
            if(experimentResultsMap != null && experimentResultsMap.containsKey(er.getResultId()))
                values = experimentResultsMap.get(er.getResultId());
            else values = new ArrayList<>();

            values.add(er);
            System.out.println(er.getResultId());
            experimentResultsMap.put(er.getResultId(),values);
        }
        HashMap<Long,ExperimentRecord> recordMap = new HashMap<>();
        objectSizeMap.put("resultTypes", resultTypes.size());
        for(ExperimentRecord rec:records)
            recordMap.put(rec.getExperimentRecordId(),rec);
        for (Long resultId : experimentResultsMap.keySet()) {
            List<ExperimentResultDetail> erdList=experimentResultsMap.get(resultId);
            //   resultDetail.put(resultId, experimentResultsMap.get(resultId));
            resultDetail.put(resultId, erdList);
            long expRecId = experimentResultsMap.get(resultId).get(0).getExperimentRecordId();
            guideMap.put(expRecId, dbService.getGuidesByExpRecId(expRecId));
            vectorMap.put(expRecId, dbService.getVectorsByExpRecId(expRecId));

            if (!experimentResultsMap.get(resultId).get(0).getUnits().contains("present")) {
                ExperimentRecord record = recordMap.get(expRecId);
                if(experimentId!=18000000014L) {
                    StringBuilder label = getLabel(record, grant.getGrantInitiative(), objectSizeMap, uniqueFields);
                    if(tissue!=null && !tissue.equals("") || tissues.size()>0) {
                        String labelTrimmed=new String();
                        if(record.getCellType()!=null && record.getTissueTerm()!=null)
                            labelTrimmed= label.toString().replace(record.getTissueTerm(), "").replace(record.getCellType(),"");
                        else if(record.getTissueTerm()!=null)
                            labelTrimmed= label.toString().replace(record.getTissueTerm(), "");
                        else labelTrimmed= label.toString();
                        labels.add("\"" +  labelTrimmed + "\"");
                        record.setExperimentName(labelTrimmed);
                    }
                    else {
                        labels.add("\"" + label + "\"");

                        record.setExperimentName(label.toString());
                    }
                }else{
                    labels.add("\"" + record.getExperimentName() + "\"");
                    record.setExperimentName(record.getExperimentName());

                }
                double average = 0;

                for (ExperimentResultDetail result : experimentResultsMap.get(resultId)) {
                    efficiency = "\"" + result.getResultType() + " in " + result.getUnits() + "\"";
                    if (result.getReplicate() != 0) {
                        values = replicateResult.get(result.getReplicate());
                        if (values == null)
                            values = new ArrayList<>();
                        if (result.getResult() == null || result.getResult().isEmpty())
                            values.add(null);
                        else {
                            values.add(Math.round(Double.valueOf(result.getResult()) * 100) / 100.0);
                        }

                        replicateResult.put(result.getReplicate(), values);
                    } else average = Double.valueOf(result.getResult());
                }
                mean.add(average);
                resultMap.put(resultId, average);

            }
        }

        plotData.put("Mean",mean);

        //      List<String> conditions = edao.getExperimentRecordConditionList(experimentId);
        List<String> conditions = labels.stream().map(l->l.replaceAll("\"","")).distinct().collect(Collectors.toList());

        req.setAttribute("tissues",tissues);
        req.setAttribute("conditions",conditions);
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a> / <a href='/toolkit/data/studies/search'>Studies</a> / <a href='/toolkit/data/experiments/study/" + study.getStudyId() + "'>Experiments</a>");
        req.setAttribute("replicateResult",replicateResult);
        req.setAttribute("experiments",labels);
        req.setAttribute("plotData",plotData);
        req.setAttribute("efficiency",efficiency);
        req.setAttribute("experimentRecordsMap", recordMap);
        req.setAttribute("resultDetail",resultDetail);
        req.setAttribute("resultMap",resultMap);
        req.setAttribute("study", study);
        req.setAttribute("experiment",e);
        req.setAttribute("guideMap",guideMap);
        req.setAttribute("vectorMap",vectorMap);
        req.setAttribute("resultType",resultType);
        req.setAttribute("tissue",tissue);
        req.setAttribute("cellType",cellType);
        req.setAttribute("action", "Experiment Records");
        req.setAttribute("page", "/WEB-INF/jsp/tools/experimentRecords");
        req.setAttribute("objectSizeMap", objectSizeMap);
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
    public List<String> getLabelFields(List<ExperimentRecord> records, Map<String, Integer> objectSizeMap, String initiative) throws Exception {
        List<String> uniqueFields=new ArrayList<>();
        boolean flag=false;
        for(Map.Entry e:objectSizeMap.entrySet()){
            int value= (int) e.getValue();
            String field= (String) e.getKey();
            if(value==records.size()){
                uniqueFields.add(field);
                flag=true;
                break;
            }
        }
        if(flag)
        return uniqueFields;
        else{

            for (String s : objectSizeMap.keySet()) {
                Set<String> uniqueLabels=new HashSet<>();

                for(ExperimentRecord record: records) {
                            if (objectSizeMap.get(s) > 1) {
                                    if(s.equalsIgnoreCase("delivery"))
                                    uniqueLabels.add(record.getDeliverySystemName());
                                if(s.equalsIgnoreCase("editor"))
                                    uniqueLabels.add(record.getEditorSymbol());
                                if(s.equalsIgnoreCase("vector")) {
                                    String vector=new String();
                                    for(Vector v: dbService.getVectorsByExpRecId(record.getExperimentRecordId()))
                                       vector+=v.getName() + " ";
                                    uniqueLabels.add(vector);
                                }
                                if(s.equalsIgnoreCase("guide")) {
                                    String guide = new String();
                                    for (Guide g : dbService.getGuidesByExpRecId(record.getExperimentRecordId()))
                                        // labels.add("\"" + record.getExperimentName() + "\"");
                                       guide+=(g.getGuide())+" ";
                                    uniqueLabels.add(guide);
                                }
                                if(s.equalsIgnoreCase("applicationMethod") ){
                                    uniqueLabels.add(record.getInjectionFrequency()+" "+record.getDosage());

                                }
                                if(s.equalsIgnoreCase("model")){
                                    uniqueLabels.add(String.valueOf(record.getModelId()));

                                }
                                if(s.equalsIgnoreCase("tissue")){
                                    uniqueLabels.add( record.getTissueTerm() + " ");

                                }
                                }
                            }
                        if(uniqueLabels.size()==records.size()){
                            uniqueFields.add(s);
                            return uniqueFields;
                        }

                        }


                for (String s : objectSizeMap.keySet()) {
                    if (objectSizeMap.get(s) > 1) {
                    for (String t : objectSizeMap.keySet()) {
                        if (objectSizeMap.get(t) > 1 && !s.equalsIgnoreCase(t)) {
                            Set<String> uniqueLabels=new HashSet<>();
                        for (ExperimentRecord record : records) {
                            if (s.equalsIgnoreCase("delivery")) {
                                if (t.equalsIgnoreCase("editor"))
                                    uniqueLabels.add(record.getDeliverySystemName()+" "+record.getEditorSymbol());
                                if (t.equalsIgnoreCase("vector")) {
                                    String vector = new String();
                                    for (Vector v : dbService.getVectorsByExpRecId(record.getExperimentRecordId()))
                                        vector += v.getName() + " ";
                                    uniqueLabels.add(record.getDeliverySystemName()+" "+vector);
                                }
                                if (t.equalsIgnoreCase("guide")) {
                                    String guide = new String();
                                    for (Guide g : dbService.getGuidesByExpRecId(record.getExperimentRecordId()))
                                        // labels.add("\"" + record.getExperimentName() + "\"");
                                        guide += (g.getGuide()) + " ";
                                    uniqueLabels.add(record.getDeliverySystemName()+" "+guide);
                                }
                                if(t.equalsIgnoreCase("applicationMethod") ){
                                    uniqueLabels.add(record.getDeliverySystemName()+" "+record.getInjectionFrequency()+"-"+record.getDosage());

                                }
                                if(t.equalsIgnoreCase("model")){
                                    uniqueLabels.add(record.getDeliverySystemName()+" "+String.valueOf(record.getModelId()));

                                }
                                if(t.equalsIgnoreCase("tissue")){
                                    uniqueLabels.add( record.getDeliverySystemName()+" "+record.getTissueTerm());

                                }
                            }
                            if (s.equalsIgnoreCase("editor")) {
                                if (t.equalsIgnoreCase("delivery"))
                                    uniqueLabels.add(record.getEditorSymbol()+" "+ record.getDeliverySystemName());
                                if (t.equalsIgnoreCase("vector")) {
                                    String vector = new String();
                                    for (Vector v : dbService.getVectorsByExpRecId(record.getExperimentRecordId()))
                                        vector += v.getName() + " ";
                                    uniqueLabels.add(record.getEditorSymbol()+" "+vector);
                                }
                                if (t.equalsIgnoreCase("guide")) {
                                    String guide = new String();
                                    for (Guide g : dbService.getGuidesByExpRecId(record.getExperimentRecordId()))
                                        // labels.add("\"" + record.getExperimentName() + "\"");
                                        guide += (g.getGuide()) + " ";
                                    uniqueLabels.add(record.getEditorSymbol()+" "+guide);
                                }
                                if(t.equalsIgnoreCase("applicationMethod") ){
                                    uniqueLabels.add(record.getEditorSymbol()+" "+record.getInjectionFrequency()+"-"+record.getDosage());

                                }
                                if(t.equalsIgnoreCase("model")){
                                    uniqueLabels.add(record.getEditorSymbol()+" "+String.valueOf(record.getModelId()));

                                }
                                if(t.equalsIgnoreCase("tissue")){
                                    uniqueLabels.add(record.getEditorSymbol()+" "+ record.getTissueTerm() + " ");

                                }
                            }
                            if (s.equalsIgnoreCase("vector")) {
                                String vector = new String();
                                for (Vector v : dbService.getVectorsByExpRecId(record.getExperimentRecordId()))
                                    vector += v.getName() + " ";
                                if (t.equalsIgnoreCase("delivery"))
                                    uniqueLabels.add(vector+" "+ record.getDeliverySystemName());
                                if (t.equalsIgnoreCase("guide")) {
                                    String guide = new String();
                                    for (Guide g : dbService.getGuidesByExpRecId(record.getExperimentRecordId()))
                                        // labels.add("\"" + record.getExperimentName() + "\"");
                                        guide += (g.getGuide()) + " ";
                                    uniqueLabels.add(vector+" "+guide);
                                }
                                if (t.equalsIgnoreCase("editor"))
                                    uniqueLabels.add(vector+" "+record.getEditorSymbol());
                                if(t.equalsIgnoreCase("applicationMethod") ){
                                    uniqueLabels.add(vector+" "+record.getInjectionFrequency()+" "+record.getDosage());

                                }
                                if(t.equalsIgnoreCase("model")){
                                    uniqueLabels.add(vector+" "+String.valueOf(record.getModelId()));

                                }
                                if(t.equalsIgnoreCase("tissue")){
                                    uniqueLabels.add( vector+" "+record.getTissueTerm());

                                }
                            }
                            if (s.equalsIgnoreCase("guide")) {
                                String guide = new String();
                                for (Guide g : dbService.getGuidesByExpRecId(record.getExperimentRecordId()))
                                    // labels.add("\"" + record.getExperimentName() + "\"");
                                    guide += (g.getGuide()) + " ";
                                if (t.equalsIgnoreCase("editor"))
                                    uniqueLabels.add(guide+" "+record.getEditorSymbol());
                                if (t.equalsIgnoreCase("vector")) {
                                    String vector = new String();
                                    for (Vector v : dbService.getVectorsByExpRecId(record.getExperimentRecordId()))
                                        vector += v.getName() + " ";
                                    uniqueLabels.add(guide+" "+vector);
                                }
                                if (t.equalsIgnoreCase("delivery"))
                                    uniqueLabels.add(guide+" "+ record.getDeliverySystemName());
                                if(t.equalsIgnoreCase("applicationMethod") ){
                                    uniqueLabels.add(guide+" "+record.getInjectionFrequency()+" "+record.getDosage());

                                }
                                if(t.equalsIgnoreCase("model")){
                                    uniqueLabels.add(guide+" "+String.valueOf(record.getModelId()));

                                }
                                if(t.equalsIgnoreCase("tissue")){
                                    uniqueLabels.add( guide+" "+record.getTissueTerm());

                                }
                            }
                            if (s.equalsIgnoreCase("model")) {
                                if (t.equalsIgnoreCase("guide")) {
                                    String guide = new String();
                                    for (Guide g : dbService.getGuidesByExpRecId(record.getExperimentRecordId()))
                                        // labels.add("\"" + record.getExperimentName() + "\"");
                                        guide += (g.getGuide()) + " ";
                                    uniqueLabels.add(record.getModelId()+" "+guide);
                                }
                                if (t.equalsIgnoreCase("editor"))
                                    uniqueLabels.add(record.getModelId()+" "+record.getEditorSymbol());
                                if (t.equalsIgnoreCase("vector")) {
                                    String vector = new String();
                                    for (Vector v : dbService.getVectorsByExpRecId(record.getExperimentRecordId()))
                                        vector += v.getName() + " ";
                                    uniqueLabels.add(record.getModelId()+" "+vector);
                                }
                                if (t.equalsIgnoreCase("delivery"))
                                    uniqueLabels.add(record.getModelId()+" "+ record.getDeliverySystemName());
                                if(t.equalsIgnoreCase("applicationMethod") ){
                                    uniqueLabels.add(record.getModelId()+" "+record.getInjectionFrequency()+" "+record.getDosage());

                                }

                                if(t.equalsIgnoreCase("tissue")){
                                    uniqueLabels.add( record.getModelId()+" "+record.getTissueTerm());

                                }
                            }
                            if (s.equalsIgnoreCase("applicationMethod")) {
                                String dosage=new String();
                                if(record.getInjectionFrequency()!=null && !record.getInjectionFrequency().equals(""))
                                dosage=record.getInjectionFrequency()+" ";
                                dosage+=record.getDosage();
                                if (t.equalsIgnoreCase("guide")) {
                                    String guide = new String();
                                    for (Guide g : dbService.getGuidesByExpRecId(record.getExperimentRecordId()))
                                        // labels.add("\"" + record.getExperimentName() + "\"");
                                        guide += (g.getGuide()) + " ";
                                    uniqueLabels.add(dosage+" "+guide);
                                }
                                if (t.equalsIgnoreCase("editor"))
                                    uniqueLabels.add(dosage+" "+record.getEditorSymbol());
                                if (t.equalsIgnoreCase("vector")) {
                                    String vector = new String();
                                    for (Vector v : dbService.getVectorsByExpRecId(record.getExperimentRecordId()))
                                        vector += v.getName() + " ";
                                    uniqueLabels.add(dosage+" "+vector);
                                }
                                if (t.equalsIgnoreCase("delivery"))
                                    uniqueLabels.add(dosage+" "+ record.getDeliverySystemName());
                                if(t.equalsIgnoreCase("model") ){
                                    uniqueLabels.add(dosage+" "+record.getModelId());

                                }

                                if(t.equalsIgnoreCase("tissue")){
                                    uniqueLabels.add( dosage+" "+record.getTissueTerm());

                                }
                            }
                            if (s.equalsIgnoreCase("tissue")) {
                                if (t.equalsIgnoreCase("guide")) {
                                    String guide = new String();
                                    for (Guide g : dbService.getGuidesByExpRecId(record.getExperimentRecordId()))
                                        // labels.add("\"" + record.getExperimentName() + "\"");
                                        guide += (g.getGuide()) + " ";
                                    uniqueLabels.add(record.getTissueTerm()+" "+guide);
                                }
                                if (t.equalsIgnoreCase("editor"))
                                    uniqueLabels.add(record.getTissueTerm()+" "+record.getEditorSymbol());
                                if (t.equalsIgnoreCase("vector")) {
                                    String vector = new String();
                                    for (Vector v : dbService.getVectorsByExpRecId(record.getExperimentRecordId()))
                                        vector += v.getName() + " ";
                                    uniqueLabels.add(record.getTissueTerm()+" "+vector);
                                }
                                if (t.equalsIgnoreCase("delivery"))
                                    uniqueLabels.add(record.getTissueTerm()+" "+ record.getDeliverySystemName());
                                if(t.equalsIgnoreCase("model") ){
                                    uniqueLabels.add(record.getTissueTerm()+" "+record.getModelId());

                                }

                                if(t.equalsIgnoreCase("applicationMethod")){
                                    uniqueLabels.add( record.getTissueTerm()+" "+record.getInjectionFrequency()+" "+record.getDosage());

                                }
                            }
                        }
                            if (uniqueLabels.size() == records.size()) {
                                uniqueFields.add(s);
                                uniqueFields.add(t);
                                return uniqueFields;
                            }
                    }
                    }

                }
                }


        }
        for(Map.Entry field:objectSizeMap.entrySet()){
            if((int) field.getValue()>1){
                uniqueFields.add((String) field.getKey());
            }
        }
        return uniqueFields;
    }
    public Map<String, Integer> getObjectSizeMap(List<ExperimentRecord> records){
        Map<String, Integer> objectSizeMap=new HashMap<>();
        Set<Long> editors=records.stream().map(r->r.getEditorId()).collect(Collectors.toSet());
        Set<Long> deliveries=records.stream().map(d->d.getDeliverySystemId()).collect(Collectors.toSet());
        Set<Long> models=records.stream().map(d->d.getModelId()).collect(Collectors.toSet());
        Set<String> tissueIds=records.stream().map(d->d.getTissueId()).collect(Collectors.toSet());
        Set<String> cellTypes=records.stream().map(d->d.getCellType()).collect(Collectors.toSet());

        Set<Integer> applicationMethods=records.stream().map(r->r.getApplicationMethodId()).collect(Collectors.toSet());
        Set<String> dosage=records.stream().map(r->r.getDosage()).filter(p->p!=null && !p.equals("")).collect(Collectors.toSet());

        Set<Long> guides= records.stream().map(x -> {
            try {
                return dbService.getGuidesByExpRecId(x.getExperimentRecordId()).stream()
                        .map(Guide::getGuide_id)
                        .collect(Collectors.toSet());
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            return null;
        }).filter(Objects::nonNull).flatMap(Set::stream).collect(Collectors.toSet());
        Set<String> targetLocus= records.stream().map(x -> {
            try {
                return dbService.getGuidesByExpRecId(x.getExperimentRecordId()).stream()
                        .map(Guide::getTargetLocus)
                        .collect(Collectors.toSet());
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            return null;
        }).filter(Objects::nonNull).flatMap(Set::stream).collect(Collectors.toSet());
        Set<Long> vectors= records.stream().map(x -> {
            try {
                return dbService.getVectorsByExpRecId(x.getExperimentRecordId()).stream()
                        .map(g -> g.getVectorId())
                        .collect(Collectors.toSet())
                        ;
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            return null;
        }).filter(Objects::nonNull).flatMap(Set::stream).collect(Collectors.toSet());
        Set<Integer> samples=records.stream().map(x -> {
            try {
                return dbService.getExperimentalResults(x.getExperimentRecordId()).stream()
                        .map(r -> r.getNumberOfSamples())
                        .collect(Collectors.toSet())
                        ;
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            return null;
        }).filter(Objects::nonNull).flatMap(Set::stream).collect(Collectors.toSet());
        if(editors.size()>0){
            objectSizeMap.put("editor", editors.size());
        }
        if(deliveries.size()>0){
            objectSizeMap.put("delivery", deliveries.size());
        }
        if(guides.size()>0){
            objectSizeMap.put("guide", guides.size());
        }
        if(models.size()>0){
            objectSizeMap.put("model", models.size());
        }
        if(vectors.size()>0){
            objectSizeMap.put("vector", vectors.size());
        }
        if(applicationMethods.size()>0){
            objectSizeMap.put("applicationMethod", applicationMethods.size());
        }
        if(dosage.size()>0){
            objectSizeMap.put("dosage", dosage.size());
        }
        if(tissueIds.size()>0){
            objectSizeMap.put("tissue", tissueIds.size());
        }
        if(cellTypes.size()>0){
            objectSizeMap.put("cellType", cellTypes.size());
        }
        if(targetLocus.size()>0){
            objectSizeMap.put("targetLocus", targetLocus.size());
        }
        if(samples.size()>0){
            objectSizeMap.put("samples", samples.size());
        }
        return objectSizeMap;
    }
    public StringBuilder getLabel(ExperimentRecord record,String initiative, Map<String, Integer> objectMapSize) throws Exception {
        StringBuilder label=new StringBuilder();
        System.out.println("INITIATIVE:"+ initiative);
        switch (initiative.toLowerCase()){
            case "delivery vehicle initiative":
                if(objectMapSize.get("delivery")!=null && objectMapSize.get("delivery")>1){
                    label.append( record.getDeliverySystemName()+" ");

                }
                if(objectMapSize.get("applicationMethod")!=null && objectMapSize.get("applicationMethod")>1){
                    label.append(record.getDosage() + " ");

                }
                if(objectMapSize.get("editor")!=null && objectMapSize.get("editor")>1){
                    label.append(record.getEditorSymbol() + " ");

                }
                if(objectMapSize.get("guide")!=null && objectMapSize.get("guide")>1) {
                    for(Guide g: dbService.getGuidesByExpRecId(record.getExperimentRecordId()))
                        // labels.add("\"" + record.getExperimentName() + "\"");
                        label.append(g.getGuide()).append(" ");

                }

                if(objectMapSize.get("vector")!=null && objectMapSize.get("vector")>1){
                    for(Vector v: dbService.getVectorsByExpRecId(record.getExperimentRecordId()))
                        label.append( v.getName() + " ");

                }
                if(objectMapSize.get("model")!=null && objectMapSize.get("model")>1){
                        label.append( record.getModelId() + " ");

                }

                if(objectMapSize.get("tissue")!=null && objectMapSize.get("tissue")>1){
                    label.append( record.getTissueTerm() + " ");

                }
                if(objectMapSize.get("cellType")!=null && objectMapSize.get("cellType")>1){
                    label.append( record.getCellType() + " ");

                }
                break;
            case "new editors initiative":
                if(objectMapSize.get("editor")!=null && objectMapSize.get("editor")>1){
                    label.append(record.getEditorSymbol() + " ");

                }
                if(objectMapSize.get("guide")!=null && objectMapSize.get("guide")>1) {
                    for(Guide g: dbService.getGuidesByExpRecId(record.getExperimentRecordId()))
                        // labels.add("\"" + record.getExperimentName() + "\"");
                        label.append(g.getGuide()).append(" ");

                }

                if(objectMapSize.get("vector")!=null && objectMapSize.get("vector")>1){
                    for(Vector v: dbService.getVectorsByExpRecId(record.getExperimentRecordId()))
                        label.append( v.getName() + " ");

                }
                if(objectMapSize.get("delivery")!=null && objectMapSize.get("delivery")>1){
                    label.append( record.getDeliverySystemType()+" ");

                }
                if(objectMapSize.get("applicationMethod")!=null && objectMapSize.get("applicationMethod")>1){
                    label.append(record.getDosage());

                }
                if(objectMapSize.get("cellType")!=null && objectMapSize.get("cellType")>1){
                    label.append( record.getCellType() + " ");

                }
                break;
             default:
                if(objectMapSize.get("guide")!=null && objectMapSize.get("guide")>1) {
                    for(Guide g: dbService.getGuidesByExpRecId(record.getExperimentRecordId()))
                        // labels.add("\"" + record.getExperimentName() + "\"");
                        label.append(g.getGuide()).append(" ");

                }
                if(objectMapSize.get("editor")!=null && objectMapSize.get("editor")>1){
                    label.append(record.getEditorSymbol() + " ");

                }
                if(objectMapSize.get("vector")!=null && objectMapSize.get("vector")>1){
                    for(Vector v: dbService.getVectorsByExpRecId(record.getExperimentRecordId()))
                        label.append( v.getName() + " ");

                }
                if(objectMapSize.get("delivery") !=null && objectMapSize.get("delivery")>1){
                    label.append( record.getDeliverySystemType()+" ");

                }
                if(objectMapSize.get("applicationMethod")!=null && objectMapSize.get("applicationMethod")>1){
                    label.append(record.getDosage());

                }
                 if(objectMapSize.get("model")!=null && objectMapSize.get("model")>1){
                     label.append(record.getModelId());

                 }
                 if(objectMapSize.get("tissue")!=null && objectMapSize.get("tissue")>1){
                     label.append( record.getTissueTerm() + " ");

                 }
                 if(objectMapSize.get("cellType")!=null && objectMapSize.get("cellType")>1){
                     label.append( record.getCellType() + " ");

                 }
        }

        System.out.println("label:"+label);
        return label;
    }
    public StringBuilder getLabel(ExperimentRecord record,String initiative, Map<String, Integer> objectMapSize, List<String> uniqueFields) throws Exception {
        StringBuilder label=new StringBuilder();
        switch (initiative.toLowerCase()){
            case "rodent testing center":
            case "delivery vehicle initiative":
                System.out.println("CASE: "+ initiative);
                if(uniqueFields.contains("delivery")) {
                    label.append(record.getDeliverySystemName() + " ");
                }
                    for(String s:uniqueFields) {
                        if (s.equalsIgnoreCase("editor")){
                            label.append(record.getEditorSymbol() + " ");

                        }
                        if (s.equalsIgnoreCase("guide") || s.equalsIgnoreCase("targetLocus")){
                            for(Guide g: dbService.getGuidesByExpRecId(record.getExperimentRecordId()))
                                // labels.add("\"" + record.getExperimentName() + "\"");
                                label.append(g.getGuide()).append(" ");
                        }
                        if (s.equalsIgnoreCase("vector")){
                            for(Vector v: dbService.getVectorsByExpRecId(record.getExperimentRecordId()))
                                label.append( v.getName() + " ");

                        }
                        if(s.equalsIgnoreCase("applicationMethod") || s.equalsIgnoreCase("dosage") ){

                            if(record.getInjectionFrequency()!=null) {

                                label.append(record.getInjectionFrequency());
                                label.append(" ");
                            }
                            label.append(record.getDosage());
                        }
                        if(s.equalsIgnoreCase("model")){
                            label.append(record.getModelId());

                        }
                        if(s.equalsIgnoreCase("tissue")){
                            label.append( record.getTissueTerm() + " ");

                        }
                        if(s.equalsIgnoreCase("cellType")){
                            label.append( record.getCellType() + " ");

                        }
                        if(s.equalsIgnoreCase("samples")){
                            label.append( dbService.getExperimentalResults(record.getExperimentRecordId()).get(0).getNumberOfSamples() + " Samples ");

                        }
                    }

                break;
            case "new editors initiative":
                System.out.println("CASE: "+ initiative);

                if(uniqueFields.contains("editor")) {
                    label.append(record.getEditorSymbol() + " ");
                }
                    for (String s : uniqueFields) {
                        if (s.equalsIgnoreCase("delivery")) {
                            label.append(record.getDeliverySystemType() + " ");
                        }
                        if (s.equalsIgnoreCase("guide") || s.equalsIgnoreCase("targetLocus")) {
                            for (Guide g : dbService.getGuidesByExpRecId(record.getExperimentRecordId())) {
                                    // labels.add("\"" + record.getExperimentName() + "\"");
                                    label.append(g.getGuide()).append(" ");

                                }
                            }
                            if (s.equalsIgnoreCase("vector")) {
                                for (Vector v : dbService.getVectorsByExpRecId(record.getExperimentRecordId())) {

                                    label.append(v.getName() + " ");
                                }

                            }
                        if(s.equalsIgnoreCase("applicationMethod") || s.equalsIgnoreCase("dosage") ){

                            if(record.getInjectionFrequency()!=null) {

                                label.append(record.getInjectionFrequency());
                                label.append(" ");
                            }
                            label.append(record.getDosage());
                        }
                        if(s.equalsIgnoreCase("model")){
                            label.append(record.getModelId());

                        }
                        if(s.equalsIgnoreCase("tissue")){
                            label.append( record.getTissueTerm() + " ");

                        }
                        if(s.equalsIgnoreCase("cellType")){
                            label.append( record.getCellType() + " ");

                        }
                        if(s.equalsIgnoreCase("samples")){
                            label.append( dbService.getExperimentalResults(record.getExperimentId()).get(0).getNumberOfSamples() + " Samples ");

                        }
                    }

                break;
            default:
                System.out.println("CASE: DEFAULT:"+ initiative);

                for (String s : uniqueFields) {
                    if (s.equalsIgnoreCase("delivery")) {
                        label.append(record.getDeliverySystemType() + " ");
                    }
                    if (s.equalsIgnoreCase("editor")) {
                        label.append(record.getEditorSymbol() + " ");
                    }
                        if (s.equalsIgnoreCase("guide") || s.equalsIgnoreCase("targetLocus")) {
                            for (Guide g : dbService.getGuidesByExpRecId(record.getExperimentRecordId()))
                                // labels.add("\"" + record.getExperimentName() + "\"");
                                label.append(g.getGuide()).append(" ");
                        }
                        if (s.equalsIgnoreCase("vector")) {
                            for (Vector v : dbService.getVectorsByExpRecId(record.getExperimentRecordId()))
                                label.append(v.getName() + " ");

                        }
                    if(s.equalsIgnoreCase("applicationMethod") || s.equalsIgnoreCase("dosage")){

                        if(record.getInjectionFrequency()!=null) {

                            label.append(record.getInjectionFrequency());
                            label.append(" ");
                        }
                        label.append(record.getDosage());
                    }
                    if(s.equalsIgnoreCase("model")){
                        label.append(record.getModelId());

                    }
                    if(s.equalsIgnoreCase("tissue")){
                        label.append( record.getTissueTerm() + " ");

                    }
                    if(s.equalsIgnoreCase("cellType")){
                        label.append( record.getCellType() + " ");

                    }
                    if(s.equalsIgnoreCase("samples")){
                        label.append( dbService.getExperimentalResults(record.getExperimentId()).get(0).getNumberOfSamples() + " Samples ");

                    }
                    }
        }
        if(label.toString().equals("")){
            System.out.println("LABEL EMPTY: "+ initiative);

            for (String s : uniqueFields) {
                if (s.equalsIgnoreCase("delivery")) {
                    label.append(record.getDeliverySystemType() + " ");
                }
                if (s.equalsIgnoreCase("editor")) {
                    label.append(record.getEditorSymbol() + " ");
                }
                if (s.equalsIgnoreCase("guide") || s.equalsIgnoreCase("targetLocus")) {
                    for (Guide g : dbService.getGuidesByExpRecId(record.getExperimentRecordId()))
                        // labels.add("\"" + record.getExperimentName() + "\"");
                        label.append(g.getGuide()).append(" ");
                }
                if (s.equalsIgnoreCase("vector")) {
                    for (Vector v : dbService.getVectorsByExpRecId(record.getExperimentRecordId()))
                        label.append(v.getName() + " ");

                }
                if(s.equalsIgnoreCase("applicationMethod") || s.equalsIgnoreCase("dosage")){
                    if(record.getInjectionFrequency()!=null) {

                        label.append(record.getInjectionFrequency());
                        label.append(" ");
                    }
                    label.append(record.getDosage());

                }
                if(s.equalsIgnoreCase("model")){
                    label.append(record.getModelId());

                }
                if(s.equalsIgnoreCase("tissue")){
                    label.append( record.getTissueTerm() + " ");

                }
                if(s.equalsIgnoreCase("cellType")){
                    label.append( record.getCellType() + " ");

                }
                if(s.equalsIgnoreCase("samples")){
                    label.append( dbService.getExperimentalResults(record.getExperimentId()).get(0).getNumberOfSamples() + " Samples ");

                }
            }

        }
        System.out.println("label:"+label);
        return label;
    }

    @RequestMapping(value="/experiment/{experimentId}/record/{expRecordId}")
    public String getExperimentRecords(HttpServletRequest req, HttpServletResponse res,
                                       @PathVariable(required = false) long experimentId,
                                       @PathVariable(required = false) long expRecordId) throws Exception {
        Person p = userService.getCurrentUser(req.getSession());

        if (!access.isLoggedIn()) {
            return "redirect:/";
        }
        Experiment experiment = edao.getExperiment(experimentId);
        List<ExperimentRecord> records = edao.getExperimentRecords(experimentId);
        Study study = sdao.getStudyById(records.get(0).getStudyId()).get(0);

        if (!access.hasStudyAccess(study, p)) {
            req.setAttribute("page", "/WEB-INF/jsp/error");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            return null;

        }

        req.setAttribute("experimentRecords", records);
        ExperimentRecord r = new ExperimentRecord();
        if (records.size() > 0) {
            for(ExperimentRecord record: records)
                if(record.getExperimentRecordId() == expRecordId)
                    r = record;
            edu.mcw.scge.datamodel.Model m = dbService.getModelById(r.getModelId());
            //List<ReporterElement> reporterElements = dbService.getReporterElementsByExpRecId(r.getExperimentRecordId());
            //List<AnimalTestingResultsSummary> results = dbService.getAnimalTestingResultsByExpRecId(r.getExperimentRecordId());
            List<ExperimentResultDetail> experimentResultList = dbService.getExperimentalResults(r.getExperimentRecordId());
            List<ExperimentResultDetail> experimentResults=new ArrayList<>();
            for(ExperimentResultDetail e: experimentResultList){
                if(e.getResult() != null && !e.getResult().equals(""))
                    experimentResults.add(e);
            }
           /* for (AnimalTestingResultsSummary s : results) {
                List<Sample> samples = dbService.getSampleDetails(s.getSummaryResultsId(), s.getExpRecId());
                s.setSamples(samples);
            }
            */
            List<Delivery> deliveryList = dbService.getDeliveryVehicles(r.getDeliverySystemId());
            List<Editor> editorList = dbService.getEditors(r.getEditorId());
            List<Guide> guideList = dbService.getGuidesByExpRecId(r.getExperimentRecordId());
            List<Vector> vectorList = dbService.getVectorsByExpRecId(r.getExperimentRecordId());
            List<ApplicationMethod> applicationMethod = dbService.getApplicationMethodsById(r.getApplicationMethodId());
            req.setAttribute("applicationMethod", applicationMethod);
            req.setAttribute("deliveryList", deliveryList);
            req.setAttribute("editorList",editorList);
            req.setAttribute("guideList",guideList);
            req.setAttribute("vectorList",vectorList);
            req.setAttribute("experiment",experiment);
            req.setAttribute("experimentRecord", r);
            req.setAttribute("model", m);
           // req.setAttribute("reporterElements", reporterElements);
            req.setAttribute("experimentResults",experimentResults);
            //req.setAttribute("results", results);
            System.out.println("Applications: "+ applicationMethod.size()+
                    "\ndelivery lsit: "+deliveryList.size()+
            "\nexperimentRecords: "+records.size()+
            "\nmodel:" +m.getName()+
                    "\nresults:"+experimentResults.size());

         /*   List<String> regionList = new ArrayList<>();
            StringBuilder json = new StringBuilder();
            json.append("[");
            for (AnimalTestingResultsSummary s : results) {
                regionList.add(s.getTissueTerm().trim());
                int value = Integer.parseInt(s.getSignalPresent());
                json.append("{\"sample\":\"");
                json.append("A" + "\",");
                json.append("\"gene\":\"" + s.getTissueTerm() + "\",");
                json.append("\"value\":" + value + "},");
            }
            json.append("]");
            Gson gson = new Gson();
            String regionListJson = gson.toJson(regionList);
            req.setAttribute("regionListJson", regionListJson);
            req.setAttribute("json", json);
            */

        }
        req.setAttribute("action", "Condition Details");

        req.setAttribute("study", study);
        req.setAttribute("page", "/WEB-INF/jsp/tools/experiment");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        return null;
    }

}
