package edu.mcw.scge.controller;

import edu.mcw.scge.dao.implementation.EditorDao;
import edu.mcw.scge.datamodel.Editor;
import edu.mcw.scge.datamodel.ExperimentRecord;
import edu.mcw.scge.service.db.DBService;
import edu.mcw.scge.service.es.IndexServices;
import org.elasticsearch.action.search.SearchResponse;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@Controller
@RequestMapping(value="/toolkit/editors")
public class EditorController {

    @RequestMapping(value="search")
    public String getEditors(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        EditorDao dao = new EditorDao();
        List<Editor> records= dao.getAllEditors();
        req.setAttribute("editors", records);
        req.setAttribute("action", "Editors");
        req.setAttribute("page", "/WEB-INF/jsp/tools/editors");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

    @RequestMapping(value="editor")
    public String getEditor(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        EditorDao dao = new EditorDao();
        Editor editor= dao.getEditorById(Integer.parseInt(req.getParameter("id"))).get(0);
        req.setAttribute("editor", editor);
        req.setAttribute("action", editor.getSymbol());
        req.setAttribute("page", "/WEB-INF/jsp/tools/editor");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

}
