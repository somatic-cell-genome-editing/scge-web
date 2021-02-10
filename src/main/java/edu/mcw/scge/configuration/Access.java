package edu.mcw.scge.configuration;

import edu.mcw.scge.dao.implementation.*;
import edu.mcw.scge.datamodel.*;
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
    ModelDao modelDao = new ModelDao();

    public boolean isLoggedIn() {
        return true;
    }

    public boolean isAdmin(Person p) {

        System.out.println("email in admin " + p.getEmail());
        if (p.getEmail().equals("jdepons@yahoo.com") || true) {
            return true;
        }else {
            return false;
        }
    }

    public boolean canUpdateTier(Person p, Study s) throws Exception {

        List<PersonInfo> personInfoRecords= this.getPersonInfoRecords(p.getId());

        for(PersonInfo i:personInfoRecords){
            //if(s.getGroupId()==i.getSubGroupId()){
              if (s.getSubmitterId()==p.getId() || s.getPiId()==p.getId()) {
                  return true;
              }
            //}
        }
        return false;
    }


    public boolean isInDCCorNIHGroup(Person p) throws Exception{
        List<Integer> DCCNIHGroupsIds=Data.getInstance().getDCCNIHGroupsIds();
        PersonDao pdao = new PersonDao();
        List<PersonInfo> personInfoRecords = pdao.getPersonInfo(p.getId());

        for(PersonInfo i:personInfoRecords) {
            if (DCCNIHGroupsIds.contains(i.getSubGroupId())) {
                return true;
            }
        }
        return false;
    }


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

    public boolean hasStudyAccess(int studyId, int personId) throws Exception{
        StudyDao sdao = new StudyDao();
        PersonDao personDao = new PersonDao();

        Study s = sdao.getStudyByStudyId(studyId);
        Person p = personDao.getPersonById(personId).get(0);

        return this.hasStudyAccess(s,p);
    }


    public boolean hasStudyAccess(Study s, Person p) throws Exception{
        Access a = new Access();

        if (s.getTier()==4) {
            return true;
        }
        if (s.getTier()==3 && a.isLoggedIn()) {
            return true;
        }

        if (isInDCCorNIHGroup(p)) {
            return true;
        }

        //check for tier 1 access
        List<PersonInfo> personInfoList = pdao.getPersonInfo(p.getId());

        for (PersonInfo pi: personInfoList) {
            if (pi.getSubGroupId()==s.getGroupId()) {
                return true;
            }
        }

        return false;


        //return sdao.verifyStudyAccessByPesonId(s.getStudyId(),p.getId());
    }

    public boolean hasExperimentAccess(int experimentId, int personId) throws Exception{
        return sdao.getStudyByExperimentId(experimentId, personId).size()>0;
    }

    public boolean hasEditorAccess(Editor e, Person p) throws Exception{
        if (e.getTier() == 4) {
            return true;
        }

        if (e.getTier() == 3) {
            return true;
        }

        if (isInDCCorNIHGroup(p)) {
            return true;
        }

        return editorDao.verifyEditorAccess(e.getId(), p.getId());
    }

    public boolean hasModelAccess(Model m, Person p) throws Exception{
        if (m.getTier() == 4) {
            return true;
        }

        if (m.getTier() == 3) {
            return true;
        }

        if (isInDCCorNIHGroup(p)) {
            return true;
        }

        return modelDao.verifyModelAccess(m.getModelId(), p.getId());
    }

    public boolean hasEditorAccess(int editorId, int personId) throws Exception{
        EditorDao edao = new EditorDao();
        Editor e = edao.getEditorById(editorId).get(0);
        PersonDao personDao = new PersonDao();
        Person p = personDao.getPersonById(personId).get(0);
        return this.hasEditorAccess(e,p);
    }

    public boolean hasDeliveryAccess(Delivery d, Person p) throws Exception{
        if (d.getTier() == 4) {
            return true;
        }

        if (d.getTier() == 3) {
            return true;
        }

        if (isInDCCorNIHGroup(p)) {
            return true;
        }

        return deliveryDao.verifyDeliveryAccess(d.getId(), p.getId());
    }

    public boolean hasDeliveryAccess(int deliveryId, int personId) throws Exception{
        DeliveryDao ddao = new DeliveryDao();
        PersonDao pdao = new PersonDao();
        return this.hasDeliveryAccess(ddao.getDeliverySystemsById(deliveryId).get(0),pdao.getPersonById(personId).get(0));
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
