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
    public String getDashboard(
                               HttpServletRequest req) throws Exception {

        Person p=userService.getCurrentUser();


            req.setAttribute("action", "Dashboard");
            req.setAttribute("destination", "base");
            req.setAttribute("page", "/WEB-INF/jsp/dashboardnew");
            //Map<String, List<String>> groupRoleMap = service.getGroupsNRolesByMemberId(personId);
             //Map<String, Map<String, List<String>>> groupSubgroupRoleMap = service.getGroupsByPersonId(personId);
           // req.getSession().setAttribute("groupRoleMap", groupRoleMap);
            //req.getSession().setAttribute("groupSubgroupRoleMap", groupSubgroupRoleMap);

            //req.setAttribute("groupsMap", service.getGroupMapByGroupName("consortium"));
          /*  Map<Integer, List<SCGEGroup>> consortiumGroups = service.getGroupsMapByGroupName("consortium");
            Map<SCGEGroup, List<Person>> groupMembersMap = service.getGroupMembersMapExcludeDCCNIH(consortiumGroups);
            Map<SCGEGroup, List<Person>> DCCNIHMembersMap = service.getDCCNIHMembersMap(consortiumGroups);*/

        req.setAttribute("groupsMap1", Data.getInstance().getConsortiumGroups());
        req.setAttribute("groupMembersMap", Data.getInstance().getGroupMembersMap());
        req.setAttribute("DCCNIHMembersMap", Data.getInstance().getDCCNIHMembersMap());
            //   req.setAttribute("message", message);
            req.setAttribute("status", req.getParameter("status"));
            List<Integer> DCCNIHGroupsIds = service.getDCCNIHGroupsIds();
            List<Study> studies = new ArrayList<>();
            Set<Integer> groupIds = new HashSet<>();
            List<PersonInfo> personInfoRecords= access.getPersonInfoRecords(p.getId());
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
