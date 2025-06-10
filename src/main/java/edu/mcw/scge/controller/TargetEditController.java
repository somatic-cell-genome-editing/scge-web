package edu.mcw.scge.controller;

import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.configuration.UserService;
import edu.mcw.scge.dao.implementation.*;
import edu.mcw.scge.datamodel.*;
import edu.mcw.scge.process.customLabels.CustomUniqueLabels;
import edu.mcw.scge.service.ProcessUtils;
import edu.mcw.scge.service.db.DBService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.*;

@Controller
@RequestMapping(value="/data/edit")
public class TargetEditController {
    ExperimentDao edao = new ExperimentDao();
    StudyDao sdao = new StudyDao();
    edu.mcw.scge.configuration.Access access=new Access();
    DBService dbService=new DBService();
    UserService userService=new UserService();

    PublicationDAO publicationDAO=new PublicationDAO();

    ProtocolDao pdao = new ProtocolDao();


    @RequestMapping(value="/target/experiment/{experimentId}")
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

        List<String> resultTypesList = dbService.getResultTypes(experimentId);
        Set<String> resultTypesSet=new HashSet<>(resultTypesList);
        Map<String, List<String>> resultTypeNUnits=dbService.getResultTypeNUnits(experimentId);
        req.setAttribute("resultTypesSet", resultTypesSet);
        req.setAttribute("resultTypeNUnits", resultTypeNUnits);

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

        req.setAttribute("records", records);


        req.setAttribute("tissues",tissues);
        req.setAttribute("tissuesTarget",tissuesTarget);
        req.setAttribute("tissuesNonTarget",tissuesNonTarget);
        req.setAttribute("conditions",conditions);
        if((tissues.size()>0 && (tissue!=null || (resultType!=null && resultType.equals("all")))) || req.getParameter("selectedTissues")!=null){
            req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a>/ <a href='/toolkit/data/experiments/group/" + localStudy.getGroupId() + "'>Project</a> / <a href='/toolkit/data/experiments/experiment/"+experimentId + "'>Experiment Overview</a>");

        }else
            req.setAttribute("crumbtrail","<a href='/toolkit/loginSuccess?destination=base'>Home</a>  / <a href='/toolkit/data/experiments/group/" + localStudy.getGroupId() + "'>Project</a>");

        req.setAttribute("study", localStudy);
        req.setAttribute("experiment",e);
        req.setAttribute("resultType",resultType);
        req.setAttribute("tissue",tissue);
        if(req.getParameter("selectedTissues")!=null)
            req.setAttribute("selectedTissues",req.getParameter("selectedTissues"));
        req.setAttribute("cellType",cellType);
        req.setAttribute("deliveryAssay",deliveryMap);
        req.setAttribute("editingAssay",editingMap);
        req.setAttribute("biomarkerAssay",biomarkerMap);

        req.setAttribute("page", "/WEB-INF/jsp/tools/tissueMap");
        if(req.getParameter("viewAll")!=null)
            req.setAttribute("viewAll", req.getParameter("viewAll"));
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
}
