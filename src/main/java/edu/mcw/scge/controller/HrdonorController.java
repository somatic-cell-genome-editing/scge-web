package edu.mcw.scge.controller;

import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.configuration.UserService;
import edu.mcw.scge.dao.implementation.*;
import edu.mcw.scge.datamodel.*;
import edu.mcw.scge.datamodel.Vector;
import edu.mcw.scge.datamodel.publications.Publication;
import edu.mcw.scge.service.db.DBService;
import edu.mcw.scge.web.utils.BreadCrumbImpl;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping(value="/data/hrdonors")
public class HrdonorController extends ObjectController {
    BreadCrumbImpl breadCrumb=new BreadCrumbImpl();
    HRDonorDao dao = new HRDonorDao();
    PublicationDAO publicationDAO=new PublicationDAO();
    @RequestMapping(value="/search")
    public String getHrdonors(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        List<HRDonor> records= dao.getAllHRDonors();
        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a>");
        req.setAttribute("hrdonors", records);
        req.setAttribute("action", "Hr Donors");
        req.setAttribute("page", "/WEB-INF/jsp/tools/hrdonors");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

    @RequestMapping(value="/hrdonor")
    public String getDeliverySystem(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {

        HRDonor hrDonor= dao.getHRDonorById(Long.parseLong(req.getParameter("id"))).get(0);
        DBService dbService = new DBService();

        UserService userService = new UserService();
        Person p=userService.getCurrentUser(req.getSession());
        Access access = new Access();

        if(!access.isLoggedIn()) {
            return "redirect:/";
        }

        if (!access.hasHrdonorAccess(hrDonor,p)) {
            req.setAttribute("page", "/WEB-INF/jsp/error");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            return null;

        }

        req.setAttribute("summaryBlocks", getSummary(hrDonor));
        req.setAttribute("crumbTrail",   breadCrumb.getCrumbTrailMap(req,hrDonor,null,null));

        req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a> / <a href='/toolkit/data/hrdonors/search'>Hr Donors</a>");
        req.setAttribute("hrdonor", hrDonor);
        req.setAttribute("action", "Hr Donor: " + hrDonor.getLabId());
        req.setAttribute("page", "/WEB-INF/jsp/tools/hrdonor");

        StudyDao sdao = new StudyDao();
        List<Study> studies = sdao.getStudiesByHrDonor(hrDonor.getId());
        req.setAttribute("studies", studies);

        ProtocolDao pdao = new ProtocolDao();
        List<Protocol> protocols = pdao.getProtocolsForObject(hrDonor.getId());
        req.setAttribute("protocols", protocols);

        ExperimentDao experimentDao= new ExperimentDao();
        List<ExperimentRecord> experimentRecords = experimentDao.getExperimentsByHrdonor(hrDonor.getId());
        req.setAttribute("experimentRecords",experimentRecords);

        HashMap<Long,List<Guide>> guideMap = new HashMap<>();
        Set<Long> experimentIds=new HashSet<>();
        for(ExperimentRecord record:experimentRecords) {
            guideMap.put(record.getExperimentRecordId(), dbService.getGuidesByExpRecId(record.getExperimentRecordId()));
            experimentIds.add(record.getExperimentId());
        }
        req.setAttribute("guideMap", guideMap);

        HashMap<Long,List<Vector>> vectorMap = new HashMap<>();
        for(ExperimentRecord record:experimentRecords) {
            vectorMap.put(record.getExperimentRecordId(), dbService.getVectorsByExpRecId(record.getExperimentRecordId()));
        }
        req.setAttribute("vectorMap", vectorMap);
        if(studies!=null && studies.size()>0) {
            mapProjectNExperiments(experimentRecords, req);}
        List<Publication> associatedPublications=new ArrayList<>();
        associatedPublications.addAll(publicationDAO.getAssociatedPublications(hrDonor.getId()));
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
        req.setAttribute("relatedPublications", publicationDAO.getRelatedPublications(hrDonor.getId()));
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
    public  Map<String, Map<String, String>> getSummary(HRDonor object){
        Map<String, Map<String, String>> summaryBlocks= new LinkedHashMap<>();
        Map<String, String> summary=new LinkedHashMap<>();
        int i=0;
        summary.put("SCGE ID", String.valueOf(object.getId()));
        if(object.getLabId()!=null && !object.getLabId().equals(""))
            summary.put("Name", object.getLabId());
        if(object.getDescription()!=null && !object.getDescription().equals(""))

            summary.put("Description", object.getDescription());
        if(object.getSource()!=null && !object.getSource().equals(""))
            summary.put("Source", object.getSource());
        if(object.getType()!=null && !object.getType().equals(""))
            summary.put("Type", object.getType());

        if(object.getModification()!=null && !object.getModification().equals(""))
            summary.put("Modification", object.getModification());

        if(object.getSequence()!=null && !object.getSequence().equals(""))
            summary.put("Sequence", object.getSequence());

        if(summary.size()>0) {
            summaryBlocks.put("block"+i, summary);

        }
        return summaryBlocks;
    }
}
