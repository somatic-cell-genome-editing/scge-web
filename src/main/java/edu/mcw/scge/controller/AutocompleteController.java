package edu.mcw.scge.controller;

import com.google.gson.Gson;
import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.configuration.UserService;
import edu.mcw.scge.datamodel.Person;
import edu.mcw.scge.service.es.IndexServices;
import co.elastic.clients.elasticsearch.core.SearchResponse;
import co.elastic.clients.elasticsearch.core.search.Hit;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
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
            SearchResponse<Map> sr=services.getSearchResults(null, searchTerm, null,DCCNIHMember,consortiumMember);
            if (sr != null) {
                for (Hit<Map> h : sr.hits().hits()) {
                    for (Map.Entry<String, List<String>> e : h.highlight().entrySet()) {
                        for (String fragment : e.getValue()) {
                            String str = fragment.replace("<em>", "<strong>")
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
}
