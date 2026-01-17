package com.example.API_menu_online.service.impl;

import com.example.API_menu_online.entity.Category;
import com.example.API_menu_online.entity.Product;
import com.example.API_menu_online.entity.Restaurant;
import com.example.API_menu_online.repository.ProductRepository;
import com.example.API_menu_online.service.FileUploadService;
import com.example.API_menu_online.service.ProductService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@Service
public class ProductServiceImpl implements ProductService {
    
    private static final Logger logger = LoggerFactory.getLogger(ProductServiceImpl.class);
    
    private final ProductRepository productRepository;
    private final FileUploadService fileUploadService;

    @Autowired
    public ProductServiceImpl(ProductRepository productRepository, FileUploadService fileUploadService) {
        this.productRepository = productRepository;
        this.fileUploadService = fileUploadService;
    }

    @Override
    public List<Product> getAll() {
        return productRepository.findAll();
    }

    @Override
    public Optional<Product> getById(Long id) {
        return productRepository.findById(id);
    }

    @Override
    public List<Product> getByCategory(Category category) {
        return productRepository.findByCategory(category);
    }

    @Override
    public List<Product> getByRestaurant(Restaurant restaurant) {
        return productRepository.findByRestaurant(restaurant);
    }

    @Override
    public Product save(Product product) {
        return productRepository.save(product);
    }

    @Override
    public Product saveWithImage(Product product, MultipartFile imageFile) throws IOException {
        System.out.println("[ProductService] saveWithImage called");
        System.out.println("[ProductService] Product ID: " + product.getId());
        System.out.println("[ProductService] ImageFile: " + (imageFile != null ? (imageFile.isEmpty() ? "empty" : imageFile.getOriginalFilename() + " (" + imageFile.getSize() + " bytes)") : "null"));
        
        logger.info("saveWithImage called - Product ID: {}, ImageFile: {}", 
                    product.getId(), 
                    imageFile != null ? (imageFile.isEmpty() ? "empty" : imageFile.getOriginalFilename()) : "null");
        
        // Upload ảnh nếu có file mới
        if (imageFile != null && !imageFile.isEmpty()) {
            System.out.println("[ProductService] Uploading new image file: " + imageFile.getOriginalFilename());
            logger.info("Uploading new image file: {}, size: {} bytes", 
                       imageFile.getOriginalFilename(), 
                       imageFile.getSize());
            String imageUrl = fileUploadService.saveFile(imageFile);
            System.out.println("[ProductService] Image uploaded, URL: " + imageUrl);
            logger.info("Image uploaded successfully, URL: {}", imageUrl);
            product.setImage(imageUrl);
        } else if (product.getId() != null) {
            System.out.println("[ProductService] Editing existing product, no new image");
            // Nếu đang edit và không upload ảnh mới
            logger.info("Editing existing product, no new image uploaded");
            // Kiểm tra xem đã có ảnh trong product chưa (từ hidden input)
            if (product.getImage() == null || product.getImage().trim().isEmpty()) {
                // Nếu chưa có, lấy từ database
                logger.info("Product image is null or empty, fetching from database");
                Product existing = productRepository.findById(product.getId()).orElse(null);
                if (existing != null && existing.getImage() != null) {
                    logger.info("Retrieved existing image from database: {}", existing.getImage());
                    product.setImage(existing.getImage());
                } else {
                    logger.warn("Existing product not found or has no image");
                }
            } else {
                logger.info("Keeping existing image from form: {}", product.getImage());
            }
            // Nếu product.getImage() đã có giá trị (từ hidden input), giữ nguyên
        } else {
            logger.warn("No image file provided and product is new (no ID)");
        }
        
        Product saved = productRepository.save(product);
        logger.info("Product saved successfully with image: {}", saved.getImage());
        return saved;
    }

    @Override
    public void delete(Long id) {
        productRepository.deleteById(id);
    }
}

