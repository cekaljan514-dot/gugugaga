-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: 172.20.2.8    Database: praxe1
-- ------------------------------------------------------
-- Server version	8.0.30

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES (1,'IT & Development'),(2,'Human Resources'),(3,'Finance & Accounting'),(4,'Sales & Marketing'),(5,'Operations'),(6,'Customer Support'),(7,'Legal');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `position` varchar(100) COLLATE utf8mb3_unicode_ci NOT NULL,
  `company` varchar(100) COLLATE utf8mb3_unicode_ci NOT NULL,
  `department_id` int DEFAULT NULL,
  `parent_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_department` (`department_id`),
  KEY `fk_parent_employee` (`parent_id`),
  CONSTRAINT `fk_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_parent_employee` FOREIGN KEY (`parent_id`) REFERENCES `employees` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees`
--

LOCK TABLES `employees` WRITE;
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
INSERT INTO `employees` VALUES (1,'Jan Novák','CEO','SILON CZ',5,NULL),(2,'Alena Svobodová','CTO','SILON CZ',1,1),(3,'Petr Čech','CFO','SILON CZ',3,1),(4,'Marek Veselý','Head of Sales','SILON CZ',4,1),(5,'Jakub Dvořák','Senior Developer','SILON CZ',1,2),(6,'Lucie Kučerová','DevOps Engineer','SILON CZ',1,2),(7,'Tomáš Marek','QA Engineer','SILON CZ',1,2),(8,'Eva Němcová','Senior Accountant','SILON CZ',3,3),(9,'Jiří Procházka','Junior Accountant','SILON CZ',3,3),(10,'Martin Král','Account Manager','SILON CZ',4,4),(11,'Anna Šimková','Sales Representative','SILON CZ',4,4),(12,'John Smith','Regional Manager','SILON US',5,1),(13,'Karel Horák','System Administrator','SILON CZ',1,2),(14,'Monika Černá','HR Specialist','SILON CZ',2,1),(15,'David Malý','Data Scientist','SILON CZ',1,2),(16,'Veronika Králová','Legal Counsel','SILON CZ',7,1),(17,'Ondřej Sedláček','Sales Director','SILON US',4,4),(18,'Emily Watson','Sales Representative','SILON US',4,5),(19,'Robert Brown','Operations Manager','SILON US',5,5),(20,'Lucas Müller','DevOps Engineer','SILON US',1,5),(21,'Adam Smith','Software Engineer','SILON US',1,8),(22,'Sofia Garcia','UX Designer','SILON US',1,8),(23,'Liam Wilson','Marketing Specialist','SILON US',4,5),(24,'Olivia Taylor','HR Manager','SILON US',2,1),(25,'James Anderson','Accountant','SILON US',NULL,1),(26,'Isabella Martinez','Support Agent','SILON US',6,5),(27,'Benjamin Lee','Security Analyst','SILON CZ',1,2),(28,'Mia Thompson','Recruiter','SILON CZ',2,3),(29,'Matej Kováč','Backend Developer','SILON CZ',1,2),(30,'Sára Novotná','Frontend Developer','SILON CZ',1,2),(31,'Viktor Horvat','Product Owner','SILON CZ',NULL,3),(32,'Elena Rossi','Business Analyst','SILON US',4,4),(33,'Lucas Silva','IT Support','SILON US',1,8),(34,'Chloe Dubois','HR Coordinator','SILON US',2,10),(35,'Oscar Nielsen','Finance Controller','SILON US',3,11),(36,'Emma Lind','Operations Specialist','SILON US',5,12);
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs`
--

DROP TABLE IF EXISTS `logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `event` varchar(50) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `ip` varchar(50) COLLATE utf8mb3_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs`
--

