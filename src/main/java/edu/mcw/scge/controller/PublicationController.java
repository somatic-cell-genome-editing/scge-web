package edu.mcw.scge.controller;

import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.configuration.UserService;
import edu.mcw.scge.dao.implementation.PublicationDAO;
import edu.mcw.scge.datamodel.*;
import edu.mcw.scge.datamodel.publications.Publication;
import edu.mcw.scge.datamodel.publications.Reference;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Controller
@RequestMapping(value="/data/publications")
public class PublicationController {
    PublicationDAO publicationDAO=new PublicationDAO();
    @RequestMapping(value="/search")
    public String getEditors(HttpServletRequest req, HttpServletResponse res) throws Exception {
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
    @GetMapping(value="/add")
    public String getPublication(HttpServletRequest req, HttpServletResponse res) throws Exception {

        UserService userService=new UserService();
        Access access= new Access();
        if (!access.isAdmin(userService.getCurrentUser(req.getSession()))) {
            req.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(req, res);
        }

        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a>/<a href='/toolkit/data/publications/search'>Publications</a>");
        req.setAttribute("action", "Add New Publication");
        req.setAttribute("page", "/WEB-INF/jsp/tools/publications/addPublication");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
    @RequestMapping(value="/add" , method = RequestMethod.POST)
    public String insertPublication(HttpServletRequest req, HttpServletResponse res) throws Exception {

        UserService userService=new UserService();
        Access access= new Access();
        if (!access.isAdmin(userService.getCurrentUser(req.getSession()))) {
            req.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(req, res);
        }
        String identifier=req.getParameter("identifier");
        String identifierType="pubmed";

        int key=publicationDAO.getPubIdKey(identifier,identifierType);
                if(key==0){
                    publicationDAO.insertPubIds(publicationDAO.getNextKey("pub_id_key_seq"),0,identifier,identifierType);
                    publicationDAO.runPubmedProcesssor(Integer.parseInt(identifier));

                }


        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a>/<a href='/toolkit/data/publications/search'>Publications</a>");
        req.setAttribute("action", "Add New Publication");
        req.setAttribute("page", "/WEB-INF/jsp/tools/publications/addPublication");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
    @RequestMapping(value="/associate")
    public String getAssociationSelectFormPage(HttpServletRequest req, HttpServletResponse res) throws Exception {

        UserService userService=new UserService();
        Access access= new Access();
        if (!access.isAdmin(userService.getCurrentUser(req.getSession()))) {
            req.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(req, res);
        }

        String objectId=req.getParameter("objectId");
        if(objectId!=null) {
            long id = Long.parseLong(objectId);
            List<Reference> references = publicationDAO.getReferencesNotAssociatedByObjectId(id);

            List<Publication> publications = new ArrayList<>();
            for (Reference ref : references) {
                Publication publication = new Publication();
                publication.setReference(ref);
                publication.setAuthorList(publicationDAO.getAuthorsByRefKey(ref.getKey()));
                publication.setArticleIds(publicationDAO.getArticleIdsByRefKey(ref.getKey()));
                publications.add(publication);
            }
            System.out.println("REDIRECT URL IN association form"+ req.getParameter("redirectURL"));
            req.setAttribute("redirectURL",req.getParameter("redirectURL"));
            req.setAttribute("objectId", req.getParameter("objectId"));
            req.setAttribute("publications", publications);
            req.setAttribute("crumbtrail", "<a href='/toolkit/loginSuccess?destination=base'>Home</a>/<a href='/toolkit/data/publications/search'>Publications</a>");
            req.setAttribute("action", "Associate Publication");
            req.setAttribute("page", "/WEB-INF/jsp/tools/publications/associatePublications");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        }
            return null;

    }
    @RequestMapping(value="/associate", method = RequestMethod.POST)
    public String makeAssociation(HttpServletRequest req, HttpServletResponse res) throws Exception {

        UserService userService=new UserService();
        Access access= new Access();
        if (!access.isAdmin(userService.getCurrentUser(req.getSession()))) {
            req.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(req, res);
        }
        String objectId=req.getParameter("objectId");

        String redirectURL = req.getParameter("redirectURL");
        String[] refKeyValues=req.getParameterValues("refKey");
        for(int i=0;i<refKeyValues.length;i++){
            String refKey=refKeyValues[i];
            String type=req.getParameter("associationType"+refKey);
            if(type!=null){
                System.out.println("REFKEY:"+refKey+"\tTYPE:"+type);
               boolean existsAssociation= publicationDAO.existsAssociation(Integer.parseInt(refKey),Long.parseLong(objectId));
               if(!existsAssociation)
                publicationDAO.insertPubAssociations(Integer.parseInt( refKey),Long.parseLong(objectId),type);
            }
        }
        System.out.println("REDIRECT URL IN insertPubAssociations"+ req.getParameter("redirectURL"));


        return "redirect:"+redirectURL;
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
        String refKey = req.getParameter("refKey");

        publicationDAO.deletePubAssociation(Long.parseLong(objectId),Integer.parseInt(refKey));

        return "redirect:" + redirectURL;
    }

}
