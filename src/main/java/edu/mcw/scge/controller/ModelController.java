package edu.mcw.scge.controller;

import edu.mcw.scge.dao.implementation.EditorDao;
import edu.mcw.scge.dao.implementation.ExperimentDao;
import edu.mcw.scge.dao.implementation.ModelDao;
import edu.mcw.scge.dao.implementation.StudyDao;
import edu.mcw.scge.datamodel.Editor;
import edu.mcw.scge.datamodel.Experiment;
import edu.mcw.scge.datamodel.Study;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

@Controller
@RequestMapping(value="/data/models")
public class ModelController {

    @RequestMapping(value="/search")
    public String getModels(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        ModelDao dao = new ModelDao();
        List<edu.mcw.scge.datamodel.Model> records= dao.getModels();
        req.setAttribute("models", records);
        req.setAttribute("action", "Models");
        req.setAttribute("page", "/WEB-INF/jsp/tools/models");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

    @RequestMapping(value="/model")
    public String getModel(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        ModelDao dao = new ModelDao();
        edu.mcw.scge.datamodel.Model mod= dao.getModelById(Integer.parseInt(req.getParameter("id")));
        req.setAttribute("model", mod);
        req.setAttribute("action","Model: " + mod.getName());
        req.setAttribute("page", "/WEB-INF/jsp/tools/model");

        StudyDao sdao = new StudyDao();
        List<Study> studies = sdao.getStudiesByModel(mod.getModelId());
        req.setAttribute("studies", studies);

        ExperimentDao experimentDao= new ExperimentDao();
        List<Experiment> experiments = experimentDao.getExperimentsByModel(mod.getModelId());
        req.setAttribute("experiments",experiments);


        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

}
