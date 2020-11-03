package edu.mcw.scge.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Created by jthota on 9/20/2019.
 */
@Controller
@RequestMapping(value="/data")
public class DataController {
    @GetMapping(value="animalReporter")
    public void getAnimalReporter(HttpServletRequest req, HttpServletResponse res, Model model) throws ServletException, IOException {

            req.setAttribute("action", "Animal Reporter Models");
            req.setAttribute("page", "/WEB-INF/jsp/data/animalReporter");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

    }

    @GetMapping(value="model/{id}")
    public void getAnimalModel(HttpServletRequest req, HttpServletResponse res, Model model) throws ServletException, IOException {
       // if(req.getSession().getAttribute("token")!=null) {
            req.setAttribute("action", "Model Report");
            req.setAttribute("destination", "/scge/secure/data/model");
            req.setAttribute("page", "/WEB-INF/jsp/data/model");
            req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);
      /*  }else{
            req.setAttribute("message", "Please Login");
            res.sendRedirect("/scge/home?message="+"please login");
        }*/
    }
}
