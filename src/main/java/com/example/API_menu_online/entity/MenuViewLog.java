package com.example.API_menu_online.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "menu_view_log")
public class MenuViewLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "restaurant_id", nullable = false)
    private Restaurant restaurant;

    @Column(name = "view_time")
    private LocalDateTime viewTime = LocalDateTime.now();

    @Column(name = "ip_address")
    private String ipAddress;

    @Column(name = "user_agent", length = 500)
    private String userAgent;

    // --- Getters & Setters ---
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Restaurant getRestaurant() { return restaurant; }
    public void setRestaurant(Restaurant restaurant) { this.restaurant = restaurant; }

    public LocalDateTime getViewTime() { return viewTime; }
    public void setViewTime(LocalDateTime viewTime) { this.viewTime = viewTime; }

    public String getIpAddress() { return ipAddress; }
    public void setIpAddress(String ipAddress) { this.ipAddress = ipAddress; }

    public String getUserAgent() { return userAgent; }
    public void setUserAgent(String userAgent) { this.userAgent = userAgent; }
}
