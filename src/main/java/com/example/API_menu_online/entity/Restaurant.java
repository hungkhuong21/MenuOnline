package com.example.API_menu_online.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Entity đại diện cho bảng restaurant trong database.
 * Mỗi nhà hàng có:
 * - id tự tăng (AUTO_INCREMENT)
 * - thông tin cơ bản: name, address, description, logo
 * - qrToken: chuỗi UUID dùng làm mã QR duy nhất cho nhà hàng
 * - owner: user sở hữu nhà hàng
 * - isActive: trạng thái hoạt động
 * - createdAt: thời điểm tạo
 */
@Entity
@Table(name = "restaurant")
public class Restaurant {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    private String address;

    @Column(columnDefinition = "TEXT")
    private String description;

    private String logo;

    // Mã QR token duy nhất cho mỗi nhà hàng (dùng để tạo link/QR an toàn hơn id)
    @Column(name = "qr_token", nullable = false, unique = true)
    private String qrToken;

    @ManyToOne
    @JoinColumn(name = "owner_id")
    private User owner;

    @Column(name = "is_active")
    private Boolean isActive = true;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    /**
     * Hàm lifecycle @PrePersist:
     * - Được JPA gọi tự động trước khi insert bản ghi mới vào database
     * - Nếu qrToken chưa có, sinh mới một UUID và gán cho qrToken
     *   => đảm bảo mỗi nhà hàng luôn có một mã QR token duy nhất
     */
    @PrePersist
    public void generateQrToken() {
        if (this.qrToken == null || this.qrToken.isEmpty()) {
            this.qrToken = UUID.randomUUID().toString();
        }
    }

    // --- Getter & Setter ---
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getLogo() { return logo; }
    public void setLogo(String logo) { this.logo = logo; }

    public String getQrToken() { return qrToken; }
    public void setQrToken(String qrToken) { this.qrToken = qrToken; }

    public User getOwner() { return owner; }
    public void setOwner(User owner) { this.owner = owner; }

    public Boolean getIsActive() { return isActive; }
    public void setIsActive(Boolean isActive) { this.isActive = isActive; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
