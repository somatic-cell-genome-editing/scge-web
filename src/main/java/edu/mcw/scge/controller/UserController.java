package edu.mcw.scge.controller;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.security.Principal;


/**
 * Created by jthota on 11/19/2019.
 */
//@RestController
@Controller
public class UserController {
    @GetMapping("/user")
    public Principal user(Principal principal) {
        return principal;
    }
}
