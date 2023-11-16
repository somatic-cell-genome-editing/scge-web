package edu.mcw.scge.controller;

import com.sun.mail.smtp.SMTPTransport;
import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.dao.implementation.PersonDao;
import edu.mcw.scge.dao.implementation.StudyDao;
import edu.mcw.scge.datamodel.Person;
import edu.mcw.scge.datamodel.Study;
import edu.mcw.scge.service.DataAccessService;

import edu.mcw.scge.web.SCGEContext;
import org.springframework.stereotype.Controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.mail.Message;
import javax.mail.Session;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.Date;
import java.util.List;
import java.util.Properties;

@Controller
@RequestMapping(value="/edit")
public class EditController {
    DataAccessService service=new DataAccessService();
    StudyDao sdao=new StudyDao();
    PersonDao pdao=new PersonDao();
    Access access=new Access();
    @RequestMapping(value = "/access")
    public String updateAccess(@RequestParam int tier, @RequestParam int studyId ,@RequestParam(required = false) String json,
                               @RequestParam(required = false) String groupIdsJson,
                               HttpServletRequest req,HttpServletResponse res) throws Exception {

        req.getSession().getAttribute("personId");
        int userId= (int) req.getSession().getAttribute("personId");
        Person loggedInUser=pdao.getPersonById(userId).get(0);
        if (!access.hasStudyAccess(studyId,userId)) {
            req.setAttribute("page", "/WEB-INF/jsp/error");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
            return null;

        }

        service.insertTierUpdates(studyId, tier, userId, groupIdsJson );
        Study study= sdao.getStudyById(studyId).get(0);
        List<Person> pi=sdao.getStudyPi(study);
       // List<Person> pi=pdao.getPersonById(study.getPiId());
        List<Person> submitter=pdao.getPersonById(study.getSubmitterId());
        List<Person> pocs=sdao.getStudyPOC(studyId);
        String emailMsg="Dear SCGE Member"/*+pi.get(0).getFirstName()+"/"+submitter.get(0).getFirstName()*/+",\n\nThe Study SCGE-"+studyId+" - "+study.getStudy().trim() +" is updated." +
                " \nThe study TIER is elevated to "+tier+ " by "+loggedInUser.getFirstName()+" "+loggedInUser.getLastName()+
                "\n\nThese changes will get executed after 24 hours. \n\nBest,\nSCGE Toolkit Team.";
        String title="SCGE Study Tier Updated";
       // sendEmailNotification("jthota@mcw.edu", "SCGE Study Updated",emailMsg);
     //   sendEmailNotification(p.get(0).getEmail(), "SCGE Study Updated",emailMsg);
   /*     if(SCGEContext.isDev())
        sendEmailNotification("ageurts@mcw.edu",title ,emailMsg);
       else*/ if(SCGEContext.isProduction()){
           if(access.isDeveloper(loggedInUser)){ //Developers can update TIER without sending email to PI and POCs
               System.out.println("TIER UPDATE BY DEVELOPER: "+ loggedInUser.getEmail());
               sendEmailNotification(loggedInUser.getEmail(),title,emailMsg);
               sendEmailNotification("scge_toolkit@mcw.edu", title, emailMsg);

           }else {
               sendEmailNotification(pi.get(0).getEmail(), title, emailMsg);
               if (pi.get(0).getId() != submitter.get(0).getId())
                   sendEmailNotification(submitter.get(0).getEmail(), title, emailMsg);
               sendEmailNotification("scge_toolkit@mcw.edu", title, emailMsg);
               if (pocs.size() > 0) {
                   for (Person poc : pocs) {
                       if (poc.getId() != pi.get(0).getId() && poc.getId() != submitter.get(0).getId()) {
                           try {
                               sendEmailNotification(poc.getEmail(), title, emailMsg);
                           } catch (Exception e) {

                           }
                       }
                   }
               }
           }
        }else{
           sendEmailNotification(loggedInUser.getEmail(),"DEV "+title,emailMsg);
        }
        String message="Confirmation request sent to PI and POC. Requested changes will get executed after 24 hours";
        return "redirect:/db?message="+message+"&studyId="+studyId+"&tier="+tier;

    }
    @RequestMapping(value = "resetAccess")
    public String resetAccess(@RequestParam String tier, @RequestParam String studyId , HttpServletRequest req, HttpServletResponse res,
                                RedirectAttributes redirectAttributes) throws Exception {
        if(!tier.equals("2")){
            sendEmailNotification("jthota@mcw.edu", "SCGE Study Updated","Your Study is updated");
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
    public void updateDatabase(int studyId, int tier, int personId, String json) throws Exception {

       service.updateStudyTier(studyId, tier,0,null,null,personId);
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
        msg.setFrom(new InternetAddress("scge_toolkit@mcw.edu", "SCGE Toolkit"));

        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail, false));

     //   msg.setRecipients(Message.RecipientType.BCC, InternetAddress.parse("scge_toolkit@mcw.edu", false));

        msg.setSubject(title);
        msg.setText(message, "utf-8");
        msg.setSentDate(new Date());

        SMTPTransport t = (SMTPTransport)session.getTransport("smtp");

        t.connect();
        t.sendMessage(msg, msg.getAllRecipients());
        t.close();
    }

}
