package edu.mcw.scge.controller;

import com.google.gson.Gson;
import edu.mcw.scge.dao.implementation.ExperimentDao;
import edu.mcw.scge.dao.implementation.ExperimentRecordDao;
import edu.mcw.scge.dao.implementation.StudyDao;
import edu.mcw.scge.datamodel.*;
import edu.mcw.scge.service.db.DBService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping(value="/data/studies")
public class StudyController {
    DBService dbService=new DBService();

    @RequestMapping(value="/search")
    public String getStudies(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        StudyDao sdao=new StudyDao();
        List<Study> studies = sdao.getStudies();
        req.setAttribute("studies", studies);
        req.setAttribute("action", "Submissions");
        req.setAttribute("page", "/WEB-INF/jsp/tools/studies");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;

    }

    @RequestMapping(value="/experiment")
    public String getStudy(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        /*
        EditorDao dao = new EditorDao();
        Editor editor= dao.getEditorById(Integer.parseInt(req.getParameter("id"))).get(0);
        req.setAttribute("editor", editor);
        req.setAttribute("action", editor.getSymbol());
        req.setAttribute("page", "/WEB-INF/jsp/tools/editor");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
*/
        return null;
    }
    @RequestMapping(value="/search/{studyId}")
    public String getExperimentRecordsByStudy(HttpServletRequest req, HttpServletResponse res, Model model, @PathVariable(required = false) int studyId) throws Exception {
        List<ExperimentRecord> records=dbService.getAllExperimentRecordsByStudyId(studyId);

        System.out.println("EXPERIMENTS: "+ records.size());
        req.setAttribute("experimentRecords", records);
        req.setAttribute("action", "Animal Reporters");
        req.setAttribute("page", "/WEB-INF/jsp/tools/animalReporter");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
    @GetMapping(value="/search/results/{id}")
    public void getResults(@PathVariable String id, HttpServletRequest req, HttpServletResponse res) throws Exception {
        int experimentId= Integer.parseInt(id);
        ExperimentDao dao = new ExperimentDao();
        Experiment e = dao.getExperiment(experimentId);

        List<ExperimentRecord> records=dbService.getExperimentRecordById(experimentId);
        if(records.size()>0) {
            for (ExperimentRecord r : records) {
           //     ExperimentRecord r = records.get(0);
                edu.mcw.scge.datamodel.Model m = dbService.getModelById(r.getModelId());
                List<ReporterElement> reporterElements = dbService.getReporterElementsByExpRecId(r.getExperimentRecordId());
                List<AnimalTestingResultsSummary> results = dbService.getAnimalTestingResultsByExpRecId(r.getExperimentRecordId());
                for (AnimalTestingResultsSummary s : results) {
                    List<Sample> samples = dbService.getSampleDetails(s.getSummaryResultsId(), s.getExpRecId());
                    s.setSamples(samples);
                }
                List<Delivery> deliveryList = dbService.getDeliveryVehicles(r.getDeliverySystemId());
                List<ApplicationMethod> applicationMethod = dbService.getApplicationMethodsById(r.getApplicationMethodId());
                req.setAttribute("applicationMethod", applicationMethod);
                req.setAttribute("deliveryList", deliveryList);
                req.setAttribute("experiment", e);
                req.setAttribute("experimentRecords", r);
                req.setAttribute("model", m);
                req.setAttribute("reporterElements", reporterElements);
                req.setAttribute("results", results);
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
                    //     System.out.print(matrix[i][j]+"\t");
                }
                json.append("]");
                Gson gson = new Gson();
                String regionListJson = gson.toJson(regionList);
                req.setAttribute("regionListJson", regionListJson);
                req.setAttribute("json", json);
            }
            //    System.out.println("RECORDS SIZE:"+records.size());
        }
        //
        req.setAttribute("action", "Experiment Report");
        req.setAttribute("page", "/WEB-INF/jsp/tools/experiment");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

    }

}
