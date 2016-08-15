-- MySQL dump 10.13  Distrib 5.6.31, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: memberdb
-- ------------------------------------------------------
-- Server version	5.6.31-0ubuntu0.14.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `activities`
--

DROP TABLE IF EXISTS `activities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `activities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity` varchar(100) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `activity` (`activity`),
  KEY `activity_idx` (`activity`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activities`
--

LOCK TABLES `activities` WRITE;
/*!40000 ALTER TABLE `activities` DISABLE KEYS */;
INSERT INTO `activities` VALUES (1,'admin','Can administrate anything. Equivilent to root.'),(2,'add org_members','Can add an entry into the org_members table. This can be used for renewing memberships or accepting membership applications.'),(3,'edit org_members','Ability to change the details of members other thanyourself.'),(4,'list members','Ability to retrieve a list of current members of an organisation.'),(5,'edit positions','Ability to edit the types of positions a member can hold'),(6,'election admin','Ability to administrate (create, edit) elections.');
/*!40000 ALTER TABLE `activities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `current_memberships`
--

DROP TABLE IF EXISTS `current_memberships`;
/*!50001 DROP VIEW IF EXISTS `current_memberships`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `current_memberships` AS SELECT 
 1 AS `id`,
 1 AS `date_entered`,
 1 AS `first_name`,
 1 AS `middle_name`,
 1 AS `last_name`,
 1 AS `DOB`,
 1 AS `sex`,
 1 AS `address1`,
 1 AS `address2`,
 1 AS `suburb`,
 1 AS `postcode`,
 1 AS `state`,
 1 AS `country`,
 1 AS `email`,
 1 AS `phone_home`,
 1 AS `phone_mobile`,
 1 AS `org_id`,
 1 AS `org_name`,
 1 AS `member_type_id`,
 1 AS `member_type`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `election`
--

DROP TABLE IF EXISTS `election`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `election` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `org_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `start_advertising` datetime DEFAULT NULL,
  `nominations_start` datetime NOT NULL,
  `nominations_close` datetime NOT NULL,
  `num_req_nominations` int(11) NOT NULL DEFAULT '0',
  `advertise_candidates` datetime NOT NULL,
  `live_results` tinyint(1) DEFAULT NULL,
  `start_voting` datetime NOT NULL,
  `close_voting` datetime NOT NULL,
  `show_results` datetime NOT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  KEY `election_org_id_fkey` (`org_id`),
  CONSTRAINT `election_org_id_fkey` FOREIGN KEY (`org_id`) REFERENCES `orgs` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `election`
--

LOCK TABLES `election` WRITE;
/*!40000 ALTER TABLE `election` DISABLE KEYS */;
/*!40000 ALTER TABLE `election` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `election_candidate`
--

DROP TABLE IF EXISTS `election_candidate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `election_candidate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `election_position_id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `spiel` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `election_candidate_pkey` (`election_position_id`,`member_id`),
  KEY `election_candidate_member_id` (`member_id`),
  CONSTRAINT `election_candidate_election_position_id_fkey` FOREIGN KEY (`election_position_id`) REFERENCES `election_position` (`id`),
  CONSTRAINT `election_candidate_member_id` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `election_candidate`
--

LOCK TABLES `election_candidate` WRITE;
/*!40000 ALTER TABLE `election_candidate` DISABLE KEYS */;
/*!40000 ALTER TABLE `election_candidate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `election_candidate_nomination`
--

DROP TABLE IF EXISTS `election_candidate_nomination`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `election_candidate_nomination` (
  `when_nominated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `election_position_id` int(11) NOT NULL,
  `from_member_id` int(11) NOT NULL,
  `for_member_id` int(11) NOT NULL,
  `reason` text,
  PRIMARY KEY (`election_position_id`,`from_member_id`,`for_member_id`),
  KEY `nomination_from_member_id_fkey` (`from_member_id`),
  KEY `nomination_for_member_id_fkey` (`for_member_id`),
  CONSTRAINT `election_candidate_nomination_election_position_id_fkey` FOREIGN KEY (`election_position_id`) REFERENCES `election_position` (`id`),
  CONSTRAINT `nomination_for_member_id_fkey` FOREIGN KEY (`for_member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `nomination_from_member_id_fkey` FOREIGN KEY (`from_member_id`) REFERENCES `members` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `election_candidate_nomination`
--

LOCK TABLES `election_candidate_nomination` WRITE;
/*!40000 ALTER TABLE `election_candidate_nomination` DISABLE KEYS */;
/*!40000 ALTER TABLE `election_candidate_nomination` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `election_position`
--

DROP TABLE IF EXISTS `election_position`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `election_position` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `election_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `num` int(11) NOT NULL DEFAULT '1',
  `description` text,
  PRIMARY KEY (`id`),
  KEY `election_position_election_id_fkey` (`election_id`),
  CONSTRAINT `election_position_election_id_fkey` FOREIGN KEY (`election_id`) REFERENCES `election` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `election_position`
--

LOCK TABLES `election_position` WRITE;
/*!40000 ALTER TABLE `election_position` DISABLE KEYS */;
/*!40000 ALTER TABLE `election_position` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `election_vote`
--

DROP TABLE IF EXISTS `election_vote`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `election_vote` (
  `member_id` int(11) NOT NULL,
  `candidate_id` int(11) NOT NULL,
  `preference` int(11) NOT NULL,
  PRIMARY KEY (`member_id`,`candidate_id`),
  UNIQUE KEY `election_vote_uniq` (`member_id`,`candidate_id`,`preference`),
  KEY `election_vote_candidate_id_fkey` (`candidate_id`),
  CONSTRAINT `election_vote_candidate_id_fkey` FOREIGN KEY (`candidate_id`) REFERENCES `election_candidate` (`id`),
  CONSTRAINT `election_vote_member_id_fkey` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `election_vote`
--

LOCK TABLES `election_vote` WRITE;
/*!40000 ALTER TABLE `election_vote` DISABLE KEYS */;
/*!40000 ALTER TABLE `election_vote` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `event_host_orgs`
--

DROP TABLE IF EXISTS `event_host_orgs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event_host_orgs` (
  `event_id` int(11) NOT NULL,
  `org_id` int(11) NOT NULL,
  `rank` int(11) DEFAULT NULL,
  PRIMARY KEY (`event_id`,`org_id`),
  KEY `event_host_orgs_org_id_fkey` (`org_id`),
  CONSTRAINT `event_host_orgs_event_id_fkey` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`),
  CONSTRAINT `event_host_orgs_org_id_fkey` FOREIGN KEY (`org_id`) REFERENCES `orgs` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `event_host_orgs`
--

LOCK TABLES `event_host_orgs` WRITE;
/*!40000 ALTER TABLE `event_host_orgs` DISABLE KEYS */;
/*!40000 ALTER TABLE `event_host_orgs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `event_organisers`
--

DROP TABLE IF EXISTS `event_organisers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event_organisers` (
  `event_id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `role` varchar(50) DEFAULT NULL,
  KEY `event_organisers_event_id_fkey` (`event_id`),
  KEY `event_organisers_member_id_fkey` (`member_id`),
  CONSTRAINT `event_organisers_event_id_fkey` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`),
  CONSTRAINT `event_organisers_member_id_fkey` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `event_organisers`
--

LOCK TABLES `event_organisers` WRITE;
/*!40000 ALTER TABLE `event_organisers` DISABLE KEYS */;
/*!40000 ALTER TABLE `event_organisers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `event_signup`
--

DROP TABLE IF EXISTS `event_signup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event_signup` (
  `event_id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `event_signup_status_id` int(11) NOT NULL,
  `ticket` int(11) DEFAULT NULL,
  KEY `event_signup_event_id_fkey` (`event_id`),
  KEY `event_signup_member_id_fkey` (`member_id`),
  KEY `event_signup_event_signup_status_id_fkey` (`event_signup_status_id`),
  CONSTRAINT `event_signup_event_id_fkey` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`),
  CONSTRAINT `event_signup_event_signup_status_id_fkey` FOREIGN KEY (`event_signup_status_id`) REFERENCES `event_signup_status` (`id`),
  CONSTRAINT `event_signup_member_id_fkey` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `event_signup`
--

LOCK TABLES `event_signup` WRITE;
/*!40000 ALTER TABLE `event_signup` DISABLE KEYS */;
/*!40000 ALTER TABLE `event_signup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `event_signup_status`
--

DROP TABLE IF EXISTS `event_signup_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event_signup_status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `event_signup_status`
--

LOCK TABLES `event_signup_status` WRITE;
/*!40000 ALTER TABLE `event_signup_status` DISABLE KEYS */;
/*!40000 ALTER TABLE `event_signup_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `event_types`
--

DROP TABLE IF EXISTS `event_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `event_types`
--

LOCK TABLES `event_types` WRITE;
/*!40000 ALTER TABLE `event_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `event_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_type_id` int(11) NOT NULL,
  `name` varchar(80) NOT NULL,
  `description` text,
  `start_datetime` datetime NOT NULL,
  `end_datetime` datetime NOT NULL,
  `url` varchar(255) DEFAULT NULL,
  `cost` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `events_event_type_id_fkey` (`event_type_id`),
  CONSTRAINT `events_event_type_id_fkey` FOREIGN KEY (`event_type_id`) REFERENCES `event_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `group_members`
--

DROP TABLE IF EXISTS `group_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `group_members` (
  `group_id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `start_datetime` datetime NOT NULL,
  `end_datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`group_id`,`member_id`),
  KEY `group_members_member_fkey` (`member_id`),
  CONSTRAINT `group_members_group_fkey` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`),
  CONSTRAINT `group_members_member_fkey` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `group_members`
--

LOCK TABLES `group_members` WRITE;
/*!40000 ALTER TABLE `group_members` DISABLE KEYS */;
/*!40000 ALTER TABLE `group_members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `groups`
--

DROP TABLE IF EXISTS `groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `org_id` int(11) DEFAULT NULL,
  `group_name` varchar(100) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_name` (`group_name`),
  KEY `groups_org_id_fkey` (`org_id`),
  KEY `group_idx` (`group_name`),
  CONSTRAINT `groups_org_id_fkey` FOREIGN KEY (`org_id`) REFERENCES `orgs` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `groups`
--

LOCK TABLES `groups` WRITE;
/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `has_had_membership`
--

DROP TABLE IF EXISTS `has_had_membership`;
/*!50001 DROP VIEW IF EXISTS `has_had_membership`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `has_had_membership` AS SELECT 
 1 AS `id`,
 1 AS `date_entered`,
 1 AS `first_name`,
 1 AS `middle_name`,
 1 AS `last_name`,
 1 AS `DOB`,
 1 AS `sex`,
 1 AS `address1`,
 1 AS `address2`,
 1 AS `suburb`,
 1 AS `postcode`,
 1 AS `state`,
 1 AS `country`,
 1 AS `email`,
 1 AS `phone_home`,
 1 AS `phone_mobile`,
 1 AS `org_id`,
 1 AS `org_name`,
 1 AS `member_type_id`,
 1 AS `member_type`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `has_permission`
--

DROP TABLE IF EXISTS `has_permission`;
/*!50001 DROP VIEW IF EXISTS `has_permission`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `has_permission` AS SELECT 
 1 AS `member_id`,
 1 AS `email`,
 1 AS `org_id`,
 1 AS `activity`,
 1 AS `can_do`,
 1 AS `can_grant`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `log`
--

DROP TABLE IF EXISTS `log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `log` (
  `logtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `priority` int(11) DEFAULT NULL,
  `username` varchar(50) DEFAULT NULL,
  `entry` text NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log`
--

LOCK TABLES `log` WRITE;
/*!40000 ALTER TABLE `log` DISABLE KEYS */;
/*!40000 ALTER TABLE `log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mail_queue`
--

DROP TABLE IF EXISTS `mail_queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mail_queue` (
  `id` bigint(20) NOT NULL DEFAULT '0',
  `create_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `time_to_send` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `sent_time` datetime DEFAULT NULL,
  `id_user` bigint(20) NOT NULL DEFAULT '0',
  `ip` varchar(20) NOT NULL DEFAULT 'unknown',
  `sender` varchar(50) NOT NULL DEFAULT '',
  `recipient` varchar(50) NOT NULL DEFAULT '',
  `headers` text NOT NULL,
  `body` longtext NOT NULL,
  `try_sent` tinyint(4) NOT NULL DEFAULT '0',
  `delete_after_send` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `time_to_send` (`time_to_send`),
  KEY `id_user` (`id_user`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mail_queue`
--

LOCK TABLES `mail_queue` WRITE;
/*!40000 ALTER TABLE `mail_queue` DISABLE KEYS */;
/*!40000 ALTER TABLE `mail_queue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mail_queue_seq`
--

DROP TABLE IF EXISTS `mail_queue_seq`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mail_queue_seq` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mail_queue_seq`
--

LOCK TABLES `mail_queue_seq` WRITE;
/*!40000 ALTER TABLE `mail_queue_seq` DISABLE KEYS */;
INSERT INTO `mail_queue_seq` VALUES (1);
/*!40000 ALTER TABLE `mail_queue_seq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_cards`
--

DROP TABLE IF EXISTS `member_cards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member_cards` (
  `org_id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `card_id` varchar(50) DEFAULT NULL,
  `start_datetime` datetime NOT NULL,
  `end_datetime` datetime DEFAULT NULL,
  KEY `member_cards_org_id_fkey` (`org_id`),
  KEY `member_cards_member_id_fkey` (`member_id`),
  CONSTRAINT `member_cards_member_id_fkey` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `member_cards_org_id_fkey` FOREIGN KEY (`org_id`) REFERENCES `orgs` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_cards`
--

LOCK TABLES `member_cards` WRITE;
/*!40000 ALTER TABLE `member_cards` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_cards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_qualifications`
--

DROP TABLE IF EXISTS `member_qualifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member_qualifications` (
  `member_id` int(11) DEFAULT NULL,
  `qualification_id` int(11) DEFAULT NULL,
  `detail` varchar(250) DEFAULT NULL,
  KEY `member_qual_member_id_fkey` (`member_id`),
  KEY `member_qual_id_fkey` (`qualification_id`),
  CONSTRAINT `member_qual_id_fkey` FOREIGN KEY (`qualification_id`) REFERENCES `qualifications` (`id`),
  CONSTRAINT `member_qual_member_id_fkey` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_qualifications`
--

LOCK TABLES `member_qualifications` WRITE;
/*!40000 ALTER TABLE `member_qualifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_qualifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_types`
--

DROP TABLE IF EXISTS `member_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `org_id` int(11) NOT NULL,
  `type` varchar(50) NOT NULL,
  `validates_membership` tinyint(1) NOT NULL,
  `revokes_membership` tinyint(1) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  KEY `member_types_org_id_fkey` (`org_id`),
  KEY `member_types_type_idx` (`type`),
  CONSTRAINT `member_types_org_id_fkey` FOREIGN KEY (`org_id`) REFERENCES `orgs` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_types`
--

LOCK TABLES `member_types` WRITE;
/*!40000 ALTER TABLE `member_types` DISABLE KEYS */;
INSERT INTO `member_types` VALUES (1,1,'Member',1,0,'Ordinary Member'),(2,1,'Applied',0,1,'Applied'),(3,1,'Pending',1,0,'Pending'),(4,1,'Approved',1,0,'Approved');
/*!40000 ALTER TABLE `member_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date_entered` datetime DEFAULT NULL,
  `first_name` varchar(50) NOT NULL,
  `middle_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `DOB` date DEFAULT NULL,
  `sex` char(1) DEFAULT NULL,
  `address1` varchar(50) DEFAULT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `suburb` varchar(50) DEFAULT NULL,
  `postcode` varchar(10) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `country` varchar(20) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `phone_home` varchar(25) DEFAULT NULL,
  `phone_mobile` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `member_email_idx` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
INSERT INTO `members` VALUES (1,NULL,'Admin',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'admin@localhost',NULL,NULL);
/*!40000 ALTER TABLE `members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members_old_details`
--

DROP TABLE IF EXISTS `members_old_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `members_old_details` (
  `id` int(11) NOT NULL,
  `date_entered` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `first_name` varchar(50) NOT NULL,
  `middle_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `DOB` date DEFAULT NULL,
  `sex` char(1) DEFAULT NULL,
  `address1` varchar(50) DEFAULT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `suburb` varchar(50) DEFAULT NULL,
  `postcode` varchar(10) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `country` varchar(20) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `phone_home` varchar(25) DEFAULT NULL,
  `phone_mobile` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`id`,`date_entered`),
  CONSTRAINT `members_old_details_id_fkey` FOREIGN KEY (`id`) REFERENCES `members` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members_old_details`
--

LOCK TABLES `members_old_details` WRITE;
/*!40000 ALTER TABLE `members_old_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `members_old_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `org_members`
--

DROP TABLE IF EXISTS `org_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `org_members` (
  `member_id` int(11) NOT NULL,
  `org_id` int(11) NOT NULL,
  `member_type_id` int(11) NOT NULL,
  `start_date` datetime NOT NULL,
  `expiry` datetime DEFAULT NULL,
  KEY `org_members_member_id_fkey` (`member_id`),
  KEY `org_members__id_fkey` (`org_id`),
  KEY `member_type_id_idx` (`member_type_id`),
  KEY `org_members_startdate_idx` (`start_date`),
  KEY `org_members_expiry_idx` (`expiry`),
  CONSTRAINT `org_members__id_fkey` FOREIGN KEY (`org_id`) REFERENCES `orgs` (`id`),
  CONSTRAINT `org_members_member_id_fkey` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `org_members_member_type_id_fkey` FOREIGN KEY (`member_type_id`) REFERENCES `member_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `org_members`
--

LOCK TABLES `org_members` WRITE;
/*!40000 ALTER TABLE `org_members` DISABLE KEYS */;
INSERT INTO `org_members` VALUES (1,1,1,'2015-12-16 18:13:25','2016-02-03 12:56:09');
/*!40000 ALTER TABLE `org_members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `org_memberships`
--

DROP TABLE IF EXISTS `org_memberships`;
/*!50001 DROP VIEW IF EXISTS `org_memberships`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `org_memberships` AS SELECT 
 1 AS `member_id`,
 1 AS `org_id`,
 1 AS `type`,
 1 AS `description`,
 1 AS `start_date`,
 1 AS `expiry`,
 1 AS `validates_membership`,
 1 AS `revokes_membership`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `org_org_types`
--

DROP TABLE IF EXISTS `org_org_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `org_org_types` (
  `org_id` int(11) DEFAULT NULL,
  `org_type_id` int(11) DEFAULT NULL,
  KEY `org_org_types_org_idx` (`org_id`),
  KEY `org_org_types_type_idx` (`org_type_id`),
  CONSTRAINT `org_types_id_fkey` FOREIGN KEY (`org_type_id`) REFERENCES `org_types` (`id`),
  CONSTRAINT `orgs_org_id_fkey` FOREIGN KEY (`org_id`) REFERENCES `orgs` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `org_org_types`
--

LOCK TABLES `org_org_types` WRITE;
/*!40000 ALTER TABLE `org_org_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `org_org_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `org_relation_types`
--

DROP TABLE IF EXISTS `org_relation_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `org_relation_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `org_id` int(11) DEFAULT NULL,
  `type` varchar(50) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  KEY `org_relation_types_org_id_fkey` (`org_id`),
  CONSTRAINT `org_relation_types_org_id_fkey` FOREIGN KEY (`org_id`) REFERENCES `orgs` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `org_relation_types`
--

LOCK TABLES `org_relation_types` WRITE;
/*!40000 ALTER TABLE `org_relation_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `org_relation_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `org_relations`
--

DROP TABLE IF EXISTS `org_relations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `org_relations` (
  `org_id` int(11) NOT NULL,
  `related_to_org_id` int(11) NOT NULL,
  `org_relation_type_id` int(11) NOT NULL,
  PRIMARY KEY (`org_id`,`related_to_org_id`,`org_relation_type_id`),
  KEY `org_relations_related_to_org_id_fkey` (`related_to_org_id`),
  KEY `orgs_relations_org_relation_type_id_fkey` (`org_relation_type_id`),
  CONSTRAINT `org_relations_org_id_fkey` FOREIGN KEY (`org_id`) REFERENCES `orgs` (`id`),
  CONSTRAINT `org_relations_related_to_org_id_fkey` FOREIGN KEY (`related_to_org_id`) REFERENCES `orgs` (`id`),
  CONSTRAINT `orgs_relations_org_relation_type_id_fkey` FOREIGN KEY (`org_relation_type_id`) REFERENCES `org_relation_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `org_relations`
--

LOCK TABLES `org_relations` WRITE;
/*!40000 ALTER TABLE `org_relations` DISABLE KEYS */;
/*!40000 ALTER TABLE `org_relations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `org_types`
--

DROP TABLE IF EXISTS `org_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `org_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `org_types`
--

LOCK TABLES `org_types` WRITE;
/*!40000 ALTER TABLE `org_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `org_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orgs`
--

DROP TABLE IF EXISTS `orgs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orgs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `founded` datetime DEFAULT NULL,
  `closed` datetime DEFAULT NULL,
  `address1` varchar(100) DEFAULT NULL,
  `address2` varchar(100) DEFAULT NULL,
  `suburb` varchar(50) DEFAULT NULL,
  `postcode` varchar(10) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `country` varchar(50) DEFAULT 'Australia',
  `website` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `fax` varchar(50) DEFAULT NULL,
  `mobile` varchar(50) DEFAULT NULL,
  `description` text,
  `owner_member_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `owner_member_id` (`owner_member_id`),
  CONSTRAINT `orgs_ibfk_1` FOREIGN KEY (`owner_member_id`) REFERENCES `members` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orgs`
--

LOCK TABLES `orgs` WRITE;
/*!40000 ALTER TABLE `orgs` DISABLE KEYS */;
INSERT INTO `orgs` VALUES (1,'MemberDB Organisation',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Australia','http://www.flamingspork.com/projects/memberdb/',NULL,NULL,NULL,NULL,'An organisation for all the cool people who run MemberDB',NULL);
/*!40000 ALTER TABLE `orgs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `passwd`
--

DROP TABLE IF EXISTS `passwd`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `passwd` (
  `member_id` int(11) NOT NULL,
  `salt` varchar(10) DEFAULT NULL,
  `password` char(33) NOT NULL,
  PRIMARY KEY (`member_id`),
  CONSTRAINT `passwd_member_id_fkey` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `passwd`
--

LOCK TABLES `passwd` WRITE;
/*!40000 ALTER TABLE `passwd` DISABLE KEYS */;
INSERT INTO `passwd` VALUES (1,'5','83c01ca8d584d792d3902fcc7cdee78a');
/*!40000 ALTER TABLE `passwd` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `pending_memberships`
--

DROP TABLE IF EXISTS `pending_memberships`;
/*!50001 DROP VIEW IF EXISTS `pending_memberships`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `pending_memberships` AS SELECT 
 1 AS `id`,
 1 AS `date_entered`,
 1 AS `first_name`,
 1 AS `middle_name`,
 1 AS `last_name`,
 1 AS `DOB`,
 1 AS `sex`,
 1 AS `address1`,
 1 AS `address2`,
 1 AS `suburb`,
 1 AS `postcode`,
 1 AS `state`,
 1 AS `country`,
 1 AS `email`,
 1 AS `phone_home`,
 1 AS `phone_mobile`,
 1 AS `org_id`,
 1 AS `org_name`,
 1 AS `member_type_id`,
 1 AS `member_type`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permissions` (
  `member_id` int(11) DEFAULT NULL,
  `group_id` int(11) DEFAULT NULL,
  `org_id` int(11) DEFAULT NULL,
  `activity_id` int(11) NOT NULL,
  `can_do` tinyint(1) DEFAULT NULL,
  `can_grant` tinyint(1) DEFAULT NULL,
  `start_datetime` datetime NOT NULL,
  `end_datetime` datetime DEFAULT NULL,
  KEY `member_permissions_member_id_fkey` (`member_id`),
  KEY `member_permissions_org_id_fkey` (`org_id`),
  KEY `member_permissions_activity_id_fkey` (`activity_id`),
  KEY `member_permissions_group_id_fkey` (`group_id`),
  CONSTRAINT `member_permissions_activity_id_fkey` FOREIGN KEY (`activity_id`) REFERENCES `activities` (`id`),
  CONSTRAINT `member_permissions_group_id_fkey` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`),
  CONSTRAINT `member_permissions_member_id_fkey` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `member_permissions_org_id_fkey` FOREIGN KEY (`org_id`) REFERENCES `orgs` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` VALUES (1,NULL,1,1,1,1,'2015-12-16 18:13:25',NULL);
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `positions`
--

DROP TABLE IF EXISTS `positions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `positions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `org_id` int(11) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  KEY `positions_org_id_fkey` (`org_id`),
  CONSTRAINT `positions_org_id_fkey` FOREIGN KEY (`org_id`) REFERENCES `orgs` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `positions`
--

LOCK TABLES `positions` WRITE;
/*!40000 ALTER TABLE `positions` DISABLE KEYS */;
/*!40000 ALTER TABLE `positions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `positions_held`
--

DROP TABLE IF EXISTS `positions_held`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `positions_held` (
  `position_id` int(11) NOT NULL,
  `org_id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `start_datetime` datetime NOT NULL,
  `end_datetime` datetime NOT NULL,
  KEY `positions_held_position_id_fkey` (`position_id`),
  KEY `positions_held_org_id_fkey` (`org_id`),
  KEY `positions_held_member_id_fkey` (`member_id`),
  CONSTRAINT `positions_held_member_id_fkey` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `positions_held_org_id_fkey` FOREIGN KEY (`org_id`) REFERENCES `orgs` (`id`),
  CONSTRAINT `positions_held_position_id_fkey` FOREIGN KEY (`position_id`) REFERENCES `positions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `positions_held`
--

LOCK TABLES `positions_held` WRITE;
/*!40000 ALTER TABLE `positions_held` DISABLE KEYS */;
/*!40000 ALTER TABLE `positions_held` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qualifications`
--

DROP TABLE IF EXISTS `qualifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `qualifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `department` varchar(100) DEFAULT NULL,
  `institution` varchar(100) DEFAULT NULL,
  `detail` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qualifications`
--

LOCK TABLES `qualifications` WRITE;
/*!40000 ALTER TABLE `qualifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `qualifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site_messages`
--

DROP TABLE IF EXISTS `site_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `site_messages` (
  `name` varchar(50) DEFAULT NULL,
  `mail_to` text,
  `mail_cc` text,
  `mail_subject` text,
  `message` text,
  KEY `site_messages_name_idx` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site_messages`
--

LOCK TABLES `site_messages` WRITE;
/*!40000 ALTER TABLE `site_messages` DISABLE KEYS */;
INSERT INTO `site_messages` VALUES ('signup/confirm-application','%MEMBER_EMAIL%','%MEMBERSHIP_ADMIN%','Application for %ORG_NAME% Membership\n','Thank you for applying to become a member of %ORG_NAME%. Attached\nare the details you entered when you signed up.\n\nShortly you should receive an email notifying you of the result of your application for membership.\n\n\n-----------------\nApplication for Membership\n%ORG_NAME%\n\nI,  %MEMBER_FULLNAME%\n\nof  %MEMBER_ADDRESS%\n\nhereby apply to become a member of the abovenamed incorporated association.\nIn the event of my admission as a member, I agree to be bound by the rules\nof the association for the time being in force.\n\n%DATE%'),('signup/application-request-for-confirm','%MEMBER_EMAIL%','%MEMBERSHIP_ADMIN%','Application for %ORG_NAME% Membership','Somebody (most likely you) has submitted this email address\nas their email address when applying for %ORG_NAME%\n<URL %ORG_URL%> membership.\n\nOn %DATE% the following data was submitted on our website:\n%MEMBER_DETAILS%\n\nYOUR APPLICATION IS NOT READY YET!\n\nYou must visit this link to confirm that this application\nis valid. If you have received this message erroneously,\njust ignore it and it will go away.\n\n%ACTION_URL%'),('signup/approve-status-change','%MEMBER_EMAIL%','%MEMBERSHIP_ADMIN%','New %ORG_NAME% Membership Status: %MEMBER_TYPE%\n','Your membership status of %ORG_NAME% has been changed to:\n\n%MEMBER_TYPE%\n\nYou can now log into the membership site with the following details:\nEmail: %MEMBER_EMAIL%\nPassword: %MEMBER_PASSWORD%\n\nPlease change your password when you first log in.'),('recover-password','%MEMBER_EMAIL%','%MEMBERSHIP_ADMIN%','Recover %ORG_NAME% Member password','You (or someone pretending to be you) has asked for\nyour password to be reset.\n\nTo do so, go to the following URL:\n%ACTION_URL%\n\nMake sure that the URL is on one line. It will remain active for\n%ACTION_TTL% from the time the request was made.'),('election-notify-nominee','%NOMINEE_EMAIL%','%MEMBERSHIP_ADMIN%','Nomination for %POSITION%','In the online election (%ELECTION%) being held by %ORG_NAME%, %NOMINATOR% has nominated you (%NOMINEE%) for a position.\n\nElection: %ELECTION%\nPosition: %POSITION%\nNominator: %NOMINATOR%\nNominee: %NOMINEE%\n\nOnce you have enough nominations, you can accept the nomination\nand become a candidate.\n\nYou will be notified of this event in a future mail.'),('election-notify-nominator','%MEMBER_EMAIL%','%MEMBERSHIP_ADMIN%','Your nomination for %POSITION%','In the online election (%ELECTION%) being held by %ORG_NAME%, you have made the following nomination:\n\nElection: %ELECTION%\nPosition: %POSITION%\nNominator: %NOMINATOR%\nNominee: %NOMINEE%\n\nOnce there are enough nominations for this member for this position\nthey may accept the nomination and become a candidate.\n'),('election-notify-candidate','%NOMINEE_EMAIL%','%MEMBERSHIP_ADMIN%','Nomination for %POSITION%','In the online election (%ELECTION%) being held by %ORG_NAME%, %NOMINATOR% has nominated you (%NOMINEE%) for a position.\n\nElection: %ELECTION%\nPosition: %POSITION%\nNominator: %NOMINATOR%\nNominee: %NOMINEE%\n\nYou now have enough nominations to become a candidate.\n\nFollow this link to accept the nomination:\n%ACTION_URL%\n\nIf you do not wish to accept the nomination, do nothing.\n\nYou cannot be elected to this position without accepting the nomination!\n'),('election-notify-candidate-nominator','%MEMBER_EMAIL%','%MEMBERSHIP_ADMIN%','Your nomination for %POSITION%','In the online election (%ELECTION%) being held by %ORG_NAME%, you have made the following nomination:\n\nElection: %ELECTION%\nPosition: %POSITION%\nNominator: %NOMINATOR%\nNominee: %NOMINEE%\n\nThe member you nominated now has enough nominations to become\na candidate for the position. It is up for them to accept this\nnomination and go through the process of becoming a candidate.\n'),('election-vote','%MEMBER_EMAIL%','%MEMBERSHIP_ADMIN%','Your vote in %ELECTION%','You have voted in the online election (%ELECTION%) being held by %ORG_NAME%. If this is incorrect, please contact %ORG_NAME%.\n');
/*!40000 ALTER TABLE `site_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `token`
--

DROP TABLE IF EXISTS `token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `token` (
  `token` varchar(50) NOT NULL DEFAULT '',
  `member_id` int(11) NOT NULL DEFAULT '0',
  `task` varchar(50) NOT NULL DEFAULT '',
  `expires` int(11) DEFAULT NULL,
  PRIMARY KEY (`token`,`member_id`,`task`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `token`
--

LOCK TABLES `token` WRITE;
/*!40000 ALTER TABLE `token` DISABLE KEYS */;
/*!40000 ALTER TABLE `token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `vendors`
--

DROP TABLE IF EXISTS `vendors`;
/*!50001 DROP VIEW IF EXISTS `vendors`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `vendors` AS SELECT 
 1 AS `id`,
 1 AS `name`,
 1 AS `founded`,
 1 AS `closed`,
 1 AS `address1`,
 1 AS `address2`,
 1 AS `suburb`,
 1 AS `postcode`,
 1 AS `state`,
 1 AS `country`,
 1 AS `website`,
 1 AS `email`,
 1 AS `phone`,
 1 AS `fax`,
 1 AS `mobile`,
 1 AS `description`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `current_memberships`
--

/*!50001 DROP VIEW IF EXISTS `current_memberships`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50001 VIEW `current_memberships` AS select distinct `members`.`id` AS `id`,`members`.`date_entered` AS `date_entered`,`members`.`first_name` AS `first_name`,`members`.`middle_name` AS `middle_name`,`members`.`last_name` AS `last_name`,`members`.`DOB` AS `DOB`,`members`.`sex` AS `sex`,`members`.`address1` AS `address1`,`members`.`address2` AS `address2`,`members`.`suburb` AS `suburb`,`members`.`postcode` AS `postcode`,`members`.`state` AS `state`,`members`.`country` AS `country`,`members`.`email` AS `email`,`members`.`phone_home` AS `phone_home`,`members`.`phone_mobile` AS `phone_mobile`,`orgs`.`id` AS `org_id`,`orgs`.`name` AS `org_name`,`member_types`.`id` AS `member_type_id`,`member_types`.`type` AS `member_type` from (((`members` join `orgs`) join `org_members`) join `member_types`) where ((`members`.`id` = `org_members`.`member_id`) and (`org_members`.`org_id` = `orgs`.`id`) and (`org_members`.`member_type_id` = `member_types`.`id`) and (`member_types`.`org_id` = `orgs`.`id`) and (((`org_members`.`start_date` < now()) and (`org_members`.`expiry` > now())) or (isnull(`org_members`.`start_date`) and isnull(`org_members`.`expiry`)) or ((`org_members`.`start_date` < now()) and isnull(`org_members`.`expiry`)) or (isnull(`org_members`.`start_date`) and (`org_members`.`expiry` > now()))) and (`member_types`.`validates_membership` = 1) and (not(exists(select `org_members`.`member_id` from (`org_members` join `member_types`) where ((`org_members`.`member_type_id` = `member_types`.`id`) and (`org_members`.`member_id` = `members`.`id`) and (`member_types`.`revokes_membership` = 1) and (`member_types`.`validates_membership` = 0) and (((`org_members`.`start_date` < now()) and (`org_members`.`expiry` > now())) or (isnull(`org_members`.`start_date`) and isnull(`org_members`.`expiry`)) or ((`org_members`.`start_date` < now()) and isnull(`org_members`.`expiry`)) or (isnull(`org_members`.`start_date`) and (`org_members`.`expiry` > now())))))))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `has_had_membership`
--

/*!50001 DROP VIEW IF EXISTS `has_had_membership`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50001 VIEW `has_had_membership` AS select distinct `members`.`id` AS `id`,`members`.`date_entered` AS `date_entered`,`members`.`first_name` AS `first_name`,`members`.`middle_name` AS `middle_name`,`members`.`last_name` AS `last_name`,`members`.`DOB` AS `DOB`,`members`.`sex` AS `sex`,`members`.`address1` AS `address1`,`members`.`address2` AS `address2`,`members`.`suburb` AS `suburb`,`members`.`postcode` AS `postcode`,`members`.`state` AS `state`,`members`.`country` AS `country`,`members`.`email` AS `email`,`members`.`phone_home` AS `phone_home`,`members`.`phone_mobile` AS `phone_mobile`,`orgs`.`id` AS `org_id`,`orgs`.`name` AS `org_name`,`member_types`.`id` AS `member_type_id`,`member_types`.`type` AS `member_type` from (((`members` join `orgs`) join `org_members`) join `member_types`) where ((`members`.`id` = `org_members`.`member_id`) and (`org_members`.`org_id` = `orgs`.`id`) and (`org_members`.`member_type_id` = `member_types`.`id`) and (`member_types`.`org_id` = `orgs`.`id`) and ((`org_members`.`start_date` < now()) or isnull(`org_members`.`start_date`) or (`org_members`.`start_date` < now()) or isnull(`org_members`.`start_date`)) and (`member_types`.`validates_membership` = 1) and (not(exists(select `org_members`.`member_id` from (`org_members` join `member_types`) where ((`org_members`.`member_type_id` = `member_types`.`id`) and (`org_members`.`member_id` = `members`.`id`) and (`member_types`.`revokes_membership` = 1) and (`member_types`.`validates_membership` = 0) and (((`org_members`.`start_date` < now()) and (`org_members`.`expiry` > now())) or (isnull(`org_members`.`start_date`) and isnull(`org_members`.`expiry`)) or ((`org_members`.`start_date` < now()) and isnull(`org_members`.`expiry`)) or (isnull(`org_members`.`start_date`) and (`org_members`.`expiry` > now())))))))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `has_permission`
--

/*!50001 DROP VIEW IF EXISTS `has_permission`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50001 VIEW `has_permission` AS select `permissions`.`member_id` AS `member_id`,`members`.`email` AS `email`,`permissions`.`org_id` AS `org_id`,`activities`.`activity` AS `activity`,`permissions`.`can_do` AS `can_do`,`permissions`.`can_grant` AS `can_grant` from ((`permissions` join `activities`) join `members`) where ((`permissions`.`activity_id` = `activities`.`id`) and (`permissions`.`member_id` = `members`.`id`) and (((`permissions`.`start_datetime` < now()) and (`permissions`.`end_datetime` > now())) or (isnull(`permissions`.`start_datetime`) and isnull(`permissions`.`end_datetime`)) or ((`permissions`.`start_datetime` < now()) and isnull(`permissions`.`end_datetime`)) or (isnull(`permissions`.`start_datetime`) and (`permissions`.`end_datetime` > now())))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `org_memberships`
--

/*!50001 DROP VIEW IF EXISTS `org_memberships`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50001 VIEW `org_memberships` AS select `om`.`member_id` AS `member_id`,`om`.`org_id` AS `org_id`,`mt`.`type` AS `type`,`mt`.`description` AS `description`,`om`.`start_date` AS `start_date`,`om`.`expiry` AS `expiry`,`mt`.`validates_membership` AS `validates_membership`,`mt`.`revokes_membership` AS `revokes_membership` from (`org_members` `om` left join `member_types` `mt` on((`mt`.`id` = `om`.`member_type_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `pending_memberships`
--

/*!50001 DROP VIEW IF EXISTS `pending_memberships`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50001 VIEW `pending_memberships` AS select distinct `members`.`id` AS `id`,`members`.`date_entered` AS `date_entered`,`members`.`first_name` AS `first_name`,`members`.`middle_name` AS `middle_name`,`members`.`last_name` AS `last_name`,`members`.`DOB` AS `DOB`,`members`.`sex` AS `sex`,`members`.`address1` AS `address1`,`members`.`address2` AS `address2`,`members`.`suburb` AS `suburb`,`members`.`postcode` AS `postcode`,`members`.`state` AS `state`,`members`.`country` AS `country`,`members`.`email` AS `email`,`members`.`phone_home` AS `phone_home`,`members`.`phone_mobile` AS `phone_mobile`,`orgs`.`id` AS `org_id`,`orgs`.`name` AS `org_name`,`member_types`.`id` AS `member_type_id`,`member_types`.`type` AS `member_type` from (((`members` join `orgs`) join `org_members`) join `member_types`) where ((`members`.`id` = `org_members`.`member_id`) and (`org_members`.`org_id` = `orgs`.`id`) and (`org_members`.`member_type_id` = `member_types`.`id`) and (`member_types`.`org_id` = `orgs`.`id`) and (`org_members`.`start_date` < now()) and (`org_members`.`expiry` > now()) and (`member_types`.`validates_membership` = 0) and (`member_types`.`revokes_membership` = 0) and (not(exists(select `current_memberships`.`id` from `current_memberships` where (`current_memberships`.`id` = `members`.`id`)))) and (not(exists(select `org_members`.`member_id` from (`org_members` join `member_types`) where ((`org_members`.`member_type_id` = `member_types`.`id`) and (`org_members`.`member_id` = `members`.`id`) and (`member_types`.`revokes_membership` = 1) and (`member_types`.`validates_membership` = 0) and (((`org_members`.`start_date` < now()) and (`org_members`.`expiry` > now())) or (isnull(`org_members`.`start_date`) and isnull(`org_members`.`expiry`)) or ((`org_members`.`start_date` < now()) and isnull(`org_members`.`expiry`)) or (isnull(`org_members`.`start_date`) and (`org_members`.`expiry` > now())))))))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vendors`
--

/*!50001 DROP VIEW IF EXISTS `vendors`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50001 VIEW `vendors` AS select `orgs`.`id` AS `id`,`orgs`.`name` AS `name`,`orgs`.`founded` AS `founded`,`orgs`.`closed` AS `closed`,`orgs`.`address1` AS `address1`,`orgs`.`address2` AS `address2`,`orgs`.`suburb` AS `suburb`,`orgs`.`postcode` AS `postcode`,`orgs`.`state` AS `state`,`orgs`.`country` AS `country`,`orgs`.`website` AS `website`,`orgs`.`email` AS `email`,`orgs`.`phone` AS `phone`,`orgs`.`fax` AS `fax`,`orgs`.`mobile` AS `mobile`,`orgs`.`description` AS `description` from `orgs` where `orgs`.`id` in (select `org_org_types`.`org_id` from `org_org_types` where (`org_org_types`.`org_type_id` = (select `org_types`.`id` from `org_types` where (`org_types`.`name` = 'Vendor')))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-08-15 11:15:07
