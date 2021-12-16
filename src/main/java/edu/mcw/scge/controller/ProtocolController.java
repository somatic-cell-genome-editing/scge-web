package edu.mcw.scge.controller;

import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.configuration.UserService;
import edu.mcw.scge.dao.implementation.*;
import edu.mcw.scge.datamodel.*;
import edu.mcw.scge.service.db.DBService;
import edu.mcw.scge.storage.FileSystemStorageService;
import edu.mcw.scge.storage.StorageProperties;
import edu.mcw.scge.web.UI;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping(value="/data/protocols")
public class ProtocolController {
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
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

    @RequestMapping(value="/protocol")
    public String getProtocol(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        ProtocolDao dao = new ProtocolDao();

        Protocol protocol= dao.getProtocolById(Long.parseLong(req.getParameter("id")));


        req.setAttribute("crumbTrail",   "hello world");

        req.setAttribute("protocol", protocol);
        req.setAttribute("action","Protocol: " + protocol.getTitle());
        req.setAttribute("page", "/WEB-INF/jsp/tools/protocol");
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a> / <a href='/toolkit/data/protocols/search'>Protocols</a>");
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

        if (!access.isInDCCorNIHGroup(p)) {
            req.setAttribute("page", "/WEB-INF/jsp/error");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            return null;

        }

        if(req.getParameter("id") != null) {
           Protocol pro = protocolDao.getProtocolById(Long.parseLong(req.getParameter("id")));
            StorageProperties properties = new StorageProperties();
            properties.setLocation("/data/scge_protocols");
            FileSystemStorageService service = new FileSystemStorageService(properties);
            MultipartFile file = (MultipartFile) service.loadAsResource(pro.getFilename());
            pro.setFile(file);
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
    public String createModel(HttpServletRequest req,HttpServletResponse res,@ModelAttribute("protocol") Protocol protocol) throws Exception {

        long protocolId = protocol.getId();
        UserService userService = new UserService();
        Person p=userService.getCurrentUser(req.getSession());
        edu.mcw.scge.configuration.Access access = new Access();

        if(!access.isLoggedIn()) {
            return "redirect:/";
        }

        if (!access.isInDCCorNIHGroup(p)) {
            req.setAttribute("page", "/WEB-INF/jsp/error");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            return null;
        }

        String filename = StringUtils.cleanPath(protocol.getFile().getOriginalFilename());

        protocol.setFilename(filename);
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
                req.setAttribute("status"," <span style=\"color: blue\">Protocol added successfully</span>");
            }else {
                req.setAttribute("status"," <span style=\"color: red\">Protocol already exists</span>");
            }
        }else {
            Protocol old = protocolDao.getProtocolById(protocolId);
            if(protocol.getFilename() == null)
                protocol.setFilename(old.getFilename());
            else {
                StorageProperties properties = new StorageProperties();
                properties.setLocation("/data/scge_protocols");
                FileSystemStorageService service = new FileSystemStorageService(properties);
                service.store(protocol.getFile());
            }
            protocolDao.updateProtocol(protocol);
            req.setAttribute("status"," <span style=\"color: blue\">Protocol updated successfully</span>");
        }

        req.getRequestDispatcher("/data/protocols/protocol?id="+protocolId).forward(req,res);
        return null;
    }

}
