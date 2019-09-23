package edu.mcw.scge.controller;


import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse;

import com.google.api.client.http.HttpTransport;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson2.JacksonFactory;

import edu.mcw.scge.service.DataAccessService;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

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

  
}
