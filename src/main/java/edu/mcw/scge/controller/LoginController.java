package edu.mcw.scge.controller;


import com.google.gson.Gson;
import edu.mcw.scge.dao.implementation.GroupDAO;
import edu.mcw.scge.dao.implementation.PersonDao;
import edu.mcw.scge.datamodel.Person;
import edu.mcw.scge.datamodel.PersonInfo;
import edu.mcw.scge.service.DataAccessService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ResolvableType;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;

import org.springframework.security.oauth2.client.OAuth2AuthorizedClient;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientService;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.security.oauth2.client.registration.ClientRegistration;
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository;

import org.springframework.stereotype.Controller;

import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;


import java.util.*;


/**
 * Created by jthota on 8/9/2019.
 */
@Controller

public class LoginController{

    private static final String authorizationRequestBaseUri = "login";
    Map<String, String> oauth2AuthenticationUrls = new HashMap<>();
    DataAccessService service=new DataAccessService();
    PersonDao pdao=new PersonDao();
    @Autowired
   private ClientRegistrationRepository clientRegistrationRepository;
    @Autowired
    private OAuth2AuthorizedClientService authorizedClientService;

    @RequestMapping("/oauth_login")
    public String getLoginPage(OAuth2AuthenticationToken authentication) throws Exception {
      Iterable<ClientRegistration> clientRegistrations = null;
        ResolvableType type = ResolvableType.forInstance(clientRegistrationRepository)
                .as(Iterable.class);
        if (type != ResolvableType.NONE && ClientRegistration.class.isAssignableFrom(type.resolveGenerics()[0])) {
            clientRegistrations = (Iterable<ClientRegistration>) clientRegistrationRepository;
        }
      /* clientRegistrations.forEach(clientRegistration -> System.out.println(clientRegistration.getClientId()+"\n"+clientRegistration.getClientSecret()+"\n"+
               clientRegistration.getProviderDetails().getAuthorizationUri()+"\nSCOPES: "+clientRegistration.getScopes().toString()));*/

        clientRegistrations.forEach(registration -> oauth2AuthenticationUrls.put(registration.getClientName(), authorizationRequestBaseUri + "/" + registration.getRegistrationId()));
        //model.addAttribute("urls", oauth2AuthenticationUrls);

       return "redirect:/";

    }

    @RequestMapping("/loginSuccess")
    public String getHomePage(OAuth2AuthenticationToken authentication, HttpServletRequest req) throws Exception {
        HttpSession session = req.getSession(true);
        Map<String, List<Integer>> plotData = service.getPlotData();
        Gson gson = new Gson();
        req.setAttribute("plotData", plotData);
        req.setAttribute("labels", gson.toJson(DataAccessService.labels));
        req.setAttribute("page", "/WEB-INF/jsp/tools/home");
        return "base";
    }

    @RequestMapping("/loginSuccessPage")
    public String verifyAuthentication(@ModelAttribute("userAttributes") Map userAttributes,@ModelAttribute("personInfoRecords") List<PersonInfo> personInfoRecords, HttpServletRequest req) throws Exception {
        boolean userExists = verifyUserExists(userAttributes.get("sub").toString(), userAttributes.get("email").toString());
        if (userExists) {
                    String userStatus = pdao.getPersonStatus(userAttributes.get("sub").toString());
                    if (userStatus.equalsIgnoreCase("active")) {
                        HttpSession session = req.getSession(true);
                        List<Person> persons = pdao.getPersonByGoogleId(userAttributes.get("sub").toString());
                        int personId = 0;
                        if (persons.size() > 0)
                            personId = persons.get(0).getId();
                        session.setAttribute("userAttributes",userAttributes);
                        session.setAttribute("personId", personId);
                        session.setAttribute("personInfoList", personInfoRecords);
                        req.setAttribute("personInfoList", personInfoRecords);
                      /*  System.out.println("PersonInoRecords size: "+personInfoRecords.size() );
                        for(PersonInfo i:personInfoRecords){
                            System.out.println(i.getGrantInitiative() +"\t"+ i.getGrantTitle()+"\t"+ i.getGroupName()+"\tGROUPID:"+i.getGroupId()+"\t"+ i.getSubGroupName() +"\tSUBGROUP ID:"+i.getSubGroupId()+"\t"+i.getRole());
                        }*/
                        return "redirect:/loginSuccess";
                    }
                } else {
                    req.setAttribute("msg", "Please contact SCGE admin and register your google id");
                    return "redirect:/loginFailure";
                }
        return "redirect:/loginFailure";

    }
    public boolean verifyUserExists( String principalName, String email) throws Exception {
        System.out.println("EMAIL: "+ email);
        List<Person> people= (pdao.getPersonByEmail(email));
        if(people!=null && people.size()>0){
            Person p= people.get(0);
           pdao.updateGoogleId(principalName, p.getId());
           return true;
        }
        return false;
    }
    @RequestMapping("/loginFailure")
    public String getFailureMessage(HttpServletRequest req){
       String msg="Please contact admin at ";
       req.setAttribute("msg",msg);
        return "loginFailure" ;
    }
    @ModelAttribute("userAttributes")
    public Map getUserAttributes(OAuth2AuthenticationToken authentication){
        if(authentication!=null) {
            OAuth2AuthorizedClient client = authorizedClientService.loadAuthorizedClient(authentication.getAuthorizedClientRegistrationId(), authentication.getName());
            if(client!=null) {
                String userInfoEndpointUri = client.getClientRegistration()
                        .getProviderDetails()
                        .getUserInfoEndpoint()
                        .getUri();
                if (!StringUtils.isEmpty(userInfoEndpointUri)) {
                    RestTemplate restTemplate = new RestTemplate();
                    HttpHeaders headers = new HttpHeaders();
                    headers.add(HttpHeaders.AUTHORIZATION, "Bearer " + client.getAccessToken()
                            .getTokenValue());
                    HttpEntity<String> entity = new HttpEntity<String>("", headers);

                    ResponseEntity<Map> response = restTemplate.exchange(userInfoEndpointUri, HttpMethod.GET, entity, Map.class);
                    return response.getBody();
                }
            }
        }
        return null;
    }
    @ModelAttribute("personInfoRecords")
    public List<PersonInfo> getPerson(@ModelAttribute("userAttributes") Map userAttributes) throws Exception {
      if(userAttributes!=null) {
          boolean userExists = verifyUserExists(userAttributes.get("sub").toString(), userAttributes.get("email").toString());
          List<PersonInfo> personInfoList = new ArrayList<>();
          if (userExists) {
              List<Person> personRecords = pdao.getPersonByGoogleId(userAttributes.get("sub").toString());
              if (personRecords.size() > 0)
                  personInfoList = pdao.getPersonInfo(personRecords.get(0).getId());
          }
          return personInfoList;
      }
      return null;
    }


 /*  @ModelAttribute("tiers")
    public List<String> getTiers() {
        List<String> tiers = new ArrayList<String>();
        tiers.add("1");
        tiers.add("2");
        tiers.add("3");
        tiers.add("4");
        return tiers;
    }*/

}
