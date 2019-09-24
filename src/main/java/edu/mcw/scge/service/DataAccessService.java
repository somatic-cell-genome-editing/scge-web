package edu.mcw.scge.service;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.http.HttpRequest;
import edu.mcw.scge.dao.implementation.AccessDao;
import edu.mcw.scge.dao.implementation.GroupDAO;
import edu.mcw.scge.dao.implementation.PersonDao;
import edu.mcw.scge.dao.implementation.TestDataDao;
import edu.mcw.scge.datamodel.Person;
import edu.mcw.scge.datamodel.TestData;

import javax.servlet.http.HttpServletRequest;
import java.util.*;

/**
 * Created by jthota on 8/16/2019.
 */
public class DataAccessService {
    TestDataDao tdao=new TestDataDao();
    PersonDao pdao=new PersonDao();
    GroupDAO gdao=new GroupDAO();
    AccessDao adao=new AccessDao();
    public List<TestData> getData(String name, String symbol) throws Exception {
           return tdao.getTestData();
    }
    public List<TestData> insert(String name, String symbol) throws Exception {
        tdao.insert(name, symbol);
        return getData(name, symbol);
    }
    public int insert(Person p) throws Exception{
        if(!existsPerson(p)){
            int key=pdao.generateNewPersonKey();
            p.setId(key);
            pdao.insert(p);
        }
         return pdao.getPerson(p).get(0).getId();

    }
    public boolean existsPerson(Person p) throws Exception{
        List<Person> persons=pdao.getPerson(p);
        if(persons.size()>0){
            return true;
        }
        return false;
    }
    public boolean existsInSCGE(GoogleIdToken.Payload payload) throws Exception {
        String email=payload.getEmail();
        List<Person> records=pdao.getPersonByEmail(email);
        System.out.println(email + "\t records: " + records.size());
       if(records.size()>0){
            return true;
        }

        return false;
    }
/*    public boolean isGeneralAdmin(GoogleIdToken.Payload payload) throws Exception {
        String email=payload.getEmail();
        List<Person> records=pdao.getPersonByEmail(email);
        if(records.size()>0){
            Person p=records.get(0);
          List<String> groups= pdao.getPersonGroups(p);
       //     if(groups.contains("general_admin"))
            if(groups.contains("general")) {
              String access=  pdao.getGroupAccessLevel(p, "general").get(0);
                if(access.equalsIgnoreCase("admin"))
                return true;
            }
        }
        return false;
    }
    public boolean isGroupAdmin(GoogleIdToken.Payload payload) throws Exception {
        String email=payload.getEmail();
        List<Person> records=pdao.getPersonByEmail(email);
        if(records.size()>0){
            Person p=records.get(0);
            List<String> groups= pdao.getPersonGroups(p);
            //     if(groups.contains("general_admin"))
            if(groups.contains("general")) {
                String access=  pdao.getGroupAccessLevel(p, "general").get(0);
                if(access.equalsIgnoreCase("group_admin"))
                    return true;
            }
        }
        return false;
    }
*/
    public String getUserStatus(GoogleIdToken.Payload payload) throws Exception {
          String status=new String();
       //   status=pdao.getPersonStatus(payload.getSubject());
        status=pdao.getPersonStatus(payload.get("email").toString());

        return status;

    }
    public List<Person> getAllUnauthorizedUsers() throws Exception {
      return   pdao.getAllUnauthorizedUsers();
     }
    public List<Person> getAllMembers() throws Exception {
        return   pdao.getAllMembers();
    }
    public List<Person> getPersonById(String scgeMemberId) throws Exception {
        return   pdao.getPersonById(Integer.parseInt(scgeMemberId));
    }
    public void updateUserStatus(HttpServletRequest req) throws Exception {
           Person person= new Person.Builder()
                .name(req.getParameter("name"))
                .email(req.getParameter("email"))
                .status(req.getParameter("status"))
                .modifiedBy((String)req.getSession().getAttribute("userEmail"))
                .modifiedById((String)req.getSession().getAttribute("userId"))
                .build();
        pdao.updateStatus(person);
        List<Person> p=pdao.getPerson(person);
        System.out.println(person.getName()+"\t"+ person.getEmail()+"\tPERSON SIZE: "+ p.size());
        if(p!=null && p.size()>0){
            Person person1=p.get(0);
            int personId=  person1.getId();
       //     int groupKey=gdao.getGroupKey("general");
        //    int accessId=adao.getAccessId("member");
        //    pdao.addMemberToGroup(personId, groupKey, accessId);
        }

    }
    public Map<String, List<String>> getGroupsByMemberName(String userName) {
        Map<String, List<String>> groupRoleMap=new HashMap<>();
        try {
            groupRoleMap=   gdao.getGroupsNRoles(userName);
        } catch (Exception e) {
            e.printStackTrace();
        }
        System.out.println("groupROLEMAP"+groupRoleMap.size());
        return groupRoleMap;
    }
    public List<Person> getGroupMembers(String groupName) throws Exception {
      List<Person> members= gdao.getGroupMembers(groupName);
        Set<Integer> personIds=new HashSet<>();
        List<Person> sortedMembersList=new ArrayList<>();
        for(Person p:members){
            if(!personIds.contains(p.getId())){
                personIds.add(p.getId());
                p.setRoles(pdao.getRolesByPersonId(p.getId(), groupName));
                sortedMembersList.add(p);
            }
        }
        System.out.println("MEMBERS SIZE: "+ members.size());
        return sortedMembersList;
    }
    public List<String> getSubGroupsByGroupName(String groupName) {
        if(groupName.contains("Cell")){
            groupName="Cell & Tissue Platform";
        }

        List<String> subgroups=new ArrayList<>();
        try {
            subgroups=   gdao.getSubGroupsByGroupName(groupName);
            } catch (Exception e) {
            e.printStackTrace();
        }

        return subgroups;
    }

    public void logToDb(GoogleIdToken.Payload payload){
        String email=payload.getEmail();
        String name = (String) payload.get("name");
        String givenName= (String) payload.get("givenName");
        String familyName= (String) payload.get("familyName");
        String sub=payload.getSubject();

    }
}
