package edu.mcw.scge.service;

import edu.mcw.scge.datamodel.Person;
import edu.mcw.scge.datamodel.SCGEGroup;

import java.util.List;
import java.util.Map;

public class Data {
    private static Data instance =null;
    private  Map<Integer, List<SCGEGroup>> consortiumGroups;
    private  Map<SCGEGroup, List<Person>> groupMembersMap ;
    private  Map<SCGEGroup, List<Person>> DCCNIHMembersMap;
    private  List<Integer> DCCNIHGroupsIds;
    private Data() throws Exception {
        DataAccessService service=new DataAccessService();
        consortiumGroups=service.getGroupsMapByGroupName("consortium");
        groupMembersMap= service.getGroupMembersMapExcludeDCCNIH(consortiumGroups);
        DCCNIHMembersMap= service.getDCCNIHMembersMap(consortiumGroups);
        DCCNIHGroupsIds=service.getDCCNIHGroupsIds();

    }
    public static Data getInstance() throws Exception {
        if(instance==null)
            instance=new Data();
        return instance;
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

    public List<Integer> getDCCNIHGroupsIds() {
        return DCCNIHGroupsIds;
    }

    public void setDCCNIHGroupsIds(List<Integer> DCCNIHGroupsIds) {
        this.DCCNIHGroupsIds = DCCNIHGroupsIds;
    }
}
