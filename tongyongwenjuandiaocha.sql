-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: tongyongwenjuandiaocha
-- ------------------------------------------------------
-- Server version	8.0.44

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
-- Current Database: `tongyongwenjuandiaocha`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `tongyongwenjuandiaocha` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `tongyongwenjuandiaocha`;

--
-- Table structure for table `config`
--

DROP TABLE IF EXISTS `config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `config` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `value` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `config`
--

LOCK TABLES `config` WRITE;
/*!40000 ALTER TABLE `config` DISABLE KEYS */;
INSERT INTO `config` VALUES (1,'picture1','http://localhost:8085/tongyongwenjuandiaocha/upload/1638238942609.jpg'),(2,'picture2','http://localhost:8085/tongyongwenjuandiaocha/upload/1638238950169.jpg'),(3,'picture3','http://localhost:8085/tongyongwenjuandiaocha/upload/1638238959682.jpg'),(6,'homepage',NULL);
/*!40000 ALTER TABLE `config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dictionary`
--

DROP TABLE IF EXISTS `dictionary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dictionary` (
  `id` int NOT NULL AUTO_INCREMENT,
  `dic_code` varchar(200) DEFAULT NULL,
  `dic_name` varchar(200) DEFAULT NULL,
  `code_index` tinyint DEFAULT NULL,
  `index_name` varchar(200) DEFAULT NULL,
  `super_types` int DEFAULT NULL,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dictionary`
--

