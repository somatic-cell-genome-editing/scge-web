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
            }

        return 0;
    }

    public List<Person> getAllMembers() throws Exception {
        return   pdao.getAllActiveMembers();
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



   public  Map<SCGEGroup, List<SCGEGroup>> getGroupsMapByGroupName(String groupName) throws Exception {

        Map<SCGEGroup, List<SCGEGroup>> map= new HashMap<>();
        List<SCGEGroup> subgroups=new ArrayList<>();
        int groupId=gdao.getGroupId(groupName);
        try {
            subgroups=   gdao.getSubGroupsByGroupId(groupId);
            for(SCGEGroup sg:subgroups){
                List<SCGEGroup> ssgroups=  gdao.getSubGroupsByGroupId(sg.getGroupId());
                map.put(sg, ssgroups);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return map;
    }


    public Map<SCGEGroup, List<Person>> getGroupMembersMapExcludeDCCNIH( Map<SCGEGroup, List<SCGEGroup>> consortiumGroup) throws Exception {
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
    public Map<SCGEGroup, List<Person>> getDCCNIHMembersMap( Map<SCGEGroup   , List<SCGEGroup>> consortiumGroup) throws Exception {
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
               groups.add(a.getGroupId());
            }
           for(StudyTierUpdate u: tierUpdateDao.getStudyTierUpdatesByStudyId(s.getStudyId())){
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

    public LinkedHashMap<String, List<Integer>> getPlotData() throws Exception {
        GrantDao grantDao=new GrantDao();
        Map<String, Map<Integer, Integer>> statsMap=new HashMap<>();

        for(String i: grantDao.getAllDistinctInitiatives()) {
            if (!i.equalsIgnoreCase("DCC") && !i.equalsIgnoreCase("NIH")) {
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
        LinkedHashMap<String, List<Integer>> plotData=new LinkedHashMap<>();
        List<String> labels=new ArrayList<>();
        for(Map.Entry e:statsMap.entrySet()){
            String initative= (String) e.getKey();
            labels.add(getLabel(initative));
            Map<Integer, Integer> tierCounts= (Map<Integer, Integer>) e.getValue();
            List<Integer> submissions=new ArrayList<>();
            List<Integer> tier1=new ArrayList<>();
            List<Integer> tier2=new ArrayList<>();
            List<Integer> tier3=new ArrayList<>();
            List<Integer> tier4=new ArrayList<>();
            for(Map.Entry entry:tierCounts.entrySet()){
                if((int)entry.getKey()==0){
                    if(plotData.get("Submissions")!=null){
                        submissions.addAll(plotData.get("Submissions"));
                    }
                    submissions.add((Integer) entry.getValue());
                    plotData.put("Submissions", submissions);
                }
                if((int)entry.getKey()==1){
                    if(plotData.get("Tier-1")!=null){
                        tier1.addAll(plotData.get("Tier-1"));
                    }
                    tier1.add((Integer) entry.getValue());
                    plotData.put("Tier-1", tier1);
                }
                if((int)entry.getKey()==2){
                    if(plotData.get("Tier-2")!=null){
                        tier2.addAll(plotData.get("Tier-2"));
                    }
                    tier2.add((Integer) entry.getValue());
                    plotData.put("Tier-2", tier2);
                }
                if((int)entry.getKey()==3){
                    if(plotData.get("Tier-3")!=null){
                        tier3.addAll(plotData.get("Tier-3"));
                    }
                    tier3.add((Integer) entry.getValue());
                    plotData.put("Tier-3", tier3);
                }
                if((int)entry.getKey()==4){
                    if(plotData.get("Tier-4")!=null){
                        tier4.addAll(plotData.get("Tier-4"));
                    }
                    tier4.add((Integer) entry.getValue());
                    plotData.put("Tier-4", tier4);
                }
            }
        }

      /*  System.out.println(labels.toString());
        for(Map.Entry entry:plotData.entrySet()){
            System.out.println(entry.getKey()+ "\t"+ entry.getValue().toString());
        }*/
       DataAccessService.labels=labels;
       return  plotData;
    }
    public String getLabel(String l){
        if(l.equalsIgnoreCase("Cell & Tissue Platform"))
            return "Biological Systems";
        if(l.equalsIgnoreCase("New Editors Initiative"))
          return  "Genome Editors";
        if(l.equalsIgnoreCase("Large Animal Reporter"))
            return "LAR";
        if(l.equalsIgnoreCase("Large Animal Testing Center"))
            return  "LATC";
        if(l.equalsIgnoreCase("Delivery Vehicle Initiative"))
            return  "Delivery Systems";
        if(l.equalsIgnoreCase("Rodent Testing Center"))
             return "SATC";
        return l;
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
