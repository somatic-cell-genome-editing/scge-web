package edu.mcw.scge.storage;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.Array;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.stream.Collectors;

import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.configuration.UserService;
import edu.mcw.scge.dao.implementation.StudyDao;
import edu.mcw.scge.datamodel.Person;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.method.annotation.MvcUriComponentsBuilder;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@Controller
public class FileUploadController {

	private final StorageService storageService;

	@Autowired
	public FileUploadController(StorageService storageService) {
		this.storageService = storageService;
	}

	@GetMapping("/download/{studyId}")
	public String listDownloadFiles(Model model, HttpServletRequest req, HttpServletResponse res,
									@ModelAttribute("message") String message, @PathVariable String studyId) throws Exception {

		UserService userService=new UserService();
		Access access= new Access();
		Person p = userService.getCurrentUser(req.getSession());

		if (!access.hasStudyAccess(Integer.parseInt(studyId),p.getId())) {
			req.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(req, res);
		}

		//	storageService.loadAll().forEach(System.out::println);
		req.setAttribute("message", message);

		StudyDao sdao = new StudyDao();

		try {
			req.setAttribute("files", storageService.loadAll(studyId).map(
					path -> MvcUriComponentsBuilder.fromMethodName(FileUploadController.class,
							"serveFile", req, path.getFileName().toString(), studyId).build().toUri().toString())
					.collect(Collectors.toList()));
		}catch (Exception e) {
			req.setAttribute("files", new ArrayList<String>());
		}
		req.setAttribute("action", "Related Files");
		req.setAttribute("study",sdao.getStudyById(Integer.parseInt(studyId)).get(0));
		req.setAttribute("destination", "dataSubmission");
		req.setAttribute("page", "/WEB-INF/jsp/submissions/download");
		req.setAttribute("groupRoleMap",req.getSession().getAttribute("groupRoleMap"));
		req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

		//	return "submissions/uploadForm";
		return null;
	}

	@GetMapping("/files/{studyId}/{filename:.+}")
	@ResponseBody
	public ResponseEntity<Resource> serveFile(HttpServletRequest req, @PathVariable String filename, @PathVariable String studyId) throws Exception{

		UserService userService=new UserService();
		Access access= new Access();
		Person p = userService.getCurrentUser(req.getSession());

		if (!access.hasStudyAccess(Integer.parseInt(studyId),p.getId())) {
			return null;
		}

		Resource file = storageService.loadAsResource(studyId + "/" + filename);

		return ResponseEntity.ok().header(HttpHeaders.CONTENT_DISPOSITION,
				"attachment; filename=\"" + file.getFilename() + "\"").body(file);
	}

	@PostMapping("/uploadFile")
	public String handleFileUpload(@RequestParam("file") MultipartFile file,
			RedirectAttributes redirectAttributes) {

		//removed upload for now
		//storageService.store(file);
		redirectAttributes.addFlashAttribute("message",
				"You successfully uploaded " + file.getOriginalFilename() + "!");

		return "redirect:/uploadFile";
	}

	@ExceptionHandler(StorageFileNotFoundException.class)
	public ResponseEntity<?> handleStorageFileNotFound(StorageFileNotFoundException exc) {
		return ResponseEntity.notFound().build();
	}
/*
	@GetMapping("/uploadFile")
	public String listUploadedFiles(Model model, HttpServletRequest req, HttpServletResponse res,
									@ModelAttribute("message") String message) throws IOException, ServletException {
		req.setAttribute("message", message);
		req.setAttribute("files", storageService.loadAll().map(
				path -> MvcUriComponentsBuilder.fromMethodName(FileUploadController.class,
						"serveFile", path.getFileName().toString()).build().toUri().toString())
				.collect(Collectors.toList()));
		req.setAttribute("action", "Data Submission System");
		req.setAttribute("destination", "dataSubmission");
		req.setAttribute("page", "/WEB-INF/jsp/submissions/submission");
		req.setAttribute("groupRoleMap",req.getSession().getAttribute("groupRoleMap"));
		req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

		return null;
	}
*/

}
