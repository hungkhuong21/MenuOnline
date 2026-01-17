package com.example.API_menu_online.controller;

import com.example.API_menu_online.entity.*;
import com.example.API_menu_online.service.*;
import com.example.API_menu_online.util.UserContextHelper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

@Controller
public class WebController {

    private static final Logger logger = LoggerFactory.getLogger(WebController.class);

    private final UserService userService;
    private final RestaurantService restaurantService;
    private final CategoryService categoryService;
    private final ProductService productService;
    private final MenuViewLogService menuViewLogService;
    private final FileUploadService fileUploadService;
    private final UserContextHelper userContextHelper;

    @Autowired
    public WebController(UserService userService,
                        RestaurantService restaurantService,
                        CategoryService categoryService,
                        ProductService productService,
                        MenuViewLogService menuViewLogService,
                        FileUploadService fileUploadService,
                        UserContextHelper userContextHelper) {
        this.userService = userService;
        this.restaurantService = restaurantService;
        this.categoryService = categoryService;
        this.productService = productService;
        this.menuViewLogService = menuViewLogService;
        this.fileUploadService = fileUploadService;
        this.userContextHelper = userContextHelper;
    }

    // ==================== LOGIN ====================
    @GetMapping("/login")
    public String loginPage(
            @RequestParam(value = "error", required = false) String error,
            @RequestParam(value = "logout", required = false) String logout,
            @RequestParam(value = "message", required = false) String message,
            HttpSession session,
            Model model) {

        // Kiểm tra nếu user đã authenticated, redirect về dashboard
        if (session != null && session.getAttribute("userId") != null) {
            return "redirect:/dashboard";
        }

        if (error != null) {
            if ("access_denied".equals(error)) {
                model.addAttribute("error", "Bạn không có quyền truy cập trang này!");
            } else {
                model.addAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng!");
            }
        }

        if (logout != null) {
            model.addAttribute("message", "Đăng xuất thành công!");
        }
        
        if (message != null) {
            if ("logout".equals(message)) {
                model.addAttribute("message", "Bạn đã đăng xuất thành công!");
            } else if ("required".equals(message)) {
                model.addAttribute("message", "Vui lòng đăng nhập để tiếp tục!");
            }
        }

        return "auth/login";
    }

    /**
     * Xử lý submit form đăng nhập:
     * - Gọi UserService.authenticate để kiểm tra username/password
     * - Nếu đúng: lưu thông tin user vào HttpSession và chuyển về trang dashboard
     * - Nếu sai: redirect lại trang login với param error
     */
    @PostMapping("/login")
    public String processLogin(@RequestParam String username, 
                              @RequestParam String password, 
                              Model model,
                              HttpSession session) {
        // Xác thực với database (so sánh password đã mã hóa bằng BCrypt)
        Optional<User> userOpt = userService.authenticate(username, password);

        if (userOpt.isPresent()) {
            User user = userOpt.get();
            // Lưu thông tin user vào session để dùng cho các request sau
            session.setAttribute("userId", user.getId());
            session.setAttribute("username", user.getUsername());
            session.setAttribute("user", user);
            return "redirect:/dashboard";
        }

        // Đăng nhập thất bại -> hiển thị thông báo lỗi trên trang login
        return "redirect:/login?error";
    }

    /**
     * Đăng xuất (GET):
     * - Xóa toàn bộ session hiện tại
     * - Redirect về trang login với thông báo đã logout
     */
    @GetMapping("/logout")
    public String logoutGet(HttpSession session) {
        session.invalidate();
        return "redirect:/login?message=logout";
    }

