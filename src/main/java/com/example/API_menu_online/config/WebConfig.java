package com.example.API_menu_online.config;

import com.example.API_menu_online.interceptor.AuthInterceptor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.web.filter.CharacterEncodingFilter;
import org.springframework.web.multipart.support.StandardServletMultipartResolver;
import org.springframework.web.servlet.ViewResolver;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.http.converter.ByteArrayHttpMessageConverter;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.config.annotation.DefaultServletHandlerConfigurer;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.web.servlet.view.JstlView;

@Configuration
@EnableWebMvc
@ComponentScan(basePackages = "com.example.API_menu_online.controller")
@PropertySource("classpath:application.properties")
public class WebConfig implements WebMvcConfigurer {

    private static final Logger logger = LoggerFactory.getLogger(WebConfig.class);

    @Value("${file.upload-dir:uploads}")
    private String uploadDir;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Phục vụ các file đã upload
        // Chuyển đổi đường dẫn tương đối thành đường dẫn tuyệt đối nếu cần
        java.nio.file.Path uploadPathObj;
        if (!java.nio.file.Paths.get(uploadDir).isAbsolute()) {
            String userDir = System.getProperty("user.dir");
            uploadPathObj = java.nio.file.Paths.get(userDir, uploadDir).toAbsolutePath();
        } else {
            uploadPathObj = java.nio.file.Paths.get(uploadDir).toAbsolutePath();
        }
        
        // Chuẩn hóa đường dẫn và đảm bảo kết thúc bằng dấu phân cách
        String uploadPath = uploadPathObj.normalize().toString();
        if (!uploadPath.endsWith(java.io.File.separator)) {
            uploadPath = uploadPath + java.io.File.separator;
        }
        
        // Thay thế dấu gạch chéo ngược bằng dấu gạch chéo xuôi cho file: URL (tương thích Windows)
        // file: URLs phải sử dụng dấu gạch chéo xuôi ngay cả trên Windows
        String normalizedPath = uploadPath.replace("\\", "/");
        
        // Đảm bảo định dạng file: URL đúng
        // Đối với Windows: file:/C:/path hoặc file:///C:/path
        // Đối với Unix: file:/path hoặc file:///path
        String fileUrl;
        if (normalizedPath.startsWith("/") && normalizedPath.length() > 1 && normalizedPath.charAt(2) == ':') {
            // Đường dẫn tuyệt đối Windows như /C:/path -> file:/C:/path
            fileUrl = "file:/" + normalizedPath;
        } else if (normalizedPath.startsWith("/")) {
            // Đường dẫn tuyệt đối Unix
            fileUrl = "file:" + normalizedPath;
        } else {
            // Đường dẫn tương đối (không nên xảy ra, nhưng vẫn xử lý)
            fileUrl = "file:/" + normalizedPath;
        }
        
        logger.debug("Upload directory: {}", uploadPath);
        logger.debug("Normalized path: {}", normalizedPath);
        logger.debug("Resource handler /uploads/** -> {}", fileUrl);
        
        // Thêm handler uploads với độ ưu tiên cao nhất
        // Sử dụng định dạng file:/// để tương thích tốt hơn (3 dấu gạch chéo cho đường dẫn tuyệt đối)
        String finalFileUrl = fileUrl;
        if (fileUrl.startsWith("file:/") && !fileUrl.startsWith("file:///")) {
            // Chuyển đổi file:/ thành file:/// cho đường dẫn tuyệt đối
            finalFileUrl = "file://" + fileUrl.substring(5); // Xóa "file:" và thêm "file://"
        }
        
        logger.debug("Final file URL: {}", finalFileUrl);
        
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations(finalFileUrl)
                .setCachePeriod(3600);
        
        // Phục vụ tài nguyên tĩnh từ classpath
        registry.addResourceHandler("/css/**")
                .addResourceLocations("classpath:/static/css/")
                .setCachePeriod(3600);
        registry.addResourceHandler("/js/**")
                .addResourceLocations("classpath:/static/js/")
                .setCachePeriod(3600);
        registry.addResourceHandler("/images/**")
                .addResourceLocations("classpath:/static/images/")
                .setCachePeriod(3600);
        
