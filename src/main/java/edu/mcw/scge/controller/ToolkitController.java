package edu.mcw.scge.controller;

import edu.mcw.scge.dao.implementation.EditorDao;
import edu.mcw.scge.datamodel.Editor;
import edu.mcw.scge.datamodel.ExperimentRecord;
import edu.mcw.scge.service.DataAccessService;
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
@RequestMapping(value="/toolkit")
public class ToolkitController {
   IndexServices services=new IndexServices();
    DBService dbService=new DBService();
    @GetMapping(value="home")
    public String getToolKitHome(HttpServletRequest req, HttpServletResponse res, Model model) throws ServletException, IOException {
        req.setAttribute("action", "Toolkit");
        req.setAttribute("page", "/WEB-INF/jsp/tools/home");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
    @RequestMapping(value="delivery/search")
    public String getDeliveryHome(HttpServletRequest req, HttpServletResponse res, Model model) throws ServletException, IOException {

     //   model.addAttribute("sr", services.getSearchResponse());
     //   req.setAttribute("sr", services.getSearchResponse());
        req.setAttribute("action", "Delivery Systems");
        req.setAttribute("page", "/WEB-INF/jsp/tools/delivery");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
    @RequestMapping(value="delivery/results")
    public String getDeliveryResults(HttpServletRequest req, HttpServletResponse res, Model model) throws ServletException, IOException {

        //   model.addAttribute("sr", services.getSearchResponse());
        SearchResponse sr=services.getSearchResponse();
        req.setAttribute("sr", sr);
        req.setAttribute("aggregations",services.getAggregations(sr));
        req.setAttribute("action", "Delivery Systems Results");
        req.setAttribute("page", "/WEB-INF/jsp/tools/results");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
    @RequestMapping(value="vitro/search")
    public String getVitroHome(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        List<ExperimentRecord> records=dbService.getAllExperimentRecordsByLabId(15);
        System.out.println("EXPERIMENTS: "+ records.size());
        req.setAttribute("experimentRecords", records);
        req.setAttribute("action", "Biological Effects - In vitro");
        req.setAttribute("page", "/WEB-INF/jsp/tools/vitro");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
    @RequestMapping(value="animalReporter/search")
    public String getReporterHome(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
      //  List<ExperimentRecord> records=dbService.getAllExperimentRecordsByLabId(15);
     //   System.out.println("EXPERIMENTS: "+ records.size());
     //   req.setAttribute("experimentRecords", records);
        req.setAttribute("action", "Animal Reporters");
        req.setAttribute("page", "/WEB-INF/jsp/tools/animalReporter");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
}
