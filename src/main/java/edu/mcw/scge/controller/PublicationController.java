package edu.mcw.scge.controller;

import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.configuration.UserService;
import edu.mcw.scge.dao.implementation.PublicationDAO;
import edu.mcw.scge.datamodel.*;
import edu.mcw.scge.datamodel.publications.Publication;
import edu.mcw.scge.datamodel.publications.Reference;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping(value="/data/publications")
public class PublicationController {
    PublicationDAO publicationDAO=new PublicationDAO();
    @RequestMapping(value="/search")
    public String getEditors(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        Access access = new Access();
        UserService us = new UserService();
        Person p = us.getCurrentUser(req.getSession());

        List<Reference> references = publicationDAO.getAllReferences();
        List<Publication> publications=new ArrayList<>();
        for(Reference ref:references){
            Publication publication=new Publication();
            publication.setReference(ref);
            publication.setAuthorList(publicationDAO.getAuthorsByRefKey(ref.getKey()));
            publication.setArticleIds(publicationDAO.getArticleIdsByRefKey(ref.getKey()));
            publications.add(publication);
        }
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a>");
        req.setAttribute("publications", publications);
        req.setAttribute("action", "Publications");
        req.setAttribute("page", "/WEB-INF/jsp/tools/publications/publications");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
}
