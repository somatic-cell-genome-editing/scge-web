package edu.mcw.scge.controller;

import com.google.gson.Gson;
import edu.mcw.scge.service.es.ESClient;
import edu.mcw.scge.web.SCGEContext;
import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.common.text.Text;
import org.elasticsearch.index.query.BoolQueryBuilder;
import org.elasticsearch.index.query.DisMaxQueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.builder.SearchSourceBuilder;
import org.elasticsearch.search.fetch.subphase.highlight.HighlightBuilder;
import org.elasticsearch.search.fetch.subphase.highlight.HighlightField;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

@Controller
@RequestMapping(value="/data/")
public class AutocompleteController {
    @RequestMapping(value="autocomplete" , method = RequestMethod.GET)
    public String getAutocompleteTerms(HttpServletRequest req, HttpServletResponse res){
        List<String> autocompleteList=new ArrayList<>();
        String searchTerm=req.getParameter("searchTerm");
        System.out.println("AUTOCOMPLETE WORKING: "+ searchTerm);

        if(searchTerm!=null && !searchTerm.equals("")) {
            searchTerm = searchTerm.replaceAll("/", "\\/");
            DisMaxQueryBuilder qb = new DisMaxQueryBuilder();
            BoolQueryBuilder query = new BoolQueryBuilder();
            query.must(qb);
            qb.add(QueryBuilders.multiMatchQuery( searchTerm));
                    /*,
                    "type", "subtype",
                    "name.ngram", "symbol", "species", "sex", "tissueTerm", "tissueIds", "termSynonyms", "cellType"));
*/

            query.must(qb);
          SearchSourceBuilder srb = new SearchSourceBuilder();
            srb.query(query);
            srb.highlighter(this.buildHighlights());

            srb.size(1000);
            SearchRequest searchRequest = new SearchRequest(SCGEContext.getESIndexName());
            searchRequest.source(srb);
            SearchResponse sr = null;
            try {
                sr = ESClient.getClient().search(searchRequest, RequestOptions.DEFAULT);
            } catch (IOException e) {
                e.printStackTrace();
            }

            if (sr != null) {
                for (SearchHit h : sr.getHits().getHits()) {
                    for (Map.Entry e : h.getHighlightFields().entrySet()) {
                        HighlightField field = (HighlightField) e.getValue();
                        for (Text s : field.fragments()) {
                            //     System.out.println(s);
                            String str = s.toString().replace("<em>", "<strong>")
                                    .replace("</em>", "</strong>");
                            if (!autocompleteList.contains(str))
                               autocompleteList.add(str);
                        }
                    }
                }

            }
            Gson gson = new Gson();
            String autoList = gson.toJson(autocompleteList);
            System.out.println("AUTO LIST:"+autoList);
            try {
                res.getWriter().write(autoList);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return null;
    }
    public HighlightBuilder buildHighlights(){
        List<String> fields=new ArrayList<>(Arrays.asList(
                "type.ngram", "subtype.ngram", "name.ngram", "symbol.ngram"
        ));
        HighlightBuilder hb=new HighlightBuilder();
      /*  for(String field:fields){
            hb.field(field);
        }*/
      hb.field("*");
        return hb;
    }
}
