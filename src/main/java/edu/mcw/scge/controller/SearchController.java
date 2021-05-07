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
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value="/data/search")
public class SearchController{
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

        SearchResponse sr=services.getSearchResults("", searchTerm, null,DCCNIHMember);
        boolean facetSearch=false;
        if(req.getParameter("facetSearch")!=null)
            facetSearch= req.getParameter("facetSearch").equals("true");        req.setAttribute("sr", sr);
        req.setAttribute("searchTerm", searchTerm);
        req.setAttribute("aggregations",services.getSearchAggregations(sr));
        if(facetSearch)
         //   return "search/resultsTable";
        //    return "search/resultsView";
            return "search/resultsPage";
        else {
            req.setAttribute("action", "Search Results: " + sr.getHits().getTotalHits() + " for " + searchTerm);
            req.setAttribute("page", "/WEB-INF/jsp/search/results");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
          //  return "search/results";
        }
        return null;
    }
    @RequestMapping(value="/results/{category}")
    public String getResultsByCategory(HttpServletRequest req, HttpServletResponse res, Model model,
                             @PathVariable(required = false) String category, @RequestParam(required = false) String searchTerm) throws Exception {
        Person user=userService.getCurrentUser(req.getSession());
        boolean DCCNIHMember=access.isInDCCorNIHGroup(user);
      /*  String type=req.getParameter("type");
        String subType=req.getParameter("subType");
        String editorType=req.getParameter("editorType");
        String dsType=req.getParameter("dsType");
        String modelType=req.getParameter("modelType");
        System.out.println("CATEOGRY:"+ category+"\n"+
                "TYPE:"+type+"\n"+
                "SUBTYPE:"+ subType+"\n"+
                "EDITOR TYPE:"+editorType+"\n"+
                "Delivery TYPE:"+ dsType+"\n"+
                "Model TYpe:"+ modelType);*/

        SearchResponse sr=services.getSearchResults(category,searchTerm,getFilterMap(req), DCCNIHMember);
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
            //  return "search/resultsTable";
            //      return "search/resultsView";
            if(getFilterMap(req).size()==1){
               SearchResponse searchResponse= services.getFilteredAggregations(category,searchTerm,getFilterMap(req), DCCNIHMember);
               if(searchResponse!=null) {
                   Map<String, List<Terms.Bucket>> filtered = services.getSearchAggregations(searchResponse);
                   aggregations.putAll(filtered);
                   req.setAttribute("aggregations", aggregations);
                   //   return "search/resultsView";
               }

            }
            return "search/resultsPage";
        }
        else{
            if(filter){

             //   return "search/resultsView";
                return "search/resultsPage";

            }else {
                req.setAttribute("action", "Search Results");
                req.setAttribute("page", "/WEB-INF/jsp/search/results");
                req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            }
        }
        return null;
    }
    public Map<String, String> getFilterMap(HttpServletRequest req){
        Map<String, String> filterMap=new HashMap<>();
        String type=req.getParameter("type");
        String subType=req.getParameter("subType");
        String editorType=req.getParameter("editorType");
        String dsType=req.getParameter("dsType");
        String modelType=req.getParameter("modelType");
        if(type!=null && !type.equals(""))filterMap.put("type", type);
        if(subType!=null && !subType.equals(""))filterMap.put("subType", subType);
        if(editorType!=null && !editorType.equals(""))filterMap.put("editors.type", editorType);
        if(dsType!=null && !dsType.equals(""))filterMap.put("deliveries.type",dsType);
        if(modelType!=null && !modelType.equals(""))  filterMap.put("models.type", modelType);

        return filterMap;
    }



}
