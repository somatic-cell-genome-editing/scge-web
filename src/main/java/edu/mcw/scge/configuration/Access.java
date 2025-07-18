package edu.mcw.scge.configuration;

import edu.mcw.scge.dao.implementation.*;
import edu.mcw.scge.datamodel.*;
import edu.mcw.scge.service.Data;
import edu.mcw.scge.service.DataAccessService;

import org.springframework.web.bind.annotation.ModelAttribute;


import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class Access {
    DataAccessService service=new DataAccessService();
    StudyDao sdao=new StudyDao();
    PersonDao pdao=new PersonDao();
    EditorDao editorDao=new EditorDao();
    DeliveryDao deliveryDao=new DeliveryDao();
    ModelDao modelDao = new ModelDao();
    AccessDao adao = new AccessDao();

    public boolean isLoggedIn() {
        return true;
    }

    public Person getUser(HttpSession session) throws Exception{
        UserService us = new UserService();
        return us.getCurrentUser(session);
    }


    public boolean isAdmin(Person p) throws Exception{

        if (p.getEmail().toLowerCase().equals("jdepons@yahoo.com")
            || p.getEmail().toLowerCase().equals("jthota@mcw.edu")
            || p.getEmail().toLowerCase().equals("mrdwinel@mcw.edu")
            || p.getEmail().toLowerCase().equals("mjhoffman@mcw.edu")
            || p.getEmail().toLowerCase().equals("ageurts@mcw.edu")
            || p.getEmail().toLowerCase().equals("alemke@mcw.edu")
            || p.getEmail().toLowerCase().equals("mgrzybowski@mcw.edu")
            || p.getEmail().toLowerCase().equals("jrsmith@mcw.edu")
            || p.getEmail().toLowerCase().equals("akwitek@mcw.edu")
            || p.getEmail().toLowerCase().equals("mtutaj@mcw.edu")) {
            return true;
        }else {
            return false;
        }
    }
    public boolean isDeveloper(Person p) throws Exception{

        if (p.getEmail().toLowerCase().equals("jdepons@yahoo.com")
                || p.getEmail().toLowerCase().equals("jthota@mcw.edu")
                || p.getEmail().toLowerCase().equals("mtutaj@mcw.edu")) {
            return true;
        }else {
            return false;
        }
    }

    /**
     * verify if the logged in person is PI or Submitter or POC
     * @param p
     * @param s
     * @return
     * @throws Exception
     */
    public boolean canUpdateTier(Person p, Study s) throws Exception {

     //   List<PersonInfo> personInfoRecords= this.getPersonInfoRecords(p.getId());
            List<Integer> piIds=s.getMultiplePis().stream().map(pi->pi.getId()).collect(Collectors.toList());
     //   for(PersonInfo i:personInfoRecords){
              if (s.getSubmitterId()==p.getId() || piIds.contains(p.getId())) {
                  return true;
              }else{
                  List<Person> pocs=sdao.getStudyPOC(s.getStudyId());

                  for (Person poc : pocs) {
                      if(poc.getId()==p.getId()) {
                       return true;
                      }
                  }
              }
    //    }
        return isAdmin(p);
    }


    public boolean isInDCCorNIHGroup(Person p) throws Exception{


        List<Integer> DCCNIHGroupsIds=Data.getInstance().getDCCNIHGroupsIds();
        PersonDao pdao = new PersonDao();
        List<PersonInfo> personInfoRecords = pdao.getPersonInfo(p.getId());

        for(PersonInfo i:personInfoRecords) {
            if (DCCNIHGroupsIds.contains(i.getGroupId())) {
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
            if (DCCNIHGroupsIds.contains(i.getGroupId())) {
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

    public boolean isConsortiumMember(int personId) throws Exception {
        List<PersonInfo> piList = pdao.getPersonInfo(personId);

        if (piList != null) {
                for (PersonInfo pi: piList) {
                    if (pi.getGroupId() == 1411) {
                        return true;
                    }
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
        if(s!=null) {
            if (s.getTier() == 4) {
                return true;
            }

            if (!this.isConsortiumMember(p.getId())) {
                return false;
            }


            if (s.getTier() == 3) {
                return true;
            }

            if (isInDCCorNIHGroup(p)) {
                return true;
            }

            return sdao.verifyStudyAccessByPesonId(s.getStudyId(), p.getId());
        }
        return false;
    }

    public boolean hasExperimentAccess(long experimentId, int personId) throws Exception{
        List<Study> studies = sdao.getStudyByExperimentId(experimentId);
        if (studies.size()==0) {
            return false;
        }

        return hasStudyAccess(studies.get(0).getStudyId(),personId);

    }


    public boolean hasModelAccess(Model m, Person p) throws Exception{
        if (m.getTier() == 4) {
            return true;
        }

        if (!this.isConsortiumMember(p.getId())) {
            return false;
        }

        if (m.getTier() == 3) {
            return true;
        }

        if (isInDCCorNIHGroup(p)) {
            return true;
        }

        return adao.verifyModelAccess(m,p);
        //return modelDao.verifyModelAccess(m.getModelId(), p.getId());
    }

    public boolean hasModelAccess(long modelId, Person p) throws Exception{
        ModelDao mdao = new ModelDao();
        Model m = mdao.getModelById(modelId);
        return this.hasModelAccess(m,p);
    }
    public boolean hasHrdonorAccess(HRDonor h, Person p) throws Exception{
        if (h.getTier() == 4) {
            return true;
        }

        if (!this.isConsortiumMember(p.getId())) {
            return false;
        }

        if (h.getTier() == 3) {
            return true;
        }

        if (isInDCCorNIHGroup(p)) {
            return true;
        }

        return adao.verifyHrdonorAccess(h,p);
        //return modelDao.verifyModelAccess(m.getModelId(), p.getId());
    }

    public boolean hasHrdonorAccess(long hrdonorId, Person p) throws Exception{
        HRDonorDao dao = new HRDonorDao();
        HRDonor h = dao.getHRDonorById(hrdonorId).get(0);
        return this.hasHrdonorAccess(h,p);
    }
    public boolean hasProtocolAccess(Protocol protocol, Person p) throws Exception{
        if (protocol.getTier() == 4) {
            return true;
        }

        if (!this.isConsortiumMember(p.getId())) {
            return false;
        }

        if (protocol.getTier() == 3) {
            return true;
        }

        if (isInDCCorNIHGroup(p)) {
            return true;
        }

        return false;
        //return protocolDao.verifyProtocolAccess(protocol,p);
        //return modelDao.verifyModelAccess(m.getModelId(), p.getId());
    }

    public boolean hasProtocolAccess(long protocolId, Person p) throws Exception{
        ProtocolDao pdao = new ProtocolDao();
        Protocol protocol= pdao.getProtocolById(protocolId);
        return this.hasProtocolAccess(protocol,p);
    }

    public boolean hasRecordAccess(ExperimentRecord r, Person p) throws Exception{
        return this.hasStudyAccess(r.getStudyId(),p.getId());

    }

    public boolean hasRecordAccess(long recordId, Person p) throws Exception{
        ExperimentRecordDao erd = new ExperimentRecordDao();

        List<ExperimentRecord> records =  erd.getExperimentRecordById(recordId);

       // System.out.println("RECORD SIZE + " + records.size());

        if (records.size() > 0 ) {
            return this.hasStudyAccess(records.get(0).getStudyId(),p.getId());
        }

        return false;

    }


    public boolean hasEditorAccess(Editor e, Person p) throws Exception{
        if (e.getTier() == 4) {
            return true;
        }

        if (!this.isConsortiumMember(p.getId())) {
            return false;
        }

        if (e.getTier() == 3) {
            return true;
        }

        if (isInDCCorNIHGroup(p)) {
            return true;
        }
        AccessDao adao = new AccessDao();

        return adao.verifyEditorAccess(e,p);
        //return editorDao.verifyEditorAccess(e.getId(), p.getId());
    }

    public boolean hasEditorAccess(long editorId, int personId) throws Exception{
        EditorDao edao = new EditorDao();
        Editor e = edao.getEditorById(editorId).get(0);
        PersonDao personDao = new PersonDao();
        Person p = personDao.getPersonById(personId).get(0);
        return this.hasEditorAccess(e,p);
    }

    public boolean hasGuideAccess(Guide g, Person p) throws Exception{
        if (g.getTier() == 4) {
            return true;
        }

        if (!this.isConsortiumMember(p.getId())) {
            return false;
        }

        if (g.getTier() == 3) {
            return true;
        }

        if (isInDCCorNIHGroup(p)) {
            return true;
        }

        return adao.verifyGuideAccess(g,p);
    }

    public boolean hasVectorAccess(long vectorId, int personId) throws Exception{
        VectorDao edao = new VectorDao();
        Vector v = edao.getVectorById(vectorId).get(0);
        PersonDao personDao = new PersonDao();
        Person p = personDao.getPersonById(personId).get(0);
        return this.hasVectorAccess(v,p);
    }

    public boolean hasVectorAccess(Vector v, Person p) throws Exception{
        if (v.getTier() == 4) {
            return true;
        }

        if (!this.isConsortiumMember(p.getId())) {
            return false;
        }

        if (v.getTier() == 3) {
            return true;
        }

        if (isInDCCorNIHGroup(p)) {
            return true;
        }

        return adao.verifyVectorAccess(v,p);
    }

    public boolean hasGuideAccess(long guideId, int personId) throws Exception{
        GuideDao edao = new GuideDao();
        Guide g = edao.getGuideById(guideId).get(0);
        PersonDao personDao = new PersonDao();
        Person p = personDao.getPersonById(personId).get(0);
        return this.hasGuideAccess(g,p);
    }


    public boolean hasDeliveryAccess(Delivery d, Person p) throws Exception{
        if (d.getTier() == 4) {
            return true;
        }

        if (!this.isConsortiumMember(p.getId())) {
            return false;
        }

        if (d.getTier() == 3) {
            return true;
        }

        if (isInDCCorNIHGroup(p)) {
            return true;
        }

        return adao.verifyDeliveryAccess(d,p);
        //return deliveryDao.verifyDeliveryAccess(d.getId(), p.getId());
    }

    public boolean hasDeliveryAccess(long deliveryId, int personId) throws Exception{
        DeliveryDao ddao = new DeliveryDao();
        PersonDao pdao = new PersonDao();
        return this.hasDeliveryAccess(ddao.getDeliverySystemsById(deliveryId).get(0),pdao.getPersonById(personId).get(0));
    }

    public boolean verifyUserExists( String principalName, String email) throws Exception {

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
