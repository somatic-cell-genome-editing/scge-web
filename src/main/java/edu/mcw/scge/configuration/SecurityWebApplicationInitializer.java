package edu.mcw.scge.configuration;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.web.context.AbstractSecurityWebApplicationInitializer;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.multipart.support.MultipartFilter;
import org.springframework.web.multipart.support.StandardServletMultipartResolver;

import javax.servlet.ServletContext;

/**
 * Created by jthota on 11/20/2019.
 */
@Configuration
public class SecurityWebApplicationInitializer extends AbstractSecurityWebApplicationInitializer{
    public SecurityWebApplicationInitializer() {
        super(SecurityConfiguration.class);
    }
    @Override
    protected void beforeSpringSecurityFilterChain(ServletContext servletContext) {
        insertFilters(servletContext, new MultipartFilter());
    }

}

