package com.example.API_menu_online.service.impl;

import com.example.API_menu_online.service.FileUploadService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

@Service
public class FileUploadServiceImpl implements FileUploadService {

    private static final Logger logger = LoggerFactory.getLogger(FileUploadServiceImpl.class);

    @Value("${file.upload-dir:uploads}")
    private String uploadDir;

    @Override
    public String saveFile(MultipartFile file) throws IOException {
        if (file == null) {
            logger.warn("MultipartFile is null");
            System.out.println("[FileUpload] MultipartFile is null");
            return null;
        }
        
        if (file.isEmpty()) {
            logger.warn("MultipartFile is empty. Original filename: {}", file.getOriginalFilename());
            System.out.println("[FileUpload] MultipartFile is empty: " + file.getOriginalFilename());
            return null;
        }

        // Lấy đường dẫn tuyệt đối hoặc tương đối
        Path uploadPath;
        String userDir = System.getProperty("user.dir");
        logger.info("Current working directory (user.dir): {}", userDir);
        System.out.println("[FileUpload] user.dir: " + userDir);
        System.out.println("[FileUpload] uploadDir config: " + uploadDir);
        
        if (Paths.get(uploadDir).isAbsolute()) {
            uploadPath = Paths.get(uploadDir);
        } else {
            // Thử nhiều cách để tìm thư mục project
            // Cách 1: Từ user.dir (thư mục làm việc hiện tại)
            Path path1 = Paths.get(userDir, uploadDir);
            
            // Cách 2: Từ classpath (thư mục chứa classes) - tìm về project root
            Path path2 = null;
            try {
                String classPath = FileUploadServiceImpl.class.getProtectionDomain()
                    .getCodeSource().getLocation().getPath();
                // Decode URL encoding
                if (classPath.startsWith("/") && classPath.length() > 1) {
                    classPath = classPath.substring(1);
                }
                classPath = URLDecoder.decode(classPath, StandardCharsets.UTF_8);
                Path classDir = Paths.get(classPath);
                // target/classes -> target -> project root
                if (classDir.toString().contains("target") || classDir.toString().contains("WEB-INF")) {
                    Path projectRoot = classDir;
                    // Tìm về project root
                    while (projectRoot != null && !projectRoot.getFileName().toString().equals("API_menu_online")) {
                        Path parent = projectRoot.getParent();
                        if (parent == null || parent.equals(projectRoot)) break;
                        projectRoot = parent;
                    }
                    if (projectRoot != null) {
                        path2 = projectRoot.resolve(uploadDir);
                    }
                }
            } catch (Exception e) {
                System.out.println("[FileUpload] Error getting classpath: " + e.getMessage());
            }
            
            // Ưu tiên: 1) path1 nếu thư mục uploads tồn tại, 2) path2, 3) path1
            if (path2 != null && Files.exists(path2)) {
                uploadPath = path2;
                System.out.println("[FileUpload] Using path from classpath: " + uploadPath.toAbsolutePath());
            } else if (Files.exists(path1) || Files.exists(path1.getParent())) {
                uploadPath = path1;
                System.out.println("[FileUpload] Using path from user.dir: " + uploadPath.toAbsolutePath());
            } else if (path2 != null) {
                uploadPath = path2;
                System.out.println("[FileUpload] Using path2 (classpath): " + uploadPath.toAbsolutePath());
            } else {
                uploadPath = path1;
                System.out.println("[FileUpload] Using default path (user.dir): " + uploadPath.toAbsolutePath());
        }
        }

        logger.info("Upload path: {}", uploadPath.toAbsolutePath());
        System.out.println("[FileUpload] Upload path: " + uploadPath.toAbsolutePath());

        // Tạo thư mục nếu chưa tồn tại
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
            logger.info("Created upload directory: {}", uploadPath.toAbsolutePath());
            System.out.println("[FileUpload] Created upload directory: " + uploadPath.toAbsolutePath());
        } else {
            logger.info("Upload directory already exists: {}", uploadPath.toAbsolutePath());
            System.out.println("[FileUpload] Upload directory exists: " + uploadPath.toAbsolutePath());
        }

        // Làm sạch tên file: loại bỏ ký tự đặc biệt không hợp lệ trong URL
        String originalFilename = file.getOriginalFilename();
        String newFilename;
        
        if (originalFilename != null && !originalFilename.isEmpty()) {
            // Loại bỏ các ký tự đặc biệt không hợp lệ trong URL: [ ] { } | \ ^ ~ ` < > # % " 
            // Chỉ giữ: chữ cái, số, dấu gạch dưới, dấu gạch ngang, dấu chấm
            newFilename = originalFilename
                .replaceAll("[\\[\\]{}|\\\\^~`<>#%\"\\s]", "_")  // Thay ký tự đặc biệt bằng _
                .replaceAll("_{2,}", "_")  // Loại bỏ nhiều dấu _ liên tiếp
                .replaceAll("^_|_$", ""); // Loại bỏ _ ở đầu và cuối
            
            // Đảm bảo có extension
            if (!newFilename.contains(".")) {
                newFilename = newFilename + ".jpg";
            }
            
            // Nếu sau khi làm sạch tên file rỗng, tạo tên mặc định
            if (newFilename.isEmpty() || newFilename.equals(".")) {
                newFilename = "upload_" + System.currentTimeMillis() + ".jpg";
            }
        } else {
            // Nếu không có tên file, tạo tên mặc định
            newFilename = "upload_" + System.currentTimeMillis() + ".jpg";
        }
        
