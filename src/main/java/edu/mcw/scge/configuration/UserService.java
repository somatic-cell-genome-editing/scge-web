package edu.mcw.scge.configuration;

import edu.mcw.scge.dao.implementation.PersonDao;
import edu.mcw.scge.datamodel.Person;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.security.oauth2.core.oidc.user.DefaultOidcUser;
import org.springframework.security.oauth2.core.user.DefaultOAuth2User;

import java.security.Principal;
import java.util.List;
import java.util.Map;


public class UserService {
    PersonDao pdao=new PersonDao();
    public Person getCurrentUser() throws Exception {
        Authentication authToken = SecurityContextHolder.getContext().getAuthentication();
     //   if(SecurityContextHolder.getContext().getAuthentication().getPrincipal()!=null) {
            Map<String, Object> attributes;
            if (authToken instanceof OAuth2AuthenticationToken) {
                attributes = ((OAuth2AuthenticationToken) authToken).getPrincipal().getAttributes();

        //    DefaultOidcUser userPrincipal = (DefaultOidcUser) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
       //     if (userPrincipal != null) {
                if (attributes != null) {
                String userEmail = (String) attributes.get("email");
                List<Person> pList = pdao.getPersonByEmail(userEmail);
                if (pList != null && pList.size() > 0)
                    return pList.get(0);
                //    System.out.println("CURRENT USER NAME:"+ userPrincipal.getAttribute("email"));
                //   System.out.println("CURRENT USER:" + SecurityContextHolder.getContext().getAuthentication().getPrincipal().toString());
            }
            }

            return null;
    }
}
