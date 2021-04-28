package edu.mcw.scge.controller;

import edu.mcw.scge.configuration.UserService;

import edu.mcw.scge.dao.implementation.StudyDao;
import edu.mcw.scge.datamodel.Person;
import edu.mcw.scge.datamodel.PersonInfo;
import edu.mcw.scge.datamodel.Study;
import edu.mcw.scge.service.Data;
import edu.mcw.scge.service.DataAccessService;

import org.springframework.stereotype.Controller;

import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;

import java.util.*;

@Controller
@RequestMapping(value="/db")
public class DashboardController extends LoginController {
    DataAccessService service=new DataAccessService();
    StudyDao sdao = new StudyDao();
    UserService userService=new UserService();

    @RequestMapping(value="")
    public String getDashboard(HttpServletRequest req) throws Exception {

        Person p=userService.getCurrentUser(req.getSession());
        if(p!=null){

            req.setAttribute("action", "Dashboard");
            req.setAttribute("destination", "base");
            req.setAttribute("page", "/WEB-INF/jsp/dashboardnew");
            req.setAttribute("status", req.getParameter("status"));

            List<Study> studies =sdao.getStudies(p);

            List<PersonInfo> personInfoRecords= access.getPersonInfoRecords(p.getId());
            req.setAttribute("groupsMap1", Data.getInstance().getConsortiumGroups());
            req.setAttribute("groupMembersMap", Data.getInstance().getGroupMembersMap());
            req.setAttribute("DCCNIHMembersMap", Data.getInstance().getDCCNIHMembersMap());
            req.setAttribute("status", req.getParameter("status"));
            req.setAttribute("DCCNIHAncestorGroupIds", Data.getInstance().getDCCNIHAncestorGroupIds());
            service.addTier2Associations(studies);
            Map<Integer, Integer> tierUpdateMap = service.getTierUpdate(studies);

        //    Person person=userService.getCurrentUser(req.getSession());
            req.setAttribute("person",p);
            req.setAttribute("personInfoRecords", personInfoRecords);
            req.setAttribute("studies", studies);

            List<Study> sharedStudies = sdao.getSharedTier2Studies(p.getId());


            req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a>");
            req.setAttribute("studiesShared", sharedStudies);
            req.setAttribute("tierUpdateMap", tierUpdateMap);
            return "base";

    }
        return "redirect:/";
    }

}
