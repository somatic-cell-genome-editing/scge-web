package edu.mcw.scge.service;

import edu.mcw.scge.dao.implementation.GrantDao;
import edu.mcw.scge.datamodel.ExperimentResultDetail;
import edu.mcw.scge.datamodel.Study;

import java.util.*;

public class ProcessUtils {
    GrantDao grantDao=new GrantDao();
    public  TreeMap<String, Map<Integer, List<Study>>>  getSortedStudiesByInitiative(List<Study> studies) throws Exception {
        TreeMap<String, Map<Integer, List<Study>>> sortedStudies=new TreeMap<>();

        Map<Integer, String> groupGrantMap=new HashMap<>();

        for(Study study:studies){
            String initiative=   grantDao.getGrantByGroupId(study.getGroupId()).getGrantInitiative();
            groupGrantMap.put(study.getGroupId(), initiative);
            sortedStudies.put(initiative, new HashMap<>());
        }
        for(Study study:studies){
            String grantInitiative=groupGrantMap.get(study.getGroupId());
            Map<Integer, List<Study>> groupStudiesMap=sortedStudies.get(grantInitiative);
            List<Study> grantStudies=new ArrayList<>();
            grantStudies.add(study);
            if (groupStudiesMap.get(study.getGroupId()) != null) {
                grantStudies.addAll(groupStudiesMap.get(study.getGroupId()));
            }

            groupStudiesMap.put(study.getGroupId(), grantStudies);

            sortedStudies.put(grantInitiative, groupStudiesMap);
        }
        return sortedStudies;
    }
    public String getResultKey(ExperimentResultDetail erd){
        return erd.getResultType().trim() + " (" + erd.getUnits().trim() + ")";
    }
}
