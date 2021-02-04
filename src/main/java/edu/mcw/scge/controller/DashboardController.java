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
    @RequestMapping(value="")
    public String getDashboard(@ModelAttribute("personInfoRecords") List<PersonInfo> personInfoRecords,
                               @ModelAttribute("DCCNIHGroupsIds")List<Integer> DCCNIHGroupsIds, HttpServletRequest req) throws Exception {
        HttpSession session= req.getSession(true);
        int personId= (int) session.getAttribute("personId");
        req.setAttribute("action","Dashboard");
        req.setAttribute("destination", "base");
        req.setAttribute("page", "/WEB-INF/jsp/dashboardnew");
        Set<Integer> groupIds= new HashSet<>();
        for(PersonInfo i:personInfoRecords){
            groupIds.add(i.getSubGroupId());
            System.out.println(i.getGrantInitiative() +"\t"+ i.getGrantTitle()+"\t"+ i.getGroupName()+"\tGROUPID:"+i.getGroupId()+"\t"+ i.getSubGroupName() +"\tSUBGROUP ID:"+i.getSubGroupId()+"\t"+i.getRole());
        }
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
        List<Study> studies=new ArrayList<>();
        for(int groupId:groupIds){
            if(DCCNIHGroupsIds.contains(groupId)){
                studies.addAll(sdao.getStudies());
            }else
            studies.addAll(sdao.getStudiesByGroupId(groupId));
        }
        service.addTier2Associations(studies);
        Map<Integer, Integer> tierUpdateMap=service.getTierUpdate(studies);
        req.setAttribute("personInfoList",personInfoRecords);

        req.setAttribute("studies", studies);
        req.setAttribute("tierUpdateMap", tierUpdateMap);
        return "base";
    }
    @ModelAttribute("DCCNIHGroupsIds")
    public List<Integer> getDCCNIHGroupsIds() throws Exception {
        GroupDAO gdao=new GroupDAO();
       return gdao.getDCCNIHGroupIds();

    }

}
