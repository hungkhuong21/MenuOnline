package com.example.API_menu_online.exception;

import org.springframework.http.HttpStatus;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.NoHandlerFoundException;

import java.util.logging.Logger;

/**
 * Global Exception Handler
 * Handles exceptions across all controllers
 */
@ControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger logger = Logger.getLogger(GlobalExceptionHandler.class.getName());

    /**
     * Handle 404 Not Found errors
     */
    @ExceptionHandler(NoHandlerFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public String handleNotFound(NoHandlerFoundException e, Model model) {
        logger.warning("404 Not Found: " + e.getRequestURL());
        model.addAttribute("errorMessage", "Trang không tồn tại");
        model.addAttribute("errorCode", "404");
        return "common/error";
    }

    /**
     * Handle general exceptions
     */
    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public String handleException(Exception e, Model model) {
        logger.severe("Unhandled exception: " + e.getMessage());
        e.printStackTrace();
        model.addAttribute("errorMessage", "Đã xảy ra lỗi: " + e.getMessage());
        model.addAttribute("errorCode", "500");
        return "common/error";
    }

    /**
     * Handle IllegalArgumentException
     */
    @ExceptionHandler(IllegalArgumentException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public String handleIllegalArgument(IllegalArgumentException e, Model model) {
        logger.warning("Illegal argument: " + e.getMessage());
        model.addAttribute("errorMessage", "Dữ liệu không hợp lệ: " + e.getMessage());
        model.addAttribute("errorCode", "400");
        return "common/error";
    }
}