LOCK TABLES `logs` WRITE;
/*!40000 ALTER TABLE `logs` DISABLE KEYS */;
INSERT INTO `logs` VALUES (1,'gabrielo','logout','192.168.92.200','2026-06-04 13:33:30'),(2,'gaga','user_created','192.168.92.200','2026-06-04 13:33:37'),(3,'gaga','login_success','192.168.92.200','2026-06-04 13:33:39'),(4,'gaga','logout','192.168.92.200','2026-06-04 13:34:39'),(5,'dfhd','user_created','192.168.92.200','2026-06-04 13:56:30'),(6,'dfhd','login_success','192.168.92.200','2026-06-04 13:56:36'),(7,'dfhd','logout','192.168.92.200','2026-06-04 13:56:46'),(8,'dfhd','login_success','192.168.92.200','2026-06-04 13:56:53'),(9,'dfhd','logout','192.168.92.200','2026-06-04 13:56:54'),(10,'gag','login_failed','192.168.92.200','2026-06-04 13:57:36'),(11,'test','logout','::1','2026-06-05 08:11:12'),(12,'g','user_created','192.168.92.200','2026-06-05 08:11:17'),(13,'g','login_success','192.168.92.200','2026-06-05 08:11:19'),(14,'g','login_failed','::1','2026-06-05 08:30:18'),(15,'gag','user_created','192.168.92.200','2026-06-05 08:51:17'),(16,'praxeadmin','user_created','192.168.92.200','2026-06-05 08:52:10'),(17,'praxeadmin','login_success','192.168.92.200','2026-06-05 08:53:04'),(18,'praxeadmin','login_success','::1','2026-06-05 08:54:52'),(19,'praxeadmin','logout','::1','2026-06-05 08:54:54'),(20,'praxeadmin','login_failed','192.168.92.200','2026-06-05 09:05:54'),(21,'praxeadmin','login_failed','192.168.92.200','2026-06-05 09:07:05'),(22,'praxeadmin','login_failed','192.168.92.200','2026-06-05 09:09:15'),(23,'praxeadmin','login_failed','192.168.92.200','2026-06-05 09:09:26'),(24,'praxe2\\praxeadmin','login_failed','192.168.92.200','2026-06-05 09:10:16'),(25,'praxe2.loc\\praxeadmin','login_failed','192.168.92.200','2026-06-05 09:10:34'),(26,'praxeadmin@praxe2.loc','user_created','192.168.92.200','2026-06-05 09:12:58'),(27,'praxeadmin@praxe2.loc','login_success','192.168.92.200','2026-06-05 09:16:12'),(28,'praxeadmin@praxe2.loc','login_success','192.168.92.200','2026-06-05 09:16:28'),(29,'praxeadmin@praxe2.loc','login_success','::1','2026-06-05 09:17:08'),(30,'praxeadmin@praxe2.loc','logout','::1','2026-06-05 09:18:06'),(31,'praxeadmin@praxe2.loc','login_success','::1','2026-06-05 09:53:35'),(32,'praxeadmin@praxe2.loc','logout','::1','2026-06-05 09:54:33'),(33,'praxeadmin@praxe2.loc','login_success','::1','2026-06-05 09:54:43'),(34,'praxeadmin@praxe2.loc','logout','::1','2026-06-05 10:14:05'),(35,'ybyb@praxe2.loc','user_created','::1','2026-06-05 10:14:11'),(36,'ybyb@praxe2.loc','login_success','::1','2026-06-05 10:14:16');
/*!40000 ALTER TABLE `logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) COLLATE utf8mb3_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'gaga','2026-06-04 13:33:37'),(2,'dfhd','2026-06-04 13:56:30'),(3,'g','2026-06-05 08:11:17'),(4,'gag','2026-06-05 08:51:17'),(5,'praxeadmin','2026-06-05 08:52:10'),(6,'praxeadmin@praxe2.loc','2026-06-05 09:12:58'),(7,'ybyb@praxe2.loc','2026-06-05 10:14:11');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'praxe1'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-05 10:21:36
