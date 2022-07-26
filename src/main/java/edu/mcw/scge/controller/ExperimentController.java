package edu.mcw.scge.controller;

import com.google.gson.Gson;
import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.configuration.UserService;
import edu.mcw.scge.dao.implementation.*;
import edu.mcw.scge.datamodel.*;
import edu.mcw.scge.datamodel.Vector;
import edu.mcw.scge.datamodel.publications.ArticleId;
import edu.mcw.scge.datamodel.publications.Author;
import edu.mcw.scge.datamodel.publications.Publication;
import edu.mcw.scge.datamodel.publications.Reference;
import edu.mcw.scge.process.customLabels.CustomUniqueLabels;
import edu.mcw.scge.service.db.DBService;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.PathParam;
import javax.ws.rs.ext.ParamConverter;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping(value="/data/experiments")
public class ExperimentController extends UserController {
    ExperimentDao edao = new ExperimentDao();
    ExperimentRecordDao erDao=new ExperimentRecordDao();
    StudyDao sdao = new StudyDao();
    Access access=new Access();
    DBService dbService=new DBService();
    UserService userService=new UserService();
    CustomUniqueLabels customLabels=new CustomUniqueLabels();
    GrantDao grantDao=new GrantDao();
    PublicationDAO publicationDAO=new PublicationDAO();
    GuideDao guideDao=new GuideDao();
    VectorDao vectorDao=new VectorDao();
    @RequestMapping(value="/search")
    public String getAllExperiments(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        ExperimentDao edao=new ExperimentDao();

        List<Experiment>  records = edao.getAllExperiments();
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a>");
        req.setAttribute("experiments", records);
        req.setAttribute("action", "Experiments");
        req.setAttribute("page", "/WEB-INF/jsp/tools/experiments");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;

    }

/*    @RequestMapping(value="/study/{studyId}")
    public String getExperimentsByStudyId( HttpServletRequest req, HttpServletResponse res,
                                           @PathVariable(required = false) int studyId) throws Exception {
        Person p=userService.getCurrentUser(req.getSession());
        Study study = sdao.getStudyById(studyId).get(0);

        if(!access.isLoggedIn()) {
            return "redirect:/";
        }

        if (!access.hasStudyAccess(study,p)) {
            req.setAttribute("page", "/WEB-INF/jsp/error");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            return null;

        }

        List<Experiment> records = edao.getExperimentsByStudy(studyId);
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a> / <a href='/toolkit/data/studies/search'>Studies</a>");
        req.setAttribute("experiments", records);
        req.setAttribute("study", study);
        req.setAttribute("action", "Experiments");
        req.setAttribute("page", "/WEB-INF/jsp/tools/experiments");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        return null;
    }

 */
@RequestMapping(value="/study/{studyId}")
public String getExperimentsByStudyId( HttpServletRequest req, HttpServletResponse res,
                                       @PathVariable(required = false) int studyId) throws Exception {
    Person p=userService.getCurrentUser(req.getSession());
    Study study = sdao.getStudyById(studyId).get(0);

    if(!access.isLoggedIn()) {
        return "redirect:/";
    }

    if (!access.hasStudyAccess(study,p)) {
        req.setAttribute("page", "/WEB-INF/jsp/error");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        return null;

    }


    return "redirect:/data/experiments/group/"+study.getGroupId();
}


