package edu.mcw.scge.configuration;

import edu.mcw.scge.dao.implementation.PersonDao;
import edu.mcw.scge.datamodel.Person;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.core.user.DefaultOAuth2User;

import java.util.List;


public class UserService {
    PersonDao pdao=new PersonDao();
    public Person getCurrentUser() throws Exception {
        DefaultOAuth2User userPrincipal= (DefaultOAuth2User) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if(userPrincipal!=null) {
            String userEmail = userPrincipal.getAttribute("email");
             List<Person> pList=pdao.getPersonByEmail(userEmail);
             if(pList!=null && pList.size()>0)
                 return pList.get(0);
            //    System.out.println("CURRENT USER NAME:"+ userPrincipal.getAttribute("email"));
            //   System.out.println("CURRENT USER:" + SecurityContextHolder.getContext().getAuthentication().getPrincipal().toString());
        }
            return null;
    }
}
