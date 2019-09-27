package edu.mcw.scge.controller;


import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse;

import com.google.api.client.http.HttpTransport;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson2.JacksonFactory;

import edu.mcw.scge.service.ClientService;
import edu.mcw.scge.service.DataAccessService;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


import java.io.IOException;
import java.math.BigInteger;
import java.security.SecureRandom;

import java.util.*;


/**
 * Created by jthota on 8/9/2019.
 */
@Controller

public class LoginController{

    DataAccessService service=new DataAccessService();
    private static final Collection<String> SCOPES = Arrays.asList("email", "profile");
    private static final JsonFactory JSON_FACTORY = new JacksonFactory();
    private static final HttpTransport HTTP_TRANSPORT = new NetHttpTransport();
    private static final String USERINFO_ENDPOINT
            //  = "https://www.googleapis.com/plus/v1/people/me/openIdConnect";
            ="https://oauth2.googleapis.com/tokeninfo";


    private GoogleAuthorizationCodeFlow flow;
    @RequestMapping(value="/home", method= RequestMethod.GET)
    public String home(HttpServletRequest req, Model model){
        model.addAttribute("message", req.getParameter("message"));
        return "home2";
    }

    @RequestMapping(value="/login")
    public String login(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
        String state= new BigInteger(130, new SecureRandom()).toString(32);
        req.getSession().setAttribute("state",state);
        if(req.getAttribute("destination")!=null){
            req.getSession().setAttribute("destination", (String)req.getAttribute("destination"));
        }else{
            req.getSession().setAttribute("destination", "secure/success");
        }

        flow=new GoogleAuthorizationCodeFlow.Builder(
                HTTP_TRANSPORT,
                JSON_FACTORY,
                ClientService.CLIENT_ID,
                ClientService.CLIENT_SECRET,
                SCOPES).build();
        String url=flow.newAuthorizationUrl()
                .setRedirectUri(ClientService.REDIRECT_URI)
                .setState(state)
                .build();
        res.sendRedirect(url);
        return null;
    }

