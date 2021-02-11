package edu.mcw.scge.controller;

import edu.mcw.scge.service.es.IndexServices;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.search.SearchHit;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@Controller
@RequestMapping(value="/data/search")
public class SearchController{
    IndexServices services=new IndexServices();
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
    public String getResults(HttpServletRequest req, HttpServletResponse res, @RequestParam(required = false) String searchTerm) throws ServletException, IOException {
        SearchResponse sr=services.getSearchResults("", searchTerm, "", "");
        boolean facetSearch=false;
        if(req.getParameter("facetSearch")!=null)
            facetSearch= req.getParameter("facetSearch").equals("true");        req.setAttribute("sr", sr);
        req.setAttribute("searchTerm", searchTerm);
        req.setAttribute("aggregations",services.getSearchAggregations(sr));
        if(facetSearch)
            return "search/resultsTable";
        else {
            req.setAttribute("action", "Search Results: " + sr.getHits().getTotalHits() + " for " + searchTerm);
            req.setAttribute("page", "/WEB-INF/jsp/search/results");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        }
        return null;
    }
    @RequestMapping(value="/results/{category}")
    public String getResultsByCategory(HttpServletRequest req, HttpServletResponse res, Model model,
                             @PathVariable(required = false) String category, @RequestParam(required = false) String searchTerm) throws ServletException, IOException {
        String type=req.getParameter("type");
        String subType=req.getParameter("subType");
        SearchResponse sr=services.getSearchResults(category,searchTerm, type, subType);
        boolean facetSearch=false;
        if(req.getParameter("facetSearch")!=null)
        facetSearch= req.getParameter("facetSearch").equals("true");
        req.setAttribute("searchTerm", searchTerm);
        req.setAttribute("category",category);
        req.setAttribute("sr", sr);
        req.setAttribute("aggregations",services.getSearchAggregations(sr));
        if(facetSearch)
        return "search/resultsTable";
        else{
             req.setAttribute("action", "Search Results");
               req.setAttribute("page", "/WEB-INF/jsp/search/resultsTable");
              req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        }
        return null;
    }


}
