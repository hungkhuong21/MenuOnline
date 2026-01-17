package com.example.API_menu_online.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;

@Configuration
@PropertySource("classpath:application.properties")
public class PropertyConfig {

    @Value("${file.upload-dir:uploads}")
    private String uploadDir;

    @Value("${server.port:8080}")
    private int serverPort;

    public String getUploadDir() {
        return uploadDir;
    }

    public int getServerPort() {
        return serverPort;
    }
}

