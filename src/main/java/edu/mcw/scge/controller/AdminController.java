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
@RequestMapping(value="/admin")
public class AdminController {
    @RequestMapping(value = "")
    public void getAnimalReporter(HttpServletRequest req, HttpServletResponse res, Model model) throws ServletException, IOException {

        req.setAttribute("action", "Administration");
        req.setAttribute("page", "/WEB-INF/jsp/admin");
        req.getRequestDispatcher("/WEB-INF/jsp/base.jsp").forward(req, res);

    }
}

