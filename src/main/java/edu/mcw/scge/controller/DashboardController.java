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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.mail.Session;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.time.LocalTime;
import java.util.*;

@Controller
@RequestMapping(value="/db")
public class DashboardController extends LoginController {
    DataAccessService service=new DataAccessService();
    StudyDao sdao = new StudyDao();

    @RequestMapping(value="")
    public String getDashboard(@ModelAttribute("personInfoRecords") List<PersonInfo> personInfoRecords,
                               HttpServletRequest req) throws Exception {

        if(personInfoRecords==null){
            return "redirect:/";
           }
            int personId = personInfoRecords.get(0).getPersonId();
            req.setAttribute("action", "Dashboard");
            req.setAttribute("destination", "base");
            req.setAttribute("page", "/WEB-INF/jsp/dashboardnew");
            //Map<String, List<String>> groupRoleMap = service.getGroupsNRolesByMemberId(personId);
             //Map<String, Map<String, List<String>>> groupSubgroupRoleMap = service.getGroupsByPersonId(personId);
           // req.getSession().setAttribute("groupRoleMap", groupRoleMap);
            //req.getSession().setAttribute("groupSubgroupRoleMap", groupSubgroupRoleMap);

            //req.setAttribute("groupsMap", service.getGroupMapByGroupName("consortium"));
            Map<Integer, List<SCGEGroup>> consortiumGroups = service.getGroupsMapByGroupName("consortium");
            Map<SCGEGroup, List<Person>> groupMembersMap = service.getGroupMembersMapExcludeDCCNIH(consortiumGroups);
            Map<SCGEGroup, List<Person>> DCCNIHMembersMap = service.getDCCNIHMembersMap(consortiumGroups);

            req.setAttribute("groupsMap1", consortiumGroups);
            req.setAttribute("groupMembersMap", groupMembersMap);
            req.setAttribute("DCCNIHMembersMap", DCCNIHMembersMap);
            //   req.setAttribute("message", message);
            req.setAttribute("status", req.getParameter("status"));
            List<Integer> DCCNIHGroupsIds = service.getDCCNIHGroupsIds();
            List<Study> studies = new ArrayList<>();
            Set<Integer> groupIds = new HashSet<>();
            for (PersonInfo i : personInfoRecords) {
                    groupIds.add(i.getSubGroupId());
                }
            boolean flag=false;
            for (int groupId : groupIds) {
                if (DCCNIHGroupsIds.contains(groupId)) {
                    flag = true;
                    break;
                }

            }
            if(flag){
                studies.addAll(sdao.getStudies());
            }else {
                for(int groupId: groupIds) {
                    studies.addAll(sdao.getStudiesByGroupId(groupId));
                }
            }

            service.addTier2Associations(studies);
            Map<Integer, Integer> tierUpdateMap = service.getTierUpdate(studies);
            req.setAttribute("personInfoRecords", personInfoRecords);

            req.setAttribute("studies", studies);
            req.setAttribute("tierUpdateMap", tierUpdateMap);
            return "base";

    }



}
