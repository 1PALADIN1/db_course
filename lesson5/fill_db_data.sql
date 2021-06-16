USE product_db;

-- MariaDB dump 10.17  Distrib 10.4.15-MariaDB, for Linux (x86_64)
--
-- Host: mysql.hostinger.ro    Database: u574849695_22
-- ------------------------------------------------------
-- Server version	10.4.15-MariaDB-cll-lve

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `catalogs`
--

DROP TABLE IF EXISTS `catalogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `catalogs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Название раздела',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_name` (`name`(10))
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Разделы интернет-магазина';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalogs`
--

LOCK TABLES `catalogs` WRITE;
/*!40000 ALTER TABLE `catalogs` DISABLE KEYS */;
INSERT INTO `catalogs` VALUES (1,'Процессоры'),(2,'Материнские платы'),(3,'Видеокарты'),(4,'Жесткие диски'),(5,'Оперативная память');
/*!40000 ALTER TABLE `catalogs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `discounts`
--

DROP TABLE IF EXISTS `discounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `discounts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned DEFAULT NULL,
  `product_id` int(10) unsigned DEFAULT NULL,
  `discount` float unsigned DEFAULT NULL COMMENT 'Величина скидки от 0.0 до 1.0',
  `started_at` datetime DEFAULT NULL,
  `finished_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `index_of_user_id` (`user_id`),
  KEY `index_of_product_id` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Скидки';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `discounts`
--

LOCK TABLES `discounts` WRITE;
/*!40000 ALTER TABLE `discounts` DISABLE KEYS */;
INSERT INTO `discounts` VALUES (1,2,3,2496,'1978-05-04 21:07:22','1991-12-28 10:21:44','1985-10-23 10:06:24','1999-05-23 00:48:41'),(2,3,5,642,'2000-04-13 15:55:22','1994-10-24 17:31:51','2001-04-13 04:50:46','1978-02-14 12:43:34'),(3,2,2,30866,'1976-12-12 15:13:13','1974-04-21 08:00:32','1980-10-05 19:18:20','1976-06-20 07:00:41'),(4,1,4,584,'1988-05-08 19:46:06','2014-03-29 12:11:36','2016-11-10 08:29:51','1990-02-05 03:55:50'),(5,1,1,6625110,'1970-08-24 17:30:20','1997-11-15 16:03:43','1997-08-21 02:18:21','1973-11-16 20:37:21');
/*!40000 ALTER TABLE `discounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `index_of_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Заказы';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,5,'1991-04-25 05:37:10','1993-09-27 10:13:43'),(2,2,'2004-06-07 07:09:49','2020-12-14 22:10:45'),(3,5,'2008-02-28 11:48:35','1987-01-22 18:41:14'),(4,3,'1994-05-21 16:40:06','2011-12-23 07:08:39'),(5,6,'2020-08-18 14:02:37','1981-09-16 07:50:04'),(6,5,'2018-11-29 17:38:45','2010-07-08 10:18:39'),(7,3,'1999-06-13 17:35:33','1980-02-08 12:28:02'),(8,4,'1980-11-03 20:17:39','2007-07-27 12:05:17'),(9,5,'2004-11-08 05:41:17','1992-04-28 05:01:46'),(10,2,'1988-01-01 14:40:49','2011-10-04 19:05:19'),(11,3,'1973-04-20 07:36:00','1995-12-11 04:57:11'),(12,3,'1999-09-21 23:19:33','2012-08-13 22:46:48'),(13,2,'2003-06-19 10:15:44','1997-11-16 22:08:43'),(14,2,'2015-08-17 07:46:19','2004-04-27 19:52:16'),(15,6,'1998-02-16 22:18:25','1994-01-16 19:02:08'),(16,3,'1988-03-21 23:14:29','1971-04-14 00:39:59'),(17,4,'1988-09-21 00:53:58','1977-01-01 16:52:56'),(18,6,'2014-09-20 01:32:45','1996-11-24 16:07:31'),(19,6,'1986-04-13 12:12:42','1987-07-13 13:20:32'),(20,6,'2008-04-16 03:28:21','1995-03-01 06:32:34');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders_products`
--

DROP TABLE IF EXISTS `orders_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders_products` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int(10) unsigned DEFAULT NULL,
  `product_id` int(10) unsigned DEFAULT NULL,
  `total` int(10) unsigned DEFAULT 1 COMMENT 'Количество заказанных товарных позиций',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Состав заказа';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders_products`
--

LOCK TABLES `orders_products` WRITE;
/*!40000 ALTER TABLE `orders_products` DISABLE KEYS */;
INSERT INTO `orders_products` VALUES (1,9,1,5,'1998-04-06 07:30:33','1970-10-19 22:11:08'),(2,12,4,7,'1989-11-15 13:29:44','2018-01-09 12:55:33'),(3,19,4,6,'1980-04-11 23:47:46','2002-09-17 08:16:07'),(4,18,7,8,'1978-05-30 05:10:47','1978-05-03 09:52:16'),(5,10,5,8,'1981-11-25 05:10:40','1977-05-24 08:53:49'),(6,11,4,8,'1970-03-08 10:34:57','1992-03-22 13:36:57'),(7,16,6,6,'1996-11-09 06:50:39','2004-01-18 21:29:52'),(8,15,7,1,'2001-02-11 07:27:05','2016-02-03 11:15:37'),(9,18,5,6,'2013-03-01 05:37:17','2018-03-07 00:31:35'),(10,5,1,2,'1990-04-19 01:08:06','1979-08-24 04:20:08'),(11,20,7,9,'2018-03-13 06:45:28','1995-01-02 17:21:56'),(12,6,1,8,'2002-02-11 16:32:03','2017-08-16 22:49:27'),(13,12,2,7,'2013-03-18 01:15:29','1989-10-31 12:23:24'),(14,14,2,7,'2020-07-30 06:54:27','2004-08-08 22:16:16'),(15,14,6,2,'1990-07-24 06:28:54','2004-04-16 19:27:29'),(16,3,1,5,'1987-07-24 10:19:52','1983-09-03 03:17:59'),(17,17,6,3,'1990-11-12 15:40:01','1972-06-11 10:39:13'),(18,13,6,4,'2021-06-08 13:26:50','1983-01-10 09:06:48'),(19,4,4,5,'1980-05-07 18:20:25','2019-08-08 11:10:53'),(20,15,5,1,'1972-06-11 01:43:04','2012-07-28 13:23:35');
/*!40000 ALTER TABLE `orders_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Название',
  `description` text COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Описание',
  `price` decimal(11,2) DEFAULT NULL COMMENT 'Цена',
  `catalog_id` int(10) unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `index_of_catalog_id` (`catalog_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Товарные позиции';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'Intel Core i3-8100','Процессор для настольных персональных компьютеров, основанных на платформе Intel.',7890.00,1,'2021-06-14 11:36:39','2021-06-14 11:36:39'),(2,'Intel Core i5-7400','Процессор для настольных персональных компьютеров, основанных на платформе Intel.',12700.00,1,'2021-06-14 11:36:39','2021-06-14 11:36:39'),(3,'AMD FX-8320E','Процессор для настольных персональных компьютеров, основанных на платформе AMD.',4780.00,1,'2021-06-14 11:36:39','2021-06-14 11:36:39'),(4,'AMD FX-8320','Процессор для настольных персональных компьютеров, основанных на платформе AMD.',7120.00,1,'2021-06-14 11:36:39','2021-06-14 11:36:39'),(5,'ASUS ROG MAXIMUS X HERO','Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX',19310.00,2,'2021-06-14 11:36:39','2021-06-14 11:36:39'),(6,'Gigabyte H310M S2H','Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX',4790.00,2,'2021-06-14 11:36:39','2021-06-14 11:36:39'),(7,'MSI B250M GAMING PRO','Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX',5060.00,2,'2021-06-14 11:36:39','2021-06-14 11:36:39');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `storehouses`
--

DROP TABLE IF EXISTS `storehouses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `storehouses` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Название',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Склады';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `storehouses`
--

LOCK TABLES `storehouses` WRITE;
/*!40000 ALTER TABLE `storehouses` DISABLE KEYS */;
INSERT INTO `storehouses` VALUES (1,'iste','2013-08-22 02:45:57','2005-07-23 00:56:14'),(2,'voluptatem','2003-02-01 17:34:14','2016-07-26 07:30:18'),(3,'iste','1970-01-07 01:59:21','1974-02-08 11:37:23'),(4,'et','1989-12-10 21:39:50','2014-08-08 16:32:05'),(5,'ut','1987-02-17 16:47:48','2011-05-28 04:03:11'),(6,'voluptatem','2014-02-09 16:27:00','1981-03-29 07:23:26'),(7,'cupiditate','1998-11-21 13:19:08','1972-05-14 09:38:44'),(8,'voluptatem','1997-05-14 12:56:52','1994-05-14 03:33:14'),(9,'qui','1989-03-22 22:01:22','2018-03-03 13:04:13'),(10,'ea','2016-09-26 11:11:05','1977-08-14 19:37:00');
/*!40000 ALTER TABLE `storehouses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `storehouses_products`
--

DROP TABLE IF EXISTS `storehouses_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `storehouses_products` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `storehouse_id` int(10) unsigned DEFAULT NULL,
  `product_id` int(10) unsigned DEFAULT NULL,
  `value` int(10) unsigned DEFAULT NULL COMMENT 'Запас товарной позиции на складе',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Запасы на складе';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `storehouses_products`
--

LOCK TABLES `storehouses_products` WRITE;
/*!40000 ALTER TABLE `storehouses_products` DISABLE KEYS */;
INSERT INTO `storehouses_products` VALUES (1,1,6,5,'1992-07-26 18:32:58','1997-09-23 11:01:50'),(2,1,4,7,'1978-04-25 21:38:17','1987-10-02 10:42:50'),(3,6,7,0,'2020-06-11 00:56:43','1991-04-27 02:35:52'),(4,4,6,8,'2005-10-01 00:07:12','1974-01-13 15:32:46'),(5,5,2,9,'1972-12-16 04:14:25','1998-07-12 10:01:50'),(6,10,5,2,'1978-08-19 19:17:26','2008-08-21 14:00:03'),(7,9,5,1,'1986-04-09 23:33:16','2000-08-11 15:25:47'),(8,6,4,5,'1985-03-07 23:43:10','1989-02-04 08:50:49'),(9,1,5,4,'1987-03-17 15:18:32','2009-02-07 21:52:08'),(10,6,1,0,'1986-08-26 12:02:20','1989-06-25 08:19:11');
/*!40000 ALTER TABLE `storehouses_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Имя покупателя',
  `birthday_at` date DEFAULT NULL COMMENT 'Дата рождения',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Покупатели';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Геннадий','1990-10-05','2021-06-14 11:36:39','2021-06-14 11:36:39'),(2,'Наталья','1984-11-12','2021-06-14 11:36:39','2021-06-14 11:36:39'),(3,'Александр','1985-05-20','2021-06-14 11:36:39','2021-06-14 11:36:39'),(4,'Сергей','1988-02-14','2021-06-14 11:36:39','2021-06-14 11:36:39'),(5,'Иван','1998-01-12','2021-06-14 11:36:39','2021-06-14 11:36:39'),(6,'Мария','1992-08-29','2021-06-14 11:36:39','2021-06-14 11:36:39');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-06-14 11:38:42
