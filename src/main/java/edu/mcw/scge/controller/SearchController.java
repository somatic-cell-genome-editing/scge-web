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
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.security.user.User;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.aggregations.Aggregation;
import org.elasticsearch.search.aggregations.Aggregations;
import org.elasticsearch.search.aggregations.bucket.terms.Terms;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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
        SearchResponse sr=services.getSearchResults(null, searchTerm, getFilterMap(req),DCCNIHMember,consortiumMember);

        boolean facetSearch=false;
        if(req.getParameter("facetSearch")!=null)
            facetSearch= req.getParameter("facetSearch").equals("true");
        req.setAttribute("sr", sr);
        req.setAttribute("searchTerm", searchTerm);
     //   Map<String, List<Terms.Bucket>>aggregations=services.getSearchAggregations(sr);
        Aggregations aggs=sr.getAggregations();
        Map<String, Aggregation> aggregationMap = new HashMap<>(aggs.asMap());
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
                    SearchResponse oneCategoryFilterAggs= services.getFilteredAggregations(null,searchTerm,getFilterMap(req), DCCNIHMember, consortiumMember);
                    if(oneCategoryFilterAggs!=null) {
                        Map<String, Aggregation> oneCategoryAggs=  oneCategoryFilterAggs.getAggregations().asMap();
                        for(Map.Entry e:oneCategoryAggs.entrySet()){
                            aggregationMap.put((String)e.getKey(), (Aggregation) e.getValue());

                        }
                        req.setAttribute("aggregations", aggregationMap);
                    }

                }else{
                    SearchResponse categoryAggs= services.getFilteredAggregations(null,searchTerm,getFilterMap(req), DCCNIHMember, consortiumMember);
                    if(categoryAggs!=null) {
                        Map<String, Aggregation> oneCategoryAggs=  categoryAggs.getAggregations().asMap();
                        for(Map.Entry e:oneCategoryAggs.entrySet()){
                            aggregationMap.put((String)e.getKey(), (Aggregation) e.getValue());

                        }
                        req.setAttribute("aggregations", aggregationMap);
                    }
                }

           // }
       //     return "search/resultsPage";
        }
    //    else {
        req.setAttribute("facets", Facet.displayNames);

        req.setAttribute("action", sr.getHits().getTotalHits().value + " results for " + searchTerm);
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
        List<String> categories=Arrays.asList(category);
        SearchResponse sr=services.getSearchResults(categories,searchTerm,getFilterMap(req), DCCNIHMember,consortiumMember);
        req.setAttribute("facets", Facet.displayNames);
        boolean facetSearch=false;
        if(req.getParameter("facetSearch")!=null)
        facetSearch= req.getParameter("facetSearch").equals("true");
        req.setAttribute("searchTerm", searchTerm);
        req.setAttribute("category",category);
        req.setAttribute("sr", sr);
        String selectedView=req.getParameter("selectedView");
        if(selectedView==null || selectedView.equals("")){
           // selectedView="list";
            if(category!=null && (category.equalsIgnoreCase("experiment") || category.equalsIgnoreCase("project"))){
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
     //   Map<String, List<Terms.Bucket>>aggregations=services.getSearchAggregations(sr);
        Aggregations aggs=sr.getAggregations();
        Map<String, Aggregation> aggregationMap = new HashMap<>(aggs.asMap());
        req.setAttribute("aggregations",aggregationMap);

        req.setAttribute("crumbTrailMap",   breadCrumb.getCrumbTrailMap(req,null,null, "search"));
        if(facetSearch) {

            if(getFilterMap(req).size()==1){
               SearchResponse oneCategoryFilterAggs= services.getFilteredAggregations(categories,searchTerm,getFilterMap(req), DCCNIHMember, consortiumMember);
               if(oneCategoryFilterAggs!=null) {
                 Map<String, Aggregation> oneCategoryAggs=  oneCategoryFilterAggs.getAggregations().asMap();
                 for(Map.Entry e:oneCategoryAggs.entrySet()){
                      aggregationMap.put((String)e.getKey(), (Aggregation) e.getValue());

                  }
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
        SearchResponse sr=services.getSearchResults(categories,searchTerm,getFilterMap(req), DCCNIHMember,consortiumMember);
        req.setAttribute("searchTerm", searchTerm);
        req.setAttribute("sr", sr);
        Map<String, Aggregation> aggregationMap = new HashMap<>(sr.getAggregations().asMap());
        req.setAttribute("aggregations",aggregationMap);
        String selectedView=req.getParameter("selectedView");
        if(selectedView==null || selectedView.equals("")){
            selectedView="list";
        }
        req.setAttribute("selectedView",selectedView);
        req.setAttribute("crumbTrailMap",   breadCrumb.getCrumbTrailMap(req,null,null, "search"));
      /*  if(facetSearch) {
            System.out.println("FACET SEARCH: "+ facetSearch);
            if(getFilterMap(req).size()==1){
                SearchResponse searchResponse= services.getFilteredAggregations(categories,searchTerm,getFilterMap(req), DCCNIHMember, consortiumMember);
                if(searchResponse!=null) {
                    Map<String, List<Terms.Bucket>> filtered = services.getSearchAggregations(searchResponse);
                    aggregations.putAll(filtered);
                    req.setAttribute("aggregations", aggregations);
                }

            }

        }
*/
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