    @RequestMapping(value="/secure")
    public void secure(HttpServletRequest req,HttpServletResponse res, Model model) throws Exception {

        if (req.getSession().getAttribute("state") == null || !req.getParameter("state").equals(req.getSession().getAttribute("state"))) {
            res.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            res.sendRedirect("/home");

        }
        req.getSession().removeAttribute("state");
        flow = new GoogleAuthorizationCodeFlow.Builder(
                HTTP_TRANSPORT,
                JSON_FACTORY,
                ClientService.CLIENT_ID,
                ClientService.CLIENT_SECRET,
                SCOPES
        ).build();


        final GoogleTokenResponse tokenResponse = flow.newTokenRequest(req.getParameter("code"))
                .setRedirectUri(ClientService.REDIRECT_URI).execute();
        req.getSession().setAttribute("token", tokenResponse.toString());
        /****************************************************************************
         PersonDao pdao=new PersonDao();
         int key=pdao.generateNewPersonKey();
         final Credential credential=flow.createAndStoreCredential(tokenResponse, String.valueOf(key));

         final HttpRequestFactory requestFactory=HTTP_TRANSPORT.createRequestFactory(credential);
         final GenericUrl url=new GenericUrl(USERINFO_ENDPOINT);
         final HttpRequest request=requestFactory.buildGetRequest(url);
         request.getHeaders().setContentType("application/json");
         final String jsonIdentity=request.execute().parseAsString();
         HashMap<String, String> userIdResult=new ObjectMapper().readValue(jsonIdentity, HashMap.class);
         System.out.println("USER ID RESULT EMAIL: "+userIdResult.get("email"));
         System.out.println("USER ID RESULT: "+userIdResult.toString());
         /****************************************************************************/
        GoogleIdToken idToken = tokenResponse.parseIdToken();
       // System.out.println("Token Response:"+tokenResponse.toString());
       // System.out.println("ID TOKEN:"+idToken);
        GoogleIdToken.Payload payload = idToken.getPayload();
        String name = (String) payload.get("name");
        String givenName = (String) payload.get("given_name");
        String familyName = (String) payload.get("family_name");
        String email = payload.getEmail();
        String sub = payload.getSubject();
     //   System.out.println("Name: " + name + "\t" + "email: " + email + " \thosted domain: " + payload.getHostedDomain()+
     //           "\taud: " + payload.getAudience() +"\t"+ payload.get("family_name"));
        boolean verifiedEmail = payload.getEmailVerified();
        if(verifiedEmail){
            HttpSession session = req.getSession(true);

            session.setAttribute("userName", name);
            session.setAttribute("firstName", givenName);
            session.setAttribute("lastName", familyName);
            session.setAttribute("userEmail", email);
            session.setAttribute("userId", sub);
            session.setAttribute("userImageUrl", payload.get("picture"));
            String message=new String();
            if (service.existsInSCGE(payload)) {
                String userStatus = service.getUserStatus(payload);
                if(userStatus.equalsIgnoreCase("approved")){
                    int personId=service.getPersonByGoogleId(payload);
                    session.setAttribute("personId", personId);
                    model.addAttribute("userImageUrl", payload.get("picture"));
                    model.addAttribute("userName", name);
                    model.addAttribute("givenName", givenName);
                    model.addAttribute("familyName", familyName);
                    model.addAttribute("userEmail", email);
                    model.addAttribute("status", userStatus);
                    res.sendRedirect((String) req.getSession().getAttribute("destination") + "?status=" + userStatus + "&message=" + message+"&destination=base");

                }else{
                    message = name+" Your request is under processing. You will receive a confirmation email shortly.";
                    res.sendRedirect("/scge/home"+ "?status=" + userStatus + "&message=" + message);
                }

            }else {
                 res.sendRedirect("secure/create");
            }
        }else{
            res.sendRedirect("scge/home");
        }
    }



    @RequestMapping(value="/secure/success")
    public String onLoginSuccess(HttpServletRequest req, Model model){
        req.setAttribute("page", "/WEB-INF/jsp/dashboard");
        if(req.getParameter("isGeneralAdmin")!=null && Objects.equals(req.getParameter("isGeneralAdmin"), "true")){
            req.getSession().setAttribute("isGeneralAdmin", "true");
            model.addAttribute("isGeneralAdmin", "true");
        }
        if(req.getParameter("isGroupAdmin")!=null && req.getParameter("isGroupAdmin").equalsIgnoreCase("true")){
            req.getSession().setAttribute("isGrouppAdmin", "true");
            model.addAttribute("isGroupAdmin", "true");
        }
   //     Map<String, List<String>> groupRoleMap=service.getGroupsByMemberName(req.getSession().getAttribute("userName").toString());
        Map<String, List<String>> groupRoleMap=service.getGroupsByMemberId((Integer) req.getSession().getAttribute("personId"));
        req.getSession().setAttribute("groupRoleMap", groupRoleMap);
        model.addAttribute("groupRoleMap", groupRoleMap);
      //  model.addAttribute("consortiumGroups", service.getSubGroupsByGroupName("consortium group"));
        model.addAttribute("groupsMap", service.getGroupsMapByGroupName("consortium group"));


        model.addAttribute("message", req.getParameter("message"));
        model.addAttribute("status", req.getParameter("status"));
        return req.getParameter("destination");
    }
    @RequestMapping(value="/secure/logout")
    public void logout(HttpServletRequest req,HttpServletResponse res, Model model) throws IOException {
        HttpSession session=req.getSession(false);
        String userName= (String) session.getAttribute("userName");
        session.invalidate();
        req.getSession();
        String message= userName+",  You're logged out of SCGE, please don't forget to logout of your Google account!!";
        res.sendRedirect("/scge/home?message="+message);
    }
}
