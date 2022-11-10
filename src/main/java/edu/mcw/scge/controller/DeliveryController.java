package edu.mcw.scge.controller;

import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.configuration.UserService;
import edu.mcw.scge.dao.implementation.*;
import edu.mcw.scge.datamodel.*;
import edu.mcw.scge.datamodel.Vector;
import edu.mcw.scge.datamodel.publications.Publication;
import edu.mcw.scge.service.db.DBService;
import edu.mcw.scge.web.utils.BreadCrumbImpl;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping(value="/data/delivery")
public class DeliveryController extends ObjectController{
    BreadCrumbImpl breadCrumb=new BreadCrumbImpl();
    DeliveryDao dao = new DeliveryDao();
    PublicationDAO publicationDAO=new PublicationDAO();
    @RequestMapping(value="/search")
    public String getDeliverySystems(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {

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

        Delivery system= dao.getDeliverySystemsById(Long.parseLong(req.getParameter("id"))).get(0);
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

        req.setAttribute("summaryBlocks", getSummary(system));
        req.setAttribute("crumbTrail",   breadCrumb.getCrumbTrailMap(req,system,null,null));

        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a> / <a href='/toolkit/data/search/results/Delivery%20System?searchTerm='>Delivery Systems</a>");
        req.setAttribute("system", system);
        req.setAttribute("action", "Delivery System: " + system.getName());
        req.setAttribute("page", "/WEB-INF/jsp/tools/deliverySystem");

        StudyDao sdao = new StudyDao();
        List<Study> studies = sdao.getStudiesByDeliverySystem(system.getId());
        req.setAttribute("studies", studies);

        ProtocolDao pdao = new ProtocolDao();
        List<Protocol> protocols = pdao.getProtocolsForObject(system.getId());
        req.setAttribute("protocols", protocols);

        ExperimentDao experimentDao= new ExperimentDao();
        List<ExperimentRecord> experimentRecords = experimentDao.getExperimentsByDeliverySystem(system.getId());
        req.setAttribute("experimentRecords",experimentRecords);

        HashMap<Long,List<Guide>> guideMap = new HashMap<>();
        for(ExperimentRecord record:experimentRecords) {
            guideMap.put(record.getExperimentRecordId(), dbService.getGuidesByExpRecId(record.getExperimentRecordId()));
        }
        req.setAttribute("guideMap", guideMap);

        HashMap<Long,List<Vector>> vectorMap = new HashMap<>();
        Set<Long> experimentIds=new HashSet<>();
        for(ExperimentRecord record:experimentRecords) {
            vectorMap.put(record.getExperimentRecordId(), dbService.getVectorsByExpRecId(record.getExperimentRecordId()));
            experimentIds.add(record.getExperimentId());
        }
        req.setAttribute("vectorMap", vectorMap);
        if(studies!=null && studies.size()>0) {
            mapProjectNExperiments(experimentRecords, req);
           }
        List<Publication> associatedPublications=new ArrayList<>();
        associatedPublications.addAll(publicationDAO.getAssociatedPublications(system.getId()));
        for(long experimentId:experimentIds) {
            for(Publication pub:publicationDAO.getAssociatedPublications(experimentId)) {
                boolean flag=false;
                for(Publication publication:associatedPublications){
                    if(pub.getReference().getKey()==publication.getReference().getKey()){
                        flag=true;
                    }
                }
                if(!flag)
                    associatedPublications.add(pub);
            }

        }
        req.setAttribute("associatedPublications", associatedPublications);
        req.setAttribute("relatedPublications", publicationDAO.getRelatedPublications(system.getId()));
        req.setAttribute("seoDescription",system.getDescription());
        req.setAttribute("seoTitle",system.getName());
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
    @RequestMapping(value = "/edit")
    public String getModelForm(HttpServletRequest req, HttpServletResponse res,Delivery delivery) throws Exception{

        UserService userService = new UserService();
        Person p=userService.getCurrentUser(req.getSession());
        edu.mcw.scge.configuration.Access access = new Access();

        if(!access.isLoggedIn()) {
            return "redirect:/";
        }

        if (!access.isAdmin(p)) {
            req.setAttribute("page", "/WEB-INF/jsp/error");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            return null;

        }

        if(req.getParameter("id") != null) {
            Delivery d = dao.getDeliverySystemsById(Long.parseLong(req.getParameter("id"))).get(0);
            req.setAttribute("delivery",d);
            req.setAttribute("action","Update Delivery System");
        }else {
            req.setAttribute("delivery", new Delivery());
            req.setAttribute("action", "Create Delivery System");
        }

        List<Delivery> records = dao.getDeliverySystems();
        Set<String> name = records.stream().map(Delivery::getName).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> type = records.stream().map(Delivery::getType).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> subtype = records.stream().map(Delivery::getSubtype).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> labId = records.stream().map(Delivery::getLabId).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> source = records.stream().map(Delivery::getSource).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());

        req.setAttribute("name",name);
        req.setAttribute("type",type);
        req.setAttribute("source",source);
        req.setAttribute("subtype",subtype);
        req.setAttribute("labId",labId);
        req.setAttribute("page", "/WEB-INF/jsp/edit/editDelivery");

        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a> / <a href='/toolkit/data/search/results/Delivery%20System?searchTerm='>Delivery</a>");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
    @RequestMapping("/create")
    public String createModel(HttpServletRequest req,HttpServletResponse res,@ModelAttribute("delivery") Delivery delivery) throws Exception {

        long deliveryId = delivery.getId();
        UserService userService = new UserService();
        Person p=userService.getCurrentUser(req.getSession());
        edu.mcw.scge.configuration.Access access = new Access();

        if(!access.isLoggedIn()) {
            return "redirect:/";
        }

        if (!access.isAdmin(p)) {
            req.setAttribute("page", "/WEB-INF/jsp/error");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            return null;

        }
        if(delivery.getId() == 0) {
            deliveryId = dao.getDeliveryId(delivery);
            if(deliveryId == 0) {
                deliveryId = dao.insertDelivery(delivery);
                req.setAttribute("status"," <span style=\"color: blue\">Delivery added successfully</span>");
            }else {
                req.setAttribute("status","<span style=\"color: red\">Delivery already exists</span>");
            }
        }else{
            dao.updateDelivery(delivery);
            req.setAttribute("status"," <span style=\"color: blue\">Delivery updated successfully</span>");
        }


        req.getRequestDispatcher("/data/delivery/system?id="+deliveryId).forward(req,res);
        return null;
    }

    public  Map<String, Map<String, String>> getSummary(Delivery object){
        Map<String, Map<String, String>> summaryBlocks=new LinkedHashMap<>();

        Map<String, String> summary=new LinkedHashMap<>();
        int i=0;
        summary.put("SCGE ID", String.valueOf(object.getId()));
        if(object.getName()!=null && !object.getName().equals(""))
        summary.put("Name", object.getName());
        if(object.getDescription()!=null && !object.getDescription().equals(""))
        summary.put("Description", object.getDescription());
        if(object.getType()!=null && !object.getType().equals(""))
        summary.put("Type", object.getType());
        if(object.getSubtype()!=null && !object.getSubtype().equals(""))
            summary.put("Subtype", object.getSubtype());
        if(summary.size()>0) {
            summaryBlocks.put("block"+i, summary);
            i++;
            summary=new LinkedHashMap<>();
        }
        if(object.getSource()!=null && !object.getSource().equals(""))
        summary.put("Source", object.getSource());
        if(object.getRrid()!=null && !object.getRrid().equals(""))
        summary.put("RRID", object.getRrid());
        if(summary.size()>0) {
            summaryBlocks.put("block"+i, summary);
            i++;
            summary=new LinkedHashMap<>();
        }
        if(object.getSequence()!=null && !object.getSequence().equals(""))
        summary.put("Sequence", object.getSequence());
        if(object.getAnnotatedMap()!=null && !object.getAnnotatedMap().equals(""))
        summary.put("Annotated Map", object.getAnnotatedMap());
        if(summary.size()>0) {
            summaryBlocks.put("block"+i, summary);
            i++;
            summary=new LinkedHashMap<>();
        }
        if(object.getNpSize()!=null && !object.getNpSize().equals("")) {
            summary.put("Nanopartical Size", object.getNpSize());
            if (object.getZetaPotential() != null && !object.getZetaPotential().equals(""))
                summary.put("Zeta Potential", object.getZetaPotential());
            if (object.getNpPolydispersityIndex() != null && !object.getNpPolydispersityIndex().equals(""))
                summary.put("Poly Dispersity Index", object.getNpPolydispersityIndex());
        }
        if(summary.size()>0) {
            summaryBlocks.put("block"+i, summary);
        }
        return summaryBlocks;
    }
}
