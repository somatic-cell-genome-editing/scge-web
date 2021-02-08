package edu.mcw.scge.controller;

import com.google.gson.Gson;
import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.configuration.UserService;
import edu.mcw.scge.dao.implementation.ExperimentDao;
import edu.mcw.scge.dao.implementation.ExperimentRecordDao;
import edu.mcw.scge.dao.implementation.PersonDao;
import edu.mcw.scge.dao.implementation.StudyDao;
import edu.mcw.scge.datamodel.*;
import edu.mcw.scge.service.Data;
import edu.mcw.scge.service.DataAccessService;
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
import java.util.Map;

@Controller
@RequestMapping(value="/data/studies")
public class StudyController{
    DBService dbService=new DBService();
    DataAccessService service=new DataAccessService();
    UserService userService=new UserService();
    Access access= new Access();
    StudyDao sdao=new StudyDao();

    @RequestMapping(value="/search")
    public String getStudies( HttpServletRequest req, HttpServletResponse res) throws Exception {


        System.out.println("here1");
        Person p=userService.getCurrentUser(req.getSession());
        if(p!=null) {
            List<Study> studies = sdao.getStudies();

            req.setAttribute("groupsMap1", Data.getInstance().getConsortiumGroups());
            req.setAttribute("groupMembersMap", Data.getInstance().getGroupMembersMap());
            req.setAttribute("DCCNIHMembersMap", Data.getInstance().getDCCNIHMembersMap());
            req.setAttribute("status", req.getParameter("status"));
            req.setAttribute("DCCNIHAncestorGroupIds", Data.getInstance().getDCCNIHAncestorGroupIds());
            service.addTier2Associations(studies);
            Map<Integer, Integer> tierUpdateMap = service.getTierUpdate(studies);

            req.setAttribute("studies", studies);
            req.setAttribute("tierUpdateMap", tierUpdateMap);
            req.setAttribute("person", p);
            req.setAttribute("action", "Studies");
            req.setAttribute("page", "/WEB-INF/jsp/tools/studies");

            System.out.println("here4");
            return "base";
        }
        return "redirect:/";
    }


  /*  @RequestMapping(value="/search/{studyId}")
    public String getExperimentRecordsByStudy(HttpServletRequest req, HttpServletResponse res, Model model, @PathVariable(required = false) int studyId) throws Exception {
        List<ExperimentRecord> records=dbService.getAllExperimentRecordsByStudyId(studyId);

        System.out.println("EXPERIMENTS: "+ records.size());
        req.setAttribute("experimentRecords", records);
        req.setAttribute("action", "Animal Reporters");
        req.setAttribute("page", "/WEB-INF/jsp/tools/animalReporter");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }*/
    @RequestMapping(value="/search/group/{groupId}")
    public String getStudiesByGroupId(@PathVariable int groupId, HttpServletRequest req, HttpServletResponse res, Model model, @PathVariable(required = false) int studyId) throws Exception {
        List<Study> records=dbService.getStudiesByGroupId(groupId);



        return null;
    }


    @GetMapping(value="/search/results/{id}")
    public void getResults(@PathVariable String id, HttpServletRequest req, HttpServletResponse res) throws Exception {
        int experimentId= Integer.parseInt(id);
        ExperimentDao dao = new ExperimentDao();
        Experiment e = dao.getExperiment(experimentId);

        List<ExperimentRecord> records=dbService.getExperimentRecordById(experimentId);
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
            req.setAttribute("experiment",e);
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
        req.setAttribute("page", "/WEB-INF/jsp/tools/experiment");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

    }

}
