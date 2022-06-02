package edu.mcw.scge.controller;

import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.configuration.UserService;
import edu.mcw.scge.datamodel.Person;
import edu.mcw.scge.service.es.IndexServices;
import edu.mcw.scge.web.utils.BreadCrumbImpl;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.security.user.User;
import org.elasticsearch.search.SearchHit;
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
    private final RequestCache requestCache = new HttpSessionRequestCache();
    IndexServices services=new IndexServices();
    Access access=new Access();
    UserService userService=new UserService();
    BreadCrumbImpl breadCrumb=new BreadCrumbImpl();
    @RequestMapping(value="/delivery/results")
    public String getDeliveryResults(HttpServletRequest req, HttpServletResponse res, Model model) throws ServletException, IOException {
        SearchResponse sr=services.getSearchResponse();
        req.setAttribute("sr", sr);
        req.setAttribute("aggregations",services.getAggregations(sr));
        req.setAttribute("action", "Delivery Systems Results");
        req.setAttribute("page", "/WEB-INF/jsp/tools/results");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
    @RequestMapping(value="/results")
    public String getResults(HttpServletRequest req, HttpServletResponse res, @RequestParam(required = false) String searchTerm) throws Exception {
        Person user=userService.getCurrentUser(req.getSession());
        boolean DCCNIHMember=access.isInDCCorNIHGroup(user);
        boolean consortiumMember=access.isConsortiumMember(user.getId());
        SearchResponse sr=services.getSearchResults("", searchTerm, getFilterMap(req),DCCNIHMember,consortiumMember);

        boolean facetSearch=false;
        if(req.getParameter("facetSearch")!=null)
            facetSearch= req.getParameter("facetSearch").equals("true");
        req.setAttribute("sr", sr);
        req.setAttribute("searchTerm", searchTerm);
        Map<String, List<Terms.Bucket>>aggregations=services.getSearchAggregations(sr);

        req.setAttribute("aggregations",aggregations);
        if(facetSearch) {
            //   return "search/resultsTable";
            //    return "search/resultsView";
            if(getFilterMap(req).size()==1){
                SearchResponse searchResponse= services.getFilteredAggregations("",searchTerm,getFilterMap(req), DCCNIHMember,consortiumMember);
                if(searchResponse!=null) {
                    Map<String, List<Terms.Bucket>> filtered = services.getSearchAggregations(searchResponse);
                    aggregations.putAll(filtered);
                    req.setAttribute("aggregations", aggregations);
                    //   return "search/resultsView";
                }

            }
       //     return "search/resultsPage";
        }
    //    else {
            req.setAttribute("action", "Search Results: " + sr.getHits().getTotalHits() + " for " + searchTerm);
            req.setAttribute("page", "/WEB-INF/jsp/search/results");
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

        SearchResponse sr=services.getSearchResults(category,searchTerm,getFilterMap(req), DCCNIHMember,consortiumMember);
        boolean facetSearch=false;
        boolean filter=false;
        if(req.getParameter("facetSearch")!=null)
        facetSearch= req.getParameter("facetSearch").equals("true");
        if(req.getParameter("filter")!=null)
            filter=req.getParameter("filter").equals("true");
        req.setAttribute("searchTerm", searchTerm);
        req.setAttribute("category",category);
        req.setAttribute("sr", sr);
        Map<String, List<Terms.Bucket>>aggregations=services.getSearchAggregations(sr);
        req.setAttribute("aggregations",aggregations);

        req.setAttribute("crumbTrailMap",   breadCrumb.getCrumbTrailMap(req,null,null, "search"));
        if(facetSearch) {
            System.out.println("FACET SEARCH: "+ facetSearch);
            //  return "search/resultsTable";
            //      return "search/resultsView";
            if(getFilterMap(req).size()==1){
               SearchResponse searchResponse= services.getFilteredAggregations(category,searchTerm,getFilterMap(req), DCCNIHMember, consortiumMember);
               if(searchResponse!=null) {
                   Map<String, List<Terms.Bucket>> filtered = services.getSearchAggregations(searchResponse);
                   aggregations.putAll(filtered);
                   req.setAttribute("aggregations", aggregations);
                   //   return "search/resultsView";
               }

            }
         //   return "search/resultsPage";
        }
      /*  else{
            if(filter){
                return "search/resultsPage";

            }else {*/
      if(searchTerm.equals("")){
          req.setAttribute("action", category);

      }else
                req.setAttribute("action", "Search Results");
                req.setAttribute("page", "/WEB-INF/jsp/search/results");
           //     req.setAttribute("filterMap", getFilterMap(req));
                req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
         /*   }
        }*/
        return null;
    }
    public Map<String, String> getFilterMap(HttpServletRequest req){
        Map<String, String> filterMap=new HashMap<>();
        Map<String, String> mappings=new HashMap<>();
        Map<String, String> selectedFilters=new HashMap<>();
        mappings.put("typeBkt","type");
        mappings.put("subtypeBkt","subType");
        mappings.put( "editorTypeBkt","editorType");
        mappings.put("editorSubTypeBkt","editorSubType");
        mappings.put("editorSpeciesBkt","editorSpecies");

        mappings.put("dsTypeBkt","deliveryType");

       mappings.put("modelTypeBkt","modelType");
       mappings.put("modelSpeciesBkt","modelOrganism");
       mappings.put( "reporterBkt","transgeneReporter");

       mappings.put("targetBkt", "tissueTerm");
        mappings.put("guideTargetLocusBkt","guideTargetLocus");
       mappings.put("speciesBkt","modelOrganism");
       mappings.put("withExperimentsBkt","withExperiments");

       mappings.put(  "vectorBkt","vectorName");
       mappings.put("vectorSubTypeBkt","vectorSubtype");
       mappings.put("vectorTypeBkt","vectorType");


        mappings.put(  "accessBkt","access");
        mappings.put("statusBkt","status");
        mappings.put("piBkt","pi");
    /*    List<String> params=new ArrayList<>( Arrays.asList("typeBkt", "subtypeBkt",
                "editorTypeBkt","editorSubTypeBkt", "editorSpeciesBkt"
               , "dsTypeBkt", "modelTypeBkt", "modelSpeciesBkt", "reporterBkt",
                "vectorBkt", "vectorTypeBkt","vectorSubTypeBkt",
                "targetBkt", "guideTargetLocusBkt", "speciesBkt","withExperimentsBkt"));
*/
        for(Map.Entry e:mappings.entrySet())
        {
            String param= (String) e.getKey();
            if (req.getParameterValues(param) != null) {
                List<String> values = Arrays.asList(req.getParameterValues(param));
                if (values.size() > 0) {
                    filterMap.put((String) e.getValue(), String.join(",", values));
                    selectedFilters.put((String) e.getKey(), String.join(",", values));
                }
                }
            }
        req.setAttribute("selectedFilters", selectedFilters);
     /*   if(req.getParameterValues("subTypeBkt")!=null) {
            List<String> subType = Arrays.asList(req.getParameter("subType"));
        }
        String editorType=req.getParameter("editorType");
        String editorSubType=req.getParameter("editorSubType");
        String editorSpecies=req.getParameter("editorSpecies");

        String dsType=req.getParameter("dsType");
        String modelType=req.getParameter("modelType");
        String modelSpeices=req.getParameter("modelSpecies");
        String reporter=req.getParameter("reporter");

        String vector=req.getParameter("vector");
        String vectorType=req.getParameter("vectorType");
        String vectorSubType=req.getParameter("vectorSubType");

        String target=req.getParameter("target");
        String guideTargetLocus=req.getParameter("guideTargetLocus");
        String speciesType=req.getParameter("speciesType");
        String withExperiments=req.getParameter("withExperiments");



        if(subType!=null && !subType.equals(""))filterMap.put("subType", subType);
        if(editorType!=null && !editorType.equals(""))filterMap.put("editors.type", editorType);
        if(editorSubType!=null && !editorSubType.equals(""))filterMap.put("editors.subType", editorSubType);
        if(editorSpecies!=null && !editorSpecies.equals(""))filterMap.put("editors.species", editorSpecies);

        if(dsType!=null && !dsType.equals(""))filterMap.put("deliveries.type",dsType);
        if(modelType!=null && !modelType.equals(""))  filterMap.put("models.type", modelType);
        if(modelSpeices!=null && !modelSpeices.equals(""))  filterMap.put("models.organism", modelSpeices);
        if(reporter!=null && !reporter.equals(""))  filterMap.put("models.transgeneReporter", reporter);

        if(target!=null && !target.equals(""))  filterMap.put("target", target);
        if(guideTargetLocus!=null && !guideTargetLocus.equals(""))  filterMap.put("guides.targetLocus", guideTargetLocus);
        if(speciesType!=null && !speciesType.equals(""))  filterMap.put("species", speciesType);
        if(withExperiments!=null && !withExperiments.equals(""))  filterMap.put("withExperiments", withExperiments);

        if(vector!=null && !vector.equals(""))filterMap.put("vectors.name", vector);
        if(vectorSubType!=null && !vectorSubType.equals(""))filterMap.put("vectors.subtype", vectorSubType);
        if(vectorType!=null && !vectorType.equals(""))filterMap.put("vectors.type", vectorType);*/
     System.out.println("filter Map:" + filterMap.toString());
        return filterMap;
    }



}
