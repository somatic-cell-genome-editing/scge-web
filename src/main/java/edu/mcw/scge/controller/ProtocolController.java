package edu.mcw.scge.controller;

import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.configuration.UserService;
import edu.mcw.scge.dao.implementation.*;
import edu.mcw.scge.datamodel.*;
import edu.mcw.scge.service.db.DBService;
import edu.mcw.scge.web.UI;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

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
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a> / <a href='/toolkit/data/models/search'>Models</a>");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
}
