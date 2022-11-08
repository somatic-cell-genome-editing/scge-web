package edu.mcw.scge.controller;

import com.google.gson.Gson;
import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.configuration.UserService;
import edu.mcw.scge.dao.implementation.*;
import edu.mcw.scge.datamodel.*;
import edu.mcw.scge.datamodel.Vector;
import edu.mcw.scge.datamodel.publications.Publication;
import edu.mcw.scge.service.db.DBService;
import edu.mcw.scge.web.utils.BreadCrumbImpl;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.management.Descriptor;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@Controller
@RequestMapping(value="/data/guide")
public class GuideController extends ObjectController{
    BreadCrumbImpl breadCrumb=new BreadCrumbImpl();
    GuideDao guideDao = new GuideDao();
    PublicationDAO publicationDAO=new PublicationDAO();
    @RequestMapping(value="/search")
    public String getGuides(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        GuideDao dao = new GuideDao();
        List<Guide> records= dao.getGuides();
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a>");
        req.setAttribute("guides", records);
        req.setAttribute("action", "Guides");
        req.setAttribute("page", "/WEB-INF/jsp/tools/guides");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

    @RequestMapping(value="/system")
    public String getGuide(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        DBService dbService = new DBService();
        UserService userService = new UserService();
        Person p=userService.getCurrentUser(req.getSession());
        edu.mcw.scge.configuration.Access access = new Access();

        Guide guide= guideDao.getGuideById(Long.parseLong(req.getParameter("id"))).get(0);

        if (!access.hasGuideAccess(guide,p)) {
            req.setAttribute("page", "/WEB-INF/jsp/error");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            return null;

        }


        List<Guide> tmpSynonoymousGuides=guideDao.getGuidesByTargetSequence(guide.getTargetSequence());

        List<Guide> synononymousGuides = new ArrayList<Guide>();

        for (Guide tmpGuide: tmpSynonoymousGuides) {
            if (tmpGuide.getGuide_id() != guide.getGuide_id()) {
                if (access.hasGuideAccess(tmpGuide,p)) {
                    synononymousGuides.add(tmpGuide);
                }
            }
        }

        req.setAttribute("synonymousGuides",synononymousGuides);


        req.setAttribute("summary", getSummary(guide));

        req.setAttribute("crumbTrail",   breadCrumb.getCrumbTrailMap(req,guide,null,null));

        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a> / <a href='/toolkit/data/search/results/Guide?searchTerm='>Guides</a>");
        req.setAttribute("guide", guide);
        req.setAttribute("action", "Guide: " + guide.getGuide());
        req.setAttribute("page", "/WEB-INF/jsp/tools/guide");

        StudyDao sdao = new StudyDao();
        List<Study> studies = sdao.getStudiesByGuide(guide.getGuide_id());
        req.setAttribute("studies", studies);

        ProtocolDao pdao = new ProtocolDao();
        List<Protocol> protocols = pdao.getProtocolsForObject(guide.getGuide_id());
        req.setAttribute("protocols", protocols);

        ExperimentDao experimentDao= new ExperimentDao();
        List<ExperimentRecord> experimentRecords = experimentDao.getExperimentsByGuide(guide.getGuide_id());
        req.setAttribute("experimentRecords",experimentRecords);

        EditorDao editorDao = new EditorDao();
        List<Editor> editors = editorDao.getEditorByGuide(guide.getGuide_id());
        req.setAttribute("editors", editors);

        OffTargetDao offTargetDao = new OffTargetDao();
        List<OffTarget> offTargets = offTargetDao.getOffTargetByGuide(guide.getGuide_id());
        req.setAttribute("offTargets",offTargets);

        OffTargetSiteDao offTargetSiteDao = new OffTargetSiteDao();
        List<OffTargetSite> offTargetSites = offTargetSiteDao.getOffTargetSitesByGuide(guide.getGuide_id());
        req.setAttribute("offTargetSites",offTargetSites);

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
            mapProjectNExperiments(experimentRecords, req);
           }
        List<Publication> associatedPublications=new ArrayList<>();
        associatedPublications.addAll(publicationDAO.getAssociatedPublications(guide.getGuide_id()));
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
        req.setAttribute("relatedPublications", publicationDAO.getRelatedPublications(guide.getGuide_id()));
        req.setAttribute("seoDescription",guide.getGuideDescription());
        req.setAttribute("seoTitle",guide.getGrnaLabId());
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

    @RequestMapping(value = "/guides/{start}/{stop}/{guideId}", method = RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public String getGuidesOfRange(@PathVariable("start")int start, @PathVariable("stop") int stop, @PathVariable("guideId") long guideId) throws Exception {
       List<Guide> guides= guideDao.getAllGuidesByRange(start, stop);
       Guide guide=guideDao.getGuideById(guideId).get(0);
       List<GuideSequenceViewer> allSequenceViewerGuides=new ArrayList<>();
       for(Guide g:guides){
           GuideSequenceViewer viewer=new GuideSequenceViewer();
           viewer.setAssembly(g.getAssembly());
           viewer.setDescription(g.getGuideDescription());
           viewer.setFmax(g.getStop());
           viewer.setFmin(g.getStart());
           Map<String, String> guide_ids=new HashMap<>();
           guide_ids.put("values", g.getGrnaLabId());
           viewer.setGuide_ids(guide_ids);
           viewer.setName("<a href='/toolkit/data/guide/system?id="+ g.getGuide_id()+"'>"+g.getGuide()+"</a>");
           viewer.setPam(g.getPam());
           viewer.setScge_id(g.getGuide_id());
           viewer.setStrand(g.getStrand());
           viewer.setSeqId(g.getChr());
           viewer.setTargetLocus(g.getTargetLocus());
           viewer.setTargetSequence(g.getTargetSequence());
           if(guide.getStart().equals(g.getStart()) && guide.getStop().equals(g.getStop()))
           viewer.setType("gRNA");
           else
               viewer.setType("substitution");
           allSequenceViewerGuides.add(viewer);
       }
       Gson gson=new Gson();
        return gson.toJson(allSequenceViewerGuides);
    }
    @RequestMapping("/create")
    public String createGuide(HttpServletRequest req,HttpServletResponse res,@ModelAttribute("guide") Guide guide) throws Exception {


        long id = guide.getGuide_id();
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
        if(id == 0) {
            id = guideDao.getGuideId(guide);
            if(id == 0) {
                id = guideDao.insertGuide(guide);
                guide.setGuide_id(id);
                guideDao.insertGenomeInfo(guide);
                req.setAttribute("status"," <span style=\"color: blue\">Guide added successfully</span>");
            } else {
                req.setAttribute("status"," <span style=\"color: red\">Guide already exits</span>");
            }
        }else {
            guideDao.updateGuide(guide);
            guideDao.updateGenomeInfo(guide);
            req.setAttribute("status"," <span style=\"color: blue\">Guide updated successfully</span>");
        }

        req.getRequestDispatcher("/data/guide/system?id="+id).forward(req,res);
        return null;
    }
    @RequestMapping(value = "/edit")
    public String getEditorForm(HttpServletRequest req, HttpServletResponse res,Guide guide) throws Exception{

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
            Guide g = guideDao.getGuideById(Long.parseLong(req.getParameter("id"))).get(0);
            req.setAttribute("guide",g);
            req.setAttribute("action","Update Guide");
        }else {
            req.setAttribute("guide", new Guide());
            req.setAttribute("action", "Create Guide");
        }

        List<Guide> records = guideDao.getGuides();
        Set<String> guides = records.stream().map(Guide::getGuide).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> grnaLabId = records.stream().map(Guide::getGrnaLabId).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> species = records.stream().map(Guide::getSpecies).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> targetLocus = records.stream().map(Guide::getTargetLocus).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> source = records.stream().map(Guide::getSource).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());
        Set<String> guideFormat = records.stream().map(Guide::getGuideFormat).filter(r -> (r != null && !r.equals(""))).collect(Collectors.toSet());

        req.setAttribute("guides",guides);
        req.setAttribute("species",species);
        req.setAttribute("source",source);
        req.setAttribute("grnaLabId",grnaLabId);
        req.setAttribute("targetLocus",targetLocus);
        req.setAttribute("guideFormat",guideFormat);

        req.setAttribute("page", "/WEB-INF/jsp/edit/editGuide");
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a> / <a href='/toolkit/data/search/results/Guide?searchTerm='>Guides</a>");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
    public Map<String, String> getSummary(Guide object){
        Map<String, String> summary=new LinkedHashMap<>();
        summary.put("SCGE ID", String.valueOf(object.getGuide_id()));
        if(object.getGrnaLabId()!=null && !object.getGrnaLabId().equals(""))
            summary.put("Name", object.getGrnaLabId());
        if(object.getSource()!=null && !object.getSource().equals(""))
            summary.put("Source", object.getSource());
        if(object.getTargetLocus()!=null && !object.getTargetLocus().equals(""))

            summary.put("Target Locus", object.getTargetLocus());
        if(object.getSpecies()!=null && !object.getSpecies().equals(""))

            summary.put("Species", object.getSpecies());
        if(object.getGuideCompatibility()!=null && !object.getGuideCompatibility().equals(""))

            summary.put("Description", object.getGuideCompatibility());
        if(object.getGuideCompatibility()!=null && !object.getGuideCompatibility().equals(""))

            summary.put("Guide Compatability", object.getGuideCompatibility());
        if(object.getGuideFormat()!=null && !object.getGuideFormat().equals(""))

            summary.put("Guide Format", object.getGuideFormat());
        if(object.getSpecificityRatio()!=null && !object.getSpecificityRatio().equals(""))

            summary.put("Specificity Ratio", object.getSpecificityRatio());
        if(object.getTargetSequence()!=null && !object.getTargetSequence().equals(""))

            summary.put("Target Sequence", object.getTargetSequence());
        if(object.getAssembly()!=null && !object.getAssembly().equals(""))

            summary.put("Position", object.getAssembly()+"/"+object.getChr()+":"+object.getStart()+"-"+object.getStop());
        if(object.getFullGuide()!=null && !object.getFullGuide().equals(""))

            summary.put("Full Guide Sequence", object.getFullGuide());
        if(object.getSpacerSequence()!=null && !object.getSpacerSequence().equals(""))

            summary.put("Spacer Sequence", object.getSpacerSequence());
        if(object.getSpacerLength()!=null && !object.getSpacerLength().equals(""))

            summary.put("Spacer Length", object.getSpacerLength());
        if(object.getModifications()!=null && !object.getModifications().equals(""))

            summary.put("Modifications", object.getModifications());
        if(object.getRepeatSequence()!=null && !object.getRepeatSequence().equals(""))

            summary.put("Repeat Sequence", object.getRepeatSequence());
        if(object.getAntiRepeatSequence()!=null && !object.getAntiRepeatSequence().equals(""))

            summary.put("Anit-Repeat Sequence", object.getAntiRepeatSequence());
        if(object.getStemloop1Sequence()!=null && !object.getStemloop1Sequence().equals(""))

            summary.put("Stemloop 1 Sequence", object.getStemloop1Sequence());
        if(object.getStemloop2Sequence()!=null && !object.getStemloop2Sequence().equals(""))

            summary.put("Stemloop 2 Sequence", object.getStemloop2Sequence());
        if(object.getStemloop3Sequence()!=null && !object.getStemloop3Sequence().equals(""))

            summary.put("Stemloop 3 Sequence", object.getStemloop3Sequence());
        if(object.getForwardPrimer()!=null && !object.getForwardPrimer().equals(""))

            summary.put("Forward Primer", object.getForwardPrimer());
        if(object.getReversePrimer()!=null && !object.getReversePrimer().equals(""))

            summary.put("Reverse Primer", object.getReversePrimer());


        return summary;
    }
}
