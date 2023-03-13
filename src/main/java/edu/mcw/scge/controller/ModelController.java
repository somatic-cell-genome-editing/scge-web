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
public class ModelController extends ObjectController{
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
        req.setAttribute("summaryBlocks", getSummary(mod));
        req.setAttribute("model", mod);
        req.setAttribute("action","Model System: " + mod.getDisplayName());
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
            mapProjectNExperiments(experimentRecords, req);}
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
        req.setAttribute("seoDescription",mod.getDescription());
        req.setAttribute("seoTitle",mod.getDisplayName());
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
    public Map<String, Map<String, String>> getSummary(edu.mcw.scge.datamodel.Model object){
        Map<String, Map<String, String>> summaryBlocks=new LinkedHashMap<>();
        Map<String, String> summary=new LinkedHashMap<>();
        int i=0;
        summary.put("SCGE ID", String.valueOf(object.getModelId()));

        if(object.getDisplayName()!=null && !object.getDisplayName().equals("")) {
            summary.put("Name", object.getDisplayName());
        } else if(object.getName()!=null && !object.getName().equals("")) {
            summary.put("Name", object.getName());
        }

        if(object.getOfficialName()!=null && !object.getOfficialName().equals(""))
            summary.put("Official Name", object.getOfficialName());
        if(object.getStrainAlias()!=null && !object.getStrainAlias().equals(""))
            summary.put("Alias", object.getStrainAlias());
        if(object.getOrganism()!=null && !object.getOrganism().equals(""))
            summary.put("Species", object.getOrganism());
        if(object.getType()!=null && !object.getType().equals(""))
            summary.put("Type", object.getType());
        if(object.getSubtype()!=null && !object.getSubtype().equals(""))
            summary.put("Subtype", object.getSubtype());

        if(object.getDescription()!=null && !object.getDescription().equals(""))
            summary.put("Description", object.getDescription());
        if(object.getParentalOrigin()!=null && !object.getParentalOrigin().equals("") ) {

            String parentalOrigin = object.getParentalOrigin();
            long modelId = 0;
            try {
                modelId = Long.parseLong(parentalOrigin);
                if( modelId > 0 ) {
                    summary.put("Parental Origin", parentalOrigin + " <a href='/toolkit/data/models/model?id=" + modelId + "'>View animal model</a>");
                }
            } catch(NumberFormatException e) {
                summary.put("Parental Origin", parentalOrigin);
            }
        }
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
        if(object.getTransgene()!=null && !object.getTransgene().equals(""))
            summary.put("Transgene", object.getTransgene());
        if(object.getTransgeneDescription()!=null && !object.getTransgeneDescription().equals(""))
            summary.put("Transgene Description", object.getTransgeneDescription());
        if(object.getTransgeneReporter()!=null && !object.getTransgeneReporter().equals(""))
            summary.put("Reporter", object.getTransgeneReporter());
        if(object.getAnnotatedMap()!=null && !object.getAnnotatedMap().equals(""))
            summary.put("Annotated Map", object.getAnnotatedMap());
        if(summary.size()>0) {
            summaryBlocks.put("block"+i, summary);
        }
        return summaryBlocks;
    }

}
