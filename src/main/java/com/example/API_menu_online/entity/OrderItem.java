package com.example.API_menu_online.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "order_item")
public class OrderItem {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "order_id", nullable = false)
    private Order order;

    @ManyToOne
    @JoinColumn(name = "product_id", nullable = false)
    private Product product;

    @Column(nullable = false)
    private Integer quantity = 1;

    @Column(nullable = false)
    private Double price; // Giá tại thời điểm đặt hàng

    @Column(name = "subtotal", nullable = false)
    private Double subtotal; // quantity * price

    // Getters & Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Order getOrder() { return order; }
    public void setOrder(Order order) { this.order = order; }

    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }

    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { 
        this.quantity = quantity;
        calculateSubtotal();
    }

    public Double getPrice() { return price; }
    public void setPrice(Double price) { 
        this.price = price;
        calculateSubtotal();
    }

    public Double getSubtotal() { return subtotal; }
    public void setSubtotal(Double subtotal) { this.subtotal = subtotal; }

    private void calculateSubtotal() {
        if (this.price != null && this.quantity != null) {
            this.subtotal = this.price * this.quantity;
        }
    }
}

