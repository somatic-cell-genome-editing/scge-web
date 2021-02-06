package edu.mcw.scge.controller;

import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.configuration.UserService;
import edu.mcw.scge.dao.implementation.*;
import edu.mcw.scge.datamodel.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.PathVariable;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

@Controller
@RequestMapping(value="/data/experiments")
public class ExperimentController extends UserController {
    ExperimentDao edao = new ExperimentDao();
    ExperimentRecordDao erDao=new ExperimentRecordDao();
    StudyDao sdao = new StudyDao();
    Access access=new Access();
    PersonDao pdao=new PersonDao();
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
        if(access.hasAccess(studyId, "study",access.getPersonInfoRecords(p.getId()))) {
            Study study = sdao.getStudyById(studyId).get(0);
            List<Experiment> records = edao.getExperimentsByStudy(studyId);
            req.setAttribute("experiments", records);
            req.setAttribute("study", study);
            req.setAttribute("action", "Experiments");
            req.setAttribute("page", "/WEB-INF/jsp/tools/experiments");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        }

        return "error";
    }


    @RequestMapping(value="/experiment/{experimentId}")
    public String getExperimentsByExperimentId(HttpServletRequest req, HttpServletResponse res,
                                               @PathVariable(required = false) int experimentId
                                      ) throws Exception {


        Person p=userService.getCurrentUser();
        if(p==null)
            return "redirect:/";
        if(access.hasAccess(experimentId, "experiment", access.getPersonInfoRecords(p.getId()))) {
            List<ExperimentRecord> records = edao.getExperimentRecords(experimentId);
            System.out.println(records.size());
            req.setAttribute("experimentRecords", records);
            Study study = sdao.getStudyById(records.get(0).getStudyId()).get(0);
            req.setAttribute("study", study);
            req.setAttribute("action", "Experiment Details");
            req.setAttribute("page", "/WEB-INF/jsp/tools/experimentRecords");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        }
        return "error";
    }
    @RequestMapping(value="/experiment/{experimentId}/record/{expRecordId")
    public String getExperimentRecords(HttpServletRequest req, HttpServletResponse res,
                                       @PathVariable(required = false) int experimentId,
                                       @PathVariable(required = false) int expRecordId) throws Exception {
        Person p=userService.getCurrentUser();
        if(p==null)
            return "redirect:/";
        if(access.hasAccess(experimentId, "experiment",access.getPersonInfoRecords(p.getId()))) {
            List<ExperimentRecord> records = erDao.getExperimentRecordByExpRecId(expRecordId);
            req.setAttribute("experimentRecords", records);
            Study study = sdao.getStudyById(records.get(0).getStudyId()).get(0);
            req.setAttribute("study", study);
            req.setAttribute("action", "Experiment Details");
            req.setAttribute("page", "/WEB-INF/jsp/tools/experimentRecords");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        }
        return "error";
    }



}
