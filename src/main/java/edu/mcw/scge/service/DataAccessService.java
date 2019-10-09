package edu.mcw.scge.service;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.http.HttpRequest;
import edu.mcw.scge.dao.implementation.AccessDao;
import edu.mcw.scge.dao.implementation.GroupDAO;
import edu.mcw.scge.dao.implementation.PersonDao;
import edu.mcw.scge.dao.implementation.TestDataDao;
import edu.mcw.scge.datamodel.Person;
import edu.mcw.scge.datamodel.PersonInfo;
import edu.mcw.scge.datamodel.TestData;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;

import javax.servlet.http.HttpServletRequest;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URI;
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
    public void insertOrUpdate(Person p) throws Exception{

            int key=pdao.generateNewPersonKey();
            p.setId(key);
            pdao.insert(p);

     //    return pdao.getPerson(p).get(0).getId();

    }
    public boolean existsPerson(Person p) throws Exception{
        List<Person> persons=pdao.getPersonByEmail(p.getEmail());
        if(persons.size()>0){
            return true;
        }
        return false;
    }
   public boolean existsInSCGE(GoogleIdToken.Payload payload) throws Exception {
       List<Person> p=pdao.getPersonByGoogleId(payload.getSubject());
        if(p==null || p.size()==0){

           int id= updateGoogleId(payload);
            if(id!=0){
                return true;
            }

        }else{
            if(p.size()>0)
           return true;
        }


        return false;
    }
 /*   public boolean existsInSCGE(GoogleIdToken.Payload payload) throws Exception {
        List<Person> p=pdao.getPersonByGoogleId(payload.getSubject());
        if(p==null || p.size()==0){
            URI uri = new URI("https://groups.io/api/v1/login?", "email=jthota@mcw.edu&password=testingfb02&api_key=nonce", null);
            String str = uri.toASCIIString();
           String jsonObject=restGet(str,null);
            System.out.println("jsonObject:"+jsonObject);

        }else{
            if(p.size()>0)
                return true;
        }


        return false;
    }*/
    public static String restGet(String url, String contentType) throws Exception {
        try {
            DefaultHttpClient httpClient = new DefaultHttpClient();
            HttpGet getRequest = new HttpGet(url);
            if (contentType != null) getRequest.addHeader("accept", contentType);

            HttpResponse response = httpClient.execute(getRequest);

            if (response.getStatusLine().getStatusCode() != 200) {
                if (response.getStatusLine().getStatusCode() == 404) return "";
                throw new RuntimeException("Failed : HTTP error code : "
                        + response.getStatusLine().getStatusCode());
            }

            BufferedReader br = new BufferedReader(
                    new InputStreamReader((response.getEntity().getContent())));

            String outputLine = "", output = "";
            while ((outputLine = br.readLine()) != null) {
                output += outputLine;
            }

            httpClient.getConnectionManager().shutdown();
            return output;

        } catch (IOException e) {

            throw e;
        }
    }
    public int updateGoogleId(GoogleIdToken.Payload payload) throws Exception {
        String googleSub=payload.getSubject();
           List<Person>  pList=pdao.getPersonByEmail(payload.getEmail());
            if(pList!=null && pList.size()==1){
                pdao.updateGoogleId(googleSub,pList.get(0).getId() );
                return  pList.get(0).getId();
            }/*else{
                pList= pdao.getPersonByLastName(familyName);
                if(pList!=null && pList.size()==1){
                    pdao.updateGoogleId(googleSub,pList.get(0).getId() );
                    return  pList.get(0).getId();
                }
            }*/

        return 0;
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
        status=pdao.getPersonStatus(payload.getSubject());

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
    public int getPersonByGoogleId(GoogleIdToken.Payload paylaod) throws Exception {
        List<Person> pList=pdao.getPersonByGoogleId(paylaod.getSubject());
        if(pList!=null && pList.size()>0){
            return pList.get(0).getId();
        }
        return  0 ;
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
      //  System.out.println(person.getName()+"\t"+ person.getEmail()+"\tPERSON SIZE: "+ p.size());
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
      //  System.out.println("groupROLEMAP"+groupRoleMap.size());
        return groupRoleMap;
    }
    public Map<String, List<String>> getGroupsByMemberId(int id) {
        Map<String, List<String>> groupRoleMap=new HashMap<>();
        try {
            groupRoleMap=   gdao.getGroupsNRolesByMemberId(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
    //    System.out.println("groupROLEMAP"+groupRoleMap.size());
        return groupRoleMap;
    }
    public Map<String,Map<String, List<String>>> getGroupsByPersonId(int id) {
       Map<String, Map<String, List<String>>> groupSubgroupRoleMap=new HashMap<>();
        try {
            List<PersonInfo> associations=  gdao.getGroupsNRolesByPersonId(id);
            for(PersonInfo i:associations){
                Map<String, List<String>> map=groupSubgroupRoleMap.get(i.getGroup());
                List<String> roles=new ArrayList<>();
                if(map!=null && map.size()>0){

                    if(map.get(i.getSubgroup())!=null){
                        roles.addAll(map.get(i.getSubgroup()));
                     }

                }else map=new HashMap<>();
                roles.add(i.getRole());
                map.put(i.getSubgroup(), roles);
                groupSubgroupRoleMap.put(i.getGroup(), map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        //    System.out.println("groupROLEMAP"+groupRoleMap.size());
        return groupSubgroupRoleMap;
    }
    public List<Person> getGroupMembers(String groupName) throws Exception {
        if(groupName.contains("Cell")){
            groupName="Cell & Tissue Platform";
        }
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
      //  System.out.println("MEMBERS SIZE: "+ members.size());
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
    public  Map<String, List<String>> getGroupsMapByGroupName(String groupName) {
        if(groupName.contains("Cell")){
            groupName="Cell & Tissue Platform";
        }
        Map<String, List<String>> map= new HashMap<>();
        List<String> subgroups=new ArrayList<>();
        try {
            subgroups=   gdao.getSubGroupsByGroupName(groupName);
            for(String sg:subgroups){
                List<String> ssgroups=  gdao.getSubGroupsByGroupName(sg);
                map.put(sg, ssgroups);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return map;
    }
    public void logToDb(GoogleIdToken.Payload payload){
        String email=payload.getEmail();
        String name = (String) payload.get("name");
        String givenName= (String) payload.get("givenName");
        String familyName= (String) payload.get("familyName");
        String sub=payload.getSubject();

    }
}
