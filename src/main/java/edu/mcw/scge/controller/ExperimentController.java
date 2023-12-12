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
import edu.mcw.scge.service.ProcessUtils;
import edu.mcw.scge.service.db.DBService;


import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.PathVariable;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
    ProtocolDao pdao = new ProtocolDao();

    ProcessUtils processUtils=new ProcessUtils();
    Gson gson=new Gson();
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
        String selectedStudy=req.getParameter("selectedStudy");
        if(selectedStudy!=null){
            int selectedStudyId=Integer.parseInt(selectedStudy);
         //   System.out.println("SELECTED STUDY:"+ selectedStudyId);
            req.setAttribute("selectedStudy", selectedStudyId);
        }

        if(!access.isLoggedIn()) {
            return "redirect:/";
        }
        if(studies.size()>0) {
            List<Publication> publications = getPublication(studies.get(0));
            req.setAttribute("publications", publications);
        }
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
        req.setAttribute("crumbtrail", "<a href='/toolkit/loginSuccess?destination=base'>Home</a> ");

        req.setAttribute("study", studies.get(0));
        Map<Long, List<Experiment>> experimentsValidatedMap=new HashMap<>();
        Map<Long, List<Experiment>> validationExperimentsMap=new HashMap<>();
        if(studies.get(0).getIsValidationStudy()==1)
        experimentsValidatedMap=getExperimentsValidated(studies,p);
        else
        validationExperimentsMap=getValidations(studies,p);
        req.setAttribute("experimentsValidatedMap" , experimentsValidatedMap);
        req.setAttribute("validationExperimentsMap",validationExperimentsMap);
        req.setAttribute("studyExperimentMap", studyExperimentMap);
        req.setAttribute("action","Project: " + grantDao.getGrantByGroupId (studies.get(0).getGroupId()).getGrantTitle());
        req.setAttribute("projectDescription", grantDao.getGrantByGroupId (studies.get(0).getGroupId()).getDescription());
        req.setAttribute("grantNumber", grantDao.getGrantByGroupId (studies.get(0).getGroupId()).getGrantNumber());
        req.setAttribute("nihReporterLink", grantDao.getGrantByGroupId (studies.get(0).getGroupId()).getNihReporterLink());
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
       // System.out.println("EXPERIMENT IDS: "+ req.getParameter("experimentIds"));
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
        req.setAttribute("crumbtrail", "<a href='/toolkit/loginSuccess?destination=base'>Home</a> / <a href='/toolkit/data/search/results/Study/Experiment?searchTerm='>Projects</a>");

        req.setAttribute("study", studies.get(0));
        Map<Long, List<Experiment>> experimentsValidatedMap=new HashMap<>();
        Map<Long, List<Experiment>> validationExperimentsMap=new HashMap<>();
        if(studies.get(0).getIsValidationStudy()==1)
            experimentsValidatedMap=getExperimentsValidated(studies,p);
        else
            validationExperimentsMap=getValidations(studies,p);
        req.setAttribute("experimentsValidatedMap" , experimentsValidatedMap);
        req.setAttribute("validationExperimentsMap",validationExperimentsMap);
        req.setAttribute("studyExperimentMap", studyExperimentMap);
        req.setAttribute("action",grantDao.getGrantByGroupId (studies.get(0).getGroupId()).getGrantTitle());
        req.setAttribute("page", "/WEB-INF/jsp/tools/experiments");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
    public Map<Long, List<Experiment>> getValidations(List<Study> studies, Person p) throws Exception {
       Map<Long, List<Experiment>> validationExperimentsMap=new HashMap<>();

        for(Study study:studies) {
            if(access.hasStudyAccess(study, p)) {
                List<Experiment> experiments = edao.getExperimentsByStudy(study.getStudyId());

                for (Experiment e : experiments) {
                    List<Long> experimentIds = edao.getValidationExperiments(e.getExperimentId());
                    List<Experiment> validatedExperiments = new ArrayList<>();
                    for (long experimentId : experimentIds) {
                        Experiment experiment = edao.getExperiment(experimentId);
                        Study validationStudy=sdao.getStudyByStudyId(experiment.getStudyId());
                      //  System.out.println("validationStudy:" + validationStudy.getStudyId()+"\tTier:"+ validationStudy.getTier() +"\tAccess:"+ access.hasStudyAccess(validationStudy, p));
                        if(access.hasStudyAccess(validationStudy, p))
                        validatedExperiments.add(experiment);
                    }
                    if (validatedExperiments.size() > 0)
                        validationExperimentsMap.put(e.getExperimentId(), validatedExperiments);
                }
            }
       }
      //  System.out.println("Validations:"+ validationExperimentsMap.size());
        return validationExperimentsMap;
    }
    public Map<Long, List<Experiment>> getExperimentsValidated(List<Study> studies, Person p) throws Exception {
        Map<Long, List<Experiment>> experimentsValidatedMap=new HashMap<>();
        for(Study study:studies) {
            if(access.hasStudyAccess(study, p)) {
                List<Experiment> experiments = edao.getExperimentsByStudy(study.getStudyId());
                for (Experiment e : experiments) {
                    List<Long> experimentIds = edao.getExperimentsValidated(e.getExperimentId());
                    List<Experiment> validatedExperiments = new ArrayList<>();
                    for (long experimentId : experimentIds) {
                        Experiment experiment = edao.getExperiment(experimentId);
                        Study originalStudy=sdao.getStudyByStudyId(experiment.getStudyId());
                      //  System.out.println("originalStudy:" + originalStudy.getStudyId()+"\tTier:"+ originalStudy.getTier() +"\tAccess:"+ access.hasStudyAccess(originalStudy, p));

                        if(access.hasStudyAccess(originalStudy, p))
                        validatedExperiments.add(experiment);
                    }
                    if (validatedExperiments.size() > 0)
                        experimentsValidatedMap.put(e.getExperimentId(), validatedExperiments);
                }
            }

        }
     //   System.out.println("Experiments validated:"+ experimentsValidatedMap.size());

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
                StringBuffer sb=new StringBuffer();
                List<Person> studyPis=sdao.getStudyPi(sdao.getStudyById(s).get(0));
                for(Person pi:studyPis) {
                    String piname = pi.getName();
                    String label = piname.split(",")[0];
                    int index = label.lastIndexOf(" ");
                    label = label.substring(index);
                    sb.append(label);
                }
                studyNames.put(s,sb.toString());
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
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a> ");
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


    public Map<Integer, List<Double>> getReplicateData(List<ExperimentRecord> records, String resultType){
        Map<Integer, List<Double>> replicateResults=new HashMap<>();
        Set<Integer> replicatesSize=new HashSet<>();
       for(ExperimentRecord record:records){
           List<ExperimentResultDetail> filteredResultDetails=new ArrayList<>();
           for(ExperimentResultDetail rd: record.getResultDetails()){
               String resultTypeKey=processUtils.getResultKey(rd);
               if(resultTypeKey.equalsIgnoreCase(resultType)){
                   filteredResultDetails.add(rd);
               }
           }
           if(filteredResultDetails.size()>1)
           replicatesSize.add(filteredResultDetails.size()-1);
       }
    //    Set<Integer> replicatesSize=filteredRDRecords.stream().filter(r->r.getResultDetails().size()>1).map(r->r.getResultDetails().size()-1).collect(Collectors.toSet());

        int maxReplicates=replicatesSize.size()>0? Collections.max(replicatesSize):1;

        for (int i=1;i<=maxReplicates;i++) {
        for(ExperimentRecord record:records) {
            List<ExperimentResultDetail> resultDetails = record.getResultDetails();
            List<Double> replicateValues = new ArrayList<>();
            if (replicateResults.get(i) != null) {
                replicateValues.addAll(replicateResults.get(i));
            }
            if (resultDetails.size() > 1 && resultDetails.size() > i) { //verifying if replicate data available in addition to result mean.
                boolean repFlag=false;
                for (ExperimentResultDetail resultDetail : resultDetails) {
                        String resultKey=processUtils.getResultKey(resultDetail);
                    if (resultDetail.getReplicate() == i && resultType.equalsIgnoreCase(resultKey)) {
                     //   System.out.println("RESULT TYPE:"+resultType+"\tRESULT DETAIL UNITS:" + resultDetail.getUnits());
                        if(!resultDetail.getResult().equalsIgnoreCase("nan"))
                            try {
                                replicateValues.add(Double.valueOf(resultDetail.getResult()));
                            }catch (Exception e){
                            }
                        else
                            replicateValues.add(null);
                        repFlag=true;
                    }

                }
                if(!repFlag){
                    replicateValues.add(null);
                }
            }else
                replicateValues.add(null);
            replicateResults.put(i, replicateValues);
        }
        }
      //  System.out.println("REPLICATE RESULTS:"+gson.toJson(replicateResults));
        return replicateResults;
    }

    public  Map<String, List<String>> getTableColumns(List<ExperimentRecord> records){
        Map<String, List<String>> columnMap=new HashMap<>();
        for(ExperimentRecord record:records){
            if(record.getQualifier()!=null && !record.getQualifier().equals("")) {
               Set<String> qualifier= new TreeSet<>();
                if(columnMap.get("qualifier")!=null){
                    qualifier.addAll(columnMap.get("qualifier"));
                }
                qualifier.add(record.getQualifier());
                columnMap.put("qualifier", new ArrayList<>(qualifier));
            }
            if(record.getTimePoint()!=null && !record.getTimePoint().equals("")) {
                Set<String> timePoint= new TreeSet<>();
                if(columnMap.get("timePoint")!=null){
                    timePoint.addAll(columnMap.get("timePoint"));
                }
                timePoint.add(record.getTimePoint());
                columnMap.put("timePoint", new ArrayList<>(timePoint));
            }
            if(record.getTissueTerm()!=null && !record.getTissueTerm().equals("")) {
                Set<String> tissueTerm= new TreeSet<>();
                if(columnMap.get("tissueTerm")!=null){
                tissueTerm.addAll(columnMap.get("tissueTerm"));
                }
                tissueTerm.add(record.getTissueTerm());
                columnMap.put("tissueTerm", new ArrayList<>(tissueTerm));
            }
            if(record.getCellTypeTerm()!=null && !record.getCellTypeTerm().equals("") && !record.getCellTypeTerm().equals("unspecified"))
            {
                Set<String> cellTypeTerm= new TreeSet<>();
                if(columnMap.get("cellTypeTerm")!=null){
                    cellTypeTerm.addAll(columnMap.get("cellTypeTerm"));
                }
                cellTypeTerm.add(record.getCellTypeTerm());
                columnMap.put("cellTypeTerm",new ArrayList<>( cellTypeTerm));
            }
        //    System.out.println("MODEL DISPLAY NAME:"+ record.getModelDisplayName()+"\nMODEL NAME:"+ record.getModelName()+"\nMODEL ID:"+record.getModelId());
            if(record.getModelDisplayName()!=null && !record.getModelDisplayName().equals(""))
            {
                Set<String> modelDisplayName= new TreeSet<>();
                if(columnMap.get("modelDisplayName")!=null){
                    modelDisplayName.addAll(columnMap.get("modelDisplayName"));
                }
                modelDisplayName.add(record.getModelDisplayName());
                columnMap.put("modelDisplayName", new ArrayList<>( modelDisplayName));
            }else{
                if(record.getModelName()!=null && !record.getModelName().equals("")){
                    Set<String> modelDisplayName= new TreeSet<>();
                    if(columnMap.get("modelDisplayName")!=null){
                        modelDisplayName.addAll(columnMap.get("modelDisplayName"));
                    }
                    modelDisplayName.add(record.getModelName());
                    columnMap.put("modelDisplayName", new ArrayList<>( modelDisplayName));
                }
            }

            if(record.getAge()!=null && !record.getAge().equals(""))
            {
               Set<String> age= new TreeSet<>();
                if(columnMap.get("age")!=null){
                    age.addAll(columnMap.get("age"));
                }
                age.add(record.getAge());
                columnMap.put("age", (List<String>) age);
            }
            if(record.getSex()!=null && !record.getSex().equals(""))
            {
                Set<String> sex= new TreeSet<>();
                if(columnMap.get("sex")!=null){
                    sex.addAll(columnMap.get("sex"));
                }
                sex.add(record.getSex());
                columnMap.put("sex", new ArrayList<>( sex));
            }

            if(record.getEditorSymbol()!=null && !record.getEditorSymbol().equals(""))
            { Set<String> editorSymbol= new TreeSet<>();
                if(columnMap.get("editorSymbol")!=null){
                    editorSymbol.addAll(columnMap.get("editorSymbol"));
                }
                editorSymbol.add(record.getEditorSymbol());
                columnMap.put("editorSymbol", new ArrayList<>(editorSymbol));
            }
            if(record.getDeliverySystemName()!=null && !record.getDeliverySystemName().equals(""))
            {
                Set<String> deliverySystemName= new TreeSet<>();
                if(columnMap.get("deliverySystemName")!=null){
                    deliverySystemName.addAll(columnMap.get("deliverySystemName"));
                }
                deliverySystemName.add(record.getDeliverySystemName());
                columnMap.put("deliverySystemName", new ArrayList<>(deliverySystemName));
            }
            if(record.getGuides()!=null && record.getGuides().size()>0)
            {
                Set<String> guide= new TreeSet<>();
                if(columnMap.get("guide")!=null){
                    guide.addAll(columnMap.get("guide"));
                }
                guide.addAll(record.getGuides().stream().map(Guide::getGuide).filter(Objects::nonNull).collect(Collectors.toSet()));
                columnMap.put("guide", new ArrayList<>( guide));
            }
            if(record.getGuides()!=null && record.getGuides().size()>0){
               List<String> targetLocus= record.getGuides().stream().map(Guide::getTargetLocus).filter(Objects::nonNull).collect(Collectors.toList());
               if(targetLocus.size()>0){

                  Set<String> targetLocusSet= new TreeSet<>();
                   if(columnMap.get("targetLocus")!=null){
                       targetLocusSet.addAll(columnMap.get("targetLocus"));
                   }
                  Set<String> targetLoci= record.getGuides().stream().filter(Objects::nonNull).map(Guide::getTargetLocus).filter(Objects::nonNull).collect(Collectors.toSet());
                  if( targetLoci.size()>0)
                   targetLocusSet.addAll(targetLoci);
                   columnMap.put("targetLocus", new ArrayList<>( targetLocusSet));
               }
            }

            if(record.getVectors()!=null && record.getVectors().size()>0)
            {
                Set<String> vector= new TreeSet<>();
                if(columnMap.get("vector")!=null){
                    vector.addAll(columnMap.get("vector"));
                }
                vector.addAll(record.getVectors().stream().map(Vector::getName).filter(Objects::nonNull).collect(Collectors.toSet()));
                columnMap.put("vector", new ArrayList<>( vector));
            }
            if(record.getHrDonors()!=null && record.getHrDonors().size()>0)
            {
               Set<String> hrDonor= new TreeSet<>();
                if(columnMap.get("hrDonor")!=null){
                    hrDonor.addAll(columnMap.get("hrDonor"));
                }
                hrDonor.addAll(record.getHrDonors().stream().map(h->String.valueOf(h.getId())).collect(Collectors.toSet()));
                columnMap.put("hrDonor", new ArrayList<>(hrDonor));
            }
            if(record.getDosage()!=null && !record.getDosage().equals(""))
            {
                Set<String> dosage= new TreeSet<>();
                if(columnMap.get("dosage")!=null){
                    dosage.addAll(columnMap.get("dosage"));
                }
                dosage.add(record.getDosage());
                columnMap.put("dosage", new ArrayList<>(dosage));
            }
            if(record.getInjectionFrequency()!=null && !record.getInjectionFrequency().equals("")) {
              Set<String> injectionFrequency= new TreeSet<>();
                if(columnMap.get("injectionFrequency")!=null){
                    injectionFrequency.addAll(columnMap.get("injectionFrequency"));
                }
                injectionFrequency.add(record.getInjectionFrequency());
                columnMap.put("injectionFrequency", (new ArrayList<>(injectionFrequency)));

            }
            if(record.getResultDetails()!=null && record.getResultDetails().size()>0)
            {
               Set<String> units= new TreeSet<>();
                if(columnMap.get("units")!=null){
                    units.addAll(columnMap.get("units"));
                }
                units.addAll(record.getResultDetails().stream().map(ExperimentResultDetail::getUnits).collect(Collectors.toSet()));
                columnMap.put("units", new ArrayList<>( units));
            }

        }
        return columnMap;
    }
    public  List<Plot> getPlotData(Map<String, List<ExperimentRecord>> resultTypeRecords){
        List<Plot> plots=new ArrayList<>();
        for(Map.Entry entry:resultTypeRecords.entrySet()) {
            String resultType = (String) entry.getKey();
            List<ExperimentRecord> records = (List<ExperimentRecord>) entry.getValue();
            boolean signalType = false;
            for (ExperimentRecord record : records) {
                for (ExperimentResultDetail detail : record.getResultDetails()) {
                    if (detail.getReplicate() == 0 && processUtils.getResultKey(detail).equalsIgnoreCase(resultType)) {
                        try {
                            Double d = Double.parseDouble(detail.getResult().trim());
                        } catch (Exception e) {
                            signalType = true;
                            break;
                        }
                    }
                }
            }
            Set<String> tissues = records.stream().map(ExperimentRecord::getTissueTerm).filter(Objects::nonNull).collect(Collectors.toSet());
            String tissue = null;
            if (tissues.size() > 0)
                tissue = String.join(", ", tissues);
            if (!signalType){
                if (!resultType.toLowerCase().contains("signal") || resultType.toLowerCase().contains("signal detection")) {
                    Plot plot = new Plot();
                    plot.setXaxisLabel(resultType);
                    plot.setTitle(resultType);
                    if (resultType.toLowerCase().contains("delivery")) {
                        plot.setTitleColor("blue");
                    } else if (resultType.toLowerCase().contains("editing")) {
                        plot.setTitleColor("orange");
                    } else plot.setTitleColor("darkgray");
                    plot.setReplicateResult((HashMap<Integer, List<Double>>) getReplicateData(records, resultType));
                    for (ExperimentRecord record : records) {
                        // plot.setYaxisLabel(records.get(0).getResultDetails().get(0).getUnits());
                        for (ExperimentResultDetail rd : record.getResultDetails()) {
                            String yaxisLabel = new String();
                            if (resultType.equalsIgnoreCase(processUtils.getResultKey(rd)) && rd.getReplicate() == 0) {
                                String[] tokens = rd.getUnits().split(",");

                                yaxisLabel = Arrays.stream(tokens).map(t -> "'" + t + "'").collect(Collectors.joining(","));
                                plot.setYaxisLabel(yaxisLabel);
                            }
                        }
                    }
                    List<String> labels = new ArrayList<>();
                    List<Long> recordIds = new ArrayList<>();
                    Map<String, List<Double>> plotData = new HashMap<>();
                    List<Double> values = new ArrayList<>();
                    for (ExperimentRecord record : records) {
                        StringBuilder experimentRecordName = new StringBuilder();
                        experimentRecordName.append(record.getExperimentRecordName());
                        if ((record.getTissueTerm() != null && !record.getTissueTerm().equalsIgnoreCase("unspecified") && !record.getTissueTerm().equals(""))
                                || (record.getQualifier() != null && !record.getQualifier().equals(""))) {
                            experimentRecordName.append(" (");
                        }
                        if (record.getQualifier() != null && !record.getQualifier().equals("")) {
                            experimentRecordName.append(record.getQualifier()).append("_");
                        }
                        if (record.getTissueTerm() != null && !record.getTissueTerm().equalsIgnoreCase("unspecified") && !record.getTissueTerm().equals("")) {
                            experimentRecordName.append(record.getTissueTerm());
                        }
                        if (record.getCellTypeTerm() != null && !record.getCellTypeTerm().equalsIgnoreCase("unspecified") && !record.getCellTypeTerm().equals("")) {
                            experimentRecordName.append("/").append(record.getCellTypeTerm());
                        }

                        if (record.getTimePoint() != null && !record.getTimePoint().equals("")) {
                            experimentRecordName.append("/").append(record.getTimePoint());
                        }
                        if (record.getTissueTerm() != null && !record.getTissueTerm().equalsIgnoreCase("unspecified") && !record.getTissueTerm().equals("")
                                || (record.getQualifier() != null && !record.getQualifier().equals(""))) {
                            experimentRecordName.append(")");
                        }
                        // record.setExperimentRecordName(experimentRecordName.toString());
                        labels.add(experimentRecordName.toString());
                        recordIds.add(record.getExperimentRecordId());
                        //  values.add(Double.parseDouble(record.getResultDetails().stream().filter(r->r.getReplicate()==0 && resultType.contains(r.getUnits())).collect(Collectors.toList()).get(0).getResult()));

                        for (ExperimentResultDetail rd : record.getResultDetails()) {
                            if (resultType.equalsIgnoreCase(processUtils.getResultKey(rd)) && rd.getReplicate() == 0) {
                                values.add(Double.valueOf(rd.getResult()));
                            }
                        }
                    }
                    plotData.put(resultType, values);
                    plot.setTickLabels(labels);
                    plot.setRecordIds(recordIds);
                    plot.setPlotData(plotData);
                    plots.add(plot);
                }
        }
        }
      //  System.out.println("PLOTS SIZE:" +plots.size());
      //  System.out.println("PLOTS JSON:" +gson.toJson(plots));
        return plots;
    }


    public Map<String, List<ExperimentRecord>> getSegregatedRecords(List<ExperimentRecord> records,Map<String, Integer> resultTypeColumnCount){
        LinkedHashMap<String, List<ExperimentRecord>> resultTypes=new LinkedHashMap<>();
        LinkedHashMap<String, List<ExperimentRecord>> resultTypesSorted=new LinkedHashMap<>();
        for(ExperimentRecord er:records){
            if(er.getResultDetails()!=null && er.getResultDetails().get(0)!=null) {
                for (ExperimentResultDetail erd : er.getResultDetails()) {
                    String resultType = processUtils.getResultKey(erd);
                    List<ExperimentRecord> segregatedRecords = new ArrayList<>();

                    if (resultTypes.get(resultType) != null) {
                        segregatedRecords.addAll(resultTypes.get(resultType));

                    }
                    boolean found=false;
                    for(ExperimentRecord r:segregatedRecords){
                        if(r.getExperimentRecordId()==er.getExperimentRecordId()){
                            found=true;
                        }
                    }
                    if(!found) {

                        segregatedRecords.add(er);
                    }
                    resultTypes.put(resultType, segregatedRecords);
                }
            }
        }
        for(String key:resultTypes.keySet()){
            if(key.toLowerCase().contains("editing efficiency")){
                resultTypesSorted.put(key, resultTypes.get(key));
                int count=1;
                if(resultTypeColumnCount.get("editing efficiency")!=null){
                    count=count+(Integer)resultTypeColumnCount.get("editing efficiency");
                }
                resultTypeColumnCount.put("editing efficiency", count);
            }

        }
        for(String key:resultTypes.keySet()){
            if(key.toLowerCase().contains("delivery efficiency")){
                resultTypesSorted.put(key, resultTypes.get(key));
                int count=1;
                if(resultTypeColumnCount.get("delivery efficiency")!=null){
                    count=count+(Integer)resultTypeColumnCount.get("delivery efficiency");
                }
                resultTypeColumnCount.put("delivery efficiency", count);
            }
        }
        for(String key:resultTypes.keySet()){
            if(!key.toLowerCase().contains("efficiency")){
                resultTypesSorted.put(key, resultTypes.get(key));
                int count=1;
                if(resultTypeColumnCount.get("other")!=null){
                    count=count+(Integer)resultTypeColumnCount.get("other");
                }
                resultTypeColumnCount.put("other", count);
            }
        }
      //  System.out.println("RESULT TYPE COUNT MAP:"+ gson.toJson(resultTypeColumnCount));
      //  System.out.println("SEGREGATED Sorted RECORDS:"+ gson.toJson(resultTypes));

        return resultTypesSorted;
    }
      @RequestMapping(value="/experiment/{experimentId}")
    public String getExperimentsByExperimentId(HttpServletRequest req, HttpServletResponse res, @PathVariable(required = true) long experimentId) throws Exception {

        String resultType = req.getParameter("resultType");
        String tissue = req.getParameter("tissue");
        String cellType = req.getParameter("cellType");

        Person p=userService.getCurrentUser(req.getSession());
        if(!access.isLoggedIn()) {
            return "redirect:/";
        }
        Experiment e = edao.getExperiment(experimentId);
        List<Study> studies=sdao.getStudyByExperimentId(experimentId);
        Study localStudy=studies.size()>0?studies.get(0):null;
        if(localStudy==null)
              return "redirect:/";
        if (!access.hasStudyAccess(localStudy,p)) {
              req.setAttribute("page", "/WEB-INF/jsp/error");
              req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
              return null;

        }
        List<ExperimentRecord> records = edao.getExperimentRecords(experimentId);
        if (records.size() == 0 ) {

            req.setAttribute("study",localStudy);
            req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a>  / <a href='/toolkit/data/experiments/group/" + localStudy.getGroupId() + "'>Project</a>");
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
        LinkedHashSet<String> conditions=new LinkedHashSet<>();
        List<String> tissues = edao.getExperimentRecordTissueList(experimentId);
        List<String> tissuesTarget = edao.getExperimentRecordTargetTissueList(experimentId);
        List<String> tissuesNonTargetTmp = edao.getExperimentRecordNonTargetTissueList(experimentId);
        List<String> tissuesNonTarget=new ArrayList<>();
        if(tissuesNonTargetTmp.size()>0)
        for(String t:tissuesNonTargetTmp){
            boolean exists=false;
            for(String target:tissuesTarget){
                if (t.equalsIgnoreCase(target)) {

                    exists=true;
                }
            }
            if(!exists){
                tissuesNonTarget.add(t);
            }
        }
          //update experiment name...append tissue and cell type if available
          for(ExperimentRecord record:records){
              if (tissue != null && !tissue.equals("") || tissues.size() > 0) {
                  record.setCondition(record.getExperimentRecordName());
                  conditions.add(record.getExperimentRecordName());
              }

          }

        List<Protocol> protocols = pdao.getProtocolsForObject(experimentId);
        req.setAttribute("protocols", protocols);
        Grant grant=grantDao.getGrantByGroupId(localStudy.getGroupId());


        List<String> resultTypesList = dbService.getResultTypes(experimentId);
        Set<String> resultTypesSet=new HashSet<>(resultTypesList);
        Map<String, List<String>> resultTypeNUnits=dbService.getResultTypeNUnits(experimentId);
        req.setAttribute("resultTypesSet", resultTypesSet);
        req.setAttribute("resultTypeNUnits", resultTypeNUnits);

        HashMap<Long,List<Guide>> guideMap = new HashMap<>();
        HashMap<Long,List<Vector>> vectorMap = new HashMap<>();

        LinkedHashMap<Long,List<ExperimentResultDetail>> experimentResultsMap = new LinkedHashMap<>();
        HashMap<String, String> deliveryMap = new HashMap<String,String>();
        HashMap<String, String> editingMap = new HashMap<String,String>();
          HashMap<String, String> biomarkerMap = new HashMap<String,String>();
        List<ExperimentResultDetail> experimentResults = dbService.getExpResultsByExpId(experimentId);
        for(ExperimentResultDetail er:experimentResults){
            if(er.getResultType().contains("Delivery")) {
                deliveryMap.put(er.getAssayDescription(),null);
            } else if (er.getResultType().contains("Editing")){
                editingMap.put(er.getAssayDescription(),null);
            }else{
                biomarkerMap.put(er.getAssayDescription(),null);
            }
        }


        for (ExperimentRecord record:records) {
            long expRecId = record.getExperimentRecordId();
            guideMap.put(expRecId, dbService.getGuidesByExpRecId(expRecId));
            vectorMap.put(expRecId, dbService.getVectorsByExpRecId(expRecId));

        }

        req.setAttribute("associatedPublications", publicationDAO.getAssociatedPublications(experimentId));
        req.setAttribute("relatedPublications", publicationDAO.getRelatedPublications(experimentId));

        Map<String, Integer> resultTypeColumnCount=new HashMap<>();
          Map<String, List<ExperimentRecord>> resultTypeRecords=getSegregatedRecords(records, resultTypeColumnCount);
          req.setAttribute("resultTypeColumnCount", resultTypeColumnCount);
          req.setAttribute("tableColumns", getTableColumns(records));
          req.setAttribute("plots", getPlotData(resultTypeRecords));
          req.setAttribute("resultTypeRecords", resultTypeRecords);
          req.setAttribute("records", records);


        req.setAttribute("tissues",tissues);
        req.setAttribute("tissuesTarget",tissuesTarget);
        req.setAttribute("tissuesNonTarget",tissuesNonTarget);
        req.setAttribute("conditions",conditions);
        if(tissues.size()>0 && (tissue!=null || (resultType!=null && resultType.equals("all")))){
            req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a>/ <a href='/toolkit/data/experiments/group/" + localStudy.getGroupId() + "'>Project</a> / <a href='/toolkit/data/experiments/experiment/"+experimentId + "'>Experiment Overview</a>");

        }else
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a>  / <a href='/toolkit/data/experiments/group/" + localStudy.getGroupId() + "'>Project</a>");

        req.setAttribute("study", localStudy);
        req.setAttribute("experiment",e);
        req.setAttribute("guideMap",guideMap);
        req.setAttribute("vectorMap",vectorMap);
        req.setAttribute("resultType",resultType);
        req.setAttribute("tissue",tissue);
        req.setAttribute("cellType",cellType);
        req.setAttribute("deliveryAssay",deliveryMap);
        req.setAttribute("editingAssay",editingMap);
        req.setAttribute("biomarkerAssay",biomarkerMap);
          Map<Long, List<Experiment>> experimentsValidatedMap=new HashMap<>();
          Map<Long, List<Experiment>> validationExperimentsMap=new HashMap<>();
        if(localStudy.getIsValidationStudy()==1) {
            experimentsValidatedMap=getExperimentsValidated(studies, p);
            req.setAttribute("action", "<span>Validation Experiment:</span> " + e.getName());
            req.setAttribute("experimentsValidatedMap" , experimentsValidatedMap);
        }
        else {
            validationExperimentsMap=getValidations(studies, p);
            req.setAttribute("action", "Experiment: " + e.getName());
            req.setAttribute("validationExperimentsMap",validationExperimentsMap);
        }

        req.setAttribute("page", "/WEB-INF/jsp/tools/experimentRecords");

        req.setAttribute("seoDescription",e.getDescription());
        req.setAttribute("seoTitle",e.getName());
        if(req.getParameter("viewAll")!=null)
        req.setAttribute("viewAll", req.getParameter("viewAll"));
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

        Map<String,String> otherExpRecDetails = erDao.getExperimentRecordDetails(expRecordId);
        if( !otherExpRecDetails.isEmpty() ) {
            req.setAttribute("otherExpRecDetails", otherExpRecDetails);
        }

        req.setAttribute("associatedPublications", associatedPublications);
        req.setAttribute("relatedPublications", publicationDAO.getRelatedPublications(experiment.getExperimentId()));

        req.setAttribute("action", "Experiment Record Detail");

        if (experiment.getType().equals("In Vitro")) {
            req.setAttribute("crumbtrail", "<a href='/toolkit/loginSuccess?destination=base'>Home</a> / <a href='/toolkit/data/experiments/group/" + study.getGroupId() + "'>Project</a> / <a href='/toolkit/data/experiments/experiment/" + experiment.getExperimentId() + "?resultType=all'>Experiment</a>");
        }else {
            req.setAttribute("crumbtrail", "<a href='/toolkit/loginSuccess?destination=base'>Home</a> / <a href='/toolkit/data/experiments/group/" + study.getGroupId() + "'>Project</a> /<a href='/toolkit/data/experiments/experiment/" + experiment.getExperimentId() + "'>Experiment Overview</a> / <a href='/toolkit/data/experiments/experiment/" + experiment.getExperimentId() + "?resultType=all'>Experiment</a>");
        }
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
     //   System.out.println("EXPERIMENTID:"+ experimentId);
     //   System.out.println("Experiment REcord IDS:"+ req.getParameter("experimentRecordIds"));

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
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a> ");
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
