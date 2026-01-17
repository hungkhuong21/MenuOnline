-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Oct 27, 2025 at 08:05 AM
-- Server version: 9.1.0
-- PHP Version: 8.3.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `menu_online`
--

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
CREATE TABLE IF NOT EXISTS `category` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `restaurant_id` bigint NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `restaurant_id_idx` (`restaurant_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`id`, `name`, `restaurant_id`, `created_at`) VALUES
(1, 'Đồ uống', 1, '2025-10-27 14:59:50'),
(2, 'Món ăn', 1, '2025-10-27 14:59:50'),
(3, 'Tráng miệng', 1, '2025-10-27 14:59:50'),
(4, 'Đồ uống', 2, '2025-10-27 14:59:50'),
(5, 'Món ăn', 2, '2025-10-27 14:59:50');

-- --------------------------------------------------------

--
-- Table structure for table `menu_view_log`
--

DROP TABLE IF EXISTS `menu_view_log`;
CREATE TABLE IF NOT EXISTS `menu_view_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `restaurant_id` bigint NOT NULL,
  `view_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `ip_address` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `restaurant_id_idx` (`restaurant_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `menu_view_log`
--

INSERT INTO `menu_view_log` (`id`, `restaurant_id`, `view_time`, `ip_address`) VALUES
(1, 1, '2025-10-27 14:59:50', '192.168.0.1'),
(2, 1, '2025-10-27 14:59:50', '192.168.0.2'),
(3, 2, '2025-10-27 14:59:50', '192.168.0.3');

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
CREATE TABLE IF NOT EXISTS `product` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `description` text,
  `price` decimal(10,2) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `category_id` bigint NOT NULL,
  `restaurant_id` bigint NOT NULL,
  `available` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_product_category` (`category_id`),
  KEY `fk_product_restaurant` (`restaurant_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`id`, `name`, `description`, `price`, `image`, `category_id`, `restaurant_id`, `available`, `created_at`) VALUES
(1, 'Cà phê sữa đá', 'Cà phê truyền thống Việt Nam', 25000.00, 'coffee.jpg', 1, 1, 1, '2025-10-27 14:59:50'),
(2, 'Trà sữa trân châu', 'Trà sữa Đài Loan', 30000.00, 'milktea.jpg', 1, 1, 1, '2025-10-27 14:59:50'),
(3, 'Bánh ngọt', 'Bánh ngọt thơm ngon', 15000.00, 'cake.jpg', 3, 1, 1, '2025-10-27 14:59:50');

-- --------------------------------------------------------

--
-- Table structure for table `restaurant`
--

DROP TABLE IF EXISTS `restaurant`;
CREATE TABLE IF NOT EXISTS `restaurant` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `description` text,
  `logo` varchar(255) DEFAULT NULL,
  `qr_token` varchar(100) NOT NULL DEFAULT (uuid()),
  `owner_id` bigint NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `qr_token_unique` (`qr_token`),
  KEY `owner_id_idx` (`owner_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `restaurant`
--

INSERT INTO `restaurant` (`id`, `name`, `address`, `description`, `logo`, `qr_token`, `owner_id`, `is_active`, `created_at`) VALUES
(1, 'Cà phê 123', '45 Lê Lợi, Quy Nhơn', 'Quán yên tĩnh, đồ uống ngon', NULL, 'e99b6e35-b30a-11f0-afa0-2047473d9898', 7, 1, '2025-10-27 14:59:49'),
(2, 'Test Cafe', '123 Lê Lợi', 'Quán test', NULL, 'e99b7534-b30a-11f0-afa0-2047473d9898', 2, 1, '2025-10-27 14:59:49');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `role` enum('ADMIN','MERCHANT') NOT NULL DEFAULT 'MERCHANT',
  `status` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `username`, `password`, `full_name`, `email`, `phone`, `role`, `status`, `created_at`) VALUES
(1, 'admin', 'admin123', 'System Admin', 'admin@gmail.com', '0123456789', 'ADMIN', 1, '2025-10-27 14:59:49'),
(2, 'merchant1', '123456', 'Tran Thi C', 'merchant1@gmail.com', '0123456789', 'MERCHANT', 1, '2025-10-27 14:59:49'),
(7, 'khuong', '123', 'Nguyen Khuong', 'khuong@gmail.com', '012373232', 'MERCHANT', 1, '2025-10-27 14:59:49');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `category`
--
ALTER TABLE `category`
  ADD CONSTRAINT `fk_restaurant` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurant` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `menu_view_log`
--
ALTER TABLE `menu_view_log`
  ADD CONSTRAINT `fk_viewlog_restaurant` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurant` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `fk_product_category` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_product_restaurant` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurant` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `restaurant`
--
ALTER TABLE `restaurant`
  ADD CONSTRAINT `fk_owner` FOREIGN KEY (`owner_id`) REFERENCES `user` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
