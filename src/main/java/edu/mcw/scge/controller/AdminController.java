package edu.mcw.scge.controller;

import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.configuration.UserService;
import edu.mcw.scge.dao.implementation.GroupDAO;
import edu.mcw.scge.dao.implementation.PersonDao;
import edu.mcw.scge.datamodel.Person;
import edu.mcw.scge.datamodel.PersonInfo;
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
            req.setAttribute("people", personDao.getAllActiveMembers());
            req.setAttribute("person",userService.getCurrentUser(req.getSession()));
            req.setAttribute("action", "Administration");
            req.setAttribute("page", "/WEB-INF/jsp/admin/admin");
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

        req.setAttribute("people", pdao.getAllActiveMembers());
        req.setAttribute("person",p);
        req.setAttribute("action", "Administration");
        req.setAttribute("page", "/WEB-INF/jsp/admin/admin");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);


    }

    @RequestMapping(value = "/users")
    public void getUsers(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        UserService userService=new UserService();
        Access access= new Access();
        if (!access.isAdmin(userService.getCurrentUser(req.getSession()))) {
            req.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(req, res);
        }

        PersonDao personDao = new PersonDao();
        req.setAttribute("people", personDao.getAllMembers());
        req.setAttribute("person",userService.getCurrentUser(req.getSession()));
        req.setAttribute("action", "Manage Users");
        req.setAttribute("page", "/WEB-INF/jsp/admin/users");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);


    }

    @RequestMapping(value = "/groups")
    public void getGroups(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {

        UserService userService=new UserService();
        Access access= new Access();
        if (!access.isAdmin(userService.getCurrentUser(req.getSession()))) {
            req.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(req, res);
        }

        req.setAttribute("action", "Manage Groups");
        req.setAttribute("page", "/WEB-INF/jsp/admin/groups");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        System.out.println("here5");


    }

    @RequestMapping(value = "/addUser")
    public void getAddUser(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        UserService userService=new UserService();
        Access access= new Access();
        if (!access.isAdmin(userService.getCurrentUser(req.getSession()))) {
            req.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(req, res);
        }



        String name = req.getParameter("name");
        int institution = Integer.parseInt(req.getParameter("institution"));
        String gEmail = req.getParameter("gEmail");
        String oEmail = req.getParameter("oEmail");




        PersonDao pdao = new PersonDao();


        Person p = new Person.Builder().build();

        p.setName(name);
        p.setInstitution(institution);
        p.setEmail(gEmail);
        p.setStatus("ACTIVE");
        if (oEmail != null && !oEmail.equals("")) {
            p.setOtherId(oEmail);
        }

        if (pdao.exists(p)) {
            System.out.println("user exists");
            throw new Exception("User already exists");
        }else {
            System.out.println("inserting user");
            pdao.insert(p);
        }

        req.setAttribute("people", pdao.getAllActiveMembers());
        req.setAttribute("person",userService.getCurrentUser(req.getSession()));
        req.setAttribute("action", "Manage Users");
        req.setAttribute("page", "/WEB-INF/jsp/admin/users");
        req.setAttribute("msg","User " + p.getName() + " Added");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);


    }

    @RequestMapping(value = "/updateUser")
    public void getUpdateUser(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        UserService userService=new UserService();
        Access access= new Access();
        if (!access.isAdmin(userService.getCurrentUser(req.getSession()))) {
            req.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(req, res);
        }


        int id=Integer.parseInt(req.getParameter("id"));
        String name = req.getParameter("name");
        int institution = Integer.parseInt(req.getParameter("institution"));
        String gEmail = req.getParameter("gEmail");
        String oEmail = req.getParameter("oEmail");
        String status = req.getParameter("status");
        PersonDao pdao = new PersonDao();

        Person p = pdao.getPersonById(Integer.parseInt(req.getParameter("id"))).get(0);

        p.setId(id);
        p.setName(name);
        p.setInstitution(institution);
        p.setEmail(gEmail);
        p.setStatus(status);
        if (oEmail != null && !oEmail.equals("")) {
            p.setOtherId(oEmail);
        }

        pdao.update(p);

        req.setAttribute("people", pdao.getAllActiveMembers());
        req.setAttribute("person",userService.getCurrentUser(req.getSession()));
        req.setAttribute("action", "Manage Users");
        req.setAttribute("page", "/WEB-INF/jsp/admin/users");
        req.setAttribute("msg","User " + p.getName() + " Updated");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);


    }


    @RequestMapping(value = "/removeUser")
    public void getRemoveUser(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        UserService userService=new UserService();
        Access access= new Access();
        if (!access.isAdmin(userService.getCurrentUser(req.getSession()))) {
            req.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(req, res);
        }

        PersonDao pdao = new PersonDao();
        Person p = pdao.getPersonById(Integer.parseInt(req.getParameter("id"))).get(0);

        pdao.delete(p);

        req.setAttribute("people", pdao.getAllActiveMembers());
        req.setAttribute("person",userService.getCurrentUser(req.getSession()));
        req.setAttribute("action", "Manage Users");
        req.setAttribute("msg","User " + p.getName() + " Deleted");
        req.setAttribute("page", "/WEB-INF/jsp/admin/users");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);


    }


    @RequestMapping(value = "/addGroup")
    public void getAddGroup(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        UserService userService=new UserService();
        Access access= new Access();
        if (!access.isAdmin(userService.getCurrentUser(req.getSession()))) {
            req.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(req, res);
        }

        int groupId=Integer.parseInt(req.getParameter("gid"));

        PersonDao pdao = new PersonDao();
        Person p = pdao.getPersonById(Integer.parseInt(req.getParameter("id"))).get(0);

        pdao.insertPersonInfo(p.getId(),1,groupId);

        req.setAttribute("action", "Manage Groups");
        req.setAttribute("page", "/WEB-INF/jsp/admin/groups");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);


    }

    @RequestMapping(value = "/removeGroup")
    public void getRemoveGroup(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        UserService userService=new UserService();
        Access access= new Access();
        if (!access.isAdmin(userService.getCurrentUser(req.getSession()))) {
            req.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(req, res);
        }

        int groupId=Integer.parseInt(req.getParameter("gid"));

        PersonDao pdao = new PersonDao();
        Person p = pdao.getPersonById(Integer.parseInt(req.getParameter("id"))).get(0);
        System.out.println("in remove");

        pdao.deletePersonInfo(p.getId(),groupId);

        req.setAttribute("action", "Manage Groups");
        req.setAttribute("page", "/WEB-INF/jsp/admin/groups");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

    }

}

