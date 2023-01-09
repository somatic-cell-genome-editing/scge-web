package edu.mcw.scge.controller;


import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.configuration.UserService;
import edu.mcw.scge.dao.implementation.StudyDao;
import edu.mcw.scge.datamodel.Person;
import edu.mcw.scge.datamodel.Study;
import edu.mcw.scge.datamodel.TestData;
import edu.mcw.scge.service.DataAccessService;
import edu.mcw.scge.storage.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.method.annotation.MvcUriComponentsBuilder;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping(value = "/data")
public class UploadController {
    DataAccessService service=new DataAccessService();
    StudyDao studyDao=new StudyDao();
    private final StorageService storageService;

    @Autowired
    public UploadController(StorageService storageService) {
        this.storageService = storageService;
    }

    @GetMapping(value="dataSubmission")
    public String submission(HttpServletRequest req, HttpServletResponse res, Model model) throws ServletException, IOException, IOException {
        List<Study> studies =new ArrayList<>();
        try {
            studies =studyDao.getStudies();
        } catch (Exception e) {
            e.printStackTrace();
        }
        req.setAttribute("studies", studies);
        req.setAttribute("action", "Submit data");
            req.setAttribute("destination", "dataSubmission");
            req.setAttribute("page", "/WEB-INF/jsp/submissions/submission");

            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        return null;
    }
    @PostMapping(value="dataSubmission")
    public String createOrUpdate(HttpServletRequest req,HttpServletResponse res, Model model) throws ServletException, IOException {


            req.setAttribute("action", "Add Experiment Data");
            req.setAttribute("destination", "dataSubmission");
            req.setAttribute("page", "/WEB-INF/jsp/submissions/newExperiment");
            req.setAttribute("experimentName", req.getParameter("createExperiment"));
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
       return  null;
    }

    @RequestMapping(value="submitForm")
    public String submitForm(HttpServletRequest req, Model model) throws Exception {
        String name=req.getParameter("name");
        String symbol=req.getParameter("symbol");
      //  List<TestData> records=service.insert(name,symbol);
        System.out.println("NAME:"+name+"\t"+ symbol);
      //  model.addAttribute("records", records);
        return "submissions/submitSucess";
    }


    @GetMapping("/files/{filename:.+}")
    @ResponseBody
    public ResponseEntity<Resource> serveFile(@PathVariable String filename) {
        Resource file = storageService.loadAsResource(filename);
        return ResponseEntity.ok().header(HttpHeaders.CONTENT_DISPOSITION,
                "attachment; filename=\"" + file.getFilename() + "\"").body(file);
    }

    @GetMapping("/uploadFile")
    public String handleFileUpload(@RequestParam("file") MultipartFile file,
                                   RedirectAttributes redirectAttributes) {

        storageService.store(file);
        redirectAttributes.addFlashAttribute("message",
                "You successfully uploaded " + file.getOriginalFilename() + "!");

        return "redirect:/uploadFile";
    }

    @ExceptionHandler(StorageFileNotFoundException.class)
    public ResponseEntity<?> handleStorageFileNotFound(StorageFileNotFoundException exc) {
        return ResponseEntity.notFound().build();
    }
    @PostMapping("/uploadFile")
    public String listUploadedFiles(Model model, HttpServletRequest req, HttpServletResponse res,
                                    @ModelAttribute("message") String message) throws IOException, ServletException {
        //	storageService.loadAll().forEach(System.out::println);
        req.setAttribute("message", message);
        req.setAttribute("files", storageService.loadAll().map(
                path -> MvcUriComponentsBuilder.fromMethodName(UploadController.class,
                        "serveFile", path.getFileName().toString()).build().toUri().toString())
                .collect(Collectors.toList()));
        req.setAttribute("action", "Data Submission System");
        req.setAttribute("destination", "dataSubmission");
        req.setAttribute("page", "/WEB-INF/jsp/submissions/submission");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

        //	return "submissions/uploadForm";
        return null;
    }
}
