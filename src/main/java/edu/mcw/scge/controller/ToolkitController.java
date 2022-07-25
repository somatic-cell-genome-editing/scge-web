package edu.mcw.scge.controller;

import com.sun.mail.smtp.SMTPTransport;
import com.google.gson.Gson;
import edu.mcw.scge.dao.implementation.*;
import edu.mcw.scge.datamodel.*;
import edu.mcw.scge.service.DataAccessService;
import edu.mcw.scge.service.db.DBService;
import edu.mcw.scge.service.es.IndexServices;
import org.json.JSONObject;
import org.elasticsearch.action.search.SearchResponse;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.mail.Message;
import javax.mail.Session;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;

@Controller
@RequestMapping(value = "/data")
public class ToolkitController {
   IndexServices services=new IndexServices();
    DBService dbService=new DBService();
    GroupDAO gdao=new GroupDAO();
    @GetMapping(value="")
    public String getToolKitHome(HttpServletRequest req, HttpServletResponse res, Model model) throws ServletException, IOException {
        req.setAttribute("action", "Toolkit");
        req.setAttribute("page", "/WEB-INF/jsp/tools/home");
        req.setAttribute("seoDescription","The goal of the SCGE program is to accelerate the development of safer and more effective methods to edit the genomes of disease-relevant somatic cells and tissues in patients.  For ethical, legal and safety reasons, the SCGE program does not support any research activities on genome editing in reproductive (germ) cells.");
        req.setAttribute("seoTitle","Home");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

    @RequestMapping(value="/feedback")
    public String getFeedback(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {

        StringBuilder buffer = new StringBuilder();
        BufferedReader reader = req.getReader();
        String line;
        while ((line = reader.readLine()) != null) {
            buffer.append(line);
            buffer.append(System.lineSeparator());
        }
        JSONObject obj = new JSONObject(buffer.toString());
        reader.close();


        String email = (String) obj.get("email");
        String feedbackMsg = (String) obj.get("message");
        String page = (String) obj.get("webPage");


        FeedbackDao fdao = new FeedbackDao();
        fdao.insert(email, feedbackMsg,page);


            String smtpHost = "smtp.mcw.edu";

            // Get a Properties object
            Properties props = System.getProperties();

            props.setProperty("mail.smtp.host", "smtp.mcw.edu");
            props.setProperty("mail.smtp.port", "25");

            Session session = Session.getInstance(props, null);

            // -- Create a new message --
            final MimeMessage msg = new MimeMessage(session);

            // -- Set the FROM and TO fields --
            msg.setFrom(new InternetAddress("scge_toolkit@mcw.edu", "SCGE Toolkit"));

           // msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse("scge_toolkit@mcw.edu", false));
         msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse("scge_toolkit@mcw.edu", false));

            //msg.setRecipients(Message.RecipientType.BCC, InternetAddress.parse("jdepons@mcw.edu", false));

            msg.setSubject("SCGE Toolkit Feedback Request");


            String emailBody = "";

            emailBody += "\n\nFeedback message received from :\t" + email + "\n\n";
            emailBody += feedbackMsg + "\n\n";
            emailBody += "This message was sent from :\t" + page + "\n\n";


            msg.setText(emailBody, "utf-8");
            msg.setSentDate(new Date());

            SMTPTransport t = (SMTPTransport)session.getTransport("smtp");

            t.connect();
            t.sendMessage(msg, msg.getAllRecipients());
            t.close();






        return "requestAccount";
    }



    @RequestMapping(value="/requestAccount")
    public String getRequestAccount(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {

        if ((req.getParameter("action") !=null && req.getParameter("action").equals("request") && req.getParameter("googleEmail").equals(""))) {
            req.setAttribute("msg","Email Address tied to Google Account is required.");
            return "requestAccount";
        }


        if (req.getParameter("googleEmail") != null && !req.getParameter("googleEmail").equals("")) {

            AccessDao adao = new AccessDao();
            adao.insertAccessRequest(req.getParameter("firstName"),req.getParameter("lastName"),req.getParameter("googleEmail"),req.getParameter("institution"),req.getParameter("institutionalEmail"),req.getParameter("pi"));

            req.setAttribute("msg","Thank you for your request!  It may take up to 3 business days to review.");

            String smtpHost = "smtp.mcw.edu";

            // Get a Properties object
            Properties props = System.getProperties();

            props.setProperty("mail.smtp.host", "smtp.mcw.edu");
            props.setProperty("mail.smtp.port", "25");

            Session session = Session.getInstance(props, null);

            // -- Create a new message --
            final MimeMessage msg = new MimeMessage(session);

            // -- Set the FROM and TO fields --
            msg.setFrom(new InternetAddress("jdepons@mcw.edu", "SCGE Toolkit"));

            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse("scge_toolkit@mcw.edu", false));

            //msg.setRecipients(Message.RecipientType.BCC, InternetAddress.parse("jdepons@mcw.edu", false));

            msg.setSubject("SCGE Toolkit Access Request");


            String emailBody = "";

            emailBody += "\n\nFirst Name:\t" + req.getParameter("firstName") + "\n";
            emailBody += "Last Name:\t" + req.getParameter("lastName") + "\n";
            emailBody += "Google Email:\t" + req.getParameter("googleEmail") + "\n";
            emailBody += "Institution:\t" + req.getParameter("institution") + "\n";
            emailBody += "Institutional Email:\t" + req.getParameter("institutionalEmail") + "\n";
            emailBody += "Principal Investigator:\t" + req.getParameter("pi");


            msg.setText(emailBody, "utf-8");
            msg.setSentDate(new Date());

            SMTPTransport t = (SMTPTransport)session.getTransport("smtp");

            t.connect();
            t.sendMessage(msg, msg.getAllRecipients());
            t.close();



        }



        return "requestAccount";
    }

    @RequestMapping(value="/editor/search")
    public String getEditorHome(HttpServletRequest req, HttpServletResponse res) throws Exception {
        EditorDao dao = new EditorDao();
        List<Editor> records= dao.getAllEditors();
        req.setAttribute("editors", records);
        req.setAttribute("action", "Editors");
        req.setAttribute("page", "/WEB-INF/jsp/tools/editor");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }

    @RequestMapping(value="/initiatives")
    public String getInitiativesHome(HttpServletRequest req, HttpServletResponse res) throws Exception {
        req.setAttribute("action", "About SCGE");
        req.setAttribute("page", "/WEB-INF/jsp/tools/initiatives");
        req.setAttribute("seoDescription","The goal of the SCGE program is to accelerate the development of safer and more effective methods to edit the genomes of disease-relevant somatic cells and tissues in patients.  For ethical, legal and safety reasons, the SCGE program does not support any research activities on genome editing in reproductive (germ) cells.");
        req.setAttribute("seoTitle","About SCGE");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
        return null;
    }

}