LOCK TABLES `dictionary` WRITE;
/*!40000 ALTER TABLE `dictionary` DISABLE KEYS */;
INSERT INTO `dictionary` VALUES (1,'sex_types','性别',1,'男',NULL,'2022-09-22 10:09:07'),(2,'sex_types','性别',2,'女',NULL,'2022-09-22 10:09:07'),(3,'exampaper_types','问卷状态',1,'启用',NULL,'2022-09-22 10:09:07'),(4,'exampaper_types','问卷状态',2,'禁用',NULL,'2022-09-22 10:09:07'),(5,'examquestion_types','题目类型',1,'单选',NULL,'2022-02-08 17:02:57'),(6,'examquestion_types','题目类型',2,'多选',NULL,'2022-02-08 17:02:57'),(9,'examredetails_types','答题结果',1,'正确',NULL,'2022-02-08 17:02:57'),(10,'examredetails_types','答题结果',2,'错误',NULL,'2022-02-08 17:02:57');
/*!40000 ALTER TABLE `dictionary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exampaper`
--

DROP TABLE IF EXISTS `exampaper`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exampaper` (
  `id` int NOT NULL AUTO_INCREMENT,
  `exampaper_name` varchar(200) NOT NULL,
  `exampaper_date` int NOT NULL,
  `exampaper_jieshuyu` varchar(255) DEFAULT NULL,
  `exampaper_types` int NOT NULL DEFAULT '0',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exampaper`
--

LOCK TABLES `exampaper` WRITE;
/*!40000 ALTER TABLE `exampaper` DISABLE KEYS */;
INSERT INTO `exampaper` VALUES (1,'用户满意度调查问卷',10,'感谢您的参与，祝您生活愉快。',1,'2026-05-24 10:00:00'),(2,'示例调查问卷',5,'感谢填写。',1,'2026-05-24 10:05:00');
/*!40000 ALTER TABLE `exampaper` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `examquestion`
--

DROP TABLE IF EXISTS `examquestion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `examquestion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `exampaper_id` int NOT NULL,
  `examquestion_name` varchar(200) NOT NULL,
  `examquestion_options` longtext,
  `examquestion_types` int DEFAULT '0',
  `examquestion_sequence` int DEFAULT '100',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `examquestion`
--

LOCK TABLES `examquestion` WRITE;
/*!40000 ALTER TABLE `examquestion` DISABLE KEYS */;
INSERT INTO `examquestion` VALUES (1,1,'您对本系统的整体满意度如何？','[{\"text\":\"非常满意\",\"code\":\"A\"},{\"text\":\"比较满意\",\"code\":\"B\"},{\"text\":\"一般\",\"code\":\"C\"},{\"text\":\"不满意\",\"code\":\"D\"}]',1,1,'2026-05-24 10:10:00'),(2,1,'您最关注问卷系统的哪些功能？','[{\"text\":\"问卷创建\",\"code\":\"A\"},{\"text\":\"匿名填写\",\"code\":\"B\"},{\"text\":\"数据分析\",\"code\":\"C\"},{\"text\":\"结果导出\",\"code\":\"D\"}]',2,2,'2026-05-24 10:11:00'),(3,1,'您的年龄段是？','[{\"text\":\"18岁以下\",\"code\":\"A\"},{\"text\":\"18-25岁\",\"code\":\"B\"},{\"text\":\"26-35岁\",\"code\":\"C\"},{\"text\":\"36岁以上\",\"code\":\"D\"}]',1,3,'2026-05-24 10:12:00'),(4,2,'您是否愿意推荐本系统？','[{\"text\":\"愿意\",\"code\":\"A\"},{\"text\":\"不确定\",\"code\":\"B\"},{\"text\":\"不愿意\",\"code\":\"C\"}]',1,1,'2026-05-24 10:13:00');
/*!40000 ALTER TABLE `examquestion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `examrecord`
--

DROP TABLE IF EXISTS `examrecord`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `examrecord` (
  `id` int NOT NULL AUTO_INCREMENT,
  `examrecord_uuid_number` varchar(200) DEFAULT NULL,
  `yonghu_id` int NOT NULL,
  `exampaper_id` int NOT NULL,
  `insert_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `examrecord`
--

LOCK TABLES `examrecord` WRITE;
/*!40000 ALTER TABLE `examrecord` DISABLE KEYS */;
INSERT INTO `examrecord` VALUES (1,'202605240001',2,1,'2026-05-24 11:00:00','2026-05-24 11:00:00'),(2,'202605240002',3,1,'2026-05-24 11:05:00','2026-05-24 11:05:00');
/*!40000 ALTER TABLE `examrecord` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `examredetails`
--

DROP TABLE IF EXISTS `examredetails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `examredetails` (
  `id` int NOT NULL AUTO_INCREMENT,
  `examredetails_uuid_number` varchar(200) DEFAULT NULL,
  `yonghu_id` int NOT NULL,
  `examquestion_id` int NOT NULL,
  `examredetails_myanswer` varchar(200) DEFAULT NULL,
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=209 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `examredetails`
--

LOCK TABLES `examredetails` WRITE;
/*!40000 ALTER TABLE `examredetails` DISABLE KEYS */;
INSERT INTO `examredetails` VALUES (1,'202605240001',2,1,'A','2026-05-24 11:00:10'),(2,'202605240001',2,2,'A,C','2026-05-24 11:00:20'),(3,'202605240001',2,3,'B','2026-05-24 11:00:30'),(4,'202605240002',3,1,'B','2026-05-24 11:05:10'),(5,'202605240002',3,2,'B,C','2026-05-24 11:05:20'),(6,'202605240002',3,3,'C','2026-05-24 11:05:30');
/*!40000 ALTER TABLE `examredetails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `news`
--

DROP TABLE IF EXISTS `news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `news` (
  `id` int NOT NULL AUTO_INCREMENT,
  `news_name` varchar(200) DEFAULT NULL,
  `news_types` int DEFAULT NULL,
  `news_photo` varchar(200) DEFAULT NULL,
  `insert_time` timestamp NULL DEFAULT NULL,
  `news_content` text,
  `create_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news`
--

LOCK TABLES `news` WRITE;
/*!40000 ALTER TABLE `news` DISABLE KEYS */;
INSERT INTO `news` VALUES (1,'系统公告',1,'','2026-05-24 10:00:00','<p>欢迎使用通用问卷调查系统。</p>','2026-05-24 10:00:00');
/*!40000 ALTER TABLE `news` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `token`
--

DROP TABLE IF EXISTS `token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `token` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `userid` bigint NOT NULL,
  `username` varchar(100) NOT NULL,
  `tablename` varchar(100) DEFAULT NULL,
  `role` varchar(100) DEFAULT NULL,
  `token` varchar(200) NOT NULL,
  `addtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expiratedtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `token`
--

LOCK TABLES `token` WRITE;
/*!40000 ALTER TABLE `token` DISABLE KEYS */;
/*!40000 ALTER TABLE `token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `role` varchar(100) DEFAULT '管理员',
  `addtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','admin','管理员','2026-05-24 10:00:00');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yonghu`
--

DROP TABLE IF EXISTS `yonghu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `yonghu` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(200) DEFAULT NULL,
  `password` varchar(200) DEFAULT NULL,
  `yonghu_name` varchar(200) DEFAULT NULL,
  `sex_types` int DEFAULT NULL,
  `yonghu_id_number` varchar(200) DEFAULT NULL,
  `yonghu_phone` varchar(200) DEFAULT NULL,
  `yonghu_photo` varchar(200) DEFAULT NULL,
  `create_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yonghu`
--

LOCK TABLES `yonghu` WRITE;
/*!40000 ALTER TABLE `yonghu` DISABLE KEYS */;
INSERT INTO `yonghu` VALUES (2,'a1','123456','用户1',2,'410882199211261544','17785544961','http://localhost:8085/tongyongwenjuandiaocha/upload/1638238202964.jpg','2026-05-24 10:00:00'),(3,'a2','123456','用户2',1,'410882198911261244','17785596968','http://localhost:8085/tongyongwenjuandiaocha/upload/1638253648945.jpg','2026-05-24 10:05:00');
/*!40000 ALTER TABLE `yonghu` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-24 15:54:27
