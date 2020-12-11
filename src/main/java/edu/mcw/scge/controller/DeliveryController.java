package edu.mcw.scge.controller;

import edu.mcw.scge.dao.implementation.DeliveryDao;
import edu.mcw.scge.dao.implementation.EditorDao;
import edu.mcw.scge.dao.implementation.StudyDao;
import edu.mcw.scge.datamodel.Delivery;
import edu.mcw.scge.datamodel.Editor;
import edu.mcw.scge.datamodel.Study;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

@Controller
@RequestMapping(value="/data/delivery")
public class DeliveryController {

    @RequestMapping(value="search")
    public String getDeliverySystems(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        DeliveryDao dao = new DeliveryDao();
        List<Delivery> records= dao.getDeliverySystems();
        req.setAttribute("systems", records);
        req.setAttribute("action", "Delivery Systems");
        req.setAttribute("page", "/WEB-INF/jsp/tools/systems");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

    @RequestMapping(value="system")
    public String getDeliverySystem(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        DeliveryDao dao = new DeliveryDao();
        Delivery system= dao.getDeliverySystemsById(Integer.parseInt(req.getParameter("id"))).get(0);
        req.setAttribute("system", system);
        req.setAttribute("action", system.getType());
        req.setAttribute("page", "/WEB-INF/jsp/tools/deliverySystem");

        StudyDao sdao = new StudyDao();
        List<Study> studies = sdao.getStudiesByDeliverySystem(system.getId());
        req.setAttribute("studies", studies);

        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

}
