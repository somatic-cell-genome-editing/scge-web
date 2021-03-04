package edu.mcw.scge.controller;

import com.google.gson.Gson;
import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.configuration.UserService;
import edu.mcw.scge.dao.implementation.*;
import edu.mcw.scge.datamodel.*;
import edu.mcw.scge.service.db.DBService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.PathVariable;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
        req.setAttribute("experiments", records);
        req.setAttribute("study", study);
        req.setAttribute("action", "Experiments");
        req.setAttribute("page", "/WEB-INF/jsp/tools/experiments");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        return null;
    }


    @RequestMapping(value="/experiment/{experimentId}")
    public String getExperimentsByExperimentId(HttpServletRequest req, HttpServletResponse res,
                                               @PathVariable(required = false) int experimentId
    ) throws Exception {

        Person p=userService.getCurrentUser(req.getSession());

        if(!access.isLoggedIn()) {
            return "redirect:/";
        }

        List<ExperimentRecord> records = edao.getExperimentRecords(experimentId);
        Study study = sdao.getStudyById(records.get(0).getStudyId()).get(0);

        if (!access.hasStudyAccess(study,p)) {
            req.setAttribute("page", "/WEB-INF/jsp/error");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            return null;

        }
        List<String> labels=new ArrayList<>();
        Map<String, List<Double>> plotData=new HashMap<>();
        List<Double> replicate1 = new ArrayList<>();
        List<Double> replicate2 = new ArrayList<>();
        List<Double> replicate3 = new ArrayList<>();
        List<Double> mean = new ArrayList<>();
        HashMap<Integer,Double> resultMap = new HashMap<>();
        HashMap<Integer,List<ExperimentResultDetail>> resultDetail = new HashMap<>();
        for(ExperimentRecord record:records) {
            labels.add("\"" + record.getExperimentName() + "\"");
            List<ExperimentResultDetail> experimentResults = dbService.getExperimentalResults(record.getExperimentRecordId());
            resultDetail.put(record.getExperimentRecordId(),experimentResults);
            int noOfSamples = 0;
            double average = 0;
            for(ExperimentResultDetail result: experimentResults){
                noOfSamples = experimentResults.get(0).getNumberOfSamples();
                if(result.getReplicate() == 1) {
                    replicate1.add(Math.round(Double.valueOf(result.getResult()) * 100) / 100.0);
                }
                if(result.getReplicate() == 2) {
                    replicate2.add(Math.round(Double.valueOf(result.getResult()) * 100) / 100.0);
                }
                if(result.getReplicate() == 3) {
                    replicate3.add(Math.round(Double.valueOf(result.getResult()) * 100) / 100.0);
                }
               average += Double.valueOf(result.getResult());
            }
            average = average/noOfSamples;
            average = Math.round(average * 100.0) / 100.0;
            mean.add(average);
            resultMap.put(record.getExperimentRecordId(),average);
        }

        plotData.put("Replicate-1", replicate1);
        plotData.put("Replicate-2", replicate2);
        plotData.put("Replicate-3", replicate3);
        plotData.put("Mean",mean);
        req.setAttribute("experiments",labels);
        req.setAttribute("plotData",plotData);
        req.setAttribute("experimentRecords", records);
        req.setAttribute("resultDetail",resultDetail);
        req.setAttribute("resultMap",resultMap);
        req.setAttribute("study", study);
        req.setAttribute("action", "Experiment Records");
        req.setAttribute("page", "/WEB-INF/jsp/tools/experimentRecords");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        return null;
    }
    @RequestMapping(value="/experiment/{experimentId}/record/{expRecordId}")
    public String getExperimentRecords(HttpServletRequest req, HttpServletResponse res,
                                       @PathVariable(required = false) int experimentId,
                                       @PathVariable(required = false) int expRecordId) throws Exception {
        Person p = userService.getCurrentUser(req.getSession());

        if (!access.isLoggedIn()) {
            return "redirect:/";
        }

        List<ExperimentRecord> records = edao.getExperimentRecords(experimentId);
        Study study = sdao.getStudyById(records.get(0).getStudyId()).get(0);

        if (!access.hasStudyAccess(study, p)) {
            req.setAttribute("page", "/WEB-INF/jsp/error");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            return null;

        }

        req.setAttribute("experimentRecords", records);
        if (records.size() > 0) {
            ExperimentRecord r = records.get(0);
            edu.mcw.scge.datamodel.Model m = dbService.getModelById(r.getModelId());
            List<ReporterElement> reporterElements = dbService.getReporterElementsByExpRecId(r.getExperimentRecordId());
            List<AnimalTestingResultsSummary> results = dbService.getAnimalTestingResultsByExpRecId(r.getExperimentRecordId());
            List<ExperimentResultDetail> experimentResults = dbService.getExperimentalResults(r.getExperimentRecordId());

            for (AnimalTestingResultsSummary s : results) {
                List<Sample> samples = dbService.getSampleDetails(s.getSummaryResultsId(), s.getExpRecId());
                s.setSamples(samples);
            }
            List<Delivery> deliveryList = dbService.getDeliveryVehicles(r.getDeliverySystemId());
            List<Editor> editorList = dbService.getEditors(r.getEditorId());
            List<Guide> guideList = dbService.getGuides(r.getGuideId());
            List<ApplicationMethod> applicationMethod = dbService.getApplicationMethodsById(r.getApplicationMethodId());
            req.setAttribute("applicationMethod", applicationMethod);
            req.setAttribute("deliveryList", deliveryList);
            req.setAttribute("editorList",editorList);
            req.setAttribute("guideList",guideList);
            //req.setAttribute("experiment",e);
            req.setAttribute("experiment", r);
            req.setAttribute("model", m);
            req.setAttribute("reporterElements", reporterElements);
            req.setAttribute("experimentResults",experimentResults);
            req.setAttribute("experimentResults",experimentResults);
            req.setAttribute("results", results);
            System.out.println("Applications: "+ applicationMethod.size()+
                    "\ndelivery lsit: "+deliveryList.size()+
            "\nexperimentRecords: "+records.size()+
            "\nmodel:" +m.getName()+
                    "\nreporters:"+reporterElements.size()+
                    "\nresults:"+experimentResults.size());

            List<String> regionList = new ArrayList<>();
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
            System.out.println("REGION LSIT"+regionList.size());
            Gson gson = new Gson();
            String regionListJson = gson.toJson(regionList);
            req.setAttribute("regionListJson", regionListJson);
            req.setAttribute("json", json);

        }
        req.setAttribute("action", "Experiment Report");

        req.setAttribute("study", study);
        req.setAttribute("page", "/WEB-INF/jsp/tools/experiment");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        return null;
    }

}
