package edu.mcw.scge.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping(value="/edit")
public class EditController {
    @RequestMapping(value = "access")
    public String getEditAccess(@RequestParam String tier, @RequestParam String studyId , HttpServletRequest req, HttpServletResponse res,
                                RedirectAttributes redirectAttributes) throws ServletException, IOException {
        System.out.println("TIER: "+ tier+"\tSTUDY ID: "+ studyId);
        if(!tier.equals("2")){
            sendEmailNotification();
          //  redirectAttributes.addFlashAttribute("message","Confirmation request sent to PI");
            String message="Confirmation request sent to PI";
            return "redirect:/loginSuccess?message="+message+"&studyId="+studyId+"&tier="+tier;
        }else {
            req.setAttribute("action", "Edit Access");
            req.setAttribute("page", "/WEB-INF/jsp/edit/access");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        }
        return null;
    }

    public void sendEmailNotification(){

    }
}
