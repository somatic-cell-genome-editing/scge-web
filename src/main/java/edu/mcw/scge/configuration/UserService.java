package edu.mcw.scge.configuration;

import edu.mcw.scge.dao.implementation.PersonDao;
import edu.mcw.scge.datamodel.Person;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class UserService {
    PersonDao pdao=new PersonDao();
    public Person getCurrentUser() throws Exception {
        Authentication authToken = SecurityContextHolder.getContext().getAuthentication();
          if(authToken!=null){
            Map<String, Object> attributes;
            if (authToken instanceof OAuth2AuthenticationToken) {
                attributes = ((OAuth2AuthenticationToken) authToken).getPrincipal().getAttributes();
                if (attributes != null) {
                String userEmail = (String) attributes.get("email");
                List<Person> pList = pdao.getPersonByEmail(userEmail);
                if (pList != null && pList.size() > 0)
                    return pList.get(0);

            }
            }}
          return null;
    }
}
