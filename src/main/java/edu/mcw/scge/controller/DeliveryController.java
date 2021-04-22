package edu.mcw.scge.controller;

import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.configuration.UserService;
import edu.mcw.scge.dao.implementation.DeliveryDao;
import edu.mcw.scge.dao.implementation.EditorDao;
import edu.mcw.scge.dao.implementation.ExperimentDao;
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
@RequestMapping(value="/data/delivery")
public class DeliveryController {

    @RequestMapping(value="/search")
    public String getDeliverySystems(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        DeliveryDao dao = new DeliveryDao();
        List<Delivery> records= dao.getDeliverySystems();
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a>");
        req.setAttribute("systems", records);
        req.setAttribute("action", "Delivery Systems");
        req.setAttribute("page", "/WEB-INF/jsp/tools/systems");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

    @RequestMapping(value="/system")
    public String getDeliverySystem(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        DeliveryDao dao = new DeliveryDao();
        Delivery system= dao.getDeliverySystemsById(Integer.parseInt(req.getParameter("id"))).get(0);
        DBService dbService = new DBService();

        UserService userService = new UserService();
        Person p=userService.getCurrentUser(req.getSession());
        edu.mcw.scge.configuration.Access access = new Access();

        if(!access.isLoggedIn()) {
            return "redirect:/";
        }

        if (!access.hasDeliveryAccess(system,p)) {
            req.setAttribute("page", "/WEB-INF/jsp/error");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            return null;

        }



        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a> -> <a href='/toolkit/data/delivery/search'>Delivery Systems</a>");
        req.setAttribute("system", system);
        req.setAttribute("action", "Delivery System: " + system.getName());
        req.setAttribute("page", "/WEB-INF/jsp/tools/deliverySystem");

        StudyDao sdao = new StudyDao();
        List<Study> studies = sdao.getStudiesByDeliverySystem(system.getId());
        req.setAttribute("studies", studies);

        ExperimentDao experimentDao= new ExperimentDao();
        List<ExperimentRecord> experimentRecords = experimentDao.getExperimentsByDeliverySystem(system.getId());
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

        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

}
