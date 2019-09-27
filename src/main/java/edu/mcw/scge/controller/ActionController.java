package edu.mcw.scge.controller;

import edu.mcw.scge.datamodel.Person;
import edu.mcw.scge.datamodel.TestData;
import edu.mcw.scge.service.DataAccessService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Created by jthota on 8/23/2019.
 */
@Controller
@RequestMapping(value="/secure")
public class ActionController {
    DataAccessService service=new DataAccessService();


    @GetMapping(value="/create")
    public void createAddForm(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        if(req.getSession().getAttribute("token")!=null) {
            req.setAttribute("action", "details");
            req.setAttribute("destination", "create");
            req.setAttribute("page", "/WEB-INF/jsp/form");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        }else{
            req.setAttribute("message", "Please Login");
            res.sendRedirect("/scge/home?message="+"please login");
        }
    }
    @PostMapping(value="/create")
    public String createMember(HttpServletRequest req, HttpServletResponse res, Model model) throws IOException {

        if(req.getSession().getAttribute("token")!=null){
            Person person= new Person.Builder()
                .name(req.getParameter("name"))
          //      .institution(req.getParameter("institution"))
                    .firstName((String) req.getSession().getAttribute("givenName"))
                    .lastName((String) req.getSession().getAttribute("familyName"))
                .email((String)req.getSession().getAttribute("userEmail"))
                .otherId(req.getParameter("workEmail"))
                .googleSub((String)req.getSession().getAttribute("userId"))
                .address(req.getParameter("address"))
                .phone(req.getParameter("phone"))
                .status("processing")
                .modifiedBy("")
                .modifiedById("")
                .build();

      try{
          service.insertOrUpdate(person);
          HttpSession session=req.getSession(false);
          session.invalidate();
          String message="Thank you for registering with SCGE. You will receive a confirmation email shortly.";
           res.sendRedirect("/scge/home?message="+message);
        }catch (Exception e){
            e.printStackTrace();
        }
        }else {
            String message = "Please Login";
            res.sendRedirect("/scge/home?message=" + message);
        }
        return null;
    }
    @GetMapping(value="/dataSubmission")
    public String submission(HttpServletRequest req,HttpServletResponse res, Model model) throws ServletException, IOException {
        if(req.getSession().getAttribute("token")!=null) {

            req.setAttribute("action", "Submit data");
            req.setAttribute("destination", "dataSubmission");
            req.setAttribute("page", "/WEB-INF/jsp/submissions/submission");
            req.setAttribute("groupRoleMap",req.getSession().getAttribute("groupRoleMap"));
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        }else{
            req.setAttribute("message", "Please Login");
            res.sendRedirect("/scge/home?message="+"please login");
        }
        return null;
    }
    @PostMapping(value="/dataSubmission")
    public String createOrUpdate(HttpServletRequest req,HttpServletResponse res, Model model) throws ServletException, IOException {
        if(req.getSession().getAttribute("token")!=null) {

            req.setAttribute("action", "Add Experiment Data");
            req.setAttribute("destination", "dataSubmission");
            req.setAttribute("page", "/WEB-INF/jsp/submissions/newExperiment");
            req.setAttribute("experimentName", req.getParameter("createExperiment"));
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        }else{
            req.setAttribute("message", "Please Login");
            res.sendRedirect("/scge/home?message="+"please login");
        }
        return null;
    }

    @GetMapping(value="/form")
    public String getForm(HttpServletRequest req,HttpServletResponse res, Model model) throws ServletException, IOException {
        if(req.getSession().getAttribute("token")!=null) {

            req.setAttribute("action", "Add Experiment Data");
            req.setAttribute("destination", "submitForm");
            req.setAttribute("page", "/WEB-INF/jsp/submissions/newExperiment");
            req.setAttribute(req.getParameter("formType"), "/WEB-INF/jsp/submissions/"+req.getParameter("formType"));

            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        }else{
            req.setAttribute("message", "Please Login");
            res.sendRedirect("/scge/home?message="+"please login");
        }
        return "submissions/submission";
    }

