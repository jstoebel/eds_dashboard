-- MySQL dump 10.13  Distrib 5.5.47, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: eds
-- ------------------------------------------------------
-- Server version	5.5.47-0ubuntu0.14.04.1

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
-- Table structure for table `adm_st`
--

DROP TABLE IF EXISTS `adm_st`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adm_st` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Student_Bnum` varchar(9) NOT NULL,
  `BannerTerm_BannerTerm` int(11) DEFAULT NULL,
  `Attempt` int(11) NOT NULL COMMENT 'number of times this student as attempted to apply in this semester.',
  `OverallGPA` float DEFAULT NULL,
  `CoreGPA` float DEFAULT NULL COMMENT 'the combination of grades in the major, collaterals and specalization.',
  `STAdmitted` tinyint(1) DEFAULT NULL,
  `STAdmitDate` datetime DEFAULT NULL,
  `STTerm` int(11) DEFAULT NULL COMMENT 'the term the student will student teach (if accepted)',
  `Notes` text,
  `letter_file_name` varchar(100) DEFAULT NULL,
  `letter_content_type` varchar(100) DEFAULT NULL,
  `letter_file_size` int(11) DEFAULT NULL,
  `letter_updated_at` datetime DEFAULT NULL,
  `background_check` tinyint(1) DEFAULT NULL,
  `beh_train` tinyint(1) DEFAULT NULL,
  `conf_train` tinyint(1) DEFAULT NULL,
  `kfets_in` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_AdmST_Student1_idx` (`Student_Bnum`),
  KEY `fk_AdmST_BannerTerm1_idx` (`BannerTerm_BannerTerm`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Records of students applying to student teach';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `adm_tep`
--

DROP TABLE IF EXISTS `adm_tep`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adm_tep` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Student_Bnum` varchar(9) NOT NULL,
  `Program_ProgCode` varchar(45) NOT NULL,
  `BannerTerm_BannerTerm` int(11) NOT NULL,
  `Attempt` int(11) NOT NULL COMMENT 'number of times this student as attempted to apply in this semester (to this program)',
  `GPA` float DEFAULT NULL,
  `GPA_last30` float DEFAULT NULL,
  `EarnedCredits` int(11) DEFAULT NULL,
  `PortfolioPass` tinyint(1) DEFAULT NULL,
  `TEPAdmit` tinyint(1) DEFAULT NULL,
  `TEPAdmitDate` datetime DEFAULT NULL,
  `Notes` text,
  `letter_file_name` varchar(100) DEFAULT NULL,
  `letter_content_type` varchar(500) DEFAULT NULL,
  `letter_file_size` int(11) DEFAULT NULL,
  `letter_updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_AdmTEP_Student1_idx` (`Student_Bnum`),
  KEY `fk_AdmTEP_Program1_idx` (`Program_ProgCode`),
  KEY `fk_AdmTEP_BannerTerm1_idx` (`BannerTerm_BannerTerm`),
  CONSTRAINT `fk_AdmTEP_Student1` FOREIGN KEY (`Student_Bnum`) REFERENCES `students` (`Bnum`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_AdmTEP_Program1` FOREIGN KEY (`Program_ProgCode`) REFERENCES `programs` (`ProgCode`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_AdmTEP_BannerTerm1` FOREIGN KEY (`BannerTerm_BannerTerm`) REFERENCES `banner_terms` (`BannerTerm`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Records of students applying to TEP';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `advisor_assignments`
--

DROP TABLE IF EXISTS `advisor_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `advisor_assignments` (
  `students_Bnum` varchar(9) NOT NULL,
  `tep_advisors_AdvisorBnum` varchar(9) NOT NULL,
  KEY `fk_students_has_tep_advisors_tep_advisors1_idx` (`tep_advisors_AdvisorBnum`),
  KEY `fk_students_has_tep_advisors_students1_idx` (`students_Bnum`),
  CONSTRAINT `fk_students_has_tep_advisors_students1` FOREIGN KEY (`students_Bnum`) REFERENCES `students` (`Bnum`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_students_has_tep_advisors_tep_advisors1` FOREIGN KEY (`tep_advisors_AdvisorBnum`) REFERENCES `tep_advisors` (`AdvisorBnum`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `alumni_info`
--

DROP TABLE IF EXISTS `alumni_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alumni_info` (
  `AlumniID` varchar(45) NOT NULL COMMENT 'bnum+date',
  `Student_Bnum` varchar(9) NOT NULL,
  `Date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `FirstName` varchar(45) DEFAULT NULL,
  `LastName` varchar(45) DEFAULT NULL,
  `Email` varchar(45) DEFAULT NULL,
  `Phone` varchar(45) DEFAULT NULL,
  `Address1` varchar(45) DEFAULT NULL,
  `Address2` varchar(45) DEFAULT NULL,
  `City` varchar(45) DEFAULT NULL,
  `State` varchar(45) DEFAULT NULL,
  `ZIP` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`AlumniID`),
  KEY `fk_AlumniInfo_Student1_idx` (`Student_Bnum`),
  CONSTRAINT `fk_AlumniInfo_Student1` FOREIGN KEY (`Student_Bnum`) REFERENCES `students` (`Bnum`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `banner_terms`
--

DROP TABLE IF EXISTS `banner_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `banner_terms` (
  `BannerTerm` int(11) NOT NULL,
  `PlainTerm` varchar(45) NOT NULL,
  `StartDate` datetime NOT NULL,
  `EndDate` datetime NOT NULL,
  `AYStart` int(11) NOT NULL,
  PRIMARY KEY (`BannerTerm`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Table of Berea College terms as defined in Banner';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `banner_updates`
--

DROP TABLE IF EXISTS `banner_updates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `banner_updates` (
  `UploadDate` datetime NOT NULL,
  PRIMARY KEY (`UploadDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `clinical_assignments`
--

DROP TABLE IF EXISTS `clinical_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clinical_assignments` (
  `id` varchar(100) NOT NULL COMMENT 'bnum+term+teacher id',
  `Bnum` varchar(9) NOT NULL,
  `clinical_teacher_id` int(11) NOT NULL,
  `Term` int(11) NOT NULL,
  `CourseID` varchar(45) NOT NULL,
  `Level` varchar(45) DEFAULT NULL COMMENT 'Levels (1-4)\n\n#need names of levels#',
  `StartDate` date DEFAULT NULL,
  `EndDate` date DEFAULT NULL,
  `AltID` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  UNIQUE KEY `AltID_UNIQUE` (`AltID`),
  KEY `fk_ClinicalAssignments_Student1_idx` (`Bnum`),
  KEY `fk_ClinicalAssignments_ClinicalTeacher1_idx` (`clinical_teacher_id`),
  CONSTRAINT `fk_ClinicalAssignments_Student1` FOREIGN KEY (`Bnum`) REFERENCES `students` (`Bnum`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ClinicalAssignments_ClinicalTeacher1` FOREIGN KEY (`clinical_teacher_id`) REFERENCES `clinical_teachers` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `clinical_sites`
--

DROP TABLE IF EXISTS `clinical_sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clinical_sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `SiteName` varchar(45) NOT NULL,
  `City` varchar(45) DEFAULT NULL,
  `County` varchar(45) DEFAULT NULL,
  `Principal` varchar(45) DEFAULT NULL,
  `District` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `clinical_teachers`
--

DROP TABLE IF EXISTS `clinical_teachers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clinical_teachers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Bnum` varchar(45) DEFAULT NULL COMMENT 'THIS IS NOT THE PK! Clinical teachers recieve a Bnum if they are paid. This Bnum can concivably be different from their Bnum as an alumni.',
  `FirstName` varchar(45) NOT NULL,
  `LastName` varchar(45) NOT NULL,
  `Email` varchar(45) DEFAULT NULL,
  `Subject` varchar(45) DEFAULT NULL,
  `clinical_site_id` int(11) NOT NULL,
  `Rank` int(11) DEFAULT NULL,
  `YearsExp` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_ClinicalTeacher_ClinicalSite1_idx` (`clinical_site_id`),
  CONSTRAINT `fk_ClinicalTeacher_ClinicalSite1` FOREIGN KEY (`clinical_site_id`) REFERENCES `clinical_sites` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `employment`
--

DROP TABLE IF EXISTS `employment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `employment` (
  `EmpID` varchar(45) NOT NULL COMMENT 'Bnum+date',
  `EmpDate` date NOT NULL,
  `Student_Bnum` varchar(45) NOT NULL,
  `EmpCategory` varchar(45) DEFAULT NULL,
  `Employer` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`EmpID`),
  KEY `fk_Employment_1_idx` (`Student_Bnum`),
  CONSTRAINT `fk_Employment_1` FOREIGN KEY (`Student_Bnum`) REFERENCES `students` (`Bnum`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `exit_codes`
--

DROP TABLE IF EXISTS `exit_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `exit_codes` (
  `ExitCode` varchar(45) NOT NULL,
  `ExitDiscrip` varchar(45) NOT NULL,
  PRIMARY KEY (`ExitCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Reasons for exiting a program as defined by the EPSB';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `forms_of_intention`
--

DROP TABLE IF EXISTS `forms_of_intention`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `forms_of_intention` (
  `FormID` varchar(45) NOT NULL,
  `Student_Bnum` varchar(9) NOT NULL,
  `DateCompleting` varchar(45) NOT NULL,
  `NewForm` tinyint(1) DEFAULT NULL,
  `SeekCert` tinyint(1) DEFAULT NULL,
  `CertArea` varchar(45) DEFAULT NULL COMMENT 'Bnum+date',
  PRIMARY KEY (`FormID`),
  KEY `fk_FormofIntention_Student1_idx` (`Student_Bnum`),
  CONSTRAINT `fk_FormofIntention_Student1` FOREIGN KEY (`Student_Bnum`) REFERENCES `students` (`Bnum`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `issue_updates`
--

DROP TABLE IF EXISTS `issue_updates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `issue_updates` (
  `UpdateID` int(11) NOT NULL AUTO_INCREMENT,
  `CreateDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdateName` varchar(100) NOT NULL,
  `Description` text NOT NULL,
  `Issues_IssueID` int(11) NOT NULL,
  `tep_advisors_AdvisorBnum` varchar(45) NOT NULL,
  PRIMARY KEY (`UpdateID`),
  KEY `fk_IssueUpdates_Issues1_idx` (`Issues_IssueID`),
  KEY `fk_IssueUpdates_tep_advisors1_idx` (`tep_advisors_AdvisorBnum`),
  CONSTRAINT `fk_IssueUpdates_Issues1` FOREIGN KEY (`Issues_IssueID`) REFERENCES `issues` (`IssueID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_IssueUpdates_tep_advisors1` FOREIGN KEY (`tep_advisors_AdvisorBnum`) REFERENCES `tep_advisors` (`AdvisorBnum`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `issues`
--

DROP TABLE IF EXISTS `issues`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `issues` (
  `IssueID` int(11) NOT NULL AUTO_INCREMENT,
  `CreateDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `students_Bnum` varchar(9) NOT NULL,
  `Name` varchar(100) NOT NULL,
  `Description` text NOT NULL,
  `Open` tinyint(1) NOT NULL DEFAULT '1',
  `tep_advisors_AdvisorBnum` varchar(45) NOT NULL,
  PRIMARY KEY (`IssueID`),
  KEY `fk_Issues_students1_idx` (`students_Bnum`),
  KEY `fk_Issues_tep_advisors1_idx` (`tep_advisors_AdvisorBnum`),
  CONSTRAINT `fk_Issues_students1` FOREIGN KEY (`students_Bnum`) REFERENCES `students` (`Bnum`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Issues_tep_advisors1` FOREIGN KEY (`tep_advisors_AdvisorBnum`) REFERENCES `tep_advisors` (`AdvisorBnum`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `praxis_prep`
--

DROP TABLE IF EXISTS `praxis_prep`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `praxis_prep` (
  `TestID` varchar(45) NOT NULL COMMENT 'bnum + test code',
  `Student_Bnum` varchar(9) NOT NULL,
  `PraxisTest_TestCode` varchar(45) NOT NULL,
  `Sub1Name` varchar(45) DEFAULT NULL,
  `Sub1Score` float DEFAULT NULL,
  `Sub2Name` varchar(45) DEFAULT NULL,
  `Sub2Score` float DEFAULT NULL,
  `Sub3Name` varchar(45) DEFAULT NULL,
  `Sub3Score` float DEFAULT NULL,
  `Sub4Name` varchar(45) DEFAULT NULL,
  `Sub4Score` float DEFAULT NULL,
  `Sub5Name` varchar(45) DEFAULT NULL,
  `Sub5Score` float DEFAULT NULL,
  `Sub6Name` varchar(45) DEFAULT NULL,
  `Sub6Score` float DEFAULT NULL,
  `Sub7Name` varchar(45) DEFAULT NULL,
  `Sub7Score` float DEFAULT NULL,
  `TestScore` float DEFAULT NULL,
  `RemediationRequired` tinyint(1) DEFAULT NULL,
  `RemediationComplete` tinyint(1) DEFAULT NULL,
  `Notes` longtext,
  PRIMARY KEY (`TestID`),
  KEY `fk_PraxisPrep_Student1_idx` (`Student_Bnum`),
  KEY `fk_PraxisPrep_PraxisTest1_idx` (`PraxisTest_TestCode`),
  CONSTRAINT `fk_PraxisPrep_Student1` FOREIGN KEY (`Student_Bnum`) REFERENCES `students` (`Bnum`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_PraxisPrep_PraxisTest1` FOREIGN KEY (`PraxisTest_TestCode`) REFERENCES `praxis_tests` (`TestCode`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `praxis_results`
--

DROP TABLE IF EXISTS `praxis_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `praxis_results` (
  `TestID` varchar(45) NOT NULL COMMENT 'Bnum+test code + date',
  `Bnum` varchar(9) NOT NULL,
  `TestCode` varchar(45) NOT NULL,
  `TestDate` datetime DEFAULT NULL,
  `RegDate` datetime DEFAULT NULL,
  `PaidBy` varchar(45) DEFAULT NULL,
  `TestScore` int(11) DEFAULT NULL,
  `BestScore` int(11) DEFAULT NULL,
  `CutScore` int(11) DEFAULT NULL,
  `Pass` tinyint(1) DEFAULT NULL,
  `AltID` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`TestID`),
  UNIQUE KEY `AltID_UNIQUE` (`AltID`),
  KEY `fk_PraxisResult_Student1_idx` (`Bnum`),
  KEY `fk_PraxisResult_PraxisTest1_idx` (`TestCode`),
  CONSTRAINT `fk_PraxisResult_Student1` FOREIGN KEY (`Bnum`) REFERENCES `students` (`Bnum`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_PraxisResult_PraxisTest1` FOREIGN KEY (`TestCode`) REFERENCES `praxis_tests` (`TestCode`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Exam results for Praxis I, Praxis II and PLT';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `praxis_subtest_results`
--

DROP TABLE IF EXISTS `praxis_subtest_results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `praxis_subtest_results` (
  `SubTestID` varchar(45) NOT NULL COMMENT 'composite: Testid and sub number',
  `SubNumber` varchar(45) NOT NULL COMMENT 'composite id: testID + sub test #',
  `praxis_results_TestID` varchar(45) NOT NULL,
  `Name` varchar(45) DEFAULT NULL,
  `PtsEarned` int(11) DEFAULT NULL,
  `PtsAval` int(11) DEFAULT NULL,
  `AvgHigh` int(11) DEFAULT NULL,
  `AvgLow` int(11) DEFAULT NULL,
  PRIMARY KEY (`SubTestID`),
  KEY `fk_praxis_subtest_results_praxis_results1_idx` (`praxis_results_TestID`),
  CONSTRAINT `fk_praxis_subtest_results_praxis_results1` FOREIGN KEY (`praxis_results_TestID`) REFERENCES `praxis_results` (`TestID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `praxis_tests`
--

DROP TABLE IF EXISTS `praxis_tests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `praxis_tests` (
  `TestCode` varchar(45) NOT NULL,
  `TestName` varchar(45) DEFAULT NULL,
  `CutScore` int(11) DEFAULT NULL,
  `TestFamily` varchar(1) DEFAULT NULL COMMENT '''1''=Praxis I\n''2''=Praxis II',
  `Sub1` varchar(100) DEFAULT NULL,
  `Sub2` varchar(100) DEFAULT NULL,
  `Sub3` varchar(100) DEFAULT NULL,
  `Sub4` varchar(100) DEFAULT NULL,
  `Sub5` varchar(100) DEFAULT NULL,
  `Sub6` varchar(100) DEFAULT NULL,
  `Sub7` varchar(45) DEFAULT NULL,
  `Program_ProgCode` varchar(45) DEFAULT NULL COMMENT 'the program this test is related to. Use null for Praxis I',
  `CurrentTest` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`TestCode`),
  KEY `fk_PraxisTest_Program1_idx` (`Program_ProgCode`),
  CONSTRAINT `fk_PraxisTest_Program1` FOREIGN KEY (`Program_ProgCode`) REFERENCES `programs` (`ProgCode`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Listing of all known Praxis exams';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `praxis_updates`
--

DROP TABLE IF EXISTS `praxis_updates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `praxis_updates` (
  `ReportDate` date NOT NULL,
  `UploadDate` datetime NOT NULL,
  PRIMARY KEY (`ReportDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `prog_exits`
--

DROP TABLE IF EXISTS `prog_exits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `prog_exits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Student_Bnum` varchar(9) NOT NULL,
  `Program_ProgCode` varchar(45) NOT NULL,
  `ExitCode_ExitCode` varchar(45) NOT NULL,
  `ExitTerm` int(11) NOT NULL,
  `ExitDate` datetime DEFAULT NULL COMMENT 'Date student exited the program\n\nA student completes the program when they graduate from Berea College having met all requirements for TEP:\n\nRequirements:\nGraduate from BC\nSuccessfully complete ST\nMeet GPA requirement according to 16 KAR 2:010 (2.5 or 3.0 in last 60 hours)\n\n*Passing praxis is not a requirement*',
  `GPA` float DEFAULT NULL,
  `GPA_last60` float DEFAULT NULL,
  `RecommendDate` datetime DEFAULT NULL COMMENT 'The date certification paperwork is submitted for this student in this program',
  `Details` text,
  PRIMARY KEY (`Student_Bnum`,`Program_ProgCode`,`ExitTerm`),
  KEY `fk_Exit_Student1_idx` (`Student_Bnum`),
  KEY `fk_Exit__Program_idx` (`Program_ProgCode`),
  KEY `fk_Exit_ExitCode1_idx` (`ExitCode_ExitCode`),
  KEY `id` (`id`),
  CONSTRAINT `fk_Exit_Student1` FOREIGN KEY (`Student_Bnum`) REFERENCES `students` (`Bnum`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Exit__Program` FOREIGN KEY (`Program_ProgCode`) REFERENCES `programs` (`ProgCode`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Exit_ExitCode1` FOREIGN KEY (`ExitCode_ExitCode`) REFERENCES `exit_codes` (`ExitCode`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Records of students exiting the program for various reasons';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `programs`
--

DROP TABLE IF EXISTS `programs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `programs` (
  `ProgCode` varchar(45) NOT NULL,
  `EPSBProgName` varchar(45) DEFAULT NULL,
  `EDSProgName` varchar(45) DEFAULT NULL,
  `Current` tinyint(1) DEFAULT NULL COMMENT 'if the program is currently offered at Berea College',
  PRIMARY KEY (`ProgCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Listing of all TEP programs, past and present';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `idRoles` int(11) NOT NULL AUTO_INCREMENT,
  `RoleName` varchar(45) NOT NULL,
  PRIMARY KEY (`idRoles`),
  UNIQUE KEY `RoleName_UNIQUE` (`RoleName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Possible roles (user has exactly one)\n\nadmin: access to everything\nadvisor: access to advisee pages\nstaff: access to staff pages\nstu_labor: access to pages granted to student labor pages';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `student_files`
--

DROP TABLE IF EXISTS `student_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `student_files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Student_Bnum` varchar(9) NOT NULL,
  `active` tinyint(1) DEFAULT '1',
  `doc_file_name` varchar(100) DEFAULT NULL,
  `doc_content_type` varchar(100) DEFAULT NULL,
  `doc_file_size` int(11) DEFAULT NULL,
  `doc_updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_student_files_students1_idx` (`Student_Bnum`),
  CONSTRAINT `fk_student_files_students1` FOREIGN KEY (`Student_Bnum`) REFERENCES `students` (`Bnum`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `students` (
  `Bnum` varchar(9) NOT NULL,
  `FirstName` varchar(45) NOT NULL,
  `PreferredFirst` varchar(45) DEFAULT NULL,
  `MiddleName` varchar(45) DEFAULT NULL,
  `LastName` varchar(45) NOT NULL,
  `PrevLast` varchar(45) DEFAULT NULL,
  `ProgStatus` varchar(45) DEFAULT 'Prospective' COMMENT 'Prospective\n	A student who has registered for EDS150 and has NOT indicated they WON''T apply to the TEP.  Note: a student may nt be eligible to apply and still be considerd prospective because this was the last intention we heard from them.\n\nNot applying:\n	A student who has indicated they are NOT interested in applying to the TEP.\n		\nCandidate\n	A student who has applied to the TEP, was admitted and is still persuing certification.\n\nDropped\n	A student who has left the TEP after being admited for any reason other than program completion\n\nCompleter\n	A student who has successfully completed the TEP (graduated, completed student teaching. Praxis II is NOT relevant.)\n',
  `EnrollmentStatus` varchar(45) DEFAULT NULL,
  `Classification` varchar(45) DEFAULT NULL,
  `CurrentMajor1` varchar(45) DEFAULT NULL,
  `CurrentMajor2` varchar(45) DEFAULT NULL,
  `TermMajor` int(11) DEFAULT NULL COMMENT 'I believe this is the term a student declares an EDS major but we need to clarify this.',
  `PraxisICohort` varchar(45) DEFAULT NULL COMMENT 'The Term a student takes the praxis for the first time',
  `PraxisIICohort` varchar(45) DEFAULT NULL COMMENT 'The term a student takes the Praxis II for the first time',
  `CellPhone` varchar(45) DEFAULT NULL,
  `CurrentMinors` varchar(45) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `CPO` varchar(45) DEFAULT NULL,
  `AltID` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`Bnum`),
  UNIQUE KEY `AltID_UNIQUE` (`AltID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Includes all students who\n1) took EDS 150 at some point (even if they withdrew from the course).\n2) were migrated from a legacy database.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tep_advisors`
--

DROP TABLE IF EXISTS `tep_advisors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tep_advisors` (
  `AdvisorBnum` varchar(9) NOT NULL,
  `Salutation` varchar(45) NOT NULL,
  `username` varchar(45) NOT NULL,
  PRIMARY KEY (`AdvisorBnum`),
  UNIQUE KEY `AdvisorBnum_UNIQUE` (`AdvisorBnum`),
  KEY `fk_tep_advisors_users1_idx` (`username`),
  CONSTRAINT `fk_tep_advisors_users1` FOREIGN KEY (`username`) REFERENCES `users` (`UserName`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='All advisors who are activly involved in the TEP programs in some way. Namly: all profs in EDS program and all profs who advise TEP students (ex: music ed profs, PE ed profs, etc).\n\n';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `transcript`
--

DROP TABLE IF EXISTS `transcript`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transcript` (
  `crn` varchar(45) NOT NULL,
  `students_Bnum` varchar(9) NOT NULL,
  `course_code` varchar(45) NOT NULL,
  `course_name` varchar(100) DEFAULT NULL,
  `term_taken` int(11) NOT NULL,
  `grade_pt` float DEFAULT NULL,
  `grade_ltr` varchar(2) DEFAULT NULL,
  `quality_points` float DEFAULT NULL,
  `credits_attempted` float DEFAULT NULL,
  `credits_earned` float DEFAULT NULL,
  `gpa_credits` float DEFAULT NULL,
  `reg_status` varchar(45) DEFAULT NULL,
  `Inst_bnum` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`crn`),
  KEY `fk_transcript_students1_idx` (`students_Bnum`),
  KEY `fk_transcript_banner_terms1_idx` (`term_taken`),
  CONSTRAINT `fk_transcript_students1` FOREIGN KEY (`students_Bnum`) REFERENCES `students` (`Bnum`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_transcript_banner_terms1` FOREIGN KEY (`term_taken`) REFERENCES `banner_terms` (`BannerTerm`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `UserName` varchar(45) NOT NULL,
  `FirstName` varchar(45) NOT NULL,
  `LastName` varchar(45) NOT NULL,
  `Email` varchar(45) NOT NULL,
  `Roles_idRoles` int(11) NOT NULL,
  PRIMARY KEY (`UserName`),
  KEY `fk_users_Roles1_idx` (`Roles_idRoles`),
  CONSTRAINT `fk_users_Roles1` FOREIGN KEY (`Roles_idRoles`) REFERENCES `roles` (`idRoles`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Users of this app.';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-02-09 16:29:41
