package edu.mcw.scge.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.configuration.UserService;
import edu.mcw.scge.dao.implementation.ExperimentDao;
import edu.mcw.scge.datamodel.Experiment;
import edu.mcw.scge.datamodel.Person;
import edu.mcw.scge.service.es.IndexServices;
import edu.mcw.scge.web.Facet;
import edu.mcw.scge.web.utils.BreadCrumbImpl;
import co.elastic.clients.elasticsearch.core.SearchResponse;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping(value="/data/search")
public class SearchController{
    ExperimentDao experimentDao=new ExperimentDao();
    private final RequestCache requestCache = new HttpSessionRequestCache();
    IndexServices services=new IndexServices();
    Access access=new Access();
    UserService userService=new UserService();
    BreadCrumbImpl breadCrumb=new BreadCrumbImpl();
    Gson gson=new Gson();
    @RequestMapping(value="/results")
    public String getResults(HttpServletRequest req, HttpServletResponse res, @RequestParam(required = false) String searchTerm) throws Exception {
        Person user=userService.getCurrentUser(req.getSession());
        boolean DCCNIHMember=access.isInDCCorNIHGroup(user);
        boolean consortiumMember=access.isConsortiumMember(user.getId());
        if(!DCCNIHMember) {
            List<Experiment> experiments = experimentDao.getExperimentsByPersonId(user.getId());
            experiments.addAll(experimentDao.getAllTier4Experiments());
            if (consortiumMember) {
                experiments.addAll(experimentDao.getAllTier3Experiments());
            }
            Set<Long> experimentIds=experiments.stream().map(experiment -> experiment.getExperimentId()).collect(Collectors.toSet());
            req.setAttribute("userAccessExperimentIds", experimentIds);
        }
        SearchResponse<Map> sr=services.getSearchResults(null, searchTerm, getFilterMap(req),DCCNIHMember,consortiumMember);

        boolean facetSearch=false;
        if(req.getParameter("facetSearch")!=null)
            facetSearch= req.getParameter("facetSearch").equals("true");
        req.setAttribute("hits", services.getHits(sr));
        req.setAttribute("resultCount", sr.hits().total()!=null ? sr.hits().total().value() : 0L);
        req.setAttribute("searchTerm", searchTerm);
        Map<String, Object> aggregationMap = services.getAggregationView(sr);
        req.setAttribute("aggregations",aggregationMap);
        String selectedView=req.getParameter("selectedView");
        if(selectedView==null || selectedView.equals("")){
            selectedView="list";
        }
        req.setAttribute("selectedView",selectedView);
     //   req.setAttribute("aggregations",aggregations);
        if(facetSearch) {
            //   return "search/resultsTable";
            //    return "search/resultsView";
      //      if(getFilterMap(req).size()==1){
       //         SearchResponse searchResponse= services.getFilteredAggregations(null,searchTerm,getFilterMap(req), DCCNIHMember,consortiumMember);
                if(getFilterMap(req).size()==1 ){
                    SearchResponse<Map> oneCategoryFilterAggs= services.getFilteredAggregations(null,searchTerm,getFilterMap(req), DCCNIHMember, consortiumMember);
                    if(oneCategoryFilterAggs!=null) {
                        aggregationMap.putAll(services.getAggregationView(oneCategoryFilterAggs));
                        req.setAttribute("aggregations", aggregationMap);
                    }

                }else{
                    SearchResponse<Map> categoryAggs= services.getFilteredAggregations(null,searchTerm,getFilterMap(req), DCCNIHMember, consortiumMember);
                    if(categoryAggs!=null) {
                        aggregationMap.putAll(services.getAggregationView(categoryAggs));
                        req.setAttribute("aggregations", aggregationMap);
                    }
                }

           // }
       //     return "search/resultsPage";
        }
    //    else {
        req.setAttribute("facets", Facet.displayNames);

        req.setAttribute("action", (sr.hits().total()!=null ? sr.hits().total().value() : 0L) + " results for " + searchTerm);
            req.setAttribute("page", "/WEB-INF/jsp/search/results");
        req.setAttribute("seoDescription","The goal of the SCGE program is to accelerate the development of safer and more effective methods to edit the genomes of disease-relevant somatic cells and tissues in patients.  For ethical, legal and safety reasons, the SCGE program does not support any research activities on genome editing in reproductive (germ) cells.");
        req.setAttribute("seoTitle","Search Result for " + searchTerm);
        req.setAttribute("filterMap", getFilterMap(req));

        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
          //  return "search/results";
    //    }
        return null;
    }
    @RequestMapping(value="/results/{category}")
    public String getResultsByCategory(HttpServletRequest req, HttpServletResponse res, Model model,
                             @PathVariable(required = false) String category, @RequestParam(required = false) String searchTerm) throws Exception {
        Person user=userService.getCurrentUser(req.getSession());
        boolean DCCNIHMember=access.isInDCCorNIHGroup(user);
        boolean consortiumMember=access.isConsortiumMember(user.getId());
        if(!DCCNIHMember) {
            List<Experiment> experiments = experimentDao.getExperimentsByPersonId(user.getId());
            experiments.addAll(experimentDao.getAllTier4Experiments());
            if (consortiumMember) {
                experiments.addAll(experimentDao.getAllTier3Experiments());
            }
            Set<Long> experimentIds=experiments.stream().map(experiment -> experiment.getExperimentId()).collect(Collectors.toSet());
            req.setAttribute("userAccessExperimentIds", experimentIds);
        }
        if(searchTerm==null || searchTerm.equals("")){
            searchTerm="";
        }
        List<String> categories=Arrays.asList(category);
        SearchResponse<Map> sr=services.getSearchResults(categories,searchTerm,getFilterMap(req), DCCNIHMember,consortiumMember);
        req.setAttribute("facets", Facet.displayNames);
        boolean facetSearch=false;
        if(req.getParameter("facetSearch")!=null)
        facetSearch= req.getParameter("facetSearch").equals("true");
        req.setAttribute("searchTerm", searchTerm);
        req.setAttribute("category",category);
        req.setAttribute("hits", services.getHits(sr));
        req.setAttribute("resultCount", sr.hits().total()!=null ? sr.hits().total().value() : 0L);
        String selectedView=req.getParameter("selectedView");
        if(selectedView==null || selectedView.equals("")){
           // selectedView="list";
            if(category!=null && (category.equalsIgnoreCase("experiment") || category.equalsIgnoreCase("project") || category.equalsIgnoreCase("publication"))){
                selectedView="list";
            }else selectedView="table";
        }
        req.setAttribute("selectedView",selectedView);
      /*  System.out.println("CATEGORY:" +category+"\nFacets ===============================");
        Iterator iterator= sr.getAggregations().iterator();
        while (iterator.hasNext()){
          Terms aggs= (Terms) iterator.next();
            System.out.println(aggs.getName()+"\t:"+ aggs.getBuckets().size());
        }*/
        Map<String, Object> aggregationMap = services.getAggregationView(sr);
        req.setAttribute("aggregations",aggregationMap);

        req.setAttribute("crumbTrailMap",   breadCrumb.getCrumbTrailMap(req,null,null, "search"));
        if(facetSearch) {

            if(getFilterMap(req).size()==1){
               SearchResponse<Map> oneCategoryFilterAggs= services.getFilteredAggregations(categories,searchTerm,getFilterMap(req), DCCNIHMember, consortiumMember);
               if(oneCategoryFilterAggs!=null) {
                   aggregationMap.putAll(services.getAggregationView(oneCategoryFilterAggs));
                   req.setAttribute("aggregations", aggregationMap);
               }

            }

        }
      if(searchTerm.equals("")){
          if(category.trim().equalsIgnoreCase("Study")) {
              req.setAttribute("action", "Studies");
              req.setAttribute("seoDescription","The goal of the SCGE program is to accelerate the development of safer and more effective methods to edit the genomes of disease-relevant somatic cells and tissues in patients.  For ethical, legal and safety reasons, the SCGE program does not support any research activities on genome editing in reproductive (germ) cells.");
              req.setAttribute("seoTitle","Projects");
          }
          if(category.trim().equalsIgnoreCase("Genome Editor")) {
              req.setAttribute("action", "Genome Editors");
              req.setAttribute("seoDescription","The goal of the SCGE program is to accelerate the development of safer and more effective methods to edit the genomes of disease-relevant somatic cells and tissues in patients.  For ethical, legal and safety reasons, the SCGE program does not support any research activities on genome editing in reproductive (germ) cells.");
              req.setAttribute("seoTitle","Genome Editors");
          }
          if(category.trim().equalsIgnoreCase("Model System")) {
              req.setAttribute("action", "Model Systems");
              req.setAttribute("seoDescription","The goal of the SCGE program is to accelerate the development of safer and more effective methods to edit the genomes of disease-relevant somatic cells and tissues in patients.  For ethical, legal and safety reasons, the SCGE program does not support any research activities on genome editing in reproductive (germ) cells.");
              req.setAttribute("seoTitle","Model Systems");
          }
          if(category.trim().equalsIgnoreCase("Delivery System")) {
              req.setAttribute("action", "Delivery Systems");
              req.setAttribute("seoDescription","The goal of the SCGE program is to accelerate the development of safer and more effective methods to edit the genomes of disease-relevant somatic cells and tissues in patients.  For ethical, legal and safety reasons, the SCGE program does not support any research activities on genome editing in reproductive (germ) cells.");
              req.setAttribute("seoTitle","Delivery Systems");
          }
          if(category.trim().equalsIgnoreCase("Guide")) {
              req.setAttribute("action", "Guides");
              req.setAttribute("seoDescription","The goal of the SCGE program is to accelerate the development of safer and more effective methods to edit the genomes of disease-relevant somatic cells and tissues in patients.  For ethical, legal and safety reasons, the SCGE program does not support any research activities on genome editing in reproductive (germ) cells.");
              req.setAttribute("seoTitle","Guides");
          }
          if(category.trim().equalsIgnoreCase("Vector")) {
              req.setAttribute("action", "Vectors");
              req.setAttribute("seoDescription","The goal of the SCGE program is to accelerate the development of safer and more effective methods to edit the genomes of disease-relevant somatic cells and tissues in patients.  For ethical, legal and safety reasons, the SCGE program does not support any research activities on genome editing in reproductive (germ) cells.");
              req.setAttribute("seoTitle","Vectors");
          }
          if(category.trim().equalsIgnoreCase("Protocol")) {
              req.setAttribute("action", "Protocols");
              req.setAttribute("seoDescription","The protocols deposited by Somatic Cell Genome Editing Consortium laboratories");
              req.setAttribute("seoTitle","Vectors");
          }
          if(category.trim().equalsIgnoreCase("Experiment")) {
              req.setAttribute("action", "Experiments");
              req.setAttribute("seoDescription","The goal of the SCGE program is to accelerate the development of safer and more effective methods to edit the genomes of disease-relevant somatic cells and tissues in patients.  For ethical, legal and safety reasons, the SCGE program does not support any research activities on genome editing in reproductive (germ) cells.");
              req.setAttribute("seoTitle","Experiments");
          }
          if(category.trim().equalsIgnoreCase("Project")) {
              req.setAttribute("action", "Projects");
              req.setAttribute("seoDescription","The goal of the SCGE program is to accelerate the development of safer and more effective methods to edit the genomes of disease-relevant somatic cells and tissues in patients.  For ethical, legal and safety reasons, the SCGE program does not support any research activities on genome editing in reproductive (germ) cells.");
              req.setAttribute("seoTitle","Projects");
          }
          if(category.trim().equalsIgnoreCase("Publication")) {
              req.setAttribute("action", "Publications");
              req.setAttribute("seoDescription","The goal of the SCGE program is to accelerate the development of safer and more effective methods to edit the genomes of disease-relevant somatic cells and tissues in patients.  For ethical, legal and safety reasons, the SCGE program does not support any research activities on genome editing in reproductive (germ) cells.");
              req.setAttribute("seoTitle","Publications");
          }
      }else {
          req.setAttribute("action", "Search Results");
          req.setAttribute("seoDescription","The goal of the SCGE program is to accelerate the development of safer and more effective methods to edit the genomes of disease-relevant somatic cells and tissues in patients.  For ethical, legal and safety reasons, the SCGE program does not support any research activities on genome editing in reproductive (germ) cells.");
          req.setAttribute("seoTitle","Search Results");
      }
                req.setAttribute("page", "/WEB-INF/jsp/search/results");
           //     req.setAttribute("filterMap", getFilterMap(req));
                req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
         /*   }
        }*/


        return null;
    }

