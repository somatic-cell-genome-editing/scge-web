package edu.mcw.scge.controller;

import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.configuration.UserService;
import edu.mcw.scge.dao.implementation.PersonDao;
import edu.mcw.scge.datamodel.Person;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

/**
 * Created by jthota on 9/20/2019.
 */
@Controller
@RequestMapping(value="/admin")
public class AdminController extends LoginController{

    @RequestMapping(value = "")
    public void getAdmin(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {

        UserService userService=new UserService();
        Access access= new Access();
        if (!access.isAdmin(userService.getCurrentUser(req.getSession()))) {
            req.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(req, res);
        }

            PersonDao personDao = new PersonDao();
            req.setAttribute("people", personDao.getAllMembers());
            req.setAttribute("action", "Administration");
            req.setAttribute("page", "/WEB-INF/jsp/admin");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

    }

    @RequestMapping(value = "/sudo")
    public void getSudo(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        UserService userService=new UserService();
        Access access= new Access();
        if (!access.isAdmin(userService.getCurrentUser(req.getSession()))) {
            req.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(req, res);
        }

        PersonDao pdao = new PersonDao();

        HttpSession sess = req.getSession();
        Person p = pdao.getPersonById(Integer.parseInt(req.getParameter("person"))).get(0);
        userService.setCurrentUser(p,sess);


        Map attributes = (Map) sess.getAttribute("userAttributes");
        attributes.put("email", p.getEmail());
        attributes.put("name", p.getName());
        attributes.put("personId",p.getId());

        sess.setAttribute("userAttributes",attributes);

        req.setAttribute("action", "Become User");
        req.setAttribute("page", "/WEB-INF/jsp/sudo");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

    }


}

