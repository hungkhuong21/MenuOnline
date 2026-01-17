package com.example.API_menu_online.controller;

import com.example.API_menu_online.dto.CartItemDTO;
import com.example.API_menu_online.entity.Order;
import com.example.API_menu_online.entity.Restaurant;
import com.example.API_menu_online.entity.User;
import com.example.API_menu_online.service.OrderService;
import com.example.API_menu_online.service.RestaurantService;
import com.example.API_menu_online.service.UserService;
import com.example.API_menu_online.util.UserContextHelper;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Controller
@RequestMapping("/orders")
public class OrderController {

    private final OrderService orderService;
    private final RestaurantService restaurantService;
    private final UserService userService;
    private final UserContextHelper userContextHelper;

    @Autowired
    public OrderController(OrderService orderService,
                          RestaurantService restaurantService,
                          UserService userService,
                          UserContextHelper userContextHelper) {
        this.orderService = orderService;
        this.restaurantService = restaurantService;
        this.userService = userService;
        this.userContextHelper = userContextHelper;
    }

    private User getCurrentUser(HttpSession session) {
        return userContextHelper.getCurrentUser(session);
    }

    // API: Tạo đơn hàng từ giỏ hàng
    @PostMapping("/create")
    @ResponseBody
    public ResponseEntity<?> createOrder(@Valid @RequestBody OrderRequest request, BindingResult bindingResult) {
        try {
            // Kiểm tra validation errors
            if (bindingResult.hasErrors()) {
                StringBuilder errorMessage = new StringBuilder();
                bindingResult.getFieldErrors().forEach(error -> {
                    if (errorMessage.length() > 0) errorMessage.append(", ");
                    errorMessage.append(error.getDefaultMessage());
                });
                return ResponseEntity.badRequest().body(Map.of("error", errorMessage.toString()));
            }

            Optional<Restaurant> optRestaurant = restaurantService.getById(request.getRestaurantId());
            if (optRestaurant.isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of("error", "Nhà hàng không tồn tại"));
            }

            // Tạo đơn hàng
            Order order = new Order();
            order.setRestaurant(optRestaurant.get());
            order.setCustomerName(request.getCustomerName().trim());
            order.setCustomerPhone(request.getCustomerPhone().trim());
            order.setCustomerAddress(request.getCustomerAddress() != null ? request.getCustomerAddress().trim() : "");
            order.setNote(request.getNote() != null ? request.getNote().trim() : "");
            order.setStatus(Order.OrderStatus.PENDING);

            // Chuyển đổi các món trong giỏ hàng sang CartItemDTO
            List<CartItemDTO> cartItems = new ArrayList<>();
            for (CartItem item : request.getItems()) {
                cartItems.add(new CartItemDTO(item.getProductId(), item.getQuantity()));
            }

            Order savedOrder = orderService.createOrder(order, cartItems);

            return ResponseEntity.ok(Map.of(
                "success", true,
                "orderCode", savedOrder.getOrderCode(),
                "message", "Đặt hàng thành công! Mã đơn hàng: " + savedOrder.getOrderCode()
            ));

        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", "Lỗi: " + e.getMessage()));
        }
    }

    // Xem danh sách đơn hàng (Merchant)
    @GetMapping("/manage")
    public String listOrders(
            @RequestParam(value = "restaurantId", required = false) Long restaurantId,
            @RequestParam(value = "status", required = false) String status,
            Model model,
            HttpServletRequest request) {
        
        if (restaurantId == null) {
            model.addAttribute("error", "Vui lòng chọn nhà hàng");
            return "merchant/order-list";
        }

        Optional<Restaurant> optRestaurant = restaurantService.getById(restaurantId);
        if (optRestaurant.isEmpty()) {
            model.addAttribute("error", "Nhà hàng không tồn tại");
            return "merchant/order-list";
        }

        Restaurant restaurant = optRestaurant.get();
        List<Order> orders;

        if (status != null && !status.isEmpty()) {
            try {
                Order.OrderStatus orderStatus = Order.OrderStatus.valueOf(status.toUpperCase());
                orders = orderService.getByRestaurantAndStatus(restaurant, orderStatus);
            } catch (IllegalArgumentException e) {
                orders = orderService.getByRestaurant(restaurant);
            }
        } else {
            orders = orderService.getByRestaurant(restaurant);
        }

        // Lấy user hiện tại cho navbar
        HttpSession session = request.getSession(false);
        User currentUser = getCurrentUser(session);
        if (currentUser == null && restaurant.getOwner() != null) {
            currentUser = restaurant.getOwner();
        }
        model.addAttribute("user", currentUser);

        model.addAttribute("restaurant", restaurant);
        model.addAttribute("orders", orders);
        model.addAttribute("selectedStatus", status);
        model.addAttribute("totalOrders", orders.size());
        model.addAttribute("pendingOrders", orders.stream()
            .filter(o -> o.getStatus() == Order.OrderStatus.PENDING).count());
        model.addAttribute("totalRevenue", orders.stream()
            .filter(o -> o.getStatus() == Order.OrderStatus.COMPLETED)
            .mapToDouble(Order::getTotalAmount).sum());

        return "merchant/order-list";
    }

    // Xem chi tiết đơn hàng
    @GetMapping("/{id}")
    public String viewOrder(@PathVariable("id") Long id, Model model, HttpServletRequest request) {
        Optional<Order> optOrder = orderService.getById(id);
        if (optOrder.isEmpty()) {
            model.addAttribute("error", "Đơn hàng không tồn tại");
            return "common/error";
        }

        Order order = optOrder.get();
        HttpSession session = request.getSession(false);
        User currentUser = getCurrentUser(session);
        if (currentUser == null && order.getRestaurant().getOwner() != null) {
            currentUser = order.getRestaurant().getOwner();
        }
        
        model.addAttribute("user", currentUser);
        model.addAttribute("order", order);
        model.addAttribute("restaurant", order.getRestaurant());
        return "merchant/order-detail";
    }

    // Cập nhật trạng thái đơn hàng
    @PostMapping(value = "/{id}/update-status", produces = "text/html;charset=UTF-8", consumes = "application/x-www-form-urlencoded;charset=UTF-8")
    public String updateStatus(
            @PathVariable("id") Long id,
            @RequestParam("status") String status,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes) {
        try {
            Optional<Order> optOrder = orderService.getById(id);
            if (optOrder.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Đơn hàng không tồn tại");
                return "redirect:/orders/manage";
            }

            Order order = optOrder.get();
            try {
                Order.OrderStatus newStatus = Order.OrderStatus.valueOf(status.toUpperCase());
                order.setStatus(newStatus);
                orderService.save(order);
                redirectAttributes.addFlashAttribute("success", "Đã cập nhật trạng thái đơn hàng");
            } catch (IllegalArgumentException e) {
                redirectAttributes.addFlashAttribute("error", "Trạng thái không hợp lệ");
            }

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }

        Optional<Order> optOrder = orderService.getById(id);
        if (optOrder.isPresent()) {
            return "redirect:/orders/manage?restaurantId=" + optOrder.get().getRestaurant().getId();
        }
        return "redirect:/orders/manage";
    }

    // ========== DTOs (Data Transfer Objects) ==========
    public static class OrderRequest {
        @NotNull(message = "Vui lòng chọn nhà hàng")
        @Positive(message = "ID nhà hàng không hợp lệ")
        private Long restaurantId;
        
        @NotBlank(message = "Vui lòng nhập tên")
        private String customerName;
        
        @NotBlank(message = "Vui lòng nhập số điện thoại")
        private String customerPhone;
        
        private String customerAddress;
        private String note;
        
        @NotEmpty(message = "Giỏ hàng trống")
        private List<CartItem> items;

        // ========== Getters & Setters ==========
        public Long getRestaurantId() { return restaurantId; }
        public void setRestaurantId(Long restaurantId) { this.restaurantId = restaurantId; }

        public String getCustomerName() { return customerName; }
        public void setCustomerName(String customerName) { this.customerName = customerName; }

        public String getCustomerPhone() { return customerPhone; }
        public void setCustomerPhone(String customerPhone) { this.customerPhone = customerPhone; }

        public String getCustomerAddress() { return customerAddress; }
        public void setCustomerAddress(String customerAddress) { this.customerAddress = customerAddress; }

        public String getNote() { return note; }
        public void setNote(String note) { this.note = note; }

        public List<CartItem> getItems() { return items; }
        public void setItems(List<CartItem> items) { this.items = items; }
    }

    public static class CartItem {
        @NotNull(message = "ID sản phẩm không được để trống")
        @Positive(message = "ID sản phẩm không hợp lệ")
        private Long productId;
        
        @NotNull(message = "Số lượng không được để trống")
        @Positive(message = "Số lượng phải lớn hơn 0")
        private Integer quantity;

        // ========== Getters & Setters ==========
        public Long getProductId() { return productId; }
        public void setProductId(Long productId) { this.productId = productId; }

        public Integer getQuantity() { return quantity; }
        public void setQuantity(Integer quantity) { this.quantity = quantity; }
    }
}

