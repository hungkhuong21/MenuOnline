package com.example.API_menu_online.service.impl;

import com.example.API_menu_online.dto.CartItemDTO;
import com.example.API_menu_online.entity.Order;
import com.example.API_menu_online.entity.OrderItem;
import com.example.API_menu_online.entity.Product;
import com.example.API_menu_online.entity.Restaurant;
import com.example.API_menu_online.repository.OrderRepository;
import com.example.API_menu_online.repository.ProductRepository;
import com.example.API_menu_online.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class OrderServiceImpl implements OrderService {
    
    private final OrderRepository orderRepository;
    private final ProductRepository productRepository;

    @Autowired
    public OrderServiceImpl(OrderRepository orderRepository, ProductRepository productRepository) {
        this.orderRepository = orderRepository;
        this.productRepository = productRepository;
    }

    @Override
    public List<Order> getAll() {
        return orderRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public Optional<Order> getById(Long id) {
        return orderRepository.findById(id);
    }

    @Override
    public Optional<Order> getByOrderCode(String orderCode) {
        return orderRepository.findByOrderCode(orderCode);
    }

    @Override
    public List<Order> getByRestaurant(Restaurant restaurant) {
        return orderRepository.findByRestaurantOrderByCreatedAtDesc(restaurant);
    }

    @Override
    public List<Order> getByRestaurantAndStatus(Restaurant restaurant, Order.OrderStatus status) {
        return orderRepository.findByRestaurantAndStatus(restaurant, status);
    }

    @Override
    @Transactional
    public Order save(Order order) {
        // Tính tổng tiền
        double total = 0.0;
        for (OrderItem item : order.getItems()) {
            total += item.getSubtotal();
        }
        order.setTotalAmount(total);
        
        return orderRepository.save(order);
    }

    @Override
    @Transactional
    public Order createOrder(Order order, List<CartItemDTO> cartItems) {
        // Thiết lập các món trong đơn hàng
        for (CartItemDTO cartItem : cartItems) {
            Optional<Product> optProduct = productRepository.findById(cartItem.getProductId());
            if (optProduct.isPresent()) {
                Product product = optProduct.get();
                
                OrderItem orderItem = new OrderItem();
                orderItem.setOrder(order);
                orderItem.setProduct(product);
                orderItem.setQuantity(cartItem.getQuantity());
                orderItem.setPrice(product.getPrice());
                orderItem.setSubtotal(product.getPrice() * cartItem.getQuantity());
                
                order.getItems().add(orderItem);
            }
        }
        
        return save(order);
    }

    @Override
    public void delete(Long id) {
        orderRepository.deleteById(id);
    }
}

