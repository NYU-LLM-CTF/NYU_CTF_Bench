-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Sep 08, 2023 at 11:11 PM
-- Server version: 5.7.40
-- PHP Version: 8.0.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `email_sqli_ctf`
--

-- --------------------------------------------------------

--
-- Table structure for table `trackingid`
--

DROP TABLE IF EXISTS `trackingid`;
CREATE TABLE IF NOT EXISTS `trackingid` (
  `cookie` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  PRIMARY KEY (`cookie`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `privilege` varchar(20) NOT NULL,
  PRIMARY KEY (`email`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`email`, `password`, `name`, `phone`, `privilege`) VALUES
('john.doe@mta.com', 'R$1m#7DnT2PqYvXs', 'John Doe', '555-123-1001', 'user'),
('jane.smith@mta.com', 'W*9zPvGk@6cXbQnT', 'Jane Smith', '555-123-1002', 'user'),
('michael.johnson@mta.com', 'L#5oVrXuP3yZbAeQ', 'Michael Johnson', '555-123-1003', 'user'),
('emily.brown@mta.com', 'p#2r@5ml8q7v!9x$1', 'Emily Brown', '555-123-1004', 'admin'),
('david.wilson@mta.com', 'Z^2wYbEn@8qDfRsT', 'David Wilson', '555-123-1005', 'user'),
('susan.jones@mta.com', 'S#4uJnQ2o5zXbRw', 'Susan Jones', '555-123-1006', 'user'),
('kevin.johnson@mta.com', 'K*8vTnZ4rJ2cBpQ', 'Kevin Johnson', '555-123-1007', 'user'),
('linda.smith@mta.com', 'L^9dSbM7iG1fPwQ', 'Linda Smith', '555-123-1008', 'user'),
('robert.anderson@mta.com', 'R@3bA5dP1oG7zTm', 'Robert Anderson', '555-123-1009', 'user'),
('mary.williams@mta.com', 'M*6rWlP9zS1xTc', 'Mary Williams', '555-123-1010', 'user'),
('william.thomas@mta.com', 'W#8lTmS2zQ4rPc', 'William Thomas', '555-123-1011', 'user'),
('laura.miller@mta.com', 'L$2rMlT8zW4iPc', 'Laura Miller', '555-123-1012', 'user'),
('james.martin@mta.com', 'J%5mRtN9cW3vPb', 'James Martin', '555-123-1013', 'user'),
('karen.jackson@mta.com', 'K^7nJcS1vZ5bMl', 'Karen Jackson', '555-123-1014', 'user'),
('richard.moore@mta.com', 'R*1hMwZ4oL7pTc', 'Richard Moore', '555-123-1015', 'user'),
('jennifer.white@mta.com', 'J#4nWpS7lT1mZr', 'Jennifer White', '555-123-1016', 'user'),
('charles.lewis@mta.com', 'C@6hLsW9pT3mZr', 'Charles Lewis', '555-123-1017', 'user'),
('sarah.harris@mta.com', 'S*9rHcW2mZ4pLs', 'Sarah Harris', '555-123-1018', 'user'),
('daniel.young@mta.com', 'D$2nYpW5mZ8cLs', 'Daniel Young', '555-123-1019', 'user'),
('jessica.brown@mta.com', 'J^5sBcW8nZ2mLp', 'Jessica Brown', '555-123-1020', 'user');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
