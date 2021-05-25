package edu.mcw.scge.controller;

import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.configuration.UserService;
import edu.mcw.scge.dao.implementation.EditorDao;
import edu.mcw.scge.dao.implementation.ExperimentDao;
import edu.mcw.scge.dao.implementation.ModelDao;
import edu.mcw.scge.dao.implementation.StudyDao;
import edu.mcw.scge.datamodel.*;
import edu.mcw.scge.service.db.DBService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;

@Controller
@RequestMapping(value="/data/models")
public class ModelController {

    @RequestMapping(value="/search")
    public String getModels(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        ModelDao dao = new ModelDao();
        List<edu.mcw.scge.datamodel.Model> records= dao.getModels();
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a>");
        req.setAttribute("models", records);
        req.setAttribute("action", "Model Systems");
        req.setAttribute("page", "/WEB-INF/jsp/tools/models");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

    @RequestMapping(value="/model")
    public String getModel(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        ModelDao dao = new ModelDao();
        edu.mcw.scge.datamodel.Model mod= dao.getModelById(Integer.parseInt(req.getParameter("id")));

        DBService dbService = new DBService();
        UserService userService = new UserService();
        Person p=userService.getCurrentUser(req.getSession());
        edu.mcw.scge.configuration.Access access = new Access();

        if(!access.isLoggedIn()) {
            return "redirect:/";
        }

        if (!access.hasModelAccess(mod,p)) {
            req.setAttribute("page", "/WEB-INF/jsp/error");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            return null;

        }


        req.setAttribute("model", mod);
        req.setAttribute("action","Model System: " + mod.getName());
        req.setAttribute("page", "/WEB-INF/jsp/tools/model");

        StudyDao sdao = new StudyDao();
        List<Study> studies = sdao.getStudiesByModel(mod.getModelId());
        req.setAttribute("studies", studies);

        ExperimentDao experimentDao= new ExperimentDao();
        List<ExperimentRecord> experimentRecords = experimentDao.getExperimentsByModel(mod.getModelId());
        req.setAttribute("experimentRecords",experimentRecords);
        HashMap<Integer,List<Guide>> guideMap = new HashMap<>();
        for(ExperimentRecord record:experimentRecords) {
            guideMap.put(record.getExperimentRecordId(), dbService.getGuidesByExpRecId(record.getExperimentRecordId()));
        }
        req.setAttribute("guideMap", guideMap);

        HashMap<Integer,List<Vector>> vectorMap = new HashMap<>();
        for(ExperimentRecord record:experimentRecords) {
            vectorMap.put(record.getExperimentRecordId(), dbService.getVectorsByExpRecId(record.getExperimentRecordId()));
        }
        req.setAttribute("vectorMap", vectorMap);

        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a> / <a href='/toolkit/data/models/search'>Models</a>");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

}
