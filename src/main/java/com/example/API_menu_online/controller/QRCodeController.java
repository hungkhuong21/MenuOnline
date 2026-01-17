package com.example.API_menu_online.controller;

import com.example.API_menu_online.entity.Restaurant;
import com.example.API_menu_online.repository.RestaurantRepository;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Optional;

/**
 * REST controller chịu trách nhiệm tạo ảnh QR Code cho nhà hàng.
 * - API chính: GET /restaurant/{id}/qr
 *   + Lấy nhà hàng theo id
 *   + Đọc qrToken đã được sinh sẵn khi tạo nhà hàng
 *   + Tạo URL menu công khai dựa trên qrToken
 *   + Generate ảnh QR (PNG) từ URL này bằng thư viện ZXing
 */
@RestController
@RequestMapping("/restaurant")
public class QRCodeController {

    private final RestaurantRepository restaurantRepository;

    @Value("${app.base.url:http://localhost:8080}")
    private String baseUrl;
    
    @Value("${app.context.path:/API_menu_online}")
    private String contextPath;

    public QRCodeController(RestaurantRepository restaurantRepository) {
        this.restaurantRepository = restaurantRepository;
    }

    /**
     * API tạo và trả về ảnh QR Code cho 1 nhà hàng:
     * - Kiểm tra nhà hàng tồn tại theo id
     * - Đọc qrToken từ entity Restaurant
     * - Tạo URL menu dạng: {baseUrl}{contextPath}/restaurant/token/{qrToken}/menu
     * - Generate QR code PNG từ URL và trả về cho client
     */
    @GetMapping("/{id}/qr")
    public ResponseEntity<byte[]> getRestaurantQRCode(@PathVariable("id") Long id) throws WriterException, IOException {
        // Tìm nhà hàng theo id
        Optional<Restaurant> optRestaurant = restaurantRepository.findById(id);
        if (optRestaurant.isEmpty()) {
            // Không tìm thấy -> trả về 404
            return ResponseEntity.notFound().build();
        }

        Restaurant restaurant = optRestaurant.get();
        // Lấy qrToken đã được sinh sẵn khi tạo nhà hàng (xem Restaurant.generateQrToken)
        String qrToken = restaurant.getQrToken();
        
        // Tạo URL đến trang menu sử dụng qrToken thay vì id (bảo mật hơn, khó đoán hơn)
        String path = contextPath.endsWith("/") ? contextPath : contextPath + "/";
        String menuUrl = baseUrl + path + "restaurant/token/" + qrToken + "/menu";

        System.out.println("QR Code URL: " + menuUrl);

        // Sử dụng thư viện ZXing để generate ma trận QR từ URL
        QRCodeWriter qrCodeWriter = new QRCodeWriter();
        BitMatrix bitMatrix = qrCodeWriter.encode(menuUrl, BarcodeFormat.QR_CODE, 300, 300);

        // Chuyển BitMatrix thành ảnh PNG lưu trong bộ nhớ (byte array)
        ByteArrayOutputStream pngOutputStream = new ByteArrayOutputStream();
        MatrixToImageWriter.writeToStream(bitMatrix, "PNG", pngOutputStream);

        byte[] pngData = pngOutputStream.toByteArray();

        // Thiết lập header Content-Type để browser hiểu là ảnh PNG
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.IMAGE_PNG);

        return ResponseEntity.ok().headers(headers).body(pngData);
    }
}