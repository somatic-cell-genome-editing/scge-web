package edu.mcw.scge.configuration;

<<<<<<< HEAD

import edu.mcw.scge.datamodel.PersonInfo;
import edu.mcw.scge.datamodel.Study;
import edu.mcw.scge.dao.implementation.StudyDao;
import edu.mcw.scge.service.DataAccessService;

import java.util.List;

public class Access {



    private static Access a;

    public static Access getInstance() {
        if (a != null) {
            return a;
        }else {
            return new Access();
        }

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