    @RequestMapping(value="/results/{category1}/{category2}")
    public String getMultiCatResults(HttpServletRequest req, HttpServletResponse res, Model model,
                                       @PathVariable(required = false) String category1,  @PathVariable(required = false) String category2, @RequestParam(required = false) String searchTerm) throws Exception {
        Person user=userService.getCurrentUser(req.getSession());
        boolean DCCNIHMember=access.isInDCCorNIHGroup(user);
        boolean consortiumMember=access.isConsortiumMember(user.getId());
        if(!DCCNIHMember) {
            List<Experiment> experiments = experimentDao.getExperimentsByPersonId(user.getId());
            experiments.addAll(experimentDao.getAllTier4Experiments());
            if (consortiumMember) {
                experiments.addAll(experimentDao.getAllTier3Experiments());
            }
            Set<Long> experimentIds=experiments.stream().map(experiment -> experiment.getExperimentId()).collect(Collectors.toSet());
            req.setAttribute("userAccessExperimentIds", experimentIds);
        }
        List<String> categories=Arrays.asList(category1, category2);
        SearchResponse<Map> sr=services.getSearchResults(categories,searchTerm,getFilterMap(req), DCCNIHMember,consortiumMember);
        req.setAttribute("searchTerm", searchTerm);
        req.setAttribute("hits", services.getHits(sr));
        req.setAttribute("resultCount", sr.hits().total()!=null ? sr.hits().total().value() : 0L);
        Map<String, Object> aggregationMap = services.getAggregationView(sr);
        req.setAttribute("aggregations",aggregationMap);
        String selectedView=req.getParameter("selectedView");
        if(selectedView==null || selectedView.equals("")){
            selectedView="list";
        }
        req.setAttribute("selectedView",selectedView);
        req.setAttribute("crumbTrailMap",   breadCrumb.getCrumbTrailMap(req,null,null, "search"));
        req.setAttribute("action", "Studies And Experiments");
        req.setAttribute("seoDescription","The goal of the SCGE program is to accelerate the development of safer and more effective methods to edit the genomes of disease-relevant somatic cells and tissues in patients.  For ethical, legal and safety reasons, the SCGE program does not support any research activities on genome editing in reproductive (germ) cells.");
        req.setAttribute("seoTitle","Projects");

        req.setAttribute("facets", Facet.displayNames);


        req.setAttribute("page", "/WEB-INF/jsp/search/results");
        //     req.setAttribute("filterMap", getFilterMap(req));
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
         /*   }
        }*/
        return null;
    }
    public Map<String, String> getFilterMap(HttpServletRequest req) throws IOException {
        String unchecked= req.getParameter("unchecked");
        Map<String, String> filterMap=new HashMap<>();
        LinkedHashMap<String, String> selectedFilters=new LinkedHashMap<>();
        String filterJsonString=req.getParameter("selectedFiltersJson");

        if(filterJsonString!=null) {
            ObjectMapper mapper = new ObjectMapper();
            Map<String, String> filterJson = mapper.readValue(filterJsonString, Map.class);
            if (filterJson != null) {
                for (Map.Entry e : filterJson.entrySet()) {
                    List<String> filterValues= Arrays.asList(e.getValue().toString().split(","));
                    // System.out.println(e.getKey() + "\t" + e.getValue().toString());
                    String key= (String) e.getKey();
                    List<String> keyValues= new ArrayList<>();
                    if(selectedFilters.get(key)!=null)
                        keyValues.addAll(Arrays.asList(selectedFilters.get(key).split(",")));
                        for(String filterValue:filterValues){
                            if(unchecked!=null && !filterValue.equalsIgnoreCase(unchecked)){
                                if(!keyValues.contains(filterValue))
                                    keyValues.add(filterValue);
                            }
                        }
                    if(keyValues.size()>0)
                        selectedFilters.put(key, String.join(",", keyValues));
                }
            }
        }

        for(String param:Facet.facetParams)
        {
            if (req.getParameterValues(param) != null) {
                List<String> values = Arrays.asList(req.getParameterValues(param));
                List<String> keyValues= new ArrayList<>();
                if(selectedFilters.get(param)!=null)
                    keyValues.addAll(Arrays.asList(selectedFilters.get(param).split(",")));
                if (values.size() > 0) {
                    for(String val:values){
                        if(!keyValues.contains(val)){
                            keyValues.add(val);
                        }
                    }
                    filterMap.put(param, String.join(",", keyValues));
                    selectedFilters.put(param, String.join(",", keyValues));
                }
                }
            }
        req.setAttribute("selectedFilters", selectedFilters);
        req.setAttribute("selectedFiltersJson" , gson.toJson(selectedFilters));

        return filterMap;
    }



}
