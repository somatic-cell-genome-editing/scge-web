package edu.mcw.scge.controller;

import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.configuration.UserService;
import edu.mcw.scge.dao.implementation.*;
import edu.mcw.scge.datamodel.*;
import edu.mcw.scge.datamodel.Vector;
import edu.mcw.scge.datamodel.publications.Publication;
import edu.mcw.scge.service.db.DBService;
import edu.mcw.scge.storage.FileSystemStorageService;
import edu.mcw.scge.storage.FileUploadController;
import edu.mcw.scge.storage.StorageProperties;
import edu.mcw.scge.storage.StorageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.method.annotation.MvcUriComponentsBuilder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping(value="/data/vector")
public class VectorController extends ObjectController{
    VectorDao dao = new VectorDao();
    PublicationDAO publicationDAO=new PublicationDAO();

    private StorageService storageService;

    @Autowired
    public void FileUploadController(StorageService storageService) {
        this.storageService = storageService;
    }

    @RequestMapping(value="/search")
    public String getVectors(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {

        List<Vector> records= dao.getAllVectors();
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a>");
        req.setAttribute("vectors", records);
        req.setAttribute("action", "Vector/Format");
        req.setAttribute("page", "/WEB-INF/jsp/tools/vectors");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

    @RequestMapping(value="/format")
    public String getVector(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        Vector v= dao.getVectorById(Long.parseLong(req.getParameter("id"))).get(0);
        DBService dbService = new DBService();
        UserService userService = new UserService();
        Person p=userService.getCurrentUser(req.getSession());
        edu.mcw.scge.configuration.Access access = new Access();

        if(!access.isLoggedIn()) {
            return "redirect:/";
        }

        if (!access.hasVectorAccess(v,p)) {
            req.setAttribute("page", "/WEB-INF/jsp/error");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            return null;

        }


        StudyDao sdao = new StudyDao();
        List<Study> studies = sdao.getStudiesByVector(v.getVectorId());
        req.setAttribute("studies", studies);

        ProtocolDao pdao = new ProtocolDao();
        List<Protocol> protocols = pdao.getProtocolsForObject(v.getVectorId());
        req.setAttribute("protocols", protocols);

        ExperimentDao experimentDao= new ExperimentDao();
        List<ExperimentRecord> experimentRecords = experimentDao.getExperimentsByVector(v.getVectorId());

        req.setAttribute("experimentRecords",experimentRecords);

        HashMap<Long,List<Guide>> guideMap = new HashMap<>();
        for(ExperimentRecord record:experimentRecords) {
            guideMap.put(record.getExperimentRecordId(), dbService.getGuidesByExpRecId(record.getExperimentRecordId()));
        }
        req.setAttribute("guideMap", guideMap);

        HashMap<Long,List<Vector>> vectorMap = new HashMap<>();
        Set<Long> experimentIds=new HashSet<>();
        for(ExperimentRecord record:experimentRecords) {
            vectorMap.put(record.getExperimentRecordId(), dbService.getVectorsByExpRecId(record.getExperimentRecordId()));
            experimentIds.add(record.getExperimentId());
        }
        req.setAttribute("vectorMap", vectorMap);
        if(studies!=null && studies.size()>0) {
            mapProjectNExperiments(experimentRecords, req);}
        List<Publication> associatedPublications=new ArrayList<>();
        associatedPublications.addAll(publicationDAO.getAssociatedPublications(v.getVectorId()));
        for(long experimentId:experimentIds) {
            for(Publication pub:publicationDAO.getAssociatedPublications(experimentId)) {
                boolean flag=false;
                for(Publication publication:associatedPublications){
                    if(pub.getReference().getKey()==publication.getReference().getKey()){
                        flag=true;
                    }
                }
                if(!flag)
                    associatedPublications.add(pub);
            }

        }
        List<String> files=new ArrayList<>();
        if(studies != null && studies.size()>0) {
            StorageProperties properties = new StorageProperties();
            //properties.setLocation("C:/tmp/upload-dir" );
            properties.setLocation("/data/scge_submissions");
            FileSystemStorageService service = new FileSystemStorageService(properties);
            storageService.init();

            String studyId = String.valueOf(studies.get(0).getStudyId());
            try {
//                req.setAttribute("files", service.loadAll(studyId).map(
//                                path -> MvcUriComponentsBuilder.fromMethodName(FileUploadController.class,
//                                        "serveFile", req, path.getFileName().toString(), studyId).build().toUri().toString())
//                        .collect(Collectors.toList()));
                 files.addAll(service.loadAll(studyId).map(
                                path -> MvcUriComponentsBuilder.fromMethodName(FileUploadController.class,
                                        "serveFile", req, path.getFileName().toString(), studyId).build().toUri().toString())
                        .collect(Collectors.toList()));
            } catch (Exception e) {
                req.setAttribute("files", new ArrayList<String>());
            }
        }

        req.setAttribute("summaryBlocks", getSummary(v, files));
        req.setAttribute("vector", v);
        req.setAttribute("action", "Vector/Format: " + v.getName());
        req.setAttribute("page", "/WEB-INF/jsp/tools/vector");

        req.setAttribute("associatedPublications", associatedPublications);
        req.setAttribute("relatedPublications", publicationDAO.getRelatedPublications(v.getVectorId()));
        req.setAttribute("seoDescription",v.getDescription());
        req.setAttribute("seoTitle",v.getName());
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
    @RequestMapping(value = "/edit")
    public String getVectorForm(HttpServletRequest req, HttpServletResponse res,Vector vector) throws Exception{

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

        if(req.getParameter("id") != null) {
            Vector v = dao.getVectorById(Long.parseLong(req.getParameter("id"))).get(0);
            req.setAttribute("vector",v);
            req.setAttribute("action","Update Vector");
        }else {
            req.setAttribute("vector", new Vector());
            req.setAttribute("action", "Create Vector");
        }

        List<Vector> records = dao.getAllVectors();
        Set<String> names = records.stream().map(Vector::getName).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> types = records.stream().map(Vector::getType).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> subTypes = records.stream().map(Vector::getSubtype).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> genomeSerotype = records.stream().map(Vector::getGenomeSerotype).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> capsidVariant = records.stream().map(Vector::getCapsidVariant).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> source = records.stream().map(Vector::getSource).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> capsidSerotype = records.stream().map(Vector::getCapsidSerotype).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> titerMethod = records.stream().map(Vector::getTiterMethod).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> labId = records.stream().map(Vector::getLabId).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());

        req.setAttribute("types",types);
        req.setAttribute("subTypes",subTypes);
        req.setAttribute("genomeSerotype",genomeSerotype);
        req.setAttribute("capsidVariant",capsidVariant);
        req.setAttribute("source",source);
        req.setAttribute("capsidSerotype",capsidSerotype);
        req.setAttribute("titerMethod",titerMethod);
        req.setAttribute("labId",labId);
        req.setAttribute("names",names);

        req.setAttribute("page", "/WEB-INF/jsp/edit/editVector");
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a> / <a href='/toolkit/data/vector/search'>Vectors</a>");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
    @RequestMapping("/create")
    public String createModel(HttpServletRequest req,HttpServletResponse res,@ModelAttribute("vector") Vector vector) throws Exception {

        long vectorId =  vector.getVectorId();
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
        if(vectorId == 0) {
            vectorId = dao.getVectorId(vector);
            if(vectorId == 0) {
                vectorId = dao.insertVector(vector);
                req.setAttribute("status"," <span style=\"color: blue\">Vector inserted successfully</span>");
            }else {
                req.setAttribute("status"," <span style=\"color: red\">Vector already exists</span>");
            }
        }else{
            dao.updateVector(vector);
            req.setAttribute("status"," <span style=\"color: blue\">Vector updated successfully</span>");
        }

        req.getRequestDispatcher("/data/vector/format?id="+vectorId).forward(req,res);
        return null;
    }
    public  Map<String, Map<String, String>>  getSummary(Vector object, List<String> files){
        Map<String, Map<String, String>> summaryBlocks= new LinkedHashMap<>();

        Map<String, String> summary=new LinkedHashMap<>();
        int i=0;
        summary.put("SCGE ID", String.valueOf(object.getVectorId()));
        if(object.getName()!=null && !object.getName().equals(""))
            summary.put("Name", object.getName());
        if(object.getDescription()!=null && !object.getDescription().equals(""))
            summary.put("Description", object.getDescription());

        if(object.getType()!=null && !object.getType().equals(""))
            summary.put("Type", object.getType());
        if(object.getSubtype()!=null && !object.getSubtype().equals(""))
            summary.put("Subtype", object.getSubtype());
        if(summary.size()>0) {
            summaryBlocks.put("block"+i, summary);
            i++;
            summary = new LinkedHashMap<>();
        }

        if(object.getSource()!=null && !object.getSource().equals(""))
            summary.put("Source", object.getSource());
        if(summary.size()>0) {
            summaryBlocks.put("block"+i, summary);
            i++;
            summary = new LinkedHashMap<>();
        }
        if(object.getGenomeSerotype()!=null && !object.getGenomeSerotype().equals(""))
            summary.put("Genome Serotype", object.getGenomeSerotype());
        if(object.getCapsidSerotype()!=null && !object.getCapsidSerotype().equals(""))
            summary.put("Capsid Serotype", object.getCapsidSerotype());
        if(object.getCapsidVariant()!=null && !object.getCapsidVariant().equals(""))
            summary.put("Capsid Variant", object.getCapsidVariant());
            if(object.getSource().equalsIgnoreCase("addGene")){
                summary.put("Stock/Catalog/RRID","<a href='https://www.addgene.org/"+object.getLabId()+"'>"+object.getLabId()+"</a>");
            }else{
                summary.put("Stock/Catalog/RRID", object.getLabId());

            }
        if(summary.size()>0) {
            summaryBlocks.put("block"+i, summary);
            i++;
            summary = new LinkedHashMap<>();
        }
        if(object.getAnnotatedMap()!=null && !object.getAnnotatedMap().equals("")) {
            System.out.println("FILES SIZE:"+ files.size());
            String annotatedMapLinked=null;
            for(String file:files){
                String[] fileParts = file.split("/");
                if(fileParts[fileParts.length -1].trim().equalsIgnoreCase(object.getAnnotatedMap().trim())){

                    annotatedMapLinked=object.getAnnotatedMap()+"&nbsp;<a href='"+file+"'><i class='fa fa-download' aria-hidden='true'></i></a>";
                    System.out.println("MATCHED..........."+annotatedMapLinked);
                    break;
                }
//                else {
//                    System.out.println("FILE Parts:" + fileParts[fileParts.length - 1] + "Annotated Map:" + object.getAnnotatedMap());
//                }
            }
            if(annotatedMapLinked==null){
                annotatedMapLinked=object.getAnnotatedMap();
            }
            summary.put("Annotated Map", annotatedMapLinked );
        }
        if(object.getTiterMethod()!=null && !object.getTiterMethod().equals(""))
            summary.put("Titer Method", object.getTiterMethod());
        if(summary.size()>0) {
            summaryBlocks.put("block"+i, summary);

        }
        return summaryBlocks;
    }

}
