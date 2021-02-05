package edu.mcw.scge.controller;

import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.dao.implementation.EditorDao;
import edu.mcw.scge.dao.implementation.ExperimentDao;
import edu.mcw.scge.dao.implementation.ExperimentRecordDao;
import edu.mcw.scge.dao.implementation.StudyDao;
import edu.mcw.scge.datamodel.Experiment;
import edu.mcw.scge.datamodel.ExperimentRecord;
import edu.mcw.scge.datamodel.PersonInfo;
import edu.mcw.scge.datamodel.Study;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.PathVariable;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

@Controller
@RequestMapping(value="/data/experiments")
public class ExperimentController extends LoginController {
    ExperimentDao edao = new ExperimentDao();
    StudyDao sdao = new StudyDao();
    Access access=new Access();
    @RequestMapping(value="/search")
    public String getExperiments(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        ExperimentRecordDao edao=new ExperimentRecordDao();
        List<ExperimentRecord>  records = edao.getExperimentRecords();

        req.setAttribute("experimentRecords", records);
        req.setAttribute("action", "Experiments");
        req.setAttribute("page", "/WEB-INF/jsp/tools/experiments");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;

    }

    @RequestMapping(value="/search/{studyId}")
    public String getExperimentRecordsByStudy(HttpServletRequest req, HttpServletResponse res,
                                              @ModelAttribute("personInfoRecords") List<PersonInfo> personInfoRecords,
                                              @PathVariable(required = false) int studyId) throws Exception {

        if(access.hasAccess(studyId, "study",personInfoRecords)) {
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


    @RequestMapping(value="/record/{experimentId}")
    public String getExperimentRecords(HttpServletRequest req, HttpServletResponse res, Model model, @PathVariable(required = false) int experimentId) throws Exception {
        List<ExperimentRecord> records=edao.getExperimentRecords(experimentId);
        System.out.println(records.size());
        req.setAttribute("experimentRecords", records);
        Study study = sdao.getStudyById(records.get(0).getStudyId()).get(0);
        req.setAttribute("study", study);
        req.setAttribute("action", "Experiment Details");
        req.setAttribute("page", "/WEB-INF/jsp/tools/experimentRecords");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }




}
