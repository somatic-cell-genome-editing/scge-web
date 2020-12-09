package edu.mcw.scge.controller;

import edu.mcw.scge.dao.implementation.ExperimentRecordDao;
import edu.mcw.scge.dao.implementation.StudyDao;
import edu.mcw.scge.datamodel.ExperimentRecord;
import edu.mcw.scge.datamodel.Study;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

@Controller
@RequestMapping(value="/toolkit/studies")
public class StudyController {

    @RequestMapping(value="search")
    public String getStudies(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        StudyDao sdao=new StudyDao();
        List<Study> studies = sdao.get


        List<ExperimentRecord>  records = edao.getExperimentRecords();

        req.setAttribute("experimentRecords", records);
        req.setAttribute("action", "Experiments");
        req.setAttribute("page", "/WEB-INF/jsp/tools/experiments");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;

    }

    @RequestMapping(value="experiment")
    public String getExperiment(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
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

}
