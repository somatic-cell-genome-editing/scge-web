package edu.mcw.scge.controller;

import com.sun.mail.smtp.SMTPTransport;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.mail.Message;
import javax.mail.Session;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;

@Controller
@RequestMapping(value="/edit")
public class EditController {
    @RequestMapping(value = "access")
    public String getEditAccess(@RequestParam String tier, @RequestParam String studyId , HttpServletRequest req, HttpServletResponse res,
                                RedirectAttributes redirectAttributes) throws Exception {
        System.out.println("TIER: "+ tier+"\tSTUDY ID: "+ studyId);
        if(!tier.equals("2")){
            updateDatabase();
            sendEmailNotification("jthota@mcw.edu", "SCGE","Your Study is updated");

            //  redirectAttributes.addFlashAttribute("message","Confirmation request sent to PI");
            String message="Confirmation request sent to PI";
            return "redirect:/loginSuccess?message="+message+"&studyId="+studyId+"&tier="+tier;
        }else {
            updateDatabase();
            sendEmailNotification("jthota@mcw.edu", "SCGE","Your Study is updated");

          /*  req.setAttribute("action", "Edit Access");
            req.setAttribute("page", "/WEB-INF/jsp/edit/access");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);*/
            String message="Confirmation request sent to PI";
            return "redirect:/loginSuccess?message="+message+"&studyId="+studyId+"&tier="+tier;

        }

      //  return null;
    }
    @RequestMapping(value = "resetAccess")
    public String resetAccess(@RequestParam String tier, @RequestParam String studyId , HttpServletRequest req, HttpServletResponse res,
                                RedirectAttributes redirectAttributes) throws Exception {
        System.out.println("TIER: "+ tier+"\tSTUDY ID: "+ studyId);
        if(!tier.equals("2")){
            sendEmailNotification("jthota@mcw.edu", "SCGE","Your Study is updated");
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
    /**
     * 1. update study table.. fields tier, last_modified_date  and modified_by
     * 2. update study_access table, add groups and members
     * 3. Add entry in study_log table with timestamp
     */
    public void updateDatabase(){

    }
    public void sendEmailNotification(String recepientEmail, String title, String message) throws Exception {
        send(recepientEmail, title,message);
    }
    public static void send(String recipientEmail, String title, String message) throws Exception {

        String smtpHost = "smtp.mcw.edu";

        // Get a Properties object
        Properties props = System.getProperties();

        props.setProperty("mail.smtp.host", "smtp.mcw.edu");
        props.setProperty("mail.smtp.port", "25");

        Session session = Session.getInstance(props, null);

        // -- Create a new message --
        final MimeMessage msg = new MimeMessage(session);

        // -- Set the FROM and TO fields --
        msg.setFrom(new InternetAddress("jthota@mcw.edu", "Rat Genome Database"));

        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail, false));

        //msg.setRecipients(Message.RecipientType.BCC, InternetAddress.parse("jdepons@mcw.edu", false));

        msg.setSubject(title);
        msg.setText(message, "utf-8");
        msg.setSentDate(new Date());

        SMTPTransport t = (SMTPTransport)session.getTransport("smtp");

        t.connect();
        t.sendMessage(msg, msg.getAllRecipients());
        t.close();
    }

}
