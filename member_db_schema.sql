-- MySQL dump 10.13  Distrib 5.6.19, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: memberdb
-- ------------------------------------------------------
-- Server version	5.6.19-0ubuntu0.14.04.1

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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=135 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
-- Table structure for table `members_xxxx`
--

DROP TABLE IF EXISTS `members_xxxx`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `members_xxxx` (
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  CONSTRAINT `org_members_member_id_fkey` FOREIGN KEY (`member_id`) REFERENCES `members` (`id`),
  CONSTRAINT `org_members_member_type_id_fkey` FOREIGN KEY (`member_type_id`) REFERENCES `member_types` (`id`),
  CONSTRAINT `org_members__id_fkey` FOREIGN KEY (`org_id`) REFERENCES `orgs` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  CONSTRAINT `orgs_org_id_fkey` FOREIGN KEY (`org_id`) REFERENCES `orgs` (`id`),
  CONSTRAINT `org_types_id_fkey` FOREIGN KEY (`org_type_id`) REFERENCES `org_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  CONSTRAINT `orgs_relations_org_relation_type_id_fkey` FOREIGN KEY (`org_relation_type_id`) REFERENCES `org_relation_types` (`id`),
  CONSTRAINT `org_relations_org_id_fkey` FOREIGN KEY (`org_id`) REFERENCES `orgs` (`id`),
  CONSTRAINT `org_relations_related_to_org_id_fkey` FOREIGN KEY (`related_to_org_id`) REFERENCES `orgs` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
-- Table structure for table `schema_version`
--

DROP TABLE IF EXISTS `schema_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_version` (
  `version` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

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
 1 AS `description`,
 1 AS `owner_member_id`*/;
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
/*!50001 VIEW `current_memberships` AS select `members`.`id` AS `id`,`members`.`date_entered` AS `date_entered`,`members`.`first_name` AS `first_name`,`members`.`middle_name` AS `middle_name`,`members`.`last_name` AS `last_name`,`members`.`DOB` AS `DOB`,`members`.`sex` AS `sex`,`members`.`address1` AS `address1`,`members`.`address2` AS `address2`,`members`.`suburb` AS `suburb`,`members`.`postcode` AS `postcode`,`members`.`state` AS `state`,`members`.`country` AS `country`,`members`.`email` AS `email`,`members`.`phone_home` AS `phone_home`,`members`.`phone_mobile` AS `phone_mobile`,`orgs`.`id` AS `org_id`,`orgs`.`name` AS `org_name`,`member_types`.`id` AS `member_type_id`,`member_types`.`type` AS `member_type` from (`members` left join ((`orgs` join `org_members`) join `member_types`) on(((`org_members`.`member_id` = `members`.`id`) and (`org_members`.`member_type_id` = `member_types`.`id`) and (`orgs`.`id` = `org_members`.`org_id`)))) where (((`org_members`.`expiry` > now()) or isnull(`org_members`.`expiry`)) and ((`org_members`.`start_date` < now()) or isnull(`org_members`.`start_date`)) and (`member_types`.`validates_membership` = 1) and (not(exists(select `org_members`.`member_id` from (`org_members` left join `member_types` on((`org_members`.`member_type_id` = `member_types`.`id`))) where ((`org_members`.`member_id` = `members`.`id`) and ((`org_members`.`expiry` > now()) or isnull(`org_members`.`expiry`)) and ((`org_members`.`start_date` < now()) or isnull(`org_members`.`start_date`)) and (`member_types`.`revokes_membership` = 1)))))) */;
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
/*!50001 VIEW `vendors` AS select `orgs`.`id` AS `id`,`orgs`.`name` AS `name`,`orgs`.`founded` AS `founded`,`orgs`.`closed` AS `closed`,`orgs`.`address1` AS `address1`,`orgs`.`address2` AS `address2`,`orgs`.`suburb` AS `suburb`,`orgs`.`postcode` AS `postcode`,`orgs`.`state` AS `state`,`orgs`.`country` AS `country`,`orgs`.`website` AS `website`,`orgs`.`email` AS `email`,`orgs`.`phone` AS `phone`,`orgs`.`fax` AS `fax`,`orgs`.`mobile` AS `mobile`,`orgs`.`description` AS `description`,`orgs`.`owner_member_id` AS `owner_member_id` from `orgs` where `orgs`.`id` in (select `org_org_types`.`org_id` from `org_org_types` where (`org_org_types`.`org_type_id` = (select `org_types`.`id` from `org_types` where (`org_types`.`name` = 'Vendor')))) */;
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

-- Dump completed on 2015-08-03 11:51:27
