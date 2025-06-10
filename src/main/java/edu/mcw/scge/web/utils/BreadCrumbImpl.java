package edu.mcw.scge.web.utils;

import edu.mcw.scge.datamodel.*;

import jakarta.servlet.http.HttpServletRequest;
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
       // System.out.println("REQ URI:"+ reqUri+"\nCONTEXT PATH:"+contextPath);

        if(pageContext!=null && pageContext.equalsIgnoreCase("search")){
            return getSearchCrumbTrail(pageContext, req);
        }
        TreeMap<Integer, Map<String, String>> crumbTrail=new TreeMap<>();
        Map<String, String> trailNLink=new HashMap<>();
        String parentCrumb=new String();
        long parentId=0;
        String childCrumb=new String();
        long childId=0;
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
           crumbTrail.put(1, trailNLink);
           return crumbTrail;
       }
        if(parent instanceof Model){
         //   System.out.println("YES MODEL INSTANCE");
            trailNLink.put("Models", "/toolkit/data/models/search/");
            crumbTrail.put(1, trailNLink);
            return crumbTrail;
        }
        if(parent instanceof Experiment){
            trailNLink.put("Experiments", "/toolkit/data/experiments/search/");
            crumbTrail.put(1, trailNLink);
            return crumbTrail;
        }
        if(parent instanceof Guide){
            trailNLink.put("Guides", "/toolkit/data/guide/search/");
            crumbTrail.put(1, trailNLink);
            return crumbTrail;
        }
        if(parent instanceof Delivery){
            trailNLink.put("Delivery Systems", "/toolkit/data/search/results/Delivery%20System?searchTerm=");
            crumbTrail.put(1, trailNLink);
            return crumbTrail;
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
    public TreeMap<Integer, Map<String, String>> getSearchCrumbTrail(String pageContext, HttpServletRequest req){
        TreeMap<Integer, Map<String, String>> crumbTrail=new TreeMap<>();
        String parentCrumb=new String();
        String childCrumb=new String();
        String parentUrl=new String();
        if(pageContext.equalsIgnoreCase("search")){
            String searchTerm=req.getParameter("searchTerm");
            String category= (String) req.getAttribute("category");
            Map<String, String> trailNLink1=new HashMap<>();
            parentCrumb= "Categories";
            parentUrl="/toolkit/data/search/results?searchTerm="+searchTerm;
            trailNLink1.put(parentCrumb, parentUrl);
            crumbTrail.put(1, trailNLink1);

            childCrumb= category;
            Map<String, String> trailNLink2=new HashMap<>();
            trailNLink2.put(childCrumb, "");
            crumbTrail.put(2, trailNLink2);

        }
        return crumbTrail;
    }
    public TreeMap<Integer, Map<String, String>> getEditorCrumbTrail(String pageContext, HttpServletRequest req){
        TreeMap<Integer, Map<String, String>> crumbTrail=new TreeMap<>();
        String parentCrumb=new String();
        int parentId=0;
        String childCrumb=new String();
        String parentUrl=new String();
        if(pageContext.equalsIgnoreCase("search")){
            String searchTerm=req.getParameter("searchTerm");
            String category= (String) req.getAttribute("category");
            Map<String, String> trailNLink1=new HashMap<>();

            parentCrumb= "Categories";
            parentUrl="/toolkit/data/search/results?searchTerm="+searchTerm;
            trailNLink1.put(parentCrumb, parentUrl+parentId);
            crumbTrail.put(1, trailNLink1);

            childCrumb= category;
            Map<String, String> trailNLink2=new HashMap<>();
            trailNLink2.put(childCrumb, "");
            crumbTrail.put(2, trailNLink2);

        }
        return crumbTrail;
    }

}
