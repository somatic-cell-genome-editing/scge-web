package edu.mcw.scge.controller;

import edu.mcw.scge.dao.implementation.*;
import edu.mcw.scge.datamodel.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

@Controller
@RequestMapping(value="/data/guide")
public class GuideController {

    @RequestMapping(value="/search")
    public String getGuides(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        GuideDao dao = new GuideDao();
        List<Guide> records= dao.getGuides();
        req.setAttribute("guides", records);
        req.setAttribute("action", "Guides");
        req.setAttribute("page", "/WEB-INF/jsp/tools/guides");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

    @RequestMapping(value="/guide")
    public String getGuide(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        GuideDao dao = new GuideDao();
        Guide guide= dao.getGuideById(Integer.parseInt(req.getParameter("id"))).get(0);
        req.setAttribute("guide", guide);
        req.setAttribute("action", "Guide: " + guide.getGuide());
        req.setAttribute("page", "/WEB-INF/jsp/tools/guide");

        StudyDao sdao = new StudyDao();
        List<Study> studies = sdao.getStudiesByGuide(guide.getGuide_id());
        req.setAttribute("studies", studies);

        ExperimentDao experimentDao= new ExperimentDao();
        List<Experiment> experiments = experimentDao.getExperimentsByGuide(guide.getGuide_id());
        req.setAttribute("experiments",experiments);

        EditorDao editorDao = new EditorDao();
        List<Editor> editors = editorDao.getEditorByGuide(guide.getGuide_id());
        req.setAttribute("editors", editors);

        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

}
