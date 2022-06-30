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
@RequestMapping(value="/data/models")
public class ModelController {
    BreadCrumbImpl breadCrumb=new BreadCrumbImpl();
    PublicationDAO publicationDAO=new PublicationDAO();
    ExperimentDao experimentDao=new ExperimentDao();
    @RequestMapping(value="/search")
    public String getModels(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        ModelDao dao = new ModelDao();
        List<edu.mcw.scge.datamodel.Model> records= dao.getModels();
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a>");
        req.setAttribute("models", records);
        req.setAttribute("action", "Model Systems");
        req.setAttribute("page", "/WEB-INF/jsp/tools/models");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

    @RequestMapping(value="/model")
    public String getModel(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        ModelDao dao = new ModelDao();
        edu.mcw.scge.datamodel.Model mod= dao.getModelById(Long.parseLong(req.getParameter("id")));

        DBService dbService = new DBService();
        UserService userService = new UserService();
        Person p=userService.getCurrentUser(req.getSession());
        edu.mcw.scge.configuration.Access access = new Access();

        if(!access.isLoggedIn()) {
            return "redirect:/";
        }

        if (!access.hasModelAccess(mod,p)) {
            req.setAttribute("page", "/WEB-INF/jsp/error");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            return null;

        }

        req.setAttribute("crumbTrail",   breadCrumb.getCrumbTrailMap(req,mod,null,null));

        req.setAttribute("model", mod);
        req.setAttribute("action","Model System: " + mod.getName());
        req.setAttribute("page", "/WEB-INF/jsp/tools/model");

        StudyDao sdao = new StudyDao();
        List<Study> studies = sdao.getStudiesByModel(mod.getModelId());
        req.setAttribute("studies", studies);

        ProtocolDao pdao = new ProtocolDao();
        List<Protocol> protocols = pdao.getProtocolsForObject(mod.getModelId());
        req.setAttribute("protocols", protocols);

        ExperimentDao experimentDao= new ExperimentDao();
        List<ExperimentRecord> experimentRecords = experimentDao.getExperimentsByModel(mod.getModelId());
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
            List<Long> associatedExperimentIds=experimentRecords.stream().map(r->r.getExperimentId()).distinct().collect(Collectors.toList());
            List<Experiment> assocatedExperiments=new ArrayList<>();

            for(long id:associatedExperimentIds){
                assocatedExperiments.add(experimentDao.getExperiment(id));
            }
            req.setAttribute("associatedExperiments", assocatedExperiments);}
        List<Publication> associatedPublications=new ArrayList<>();
        associatedPublications.addAll(publicationDAO.getAssociatedPublications(mod.getModelId()));
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
        req.setAttribute("relatedPublications", publicationDAO.getRelatedPublications(mod.getModelId()));
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a> / <a href='/toolkit/data/search/results/Model%20System?searchTerm='>Models</a>");
        req.setAttribute("seoDescription",model.getDescription());
        req.setAttribute("seoTitle",model.getDisplayName());
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

    @RequestMapping(value = "/edit")
    public String getModelForm(HttpServletRequest req, HttpServletResponse res,Model model) throws Exception{
        ModelDao dao = new ModelDao();

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
            edu.mcw.scge.datamodel.Model mod = dao.getModelById(Long.parseLong(req.getParameter("id")));
            req.setAttribute("model",mod);
            req.setAttribute("action","Update Model");
        }else {
            req.setAttribute("model", new edu.mcw.scge.datamodel.Model());
            req.setAttribute("action", "Create Model");
        }
        req.setAttribute("page", "/WEB-INF/jsp/edit/editModel");
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a> / <a href='/toolkit/data/search/results/Model%20System?searchTerm='>Models</a>");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
    @RequestMapping("/create")
    public String createModel(HttpServletRequest req,HttpServletResponse res,@ModelAttribute("model") edu.mcw.scge.datamodel.Model model) throws Exception {

        ModelDao dao = new ModelDao();
        long modelId = model.getModelId();
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
        if(model.getModelId() == 0) {
            modelId = dao.getModelId(model);
            if(modelId == 0) {
                modelId = dao.insertModel(model);
                req.setAttribute("status"," <span style=\"color: blue\">Model added successfully</span>");
            }else {
                req.setAttribute("status"," <span style=\"color: red\">Model already exists</span>");
            }
        }else {
            dao.updateModel(model);
            req.setAttribute("status"," <span style=\"color: blue\">Model updated successfully</span>");
        }

        req.getRequestDispatcher("/data/models/model?id="+modelId).forward(req,res);
        return null;
    }

}
