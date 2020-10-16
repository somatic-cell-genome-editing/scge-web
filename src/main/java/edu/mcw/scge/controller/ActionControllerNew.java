package edu.mcw.scge.controller;

import edu.mcw.scge.datamodel.Person;
import edu.mcw.scge.datamodel.TestData;
import edu.mcw.scge.service.DataAccessService;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Created by jthota on 11/20/2019.
 */
@Controller

//@RequestMapping(value="/")
public class ActionControllerNew {
    DataAccessService service=new DataAccessService();

   @GetMapping(value="/create")
    public void createAddForm(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {

            req.setAttribute("action", "details");
            req.setAttribute("destination", "create");
            req.setAttribute("page", "/WEB-INF/jsp/form");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

    }
    @PostMapping(value="/create")
    public String createMember(HttpServletRequest req, HttpServletResponse res, Model model) throws IOException {


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

        return null;
    }
    @RequestMapping(value="/dataSubmission")
    public String submission(HttpServletRequest req,HttpServletResponse res, Model model) throws ServletException, IOException {

            req.setAttribute("action", "Data Submission System");
            req.setAttribute("destination", "dataSubmission");
            req.setAttribute("page", "/WEB-INF/jsp/submissions/submission");
            req.setAttribute("groupRoleMap",req.getSession().getAttribute("groupRoleMap"));
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }


   /* @PostMapping(value="/datasubmission/upload")
    public String upload(HttpServletRequest req,HttpServletResponse res, Model model) throws ServletException, IOException {

        req.setAttribute("action", "Successfully submitted");

        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }*/
   @RequestMapping(value = "/uploadFile", method = RequestMethod.POST)
   public String submit(@RequestParam("file") MultipartFile file, ModelMap modelMap) {
       System.out.println("in the controller");
       modelMap.addAttribute("file", file);
       return "submissions/fileUploadView";
   }
    @RequestMapping(value="/submit")
    public String createOrUpdate(HttpServletRequest req,HttpServletResponse res, Model model) throws ServletException, IOException {

            req.setAttribute("action", "Add Experiment Data");
            req.setAttribute("destination", "dataSubmission");
            req.setAttribute("page", "/WEB-INF/jsp/submissions/newExperiment");
            req.setAttribute("experimentName", req.getParameter("createExperiment"));
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

    @GetMapping(value="/form")
    public String getForm(HttpServletRequest req,HttpServletResponse res, Model model) throws ServletException, IOException {

            req.setAttribute("action", "Add Experiment Data");
            req.setAttribute("destination", "submitForm");
            req.setAttribute("page", "/WEB-INF/jsp/submissions/newExperiment");
            req.setAttribute(req.getParameter("formType"), "/WEB-INF/jsp/submissions/"+req.getParameter("formType"));

            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

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

            List<Person> unauthorizedUsers=service.getAllUnauthorizedUsers();
            req.setAttribute("action", "list");
            req.setAttribute("destination", "authorize");
            req.setAttribute("page", "/WEB-INF/jsp/unauthorizedUsers");
            req.setAttribute("unauthorizedUsers", unauthorizedUsers);

            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        //   return "unauthorizedUsers";
        return null;
    }
    @PostMapping(value="/authorize")
    public String authorize(HttpServletRequest req,HttpServletResponse res, Model model) throws Exception {

            if(req.getParameter("status")!=null){
                service.updateUserStatus(req);
            }
            List<Person> unauthorizedUsers=service.getAllUnauthorizedUsers();
            req.setAttribute("action", "list");
            req.setAttribute("destination", "authorize");
            req.setAttribute("page", "/WEB-INF/jsp/unauthorizedUsers");
            req.setAttribute("unauthorizedUsers", unauthorizedUsers);

            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        //   return "unauthorizedUsers";
        return null;
    }
    @GetMapping(value="/memberProfile")
    public String getMembers(HttpServletRequest req,HttpServletResponse res, Model model) throws Exception {

            req.setAttribute("action", "Get");
            req.setAttribute("destination", "memberProfile");
            req.setAttribute("page", "/WEB-INF/jsp/memberProfile");
            req.setAttribute("members",  service.getAllMembers());
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
    @PostMapping(value="/memberProfile")
    public String getMemberProfile(HttpServletRequest req,HttpServletResponse res, Model model) throws Exception {

            Person p=service.getPersonById(req.getParameter("scgemember")).get(0);
            req.setAttribute("memberId", req.getParameter("scgemember"));
            req.setAttribute("action", "Get");
            req.setAttribute("destination", "memberProfile");
            req.setAttribute("page", "/WEB-INF/jsp/memberProfile");
            req.setAttribute("member",  p);
            req.setAttribute("members",  service.getAllMembers());
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        //   return "unauthorizedUsers";
        return null;
    }

    @RequestMapping(value="/groups")
    public String getGroups(HttpServletRequest req,HttpServletResponse res, Model model) throws Exception {


            req.setAttribute("action", "Groups");
            req.setAttribute("destination", "groups");
            req.setAttribute("page", "/WEB-INF/jsp/groups");
            req.setAttribute("groups",  service.getSubGroupsByGroupName(req.getParameter("group")));
            req.setAttribute("groupName",  req.getParameter("group"));
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        //   return "unauthorizedUsers";
        return null;
    }
    @RequestMapping(value="/members")
    public String getAllMembers(HttpServletRequest req,HttpServletResponse res, Model model) throws Exception {
            req.setAttribute("action", "Members");
            req.setAttribute("destination", "members");
            req.setAttribute("page", "/WEB-INF/jsp/members");
            List<Person> members=service.getGroupMembers(req.getParameter("group"));
            req.setAttribute("groupMembers", members );
            req.setAttribute("groupMembersCount",members.size() );
            req.setAttribute("groupName",  (req.getParameter("group")));
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        //   return "unauthorizedUsers";
        return null;
    }
    @RequestMapping(value="/joinGroup")
    public String getGroup(HttpServletRequest req,HttpServletResponse res, Model model) throws Exception {


            req.setAttribute("action", "Get");
            req.setAttribute("destination", "joinGroup");
            req.setAttribute("page", "/WEB-INF/jsp/joinGroup");
            //  req.setAttribute("groups",  service.getAllGroups());
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        //   return "unauthorizedUsers";
        return null;
    }
    @RequestMapping(value="/leaveGroup")
    public String leaveGroup(HttpServletRequest req,HttpServletResponse res, Model model) throws Exception {


            req.setAttribute("action", "Get");
            req.setAttribute("destination", "leaveGroup");
            req.setAttribute("page", "/WEB-INF/jsp/leaveGroup");
            //  req.setAttribute("groups",  service.getAllGroups());
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);


        return null;
    }
}
