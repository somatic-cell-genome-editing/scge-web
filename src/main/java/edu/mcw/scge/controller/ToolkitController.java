package edu.mcw.scge.controller;

import com.google.gson.Gson;
import edu.mcw.scge.dao.implementation.AnimalTestingResultsDAO;
import edu.mcw.scge.dao.implementation.EditorDao;
import edu.mcw.scge.datamodel.*;
import edu.mcw.scge.service.DataAccessService;
import edu.mcw.scge.service.db.DBService;
import edu.mcw.scge.service.es.IndexServices;
import org.elasticsearch.action.search.SearchResponse;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
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
       List<ExperimentRecord> records=dbService.getAllExperimentRecordsByLabId(3);
        System.out.println("EXPERIMENTS: "+ records.size());
        req.setAttribute("experimentRecords", records);
        req.setAttribute("action", "Animal Reporters");
        req.setAttribute("page", "/WEB-INF/jsp/tools/animalReporter");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

    @GetMapping(value="/animalReporter/results/{id}")
    public void getdeliveryResults(@PathVariable String id, HttpServletRequest req, HttpServletResponse res) throws Exception {
       int experimentId= Integer.parseInt(id);
        List<ExperimentRecord> records=dbService.getExperimentRecordById(experimentId);
        if(records.size()>0){
          ExperimentRecord r=  records.get(0);
          edu.mcw.scge.datamodel.Model m= dbService.getModelById( r.getModelId());
           List< ReporterElement> reporterElements=dbService.getReporterElementsByExpRecId(r.getExperimentRecId());
           List<AnimalTestingResultsSummary> results=dbService.getAnimalTestingResultsByExpRecId(r.getExperimentRecId());
           List<Delivery> deliveryList=dbService.getDeliveryVehicles(r.getDeliveryId());
           List<ApplicationMethod> applicationMethod=dbService.getApplicationMethodsById(r.getApplicationMethodId());
            req.setAttribute("applicationMethod", applicationMethod);
            req.setAttribute("deliveryList", deliveryList);
            req.setAttribute("experiment",r);
            req.setAttribute("model", m);
            req.setAttribute("reporterElements", reporterElements);
            req.setAttribute("results", results);
            List<String> regionList=new ArrayList<>();
            StringBuilder json=new StringBuilder();
            json.append("[");
            for(AnimalTestingResultsSummary s:results){
                regionList.add(s.getTissueTerm());
               int value= Integer.parseInt(s.getSignalPresent());
                json.append("{\"sample\":\"");
                json.append("A"+"\",");
                json.append("\"gene\":\""+s.getTissueTerm()+"\",");
                json.append("\"value\":"+value+"},");
                //     System.out.print(matrix[i][j]+"\t");
            }
            json.append("]");
            Gson gson=new Gson();
            String regionListJson=gson.toJson(regionList);
            req.setAttribute("regionListJson",regionListJson);
            req.setAttribute("json", json);
        }
    //    System.out.println("RECORDS SIZE:"+records.size());

    //
        req.setAttribute("action", "Experiment Report");
        req.setAttribute("page", "/WEB-INF/jsp/tools/experiment");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

    }
    @RequestMapping(value="editor/search")
    public String getEditorHome(HttpServletRequest req, HttpServletResponse res) throws Exception {
        EditorDao dao = new EditorDao();
        List<Editor> records= dao.getAllEditors();
        req.setAttribute("editors", records);
        req.setAttribute("action", "Editors");
        req.setAttribute("page", "/WEB-INF/jsp/tools/editor");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

}
