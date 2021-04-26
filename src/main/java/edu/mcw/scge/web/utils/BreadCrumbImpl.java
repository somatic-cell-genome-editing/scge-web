package edu.mcw.scge.web.utils;

import edu.mcw.scge.datamodel.Editor;
import edu.mcw.scge.datamodel.Experiment;
import edu.mcw.scge.datamodel.Study;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;

public class BreadCrumbImpl implements Crumb {
    @Override
    public TreeMap<Integer, Map<String, String>> getCrumbTrailMap(
            HttpServletRequest req,
            Object parent, Object child, String pageContext ) {
        String reqUri=req.getRequestURI();
        String contextPath=req.getContextPath();
        System.out.println("REQ URI:"+ reqUri+"\nCONTEXT PATH:"+contextPath);
        TreeMap<Integer, Map<String, String>> crumbTrail=new TreeMap<>();
        Map<String, String> trailNLink=new HashMap<>();
        String parentCrumb=new String();
        int parentId=0;
        String childCrumb=new String();
        int childId=0;
        String parentUrl=new String();
        String childUrl=new String();
        if(parent instanceof Study){
            trailNLink.put("Studies", "/toolkit/data/studies/search/");

            parentCrumb = ((Study) parent).getStudy();
           parentId=((Study) parent).getStudyId();
           parentUrl="/toolkit/data/experiments/study/";
        }
        if(parent instanceof Experiment){
            trailNLink.put("Experiments", "/toolkit/data/experiments/search/");
            parentCrumb= ((Experiment) parent).getName();
            parentId=((Experiment) parent).getExperimentId();
            parentUrl="/toolkit/data/experiments/experiment/";
        }
       if(parent instanceof Editor){
           trailNLink.put("Editors", "/toolkit/data/editors/search/");

        }

        if(child instanceof Experiment){
            childCrumb= ((Experiment) child).getName();
            childId=((Experiment) child).getExperimentId();
            childUrl="/toolkit/data/experiments/experiment/";
        }

        req.getRequestURI();
        crumbTrail.put(1, trailNLink);
        Map<String, String> trailNLink2=new HashMap<>();
        trailNLink2.put(parentCrumb, parentUrl+parentId);
        crumbTrail.put(2, trailNLink2);
        if(childCrumb!=null && !childCrumb.equals("")) {
            Map<String, String> trailNLink3 = new HashMap<>();
            trailNLink3.put(childCrumb, childUrl + childId);
            crumbTrail.put(3, trailNLink3);
        }
        return crumbTrail;
    }
    public TreeMap<Integer, Map<String, String>> getCrumbTrail(String pageContext, HttpServletRequest req){
        TreeMap<Integer, Map<String, String>> crumbTrail=new TreeMap<>();
        if(pageContext.equalsIgnoreCase("search")){
            String searchTerm=req.getParameter("searchTerm");
            String
        }
        return crumbTrail;
    }
}
