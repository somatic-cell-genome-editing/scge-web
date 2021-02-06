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
import java.util.List;

@Controller
@RequestMapping(value="/data/experiments")
public class ExperimentController extends UserController {
    ExperimentDao edao = new ExperimentDao();
    ExperimentRecordDao erDao=new ExperimentRecordDao();
    StudyDao sdao = new StudyDao();
    Access access=new Access();
    DBService dbService=new DBService();
    UserService userService=new UserService();
    @RequestMapping(value="/")
    public String getAllExperiments(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        ExperimentRecordDao edao=new ExperimentRecordDao();
        List<ExperimentRecord>  records = edao.getExperimentRecords();

        req.setAttribute("experimentRecords", records);
        req.setAttribute("action", "Experiments");
        req.setAttribute("page", "/WEB-INF/jsp/tools/experiments");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;

    }

    @RequestMapping(value="/study/{studyId}")
    public String getExperimentsByStudyId( HttpServletRequest req, HttpServletResponse res,
                                           @PathVariable(required = false) int studyId) throws Exception {
        Person p=userService.getCurrentUser();

        if(p==null)
            return "redirect:/";
         else  if (access.hasAccess(studyId, "study", access.getPersonInfoRecords(p.getId()))) {
                Study study = sdao.getStudyById(studyId).get(0);
                List<Experiment> records = edao.getExperimentsByStudy(studyId);
                req.setAttribute("experiments", records);
                req.setAttribute("study", study);
                req.setAttribute("action", "Experiments");
                req.setAttribute("page", "/WEB-INF/jsp/tools/experiments");
                req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            return null;
            }else
            return "error";


    }


    @RequestMapping(value="/experiment/{experimentId}")
    public String getExperimentsByExperimentId(HttpServletRequest req, HttpServletResponse res,
                                               @PathVariable(required = false) int experimentId
    ) throws Exception {

        Person p=userService.getCurrentUser();
        if(p==null)
            return "redirect:/";
        if (access.hasAccess(experimentId, "experiment", access.getPersonInfoRecords(p.getId()))) {
            List<ExperimentRecord> records = edao.getExperimentRecords(experimentId);
            System.out.println(records.size());
            req.setAttribute("experimentRecords", records);
            Study study = sdao.getStudyById(records.get(0).getStudyId()).get(0);
            req.setAttribute("study", study);
            req.setAttribute("action", "Experiment Records");
            req.setAttribute("page", "/WEB-INF/jsp/tools/experimentRecords");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            return null;
        }else
        return "error";

    }
    @RequestMapping(value="/experiment/{experimentId}/record/{expRecordId}")
    public String getExperimentRecords(HttpServletRequest req, HttpServletResponse res,
                                       @PathVariable(required = false) int experimentId,
                                       @PathVariable(required = false) int expRecordId) throws Exception {
        Person p=userService.getCurrentUser();
        if(p==null){
            return "redirect:/";
        }
            if (access.hasAccess(experimentId, "experiment", access.getPersonInfoRecords(p.getId()))) {
                List<ExperimentRecord> records = erDao.getExperimentRecordByExpRecId(expRecordId);
                req.setAttribute("experimentRecords", records);
                Study study = sdao.getStudyById(records.get(0).getStudyId()).get(0);
                if(records.size()>0){
                    ExperimentRecord r=  records.get(0);
                    edu.mcw.scge.datamodel.Model m= dbService.getModelById( r.getModelId());
                    List<ReporterElement> reporterElements=dbService.getReporterElementsByExpRecId(r.getExperimentRecordId());
                    List<AnimalTestingResultsSummary> results=dbService.getAnimalTestingResultsByExpRecId(r.getExperimentRecordId());
                    for(AnimalTestingResultsSummary s: results){
                        List<Sample> samples= dbService.getSampleDetails(s.getSummaryResultsId(), s.getExpRecId());
                        s.setSamples(samples  );
                    }
                    List<Delivery> deliveryList=dbService.getDeliveryVehicles(r.getDeliverySystemId());
                    List<ApplicationMethod> applicationMethod=dbService.getApplicationMethodsById(r.getApplicationMethodId());
                    req.setAttribute("applicationMethod", applicationMethod);
                    req.setAttribute("deliveryList", deliveryList);
                    //req.setAttribute("experiment",e);
                    req.setAttribute("experimentRecords",r);
                    req.setAttribute("model", m);
                    req.setAttribute("reporterElements", reporterElements);
                    req.setAttribute("results", results);
                    List<String> regionList=new ArrayList<>();
                    StringBuilder json=new StringBuilder();
                    json.append("[");
                    for(AnimalTestingResultsSummary s:results){
                        regionList.add(s.getTissueTerm().trim());
                        int value= Integer.parseInt(s.getSignalPresent());
                        json.append("{\"sample\":\"");
                        json.append("A"+"\",");
                        json.append("\"gene\":\""+s.getTissueTerm()+"\",");
                        json.append("\"value\":"+value+"},");
                    }
                    json.append("]");
                    Gson gson=new Gson();
                    String regionListJson=gson.toJson(regionList);
                    req.setAttribute("regionListJson",regionListJson);
                    req.setAttribute("json", json);
                }
                req.setAttribute("action", "Experiment Report");

                req.setAttribute("study", study);
                req.setAttribute("page", "/WEB-INF/jsp/tools/experiment");
                req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
                return null;
            }else
            return "error";

        }

}
