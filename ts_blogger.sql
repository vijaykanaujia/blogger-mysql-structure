-- Adminer 4.6.2 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

SET NAMES utf8mb4;

DROP DATABASE IF EXISTS `ts_blogger`;
CREATE DATABASE `ts_blogger` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `ts_blogger`;

DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `title` varchar(75) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `content` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_category_title` (`title`),
  UNIQUE KEY `unq_category_slug` (`slug`),
  KEY `fk_parent_categories` (`parent_id`),
  CONSTRAINT `fk_parent_categories` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `categories` (`id`, `parent_id`, `title`, `slug`, `content`) VALUES
(1,	NULL,	'technology',	'technology',	'technology content'),
(2,	NULL,	'social',	'social',	'social content');

DROP TABLE IF EXISTS `posts`;
CREATE TABLE `posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `title` varchar(75) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `description` tinytext NOT NULL,
  `status` enum('pending','publish','draft','private') NOT NULL DEFAULT 'pending',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `published_at` datetime DEFAULT NULL,
  `content` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_slug` (`slug`),
  UNIQUE KEY `unq_title` (`title`),
  KEY `fk_users` (`user_id`),
  KEY `fk_posts` (`parent_id`),
  CONSTRAINT `fk_parent_posts` FOREIGN KEY (`parent_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `posts` (`id`, `user_id`, `parent_id`, `title`, `slug`, `description`, `status`, `created_at`, `updated_at`, `published_at`, `content`) VALUES
(13,	1,	NULL,	'first post',	'post',	'test post',	'',	'2022-12-13 12:02:06',	NULL,	NULL,	'no content available'),
(14,	1,	NULL,	'first post 1',	'post3',	'test post',	'',	'2022-12-13 12:02:06',	NULL,	NULL,	'no content available'),
(15,	1,	NULL,	'first post 2',	'post1',	'test post',	'',	'2022-12-13 12:02:06',	NULL,	NULL,	'no content available'),
(16,	1,	13,	'first post 3',	'post2',	'test post',	'',	'2022-12-13 12:02:06',	NULL,	NULL,	'no content available');

DROP TABLE IF EXISTS `post_category`;
CREATE TABLE `post_category` (
  `post_id` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  KEY `fk_post_category_posts` (`post_id`),
  KEY `fk_post_category_tags` (`category_id`),
  CONSTRAINT `fk_post_category_posts` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_post_category_tags` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `post_category` (`post_id`, `category_id`) VALUES
(13,	1),
(13,	2);

DROP TABLE IF EXISTS `post_comments`;
CREATE TABLE `post_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `post_id` int(11) NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `title` varchar(75) NOT NULL,
  `status` enum('pending','publish','draft','private') NOT NULL DEFAULT 'pending',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `published_at` datetime DEFAULT NULL,
  `content` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_comment_title` (`title`),
  KEY `fk_posts` (`post_id`),
  KEY `fk_parent_comments` (`parent_id`),
  CONSTRAINT `fk_parent_comments` FOREIGN KEY (`parent_id`) REFERENCES `post_comments` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_posts` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `post_meta`;
CREATE TABLE `post_meta` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `post_id` int(11) NOT NULL,
  `key` varchar(50) NOT NULL,
  `content` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_post_id_key` (`post_id`,`key`),
  KEY `idx_meta_post` (`post_id`),
  CONSTRAINT `fk_post_meta_posts` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `post_meta` (`id`, `post_id`, `key`, `content`) VALUES
(1,	13,	'key1',	'post 13 content'),
(2,	13,	'key2',	'post 13');

DROP TABLE IF EXISTS `post_tag`;
CREATE TABLE `post_tag` (
  `post_id` int(11) DEFAULT NULL,
  `tag_id` int(11) DEFAULT NULL,
  KEY `fk_post_tag_posts` (`post_id`),
  KEY `fk_post_tag_tags` (`tag_id`),
  CONSTRAINT `fk_post_tag_posts` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_post_tag_tags` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `post_tag` (`post_id`, `tag_id`) VALUES
(13,	1);

DROP TABLE IF EXISTS `tags`;
CREATE TABLE `tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(75) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `content` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_tag_title` (`title`),
  UNIQUE KEY `unq_tag_slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `tags` (`id`, `title`, `slug`, `content`) VALUES
(1,	'tag1',	'tag1',	'tag1 content');

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(30) DEFAULT NULL,
  `mobile` varchar(15) DEFAULT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(72) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_email` (`email`),
  UNIQUE KEY `unq_mobile` (`mobile`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `users` (`id`, `first_name`, `last_name`, `mobile`, `email`, `password`, `created_at`, `updated_at`) VALUES
(1,	'vijay',	'kanaujia',	'9695236954',	'thedev8@gmail.com',	'5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8',	'2022-12-08 12:31:00',	'2022-12-08 12:34:53'),
(2,	'ajay',	'',	'9695236923',	'thedev16@gmail.com',	'5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8',	'2022-12-08 12:31:00',	NULL),
(8,	'ashutosh',	'',	'1234568785',	'thedev1@gmail.com',	'5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8',	'2022-12-08 12:33:50',	NULL),
(9,	'dibyank',	'',	'5685965256',	'thedev6@gmail.com',	'5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8',	'2022-12-08 12:33:50',	NULL),
(10,	'vedant',	'',	'4785125365',	'thedev5@gmail.com',	'5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8',	'2022-12-08 12:33:50',	NULL),
(11,	'syamu',	'',	'4585621359',	'thedev3@gmail.com',	'5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8',	'2022-12-08 12:33:50',	NULL),
(12,	'shashank',	'',	'5456213526',	'thedev2@gmail.com',	'5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8',	'2022-12-08 12:33:50',	NULL);

-- 2022-12-13 06:52:41
