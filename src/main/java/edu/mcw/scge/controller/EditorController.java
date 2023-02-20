package edu.mcw.scge.controller;

import edu.mcw.scge.configuration.UserService;
import edu.mcw.scge.dao.implementation.*;
import edu.mcw.scge.datamodel.*;
import edu.mcw.scge.datamodel.Vector;
import edu.mcw.scge.datamodel.publications.Publication;
import edu.mcw.scge.process.UI;
import edu.mcw.scge.service.db.DBService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import edu.mcw.scge.configuration.Access;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping(value="/data/editors")
public class EditorController extends ObjectController {
    EditorDao editorDao = new EditorDao();
    PublicationDAO publicationDAO=new PublicationDAO();
    @RequestMapping(value="/search")
    public String getEditors(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        Access access = new Access();
        UserService us = new UserService();
        Person p = us.getCurrentUser(req.getSession());

        List<Editor> records = null;


        if (access.isInDCCorNIHGroup(p)) {
            records = editorDao.getAllEditors();
        }else {
            records = editorDao.getAllEditors(us.getCurrentUser(req.getSession()).getId());
        }


        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a>");
        req.setAttribute("editors", records);
        req.setAttribute("action", "Genome Editors");
        req.setAttribute("page", "/WEB-INF/jsp/tools/editors");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

    @RequestMapping(value="/editor")
    public String getEditor(HttpServletRequest req, HttpServletResponse res) throws Exception {
        EditorDao dao = new EditorDao();
        Editor editor= dao.getEditorById(Long.parseLong(req.getParameter("id"))).get(0);
        DBService dbService = new DBService();
        UserService userService = new UserService();
        Person p=userService.getCurrentUser(req.getSession());
        Access access = new Access();

        if(!access.isLoggedIn()) {
            return "redirect:/";
        }

        if (!access.hasEditorAccess(editor,p)) {
            req.setAttribute("page", "/WEB-INF/jsp/error");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            return null;

        }

        req.setAttribute("summaryBlocks", getSummary(editor));
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a> / <a href='/toolkit/data/search/results/Genome%20Editor?searchTerm='>Editors</a>");
        req.setAttribute("editor", editor);
        req.setAttribute("objectId", editor.getId());

        req.setAttribute("action", "Genome Editor: " + UI.replacePhiSymbol(editor.getSymbol()));
        req.setAttribute("page", "/WEB-INF/jsp/tools/editor");

        StudyDao sdao = new StudyDao();
        List<Study> studies = sdao.getStudiesByEditor(editor.getId());
        req.setAttribute("studies", studies);

        ProtocolDao pdao = new ProtocolDao();
        List<Protocol> protocols = pdao.getProtocolsForObject(editor.getId());
        req.setAttribute("protocols", protocols);


        ExperimentDao experimentDao= new ExperimentDao();
        List<ExperimentRecord> experimentRecords = experimentDao.getExperimentsByEditor(editor.getId());
        req.setAttribute("experimentRecords",experimentRecords);

        HashMap<Long,List<Guide>> guideMap = new HashMap<>();
        for(ExperimentRecord record:experimentRecords) {
            guideMap.put(record.getExperimentRecordId(), dbService.getGuidesByExpRecId(record.getExperimentRecordId()));
        }

        GuideDao guideDao = new GuideDao();
        List<Guide> guides = guideDao.getGuidesByEditor(editor.getId());
        req.setAttribute("guides", guides);
        req.setAttribute("guideMap", guideMap);

        HashMap<Long,List<Vector>> vectorMap = new HashMap<>();
        Set<Long> experimentIds=new HashSet<>();
        for(ExperimentRecord record:experimentRecords) {
            vectorMap.put(record.getExperimentRecordId(), dbService.getVectorsByExpRecId(record.getExperimentRecordId()));
            experimentIds.add(record.getExperimentId());
        }
        req.setAttribute("vectorMap", vectorMap);
        /*************************************************************/

        if(studies!=null && studies.size()>0) {
            mapProjectNExperiments(experimentRecords, req);
            List<Object> comparableEditors=new ArrayList<>();
            List<Experiment> experiments=new ArrayList<>();

            for (Study study : studies) {
                 experiments.addAll(experimentDao.getExperimentsByStudy(study.getStudyId()));
                for (Experiment experiment : experiments) {
                    List<Editor> otherEditorsOfThis=editorDao
                            .getEditorByExperimentId(experiment.getExperimentId());
                     comparableEditors=otherEditorsOfThis.stream().filter(o->o.getId()!=editor.getId()).collect(Collectors.toList());


                }
            }

            req.setAttribute("comparableEditors", comparableEditors);
        }
        /*************************************************************/
        List<Publication> associatedPublications=new ArrayList<>();
        associatedPublications.addAll(publicationDAO.getAssociatedPublications(editor.getId()));
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
        req.setAttribute("associatedPublications", associatedPublications);
        req.setAttribute("relatedPublications", publicationDAO.getRelatedPublications(editor.getId()));
        req.setAttribute("seoDescription",editor.getEditorDescription());
        req.setAttribute("seoTitle",editor.getSymbol());

        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
    @RequestMapping("/create")
    public String createEditor(HttpServletRequest req,HttpServletResponse res,@ModelAttribute("editor") Editor editor) throws Exception {


        long id = editor.getId();
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
        if(editor.getId() == 0) {
            id = editorDao.getEditorId(editor);
            if(id == 0) {
                id = editorDao.insertEditor(editor);
                editor.setId(id);
                editorDao.insertGenomeInfo(editor);
                req.setAttribute("status"," <span style=\"color: blue\">Editor added successfully</span>");
            }
            else {
                req.setAttribute("status"," <span style=\"color: red\">Editor already exists</span>");
            }
        }else {
            editorDao.updateEditor(editor);
            editorDao.updateGenomeInfo(editor);
            req.setAttribute("status"," <span style=\"color: blue\">Editor updated successfully</span>");
        }

        req.getRequestDispatcher( "/data/editors/editor?id="+id).forward(req,res);
        return null;
    }
    @RequestMapping(value = "/edit")
    public String getEditorForm(HttpServletRequest req, HttpServletResponse res,Editor editor) throws Exception{

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
            Editor e = editorDao.getEditorById(Long.parseLong(req.getParameter("id"))).get(0);
            req.setAttribute("editor",e);
            req.setAttribute("action","Update Editor");
        }else {
            req.setAttribute("editor", new Editor());
            req.setAttribute("action", "Create Editor");
        }

        List<Editor> records = editorDao.getAllEditors();
        Set<String> types = records.stream().map(Editor::getType).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> subTypes = records.stream().map(Editor::getSubType).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> species = records.stream().map(Editor::getSpecies).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> pam = records.stream().map(Editor::getPamPreference).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> variant = records.stream().map(Editor::getEditorVariant).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> fusion = records.stream().map(Editor::getFusion).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> cleavage = records.stream().map(Editor::getDsbCleavageType).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> source = records.stream().map(Editor::getSource).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> symbol = records.stream().map(Editor::getSymbol).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> substrate = records.stream().map(Editor::getSubstrateTarget).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> activity = records.stream().map(Editor::getActivity).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());

        req.setAttribute("types",types);
        req.setAttribute("subTypes",subTypes);
        req.setAttribute("species",species);
        req.setAttribute("pam",pam);
        req.setAttribute("variant",variant);
        req.setAttribute("fusion",fusion);
        req.setAttribute("cleavage",cleavage);
        req.setAttribute("source",source);
        req.setAttribute("symbol",symbol);
        req.setAttribute("substrate",substrate);
        req.setAttribute("activity",activity);
        req.setAttribute("page", "/WEB-INF/jsp/edit/editEditor");
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a> / <a href='/toolkit/data/search/results/Genome%20Editor?searchTerm='>Editors</a>");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
    public  Map<String, Map<String, String>> getSummary(Editor editor){
        Map<String, Map<String, String>> summaryBlocks=new LinkedHashMap<>();

        Map<String, String> summary=new LinkedHashMap<>();
        int i=0;
        summary.put("SCGE ID", String.valueOf(editor.getId()));
        if(editor.getSymbol()!=null && !editor.getSymbol().equals(""))
        summary.put("Symbol", editor.getSymbol());
        if(editor.getEditorDescription()!=null && !editor.getEditorDescription().equals(""))
        summary.put("Description", editor.getEditorDescription());
        if(editor.getSpecies()!=null && !editor.getSpecies().equals(""))
        summary.put("Species", editor.getSpecies());
        if(editor.getType()!=null && !editor.getType().equals(""))
        summary.put("Type", editor.getType());
        if(editor.getSubType()!=null && !editor.getSubType().equals(""))
        summary.put("Subtype", editor.getSubType());
        if(editor.getAlias()!=null && !editor.getAlias().equals(""))
        summary.put("Alias", editor.getAlias());
        if(summary.size()>0) {
            summaryBlocks.put("block"+i, summary);
            i++;
            summary=new LinkedHashMap<>();
        }
        if(editor.getActivity()!=null && !editor.getActivity().equals(""))
        summary.put("Activity", editor.getActivity());
        if(editor.getSubstrateTarget()!=null && !editor.getSubstrateTarget().equals(""))
        summary.put("Substrate", editor.getSubstrateTarget());
        if(editor.getDsbCleavageType()!=null && !editor.getDsbCleavageType().equals(""))
        summary.put("DSB Cleavage Type", editor.getDsbCleavageType());
        if(editor.getPamPreference()!=null && !editor.getPamPreference().equals(""))
        summary.put("PAM", editor.getPamPreference());
        if(editor.getEditorVariant()!=null && !editor.getEditorVariant().equals(""))
        summary.put("Variant", editor.getEditorVariant());
        if(editor.getFusion()!=null && !editor.getFusion().equals(""))
        summary.put("Fusion", editor.getFusion());
        if(editor.getAnnotatedMap()!=null && !editor.getAnnotatedMap().equals(""))
        summary.put("Annotated Map", editor.getAnnotatedMap());
        if(summary.size()>0) {
            summaryBlocks.put("block"+i, summary);
            i++;
            summary=new LinkedHashMap<>();
        }        if(editor.getSource()!=null && !editor.getSource().equals(""))
        summary.put("Source", editor.getSource());
        if(editor.getCatalog()!=null && !editor.getCatalog().equals(""))
        summary.put("Catalog", editor.getCatalog());
        if(editor.getRrid()!=null && !editor.getRrid().equals(""))
        summary.put("RRID", editor.getRrid());
        if(summary.size()>0) {
            summaryBlocks.put("block"+i, summary);
            i++;
            summary=new LinkedHashMap<>();
        }        if(editor.getTargetLocus()!=null && !editor.getTargetLocus().equals(""))
        summary.put("Target Locus", editor.getTargetLocus());
        if(editor.getTarget_sequence()!=null && !editor.getTarget_sequence().equals(""))
        summary.put("Target Sequence", editor.getTarget_sequence());
        if(editor.getAssembly()!=null && !editor.getAssembly().equals(""))
        summary.put("Position", editor.getAssembly()+"/"+editor.getChr()+":"+editor.getStart()+"-"+editor.getStop());
        if(summary.size()>0) {
            summaryBlocks.put("block"+i, summary);
        }
        return summaryBlocks;
    }
}
