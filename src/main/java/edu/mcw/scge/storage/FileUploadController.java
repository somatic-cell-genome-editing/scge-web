package edu.mcw.scge.storage;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Array;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.Properties;
import java.util.stream.Collectors;
import org.apache.commons.io.IOUtils;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.HttpStatus;
import org.springframework.http.CacheControl;
import org.springframework.util.StringUtils;
import edu.mcw.scge.configuration.Access;
import edu.mcw.scge.configuration.UserService;
import edu.mcw.scge.dao.implementation.StudyDao;
import edu.mcw.scge.datamodel.Model;
import edu.mcw.scge.datamodel.Person;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.method.annotation.MvcUriComponentsBuilder;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.core.io.UrlResource;

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

		req.setAttribute("message", message);
		StorageProperties properties=new StorageProperties();
		//properties.setLocation("C:/tmp/upload-dir" );
		properties.setLocation("/data/scge_submissions");
		FileSystemStorageService service=new FileSystemStorageService(properties);
		storageService.init();
		StudyDao sdao = new StudyDao();

		try {
			req.setAttribute("files", service.loadAll(studyId).map(
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
	//	req.setAttribute("groupRoleMap",req.getSession().getAttribute("groupRoleMap"));
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
		StorageProperties properties=new StorageProperties();
	//	properties.setLocation("C:/tmp/upload-dir" );
		properties.setLocation("/data/scge_submissions");
		FileSystemStorageService service=new FileSystemStorageService(properties);

		Resource file = service.loadAsResource(studyId + "/" + filename);

		return ResponseEntity.ok().header(HttpHeaders.CONTENT_DISPOSITION,
				"attachment; filename=\"" + file.getFilename() + "\"").body(file);
	}

	@RequestMapping(value = "/store/{type}/{oid}/{bucket}/{filename}.{ext}", method = RequestMethod.GET)
	@ResponseBody
	public ResponseEntity<byte[]>  getImageAsByteArray(HttpServletRequest req, HttpServletResponse res,@PathVariable String type,@PathVariable String oid,@PathVariable String bucket,@PathVariable String filename,@PathVariable String ext) throws Exception {

		UserService userService=new UserService();
		Access access= new Access();
		Person p = userService.getCurrentUser(req.getSession());

		if (type.equals(ImageTypes.EDITOR)) {
			if (!access.hasEditorAccess(Long.parseLong(oid),p.getId())) {
				req.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(req, res);
			}
		}else if (type.equals(ImageTypes.MODEL)) {
			if (!access.hasModelAccess(Long.parseLong(oid),p)) {
				req.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(req, res);
			}
		}else if (type.equals(ImageTypes.DELIVERY_SYSTEM)) {
			if (!access.hasDeliveryAccess(Long.parseLong(oid),p.getId())) {
				req.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(req, res);
			}
		}else if (type.equals(ImageTypes.GUIDE)) {
			if (!access.hasGuideAccess(Long.parseLong(oid),p.getId())) {
				req.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(req, res);
			}
		}else if (type.equals(ImageTypes.RECORD)) {
			if (!access.hasRecordAccess(Long.parseLong(oid),p)) {
				req.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(req, res);
			}
		}else if (type.equals(ImageTypes.STUDY)) {
			if (!access.hasStudyAccess(Integer.parseInt(oid),p.getId())) {
				req.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(req, res);
			}
		}else if (type.equals(ImageTypes.VECTOR)) {
			if (!access.hasVectorAccess(Long.parseLong(oid),p.getId())) {
				req.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(req, res);
			}
		}else if (type.equals(ImageTypes.EXPERIMENT)) {
			if (!access.hasExperimentAccess(Long.parseLong(oid),p.getId())) {
				req.getRequestDispatcher("/WEB-INF/jsp/error.jsp").forward(req, res);
			}
		}


		Resource resource=null;
		try {

			Path file = new File(StorageProperties.rootLocation + "/" + type + "/" + oid + "/" + bucket + "/").toPath().resolve(filename + "." + ext);
			System.out.println(file.toString());
			//Path file = load(filename);
			resource = new UrlResource(file.toUri());

			if (resource.exists() || resource.isReadable()) {
				System.out.println("IMAGE: resource exists and is readable");
			}
			else {
				System.out.println("Could not read file " + file.toUri().toString());
				throw new StorageFileNotFoundException(
						"IMAGE: Could not read file: " + filename);

			}
		}
		catch (MalformedURLException e) {
			e.printStackTrace();
			throw new StorageFileNotFoundException("IMAGE: Could not read file: " + filename, e);
		}

		//Resource file = storageService.loadAsResource("naturezoom.jpeg");

		HttpHeaders headers = new HttpHeaders();
		InputStream in = resource.getInputStream();
		byte[] media = IOUtils.toByteArray(in);
		headers.setCacheControl(CacheControl.noCache().getHeaderValue());
		headers.setContentType(MediaType.IMAGE_JPEG);
		in.close();

		return new ResponseEntity<byte[]>(media, headers, HttpStatus.OK);
	}



	@RequestMapping(value="/images")
	public String getImages(HttpServletRequest req, HttpServletResponse res, Model model) throws Exception {
		req.setAttribute("action", "Images");
		req.setAttribute("page", "/WEB-INF/jsp/tools/images");
		req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

		return null;
	}

	@PostMapping("/uploadFile")
	public String handleFileUpload(HttpServletRequest req, HttpServletResponse res, @RequestParam("filename") MultipartFile file,
								   RedirectAttributes redirectAttributes) throws Exception {

		UserService userService=new UserService();
		Access access= new Access();
		Person p = userService.getCurrentUser(req.getSession());

		if (!access.isAdmin(p)) {
			return null;
		}

		String type=req.getParameter("type");
		String id = req.getParameter("id");
		String url = req.getParameter("url");
		String bucket = req.getParameter("bucket");

		String filename = StringUtils.cleanPath(file.getOriginalFilename());
		try {
			if (file.isEmpty()) {
				throw new StorageException("Failed to store empty file " + filename);
			}
			if (filename.contains("..")) {
				// This is a security check
				throw new StorageException(
						"Cannot store file with relative path outside current directory "
								+ filename);
			}

			File f = new File(StorageProperties.rootLocation + "/" +  type + "/" + id + "/" + bucket);
			if (!f.exists()) {
				f.mkdirs();
			}

			Path rootLocation = f.toPath();


			try (InputStream inputStream = file.getInputStream()) {
				Files.copy(inputStream, rootLocation.resolve(filename), StandardCopyOption.REPLACE_EXISTING);
			}
		}
		catch (IOException e) {
			throw new StorageException("Failed to store file " + filename, e);
		}

		return "redirect:" + url;

	}


	@PostMapping("/store/remove")
	public String handleFileUpload(HttpServletRequest req, HttpServletResponse res) throws Exception {

		UserService userService=new UserService();
		Access access= new Access();
		Person p = userService.getCurrentUser(req.getSession());

		if (!access.isAdmin(p)) {
			return null;
		}


		String type=req.getParameter("type");
		String id = req.getParameter("id");
		String url = req.getParameter("url");
		String filename = req.getParameter("filename");
		String bucket=req.getParameter("bucket");

		File f = new File(StorageProperties.rootLocation + "/" + type + "/" + id + "/" + bucket + "/" +  filename);
		if (!f.delete()) {
			System.out.println("could not delete");
		}

		return "redirect:" + url;

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
