package edu.mcw.scge.service;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.http.HttpRequest;
import edu.mcw.scge.dao.AbstractDAO;
import edu.mcw.scge.dao.implementation.*;
import edu.mcw.scge.dao.spring.StudyAssociationQuery;
import edu.mcw.scge.datamodel.*;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.web.bind.annotation.ModelAttribute;

import javax.servlet.http.HttpServletRequest;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URI;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.ZoneId;
import java.util.*;

/**
 * Created by jthota on 8/16/2019.
 */
public class DataAccessService extends AbstractDAO {
    private static TestDataDao tdao=new TestDataDao();
    PersonDao pdao=new PersonDao();
    GroupDAO gdao=new GroupDAO();
    StudyDao sdao=new StudyDao();
    TierUpdateDao tierUpdateDao=new TierUpdateDao();
    public static List<String> labels;
    public List<TestData> getData(String name, String symbol) throws Exception {
           return tdao.getTestData();
    }
    public List<TestData> insert(String name, String symbol) throws Exception {
        tdao.insert(name, symbol);
        return getData(name, symbol);
    }
    public void insertOrUpdate(Person p) throws Exception{

            int key=pdao.getNextKey("person_seq");
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
    public Map<String, List<String>> getGroupsNRolesByMemberId(int id) {
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
                Map<String, List<String>> map=groupSubgroupRoleMap.get(i.getGroupName());
                List<String> roles=new ArrayList<>();
                if(map!=null && map.size()>0){

                    if(map.get(i.getSubGroupName())!=null){
                        roles.addAll(map.get(i.getSubGroupName()));
                     }

                }else map=new HashMap<>();
                roles.add(i.getRole());
                map.put(i.getSubGroupName(), roles);
                groupSubgroupRoleMap.put(i.getGroupName(), map);
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
    public  Map<String, List<String>> getGroupsNRolesMapByGroupName(String groupName) {
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
    public  Map<Integer, List<SCGEGroup>> getGroupsMapByGroupName(String groupName) throws Exception {

        Map<Integer, List<SCGEGroup>> map= new HashMap<>();
        List<SCGEGroup> subgroups=new ArrayList<>();
        int groupId=gdao.getGroupId(groupName);
        try {
            subgroups=   gdao.getSubGroupsByGroupId(groupId);
            for(SCGEGroup sg:subgroups){
                List<SCGEGroup> ssgroups=  gdao.getSubGroupsByGroupId(sg.getGroupId());
                map.put(sg.getGroupId(), ssgroups);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return map;
    }
    public  Map<SCGEGroup, List<SCGEGroup>> getGroupMapByGroupId(int groupId) {

        Map<SCGEGroup, List<SCGEGroup>> map= new HashMap<>();
        List<SCGEGroup> subgroups=new ArrayList<>();
        try {
            subgroups=   gdao.getSubGroupsByGroupId(groupId);
            for(SCGEGroup sg:subgroups){
                List<SCGEGroup> ssgroups=  gdao.getSubGroupsByGroupId(sg.getGroupId());
                for(SCGEGroup g:ssgroups){
                    List<Person> members=new ArrayList<>();
                    Set<Integer> memberIds=new HashSet<>();
                    for(Person p:gdao.getGroupMembersByGroupId(g.getGroupId())) {
                      if(!memberIds.contains(p.getId())){
                          memberIds.add(p.getId());
                          members.add(p);
                      }
                    }
                    g.setMembers(members);
                }
                map.put(sg, ssgroups);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return map;
    }
    public  Map<SCGEGroup, List<SCGEGroup>> getGroupMapByGroupName(String groupName) throws Exception {

        Map<SCGEGroup, List<SCGEGroup>> map= new HashMap<>();
        List<SCGEGroup> subgroups=new ArrayList<>();
        int groupId=gdao.getGroupId(groupName);
        try {
            subgroups=   gdao.getSubGroupsByGroupId(groupId);
            for(SCGEGroup sg:subgroups){
                List<SCGEGroup> ssgroups=  gdao.getSubGroupsByGroupId(sg.getGroupId());
                for(SCGEGroup g:ssgroups){
                    List<Person> members=new ArrayList<>();
                    Set<Integer> memberIds=new HashSet<>();
                    for(Person p:gdao.getGroupMembersByGroupId(g.getGroupId())) {
                        if(!memberIds.contains(p.getId())){
                            memberIds.add(p.getId());
                            members.add(p);
                        }
                    }
                    g.setMembers(members);
                }
                map.put(sg, ssgroups);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return map;
    }
    public Map<Integer, List<Person>> getAllGroupsMembersMap( Map<Integer, List<SCGEGroup>> consortiumGroup) throws Exception {
        Map<Integer, List<Person>> map=new HashMap<>();
        for(Map.Entry e: consortiumGroup.entrySet()){
            List<SCGEGroup> groups= (List<SCGEGroup>) e.getValue();
            for(SCGEGroup g:groups){
                int groupId= g.getGroupId();
                List<Person> sortedMembers=new ArrayList<>();
                List<Integer> memberIds=new ArrayList<>();
                List<Person> members=gdao.getGroupMembersByGroupId(groupId);
                for(Person p:members){
                    if(!memberIds.contains(p.getId())){
                        sortedMembers.add(p);
                        memberIds.add(p.getId());
                    }
                }
                map.put(groupId, sortedMembers);

            }
        }
        return map;
    }
    public Map<SCGEGroup, List<Person>> getGroupMembersMapExcludeDCCNIH( Map<Integer, List<SCGEGroup>> consortiumGroup) throws Exception {
        Map<SCGEGroup, List<Person>> map=new HashMap<>();
        List<Integer> DCCNIHGroups= gdao.getDCCNIHGroupIds();
        for(Map.Entry e: consortiumGroup.entrySet()){
            List<SCGEGroup> groups= (List<SCGEGroup>) e.getValue();
            for(SCGEGroup g:groups){
                int groupId= g.getGroupId();
                List<Person> sortedMembers=new ArrayList<>();
                List<Integer> memberIds=new ArrayList<>();
                List<Person> members=gdao.getGroupMembersByGroupId(groupId);
                for(Person p:members){
                    if(!memberIds.contains(p.getId())){
                        sortedMembers.add(p);
                        memberIds.add(p.getId());
                    }
                }
              if(!DCCNIHGroups.contains(groupId))
                map.put(g, sortedMembers);

            }
        }
        return map;
    }
    public Map<SCGEGroup, List<Person>> getDCCNIHMembersMap( Map<Integer, List<SCGEGroup>> consortiumGroup) throws Exception {
        Map<SCGEGroup, List<Person>> map=new HashMap<>();
        List<Integer> DCCNIHGroups= gdao.getDCCNIHGroupIds();
        for(Map.Entry e: consortiumGroup.entrySet()){
            List<SCGEGroup> groups= (List<SCGEGroup>) e.getValue();
            for(SCGEGroup g:groups){
                int groupId= g.getGroupId();
                if(DCCNIHGroups.contains(groupId)) {
                    List<Person> sortedMembers = new ArrayList<>();
                    List<Integer> memberIds = new ArrayList<>();
                    List<Person> members = gdao.getGroupMembersByGroupId(groupId);
                    for (Person p : members) {
                        if (!memberIds.contains(p.getId())) {
                            sortedMembers.add(p);
                            memberIds.add(p.getId());
                        }
                    }

                    map.put(g, sortedMembers);
                }

            }
        }
        return map;
    }
    public void updateStudyTier(int studyId, int tier, int groupId,
                                String action, String status, int modifiedBypersonId) throws Exception {
        int sequenceKey=getNextKey("study_tier_updates_seq");
        sdao.insertStudyTier(studyId, tier,groupId,sequenceKey, action, status, modifiedBypersonId);
    }
    public void insertTierUpdates(List<StudyTierUpdate> updates) throws Exception {
        System.out.println("UPDATE RECORDS SIZE: "+ updates.size());
        tierUpdateDao.batchUpdate(updates);
    }
    public void deleteTierUpdates(int studyId) throws Exception {
        tierUpdateDao.delete(studyId);
    }
    public Map<Integer, Integer> getTierUpdate(List<Study> studies) throws Exception {
        Map<Integer, Integer> tierUpdatesMap=new HashMap<>();
        for(Study s:studies) {
            int studyId=s.getStudyId();
            List<StudyTierUpdate> updates = tierUpdateDao.getStudyTierUpdatesByStudyId(studyId);
            if (updates != null && updates.size() > 0) {
               tierUpdatesMap.put(studyId,   updates.get(0).getTier());
            }else{
                tierUpdatesMap.put(studyId, s.getTier());
            }
        }
        return tierUpdatesMap;
    }

    public void addTier2Associations(List<Study> studies) throws Exception {
        for(Study s:studies){
            List<Integer> groups=new ArrayList<>();
           for(StudyAssociation a: sdao.getStudyAssociations(s.getStudyId())){
              // SCGEGroup g= new SCGEGroup();
             //  g=gdao.getGroupById(a.getGroupId());
              // g.setMembers( gdao.getGroupMembersByGroupId(a.getGroupId()));
               groups.add(a.getGroupId());
            }
           for(StudyTierUpdate u: tierUpdateDao.getStudyTierUpdatesByStudyId(s.getStudyId())){
            //   SCGEGroup g=new SCGEGroup();
           //    g=gdao.getGroupById(u.getGroupId());
             //  g.setMembers( gdao.getGroupMembersByGroupId(u.getGroupId()));
               groups.add(u.getAssociatedGroupId());
           }
           s.setAssociatedGroups(groups);
        }

    }

    public void insertTierUpdates(int studyId, int tier, int userId, String json) throws Exception {
        List<StudyTierUpdate> updates= new ArrayList<>();
        LocalDate todayLocalDate = LocalDate.now( ZoneId.of( "America/Chicago" ) );
        LocalTime time=LocalTime.now();
        java.sql.Date sqlDate = java.sql.Date.valueOf( todayLocalDate );
        deleteOldRecords(studyId);
        if(json!=null && tier==2) {
            JSONObject jsonObject=new JSONObject(json);
            JSONArray selectedArray= jsonObject.getJSONArray("selected");
                for(int j=0; j<selectedArray.length();j++){
                    int sequenceKey=getNextKey("study_tier_updates_seq");

                    System.out.println("Group ID: "+ selectedArray.get(j) +"\tSequenceKey:"+ sequenceKey);
                    StudyTierUpdate rec= new StudyTierUpdate();
                    rec.setStudyTierUpdateId(sequenceKey);
                    rec.setStudyId(studyId);
                    rec.setTier(tier);
                    rec.setAssociatedGroupId((Integer) selectedArray.get(j));
                 //   rec.setMemberId((Integer) selectedArray.get(j));
                    rec.setModifiedBy(userId);
                    rec.setStatus("submitted"); //initial status of update is "submitted", after processing status changes to "PROCESSED"
                    rec.setAction("");
                    rec.setModifiedTime(Time.valueOf(time));
                    rec.setModifiedDate(sqlDate);
                    updates.add(rec);
                }


        }else{
            int sequenceKey=getNextKey("study_tier_updates_seq");
            StudyTierUpdate rec= new StudyTierUpdate();
            rec.setStudyTierUpdateId(sequenceKey);
            rec.setStudyId(studyId);
            rec.setTier(tier);
            rec.setModifiedBy(userId);
            rec.setStatus("submitted"); //initial status of update is "submitted", after processing status changes to "PROCESSED"
            rec.setAction("");
            rec.setModifiedTime(Time.valueOf(time));
            rec.setModifiedDate(sqlDate);
            updates.add(rec);
        }
        insertTierUpdates(updates);
    }
    public void deleteOldRecords(int studyId) throws Exception {
        deleteTierUpdates(studyId);
    }
    public void insertOrUpdateTierUpdatesOLD(int studyId, int tier, int userId, String json) throws Exception {
        List<StudyTierUpdate> updates= new ArrayList<>();
        LocalDate todayLocalDate = LocalDate.now( ZoneId.of( "America/Chicago" ) );
        LocalTime time=LocalTime.now();
        java.sql.Date sqlDate = java.sql.Date.valueOf( todayLocalDate );
        if(json!=null && tier==2) {
            JSONObject jsonObject=new JSONObject(json);
            JSONArray selectedArray= jsonObject.getJSONArray("selected");
            for(int i=0;i<selectedArray.length();i++){
                String groupId=selectedArray.getJSONObject(i).getString("groupId");
                System.out.println("*******GROUP ID: "+ groupId+"*******");
                JSONArray array=selectedArray.getJSONObject(i).getJSONArray("members");
                for(int j=0; j<array.length();j++){
                    int sequenceKey=getNextKey("study_tier_updates_seq");
                    System.out.println("MEMBER ID: "+ array.get(j) +"\tSequenceKey:"+ sequenceKey);
                    StudyTierUpdate rec= new StudyTierUpdate();
                    rec.setStudyTierUpdateId(sequenceKey);
                    rec.setStudyId(studyId);
                    rec.setTier(tier);
                    rec.setAssociatedGroupId(Integer.parseInt(groupId));
                    rec.setMemberId((Integer) array.get(j));
                    rec.setModifiedBy(userId);
                    rec.setStatus("submitted"); //initial status of update is "submitted", after processing status changes to "PROCESSED"
                    rec.setAction("");
                    rec.setModifiedTime(Time.valueOf(time));
                   rec.setModifiedDate(sqlDate);
                    updates.add(rec);
                }

            }
        }else{
            int sequenceKey=getNextKey("study_tier_updates_seq");
            StudyTierUpdate rec= new StudyTierUpdate();
            rec.setStudyTierUpdateId(sequenceKey);
            rec.setStudyId(studyId);
            rec.setTier(tier);
            rec.setModifiedBy(userId);
            rec.setStatus("submitted"); //initial status of update is "submitted", after processing status changes to "PROCESSED"
            rec.setAction("");
            rec.setModifiedTime(Time.valueOf(time));
            rec.setModifiedDate(sqlDate);
            updates.add(rec);
        }
        insertTierUpdates(updates);
    }
    public Map<String, Map<Integer, Integer>> sortStudies(List<Study> studies){
        Map<String, Map<Integer, Integer>> sortedMap=new HashMap<>();
        for(Study s:studies){

        }

        return null;
    }
    public Map<String, List<Integer>> getPlotData() throws Exception {
        GrantDao grantDao=new GrantDao();
        Map<String, Map<Integer, Integer>> statsMap=new HashMap<>();

        for(String i: grantDao.getAllDistinctInitiatives()) {
            if (!i.equalsIgnoreCase("DCC")) {
                List<Grant> grants = grantDao.getGrantsByInitiative(i);
                Map<Integer, Integer> tierStats = new HashMap<>();
                int totalStudies = 0;

                for (Grant g : grants) {

                    List<Study> studies = sdao.getStudiesByGrantId(g.getGrantId());
                    totalStudies = studies.size() + totalStudies;

                    for (int j = 1; j < 5; j++) {
                        int tierCount = 0;
                        for (Study s : studies) {
                            if (s.getTier() == j) {
                                tierCount = tierCount + 1;
                            }
                        }
                        if (tierStats.get(j) != null) {
                            tierCount = tierCount + tierStats.get(j);
                        }
                        tierStats.put(j, tierCount);
                    }
                }
                tierStats.put(0, totalStudies);
                statsMap.put(i, tierStats);
            }
        }
        Map<String, List<Integer>> plotData=new HashMap<>();
        List<String> labels=new ArrayList<>();
        for(Map.Entry e:statsMap.entrySet()){
            String initative= (String) e.getKey();
            labels.add(initative);

            //   System.out.println("Initiative: "+ initative+"*********");
            Map<Integer, Integer> tierCounts= (Map<Integer, Integer>) e.getValue();
            List<Integer> submissions=new ArrayList<>();
            List<Integer> tier1=new ArrayList<>();
            List<Integer> tier2=new ArrayList<>();
            List<Integer> tier3=new ArrayList<>();
            List<Integer> tier4=new ArrayList<>();
            if(plotData.get("Submissions")!=null){
                submissions.addAll(plotData.get("Submissions"));
            }
            submissions.add(tierCounts.get(0));
            plotData.put("Submissions", submissions);

            /**********************tier-1****************/
            if(plotData.get("Tier-1")!=null){
                tier1.addAll(plotData.get("Tier-1"));
            }
            tier1.add(tierCounts.get(1));
            plotData.put("Tier-1", tier1);
            /*******************TIER-2*****************/
            if(plotData.get("Tier-2")!=null){
                tier2.addAll(plotData.get("Tier-2"));
            }
            tier2.add(tierCounts.get(2));
            plotData.put("Tier-2", tier2);
            /*****************************TIER-3*************/
            if(plotData.get("Tier-3")!=null){
                tier3.addAll(plotData.get("Tier-3"));
            }
            tier3.add(tierCounts.get(3));
            plotData.put("Tier-3", tier3);
            /*********************TIER-4********************/
            if(plotData.get("Tier-4")!=null){
                tier4.addAll(plotData.get("Tier-4"));
            }
            tier4.add(tierCounts.get(4));
            plotData.put("Tier-4", tier4);

        }
      /*  System.out.println(labels.toString());
        for(Map.Entry entry:plotData.entrySet()){
            System.out.println(entry.getKey()+ "\t"+ entry.getValue().toString());
        }*/
       DataAccessService.labels=labels;
        return  plotData;
    }
    public void logToDb(GoogleIdToken.Payload payload){
        String email=payload.getEmail();
        String name = (String) payload.get("name");
        String givenName= (String) payload.get("givenName");
        String familyName= (String) payload.get("familyName");
        String sub=payload.getSubject();

    }

    public List<Integer> getDCCNIHGroupsIds() throws Exception {
        GroupDAO gdao=new GroupDAO();
        return gdao.getDCCNIHGroupIds();

    }

}
