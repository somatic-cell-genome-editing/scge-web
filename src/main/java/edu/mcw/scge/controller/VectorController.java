package edu.mcw.scge.controller;

import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.configuration.UserService;
import edu.mcw.scge.dao.implementation.*;
import edu.mcw.scge.datamodel.*;
import edu.mcw.scge.service.db.DBService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Controller
@RequestMapping(value="/data/vector")
public class VectorController {
    VectorDao dao = new VectorDao();
    PublicationDAO publicationDAO=new PublicationDAO();
    @RequestMapping(value="/search")
    public String getVectors(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {

        List<Vector> records= dao.getAllVectors();
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a>");
        req.setAttribute("vectors", records);
        req.setAttribute("action", "Vector/Format");
        req.setAttribute("page", "/WEB-INF/jsp/tools/vectors");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

    @RequestMapping(value="/format")
    public String getVector(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        Vector v= dao.getVectorById(Long.parseLong(req.getParameter("id"))).get(0);
        DBService dbService = new DBService();
        UserService userService = new UserService();
        Person p=userService.getCurrentUser(req.getSession());
        edu.mcw.scge.configuration.Access access = new Access();

        if(!access.isLoggedIn()) {
            return "redirect:/";
        }

        if (!access.hasVectorAccess(v,p)) {
            req.setAttribute("page", "/WEB-INF/jsp/error");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            return null;

        }

        req.setAttribute("vector", v);
        req.setAttribute("action", "Vector/Format: " + v.getName());
        req.setAttribute("page", "/WEB-INF/jsp/tools/vector");

        StudyDao sdao = new StudyDao();
        List<Study> studies = sdao.getStudiesByVector(v.getVectorId());
        req.setAttribute("studies", studies);

        ProtocolDao pdao = new ProtocolDao();
        List<Protocol> protocols = pdao.getProtocolsForObject(v.getVectorId());
        req.setAttribute("protocols", protocols);
        req.setAttribute("publications", publicationDAO.getPublications(v.getVectorId()));

        ExperimentDao experimentDao= new ExperimentDao();
        List<ExperimentRecord> experimentRecords = experimentDao.getExperimentsByVector(v.getVectorId());

        req.setAttribute("experimentRecords",experimentRecords);

        HashMap<Long,List<Guide>> guideMap = new HashMap<>();
        for(ExperimentRecord record:experimentRecords) {
            guideMap.put(record.getExperimentRecordId(), dbService.getGuidesByExpRecId(record.getExperimentRecordId()));
        }
        req.setAttribute("guideMap", guideMap);

        HashMap<Long,List<Vector>> vectorMap = new HashMap<>();
        for(ExperimentRecord record:experimentRecords) {
            vectorMap.put(record.getExperimentRecordId(), dbService.getVectorsByExpRecId(record.getExperimentRecordId()));
        }
        req.setAttribute("vectorMap", vectorMap);
        if(studies!=null && studies.size()>0) {
            List<Long> associatedExperimentIds=experimentRecords.stream().map(r->r.getExperimentId()).distinct().collect(Collectors.toList());
            List<Experiment> assocatedExperiments=new ArrayList<>();

            for(long id:associatedExperimentIds){
                assocatedExperiments.add(experimentDao.getExperiment(id));
            }
            req.setAttribute("associatedExperiments", assocatedExperiments);}
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
    @RequestMapping(value = "/edit")
    public String getVectorForm(HttpServletRequest req, HttpServletResponse res,Vector vector) throws Exception{

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
            Vector v = dao.getVectorById(Long.parseLong(req.getParameter("id"))).get(0);
            req.setAttribute("vector",v);
            req.setAttribute("action","Update Vector");
        }else {
            req.setAttribute("vector", new Vector());
            req.setAttribute("action", "Create Vector");
        }

        List<Vector> records = dao.getAllVectors();
        Set<String> names = records.stream().map(Vector::getName).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> types = records.stream().map(Vector::getType).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> subTypes = records.stream().map(Vector::getSubtype).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> genomeSerotype = records.stream().map(Vector::getGenomeSerotype).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> capsidVariant = records.stream().map(Vector::getCapsidVariant).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> source = records.stream().map(Vector::getSource).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> capsidSerotype = records.stream().map(Vector::getCapsidSerotype).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> titerMethod = records.stream().map(Vector::getTiterMethod).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> labId = records.stream().map(Vector::getLabId).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());

        req.setAttribute("types",types);
        req.setAttribute("subTypes",subTypes);
        req.setAttribute("genomeSerotype",genomeSerotype);
        req.setAttribute("capsidVariant",capsidVariant);
        req.setAttribute("source",source);
        req.setAttribute("capsidSerotype",capsidSerotype);
        req.setAttribute("titerMethod",titerMethod);
        req.setAttribute("labId",labId);
        req.setAttribute("names",names);

        req.setAttribute("page", "/WEB-INF/jsp/edit/editVector");
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a> / <a href='/toolkit/data/vector/search'>Vectors</a>");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
    @RequestMapping("/create")
    public String createModel(HttpServletRequest req,HttpServletResponse res,@ModelAttribute("vector") Vector vector) throws Exception {

        long vectorId =  vector.getVectorId();
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
        if(vectorId == 0) {
            vectorId = dao.getVectorId(vector);
            if(vectorId == 0) {
                vectorId = dao.insertVector(vector);
                req.setAttribute("status"," <span style=\"color: blue\">Vector inserted successfully</span>");
            }else {
                req.setAttribute("status"," <span style=\"color: red\">Vector already exists</span>");
            }
        }else{
            dao.updateVector(vector);
            req.setAttribute("status"," <span style=\"color: blue\">Vector updated successfully</span>");
        }

        req.getRequestDispatcher("/data/vector/format?id="+vectorId).forward(req,res);
        return null;
    }

}