    /**
     * Đăng xuất (POST) - dùng khi submit form logout:
     * - Xóa toàn bộ session hiện tại
     * - Redirect về trang login với thông báo đã logout
     */
    @PostMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login?message=logout";
    }

    // ==================== DASHBOARD ====================
    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        User currentUser = getCurrentUser();
        List<Restaurant> restaurants;

        if (currentUser.getRole() == User.Role.ADMIN) {
            restaurants = restaurantService.getAll();
        } else {
            restaurants = restaurantService.getByOwner(currentUser);
        }

        model.addAttribute("user", currentUser);
        model.addAttribute("restaurants", restaurants);

        // Thống kê tổng quan
        long totalProducts = 0;
        long totalViews = 0;
        long totalCategories = 0;
        for (Restaurant restaurant : restaurants) {
            totalProducts += productService.getByRestaurant(restaurant).size();
            totalViews += menuViewLogService.getByRestaurant(restaurant).size();
            totalCategories += categoryService.getByRestaurant(restaurant).size();
        }

        model.addAttribute("totalRestaurants", restaurants.size());
        model.addAttribute("totalProducts", totalProducts);
        model.addAttribute("totalViews", totalViews);
        model.addAttribute("totalCategories", totalCategories);

        return "merchant/dashboard";
    }

    // ==================== QUẢN LÝ NHÀ HÀNG ====================
    @GetMapping("/manage/restaurants")
    public String listRestaurants(Model model, RedirectAttributes redirectAttributes) {
        User currentUser = getCurrentUser();
        
        // MERCHANT không cần trang danh sách, redirect về dashboard
        if (currentUser.getRole() == User.Role.MERCHANT) {
            return "redirect:/dashboard";
        }
        
        List<Restaurant> restaurants;
        if (currentUser.getRole() == User.Role.ADMIN) {
            restaurants = restaurantService.getAll();
        } else {
            restaurants = restaurantService.getByOwner(currentUser);
        }

        model.addAttribute("restaurants", restaurants);
        model.addAttribute("user", currentUser);
        return "merchant/restaurant-list";
    }

    @GetMapping("/manage/restaurants/new")
    public String newRestaurantForm(Model model, RedirectAttributes redirectAttributes) {
        User currentUser = getCurrentUser();
        
        // Nếu là MERCHANT và đã có nhà hàng rồi thì không cho tạo thêm
        if (currentUser.getRole() == User.Role.MERCHANT) {
            List<Restaurant> userRestaurants = restaurantService.getByOwner(currentUser);
            if (!userRestaurants.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Bạn chỉ được tạo 1 nhà hàng!");
                return "redirect:/dashboard";
            }
        }
        
        model.addAttribute("user", currentUser);
        model.addAttribute("restaurant", new Restaurant());
        return "merchant/restaurant-form";
    }

    @GetMapping("/manage/restaurants/edit/{id}")
    public String editRestaurantForm(@PathVariable("id") Long id, Model model, RedirectAttributes redirectAttributes) {
        Optional<Restaurant> restaurant = restaurantService.getById(id);
        if (restaurant.isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy nhà hàng!");
            return "redirect:/manage/restaurants";
        }

        // Kiểm tra quyền
        User currentUser = getCurrentUser();
        if (currentUser.getRole() != User.Role.ADMIN &&
                !restaurant.get().getOwner().getId().equals(currentUser.getId())) {
            redirectAttributes.addFlashAttribute("error", "Bạn không có quyền chỉnh sửa nhà hàng này!");
            return "redirect:/manage/restaurants";
        }

        model.addAttribute("user", currentUser);
        model.addAttribute("restaurant", restaurant.get());
        return "merchant/restaurant-form";
    }

    /**
     * Lưu thông tin nhà hàng (tạo mới hoặc cập nhật):
     * - Nếu tạo mới: gán owner = user hiện tại, isActive mặc định true
     * - Nếu cập nhật: giữ nguyên owner, qrToken, createdAt, logo cũ nếu không upload mới
     * - Nếu có upload logo mới: lưu file và gán đường dẫn logo cho restaurant
     * - Sau cùng: gọi RestaurantService.save để lưu vào database
     */
    @PostMapping(value = "/manage/restaurants/save", produces = "text/html;charset=UTF-8", consumes = "multipart/form-data;charset=UTF-8")
    public String saveRestaurant(@ModelAttribute Restaurant restaurant,
                                 @RequestParam(value = "logoFile", required = false) MultipartFile logoFile,
                                 HttpServletRequest request,
                                 RedirectAttributes redirectAttributes) {
        try {
            // Xử lý isActive: nếu null hoặc không được set, mặc định là false
            if (restaurant.getIsActive() == null) {
                restaurant.setIsActive(false);
            }
            
            // Nếu tạo mới (chưa có ID), gán owner là user hiện tại
            if (restaurant.getId() == null) {
                User currentUser = getCurrentUser();
                restaurant.setOwner(currentUser);
                // Mặc định là active khi tạo mới nếu chưa set
                if (restaurant.getIsActive() == null) {
                    restaurant.setIsActive(true);
                }
            } else {
                // Nếu update, giữ nguyên owner, qrToken, createdAt và logo cũ (nếu không upload mới)
                Restaurant existing = restaurantService.getById(restaurant.getId()).orElse(null);
                if (existing != null) {
                    restaurant.setOwner(existing.getOwner());
                    restaurant.setQrToken(existing.getQrToken());
                    restaurant.setCreatedAt(existing.getCreatedAt());
                    // Giữ nguyên logo cũ nếu không upload logo mới
                    if ((logoFile == null || logoFile.isEmpty()) && existing.getLogo() != null) {
                        restaurant.setLogo(existing.getLogo());
                    }
                }
            }

            // Upload logo mới nếu có file được chọn
            if (logoFile != null && !logoFile.isEmpty()) {
                String logoUrl = fileUploadService.saveFile(logoFile);
                if (logoUrl != null) {
                    restaurant.setLogo(logoUrl);
                }
            }

            // Lưu hoặc cập nhật nhà hàng vào database
            restaurantService.save(restaurant);
            redirectAttributes.addFlashAttribute("success", "Lưu nhà hàng thành công!");
        } catch (IOException e) {
            logger.error("Lỗi upload ảnh nhà hàng", e);
            redirectAttributes.addFlashAttribute("error", "Lỗi upload ảnh: " + e.getMessage());
        } catch (Exception e) {
            logger.error("Lỗi lưu nhà hàng", e);
            redirectAttributes.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }

        // Sau khi lưu xong, điều hướng khác nhau cho ADMIN và MERCHANT
        User currentUser = getCurrentUser();
        if (currentUser.getRole() == User.Role.ADMIN) {
            return "redirect:/manage/restaurants";
        } else {
            return "redirect:/dashboard";
        }
    }

    // Toggle trạng thái nhà hàng (API endpoint cho AJAX)
    @PostMapping(value = "/api/restaurants/toggle-status/{id}", 
                 produces = {"application/json", "application/json;charset=UTF-8"},
                 consumes = {"application/x-www-form-urlencoded", "multipart/form-data"})
    @ResponseBody
    public java.util.Map<String, Object> toggleRestaurantStatusApi(@PathVariable("id") Long id, HttpServletRequest request) {
        java.util.Map<String, Object> response = new java.util.HashMap<>();
        try {
            // Kiểm tra user đã đăng nhập chưa
            User currentUser = getCurrentUser();
            if (currentUser == null) {
                response.put("success", false);
                response.put("message", "Bạn cần đăng nhập để thực hiện thao tác này!");
                return response;
            }
            
            Optional<Restaurant> restaurantOpt = restaurantService.getById(id);
            if (restaurantOpt.isEmpty()) {
                response.put("success", false);
                response.put("message", "Không tìm thấy nhà hàng!");
                return response;
            }

            Restaurant restaurant = restaurantOpt.get();
            
            // Kiểm tra quyền
            if (currentUser.getRole() != User.Role.ADMIN &&
                    (restaurant.getOwner() == null || !restaurant.getOwner().getId().equals(currentUser.getId()))) {
                response.put("success", false);
                response.put("message", "Bạn không có quyền thay đổi trạng thái nhà hàng này!");
                return response;
            }

            // Toggle status
            if (restaurant.getIsActive() == null) {
                restaurant.setIsActive(true);
            } else {
                restaurant.setIsActive(!restaurant.getIsActive());
            }
            
            restaurantService.save(restaurant);
            
            response.put("success", true);
            response.put("isActive", restaurant.getIsActive());
            response.put("message", "Đã đổi trạng thái nhà hàng thành: " + (restaurant.getIsActive() ? "Hoạt động" : "Tạm ngừng"));
        } catch (Exception e) {
            logger.error("Lỗi toggle trạng thái nhà hàng API", e);
            response.put("success", false);
            response.put("message", "Lỗi: " + (e.getMessage() != null ? e.getMessage() : e.getClass().getSimpleName()));
        }
        return response;
    }

    // Toggle trạng thái nhà hàng (Form submit - fallback)
    @PostMapping("/manage/restaurants/toggle-status/{id}")
    public String toggleRestaurantStatus(@PathVariable("id") Long id, RedirectAttributes redirectAttributes) {
        try {
            Optional<Restaurant> restaurantOpt = restaurantService.getById(id);
            if (restaurantOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy nhà hàng!");
                return "redirect:/manage/restaurants";
            }

            Restaurant restaurant = restaurantOpt.get();
            
            // Kiểm tra quyền
            User currentUser = getCurrentUser();
            if (currentUser.getRole() != User.Role.ADMIN &&
                    !restaurant.getOwner().getId().equals(currentUser.getId())) {
                redirectAttributes.addFlashAttribute("error", "Bạn không có quyền thay đổi trạng thái nhà hàng này!");
                return "redirect:/manage/restaurants";
            }

            // Toggle status
            if (restaurant.getIsActive() == null) {
                restaurant.setIsActive(true);
            } else {
                restaurant.setIsActive(!restaurant.getIsActive());
            }
            
            restaurantService.save(restaurant);
            
            String status = restaurant.getIsActive() ? "Hoạt động" : "Tạm ngừng";
            redirectAttributes.addFlashAttribute("success", "Đã đổi trạng thái nhà hàng thành: " + status);
        } catch (Exception e) {
            logger.error("Lỗi toggle trạng thái nhà hàng", e);
            redirectAttributes.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }

        User currentUser = getCurrentUser();
        if (currentUser.getRole() == User.Role.ADMIN) {
            return "redirect:/manage/restaurants";
        } else {
            return "redirect:/dashboard";
        }
    }

    @PostMapping("/manage/restaurants/delete/{id}")
    public String deleteRestaurant(@PathVariable("id") Long id, 
                                   HttpServletRequest request,
                                   RedirectAttributes redirectAttributes) {
        try {
            User currentUser = getCurrentUser();
            Optional<Restaurant> restaurantOpt = restaurantService.getById(id);
            
            if (restaurantOpt.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Nhà hàng không tồn tại!");
                return "redirect:/manage/restaurants";
            }
            
            Restaurant restaurant = restaurantOpt.get();
            
            // Kiểm tra quyền: MERCHANT chỉ có thể xóa nhà hàng của chính mình
            if (currentUser.getRole() == User.Role.MERCHANT && 
                !restaurant.getOwner().getId().equals(currentUser.getId())) {
                redirectAttributes.addFlashAttribute("error", "Bạn không có quyền xóa nhà hàng này!");
                return "redirect:/manage/restaurants";
            }
            
            restaurantService.delete(id);
            redirectAttributes.addFlashAttribute("success", "Xóa nhà hàng thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi xóa nhà hàng: " + e.getMessage());
        }
        return "redirect:/dashboard";
    }

    // ==================== QUẢN LÝ DANH MỤC ====================
    @GetMapping("/manage/categories")
    public String listCategories(@RequestParam("restaurantId") Long restaurantId, Model model) {
        Restaurant restaurant = restaurantService.getById(restaurantId).orElse(null);
        if (restaurant == null) {
            return "redirect:/manage/restaurants";
        }

        User currentUser = getCurrentUser();
        List<Category> categories = categoryService.getByRestaurant(restaurant);
        model.addAttribute("user", currentUser);
        model.addAttribute("restaurant", restaurant);
        model.addAttribute("categories", categories);
        return "merchant/category-list";
    }

    @PostMapping(value = "/manage/categories/save", produces = "text/html;charset=UTF-8", consumes = "application/x-www-form-urlencoded;charset=UTF-8")
    public String saveCategory(@ModelAttribute Category category, 
                               HttpServletRequest request,
                               RedirectAttributes redirectAttributes) {
        categoryService.save(category);
        redirectAttributes.addFlashAttribute("success", "Lưu danh mục thành công!");
        return "redirect:/manage/categories?restaurantId=" + category.getRestaurant().getId();
    }

    @PostMapping("/manage/categories/delete/{id}")
    public String deleteCategory(@PathVariable("id") Long id, @RequestParam("restaurantId") Long restaurantId, RedirectAttributes redirectAttributes) {
        categoryService.delete(id);
        redirectAttributes.addFlashAttribute("success", "Xóa danh mục thành công!");
        return "redirect:/manage/categories?restaurantId=" + restaurantId;
    }

    // ==================== QUẢN LÝ MÓN ĂN ====================
    @GetMapping("/manage/products")
    public String listProducts(@RequestParam("restaurantId") Long restaurantId, Model model) {
        Restaurant restaurant = restaurantService.getById(restaurantId).orElse(null);
        if (restaurant == null) {
            return "redirect:/manage/restaurants";
        }

        User currentUser = getCurrentUser();
        List<Product> products = productService.getByRestaurant(restaurant);
        List<Category> categories = categoryService.getByRestaurant(restaurant);

        model.addAttribute("user", currentUser);
        model.addAttribute("restaurant", restaurant);
        model.addAttribute("products", products);
        model.addAttribute("categories", categories);
        return "merchant/product-list";
    }

    @PostMapping(value = "/manage/products/save", produces = "text/html;charset=UTF-8", consumes = "multipart/form-data;charset=UTF-8")
    public String saveProduct(@ModelAttribute Product product,
                              @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
                              HttpServletRequest request,
                              RedirectAttributes redirectAttributes) {
        try {
            System.out.println("========================================");
            System.out.println("[WebController] saveProduct called");
            System.out.println("[WebController] Product ID: " + product.getId());
            System.out.println("[WebController] Product Name: " + product.getName());
            System.out.println("[WebController] ImageFile: " + (imageFile != null ? (imageFile.isEmpty() ? "empty" : imageFile.getOriginalFilename() + " (" + imageFile.getSize() + " bytes)") : "null"));
            
            logger.info("saveProduct called - Product ID: {}, Name: {}", product.getId(), product.getName());
            logger.info("ImageFile received: {}", 
                       imageFile != null ? (imageFile.isEmpty() ? "empty" : imageFile.getOriginalFilename() + " (" + imageFile.getSize() + " bytes)") : "null");
            
            // Business logic xử lý ảnh đã được di chuyển sang ProductService
            productService.saveWithImage(product, imageFile);
            
            System.out.println("[WebController] Product saved - Image URL: " + product.getImage());
            logger.info("Product saved successfully - ID: {}, Image: {}", product.getId(), product.getImage());
            redirectAttributes.addFlashAttribute("success", "Lưu món ăn thành công!");
            System.out.println("========================================");
        } catch (IOException e) {
            System.out.println("[WebController] ERROR IOException: " + e.getMessage());
            e.printStackTrace();
            logger.error("Error saving product with image", e);
            redirectAttributes.addFlashAttribute("error", "Lỗi upload ảnh: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("[WebController] ERROR Exception: " + e.getMessage());
            e.printStackTrace();
            logger.error("Unexpected error saving product", e);
            redirectAttributes.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }

        return "redirect:/manage/products?restaurantId=" + product.getRestaurant().getId();
    }

    @PostMapping("/manage/products/delete/{id}")
    public String deleteProduct(@PathVariable("id") Long id, @RequestParam("restaurantId") Long restaurantId, RedirectAttributes redirectAttributes) {
        productService.delete(id);
        redirectAttributes.addFlashAttribute("success", "Xóa món ăn thành công!");
        return "redirect:/manage/products?restaurantId=" + restaurantId;
    }

    @PostMapping("/manage/products/toggle-status/{id}")
    public String toggleProductStatus(@PathVariable("id") Long id, @RequestParam("restaurantId") Long restaurantId, RedirectAttributes redirectAttributes) {
        try {
            Product product = productService.getById(id).orElse(null);
            if (product != null) {
                product.setAvailable(!product.getAvailable());
                productService.save(product);
                String status = product.getAvailable() ? "Còn hàng" : "Hết hàng";
                redirectAttributes.addFlashAttribute("success", "Đã đổi trạng thái thành: " + status);
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }
        return "redirect:/manage/products?restaurantId=" + restaurantId;
    }

    // ==================== THỐNG KÊ ====================
    @GetMapping("/manage/statistics")
    public String statistics(@RequestParam("restaurantId") Long restaurantId, Model model) {
        try {
            logger.debug("Statistics request for restaurantId: {}", restaurantId);
            
            User currentUser = getCurrentUser();
            if (currentUser == null) {
                logger.warn("Statistics: User not found");
                return "redirect:/login";
            }
            logger.debug("Statistics: User found: {}", currentUser.getFullName());
            
            model.addAttribute("user", currentUser);
            
            Restaurant restaurant = restaurantService.getById(restaurantId).orElse(null);
            if (restaurant == null) {
                logger.warn("Statistics: Restaurant not found for ID: {}", restaurantId);
                // Vẫn render trang nhưng với restaurant = null để hiển thị thông báo lỗi
                model.addAttribute("restaurant", null);
                model.addAttribute("logs", new java.util.ArrayList<>());
                model.addAttribute("totalViews", 0);
                return "merchant/statistics";
            }
            logger.debug("Statistics: Restaurant found: {}", restaurant.getName());

            List<MenuViewLog> logs = menuViewLogService.getByRestaurant(restaurant);
            logger.debug("Statistics: Logs count = {}", logs != null ? logs.size() : 0);
            
            model.addAttribute("restaurant", restaurant);
            model.addAttribute("logs", logs != null ? logs : new java.util.ArrayList<>());
            model.addAttribute("totalViews", logs != null ? logs.size() : 0);

            return "merchant/statistics";
        } catch (Exception e) {
            logger.error("Statistics ERROR", e);
            // Vẫn render trang với thông báo lỗi
            User currentUser = getCurrentUser();
            if (currentUser != null) {
                model.addAttribute("user", currentUser);
            }
            model.addAttribute("restaurant", null);
            model.addAttribute("logs", new java.util.ArrayList<>());
            model.addAttribute("totalViews", 0);
            model.addAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
            return "merchant/statistics";
        }
    }

    // ==================== HELPER METHODS ====================
    private User getCurrentUser(HttpSession session) {
        return userContextHelper.getCurrentUser(session);
    }
    
    private User getCurrentUser() {
        // Lấy session từ request
        HttpServletRequest request = ((org.springframework.web.context.request.ServletRequestAttributes) 
            org.springframework.web.context.request.RequestContextHolder.getRequestAttributes())
            .getRequest();
        HttpSession session = request.getSession(false);
        return getCurrentUser(session);
    }
}