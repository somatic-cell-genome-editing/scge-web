package edu.mcw.scge.configuration;

import edu.mcw.scge.datamodel.Person;
import edu.mcw.scge.datamodel.PersonInfo;
import edu.mcw.scge.datamodel.SCGEGroup;
import edu.mcw.scge.datamodel.Study;
import edu.mcw.scge.dao.implementation.StudyDao;
import edu.mcw.scge.service.DataAccessService;
import edu.mcw.scge.service.db.DBService;


import java.util.List;
import java.util.Map;

public class Access {

    private Map<Integer, List<SCGEGroup>> consortiumGroups = null;
    private Map<SCGEGroup, List<Person>> groupMembersMap = null;
    private Map<SCGEGroup, List<Person>> DCCNIHMembersMap = null;

    private static Access access;

    public Access () {

        DataAccessService service=new DataAccessService();
        try {
            this.consortiumGroups = service.getGroupsMapByGroupName("consortium");
            this.groupMembersMap = service.getGroupMembersMapExcludeDCCNIH(consortiumGroups);
            this.DCCNIHMembersMap = service.getDCCNIHMembersMap(consortiumGroups);
        }catch (Exception e) {
            System.out.println(e);
        }

    }

    public static Access getInstance() {
        if (access != null) {
            return access;
        }else {
            access =  new Access();
            return access;
        }
    }

    public Map<Integer, List<SCGEGroup>> getConsortiumGroups() {
        return consortiumGroups;
    }

    public void setConsortiumGroups(Map<Integer, List<SCGEGroup>> consortiumGroups) {
        this.consortiumGroups = consortiumGroups;
    }

    public Map<SCGEGroup, List<Person>> getGroupMembersMap() {
        return groupMembersMap;
    }

    public void setGroupMembersMap(Map<SCGEGroup, List<Person>> groupMembersMap) {
        this.groupMembersMap = groupMembersMap;
    }

    public Map<SCGEGroup, List<Person>> getDCCNIHMembersMap() {
        return DCCNIHMembersMap;
    }

    public void setDCCNIHMembersMap(Map<SCGEGroup, List<Person>> DCCNIHMembersMap) {
        this.DCCNIHMembersMap = DCCNIHMembersMap;
    }


    public boolean hasAccessToStudy(PersonInfo p, Study s) {
        if(s.getGroupId()==p.getSubGroupId()){
                return true;
        }
        return false;
    }

    public boolean hasAccessToStudy(List<PersonInfo> pList, Study s) {
        for (PersonInfo p: pList) {
            return hasAccessToStudy(p,s);
        }
        return false;
    }

    public boolean hasAccessToExperiment() {
        return false;
    }

    DataAccessService service=new DataAccessService();
    StudyDao sdao=new StudyDao();
    public boolean hasAccess(int id, String idType,  List<PersonInfo> personInfoRecords) throws Exception {
        int personId=personInfoRecords.get(0).getPersonId();
        boolean dccNIHflag=false;
        List<Integer> DCCNIHGroupsIds=service.getDCCNIHGroupsIds();
        for(PersonInfo i:personInfoRecords) {
            if (DCCNIHGroupsIds.contains(i.getSubGroupId())) {
                dccNIHflag=true;
            }
        }
        if (idType.equalsIgnoreCase("study")) {
            if(dccNIHflag) {
                return dccNIHflag;
            }else {
                return hasStudyAccess(id,personId);

            }

        }

        return false;
    }
    public boolean verifyPersonHasStudyAccess(int studyId, int personId) throws Exception{
        return sdao.verifyStudyAccessByPesonId(studyId,personId);

    }
    public boolean hasStudyAccess(int studyId, int personId) throws Exception{
        return verifyPersonHasStudyAccess(studyId, personId);
    }

}
