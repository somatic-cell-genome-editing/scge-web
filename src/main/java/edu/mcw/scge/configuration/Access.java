package edu.mcw.scge.configuration;

import edu.mcw.scge.dao.implementation.StudyDao;
import edu.mcw.scge.datamodel.PersonInfo;
import edu.mcw.scge.service.DataAccessService;

import java.util.List;

public class Access {
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
        if (idType.equalsIgnoreCase("experiment")) {
            if(dccNIHflag) {
                return dccNIHflag;
            }else {
                return hasExperimentAccess(id,personId);

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
    public boolean hasExperimentAccess(int experimentId, int personId) throws Exception{
        return sdao.getStudyByExperimentId(experimentId, personId).size()>0;
    }
}
