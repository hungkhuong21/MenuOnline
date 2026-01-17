package com.example.API_menu_online.config;

import jakarta.servlet.Filter;
import jakarta.servlet.MultipartConfigElement;
import jakarta.servlet.ServletRegistration;
import org.springframework.web.filter.CharacterEncodingFilter;
import org.springframework.web.servlet.support.AbstractAnnotationConfigDispatcherServletInitializer;
import java.util.logging.Logger;

public class WebAppInitializer extends AbstractAnnotationConfigDispatcherServletInitializer {

    private static final Logger logger = Logger.getLogger(WebAppInitializer.class.getName());

    @Override
    protected Class<?>[] getRootConfigClasses() {
        logger.info("=== WebAppInitializer: getRootConfigClasses called ===");
        return new Class<?>[] { RootConfig.class };
    }

    @Override
    protected Class<?>[] getServletConfigClasses() {
        logger.info("=== WebAppInitializer: getServletConfigClasses called ===");
        return new Class<?>[] { WebConfig.class };
    }

    @Override
    protected String[] getServletMappings() {
        logger.info("=== WebAppInitializer: getServletMappings called ===");
        return new String[] { "/" };
    }

    @Override
    public void onStartup(jakarta.servlet.ServletContext servletContext) throws jakarta.servlet.ServletException {
        logger.info("=== WebAppInitializer: onStartup called ===");
        super.onStartup(servletContext);
        logger.info("=== WebAppInitializer: onStartup completed ===");
    }

    @Override
    protected Filter[] getServletFilters() {
        logger.info("=== WebAppInitializer: getServletFilters called ===");
        // Register CharacterEncodingFilter to handle UTF-8 encoding
        CharacterEncodingFilter characterEncodingFilter = new CharacterEncodingFilter();
        characterEncodingFilter.setEncoding("UTF-8");
        characterEncodingFilter.setForceEncoding(true);
        characterEncodingFilter.setForceRequestEncoding(true);
        characterEncodingFilter.setForceResponseEncoding(true);
        return new Filter[] { characterEncodingFilter };
    }

    @Override
    protected void customizeRegistration(ServletRegistration.Dynamic registration) {
        // Configure multipart settings (10MB max file size, 10MB max request size)
        MultipartConfigElement multipartConfig = new MultipartConfigElement(
            null, // location - null means use temp directory
            10485760L, // maxFileSize - 10MB
            10485760L, // maxRequestSize - 10MB
            0 // fileSizeThreshold - 0 means write to disk immediately
        );
        registration.setMultipartConfig(multipartConfig);
    }
}
