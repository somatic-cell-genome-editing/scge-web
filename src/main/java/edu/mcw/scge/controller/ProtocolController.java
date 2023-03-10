package edu.mcw.scge.controller;

import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.configuration.UserService;
import edu.mcw.scge.dao.implementation.*;
import edu.mcw.scge.datamodel.*;
import edu.mcw.scge.service.db.DBService;
import edu.mcw.scge.storage.FileSystemStorageService;
import edu.mcw.scge.storage.StorageProperties;

import org.springframework.core.io.Resource;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping(value="/data/protocols")
public class ProtocolController extends ObjectController{
    ProtocolDao protocolDao = new ProtocolDao();

    @RequestMapping(value="/search")
    public String getEditors(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        Access access = new Access();
        UserService us = new UserService();
        Person p = us.getCurrentUser(req.getSession());

        List<Protocol> records = protocolDao.getProtocols();

        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a>");
        req.setAttribute("protocols", records);
        req.setAttribute("action", "Protocols");
        req.setAttribute("page", "/WEB-INF/jsp/tools/protocols");
        req.setAttribute("seoDescription","Listing of protocols submitted to the Somatic Cell Genome Editing consortium");
        req.setAttribute("seoTitle","Protocols");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

    @RequestMapping(value="/associate")
    public String getAssociatedEditors(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {

        UserService userService=new UserService();
        Access access= new Access();
        if (!access.isAdmin(userService.getCurrentUser(req.getSession()))) {
            req.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(req, res);
        }

        String objectId = req.getParameter("objectId");

        List<Protocol> records = protocolDao.getProtocolsNotAssociatedToObject(Long.parseLong(objectId));

        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a>");
        req.setAttribute("protocols", records);
        req.setAttribute("action", "Assocate Protocols");
        req.setAttribute("page", "/WEB-INF/jsp/tools/associateProtocols");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

    @RequestMapping(value="/removeAssociation")
    public String getRemoveAssociations(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        UserService userService=new UserService();
        Access access= new Access();
        if (!access.isAdmin(userService.getCurrentUser(req.getSession()))) {
            req.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(req, res);
        }




        String objectId = req.getParameter("objectId");
        String redirectURL = req.getParameter("redirectURL");
        String protocolId = req.getParameter("protocolId");

        protocolDao.deleteProtocolAssociation(Long.parseLong(protocolId),Long.parseLong(objectId));

        return "redirect:" + redirectURL;
    }


    @RequestMapping(value="/updateAssociations")
    public String getUpdateAssociations(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        UserService userService=new UserService();
        Access access= new Access();
        if (!access.isAdmin(userService.getCurrentUser(req.getSession()))) {
            req.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(req, res);
        }


        String objectId = req.getParameter("objectId");
        String redirectURL = req.getParameter("redirectURL");
        String[] protocolIds = req.getParameterValues("protocolIds");

        for (int i=0; i<protocolIds.length; i++) {
            protocolDao.insertProtocolAssociation(Long.parseLong(protocolIds[i]),Long.parseLong(objectId));

        }

        return "redirect:" + redirectURL;
    }


    @RequestMapping(value="/protocol")
    public String getProtocol(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        ProtocolDao dao = new ProtocolDao();

        Protocol protocol= dao.getProtocolById(Long.parseLong(req.getParameter("id")));

        UserService userService = new UserService();
        Person p=userService.getCurrentUser(req.getSession());
        edu.mcw.scge.configuration.Access access = new Access();

        if (!access.hasProtocolAccess(protocol,p)) {
            req.setAttribute("page", "/WEB-INF/jsp/error");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            return null;

        }
        ProtocolAssociation protocolAssociation=protocolDao.getProtocolAssociations(protocol.getId());
        List<Study> studies=protocolAssociation.getAssociatedStudies();
        if(studies!=null && studies.size()>0) {
            List<ExperimentRecord> experimentRecords=new ArrayList<>();
            if(protocolAssociation.getAssociatedExperiments()!=null){
                for(Experiment experiment:protocolAssociation.getAssociatedExperiments()){
                    List<ExperimentRecord> records=experimentDao.getExperimentRecords(experiment.getExperimentId());
                    experimentRecords.addAll(records);
                }
            }
            mapProjectNExperiments(experimentRecords, req);
        }
        req.setAttribute("summaryBlocks", getSummary(protocol));
        req.setAttribute("crumbTrail",   "hello world");
        req.setAttribute("protocol", protocol);
        req.setAttribute("protocolAssociations", protocolAssociation);
        req.setAttribute("studies", studies);
        req.setAttribute("action","Protocol: " + protocol.getTitle());
        req.setAttribute("page", "/WEB-INF/jsp/tools/protocol");
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a> / <a href='/toolkit/data/protocols/search'>Protocols</a>");
        req.setAttribute("seoDescription",protocol.getDescription());
        req.setAttribute("seoTitle",protocol.getTitle());
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
    @RequestMapping(value = "/edit")
    public String getProtocolForm(HttpServletRequest req, HttpServletResponse res,Protocol protocol) throws Exception{

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
           Protocol pro = protocolDao.getProtocolById(Long.parseLong(req.getParameter("id")));
            req.setAttribute("protocol",pro);
            req.setAttribute("action","Update Protocol");
        }else {
            req.setAttribute("protocol", new Protocol());
            req.setAttribute("action", "Create Protocol");
        }
        req.setAttribute("page", "/WEB-INF/jsp/edit/editProtocol");
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a> / <a href='/toolkit/data/protocols/search'>Protocols</a>");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
    @RequestMapping("/create")
    public String createProtocol(HttpServletRequest req,HttpServletResponse res,@ModelAttribute("protocol") Protocol protocol) throws Exception {

        long protocolId = protocol.getId();
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

        if(protocol.getFile() != null ) {
            protocol.setFilename(StringUtils.cleanPath(protocol.getFile().getOriginalFilename()));
        }

        if(protocolId == 0) {
            protocolId = protocolDao.getProtocolId(protocol);
            if(protocolId == 0) {
                protocolId = protocolDao.insertProtocol(protocol);
                if(protocol.getFilename() != null) {
                    StorageProperties properties = new StorageProperties();
                    properties.setLocation("/data/scge_protocols");
                    FileSystemStorageService service = new FileSystemStorageService(properties);
                    service.store(protocol.getFile());
                }
                System.out.println(protocolId);
                req.setAttribute("status"," <span style=\"color: blue\">Protocol added successfully</span>");
            }else {
                req.setAttribute("status"," <span style=\"color: red\">Protocol already exists</span>");
            }
        }else {
            Protocol old = protocolDao.getProtocolById(protocolId);

            if(protocol.getFile().isEmpty()) {
                protocol.setFilename(old.getFilename());
            }else {
                StorageProperties properties = new StorageProperties();
                properties.setLocation("/data/scge_protocols");
                FileSystemStorageService service = new FileSystemStorageService(properties);
                service.store(protocol.getFile());
            }
            protocolDao.updateProtocol(protocol);
            req.setAttribute("status"," <span style=\"color: blue\">Protocol updated successfully</span>");
        }

        return "redirect:" + "/data/protocols/protocol?id="+protocolId;
        //req.getRequestDispatcher("/data/protocols/protocol?id="+protocolId).forward(req,res);
    }
    public  Map<String, Map<String, String>> getSummary(Protocol protocol){
        Map<String, Map<String, String>> summaryBlocks=new LinkedHashMap<>();

        Map<String, String> summary=new LinkedHashMap<>();
        int i=0;
        summary.put("SCGE ID", String.valueOf(protocol.getId()));
        if(protocol.getTitle()!=null && !protocol.getTitle().equals(""))
            summary.put("Title", protocol.getTitle());
        if(protocol.getDescription()!=null && !protocol.getDescription().equals(""))
            summary.put("Description", protocol.getDescription());
            summary.put("Tier", String.valueOf(protocol.getTier()));
        if(protocol.getFilename()!=null && !protocol.getFilename().equals("")) {
            String fileDownload="<a href='/toolkit/files/protocol/"+protocol.getFilename()+"'>"+protocol.getFilename()+"</a>";
            summary.put("File Download", fileDownload);
        }
        if(protocol.getXref()!=null && !protocol.getXref().equals(""))
            summary.put("Additional Information", protocol.getXref());
        if(protocol.getKeywords()!=null && !protocol.getKeywords().equals(""))
            summary.put("Keywords", protocol.getKeywords());
        if(summary.size()>0) {
            summaryBlocks.put("block"+i, summary);
            i++;
            summary=new LinkedHashMap<>();
        }

        return summaryBlocks;
    }
}
