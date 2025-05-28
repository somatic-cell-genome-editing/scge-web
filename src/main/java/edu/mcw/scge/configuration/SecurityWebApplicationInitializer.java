package edu.mcw.scge.configuration;

import jakarta.servlet.MultipartConfigElement;
import jakarta.servlet.ServletRegistration;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.web.context.AbstractSecurityWebApplicationInitializer;
import org.springframework.web.multipart.support.MultipartFilter;

import jakarta.servlet.ServletContext;

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
    protected void customizeRegistration(ServletRegistration.Dynamic registration) {
        MultipartConfigElement multipartConfigElement =
                new MultipartConfigElement("/tmp", 10_000_000, 15_000_000, 1_000_000);

        registration.setMultipartConfig(multipartConfigElement);
    }
}