    @RequestMapping(value="/submitForm")
    public String submitForm(HttpServletRequest req, Model model) throws Exception {
        String name=req.getParameter("name");
        String symbol=req.getParameter("symbol");
        List<TestData> records=service.insert(name,symbol);
        model.addAttribute("records", records);
        return "submissions/submitSucess";
    }
    @GetMapping(value="/unauthorizedUsers")
    public String getUnauthorizedUsers(HttpServletRequest req,HttpServletResponse res, Model model) throws Exception {
        if(req.getSession().getAttribute("token")!=null) {
            List<Person> unauthorizedUsers=service.getAllUnauthorizedUsers();
            req.setAttribute("action", "list");
            req.setAttribute("destination", "authorize");
            req.setAttribute("page", "/WEB-INF/jsp/unauthorizedUsers");
            req.setAttribute("unauthorizedUsers", unauthorizedUsers);

            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        }else{
            req.setAttribute("message", "Please Login");
            res.sendRedirect("/scge/home?message="+"please login");
        }
      //   return "unauthorizedUsers";
        return null;
    }
    @PostMapping(value="/authorize")
    public String authorize(HttpServletRequest req,HttpServletResponse res, Model model) throws Exception {
        if(req.getSession().getAttribute("token")!=null) {
            if(req.getParameter("status")!=null){
                service.updateUserStatus(req);
            }
            List<Person> unauthorizedUsers=service.getAllUnauthorizedUsers();
            req.setAttribute("action", "list");
            req.setAttribute("destination", "authorize");
            req.setAttribute("page", "/WEB-INF/jsp/unauthorizedUsers");
            req.setAttribute("unauthorizedUsers", unauthorizedUsers);

            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        }else{
            req.setAttribute("message", "Please Login");
            res.sendRedirect("/scge/home?message="+"please login");
        }
        //   return "unauthorizedUsers";
        return null;
    }
    @GetMapping(value="/memberProfile")
    public String getMembers(HttpServletRequest req,HttpServletResponse res, Model model) throws Exception {
        if(req.getSession().getAttribute("token")!=null) {

            req.setAttribute("action", "Get");
            req.setAttribute("destination", "memberProfile");
            req.setAttribute("page", "/WEB-INF/jsp/memberProfile");
            req.setAttribute("members",  service.getAllMembers());
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        }else{
            req.setAttribute("message", "Please Login");
            res.sendRedirect("/scge/home?message="+"please login");
        }
        //   return "unauthorizedUsers";
        return null;
    }
    @PostMapping(value="/memberProfile")
    public String getMemberProfile(HttpServletRequest req,HttpServletResponse res, Model model) throws Exception {
        if(req.getSession().getAttribute("token")!=null) {
            Person p=service.getPersonById(req.getParameter("scgemember")).get(0);
            req.setAttribute("memberId", req.getParameter("scgemember"));
            req.setAttribute("action", "Get");
            req.setAttribute("destination", "memberProfile");
            req.setAttribute("page", "/WEB-INF/jsp/memberProfile");
            req.setAttribute("member",  p);
            req.setAttribute("members",  service.getAllMembers());
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        }else{
            req.setAttribute("message", "Please Login");
            res.sendRedirect("/scge/home?message="+"please login");
        }
        //   return "unauthorizedUsers";
        return null;
    }

    @GetMapping(value="/groups")
    public String getGroups(HttpServletRequest req,HttpServletResponse res, Model model) throws Exception {
        if(req.getSession().getAttribute("token")!=null) {

            req.setAttribute("action", "Groups");
            req.setAttribute("destination", "groups");
            req.setAttribute("page", "/WEB-INF/jsp/groups");
            req.setAttribute("groups",  service.getSubGroupsByGroupName(req.getParameter("group")));
            req.setAttribute("groupName",  req.getParameter("group"));
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        }else{
            req.setAttribute("message", "Please Login");
            res.sendRedirect("/scge/home?message="+"please login");
        }
        //   return "unauthorizedUsers";
        return null;
    }
    @GetMapping(value="/members")
    public String getAllMembers(HttpServletRequest req,HttpServletResponse res, Model model) throws Exception {
        if(req.getSession().getAttribute("token")!=null) {
             req.setAttribute("action", "Members");
            req.setAttribute("destination", "members");
            req.setAttribute("page", "/WEB-INF/jsp/members");
             req.setAttribute("groupMembers",  service.getGroupMembers(req.getParameter("group")));
            req.setAttribute("groupName",  (req.getParameter("group")));
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        }else{
            req.setAttribute("message", "Please Login");
            res.sendRedirect("/scge/home?message="+"please login");
        }
        //   return "unauthorizedUsers";
        return null;
    }
    @GetMapping(value="/joinGroup")
    public String getGroup(HttpServletRequest req,HttpServletResponse res, Model model) throws Exception {
        if(req.getSession().getAttribute("token")!=null) {

            req.setAttribute("action", "Get");
            req.setAttribute("destination", "joinGroup");
            req.setAttribute("page", "/WEB-INF/jsp/joinGroup");
            //  req.setAttribute("groups",  service.getAllGroups());
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        }else{
            req.setAttribute("message", "Please Login");
            res.sendRedirect("/scge/home?message="+"please login");
        }
        //   return "unauthorizedUsers";
        return null;
    }
    @GetMapping(value="/leaveGroup")
    public String leaveGroup(HttpServletRequest req,HttpServletResponse res, Model model) throws Exception {
        if(req.getSession().getAttribute("token")!=null) {

            req.setAttribute("action", "Get");
            req.setAttribute("destination", "leaveGroup");
            req.setAttribute("page", "/WEB-INF/jsp/leaveGroup");
            //  req.setAttribute("groups",  service.getAllGroups());
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        }else{
            req.setAttribute("message", "Please Login");
            res.sendRedirect("/scge/home?message="+"please login");
        }
        //   return "unauthorizedUsers";
        return null;
    }
}