    @RequestMapping(value="/group/{groupId}")
    public String getExperimentsByGroupId( HttpServletRequest req, HttpServletResponse res,
                                           @PathVariable(required = false) int groupId) throws Exception {
        Person p=userService.getCurrentUser(req.getSession());
        List<Study> studies = sdao.getStudiesByGroupId(groupId);

        if(!access.isLoggedIn()) {
            return "redirect:/";
        }
        List<Publication> publications=getPublication(studies.get(0));
        req.setAttribute("publications", publications);
        LinkedHashMap<Study, List<Experiment>> studyExperimentMap=new LinkedHashMap<>();
        for(Study study:studies) {
            if (access.hasStudyAccess(study, p)) {
                List<Experiment> experiments = edao.getExperimentsByStudy(study.getStudyId());
                if(experiments.size()>0)
                studyExperimentMap.put(study, experiments);
            }
        }
        for(Study study:studies) {
            if (access.hasStudyAccess(study, p)) {
                List<Experiment> experiments = edao.getExperimentsByStudy(study.getStudyId());
                if(experiments.size()==0)
                    studyExperimentMap.put(study, experiments);
            }
        }

        if(studyExperimentMap.size()==0){
            req.setAttribute("page", "/WEB-INF/jsp/error");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            return null;
        }
        req.setAttribute("crumbtrail", "<a href='/toolkit/loginSuccess?destination=base'>Home</a> / <a href='/toolkit/data/search/results/Experiment?searchTerm='>Experiments</a>");

        req.setAttribute("study", studies.get(0));
        Map<Long, List<Experiment>> experimentsValidatedMap=new HashMap<>();
        Map<Long, List<Experiment>> validationExperimentsMap=new HashMap<>();
        if(studies.get(0).getIsValidationStudy()==1)
        experimentsValidatedMap=getExperimentsValidated(studies);
        else
        validationExperimentsMap=getValidations(studies);
        req.setAttribute("experimentsValidatedMap" , experimentsValidatedMap);
        req.setAttribute("validationExperimentsMap",validationExperimentsMap);
        req.setAttribute("studyExperimentMap", studyExperimentMap);
        req.setAttribute("action","Study: " + grantDao.getGrantByGroupId (studies.get(0).getGroupId()).getGrantTitle());
        req.setAttribute("page", "/WEB-INF/jsp/tools/experiments");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
    public List<Publication> getPublication(Study study) throws Exception {
        List<Publication> publications= new ArrayList<>();
        List<Reference> references=publicationDAO.getPublicationsBySCGEId(study.getStudyId());
        if(references!=null) {
            for (Reference reference : references) {
                Publication publication = new Publication();
                publication.setReference(reference);
                List<Author> authors = publicationDAO.getAuthorsByRefKey(reference.getKey());
                publication.setAuthorList(authors);

                List<ArticleId> articleIds = publicationDAO.getArticleIdsSCGEID(study.getStudyId());
                if (articleIds != null && articleIds.size() > 0) {
                    publication.setArticleIds(articleIds);
                }
                publications.add(publication);
            }
        }
        return publications;
    }
    @RequestMapping(value="/validations/study/{studyId}")
    public String getLimitedExperimentsByGroupId(HttpServletRequest req, HttpServletResponse res,
                                                 @PathVariable(required = false) int studyId
                                                 ) throws Exception {
        Person p=userService.getCurrentUser(req.getSession());
        Study s = sdao.getStudyById(studyId).get(0);

        List<Study> studies = sdao.getStudiesByGroupId(s.getGroupId());
        String experimentIds=  req.getParameter("experimentIds");
        System.out.println("EXPERIMENT IDS: "+ req.getParameter("experimentIds"));
        if(!access.isLoggedIn()) {
            return "redirect:/";
        }
        LinkedHashMap<Study, List<Experiment>> studyExperimentMap=new LinkedHashMap<>();
        for(Study study:studies) {
            if (access.hasStudyAccess(study, p)) {
                List<Experiment> experiments = new ArrayList<>();
                String[] experimentIDs=experimentIds.split(",");
                for (String experimentId : experimentIDs) {
                    if(!experimentId.equals("")) {
                        Experiment experiment = edao.getExperimentByStudyIdNExperimentId(study.getStudyId() ,Long.parseLong(experimentId));
                        if (experiment != null) {
                            experiments.add(experiment);
                        }
                    }
                }
                if(experiments.size()>0)
                studyExperimentMap.put(study, experiments);
            }
        }
        for(Study study:studies) {
            if (access.hasStudyAccess(study, p)) {
                List<Experiment> experiments=new ArrayList<>();
                String[] experimentIDs=experimentIds.split(",");
                for (String experimentId : experimentIDs) {
                    if(!experimentId.equals("")) {
                        Experiment experiment = edao.getExperimentByStudyIdNExperimentId(study.getStudyId(), Long.parseLong(experimentId));
                        if (experiment != null) {
                            experiments.add(experiment);
                        }
                    }
                }
                if(experiments.size()>0)
                studyExperimentMap.put(study, experiments);

            }
        }

        if(studyExperimentMap.size()==0){
            req.setAttribute("page", "/WEB-INF/jsp/error");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            return null;
        }
        req.setAttribute("crumbtrail", "<a href='/toolkit/loginSuccess?destination=base'>Home</a> / <a href='/toolkit/data/search/results/Experiment?searchTerm='>Experiments</a>");

        req.setAttribute("study", studies.get(0));
        Map<Long, List<Experiment>> experimentsValidatedMap=new HashMap<>();
        Map<Long, List<Experiment>> validationExperimentsMap=new HashMap<>();
        if(studies.get(0).getIsValidationStudy()==1)
            experimentsValidatedMap=getExperimentsValidated(studies);
        else
            validationExperimentsMap=getValidations(studies);
        req.setAttribute("experimentsValidatedMap" , experimentsValidatedMap);
        req.setAttribute("validationExperimentsMap",validationExperimentsMap);
        req.setAttribute("studyExperimentMap", studyExperimentMap);
        req.setAttribute("action",grantDao.getGrantByGroupId (studies.get(0).getGroupId()).getGrantTitle());
        req.setAttribute("page", "/WEB-INF/jsp/tools/experiments");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
    public Map<Long, List<Experiment>> getValidations(List<Study> studies) throws Exception {
       Map<Long, List<Experiment>> validationExperimentsMap=new HashMap<>();

        for(Study study:studies) {
           List<Experiment> experiments=edao.getExperimentsByStudy(study.getStudyId());

           for (Experiment e : experiments) {
                   List<Long> experimentIds = edao.getValidationExperiments(e.getExperimentId());
                   List<Experiment> validatedExperiments = new ArrayList<>();
                   for (long experimentId : experimentIds) {
                       Experiment experiment = edao.getExperiment(experimentId);
                       validatedExperiments.add(experiment);
                   }
                   if(validatedExperiments.size()>0)
                   validationExperimentsMap.put(e.getExperimentId(), validatedExperiments);
               }

       }
        System.out.println("Validations:"+ validationExperimentsMap.size());
        return validationExperimentsMap;
    }
    public Map<Long, List<Experiment>> getExperimentsValidated(List<Study> studies) throws Exception {
        Map<Long, List<Experiment>> experimentsValidatedMap=new HashMap<>();
        for(Study study:studies) {

                List<Experiment> experiments = edao.getExperimentsByStudy(study.getStudyId());
                for (Experiment e : experiments) {
                    List<Long> experimentIds = edao.getExperimentsValidated(e.getExperimentId());
                    List<Experiment> validatedExperiments = new ArrayList<>();
                    for (long experimentId : experimentIds) {
                        Experiment experiment = edao.getExperiment(experimentId);
                        validatedExperiments.add(experiment);
                    }
                    if(validatedExperiments.size()>0)
                    experimentsValidatedMap.put(e.getExperimentId(), validatedExperiments);
                }


        }
        System.out.println("Experiments validated:"+ experimentsValidatedMap.size());

        return experimentsValidatedMap;
    }

    @RequestMapping(value="/experiment/experimentRecords")
    public String getAllExperimentRecords(HttpServletRequest req, HttpServletResponse res
    ) throws Exception {

        Person p = userService.getCurrentUser(req.getSession());

        if (!access.isLoggedIn()) {
            return "redirect:/";
        }

        List<ExperimentRecord> records = new ArrayList<>();
        List<ExperimentRecord> allRecords = edao.getAllExperimentRecords();
        Set<Integer> studies = new TreeSet<>();
        HashMap<Integer,String> studyNames = new HashMap<>();
        for (ExperimentRecord r : allRecords) {
            studies.add(r.getStudyId());
        }

        for (int s : studies){
            Study study = sdao.getStudyById(s).get(0);
            if(!access.hasStudyAccess(study,p))
                studies.remove(s);
            else {
                String piname = study.getPi();
                String label = piname.split(",")[0];
                int index=label.lastIndexOf(" ");
                label = label.substring(index);
                studyNames.put(s,label);
            }
        }

        if (studies.size() == 0) {
            req.setAttribute("page", "/WEB-INF/jsp/error");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            return null;
        }

        Map<String, List<Double>> plotData=new HashMap<>();
        List<Double> mean = new ArrayList<>();
        HashMap<Long,Double> resultMap = new HashMap<>();
        HashMap<Long,List<ExperimentResultDetail>> resultDetail = new HashMap<>();
        HashMap<Long,String> labels = new HashMap<>();
        int noOfSamples = 0;
        for(ExperimentRecord record:allRecords) {
            if(studies.contains(record.getStudyId())) {
                records.add(record);
                String label = studyNames.get(record.getStudyId());
                labels.put(record.getExperimentRecordId(),"\"" + label+ "-" + record.getExperimentRecordId() + "\"");
                List<ExperimentResultDetail> experimentResults = dbService.getExperimentalResults(record.getExperimentRecordId());
                resultDetail.put(record.getExperimentRecordId(), experimentResults);
                double average = 0;
                for (ExperimentResultDetail result : experimentResults) {
                    noOfSamples = result.getNumberOfSamples();
                    if (result.getResult() != null && !result.getResult().isEmpty())
                        average += Double.valueOf(result.getResult());
                }
                average = average / noOfSamples;
                average = Math.round(average * 100.0) / 100.0;
                mean.add(average);
                resultMap.put(record.getExperimentRecordId(), average);
            }
        }

        plotData.put("Mean",mean);
        req.setAttribute("experiments",labels);
        req.setAttribute("plotData",plotData);
        req.setAttribute("experimentRecords", records);
        req.setAttribute("resultDetail",resultDetail);
        req.setAttribute("resultMap",resultMap);
       // req.setAttribute("study", study);
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a> / <a href='/toolkit/data/search/results/Experiment?searchTerm='>Experiments</a>");
        req.setAttribute("action", "All Experiment Records");
        req.setAttribute("page", "/WEB-INF/jsp/tools/allExperimentRecords");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        return null;
    }

    @RequestMapping(value="/experiment/compare/{experimentId1}/{experimentId2}")
    public String compare(HttpServletRequest req, HttpServletResponse res,
                                     @PathVariable(required = false) long experimentId1,
                                     @PathVariable(required = false) long experimentId2) throws Exception {

        Person p = userService.getCurrentUser(req.getSession());

        if (!access.isLoggedIn()) {
            return "redirect:/";
        }

        List<ExperimentRecord> exp1 = edao.getExperimentRecords(experimentId1);
        List<ExperimentRecord> exp2 = edao.getExperimentRecords(experimentId2);
        Set<Integer> studies = new TreeSet<>();
        studies.add(exp1.get(0).getStudyId());
        studies.add(exp2.get(0).getStudyId());
        List<Study> studiesList = new ArrayList<>();
        for (int s : studies){
            Study study = sdao.getStudyById(s).get(0);
            studiesList.add(study);
            if(!access.hasStudyAccess(study,p)){
                req.setAttribute("page", "/WEB-INF/jsp/error");
                req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
                return null;
            }
        }

        ExperimentRecord expr1 = exp1.get(0);
        ExperimentRecord expr2 = exp2.get(0);

        Experiment e1 = edao.getExperiment(experimentId1);
        Experiment e2 = edao.getExperiment(experimentId2);

        List<ExperimentRecord> allRecords = new ArrayList<>();
        allRecords.addAll(exp1);
        allRecords.addAll(exp2);

        HashMap<String,Double> exp1Results = new HashMap<>();
        HashMap<String,Double> exp2Results = new HashMap<>();
        List<Double> exp1Mean = new ArrayList<>();
        List<Double> exp2Mean = new ArrayList<>();
        HashMap<Long,String> labels = new HashMap<>();
        Set<String> labelNames = new TreeSet<>();
        int noOfSamples = 0;

        String editor1 = "\"" + exp1.get(0).getEditorSymbol() + "\"";
        String editor2 = "\"" + exp2.get(0).getEditorSymbol() + "\"";
        String units="";
        List<Guide> guides1 = dbService.getGuidesByExpRecId(exp1.get(0).getExperimentRecordId());
        List<Guide> guides2 = dbService.getGuidesByExpRecId(exp2.get(0).getExperimentRecordId());

        for(ExperimentRecord record:allRecords) {
            labels.put(record.getDeliverySystemId(),record.getDeliverySystemType());
            List<ExperimentResultDetail> experimentResults = dbService.getExperimentalResults(record.getExperimentRecordId());

            double average = 0;
            for (ExperimentResultDetail result : experimentResults) {
                noOfSamples = result.getNumberOfSamples();
                units = "\"" + result.getResultType() + " in " + experimentResults.get(0).getUnits() + "\"";
                if (result.getReplicate() == 0 && !result.getResult().equalsIgnoreCase("No editing detected"))
                    average = Double.valueOf(result.getResult());
            }

            if(experimentId1 == record.getExperimentId()) {
                exp1Results.put(record.getDeliverySystemType(), average);
            }
            else {
                exp2Results.put(record.getDeliverySystemType(),average);
            }
        }
        for(Long id:labels.keySet()) {
            String name = labels.get(id);
            exp1Mean.add(exp1Results.get(name));
            exp2Mean.add(exp2Results.get(name));
            labelNames.add("\"" + name +"\"" ); //add quotes for labels on graph
        }

        req.setAttribute("action", "Compare Experiments");
        req.setAttribute("labelNames",labelNames);
        req.setAttribute("labels",labels);
        req.setAttribute("exp1Mean",exp1Mean);
        req.setAttribute("exp2Mean",exp2Mean);
        req.setAttribute("editor1",editor1);
        req.setAttribute("editor2",editor2);
        req.setAttribute("exp1Results",exp1Results);
        req.setAttribute("exp2Results",exp2Results);
        req.setAttribute("units",units);
        req.setAttribute("studies",studiesList);
        req.setAttribute("expRecord1",expr1);
        req.setAttribute("expRecord2",expr2);
        req.setAttribute("exp1",e1);
        req.setAttribute("exp2",e2);
        req.setAttribute("guides1",guides1);
        req.setAttribute("guides2",guides2);
        req.setAttribute("page", "/WEB-INF/jsp/tools/compareExperiments");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        return null;
    }
    @RequestMapping(value="/experiment/compareExperiments/{experimentId1}/{experimentId2}")
    public String compareExperiments(HttpServletRequest req, HttpServletResponse res,
                                     @PathVariable(required = false) long experimentId1,
                                     @PathVariable(required = false) long experimentId2) throws Exception {

        Person p = userService.getCurrentUser(req.getSession());

        if (!access.isLoggedIn()) {
            return "redirect:/";
        }

        List<ExperimentRecord> exp1 = edao.getExperimentRecords(experimentId1);
        List<ExperimentRecord> exp2 = edao.getExperimentRecords(experimentId2);
        Set<Integer> studies = new TreeSet<>();
        studies.add(exp1.get(0).getStudyId());
        studies.add(exp2.get(0).getStudyId());
        List<Study> studiesList = new ArrayList<>();
        for (int s : studies){
            Study study = sdao.getStudyById(s).get(0);
            studiesList.add(study);
            if(!access.hasStudyAccess(study,p)){
                req.setAttribute("page", "/WEB-INF/jsp/error");
                req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
                return null;
            }
        }

        ExperimentRecord expr1 = exp1.get(0);
        ExperimentRecord expr2 = exp2.get(0);

        Experiment e1 = edao.getExperiment(experimentId1);
        Experiment e2 = edao.getExperiment(experimentId2);

        List<ExperimentRecord> allRecords = new ArrayList<>();
        allRecords.addAll(exp1);
        allRecords.addAll(exp2);


        req.setAttribute("action", "Compare Experiments");

        req.setAttribute("studies",studiesList);
        req.setAttribute("expRecord1",expr1);
        req.setAttribute("expRecord2",expr2);
        req.setAttribute("exp1",e1);
        req.setAttribute("exp2",e2);

        req.setAttribute("page", "/WEB-INF/jsp/tools/compareExperiments");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        return null;
    }

    @RequestMapping(value="/experiment/{experimentId}")
    public String getExperimentsByExperimentId(HttpServletRequest req, HttpServletResponse res,
                                               @PathVariable(required = true) long experimentId
    ) throws Exception {

        String resultType = req.getParameter("resultType");
        String tissue = req.getParameter("tissue");
        String cellType = req.getParameter("cellType");

        Person p=userService.getCurrentUser(req.getSession());

        if(!access.isLoggedIn()) {
            return "redirect:/";
        }
        List<ExperimentRecord> records = edao.getExperimentRecords(experimentId);
        Experiment e = edao.getExperiment(experimentId);

        if (records.size() == 0 ) {
            Study localStudy=sdao.getStudyByExperimentId(experimentId).get(0);

            req.setAttribute("study",localStudy);
            req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a> / <a href='/toolkit/data/search/results/Experiment?searchTerm='>Experiments</a> / <a href='/toolkit/data/experiments/group/" + localStudy.getGroupId() + "'>Experiments</a>");
            req.setAttribute("page", "/WEB-INF/jsp/tools/experimentRecords");
            req.setAttribute("deliveryAssay",new HashMap<String,String>());
            req.setAttribute("editingAssay",new HashMap<String,String>());
            req.setAttribute("experiment",e);
            req.setAttribute("experimentRecordsMap",new HashMap<Long, ExperimentRecord>());

            ProtocolDao pdao = new ProtocolDao();
            List<Protocol> protocols = pdao.getProtocolsForObject(experimentId);
            req.setAttribute("protocols", protocols);

            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            return null;
        }

        List<String> tissues = edao.getExperimentRecordTissueList(experimentId);

        ProtocolDao pdao = new ProtocolDao();
        List<Protocol> protocols = pdao.getProtocolsForObject(experimentId);
        req.setAttribute("protocols", protocols);


        Study study = sdao.getStudyById(records.get(0).getStudyId()).get(0);
        GrantDao grantDao=new GrantDao();
        Grant grant=grantDao.getGrantByGroupId(study.getGroupId());
       Map<String, Integer> objectSizeMap=customLabels.getObjectSizeMap(records);
        if (!access.hasStudyAccess(study,p)) {
            req.setAttribute("page", "/WEB-INF/jsp/error");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            return null;

        }
       List<String> uniqueFields=customLabels.getLabelFields(records, objectSizeMap, grant.getGrantInitiative());
   //     System.out.print("UNIQUE FIELDS:"+ uniqueFields.toString());
        List<String> labels=new ArrayList<>();
        Map<String, List<Double>> plotData=new HashMap<>();
        HashMap<Integer,List<Integer>> replicateResult = new HashMap<>();
        List mean = new ArrayList<>();
        HashMap<Long,Double> resultMap = new HashMap<>();
        TreeMap<Long,List<ExperimentResultDetail>> resultDetail = new TreeMap<>();
        String efficiency = null;
        int i=0;
        List values = new ArrayList<>();
        List<String> resultTypes = dbService.getResultTypes(experimentId);
        HashMap<Long,List<Guide>> guideMap = new HashMap<>();
        HashMap<Long,List<Vector>> vectorMap = new HashMap<>();
        LinkedHashSet<String> conditions=new LinkedHashSet<>();
        List<ExperimentResultDetail> experimentResults = dbService.getExpResultsByExpId(experimentId);
        LinkedHashMap<Long,List<ExperimentResultDetail>> experimentResultsMap = new LinkedHashMap<>();
        String editingAssay = null,deliveryAssay=null;

        HashMap<String, String> deliveryMap = new HashMap<String,String>();
        HashMap<String, String> editingMap = new HashMap<String,String>();

        for(ExperimentResultDetail er:experimentResults){

            if(experimentResultsMap != null && experimentResultsMap.containsKey(er.getResultId())) {
                values = experimentResultsMap.get(er.getResultId());
            } else {
                values = new ArrayList<>();
            }

            values.add(er);


            if(er.getResultType().contains("Delivery")) {
                //deliveryAssay += " -- " + er.getAssayDescription();
                deliveryMap.put(er.getAssayDescription(),null);
            } else {
                editingMap.put(er.getAssayDescription(),null);
                //editingAssay += " -- " + er.getAssayDescription();
            }
            experimentResultsMap.put(er.getResultId(),values);
        }
        HashMap<Long,ExperimentRecord> recordMap = new HashMap<>();

        for(ExperimentRecord rec:records) {
            recordMap.put(rec.getExperimentRecordId(), rec);
        }

        for (Long resultId : experimentResultsMap.keySet()) {
            List<ExperimentResultDetail> erdList=experimentResultsMap.get(resultId); //multiple replicate values for each result
            resultDetail.put(resultId, erdList);
            long expRecId = experimentResultsMap.get(resultId).get(0).getExperimentRecordId();
            guideMap.put(expRecId, dbService.getGuidesByExpRecId(expRecId));
            vectorMap.put(expRecId, dbService.getVectorsByExpRecId(expRecId));
            String labelTrimmed=new String();
            ExperimentRecord record = recordMap.get(expRecId);
            List<String> modifiedLabels = uniqueFields;
            if(uniqueFields.contains("guide") && (objectSizeMap.get("guide") == guideMap.get(expRecId).size())) {
                modifiedLabels.remove("guide");
            }
            if(uniqueFields.contains("vector") && (objectSizeMap.get("vector") == vectorMap.get(expRecId).size()))
                modifiedLabels.remove("vector");
                StringBuilder label = (customLabels.getLabel(record, grant.getGrantInitiative(),objectSizeMap, modifiedLabels,resultId));

                if(tissue!=null && !tissue.equals("") || tissues.size()>0) {
                    if(record.getCellTypeTerm()!=null && record.getTissueTerm()!=null)
                        labelTrimmed= label.toString().replace(record.getTissueTerm(), "").replace(record.getCellTypeTerm(),"");
                    else if(record.getTissueTerm()!=null)
                        labelTrimmed= label.toString().replace(record.getTissueTerm(), "");
                    else labelTrimmed= label.toString();

                    //if (record.getCondition() != null) {
                    record.setCondition(record.getExperimentRecordName());
                    conditions.add(record.getExperimentRecordName());
                    //}else {

                    //record.setCondition(labelTrimmed);
                    //conditions.add(labelTrimmed.trim());
                }

            labels.add("\"" + record.getExperimentName() + "\"");
            record.setExperimentName(record.getExperimentName());
                double average = 0;

                for (ExperimentResultDetail result : experimentResultsMap.get(resultId)) {
                    if(resultType == null || result.getResultType().contains(resultType)) {
                        if (!result.getUnits().equalsIgnoreCase("signal")) {

                            efficiency = "\"" + result.getResultType() + " in " + result.getUnits() + "\"";
                            if (result.getReplicate() != 0) {
                                values = replicateResult.get(result.getReplicate());
                                if (values == null)
                                    values = new ArrayList<>();
                                if (result.getResult() == null || result.getResult().isEmpty())
                                    values.add(null);
                                else {
                                    values.add(Math.round(Double.valueOf(result.getResult()) * 100) / 100.0);
                                }

                                replicateResult.put(result.getReplicate(), values);
                            } else average = Double.valueOf(result.getResult());

                            mean.add(average);
                            resultMap.put(resultId, average);
                        }
                    }
            }
        }
        req.setAttribute("associatedPublications", publicationDAO.getAssociatedPublications(experimentId));
        req.setAttribute("relatedPublications", publicationDAO.getRelatedPublications(experimentId));

        plotData.put("Mean",mean);

        req.setAttribute("tissues",tissues);
        req.setAttribute("conditions",conditions);
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a> / <a href='/toolkit/data/search/results/Experiment?searchTerm='>Experiments</a> / <a href='/toolkit/data/experiments/group/" + study.getGroupId() + "'>Experiments</a>");
        req.setAttribute("replicateResult",replicateResult);
        req.setAttribute("experiments",labels);
        req.setAttribute("plotData",plotData);
        req.setAttribute("efficiency",efficiency);
        req.setAttribute("experimentRecordsMap", recordMap);
        req.setAttribute("resultDetail",resultDetail);
        req.setAttribute("resultMap",resultMap);
        req.setAttribute("study", study);
        req.setAttribute("experiment",e);
        req.setAttribute("guideMap",guideMap);
        req.setAttribute("vectorMap",vectorMap);
        req.setAttribute("resultType",resultType);
        req.setAttribute("tissue",tissue);
        req.setAttribute("cellType",cellType);
        //req.setAttribute("deliveryAssay",deliveryAssay);
        //req.setAttribute("editingAssay",editingAssay);
        req.setAttribute("deliveryAssay",deliveryMap);
        req.setAttribute("editingAssay",editingMap);
        req.setAttribute("action", "Experiment: " + e.getName());
        req.setAttribute("page", "/WEB-INF/jsp/tools/experimentRecords");
        req.setAttribute("objectSizeMap", objectSizeMap);
        req.setAttribute("uniqueFields", uniqueFields);
        req.setAttribute("seoDescription",e.getDescription());
        req.setAttribute("seoTitle",e.getName());
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

    @RequestMapping(value="/experiment/{experimentId}/record/{expRecordId}")
    public String getExperimentRecords(HttpServletRequest req, HttpServletResponse res,
                                       @PathVariable(required = false) long experimentId,
                                       @PathVariable(required = false) long expRecordId) throws Exception {
        Person p = userService.getCurrentUser(req.getSession());

        if (!access.isLoggedIn()) {
            return "redirect:/";
        }
        Experiment experiment = edao.getExperiment(experimentId);
        List<ExperimentRecord> records = edao.getExperimentRecords(experimentId);
        Study study = sdao.getStudyById(records.get(0).getStudyId()).get(0);
        Set<String> unitList = new TreeSet<>();
        if (!access.hasStudyAccess(study, p)) {
            req.setAttribute("page", "/WEB-INF/jsp/error");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            return null;

        }

        ProtocolDao pdao = new ProtocolDao();
        List<Protocol> protocols = pdao.getProtocolsForObject(expRecordId);
        req.setAttribute("protocols", protocols);
        AntibodyDao adao = new AntibodyDao();
        List<Antibody> antibodyList = adao.getAntibodysByExpRecId(expRecordId);
        req.setAttribute("antibodyList",antibodyList);

        req.setAttribute("experimentRecords", records);
        ExperimentRecord r = new ExperimentRecord();
        if (records.size() > 0) {
            for(ExperimentRecord record: records)
                if(record.getExperimentRecordId() == expRecordId)
                    r = record;
            edu.mcw.scge.datamodel.Model m = dbService.getModelById(r.getModelId());
            //List<ReporterElement> reporterElements = dbService.getReporterElementsByExpRecId(r.getExperimentRecordId());
            //List<AnimalTestingResultsSummary> results = dbService.getAnimalTestingResultsByExpRecId(r.getExperimentRecordId());
            List<ExperimentResultDetail> experimentResultList = dbService.getExperimentalResults(r.getExperimentRecordId());
            List<ExperimentResultDetail> experimentResults=new ArrayList<>();
            for(ExperimentResultDetail e: experimentResultList){
                if(e.getResult() != null && !e.getResult().equals("") && !e.getResult().equals("NaN")) {
                    experimentResults.add(e);
                    unitList.add(e.getUnits());
                }
            }
           /* for (AnimalTestingResultsSummary s : results) {
                List<Sample> samples = dbService.getSampleDetails(s.getSummaryResultsId(), s.getExpRecId());
                s.setSamples(samples);
            }
            */
            List<Delivery> deliveryList = dbService.getDeliveryVehicles(r.getDeliverySystemId());
            List<Editor> editorList = dbService.getEditors(r.getEditorId());
            List<Guide> guideList = dbService.getGuidesByExpRecId(r.getExperimentRecordId());
            List<Vector> vectorList = dbService.getVectorsByExpRecId(r.getExperimentRecordId());
            List<ApplicationMethod> applicationMethod = dbService.getApplicationMethodsById(r.getApplicationMethodId());


            req.setAttribute("applicationMethod", applicationMethod);
            req.setAttribute("deliveryList", deliveryList);
            req.setAttribute("editorList",editorList);
            req.setAttribute("guideList",guideList);
            req.setAttribute("vectorList",vectorList);
            req.setAttribute("unitList",unitList);
            req.setAttribute("experiment",experiment);
            req.setAttribute("experimentRecord", r);
            req.setAttribute("model", m);
           // req.setAttribute("reporterElements", reporterElements);
            req.setAttribute("experimentResults",experimentResults);
            //req.setAttribute("results", results);
            System.out.println("Applications: "+ applicationMethod.size()+
                    "\ndelivery lsit: "+deliveryList.size()+
            "\nexperimentRecords: "+records.size()+
            "\nmodel:" +m.getName()+
                    "\nresults:"+experimentResults.size());

        }
        List<Publication> associatedPublications=new ArrayList<>();
        associatedPublications.addAll(publicationDAO.getAssociatedPublications(experiment.getExperimentId()));
        associatedPublications.addAll(publicationDAO.getAssociatedPublications(r.getEditorId()));
        associatedPublications.addAll(publicationDAO.getAssociatedPublications(r.getHrdonorId()));

        associatedPublications.addAll(publicationDAO.getAssociatedPublications(r.getModelId()));
        associatedPublications.addAll(publicationDAO.getAssociatedPublications(r.getDeliverySystemId()));
        List<Guide> guides=guideDao.getGuidesByExpRecId(r.getExperimentRecordId());
        if(guides.size()>0){
            for(Guide g:guides){
                associatedPublications.addAll(publicationDAO.getAssociatedPublications(g.getGuide_id()));

            }
        }
        List<Vector> vectors=vectorDao.getVectorsByExpRecId(expRecordId);
        if(vectors.size()>0){
            for(Vector vector:vectors)
            associatedPublications.addAll(publicationDAO.getAssociatedPublications(vector.getVectorId()));

        }

        req.setAttribute("associatedPublications", associatedPublications);
        req.setAttribute("relatedPublications", publicationDAO.getRelatedPublications(experiment.getExperimentId()));

        req.setAttribute("action", "Experiment Record Detail");
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a> / <a href='/toolkit/data/search/results/Experiment?searchTerm='>Experiments</a> / <a href='/toolkit/data/experiments/experiment/" + experiment.getExperimentId() + "'>Experiment</a>");

        req.setAttribute("seoDescription",r.getCondition());
        req.setAttribute("seoTitle",r.getExperimentName());
        req.setAttribute("study", study);
        req.setAttribute("page", "/WEB-INF/jsp/tools/experiment");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        return null;
    }
    @RequestMapping(value="/update/experiment/{experimentId}")
    public String updateTargetTissue(HttpServletRequest req, HttpServletResponse res,
                                       @PathVariable(required = false) long experimentId) throws Exception {
        Person p = userService.getCurrentUser(req.getSession());
        long expRecordId=0;
        if (!access.isLoggedIn()) {
            return "redirect:/";
        }
       String experimentRecordIdString=req.getParameter("experimentRecordIds");
        if(experimentRecordIdString!=null) {
            String[] experimentRecordIds = experimentRecordIdString.split(",");
            if (experimentRecordIds.length > 0){
                List<Long> erIds = Arrays.stream(experimentRecordIds).filter(id-> !id.equals("")).map(id -> Long.valueOf(id)).collect(Collectors.toList());
                erDao.updateTargetTissue(experimentId, erIds);
        }
        }
        System.out.println("EXPERIMENTID:"+ experimentId);
        System.out.println("Experiment REcord IDS:"+ req.getParameter("experimentRecordIds"));

        return "redirect:/data/experiments/experiment/"+experimentId;
    }

    @RequestMapping(value = "/edit")
    public String getExperimentForm(HttpServletRequest req, HttpServletResponse res,Experiment experiment) throws Exception{

        UserService userService = new UserService();
        Person p=userService.getCurrentUser(req.getSession());
        edu.mcw.scge.configuration.Access access = new Access();

        if(!access.isLoggedIn()) {
            return "redirect:/";
        }

        if (!access.isAdmin(p)) {
            req.setAttribute("page", "/WEB-INF/jsp/error");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            return null;

        }
            Experiment e = new Experiment();
            e.setStudyId(Integer.parseInt(req.getParameter("studyId")));
            req.setAttribute("experiment", e);
            req.setAttribute("action", "Create Experiment");


        List<Experiment> records = edao.getAllExperiments();
        Set<String> names = records.stream().map(Experiment::getName).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> types = records.stream().map(Experiment::getType).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());

        req.setAttribute("names",names);
        req.setAttribute("types",types);

        req.setAttribute("page", "/WEB-INF/jsp/edit/editExperiment");
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a> / <a href='/toolkit/data/search/results/Study?searchTerm='>Studies</a>");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

    @RequestMapping("/create")
    public String createExperiment(HttpServletRequest req,HttpServletResponse res,@ModelAttribute("experiment") Experiment experiment) throws Exception {

        UserService userService = new UserService();
        Person p=userService.getCurrentUser(req.getSession());
        edu.mcw.scge.configuration.Access access = new Access();

        if(!access.isLoggedIn()) {
            return "redirect:/";
        }

        if (!access.isAdmin(p)) {
            req.setAttribute("page", "/WEB-INF/jsp/error");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            return null;

        }
        long experimentId = edao.insertExperiment(experiment);
        req.setAttribute("status"," <span style=\"color: blue\">Experiment inserted successfully</span>");

        int studyId = experiment.getStudyId();
        Study study = sdao.getStudyById(studyId).get(0);
        int groupId = study.getGroupId();
        req.getRequestDispatcher("/data/experiments/group/"+groupId).forward(req,res);
        return null;
    }

}
