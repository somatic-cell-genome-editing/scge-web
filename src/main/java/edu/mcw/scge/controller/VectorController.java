package edu.mcw.scge.controller;

import edu.mcw.scge.dao.implementation.DeliveryDao;
import edu.mcw.scge.dao.implementation.ExperimentDao;
import edu.mcw.scge.dao.implementation.StudyDao;
import edu.mcw.scge.dao.implementation.VectorDao;
import edu.mcw.scge.datamodel.*;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

@Controller
@RequestMapping(value="/data/vector")
public class VectorController {

    @RequestMapping(value="/search")
    public String getVectors(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        VectorDao dao = new VectorDao();
        List<Vector> records= dao.getAllVectors();
        req.setAttribute("vectors", records);
        req.setAttribute("action", "Vector/Format");
        req.setAttribute("page", "/WEB-INF/jsp/tools/vectors");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

    @RequestMapping(value="/format")
    public String getVector(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        VectorDao dao = new VectorDao();
        Vector v= dao.getVectorById(Integer.parseInt(req.getParameter("id"))).get(0);
        req.setAttribute("vector", v);
        req.setAttribute("action", "Vector/Format: " + v.getName());
        req.setAttribute("page", "/WEB-INF/jsp/tools/vector");

        StudyDao sdao = new StudyDao();
        List<Study> studies = sdao.getStudiesByVector(v.getVectorId());
        req.setAttribute("studies", studies);

        ExperimentDao experimentDao= new ExperimentDao();
        List<ExperimentRecord> experimentRecords = experimentDao.getExperimentsByVector(v.getVectorId());
        req.setAttribute("experimentRecords",experimentRecords);

        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

}