        System.out.println("[FileUpload] Original filename: " + originalFilename);
        System.out.println("[FileUpload] Cleaned filename: " + newFilename);

        logger.info("Original filename: {}, New filename: {}", originalFilename, newFilename);
        System.out.println("[FileUpload] Original filename: " + originalFilename);
        System.out.println("[FileUpload] New filename: " + newFilename);

        // Lưu file
        Path filePath = uploadPath.resolve(newFilename);
        logger.info("Full file path: {}", filePath.toAbsolutePath());
        System.out.println("[FileUpload] Full file path: " + filePath.toAbsolutePath());
        System.out.println("[FileUpload] File size: " + file.getSize() + " bytes");
        
        try {
            // Nếu file đã tồn tại, thử xóa trước (có thể đang được sử dụng)
            if (Files.exists(filePath)) {
                System.out.println("[FileUpload] File already exists, attempting to delete old file...");
                logger.info("File already exists, attempting to delete: {}", filePath.toAbsolutePath());
                
                int maxRetries = 3;
                boolean deleted = false;
                for (int i = 0; i < maxRetries; i++) {
                    try {
                        Files.delete(filePath);
                        deleted = true;
                        System.out.println("[FileUpload] Old file deleted successfully");
                        logger.info("Old file deleted successfully");
                        break;
                    } catch (IOException deleteException) {
                        System.out.println("[FileUpload] Retry " + (i + 1) + "/" + maxRetries + " - Cannot delete file (may be in use): " + deleteException.getMessage());
                        logger.warn("Retry {}/{} - Cannot delete file (may be in use): {}", i + 1, maxRetries, deleteException.getMessage());
                        
                        if (i < maxRetries - 1) {
                            // Đợi một chút trước khi thử lại
                            try {
                                Thread.sleep(500); // Đợi 500ms
                            } catch (InterruptedException ie) {
                                Thread.currentThread().interrupt();
                            }
                        }
                    }
                }
                
                if (!deleted) {
                    // Nếu không xóa được, đổi tên file mới
                    String baseName = newFilename.substring(0, newFilename.lastIndexOf('.'));
                    String extension = newFilename.substring(newFilename.lastIndexOf('.'));
                    String timestamp = String.valueOf(System.currentTimeMillis());
                    newFilename = baseName + "_" + timestamp + extension;
                    filePath = uploadPath.resolve(newFilename);
                    System.out.println("[FileUpload] Cannot delete old file, using new filename: " + newFilename);
                    logger.warn("Cannot delete old file, using new filename: {}", newFilename);
                }
            }
            
            // Lưu file mới
            Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
        
            // Kiểm tra file đã được lưu chưa
            boolean fileExists = Files.exists(filePath);
            long fileSize = fileExists ? Files.size(filePath) : 0;
            
            logger.info("File saved successfully to: {}", filePath.toAbsolutePath());
            logger.info("File exists: {}, File size: {} bytes", fileExists, fileSize);
            logger.info("File URL: /uploads/{}", newFilename);
            
            System.out.println("[FileUpload] File saved successfully!");
            System.out.println("[FileUpload] File exists: " + fileExists);
            System.out.println("[FileUpload] File size on disk: " + fileSize + " bytes");
            System.out.println("[FileUpload] File URL: /uploads/" + newFilename);
        } catch (IOException e) {
            logger.error("Error saving file to: {}", filePath.toAbsolutePath(), e);
            System.out.println("[FileUpload] ERROR saving file: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }

        return "/uploads/" + newFilename;
    }

    @Override
    public void deleteFile(String fileUrl) {
        if (fileUrl == null || !fileUrl.startsWith("/uploads/")) {
            logger.warn("Invalid file URL for deletion: {}", fileUrl);
            return;
        }

        try {
            String filename = fileUrl.substring("/uploads/".length());
            
            // Xử lý relative path giống như saveFile()
            Path filePath;
            if (Paths.get(uploadDir).isAbsolute()) {
                filePath = Paths.get(uploadDir).resolve(filename);
            } else {
                String userDir = System.getProperty("user.dir");
                filePath = Paths.get(userDir, uploadDir).resolve(filename);
            }
            
            boolean deleted = Files.deleteIfExists(filePath);
            if (deleted) {
                logger.info("File deleted: {}", filePath.toAbsolutePath());
            } else {
                logger.warn("File not found for deletion: {}", filePath.toAbsolutePath());
            }
        } catch (IOException e) {
            logger.error("Error deleting file: {}", e.getMessage(), e);
        }
    }
}

