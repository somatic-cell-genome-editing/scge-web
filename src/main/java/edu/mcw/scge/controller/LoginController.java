package edu.mcw.scge.controller;


import edu.mcw.scge.dao.implementation.PersonDao;
import edu.mcw.scge.datamodel.Person;
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
import org.springframework.ui.Model;

import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import org.springframework.web.client.RestTemplate;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


import java.io.IOException;
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
    public String getLoginPage(Model model, HttpServletRequest req, HttpServletResponse res,OAuth2AuthenticationToken authentication) throws Exception {
      Iterable<ClientRegistration> clientRegistrations = null;
        ResolvableType type = ResolvableType.forInstance(clientRegistrationRepository)
                .as(Iterable.class);
        if (type != ResolvableType.NONE && ClientRegistration.class.isAssignableFrom(type.resolveGenerics()[0])) {
            clientRegistrations = (Iterable<ClientRegistration>) clientRegistrationRepository;
        }
    /*    clientRegistrations.forEach(clientRegistration -> System.out.println(clientRegistration.getClientId()+"\n"+clientRegistration.getClientSecret()+"\n"+
        clientRegistration.getProviderDetails().getAuthorizationUri()+"\nSCOPES: "+clientRegistration.getScopes().toString()));*/
       clientRegistrations.forEach(registration -> oauth2AuthenticationUrls.put(registration.getClientName(), authorizationRequestBaseUri + "/" + registration.getRegistrationId()));
       model.addAttribute("urls", oauth2AuthenticationUrls);

       return "home2";
      //  res.sendRedirect("/");
     //   return null;

    }

    @RequestMapping("/loginSuccess")
    public String getLoginInfo(Model model, OAuth2AuthenticationToken authentication, HttpServletRequest req) throws Exception {

     OAuth2AuthorizedClient client = authorizedClientService.loadAuthorizedClient(authentication.getAuthorizedClientRegistrationId(), authentication.getName());
        System.out.println("Principal Name:"+client.getPrincipalName());
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
            Map userAttributes = response.getBody();
            model.addAttribute("name", userAttributes.get("name"));
            String name= (String) userAttributes.get("name");

        String userStatus = pdao.getPersonStatus(client.getPrincipalName());

        String message= new String();
        if(userStatus.equalsIgnoreCase("approved")) {
         //   req.getSession().setAttribute("token",client.getAccessToken().getTokenValue());
            List<Person> persons = pdao.getPersonByGoogleId(client.getPrincipalName());
            int personId=0;
            if(persons.size()>0)
            personId=persons.get(0).getId();
            HttpSession session= req.getSession(true);
            session.setAttribute("userAttributes",userAttributes);
            session.setAttribute("personId", personId);
            req.setAttribute("destination", "base");
            req.setAttribute("page", "/WEB-INF/jsp/dashboard");
            model.addAttribute("message", req.getParameter("message"));
            model.addAttribute("status", req.getParameter("status"));
      //  return"redirect:/secure/success"+ "?status=" + userStatus + "&message=" + message+"&destination=base";
            /***************************************************************************************************/
            Map<String, List<String>> groupRoleMap=service.getGroupsByMemberId(personId);
            Map<String, Map<String, List<String>>> groupSubgroupRoleMap=service.getGroupsByPersonId(personId);
            req.getSession().setAttribute("groupRoleMap", groupRoleMap);
            req.getSession().setAttribute("groupSubgroupRoleMap", groupSubgroupRoleMap);

            model.addAttribute("groupRoleMap", groupRoleMap);
            model.addAttribute("groupSubgroupRoleMap", groupSubgroupRoleMap);
            //  model.addAttribute("consortiumGroups", service.getSubGroupsByGroupName("consortium group"));
            req.setAttribute("groupsMap", service.getGroupsMapByGroupName("consortium group"));
            session.setAttribute("userName", userAttributes.get("name"));
            session.setAttribute("userImageUrl", userAttributes.get("picture"));
            model.addAttribute("userName", userAttributes.get("name"));
            model.addAttribute("userImageUrl", userAttributes.get("picture"));
            req.setAttribute("givenName", userAttributes.get("givenName"));
            req.setAttribute("familyName", userAttributes.get("familyName"));
            req.setAttribute("userEmail", userAttributes.get("email"));
            req.setAttribute("message", req.getParameter("message"));
            req.setAttribute("status", req.getParameter("status"));

            return "base";
        }else{
            message = name+" Your request is under processing. You will receive a confirmation email shortly.";
            return "redirect:/oauth_login"+ "?status=" + userStatus + "&message=" + message;
        }
        }
        return "loginSuccess";
    }

    @RequestMapping("/loginSuccessPage")
    public String getSuccessPage(Model model, OAuth2AuthenticationToken authentication, HttpServletRequest req) throws Exception {
        System.out.println("SUCCESS");
        OAuth2AuthorizedClient client = authorizedClientService.loadAuthorizedClient(authentication.getAuthorizedClientRegistrationId(), authentication.getName());
        System.out.println("Principal Name:"+client.getPrincipalName());
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
            Map userAttributes = response.getBody();
            model.addAttribute("name", userAttributes.get("name"));
            String name = (String) userAttributes.get("name");

            String userStatus = pdao.getPersonStatus(client.getPrincipalName());


            if (userStatus.equalsIgnoreCase("approved")) {
                HttpSession session = req.getSession(true);
                session.setAttribute("userName", name);
                session.setAttribute("userAttributes", userAttributes);
                req.setAttribute("userName", name);
                return "redirect:/loginSuccess";
            }
        }
       return "home2";

    }

}
