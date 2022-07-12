package edu.mcw.scge.controller;

import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.configuration.UserService;
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
        //req.setAttribute("seoDescription",guide.getGuideDescription());
        req.setAttribute("seoTitle","Delivery System Search");
        req.setAttribute("page", "/WEB-INF/jsp/tools/results");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
    @RequestMapping(value="/results")
    public String getResults(HttpServletRequest req, HttpServletResponse res, @RequestParam(required = false) String searchTerm) throws Exception {
        Person user=userService.getCurrentUser(req.getSession());
        boolean DCCNIHMember=access.isInDCCorNIHGroup(user);
        boolean consortiumMember=access.isConsortiumMember(user.getId());
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

     //   req.setAttribute("aggregations",aggregations);
        if(facetSearch) {
            //   return "search/resultsTable";
            //    return "search/resultsView";
            if(getFilterMap(req).size()==1){
                SearchResponse searchResponse= services.getFilteredAggregations(null,searchTerm,getFilterMap(req), DCCNIHMember,consortiumMember);
                if(getFilterMap(req).size()==1){
                    SearchResponse oneCategoryFilterAggs= services.getFilteredAggregations(null,searchTerm,getFilterMap(req), DCCNIHMember, consortiumMember);
                    if(oneCategoryFilterAggs!=null) {
                        Map<String, Aggregation> oneCategoryAggs=  oneCategoryFilterAggs.getAggregations().asMap();
                        for(Map.Entry e:oneCategoryAggs.entrySet()){
                            aggregationMap.put((String)e.getKey(), (Aggregation) e.getValue());

                        }
                        req.setAttribute("aggregations", aggregationMap);
                    }

                }

            }
       //     return "search/resultsPage";
        }
    //    else {
            req.setAttribute("action", sr.getHits().getTotalHits() + " results for " + searchTerm);
            req.setAttribute("page", "/WEB-INF/jsp/search/results");
        req.setAttribute("filterMap", getFilterMap(req));
        //req.setAttribute("seoDescription",guide.getGuideDescription());
        req.setAttribute("seoTitle","Search Results");

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
        List<String> categories=Arrays.asList(category);
        SearchResponse sr=services.getSearchResults(categories,searchTerm,getFilterMap(req), DCCNIHMember,consortiumMember);
        req.setAttribute("facets", Facet.displayNames);
        boolean facetSearch=false;
        if(req.getParameter("facetSearch")!=null)
        facetSearch= req.getParameter("facetSearch").equals("true");
        req.setAttribute("searchTerm", searchTerm);
        req.setAttribute("category",category);
        req.setAttribute("sr", sr);
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
              req.setAttribute("seoDescription","Database of study and experiment data generated by the Somatic Cell Genome Editing Consortium");
              req.setAttribute("seoTitle","Studies");
              req.setAttribute("action", "Studies");
          } else if(category.trim().equalsIgnoreCase("Genome Editor")) {
              req.setAttribute("seoDescription","Database of study and experiment data generated by the Somatic Cell Genome Editing Consortium");
              req.setAttribute("seoTitle","Genome Editors");
              req.setAttribute("action", "Genome Editors");
          } else if(category.trim().equalsIgnoreCase("Model System")) {
              req.setAttribute("seoDescription","Database of study and experiment data generated by the Somatic Cell Genome Editing Consortium");
              req.setAttribute("seoTitle","Model Systems");
              req.setAttribute("action", "Model Systems");
          }else if(category.trim().equalsIgnoreCase("Delivery System")) {
              req.setAttribute("seoDescription","Database of study and experiment data generated by the Somatic Cell Genome Editing Consortium");
              req.setAttribute("seoTitle","Delivery Systems");
              req.setAttribute("action", "Delivery Systems");
          }else if(category.trim().equalsIgnoreCase("Guide")) {
              req.setAttribute("seoDescription","Database of study and experiment data generated by the Somatic Cell Genome Editing Consortium");
              req.setAttribute("seoTitle","Guides");
              req.setAttribute("action", "Guides");
          }else if(category.trim().equalsIgnoreCase("Vector")) {
              req.setAttribute("seoDescription","Database of study and experiment data generated by the Somatic Cell Genome Editing Consortium");
              req.setAttribute("seoTitle","Vectors");
              req.setAttribute("action", "Vectors");
          }else if(category.trim().equalsIgnoreCase("Experiment")) {
              req.setAttribute("seoDescription","Database of study and experiment data generated by the Somatic Cell Genome Editing Consortium");
              req.setAttribute("seoTitle","Experiments");
              req.setAttribute("action", "Experiments");
          }

      }else {
          req.setAttribute("seoDescription", "Database of study and experiment data generated by the Somatic Cell Genome Editing Consortium");
          req.setAttribute("seoTitle", "Search Results");
          req.setAttribute("action", "Search Result");
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
        List<String> categories=Arrays.asList(category1, category2);
        SearchResponse sr=services.getSearchResults(categories,searchTerm,getFilterMap(req), DCCNIHMember,consortiumMember);
        boolean facetSearch=false;
        if(req.getParameter("facetSearch")!=null)
            facetSearch= req.getParameter("facetSearch").equals("true");
        req.setAttribute("searchTerm", searchTerm);
        req.setAttribute("sr", sr);
        Map<String, List<Terms.Bucket>>aggregations=services.getSearchAggregations(sr);
        Map<String, Aggregation> aggregationMap = new HashMap<>(sr.getAggregations().asMap());
        req.setAttribute("aggregations",aggregationMap);

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



        req.setAttribute("seoDescription","Database of study and experiment data generated by the Somatic Cell Genome Editing Consortium");
        req.setAttribute("seoTitle","Studies and Experiments");
        req.setAttribute("page", "/WEB-INF/jsp/search/results");
        //     req.setAttribute("filterMap", getFilterMap(req));
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
         /*   }
        }*/
        return null;
    }
    public Map<String, String> getFilterMap(HttpServletRequest req){
        Map<String, String> filterMap=new HashMap<>();
        Map<String, String> selectedFilters=new HashMap<>();
        for(String param:Facet.facetParams)
        {
            if (req.getParameterValues(param) != null) {
                List<String> values = Arrays.asList(req.getParameterValues(param));
                if (values.size() > 0) {
                    filterMap.put(param, String.join(",", values));
                    selectedFilters.put(param, String.join(",", values));
                }
                }
            }
        req.setAttribute("selectedFilters", selectedFilters);

     System.out.println("filter Map:" + filterMap.toString());
        return filterMap;
    }



}
