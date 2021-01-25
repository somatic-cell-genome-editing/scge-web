package edu.mcw.scge.controller;

import edu.mcw.scge.dao.implementation.GroupDAO;
import edu.mcw.scge.dao.implementation.PersonDao;
import edu.mcw.scge.dao.implementation.StudyDao;
import edu.mcw.scge.datamodel.Person;
import edu.mcw.scge.datamodel.PersonInfo;
import edu.mcw.scge.datamodel.SCGEGroup;
import edu.mcw.scge.datamodel.Study;
import edu.mcw.scge.service.DataAccessService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.mail.Session;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value="/db")
public class DashboardController {
    DataAccessService service=new DataAccessService();
    @RequestMapping(value="")
    public String getDashboard(HttpServletRequest req) throws Exception {
        HttpSession session= req.getSession(true);
        int personId= (int) session.getAttribute("personId");
        req.setAttribute("action","Dashboard");
        req.setAttribute("destination", "base");
        req.setAttribute("page", "/WEB-INF/jsp/dashboardnew");

        Map<String, List<String>> groupRoleMap=service.getGroupsNRolesByMemberId(personId);
        Map<String, Map<String, List<String>>> groupSubgroupRoleMap=service.getGroupsByPersonId(personId);
        req.getSession().setAttribute("groupRoleMap", groupRoleMap);
        req.getSession().setAttribute("groupSubgroupRoleMap", groupSubgroupRoleMap);

        req.setAttribute("groupsMap", service.getGroupMapByGroupName("consortium"));
        Map<Integer, List<SCGEGroup>> consortiumGroups= service.getGroupsMapByGroupName("consortium");
        Map<SCGEGroup, List<Person>> groupMembersMap=service.getGroupMembersMapExcludeDCCNIH(consortiumGroups);
        Map<SCGEGroup, List<Person>> DCCNIHMembersMap=service.getDCCNIHMembersMap(consortiumGroups);

        req.setAttribute("groupsMap1", consortiumGroups);
        req.setAttribute("groupMembersMap",groupMembersMap );
        req.setAttribute("DCCNIHMembersMap",DCCNIHMembersMap );
        //   req.setAttribute("message", message);
        req.setAttribute("status", req.getParameter("status"));
        StudyDao sdao=new StudyDao();
        List<Study> studies = sdao.getStudies(); //this has to be changed to pull studies by memberID/GroupId.
        service.addTier2Associations(studies);
        Map<Integer, Integer> tierUpdateMap=service.getTierUpdate(studies);
        req.setAttribute("studies", studies);
        req.setAttribute("tierUpdateMap", tierUpdateMap);
        return "base";
    }

  /*  @RequestMapping(value="/home")
    public String getDashboardHome(HttpServletRequest req) throws Exception {
        StudyDao sdao=new StudyDao();
        List<Study> studies = sdao.getStudies(); //this has to be changed to pull studies by memberID/GroupId.
        req.setAttribute("studies", studies);
        return "dashboardElements/home";
    }
    @RequestMapping(value="/mySubmissions")
    public String getMySubmissions(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        StudyDao sdao=new StudyDao();
        GroupDAO gdao=new GroupDAO();
        PersonDao pdao=new PersonDao();
        HttpSession session=req.getSession();
        int memberId= (int) session.getAttribute("personId");
        List<PersonInfo> infoList=pdao.getPersonInfoById(memberId);
       System.out.println("MEMBER ID:"+ memberId +" GROUPS: " + infoList.size());
     //   List<Study> studies = sdao.getStudiesByLab(memberId); //this has to be changed to pull studies by memberID/GroupId.
    //    req.setAttribute("studies", studies);
    //    return "tools/studies";
        return null;
    }*/
}
