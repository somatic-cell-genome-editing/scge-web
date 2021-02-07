package edu.mcw.scge.configuration;

import edu.mcw.scge.dao.implementation.DeliveryDao;
import edu.mcw.scge.dao.implementation.EditorDao;
import edu.mcw.scge.dao.implementation.PersonDao;
import edu.mcw.scge.dao.implementation.StudyDao;
import edu.mcw.scge.datamodel.Person;
import edu.mcw.scge.datamodel.PersonInfo;
import edu.mcw.scge.service.Data;
import edu.mcw.scge.service.DataAccessService;

import org.springframework.web.bind.annotation.ModelAttribute;


import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class Access {
    DataAccessService service=new DataAccessService();
    StudyDao sdao=new StudyDao();
    PersonDao pdao=new PersonDao();
    EditorDao editorDao=new EditorDao();
    DeliveryDao deliveryDao=new DeliveryDao();
    public boolean hasAccess(int id, String idType,  List<PersonInfo> personInfoRecords) throws Exception {
        int personId=personInfoRecords.get(0).getPersonId();
        boolean dccNIHflag=false;
      //  List<Integer> DCCNIHGroupsIds=service.getDCCNIHGroupsIds();
        List<Integer> DCCNIHGroupsIds=Data.getInstance().getDCCNIHGroupsIds();
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
        if (idType.equalsIgnoreCase("editor")) {
            if(dccNIHflag) {
                return dccNIHflag;
            }else {
                return hasEditorAccess(id,personId);

            }

        }
        if (idType.equalsIgnoreCase("delivery")) {
            if(dccNIHflag) {
                return dccNIHflag;
            }else {
                return hasDeliveryAccess(id,personId);

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
    public boolean hasEditorAccess(int editorId, int personId) throws Exception{
        return editorDao.verifyEditorAccess(editorId, personId);
    }
    public boolean hasDeliveryAccess(int deliveryId, int personId) throws Exception{
        return deliveryDao.verifyDeliveryAccess(deliveryId, personId);
    }

    public boolean verifyUserExists( String principalName, String email) throws Exception {
        System.out.println("EMAIL: "+ email);
        List<Person> people= (pdao.getPersonByEmail(email));
        if(people!=null && people.size()>0){
            Person p= people.get(0);
            pdao.updateGoogleId(principalName, p.getId());
            return true;
        }
        return false;
    }
    //   @ModelAttribute("personInfoRecords")
    public List<PersonInfo> getPersonInfoRecords(@ModelAttribute("userAttributes") Map userAttributes) throws Exception {
        if(userAttributes!=null) {
            boolean userExists = verifyUserExists(userAttributes.get("sub").toString(), userAttributes.get("email").toString());
            List<PersonInfo> personInfoList = new ArrayList<>();
            if (userExists) {
                List<Person> personRecords = pdao.getPersonByGoogleId(userAttributes.get("sub").toString());
                if (personRecords.size() > 0)
                    personInfoList = pdao.getPersonInfo(personRecords.get(0).getId());
            }
            return personInfoList;
        }
        return null;
    }
    public List<PersonInfo> getPersonInfoRecords(int personId) throws Exception {

            List<PersonInfo> personInfoList = new ArrayList<>();

                    personInfoList = pdao.getPersonInfo(personId);

            return personInfoList;


    }


}
