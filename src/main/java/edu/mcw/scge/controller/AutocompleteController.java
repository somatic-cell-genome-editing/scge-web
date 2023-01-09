package edu.mcw.scge.controller;

import com.google.gson.Gson;
import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.configuration.UserService;
import edu.mcw.scge.datamodel.Person;
import edu.mcw.scge.service.es.ESClient;
import edu.mcw.scge.service.es.IndexServices;
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
import java.nio.charset.StandardCharsets;
import java.util.*;

@Controller
@RequestMapping(value="/data/")
public class AutocompleteController {
    IndexServices services=new IndexServices();
    Access access=new Access();
    UserService userService=new UserService();
    @RequestMapping(value="autocomplete" , method = RequestMethod.GET)
    public String getAutocompleteTerms(HttpServletRequest req, HttpServletResponse res) throws Exception {
        LinkedHashMap<String, String> autocompleteList=new LinkedHashMap<>();
        String searchTerm=req.getParameter("searchTerm");
        Person user=userService.getCurrentUser(req.getSession());
        boolean DCCNIHMember=access.isInDCCorNIHGroup(user);
        boolean consortiumMember=access.isConsortiumMember(user.getId());


        if(searchTerm!=null && !searchTerm.equals("")) {
            searchTerm = searchTerm.replaceAll("/", "\\/");
            SearchResponse sr=services.getSearchResults(null, searchTerm, null,DCCNIHMember,consortiumMember);
            if (sr != null) {
                for (SearchHit h : sr.getHits().getHits()) {
                    for (Map.Entry e : h.getHighlightFields().entrySet()) {
                        HighlightField field = (HighlightField) e.getValue();
                        for (Text s : field.fragments()) {
                               System.out.println(s.bytes().utf8ToString());
                            String str = s.toString().replace("<em>", "<strong>")
                                    .replace("</em>", "</strong>");
                            autocompleteList.put(str,"");
                        }
                    }
                }

            }
            Gson gson = new Gson();
            String autoList = gson.toJson(autocompleteList.keySet());
           // System.out.println("AUTO LIST:"+autoList);
            try {
                res.setContentType ("text/html;charset=utf-8");
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
