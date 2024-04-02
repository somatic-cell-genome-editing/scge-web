package edu.mcw.scge.controller;

import com.google.gson.Gson;
import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.configuration.UserService;
import edu.mcw.scge.dao.implementation.*;
import edu.mcw.scge.datamodel.*;
import edu.mcw.scge.datamodel.Vector;
import edu.mcw.scge.datamodel.publications.ArticleId;
import edu.mcw.scge.datamodel.publications.Publication;
import edu.mcw.scge.datamodel.publications.Reference;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

@Controller
@RequestMapping(value="/data/publications")
public class PublicationController extends ObjectController {
    PublicationDAO publicationDAO=new PublicationDAO();
    ExperimentDao experimentDao=new ExperimentDao();
    GuideDao guideDao=new GuideDao();
    VectorDao vectorDao=new VectorDao();
    StudyDao studyDao=new StudyDao();
    Gson gson=new Gson();
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
                }else {
                    msg="<span style='color:red'>Error inserting the publication "+identifierType+":"+identifier+"</span>";
                }

            }else {
                msg="<span style='color:red'>pubmed id ..</span>" +identifier +" exists";

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
                publicationDAO.makeAssociation(Long.parseLong(objectId),Integer.parseInt(refKey),req.getParameter("associationType"+refKey));

            }
        }
    //    System.out.println("REDIRECT URL IN insertPubAssociations"+ req.getParameter("redirectURL"));


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
        Map<Integer, String> idMap=new HashMap<>(); //Map(refKey, pubmedId)
        String[] refKeyValues=req.getParameterValues("refKey");
        for (String refKeyValue : refKeyValues) {
            int refKey = Integer.parseInt(refKeyValue);
            Reference reference = publicationDAO.getReferenceByKey(refKey);
            references.add(reference);

        }


        req.setAttribute("idMap", idMap);
        req.setAttribute("refKeys", refKeyValues);
        req.setAttribute("references", references);
        req.setAttribute("studies", studyDao.getStudies());
        req.setAttribute("action", "Publication Association Form");
        req.setAttribute("page", "/WEB-INF/jsp/tools/publications/associationForm");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        return null;
    }
    @RequestMapping(value="/associate/study")
    public String getStudyDetailsToAssociatePublication(HttpServletRequest req, HttpServletResponse res) throws Exception {

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
       Map<Long,  Map<String, Map<Long, String>>> experimentObjectsMap=new HashMap<>();
        for(Map.Entry entry:experimentRecordsMap.entrySet()){
            Map<String, Map<Long, String>>  objectMap=new HashMap<>();
            objectMap.put("Editor", new HashMap<>());
            objectMap.put("Guide", new HashMap<>());
            objectMap.put("Vector", new HashMap<>());
            objectMap.put("Model", new HashMap<>());
            objectMap.put("Delivery", new HashMap<>());
            objectMap.put("HRDonor", new HashMap<>());
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
                if(record.getDeliverySystemId()>0)
                devliveryMap.put(record.getDeliverySystemId(), record.getDeliverySystemType());

                Map<Long, String> hrDonor=objectMap.get("HRDonor");
                if(record.getHrdonorId()>0)
                hrDonor.put(record.getHrdonorId(), record.getHrdonorName());


            }
            experimentObjectsMap.put((Long) entry.getKey(), objectMap);
        }
        Set<Long> associated=new HashSet<>();
        Set<Long> related=new HashSet<>();
        getAssociationTypesFromDB(experimentRecordsMap, references, associated, related);
        req.setAttribute("associated",associated );
        req.setAttribute("related", related );

        req.setAttribute("studies", studyDao.getStudies());
        req.setAttribute("selectedStudyId", studyId);
        req.setAttribute("experimentRecordsMap", experimentRecordsMap);
        req.setAttribute("experiments", experiments);
        //req.setAttribute("objectMap", objectMap);
        req.setAttribute("experimentObjectsMap", experimentObjectsMap);
        req.setAttribute("references", references);
        req.setAttribute("action", "Publication Association Form");
        req.setAttribute("page", "/WEB-INF/jsp/tools/publications/associationForm");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        return null;
    }
    public void getAssociationTypesFromDB( Map<Long, List<ExperimentRecord>> experimentRecordsMap, List<Reference> references, Set<Long> associated, Set<Long> related) throws Exception {

        Set<Long> scgeIds=new HashSet<>();
        for(Map.Entry entry:experimentRecordsMap.entrySet()){
            scgeIds.add((Long) entry.getKey());

            List<ExperimentRecord> records= (List<ExperimentRecord>) entry.getValue();
            for(ExperimentRecord record:records){

                if(record.getEditorId()>0)
                    scgeIds.add(record.getEditorId());


                for(Guide g:guideDao.getGuidesByExpRecId(record.getExperimentRecordId()))
                    if(g.getGuide_id()>0){
                        scgeIds.add(g.getGuide_id());

                    }

                if(record.getModelId()>0){
                    scgeIds.add(record.getModelId());

                }
                for(Vector v:vectorDao.getVectorsByExpRecId(record.getExperimentRecordId())){
                    if(v.getVectorId()>0){
                        scgeIds.add(v.getVectorId());

                    }
                }
                if(record.getDeliverySystemId()>0){
                    scgeIds.add(record.getDeliverySystemId());

                }
                if(record.getHrdonorId()>0){

                    scgeIds.add(record.getHrdonorId());

                }

            }

        }
      //  System.out.println("SCGEIDS:"+scgeIds.toString());

            for(Long scgeId:scgeIds){
                List<Publication> associatedPublications= publicationDAO.getAssociatedPublications(scgeId);
                List<Publication> relatedPublications= publicationDAO.getRelatedPublications(scgeId);
                for(Reference r:references){
                for(Publication p:associatedPublications){
                   if(p.getReference().getKey()==r.getKey()){
                       associated.add(scgeId);
                   }
               }
                for(Publication p:relatedPublications){
                    if(p.getReference().getKey()==r.getKey()){
                        related.add(scgeId);
                    }
                }
            }
        }
       //     System.out.println("ASSOCIATION TYPES DB:"+ gson.toJson(associated));

    }
    @RequestMapping(value="/associate/study/submit")
    public String makeStudyLevelAssociation(HttpServletRequest req, HttpServletResponse res) throws Exception {

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

        List<Experiment> experiments=experimentDao.getExperimentsByStudy(studyId);
        Map<Long, List<ExperimentRecord>> experimentRecordsMap=new HashMap<>();
        for(Experiment experiment:experiments){
            List<ExperimentRecord> records=experimentDao.getExperimentRecords(experiment.getExperimentId());
            experimentRecordsMap.put(experiment.getExperimentId(),records );
        }
        Map<Long,  String> associationTypes=getAssociationTypes(experimentRecordsMap,req);//Map<SCGE_OBJECT_ID, REF_KEY>
    //    System.out.println("Association Types:" +gson.toJson(associationTypes));
        for(String object:Arrays.asList("experiment", "editor","model", "vector","delivery", "guide", "hrDonor")) {
            if (req.getParameterValues(object) != null) {
                for (String x : req.getParameterValues(object)) {
                for (Reference reference : references) {

                       publicationDAO.makeAssociation(Long.parseLong(x), reference.getKey(), associationTypes.get(Long.parseLong(x)));
                   // System.out.println(Long.parseLong(x)+"\t"+ reference.getKey()+"\t"+ associationTypes.get(Long.parseLong(x)));
                    }
                }
            }

        }
     
        req.setAttribute("studies", studyDao.getStudies());
        req.setAttribute("selectedStudyId", studyId);
     //   req.setAttribute("experimentRecordsMap", experimentRecordsMap);
    //    req.setAttribute("experiments", experiments);
        //req.setAttribute("objectMap", objectMap);
        req.setAttribute("references", references);
        req.setAttribute("action", "Publication Association Form");
        req.setAttribute("page", "/WEB-INF/jsp/tools/publications/associationForm");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        return null;
    }
    public Map<Long,  String> getAssociationTypes( Map<Long, List<ExperimentRecord>> experimentRecordsMap, HttpServletRequest req) throws Exception {
        Map<Long,  String> associationTypes=new HashMap<>();
        for(Map.Entry entry:experimentRecordsMap.entrySet()){
         //   System.out.println("ASSOCIATION TYPE:"+req.getParameter(String.valueOf( entry.getKey())));
            if(req.getParameter(String.valueOf(entry.getKey()))!=null)
            associationTypes.put((Long) entry.getKey(), req.getParameter(String.valueOf( entry.getKey())));
            List<ExperimentRecord> records= (List<ExperimentRecord>) entry.getValue();
            for(ExperimentRecord record:records){

                if(record.getEditorId()>0)
                    associationTypes.put(record.getEditorId(),  req.getParameter(String.valueOf(record.getEditorId())));


                for(Guide g:guideDao.getGuidesByExpRecId(record.getExperimentRecordId()))
                    if(g.getGuide_id()>0){
                        associationTypes.put(g.getGuide_id(),  req.getParameter(String.valueOf(g.getGuide_id())));

                    }

                if(record.getModelId()>0){
                    associationTypes.put(record.getModelId(),  req.getParameter(String.valueOf(record.getModelId())));

                }
                for(Vector v:vectorDao.getVectorsByExpRecId(record.getExperimentRecordId())){
                    if(v.getVectorId()>0){
                        associationTypes.put(v.getVectorId(),  req.getParameter(String.valueOf(v.getVectorId())));

                    }
                }
                if(record.getDeliverySystemId()>0){
                    associationTypes.put(record.getDeliverySystemId(),  req.getParameter(String.valueOf(record.getDeliverySystemId())));

                }
                if(record.getHrdonorId()>0){

                    associationTypes.put(record.getHrdonorId(),  req.getParameter(String.valueOf(record.getHrdonorId())));

                }

            }

        }
return associationTypes;
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
    @RequestMapping(value="/publication")
    public String getReference(HttpServletRequest req, HttpServletResponse res) throws Exception {
        PublicationDAO dao = new PublicationDAO();

        AssociationDao associationDao=new AssociationDao();
        Reference reference= dao.getReferenceByKey(Integer.parseInt(req.getParameter("key")));
        Publication publication=new Publication();
        publication.setReference(reference);
        publication.setAuthorList(publicationDAO.getAuthorsByRefKey(reference.getKey()));
        publication.setArticleIds(publicationDAO.getArticleIdsByRefKey(reference.getKey()));
        for(ArticleId id:publication.getArticleIds()){
            if(id.getIdType()!=null && !id.getIdType().equals("")) {
             id.setUrl( dao.getXDBUrl(id.getIdType().toLowerCase()));
            }
        }
        Association association=associationDao.getPublicationAssociations(reference.getKey());
        List<Study> studies=association.getAssociatedStudies();
        if(studies!=null && studies.size()>0) {
            List<ExperimentRecord> experimentRecords=new ArrayList<>();
            if(association.getAssociatedExperiments()!=null){
                for(Experiment experiment:association.getAssociatedExperiments()){
                    List<ExperimentRecord> records=experimentDao.getExperimentRecords(experiment.getExperimentId());
                    experimentRecords.addAll(records);
                }
            }
            mapProjectNExperiments(experimentRecords, req);
        }
      req.setAttribute("summaryBlocks", getSummary(publication));
        req.setAttribute("crumbTrail",   "publication");
        req.setAttribute("publication", reference);
        req.setAttribute("pub", publication);
        req.setAttribute("publicationAssoications", association);
        req.setAttribute("associatedPublications", association.getAssociatedPublications());
        req.setAttribute("relatedPublications", association.getRelatedPublications());
        req.setAttribute("studies", studies);
        req.setAttribute("action","Publication: " + reference.getTitle());
        req.setAttribute("page", "/WEB-INF/jsp/tools/publications/publication");
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a> / <a href='/toolkit/data/search/results/Publication?searchTerm='>Publications</a>");
        req.setAttribute("seoDescription",reference.getRefAbstract());
        req.setAttribute("seoTitle",reference.getTitle());
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
    public  Map<String, Map<String, String>> getSummary(Publication publication){
        Map<String, Map<String, String>> summaryBlocks=new LinkedHashMap<>();

        Map<String, String> summary=new LinkedHashMap<>();
        int i=0;
//        summary.put("SCGE ID", String.valueOf(protocol.getKey()));
        if(publication.getReference().getTitle()!=null && !publication.getReference().getTitle().equals(""))
            summary.put("Title", publication.getReference().getTitle());
        if(publication.getReference().getRefAbstract()!=null && !publication.getReference().getRefAbstract().equals(""))
            summary.put("Abstract", publication.getReference().getRefAbstract());



        summaryBlocks.put("block"+i, summary);


        return summaryBlocks;
    }
}
