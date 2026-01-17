-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jan 16, 2026 at 09:40 AM
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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`id`, `name`, `restaurant_id`, `created_at`) VALUES
(1, 'Đồ uống', 1, '2025-10-27 14:59:50'),
(2, 'Món ăn', 1, '2025-10-27 14:59:50'),
(3, 'Tráng miệng', 1, '2025-10-27 14:59:50'),
(8, 'Bánh cookie', 8, '2025-12-03 08:28:05'),
(11, 'Sushi & Sashimi', 9, '2025-12-05 07:09:37'),
(12, 'Bento (Cơm hộp kiểu Nhật)', 9, '2025-12-05 07:09:46'),
(13, 'Mì Nhật', 9, '2025-12-05 07:09:52'),
(14, 'Tempura', 9, '2025-12-05 07:10:03'),
(15, 'Lẩu Nhật (Nabe)', 9, '2025-12-05 07:10:14'),
(16, 'Tráng miệng', 9, '2025-12-05 07:10:28'),
(17, 'Đồ uống', 9, '2025-12-05 07:10:37');

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
  `user_agent` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `restaurant_id_idx` (`restaurant_id`)
) ENGINE=InnoDB AUTO_INCREMENT=92 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `menu_view_log`
--

INSERT INTO `menu_view_log` (`id`, `restaurant_id`, `view_time`, `ip_address`, `user_agent`) VALUES
(2, 1, '2025-10-27 14:59:50', '192.168.0.2', NULL),
(4, 1, '2025-10-27 08:39:35', '192.168.1.10', NULL),
(5, 1, '2025-12-01 07:13:24', '0:0:0:0:0:0:0:1', NULL),
(6, 1, '2025-12-01 07:21:25', '0:0:0:0:0:0:0:1', NULL),
(7, 1, '2025-12-01 07:23:02', '0:0:0:0:0:0:0:1', NULL),
(8, 1, '2025-12-01 09:19:45', '0:0:0:0:0:0:0:1', NULL),
(9, 1, '2025-12-03 07:03:24', '192.168.104.2', NULL),
(13, 9, '2025-12-04 03:56:54', '192.168.104.2', 'Mozilla/5.0 (Linux; Android 11; RMX1973 Build/RKQ1.201217.002;) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/142.0.7444.171 Safari/537.36 Zalo android/25112868 ZaloTheme/dark ZaloLanguage/vi'),
(14, 9, '2025-12-04 03:57:38', '192.168.104.2', 'Mozilla/5.0 (Linux; Android 11; RMX1973 Build/RKQ1.201217.002;) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/142.0.7444.171 Safari/537.36 Zalo android/25112868 ZaloTheme/dark ZaloLanguage/vi'),
(15, 9, '2025-12-04 15:09:05', '192.168.104.2', 'Mozilla/5.0 (Linux; Android 11; RMX1973 Build/RKQ1.201217.002;) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/142.0.7444.171 Safari/537.36 Zalo android/25112868 ZaloTheme/dark ZaloLanguage/vi'),
(16, 9, '2025-12-05 02:53:16', '192.168.104.2', 'Mozilla/5.0 (Linux; Android 11; RMX1973 Build/RKQ1.201217.002;) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/142.0.7444.171 Safari/537.36 Zalo android/25112868 ZaloTheme/dark ZaloLanguage/vi'),
(17, 9, '2025-12-05 02:58:46', '192.168.104.2', 'Mozilla/5.0 (Linux; Android 11; RMX1973 Build/RKQ1.201217.002;) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/142.0.7444.171 Safari/537.36 Zalo android/25112868 ZaloTheme/dark ZaloLanguage/vi'),
(18, 9, '2025-12-05 03:13:18', '192.168.104.2', 'Mozilla/5.0 (Linux; Android 11; RMX1973 Build/RKQ1.201217.002;) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/142.0.7444.171 Safari/537.36 Zalo android/25112868 ZaloTheme/dark ZaloLanguage/vi'),
(19, 9, '2025-12-05 07:29:05', '192.168.104.2', 'Mozilla/5.0 (Linux; Android 11; RMX1973 Build/RKQ1.201217.002;) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/142.0.7444.171 Safari/537.36 Zalo android/25112868 ZaloTheme/dark ZaloLanguage/vi'),
(22, 9, '2026-01-11 14:18:26', '192.168.1.62', 'Mozilla/5.0 (Linux; Android 11; RMX1973 Build/RKQ1.201217.002;) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/143.0.7499.146 Mobile Safari/537.36 Zalo android/25122880 ZaloTheme/dark ZaloLanguage/vi'),
(23, 9, '2026-01-12 00:25:13', '192.168.1.62', 'Mozilla/5.0 (Linux; Android 11; RMX1973 Build/RKQ1.201217.002;) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/143.0.7499.146 Mobile Safari/537.36 Zalo android/25122880 ZaloTheme/dark ZaloLanguage/vi'),
(24, 9, '2026-01-12 06:14:52', '192.168.1.62', 'Mozilla/5.0 (Linux; Android 11; RMX1973 Build/RKQ1.201217.002;) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/143.0.7499.146 Mobile Safari/537.36 Zalo android/25122880 ZaloTheme/dark ZaloLanguage/vi'),
(25, 9, '2026-01-12 06:15:40', '192.168.1.62', 'Mozilla/5.0 (Linux; Android 11; RMX1973 Build/RKQ1.201217.002;) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/143.0.7499.146 Mobile Safari/537.36 Zalo android/25122880 ZaloTheme/dark ZaloLanguage/vi'),
(26, 9, '2026-01-12 06:19:46', '192.168.1.62', 'Mozilla/5.0 (Linux; Android 11; RMX1973 Build/RKQ1.201217.002;) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/143.0.7499.146 Mobile Safari/537.36 Zalo android/25122880 ZaloTheme/dark ZaloLanguage/vi'),
(27, 9, '2026-01-12 06:20:22', '192.168.1.62', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36'),
(28, 9, '2026-01-12 06:25:47', '192.168.1.62', 'Mozilla/5.0 (Linux; Android 11; RMX1973 Build/RKQ1.201217.002;) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/143.0.7499.146 Mobile Safari/537.36 Zalo android/25122880 ZaloTheme/dark ZaloLanguage/vi'),
(29, 9, '2026-01-12 06:30:14', '192.168.1.62', 'Mozilla/5.0 (Linux; Android 11; RMX1973 Build/RKQ1.201217.002;) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/143.0.7499.146 Mobile Safari/537.36 Zalo android/25122880 ZaloTheme/dark ZaloLanguage/vi'),
(30, 9, '2026-01-12 06:34:31', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(31, 9, '2026-01-12 06:37:17', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(32, 9, '2026-01-12 06:40:04', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(33, 9, '2026-01-12 06:43:49', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(34, 9, '2026-01-12 06:44:49', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(35, 9, '2026-01-12 06:44:54', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(36, 9, '2026-01-12 06:44:59', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(37, 9, '2026-01-12 06:45:03', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(38, 9, '2026-01-12 06:45:08', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(39, 9, '2026-01-12 06:45:09', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(40, 9, '2026-01-12 06:45:32', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(41, 9, '2026-01-12 06:45:39', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(42, 9, '2026-01-12 06:45:44', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(43, 9, '2026-01-12 06:45:51', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(44, 9, '2026-01-12 06:45:54', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(45, 9, '2026-01-12 06:45:54', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(46, 9, '2026-01-12 06:45:58', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(47, 9, '2026-01-12 06:46:33', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(48, 9, '2026-01-12 06:50:41', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(49, 9, '2026-01-12 06:54:36', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(50, 9, '2026-01-12 06:55:00', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(51, 9, '2026-01-12 11:49:44', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(52, 9, '2026-01-12 11:50:10', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(53, 9, '2026-01-12 11:50:25', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(54, 9, '2026-01-12 11:50:30', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(55, 9, '2026-01-12 11:50:32', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(56, 9, '2026-01-12 11:50:33', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(57, 9, '2026-01-12 11:50:34', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(58, 9, '2026-01-12 11:50:43', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(59, 9, '2026-01-12 11:51:21', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(60, 9, '2026-01-12 11:51:24', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(61, 9, '2026-01-12 11:51:25', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(62, 9, '2026-01-12 11:51:26', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(63, 9, '2026-01-12 11:52:26', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(64, 9, '2026-01-12 11:53:55', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(65, 9, '2026-01-12 11:57:39', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(66, 9, '2026-01-12 12:01:18', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(67, 9, '2026-01-12 12:05:13', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(68, 9, '2026-01-12 12:08:31', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(69, 9, '2026-01-12 12:11:46', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(70, 9, '2026-01-12 12:16:28', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(71, 9, '2026-01-12 12:19:44', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(72, 9, '2026-01-12 12:22:09', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(73, 9, '2026-01-12 12:27:12', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(74, 9, '2026-01-13 01:58:05', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(75, 9, '2026-01-13 02:03:36', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(76, 9, '2026-01-13 06:36:45', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(77, 9, '2026-01-13 07:33:31', '0:0:0:0:0:0:0:1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36'),
(78, 9, '2026-01-16 08:28:23', '192.168.104.2', 'Mozilla/5.0 (Linux; Android 11; RMX1973 Build/RKQ1.201217.002;) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/143.0.7499.192 Mobile Safari/537.36 Zalo android/25122880 ZaloTheme/dark ZaloLanguage/vi'),
(79, 9, '2026-01-16 08:30:07', '192.168.104.26', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),
(80, 9, '2026-01-16 08:34:59', '192.168.104.26', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),
(81, 9, '2026-01-16 08:36:53', '192.168.104.26', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),
(82, 9, '2026-01-16 08:41:57', '192.168.104.26', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),
(83, 9, '2026-01-16 08:42:02', '192.168.104.26', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),
(84, 9, '2026-01-16 08:52:49', '192.168.104.26', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),
(85, 9, '2026-01-16 09:02:03', '192.168.104.2', 'Mozilla/5.0 (Linux; Android 11; RMX1973 Build/RKQ1.201217.002;) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/143.0.7499.192 Mobile Safari/537.36 Zalo android/25122880 ZaloTheme/dark ZaloLanguage/vi'),
(86, 9, '2026-01-16 09:02:14', '192.168.104.26', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),
(87, 9, '2026-01-16 09:02:26', '192.168.104.2', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Mobile Safari/537.36'),
(88, 9, '2026-01-16 09:07:50', '192.168.104.26', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),
(89, 9, '2026-01-16 09:10:20', '192.168.104.26', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),
(90, 9, '2026-01-16 09:13:23', '192.168.104.26', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36'),
(91, 9, '2026-01-16 09:13:46', '192.168.104.2', 'Mozilla/5.0 (Linux; Android 11; RMX1973 Build/RKQ1.201217.002;) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/143.0.7499.192 Mobile Safari/537.36 Zalo android/25122880 ZaloTheme/dark ZaloLanguage/vi');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
CREATE TABLE IF NOT EXISTS `orders` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `restaurant_id` bigint NOT NULL,
  `customer_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `customer_phone` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `customer_address` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Số bàn (ví dụ: Bàn 5, Bàn 12, Khu VIP...)',
  `note` text COLLATE utf8mb4_unicode_ci,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'PENDING',
  `total_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `order_code` (`order_code`),
  KEY `idx_restaurant` (`restaurant_id`),
  KEY `idx_status` (`status`),
  KEY `idx_order_code` (`order_code`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `order_code`, `restaurant_id`, `customer_name`, `customer_phone`, `customer_address`, `note`, `status`, `total_amount`, `created_at`, `updated_at`) VALUES
(1, 'ORD1764904422997', 9, 'Khuong', '0359536999', 'B5', 'Fgg', 'COMPLETED', 0.00, '2025-12-05 03:13:43', '2025-12-05 06:50:10'),
(2, 'ORD1764919784484', 9, 'Khương', '0123456789', 'Bàn 1', 'Hfhfhf', 'COMPLETED', 70000.00, '2025-12-05 07:29:44', '2025-12-05 07:33:18'),
(3, 'ORD1768220574667', 9, 'Khương', '0234567891', 'Bàn 5, Phòng VIP1', '', 'COMPLETED', 150000.00, '2026-01-12 12:22:55', '2026-01-13 06:36:02'),
(4, 'ORD1768220853997', 9, 'Khương', '0234567891', 'Bàn 5, Phòng VIP1', '', 'COMPLETED', 115000.00, '2026-01-12 12:27:34', '2026-01-13 02:04:47'),
(5, 'ORD1768269846284', 9, 'Khương', '0234567891', 'Bàn 5, Phòng VIP1', '', 'COMPLETED', 70000.00, '2026-01-13 02:04:06', '2026-01-13 02:05:07'),
(6, 'ORD1768286224459', 9, 'Khương', '0234567891', 'Bàn 5, Phòng VIP1', 'ghfhgfh', 'PENDING', 105000.00, '2026-01-13 06:37:04', '2026-01-13 06:37:04'),
(7, 'ORD1768552164509', 9, 'Khương', '5956565646', 'Bàn 1', '', 'PENDING', 70000.00, '2026-01-16 08:29:24', '2026-01-16 08:29:24');

-- --------------------------------------------------------

--
-- Table structure for table `order_item`
--

DROP TABLE IF EXISTS `order_item`;
CREATE TABLE IF NOT EXISTS `order_item` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL,
  `product_id` bigint NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `price` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_order` (`order_id`),
  KEY `idx_product` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `order_item`
--

INSERT INTO `order_item` (`id`, `order_id`, `product_id`, `quantity`, `price`, `subtotal`) VALUES
(2, 2, 1001, 1, 35000.00, 35000.00),
(3, 2, 1002, 1, 35000.00, 35000.00),
(4, 3, 1001, 3, 35000.00, 105000.00),
(5, 3, 1004, 1, 45000.00, 45000.00),
(6, 4, 1001, 2, 35000.00, 70000.00),
(7, 4, 1004, 1, 45000.00, 45000.00),
(8, 5, 1001, 1, 35000.00, 35000.00),
(9, 5, 1002, 1, 35000.00, 35000.00),
(10, 6, 1001, 2, 35000.00, 70000.00),
(11, 6, 1002, 1, 35000.00, 35000.00),
(12, 7, 1001, 2, 35000.00, 70000.00);

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
) ENGINE=InnoDB AUTO_INCREMENT=1606 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`id`, `name`, `description`, `price`, `image`, `category_id`, `restaurant_id`, `available`, `created_at`) VALUES
(2, 'Trà sữa trân châu', 'Trà sữa Đài Loan', 30000.00, '/uploads/d5a9b77c-42e2-4170-b579-1cae88a8d71b.jpg', 1, 1, 1, '2025-12-03 06:49:26'),
(3, 'Bánh ngọt', 'Bánh ngọt thơm ngon', 15000.00, 'cake.jpg', 3, 1, 1, '2025-10-27 14:59:50'),
(4, 'Coca Cola', 'Soft drink', 1.50, 'coca.jpg', 1, 1, 1, '2025-10-27 08:31:01'),
(1001, 'Salmon Nigiri', 'Sushi cá hồi tươi', 35000.00, '/uploads/salmonsushi.webp', 11, 9, 1, '2026-01-13 12:32:54'),
(1002, 'Tuna Nigiri', 'Sushi cá ngừ đỏ', 35000.00, '/uploads/tuna.webp', 11, 9, 1, '2026-01-16 08:00:40'),
(1003, 'Ebi Nigiri', 'Sushi tôm luộc', 30000.00, '/uploads/ebi.webp', 11, 9, 1, '2026-01-16 08:11:39'),
(1004, 'Unagi Nigiri', 'Sushi lươn nướng sốt ngọt', 45000.00, '/uploads/unagi.webp', 11, 9, 1, '2026-01-13 01:44:52'),
(1005, 'Salmon Sashimi', 'Sashimi cá hồi tươi 6 lát', 89000.00, '/uploads/salmonsushi_1768551498204.webp', 11, 9, 1, '2026-01-16 08:18:17'),
(1006, 'Tuna Sashimi', 'Sashimi cá ngừ 6 lát', 95000.00, '/uploads/tuna_sashimi.webp', 11, 9, 1, '2026-01-13 01:45:27'),
(1007, 'Hamachi Sashimi', 'Sashimi cá cam 6 lát', 120000.00, '/uploads/hamachi_sashimi.webp', 11, 9, 1, '2026-01-13 01:46:28'),
(1008, 'Octopus Sashimi', 'Sashimi bạch tuộc 6 lát', 75000.00, '/uploads/octopus_sashimi.webp', 11, 9, 1, '2026-01-13 01:46:47'),
(1009, 'California Roll', 'Cuộn thanh cua, bơ, dưa leo', 65000.00, '/uploads/cali_roll.webp', 11, 9, 1, '2026-01-13 01:47:00'),
(1010, 'Spicy Salmon Roll', 'Cuộn cá hồi cay kiểu Nhật', 69000.00, '/uploads/spicy_salmon_roll.webp', 11, 9, 1, '2026-01-13 01:47:34'),
(1101, 'Bento Cá Hồi', 'Cá hồi nướng sốt teriyaki, cơm, salad', 120000.00, '/uploads/Bánh Dorayaki.webp', 12, 9, 1, '2026-01-13 01:49:17'),
(1102, 'Bento Gà Katsu', 'Gà chiên xù, cơm, salad, sốt katsu', 95000.00, '/uploads/bento_ga.webp', 12, 9, 1, '2026-01-13 01:49:33'),
(1103, 'Bento Bò Teriyaki', 'Thịt bò xào teriyaki, cơm, rau', 130000.00, '/uploads/bento_bo.webp', 12, 9, 1, '2026-01-13 01:49:48'),
(1104, 'Bento Tôm Tempura', 'Tôm chiên tempura, cơm và rau củ', 115000.00, '/uploads/bento_tom_tempura.webp', 12, 9, 1, '2026-01-13 01:51:02'),
(1105, 'Bento Chay', 'Đậu hũ, rau củ, cơm', 90000.00, '/uploads/bento_chay.webp', 12, 9, 1, '2026-01-13 01:51:22'),
(1201, 'Shoyu Ramen', 'Mì ramen nước tương', 85000.00, '/uploads/shoyuramen.webp', 13, 9, 1, '2026-01-13 01:54:12'),
(1202, 'Miso Ramen', 'Mì ramen miso, thịt heo, trứng', 90000.00, '/uploads/miso_ramne.webp', 13, 9, 1, '2026-01-13 02:33:12'),
(1203, 'Tonkotsu Ramen', 'Mì ramen xương hầm kiểu Nhật', 99000.00, '/uploads/tonkotsu_ramen.webp', 13, 9, 1, '2025-12-05 14:15:37'),
(1204, 'Udon Tempura', 'Mì udon kèm tempura', 89000.00, '/uploads/udontempura.webp', 13, 9, 1, '2025-12-05 14:15:37'),
(1205, 'Soba Lạnh', 'Mì soba lạnh chấm tsuyu', 80000.00, '/uploads/sobalanh.webp', 13, 9, 1, '2025-12-05 14:15:37'),
(1301, 'Tôm Tempura', 'Tôm chiên bột giòn', 75000.00, '/uploads/ebi.webp', 14, 9, 1, '2025-12-05 14:15:37'),
(1302, 'Rau Củ Tempura', 'Rau củ chiên bột', 65000.00, '/uploads/raucu.webp', 14, 9, 1, '2025-12-05 14:15:37'),
(1303, 'Tempura Mix', 'Tôm + rau củ', 95000.00, '/uploads/mix.webp', 14, 9, 1, '2025-12-05 14:15:37'),
(1401, 'Lẩu Shabu Shabu', 'Lẩu nhúng thịt bò Nhật', 250000.00, '/uploads/laushaubu.webp', 15, 9, 1, '2025-12-05 14:15:37'),
(1402, 'Luk Sukiyaki', 'Lẩu bò ngọt kiểu Nhật', 260000.00, '/uploads/Luk Sukiyaki.webp', 15, 9, 1, '2025-12-05 14:15:37'),
(1403, 'Lẩu Miso', 'Lẩu nước miso với hải sản', 230000.00, 'miso_hotpot.jpg', 15, 9, 1, '2025-12-05 14:15:37'),
(1501, 'Mochi Kem', 'Bánh mochi nhân kem lạnh', 35000.00, 'mochi.jpg', 16, 9, 1, '2025-12-05 14:15:37'),
(1502, 'Kem Matcha', 'Kem trà xanh Nhật Bản', 30000.00, 'matcha_icecream.jpg', 16, 9, 1, '2025-12-05 14:15:37'),
(1503, 'Bánh Dorayaki', 'Bánh rán Nhật nhân đậu đỏ', 25000.00, 'dorayaki.jpg', 16, 9, 1, '2025-12-05 14:15:37'),
(1601, 'Trà Xanh Nhật', 'Trà nóng hoặc lạnh', 20000.00, 'green_tea.jpg', 17, 9, 1, '2025-12-05 14:15:37'),
(1603, 'Bia Asahi', 'Bia Nhật đóng lon/chai', 45000.00, '/uploads/Bia_Asahi.webp', 17, 9, 1, '2026-01-16 08:17:40'),
(1604, 'Nước Suối', 'Chai 500ml', 10000.00, 'water.jpg', 17, 9, 1, '2025-12-05 14:15:37');

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
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `restaurant`
--

INSERT INTO `restaurant` (`id`, `name`, `address`, `description`, `logo`, `qr_token`, `owner_id`, `is_active`, `created_at`) VALUES
(1, 'Cà phê 123', '45 Lê Lợi, Quy Nhơn', 'Quán yên tĩnh, đồ uống ngon', NULL, 'e99b6e35-b30a-11f0-afa0-2047473d9898', 7, 1, '2025-10-27 14:59:49'),
(5, 'Hải sản', 'Quy Nhơn Bắc, Bình Định', 'bán hải sản giá rẻ', '/uploads/b0966ad3-99cf-4f66-a2e1-7ff40f76143f.jfif', 'a56792d5-c821-44cf-b8b2-893c2589a9c7', 7, 1, '2025-12-01 09:21:38'),
(6, 'Hải sản', 'Quy Nhơn Bắc, Bình Định', 'bán hải sản giá rẻ', '/uploads/d3583109-8819-4c9d-b137-ddb68e78729b.jpg', '62c9da3c-4a7f-42d3-88ab-39d419d7e5e6', 7, 1, '2025-12-01 09:21:49'),
(8, 'Bánh ngọt', 'Quy Nhơn, Bình Định', 'fsada', '/uploads/904151b7-c508-4cdb-be2f-0ee0fd004fbd.webp', 'ce5a1d6d-83eb-4d10-b902-be909a0ee517', 1, 1, '2025-12-03 08:27:31'),
(9, 'The Royal Table', 'Quy Nhơn Nam, Bình Định', '', '/uploads/bbbc4a96-9e1f-4fea-9a13-ef6013d648c6.jpg', '7154c0f5-ebcb-422f-92a8-ff5e078d39f7', 9, 1, '2025-12-04 03:55:20');

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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `username`, `password`, `full_name`, `email`, `phone`, `role`, `status`, `created_at`) VALUES
(1, 'admin', '$2a$10$T15gj4IU4WY/56w7hfje2uMAXI1BLB70hkgYB4bktasFnkqVvWLuG', 'System Admin', 'admin@gmail.com', '0123456789', 'ADMIN', 1, '2025-10-27 14:59:49'),
(7, 'khuong', '$2a$10$V2THm5iM2Ofq7zW0HOhgX.qRT5Ig/.oAq0rpzGC5ygQ4cPgU.3gpu', 'Ngo Khuong', 'khuong@gmail.com', '012373232', 'MERCHANT', 1, '2025-10-27 14:59:49'),
(8, 'nau', '$2a$10$djTN0vo4LodLzKzMUm0RdeY8cshi5eS.rw9ogA1lFZTGeJSjfH7aS', 'Khương', 'khuong@gmail.com', '0123456789', 'MERCHANT', 1, '2025-12-03 06:27:25'),
(9, 'Ngô Hùng Khương', '$2a$10$jdZRsyG99QrAGusBgxHeuO6/TPPXN5vFOO9jxPIoDtetXlATB/VBe', 'Ha Ha', 'hungkhuong32@gmail.com', '0123456789', 'MERCHANT', 1, '2025-12-04 03:53:15'),
(10, 'Ngô Khương', '$2a$10$zXmnCt2CP.R8WGccJxp2e.UnhICNt88YQAD1zatWl3GExGZkl2gOy', 'Ngô Hùng Khương', 'hungkhuong32@gmail.com', '0123456789', 'MERCHANT', 1, '2026-01-13 09:32:40');

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
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`restaurant_id`) REFERENCES `restaurant` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_item`
--
ALTER TABLE `order_item`
  ADD CONSTRAINT `order_item_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_item_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE;

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