        // Phục vụ từ classpath:/resources/ (nếu có)
        registry.addResourceHandler("/resources/**")
                .addResourceLocations("classpath:/resources/")
                .setCachePeriod(3600);
    }

    @Bean
    public ViewResolver viewResolver() {
        InternalResourceViewResolver viewResolver = new InternalResourceViewResolver();
        viewResolver.setViewClass(JstlView.class);
        viewResolver.setPrefix("/WEB-INF/views/");
        viewResolver.setSuffix(".jsp");
        viewResolver.setContentType("text/html;charset=UTF-8");
        return viewResolver;
    }

    @Bean
    public StandardServletMultipartResolver multipartResolver() {
        StandardServletMultipartResolver resolver = new StandardServletMultipartResolver();
        // Lưu ý: StandardServletMultipartResolver không có cài đặt encoding trực tiếp
        // Encoding được xử lý bởi CharacterEncodingFilter (đã cấu hình ở dưới)
        return resolver;
    }

    @Override
    public void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer) {
        // Bật default servlet để xử lý tài nguyên tĩnh không được xử lý bởi resource handlers
        configurer.enable();
    }

    @Bean
    public CharacterEncodingFilter characterEncodingFilter() {
        CharacterEncodingFilter filter = new CharacterEncodingFilter();
        filter.setEncoding("UTF-8");
        filter.setForceEncoding(true); // Ép encoding cho cả request và response
        filter.setForceRequestEncoding(true);
        filter.setForceResponseEncoding(true);
        return filter;
    }

    @Override
    public void configureMessageConverters(java.util.List<HttpMessageConverter<?>> converters) {
        // Cấu hình StringHttpMessageConverter với UTF-8
        StringHttpMessageConverter stringConverter = new StringHttpMessageConverter(java.nio.charset.StandardCharsets.UTF_8);
        converters.add(stringConverter);
        
        // Thêm ByteArrayHttpMessageConverter cho phản hồi image/png (QR codes)
        ByteArrayHttpMessageConverter byteArrayConverter = new ByteArrayHttpMessageConverter();
        converters.add(byteArrayConverter);
        
        // Thêm JSON message converter cho các REST API endpoints
        try {
            org.springframework.http.converter.json.MappingJackson2HttpMessageConverter jsonConverter = 
                new org.springframework.http.converter.json.MappingJackson2HttpMessageConverter();
            java.util.List<org.springframework.http.MediaType> mediaTypes = new java.util.ArrayList<>();
            mediaTypes.add(org.springframework.http.MediaType.APPLICATION_JSON);
            // APPLICATION_JSON_UTF8 đã bị deprecated, sử dụng APPLICATION_JSON với charset trong header
            jsonConverter.setSupportedMediaTypes(mediaTypes);
            converters.add(jsonConverter);
        } catch (NoClassDefFoundError e) {
            logger.warn("Không tìm thấy Jackson, phản hồi JSON có thể không hoạt động. Thêm dependency jackson-databind.", e);
        } catch (Exception e) {
            logger.warn("Không thể thêm Jackson JSON converter: {}", e.getMessage(), e);
        }
    }

    @Bean
    public AuthInterceptor authInterceptor() {
        return new AuthInterceptor();
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(authInterceptor())
                .addPathPatterns("/**") // Áp dụng cho tất cả các đường dẫn
                .excludePathPatterns(
                    "/login",           // Loại trừ trang đăng nhập
                    "/login/**",        // Loại trừ các đường dẫn liên quan đến đăng nhập
                    "/register",        // Loại trừ trang đăng ký
                    "/register/**",     // Loại trừ các đường dẫn liên quan đến đăng ký
                    "/restaurant/*/menu", // Loại trừ trang menu công khai
                    "/restaurant/*/qr",   // Loại trừ trang QR code
                    "/uploads/**",      // Loại trừ các file đã upload
                    "/css/**",          // Loại trừ tài nguyên tĩnh
                    "/js/**",           // Loại trừ tài nguyên tĩnh
                    "/images/**",       // Loại trừ tài nguyên tĩnh
                    "/resources/**",    // Loại trừ tài nguyên tĩnh từ webapp/resources
                    "/api/**",          // Loại trừ các API endpoints
                    "/orders/create",   // Loại trừ tạo đơn hàng
                    "/"                 // Loại trừ trang chủ
                );
    }
}