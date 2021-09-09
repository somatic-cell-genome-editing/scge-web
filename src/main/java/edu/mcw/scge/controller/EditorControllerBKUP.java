package edu.mcw.scge.controller;

import edu.mcw.scge.configuration.UserService;
import edu.mcw.scge.dao.implementation.*;
import edu.mcw.scge.datamodel.*;
import edu.mcw.scge.datamodel.Vector;
import edu.mcw.scge.process.customLabels.CustomUniqueLabels;
import edu.mcw.scge.service.db.DBService;
import edu.mcw.scge.service.es.IndexServices;
import edu.mcw.scge.web.UI;
import org.elasticsearch.action.search.SearchResponse;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import edu.mcw.scge.configuration.Access;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;


@RequestMapping(value="/data/editors")
public class EditorControllerBKUP {
    CustomUniqueLabels customLabels=new CustomUniqueLabels();
    GrantDao grantDao=new GrantDao();
    DBService dbService = new DBService();
    ExperimentDao experimentDao= new ExperimentDao();
    StudyDao studyDao=new StudyDao();
    GuideDao guideDao=new GuideDao();
    ExperimentResultDao experimentResultDao=new ExperimentResultDao();
    @RequestMapping(value="/search")
    public String getEditors(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        EditorDao dao = new EditorDao();
        Access access = new Access();
        UserService us = new UserService();
        Person p = us.getCurrentUser(req.getSession());

        List<Editor> records = null;


        if (access.isInDCCorNIHGroup(p)) {
            records = dao.getAllEditors();
        }else {
            records = dao.getAllEditors(us.getCurrentUser(req.getSession()).getId());
        }


        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a>");
        req.setAttribute("editors", records);
        req.setAttribute("action", "Genome Editors");
        req.setAttribute("page", "/WEB-INF/jsp/tools/editors");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

    @RequestMapping(value="/editor")
    public String getEditor(HttpServletRequest req, HttpServletResponse res) throws Exception {
        EditorDao editorDao = new EditorDao();
        Editor editor= editorDao.getEditorById(Long.parseLong(req.getParameter("id"))).get(0);
        UserService userService = new UserService();
        Person p=userService.getCurrentUser(req.getSession());
        Access access = new Access();

        if(!access.isLoggedIn()) {
            return "redirect:/";
        }

        if (!access.hasEditorAccess(editor,p)) {
            req.setAttribute("page", "/WEB-INF/jsp/error");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            return null;

        }

        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a> / <a href='/toolkit/data/editors/search'>Editors</a>");
        req.setAttribute("editor", editor);
        req.setAttribute("action", "Genome Editor: " + UI.replacePhiSymbol(editor.getSymbol()));
        req.setAttribute("page", "/WEB-INF/jsp/tools/editor");

        List<Study> studies = studyDao.getStudiesByEditor(editor.getId());
        req.setAttribute("studies", studies);

        List<ExperimentRecord> experimentRecords = experimentDao.getExperimentsByEditor(editor.getId());
        req.setAttribute("experimentRecords",experimentRecords);

        HashMap<Long,List<Guide>> guideMap = new HashMap<>();
        HashMap<Long,List<Vector>> vectorMap = new HashMap<>();
        HashMap<Long,ExperimentRecord> recordMap = new HashMap<>();

        for(ExperimentRecord record:experimentRecords) {
            guideMap.put(record.getExperimentRecordId(), dbService.getGuidesByExpRecId(record.getExperimentRecordId()));
            vectorMap.put(record.getExperimentRecordId(), dbService.getVectorsByExpRecId(record.getExperimentRecordId()));
            recordMap.put(record.getExperimentRecordId(),record);

        }

        GuideDao guideDao = new GuideDao();
        List<Guide> guides = guideDao.getGuidesByEditor(editor.getId());
        req.setAttribute("guides", guides);
        req.setAttribute("guideMap", guideMap);
        req.setAttribute("vectorMap", vectorMap);
/********************************/
        if(studies!=null && studies.size()>0) {
            List<Plot> plots = new ArrayList<>();
            for (Study study : studies) {
                Grant grant = grantDao.getGrantByGroupId(study.getGroupId());
                List<Experiment> experiments = experimentDao.getExperimentsByStudy(study.getStudyId());
                for (Experiment experiment : experiments) {
                    List<Editor> otherEditorsOfThis=editorDao
                            .getEditorByExperimentId(experiment.getExperimentId());
                    List<Object> comparableEditors=otherEditorsOfThis.stream().filter(o->o.getId()!=editor.getId()).collect(Collectors.toList());
                    List<ExperimentRecord> records=experimentDao.getExperimentsByEditorNExperiment(editor.getId(),experiment.getExperimentId());
                    Map<String, Integer> objectSizeMap = customLabels.getObjectSizeMap(records);
                    List<String> uniqueFields = customLabels.getLabelFields(records, objectSizeMap, grant.getGrantInitiative());
                    Plot plot = new Plot();
                    plot.setComparableObjects(comparableEditors);
                    if(comparableEditors.size()>0 && uniqueFields.size()==1){
                        buildComparablePlotData(otherEditorsOfThis, experiment, grant, plot);
                    }else

                        buildPlot(records,grant,experiment,plot,editor); //actual editor plot

                    if(plot.getPlotData()!=null && plot.getPlotData().size()>0) {
                        plots.add(plot);
                    }

                }
            }

            req.setAttribute("plots", plots);
        }
        /***************************************/
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
    public void buildPlot(List<ExperimentRecord> records, Grant grant,Experiment experiment, Plot plot, Editor editor) throws Exception {
        Map<String, Integer> objectSizeMap = customLabels.getObjectSizeMap(records);
        List<String> uniqueFields = customLabels.getLabelFields(records, objectSizeMap, grant.getGrantInitiative());
        List<String> labels = new ArrayList<>();
        Map<String, List<Double>> plotData = new HashMap<>();
        HashMap<Integer, List<Integer>> replicateResult = new HashMap<>();
        LinkedList mean = new LinkedList();
        HashMap<Long, Double> resultMap = new HashMap<>();
        TreeMap<Long, List<ExperimentResultDetail>> resultDetail = new TreeMap<>();
        String efficiency = null;
        int i = 0;
        List values = new ArrayList<>();
        List<String> resultTypes = dbService.getResultTypes(experiment.getExperimentId());

        HashMap<Long,ExperimentRecord> recordMap = new HashMap<>();
        for(ExperimentRecord record:records) {
            recordMap.put(record.getExperimentRecordId(),record);

        }
        List<ExperimentResultDetail> experimentResults = experimentResultDao.getResultsByEditorId(experiment.getExperimentId(), editor.getId());
        HashMap<Long, List<ExperimentResultDetail>> experimentResultsMap = new HashMap<>();
        for (ExperimentResultDetail er : experimentResults) {
            if (experimentResultsMap != null && experimentResultsMap.containsKey(er.getResultId()))
                values = experimentResultsMap.get(er.getResultId());
            else values = new ArrayList<>();

            values.add(er);
            experimentResultsMap.put(er.getResultId(), values);
        }
        objectSizeMap.put("resultTypes", resultTypes.size());
        for (Long resultId : experimentResultsMap.keySet()) {
            List<ExperimentResultDetail> erdList = experimentResultsMap.get(resultId);
            //   resultDetail.put(resultId, experimentResultsMap.get(resultId));
            resultDetail.put(resultId, erdList);
            long expRecId = experimentResultsMap.get(resultId).get(0).getExperimentRecordId();
            //    guideMap.put(expRecId, dbService.getGuidesByExpRecId(expRecId));
            //    vectorMap.put(expRecId, dbService.getVectorsByExpRecId(expRecId));
            ExperimentRecord record = recordMap.get(expRecId);

            StringBuilder label = new StringBuilder();
            if (record != null) {
                try {
                    label = (customLabels.getLabel(record, grant.getGrantInitiative(), objectSizeMap, uniqueFields, resultId));
                    labels.add("\"" + label + "\"");
                    record.setExperimentName(label.toString());
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            if (!experimentResultsMap.get(resultId).get(0).getUnits().contains("signal")) {

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

        plotData.put(editor.getSymbol(), mean);
        plot.setPlotData(plotData);
        plot.setExperiment(experiment);
        plot.setTickLabels(labels);
        plot.setReplicateResult(replicateResult);
    /*    req.setAttribute("experiments", labels);
        req.setAttribute("plotData", plotData);
        req.setAttribute("experiment", experiment);
        req.setAttribute("replicateResult", replicateResult);*/
        if ( experimentResults.size() > 0) {
            //   if (experimentResults.get(0).getResultType() != null && !experimentResults.get(0).getResultType().equals("")) {
            //  req.setAttribute("resultType", experimentResults.get(0).getResultType());
            plot.setTitle(experimentResults.get(0).getResultType());
            //    }
            //      req.setAttribute("yaxisLabel", experimentResults.get(0).getResultType() + " " + experimentResults.get(0).getUnits());
            plot.setYaxisLabel(experimentResults.get(0).getResultType() + " " + experimentResults.get(0).getUnits());
            if (uniqueFields.size() == 1) {
                if (uniqueFields.get(0).equalsIgnoreCase("name")) {
                    //  req.setAttribute("xaxisLabel", "Experiment Conditions");
                    plot.setXaxisLabel("Experiment Conditions");
                } else if (uniqueFields.get(0).equalsIgnoreCase("delivery")) {
                    //  req.setAttribute("xaxisLabel", "Delivery Systems");
                    plot.setXaxisLabel("Delivery Systems");
                } else
                    //   req.setAttribute("xaxisLabel", uniqueFields.get(0).toUpperCase() + "S");
                    plot.setXaxisLabel(uniqueFields.get(0).toUpperCase() + "S");

            } else
                //  req.setAttribute("xaxisLabel", uniqueFields.stream().map(s -> s.toUpperCase() + "S").collect(Collectors.joining(",")));
                plot.setXaxisLabel(uniqueFields.stream().map(s -> s.toUpperCase()).collect(Collectors.joining(",")));
        }

    }
    public void buildComparableDataSets(List<ExperimentRecord> records, Grant grant,Experiment experiment, Plot plot, Editor editor) throws Exception {
        Map<String, Integer> objectSizeMap = customLabels.getObjectSizeMap(records);
        List<String> uniqueFields = customLabels.getLabelFields(records, objectSizeMap, grant.getGrantInitiative());
        List<String> labels = new ArrayList<>();
        Map<String, LinkedList<Double>> plotData = new HashMap<>();
        HashMap<Integer, List<Integer>> replicateResult = new HashMap<>();
        HashMap<Long,ExperimentRecord> recordMap = new HashMap<>();

        for(ExperimentRecord record:records) {

            recordMap.put(record.getExperimentRecordId(),record);

        }
        LinkedList mean = new LinkedList();
        HashMap<Long, Double> resultMap = new HashMap<>();
        TreeMap<Long, List<ExperimentResultDetail>> resultDetail = new TreeMap<>();
        String efficiency = null;
        int i = 0;
        List values = new ArrayList<>();
        List<String> resultTypes = dbService.getResultTypes(experiment.getExperimentId());


        List<ExperimentResultDetail> experimentResults = experimentResultDao.getResultsByEditorId(experiment.getExperimentId(), editor.getId());
        HashMap<Long, List<ExperimentResultDetail>> experimentResultsMap = new HashMap<>();
        for (ExperimentResultDetail er : experimentResults) {
            if (experimentResultsMap != null && experimentResultsMap.containsKey(er.getResultId()))
                values = experimentResultsMap.get(er.getResultId());
            else values = new ArrayList<>();

            values.add(er);
            experimentResultsMap.put(er.getResultId(), values);
        }
        objectSizeMap.put("resultTypes", resultTypes.size());
        for (Long resultId : experimentResultsMap.keySet()) {
            List<ExperimentResultDetail> erdList = experimentResultsMap.get(resultId);
            //   resultDetail.put(resultId, experimentResultsMap.get(resultId));
            resultDetail.put(resultId, erdList);
            long expRecId = experimentResultsMap.get(resultId).get(0).getExperimentRecordId();
            //    guideMap.put(expRecId, dbService.getGuidesByExpRecId(expRecId));
            //    vectorMap.put(expRecId, dbService.getVectorsByExpRecId(expRecId));
            ExperimentRecord record = recordMap.get(expRecId);

            StringBuilder label = new StringBuilder();
            if (record != null) {
                try {
                    label = (customLabels.getLabel(record, grant.getGrantInitiative(), objectSizeMap, uniqueFields, resultId));
                    labels.add("\"" + label + "\"");
                    record.setExperimentName(label.toString());
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            if (!experimentResultsMap.get(resultId).get(0).getUnits().contains("signal")) {

                double average = 0;

                for (ExperimentResultDetail result : experimentResultsMap.get(resultId)) {
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

        plotData.put(editor.getSymbol(), mean);
        plot.getPlotData().putAll(plotData);
        plot.setExperiment(experiment);
        Set<String> tickLabels=new HashSet<>();
        tickLabels.addAll(plot.getTickLabels());
        tickLabels.addAll(labels);
        plot.setTickLabels(new ArrayList<>(tickLabels));
        plot.getReplicateResult().putAll(replicateResult);

        if ( experimentResults.size() > 0) {
            //   if (experimentResults.get(0).getResultType() != null && !experimentResults.get(0).getResultType().equals("")) {
            //  req.setAttribute("resultType", experimentResults.get(0).getResultType());
            plot.setTitle(experimentResults.get(0).getResultType());
            //    }
            //      req.setAttribute("yaxisLabel", experimentResults.get(0).getResultType() + " " + experimentResults.get(0).getUnits());
            plot.setYaxisLabel(experimentResults.get(0).getResultType() + " " + experimentResults.get(0).getUnits());
            if (uniqueFields.size() == 1) {
                if (uniqueFields.get(0).equalsIgnoreCase("name")) {
                    //  req.setAttribute("xaxisLabel", "Experiment Conditions");
                    plot.setXaxisLabel("Experiment Conditions");
                } else if (uniqueFields.get(0).equalsIgnoreCase("delivery")) {
                    //  req.setAttribute("xaxisLabel", "Delivery Systems");
                    plot.setXaxisLabel("Delivery Systems");
                } else
                    //   req.setAttribute("xaxisLabel", uniqueFields.get(0).toUpperCase() + "S");
                    plot.setXaxisLabel(uniqueFields.get(0).toUpperCase() + "S");

            } else
                //  req.setAttribute("xaxisLabel", uniqueFields.stream().map(s -> s.toUpperCase() + "S").collect(Collectors.joining(",")));
                plot.setXaxisLabel(uniqueFields.stream().map(s -> s.toUpperCase()).collect(Collectors.joining(",")));
        }

    }
    public void buildComparablePlotData(List<Editor> allComparableEditors, Experiment experiment, Grant grant, Plot plot) throws Exception {
        LinkedHashMap<String, List<Double>> plotData=new LinkedHashMap<>();
        TreeMap<String, List<Double>> uniqueFieldDataMap=new TreeMap<>();

        List<ExperimentRecord> allRecords=new ArrayList<>();
        Set<String> uniqueFields=new HashSet<>();
        List<ExperimentResultDetail> experimentResults=new ArrayList<>();
        TreeMap<String, List<ExperimentRecord>> recordsMap=new TreeMap<>();
        for(Editor editor: allComparableEditors) {
            List<ExperimentRecord> records = experimentDao.getExperimentsByEditorNExperiment(editor.getId(), experiment.getExperimentId());
            recordsMap.put(editor.getSymbol(), records);
            allRecords.addAll(records);
            Map<String, Integer> objectSizeMap = customLabels.getObjectSizeMap(records);
            uniqueFields.addAll(customLabels.getLabelFields(records, objectSizeMap, grant.getGrantInitiative()));
            experimentResults = experimentResultDao.getResultsByEditorId(experiment.getExperimentId(), editor.getId());

        }
        System.out.println("record Map Key set:"+recordsMap.keySet());
        if(uniqueFields.size()==1) {
            String uniqueField= String.join("", uniqueFields);
            uniqueFieldDataMap=groupByUniqueField(recordsMap, uniqueField);
            TreeMap<String, Map<String, Double>>  uniqueFieldEditorValueMap=populateUniqueFieldDataMap(recordsMap, uniqueFieldDataMap, uniqueField, experimentResults, allComparableEditors);
            LinkedList<String> labels = new LinkedList<>();
            switch (uniqueField){
                case "guide":
                    mapGuidePlotData(uniqueField, labels,uniqueFieldEditorValueMap, recordsMap,plotData );
                    break;
                case "tissue":
                    mapTissuePlotData(uniqueField, labels,uniqueFieldEditorValueMap, recordsMap,plotData );
                    break;
                default:
                    mapNamePlotData(uniqueField, labels,uniqueFieldEditorValueMap, recordsMap,plotData );
                    break;
            }
            for(Map.Entry entry:plotData.entrySet()){
                System.out.println(entry.getKey()+"\t"+ entry.getValue().toString());
            }

            plot.setPlotData(plotData);
            plot.setTickLabels(new ArrayList<>(labels));
            plot.setExperiment(experiment);
            if ( experimentResults.size() > 0) {

                plot.setTitle(experimentResults.get(0).getResultType());
                plot.setYaxisLabel(experimentResults.get(0).getResultType() + " " + experimentResults.get(0).getUnits());
                if (uniqueFields.size() == 1) {
                    if (uniqueField.equalsIgnoreCase("name")) {
                        //  req.setAttribute("xaxisLabel", "Experiment Conditions");
                        plot.setXaxisLabel("Experiment Conditions");
                    } else if (uniqueField.equalsIgnoreCase("delivery")) {
                        //  req.setAttribute("xaxisLabel", "Delivery Systems");
                        plot.setXaxisLabel("Delivery Systems");
                    } else
                        //   req.setAttribute("xaxisLabel", uniqueFields.get(0).toUpperCase() + "S");
                        plot.setXaxisLabel(uniqueField.toUpperCase() + "");

                } else
                    //  req.setAttribute("xaxisLabel", uniqueFields.stream().map(s -> s.toUpperCase() + "S").collect(Collectors.joining(",")));
                    plot.setXaxisLabel(uniqueFields.stream().map(s -> s.toUpperCase()).collect(Collectors.joining(",")));
            }

        }

    }
    public void mapGuidePlotData(String uniqueField,LinkedList<String> labels,TreeMap<String, Map<String, Double>> uniqueFieldEditorValueMap,TreeMap<String,
            List<ExperimentRecord>> recordsMap, LinkedHashMap<String, List<Double>> plotData ){
        if(uniqueField.equalsIgnoreCase("guide")){

            labels.addAll(uniqueFieldEditorValueMap.keySet());
            for(Map.Entry editor: recordsMap.entrySet()) {
                List<Double> values=new ArrayList<>();
                String editorSymbol = (String) editor.getKey();
                for(Map.Entry e:uniqueFieldEditorValueMap.entrySet()){
                    Map<String, Double> valueMap= (Map<String, Double>) e.getValue(); //editor and result
                    for(Map.Entry result: valueMap.entrySet()){
                        if(editorSymbol.equalsIgnoreCase(result.getKey().toString())){
                            if( plotData.get(editorSymbol)!=null){
                                values.addAll(plotData.get(editorSymbol));
                            }
                            values.add((Double) result.getValue());
                        }
                    }


                }
                plotData.put(editorSymbol, values);
            }
        }
    }
    public void mapTissuePlotData(String uniqueField,LinkedList<String> labels,TreeMap<String, Map<String, Double>> uniqueFieldEditorValueMap,TreeMap<String,
            List<ExperimentRecord>> recordsMap, LinkedHashMap<String, List<Double>> plotData ){
        if(uniqueField.equalsIgnoreCase("tissue")){

            labels.addAll(uniqueFieldEditorValueMap.keySet());
            for(Map.Entry editor: recordsMap.entrySet()) {
                List<Double> values=new ArrayList<>();
                String editorSymbol = (String) editor.getKey();
                for(Map.Entry e:uniqueFieldEditorValueMap.entrySet()){
                    Map<String, Double> valueMap= (Map<String, Double>) e.getValue(); //editor and result
                    for(Map.Entry result: valueMap.entrySet()){
                        if(editorSymbol.equalsIgnoreCase(result.getKey().toString())){
                            if( plotData.get(editorSymbol)!=null){
                                values.addAll(plotData.get(editorSymbol));
                            }
                            values.add((Double) result.getValue());
                        }
                    }


                }
                plotData.put(editorSymbol, values);
            }
        }
    }
    public void mapNamePlotData(String uniqueField,LinkedList<String> labels,TreeMap<String, Map<String, Double>> uniqueFieldEditorValueMap,TreeMap<String,
            List<ExperimentRecord>> recordsMap, LinkedHashMap<String, List<Double>> plotData ){
        if(uniqueField.equalsIgnoreCase("name")){

            labels.addAll(uniqueFieldEditorValueMap.keySet());
            for(Map.Entry editor: recordsMap.entrySet()) {
                List<Double> values=new ArrayList<>();
                String editorSymbol = (String) editor.getKey();
                for(Map.Entry e:uniqueFieldEditorValueMap.entrySet()){
                    Map<String, Double> valueMap= (Map<String, Double>) e.getValue(); //editor and result
                    for(Map.Entry result: valueMap.entrySet()){
                        if(editorSymbol.equalsIgnoreCase(result.getKey().toString())){
                            if( plotData.get(editorSymbol)!=null){
                                values.addAll(plotData.get(editorSymbol));
                            }
                            values.add((Double) result.getValue());
                        }
                    }


                }
                plotData.put(editorSymbol, values);
            }
        }
    }
    public  TreeMap<String, List<Double>> groupByUniqueField(Map<String, List<ExperimentRecord>> recordsMap, String  uniqueField) throws Exception {
        TreeMap<String, List<Double>> plotMap=new TreeMap<>();
        for(Map.Entry e:recordsMap.entrySet()){
            List<ExperimentRecord> records= (List<ExperimentRecord>) e.getValue();
            for(ExperimentRecord record:records){
                if(uniqueField.equalsIgnoreCase("guide")){
                    plotMap.put( guideDao.getGuidesByExpRecId(record.getExperimentRecordId()).stream()
                            .map(g->g.getGuide()).collect(Collectors.joining(" ")), new LinkedList<>());
                }
                if(uniqueField.equalsIgnoreCase("name")){
                    plotMap.put( record.getExperimentName(), new LinkedList<>());
                }
                if(uniqueField.equalsIgnoreCase("tissue")){
                    plotMap.put( record.getTissueTerm(), new LinkedList<>());
                }
            }}
        return plotMap;
    }
    public TreeMap<String, Map<String, Double>> populateUniqueFieldDataMap(Map<String, List<ExperimentRecord>> recordsMap,TreeMap<String, List<Double>> uniqueFieldDataMap, String uniqueField,List<ExperimentResultDetail> experimentResults,List<Editor> allEditors ) throws Exception {
        System.out.println("UNIQUE GUIDE KEY FIELD DATA SET:"+ uniqueFieldDataMap.keySet().toString());
        TreeMap<String, Map<String, Double>>  guideEditorValueMap=new TreeMap<>();
        if(uniqueField.equalsIgnoreCase("guide")){
            for(String guideKey:uniqueFieldDataMap.keySet()) {
                Map<String, Double> valueMap=new HashMap<>();
                for (Map.Entry e : recordsMap.entrySet()) {
                    List<ExperimentRecord> records = (List<ExperimentRecord>) e.getValue();
                    String editor = (String) e.getKey();
                    for (ExperimentRecord record : records) {
                        String guide = guideDao.getGuidesByExpRecId(record.getExperimentRecordId()).stream()
                                .map(g -> g.getGuide()).collect(Collectors.joining(" "));
                        if (guide.equalsIgnoreCase(guideKey)) {
                            for (ExperimentResultDetail erd : experimentResultDao.getResultsByExperimentRecId(record.getExperimentRecordId())) {
                                if (erd.getReplicate() == 0) {
                                    if (erd.getResult() != null && !erd.getResult().equals("")) {
                                        Double value = (Math.round(Double.parseDouble(erd.getResult()) * 100) / 100.0);
                                        valueMap.put(editor, value);
                                    }
                                }
                            }

                        }
                    }

                }
                if(valueMap.size()<allEditors.size()){
                    Set<String> editors=valueMap.keySet();
                    for(Map.Entry e:recordsMap.entrySet()){
                        String editor= (String) e.getKey();
                        if(!editors.contains(editor)){
                            valueMap.put(editor, 0.0);
                        }
                    }

                }
                guideEditorValueMap.put(guideKey, valueMap);
            }
        }
        if(uniqueField.equalsIgnoreCase("name")){
            for(String key:uniqueFieldDataMap.keySet()) {
                Map<String, Double> valueMap=new HashMap<>();
                for (Map.Entry e : recordsMap.entrySet()) {
                    List<ExperimentRecord> records = (List<ExperimentRecord>) e.getValue();
                    String editor = (String) e.getKey();
                    for (ExperimentRecord record : records) {
                        String name = record.getExperimentName();
                        if (name.equalsIgnoreCase(key)) {
                            for (ExperimentResultDetail erd : experimentResultDao.getResultsByExperimentRecId(record.getExperimentRecordId())) {
                                if (erd.getReplicate() == 0) {
                                    if (erd.getResult() != null && !erd.getResult().equals("")) {
                                        Double value = (Math.round(Double.parseDouble(erd.getResult()) * 100) / 100.0);
                                        valueMap.put(editor, value);
                                    }
                                }
                            }

                        }
                    }

                }
                if(valueMap.size()<allEditors.size()){
                    Set<String> editors=valueMap.keySet();
                    for(Map.Entry e:recordsMap.entrySet()){
                        String editor= (String) e.getKey();
                        if(!editors.contains(editor)){
                            valueMap.put(editor, 0.0);
                        }
                    }

                }
                guideEditorValueMap.put(key, valueMap);
            }
        }
        if(uniqueField.equalsIgnoreCase("tissue")){
            for(String key:uniqueFieldDataMap.keySet()) {
                Map<String, Double> valueMap=new HashMap<>();
                for (Map.Entry e : recordsMap.entrySet()) {
                    List<ExperimentRecord> records = (List<ExperimentRecord>) e.getValue();
                    String editor = (String) e.getKey();
                    for (ExperimentRecord record : records) {
                        String tissue = record.getTissueTerm();
                        if (tissue.equalsIgnoreCase(key)) {
                            for (ExperimentResultDetail erd : experimentResultDao.getResultsByExperimentRecId(record.getExperimentRecordId())) {
                                if (erd.getReplicate() == 0) {
                                    if (erd.getResult() != null && !erd.getResult().equals("")) {
                                        Double value = (Math.round(Double.parseDouble(erd.getResult()) * 100) / 100.0);
                                        valueMap.put(editor, value);
                                    }
                                }
                            }

                        }
                    }

                }
                if(valueMap.size()<allEditors.size()){
                    Set<String> editors=valueMap.keySet();
                    for(Map.Entry e:recordsMap.entrySet()){
                        String editor= (String) e.getKey();
                        if(!editors.contains(editor)){
                            valueMap.put(editor, 0.0);
                        }
                    }

                }
                guideEditorValueMap.put(key, valueMap);
            }
        }
        for(Map.Entry e:guideEditorValueMap.entrySet()){
            System.out.println(e.getKey()+ "\t"+ e.getValue().toString());
        }
        return guideEditorValueMap;
    }


}
