package com.example.API_menu_online.service;

import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;

public interface FileUploadService {
    String saveFile(MultipartFile file) throws IOException;
    void deleteFile(String fileUrl);
}
