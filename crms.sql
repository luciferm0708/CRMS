-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 25, 2025 at 08:24 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `crms`
--

-- --------------------------------------------------------

--
-- Table structure for table `assignments`
--

CREATE TABLE `assignments` (
  `id` int(11) NOT NULL,
  `report_id` int(11) NOT NULL,
  `professional_id` int(11) NOT NULL,
  `is_current` tinyint(1) DEFAULT 1,
  `assigned_at` datetime DEFAULT current_timestamp(),
  `progress` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `assignments`
--

INSERT INTO `assignments` (`id`, `report_id`, `professional_id`, `is_current`, `assigned_at`, `progress`) VALUES
(4, 15, 4, 1, '2025-03-25 12:15:15', 0);

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `id` int(11) NOT NULL,
  `report_id` int(11) NOT NULL,
  `people_id` int(11) NOT NULL,
  `comment_text` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `comments`
--

INSERT INTO `comments` (`id`, `report_id`, `people_id`, `comment_text`, `created_at`) VALUES
(18, 15, 10, 'debug', '2025-03-25 09:55:55'),
(19, 15, 8, 'debug', '2025-03-25 09:58:36'),
(20, 15, 9, 'debug 1', '2025-03-25 09:59:16'),
(21, 15, 10, 'debug 2', '2025-03-25 10:00:11'),
(22, 15, 8, 'debug 0', '2025-03-25 10:18:54'),
(23, 15, 10, 'debug', '2025-03-25 10:21:51'),
(24, 15, 10, 'debug', '2025-03-25 10:21:55'),
(25, 15, 10, 'debug', '2025-03-25 10:22:27'),
(26, 15, 8, 'debug from test000', '2025-03-25 10:23:01'),
(27, 15, 9, 'debug from test001', '2025-03-25 10:23:24'),
(28, 15, 11, 'debug 01', '2025-03-25 13:10:29'),
(29, 17, 8, 'debug 1', '2025-03-25 18:48:20'),
(30, 17, 9, 'debug 2', '2025-03-25 18:49:43'),
(31, 17, 12, 'debug 5', '2025-03-25 19:10:59');

-- --------------------------------------------------------

--
-- Table structure for table `crime_reports`
--

CREATE TABLE `crime_reports` (
  `id` int(11) NOT NULL,
  `people_id` int(11) NOT NULL,
  `forum` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `reported_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `image_urls` text DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `crime_reports`
--

INSERT INTO `crime_reports` (`id`, `people_id`, `forum`, `description`, `reported_at`, `image_urls`, `username`) VALUES
(15, 8, 'Mirpur', 'Debug 0', '2025-03-25 05:31:28', '[\"http:\\/\\/localhost\\/api_crms\\/crimeReports\\/uploads\\/67e23fb07afc8_uploaded_image_0.jpg\"]', 'test000'),
(16, 11, 'Savar', 'Debug 1', '2025-03-25 11:37:48', '[\"http:\\/\\/localhost\\/api_crms\\/crimeReports\\/uploads\\/67e2958c77993_uploaded_image_0.jpg\"]', 'test003'),
(17, 8, 'Mirpur', 'Debug 2', '2025-03-25 17:18:23', '[\"http:\\/\\/localhost\\/api_crms\\/crimeReports\\/uploads\\/67e2e55f4402e_uploaded_image_0.jpg\"]', 'test000');

-- --------------------------------------------------------

--
-- Table structure for table `people`
--

CREATE TABLE `people` (
  `people_id` int(11) NOT NULL,
  `first_name` varchar(121) DEFAULT NULL,
  `last_name` varchar(121) DEFAULT NULL,
  `username` varchar(121) DEFAULT NULL,
  `email` varchar(121) DEFAULT NULL,
  `gender` varchar(121) DEFAULT NULL,
  `nid` int(11) DEFAULT NULL,
  `dob` varchar(121) DEFAULT NULL,
  `pass` text DEFAULT NULL,
  `confirm_pass` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `people`
--

INSERT INTO `people` (`people_id`, `first_name`, `last_name`, `username`, `email`, `gender`, `nid`, `dob`, `pass`, `confirm_pass`) VALUES
(8, 'test', '000', 'test000', 'test000@gmail.com', 'Male', 789456, '2025-03-25', 'e10adc3949ba59abbe56e057f20f883e', 'e10adc3949ba59abbe56e057f20f883e'),
(9, 'test', '001', 'test001', 'test001@gmail.com', 'Male', 12346, '2025-03-25', 'e10adc3949ba59abbe56e057f20f883e', 'e10adc3949ba59abbe56e057f20f883e'),
(10, 'test', '002', 'test002', 'test002@gmail.com', 'Male', 123456, '2025-03-25', 'e10adc3949ba59abbe56e057f20f883e', 'e10adc3949ba59abbe56e057f20f883e'),
(11, 'test', '003', 'test003', 'test003@gmail.com', 'Female', 123456, '2025-03-25', 'e10adc3949ba59abbe56e057f20f883e', 'e10adc3949ba59abbe56e057f20f883e'),
(12, 'test', '004', 'test004', 'test004@gmail.com', 'Male', 123456, '2025-03-26', 'e10adc3949ba59abbe56e057f20f883e', 'e10adc3949ba59abbe56e057f20f883e');

-- --------------------------------------------------------

--
-- Table structure for table `peoproimage`
--

CREATE TABLE `peoproimage` (
  `id` int(11) NOT NULL,
  `img` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `professionalregistration`
--

CREATE TABLE `professionalregistration` (
  `professional_id` int(11) NOT NULL,
  `profession_type` varchar(255) DEFAULT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `organization_name` varchar(255) DEFAULT NULL,
  `license_number` varchar(100) DEFAULT NULL,
  `nid_number` varchar(20) NOT NULL,
  `expertise_area` text DEFAULT NULL,
  `pass` text DEFAULT NULL,
  `confirm_pass` text DEFAULT NULL,
  `verification_status` enum('Pending','Verified','Rejected') DEFAULT 'Pending',
  `registered_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `professionalregistration`
--

INSERT INTO `professionalregistration` (`professional_id`, `profession_type`, `first_name`, `last_name`, `username`, `email`, `organization_name`, `license_number`, `nid_number`, `expertise_area`, `pass`, `confirm_pass`, `verification_status`, `registered_at`) VALUES
(4, 'Police', 'test', '000', 'test000', 'test000@gmail.com', 'Police', '852963', '789456', 'Policing', 'e10adc3949ba59abbe56e057f20f883e', 'e10adc3949ba59abbe56e057f20f883e', 'Pending', '2025-03-25 05:39:59');

-- --------------------------------------------------------

--
-- Table structure for table `prof_comments`
--

CREATE TABLE `prof_comments` (
  `id` int(11) NOT NULL,
  `report_id` int(11) NOT NULL,
  `professional_id` int(11) NOT NULL,
  `comment_text` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `prof_reactions`
--

CREATE TABLE `prof_reactions` (
  `id` int(11) NOT NULL,
  `report_id` int(11) NOT NULL,
  `professional_id` int(11) NOT NULL,
  `reaction_type` enum('upvote','downvote','remove') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `prof_reactions`
--

INSERT INTO `prof_reactions` (`id`, `report_id`, `professional_id`, `reaction_type`, `created_at`) VALUES
(0, 17, 4, 'downvote', '2025-03-25 18:25:25'),
(0, 15, 4, 'upvote', '2025-03-25 18:25:21'),
(0, 16, 4, 'downvote', '2025-03-25 18:25:23');

-- --------------------------------------------------------

--
-- Table structure for table `reactions`
--

CREATE TABLE `reactions` (
  `id` int(11) NOT NULL,
  `report_id` int(11) NOT NULL,
  `people_id` int(11) NOT NULL,
  `reaction_type` varchar(20) NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reactions`
--

INSERT INTO `reactions` (`id`, `report_id`, `people_id`, `reaction_type`, `created_at`) VALUES
(3, 15, 8, 'upvote', '2025-03-26 00:44:30'),
(4, 17, 8, 'upvote', '2025-03-26 00:44:36'),
(5, 15, 9, 'upvote', '2025-03-26 00:49:25'),
(6, 17, 9, 'downvote', '2025-03-26 00:49:35'),
(7, 15, 12, 'upvote', '2025-03-26 01:10:44'),
(8, 16, 12, 'downvote', '2025-03-26 01:10:46'),
(9, 17, 12, 'upvote', '2025-03-26 01:10:48');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `assignments`
--
ALTER TABLE `assignments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `report_id` (`report_id`),
  ADD UNIQUE KEY `professional_id` (`professional_id`);

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `report_id` (`report_id`);

--
-- Indexes for table `crime_reports`
--
ALTER TABLE `crime_reports`
  ADD PRIMARY KEY (`id`),
  ADD KEY `crime_reports_ibfk_1` (`people_id`);

--
-- Indexes for table `people`
--
ALTER TABLE `people`
  ADD PRIMARY KEY (`people_id`);

--
-- Indexes for table `professionalregistration`
--
ALTER TABLE `professionalregistration`
  ADD PRIMARY KEY (`professional_id`);

--
-- Indexes for table `reactions`
--
ALTER TABLE `reactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_reaction` (`report_id`,`people_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `assignments`
--
ALTER TABLE `assignments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `crime_reports`
--
ALTER TABLE `crime_reports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `people`
--
ALTER TABLE `people`
  MODIFY `people_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `professionalregistration`
--
ALTER TABLE `professionalregistration`
  MODIFY `professional_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `reactions`
--
ALTER TABLE `reactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`report_id`) REFERENCES `crime_reports` (`id`);

--
-- Constraints for table `crime_reports`
--
ALTER TABLE `crime_reports`
  ADD CONSTRAINT `crime_reports_ibfk_1` FOREIGN KEY (`people_id`) REFERENCES `people` (`people_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
