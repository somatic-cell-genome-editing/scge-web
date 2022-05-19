package edu.mcw.scge.controller;

import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.configuration.UserService;
import edu.mcw.scge.dao.implementation.*;
import edu.mcw.scge.datamodel.*;
import edu.mcw.scge.datamodel.Vector;
import edu.mcw.scge.datamodel.publications.Publication;
import edu.mcw.scge.datamodel.publications.Reference;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

@Controller
@RequestMapping(value="/data/publications")
public class PublicationController {
    PublicationDAO publicationDAO=new PublicationDAO();
    ExperimentDao experimentDao=new ExperimentDao();
    ExperimentRecordDao recordDao=new ExperimentRecordDao();
    GuideDao guideDao=new GuideDao();
    VectorDao vectorDao=new VectorDao();
    @RequestMapping(value="/search")
    public String getAllPublications(HttpServletRequest req, HttpServletResponse res) throws Exception {
        Access access = new Access();
        UserService us = new UserService();
        Person p = us.getCurrentUser(req.getSession());

        List<Reference> references = publicationDAO.getAllReferences();
        List<Publication> publications=new ArrayList<>();
        for(Reference ref:references){
            Publication publication=new Publication();
            publication.setReference(ref);
            publication.setAuthorList(publicationDAO.getAuthorsByRefKey(ref.getKey()));
            publication.setArticleIds(publicationDAO.getArticleIdsByRefKey(ref.getKey()));
            publications.add(publication);
        }
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a>");
        req.setAttribute("publications", publications);
        req.setAttribute("action", "Publications");
        req.setAttribute("page", "/WEB-INF/jsp/tools/publications/publications");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
    @GetMapping(value="/add")
    public String getPublication(HttpServletRequest req, HttpServletResponse res) throws Exception {

        UserService userService=new UserService();
        Access access= new Access();
        if (!access.isAdmin(userService.getCurrentUser(req.getSession()))) {
            req.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(req, res);
        }

        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a>/<a href='/toolkit/data/publications/search'>Publications</a>");
        req.setAttribute("action", "Add New Publication");
        req.setAttribute("page", "/WEB-INF/jsp/tools/publications/addPublication");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
    @RequestMapping(value="/add" , method = RequestMethod.POST)
    public String insertPublication(HttpServletRequest req, HttpServletResponse res) throws Exception {

        UserService userService=new UserService();
        Access access= new Access();
        if (!access.isAdmin(userService.getCurrentUser(req.getSession()))) {
            req.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(req, res);
        }
        String identifier=req.getParameter("identifier");
        String identifierType="pubmed";
        String msg=new String();
        if(identifier!=null && !identifier.equals("")) {
            int key = publicationDAO.getPubIdKey(identifier.trim(), identifierType);
            if (key == 0) {
                publicationDAO.insertPubIds(publicationDAO.getNextKey("pub_id_key_seq"), 0, identifier.trim(), identifierType);
                int refKey = publicationDAO.runPubmedProcesssor(Integer.parseInt(identifier.trim()));
                if (refKey > 0) {
                    msg = "Successfully added publication to the database. Added publication can be viewed in <a href='/toolkit/data/publications/search'>publications list</a>";
                }

            }


        }else {
            msg="<span style='color:red'>Please enter pubmed id..</span>";

        }
        req.setAttribute("message", msg);
            req.setAttribute("crumbtrail", "<a href='/toolkit/loginSuccess?destination=base'>Home</a>/<a href='/toolkit/data/publications/search'>Publications</a>");
            req.setAttribute("action", "Add New Publication");
            req.setAttribute("page", "/WEB-INF/jsp/tools/publications/addPublication");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
    @RequestMapping(value="/associate")
    public String getAssociationSelectFormPage(HttpServletRequest req, HttpServletResponse res) throws Exception {

        UserService userService=new UserService();
        Access access= new Access();
        if (!access.isAdmin(userService.getCurrentUser(req.getSession()))) {
            req.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(req, res);
        }

        String objectId=req.getParameter("objectId");
        if(objectId!=null) {
            long id = Long.parseLong(objectId);
            List<Reference> references = publicationDAO.getReferencesNotAssociatedByObjectId(id);

            List<Publication> publications = new ArrayList<>();
            for (Reference ref : references) {
                Publication publication = new Publication();
                publication.setReference(ref);
                publication.setAuthorList(publicationDAO.getAuthorsByRefKey(ref.getKey()));
                publication.setArticleIds(publicationDAO.getArticleIdsByRefKey(ref.getKey()));
                publications.add(publication);
            }
            req.setAttribute("redirectURL",req.getParameter("redirectURL"));
            req.setAttribute("objectId", req.getParameter("objectId"));
            req.setAttribute("publications", publications);
            req.setAttribute("crumbtrail", "<a href='/toolkit/loginSuccess?destination=base'>Home</a>/<a href='/toolkit/data/publications/search'>Publications</a>");
            req.setAttribute("action", "Associate Publication");
            req.setAttribute("page", "/WEB-INF/jsp/tools/publications/associatePublications");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        }
            return null;

    }
    @RequestMapping(value="/associate/{objectId}", method = RequestMethod.POST)
    public String makeObjectAssociation(HttpServletRequest req, HttpServletResponse res, @PathVariable(required = true)String objectId) throws Exception {

        UserService userService=new UserService();
        Access access= new Access();
        if (!access.isAdmin(userService.getCurrentUser(req.getSession()))) {
            req.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(req, res);
        }
     //   String objectId=req.getParameter("objectId");

        String redirectURL = req.getParameter("redirectURL");
        String[] refKeyValues=req.getParameterValues("refKey");
        for(int i=0;i<refKeyValues.length;i++){
            String refKey=refKeyValues[i];
            String type=req.getParameter("associationType"+refKey);
            if(type!=null){
                System.out.println("REFKEY:"+refKey+"\tTYPE:"+type);
               boolean existsAssociation= publicationDAO.existsAssociation(Integer.parseInt(refKey),Long.parseLong(objectId));
               if(!existsAssociation)
                publicationDAO.insertPubAssociations(Integer.parseInt( refKey),Long.parseLong(objectId),type);
            }
        }
        System.out.println("REDIRECT URL IN insertPubAssociations"+ req.getParameter("redirectURL"));


        return "redirect:"+redirectURL;
    }
    @RequestMapping(value="/associate", method = RequestMethod.POST)
    public String makeAssociation(HttpServletRequest req, HttpServletResponse res) throws Exception {

        UserService userService=new UserService();
        Access access= new Access();
        if (!access.isAdmin(userService.getCurrentUser(req.getSession()))) {
            req.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(req, res);
        }
        List<Reference> references=new ArrayList<>();
        String[] refKeyValues=req.getParameterValues("refKey");
        for(int i=0;i<refKeyValues.length;i++){
            int refKey= Integer.parseInt(refKeyValues[i]);
            Reference reference=publicationDAO.getReferenceByKey(refKey);
           references.add(reference);

        }
        StudyDao studyDao=new StudyDao();
        req.setAttribute("refKeys", refKeyValues);
        req.setAttribute("references", references);
        req.setAttribute("studies", studyDao.getStudies());
        req.setAttribute("action", "Publication Association Form");
        req.setAttribute("page", "/WEB-INF/jsp/tools/publications/associationForm");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        return null;
    }
    @RequestMapping(value="/associate/study")
    public String makeStudyLevelassociation(HttpServletRequest req, HttpServletResponse res) throws Exception {

        UserService userService=new UserService();
        Access access= new Access();
        if (!access.isAdmin(userService.getCurrentUser(req.getSession()))) {
            req.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(req, res);
        }
        int studyId= Integer.parseInt(req.getParameter("studyId"));
        List<Reference> references=new ArrayList<>();
        String[] refKeyValues=req.getParameterValues("refKey");
        if(refKeyValues!=null)
        for(int i=0;i<refKeyValues.length;i++){
            int refKey= Integer.parseInt(refKeyValues[i]);
            Reference reference=publicationDAO.getReferenceByKey(refKey);
            references.add(reference);

        }
        StudyDao studyDao=new StudyDao();
        List<Experiment> experiments=experimentDao.getExperimentsByStudy(studyId);
        Map<Long, List<ExperimentRecord>> experimentRecordsMap=new HashMap<>();
        for(Experiment experiment:experiments){
            List<ExperimentRecord> records=experimentDao.getExperimentRecords(experiment.getExperimentId());
            experimentRecordsMap.put(experiment.getExperimentId(),records );
        }
        Map<String, Map<Long, String>>  objectMap=new HashMap<>();
        objectMap.put("Editor", new HashMap<>());
        objectMap.put("Guide", new HashMap<>());
        objectMap.put("Vector", new HashMap<>());
        objectMap.put("Model", new HashMap<>());
        objectMap.put("Delivery", new HashMap<>());
        objectMap.put("HRDonor", new HashMap<>());
        for(Map.Entry entry:experimentRecordsMap.entrySet()){
            List<ExperimentRecord> records= (List<ExperimentRecord>) entry.getValue();
            for(ExperimentRecord record:records){
                Map<Long, String> editorMap=objectMap.get("Editor");
                if(record.getEditorId()>0)
                editorMap.put(record.getEditorId(), record.getEditorSymbol());

                Map<Long, String> guideMap=objectMap.get("Guide");
                for(Guide g:guideDao.getGuidesByExpRecId(record.getExperimentRecordId()))
                    if(g.getGuide_id()>0)
                guideMap.put(g.getGuide_id(),g.getGuide());

                Map<Long, String> modelMap=objectMap.get("Model");
                if(record.getModelId()>0)
                modelMap.put(record.getModelId(), record.getModelName());

                Map<Long, String> vectorMap=objectMap.get("Vector");
                for(Vector v:vectorDao.getVectorsByExpRecId(record.getExperimentRecordId())){
                   if(v.getVectorId()>0)
                    vectorMap.put(v.getVectorId(), v.getName());
                }

                Map<Long, String> devliveryMap=objectMap.get("Delivery");
                if(record.getHrdonorId()>0)
                devliveryMap.put(record.getDeliverySystemId(), record.getDeliverySystemType());

                Map<Long, String> hrDonor=objectMap.get("HRDonor");
                if(record.getHrdonorId()>0)
                hrDonor.put(record.getHrdonorId(), record.getHrdonorName());


            }
        }

        req.setAttribute("studies", studyDao.getStudies());
        req.setAttribute("selectedStudyId", studyId);
        req.setAttribute("experimentRecordsMap", experimentRecordsMap);
        req.setAttribute("experiments", experiments);
        req.setAttribute("objectMap", objectMap);
        req.setAttribute("references", references);
        req.setAttribute("action", "Publication Association Form");
        req.setAttribute("page", "/WEB-INF/jsp/tools/publications/associationForm");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        return null;
    }
    @RequestMapping(value="/removeAssociation")
    public String getRemoveAssociations(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        UserService userService=new UserService();
        Access access= new Access();
        if (!access.isAdmin(userService.getCurrentUser(req.getSession()))) {
            req.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(req, res);
        }
        String objectId = req.getParameter("objectId");
        String redirectURL = req.getParameter("redirectURL");
        String refKey = req.getParameter("refKey");

        publicationDAO.deletePubAssociation(Long.parseLong(objectId),Integer.parseInt(refKey));

        return "redirect:" + redirectURL;
    }

}
