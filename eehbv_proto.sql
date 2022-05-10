-- MariaDB dump 10.19  Distrib 10.7.3-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: eehbv_proto
-- ------------------------------------------------------
-- Server version	10.7.3-MariaDB-1:10.7.3+maria~focal

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
-- Table structure for table `aggregate_components`
--

DROP TABLE IF EXISTS `aggregate_components`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aggregate_components` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `aggregate_api_name` varchar(30) NOT NULL,
  `component_api_name` varchar(30) NOT NULL,
  `variable_name` varchar(30) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aggregate_components`
--

LOCK TABLES `aggregate_components` WRITE;
/*!40000 ALTER TABLE `aggregate_components` DISABLE KEYS */;
/*!40000 ALTER TABLE `aggregate_components` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `aggregate_parts`
--

DROP TABLE IF EXISTS `aggregate_parts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aggregate_parts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `aggregate_id` int(11) NOT NULL,
  `component_id` int(11) NOT NULL,
  `aggregate_components_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `aggregate_parts_components` (`aggregate_components_id`),
  CONSTRAINT `aggregate_parts_components` FOREIGN KEY (`aggregate_components_id`) REFERENCES `aggregate_components` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aggregate_parts`
--

LOCK TABLES `aggregate_parts` WRITE;
/*!40000 ALTER TABLE `aggregate_parts` DISABLE KEYS */;
/*!40000 ALTER TABLE `aggregate_parts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `aggregate_variables`
--

DROP TABLE IF EXISTS `aggregate_variables`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aggregate_variables` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `api_name` varchar(30) NOT NULL,
  `column_name` varchar(30) NOT NULL,
  `func` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aggregate_variables`
--

LOCK TABLES `aggregate_variables` WRITE;
/*!40000 ALTER TABLE `aggregate_variables` DISABLE KEYS */;
/*!40000 ALTER TABLE `aggregate_variables` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `column_info`
--

DROP TABLE IF EXISTS `column_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `column_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `component_id` int(30) NOT NULL,
  `column_name` varchar(30) NOT NULL,
  `view_name` varchar(40) NOT NULL,
  `type` varchar(7) NOT NULL,
  `position` tinyint(4) NOT NULL,
  `unit` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `component_tables` (`component_id`),
  CONSTRAINT `component_tables` FOREIGN KEY (`component_id`) REFERENCES `components` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `column_info`
--

LOCK TABLES `column_info` WRITE;
/*!40000 ALTER TABLE `column_info` DISABLE KEYS */;
INSERT INTO `column_info` VALUES
(1,1,'name','Modell','VARCHAR',1,NULL),
(2,1,'manufacturer','Hersteller','VARCHAR',2,NULL),
(3,1,'n_max','Max. Drehzahl','DOUBLE',3,'s^-1'),
(4,1,'m_max','Max. Drehmoment','DOUBLE',4,'Nm'),
(5,1,'async','Asynchron','BOOL',5,NULL);
/*!40000 ALTER TABLE `column_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `component_motors`
--

DROP TABLE IF EXISTS `component_motors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `component_motors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(40) NOT NULL,
  `manufacturer` varchar(40) NOT NULL,
  `n_max` double NOT NULL,
  `m_max` double NOT NULL,
  `async` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `component_motors`
--

LOCK TABLES `component_motors` WRITE;
/*!40000 ALTER TABLE `component_motors` DISABLE KEYS */;
INSERT INTO `component_motors` VALUES
(1,'motor1','man1',4000,250,0),
(2,'motor2','man1',4200,230,0),
(3,'motor3','man1',4200,250,0),
(4,'motor4','man2',4200,230,0),
(5,'motor5','man3',4200,230,0),
(6,'motor6','man2',4500,230,0),
(8,'motorX','man2',4200,230,0);
/*!40000 ALTER TABLE `component_motors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `components`
--

DROP TABLE IF EXISTS `components`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `components` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `table_name` varchar(30) NOT NULL,
  `view_name` varchar(30) NOT NULL,
  `api_name` varchar(15) NOT NULL,
  `is_aggregate` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `components`
--

LOCK TABLES `components` WRITE;
/*!40000 ALTER TABLE `components` DISABLE KEYS */;
INSERT INTO `components` VALUES
(1,'component_motors','Motoren','motors',0);
/*!40000 ALTER TABLE `components` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glossary`
--

DROP TABLE IF EXISTS `glossary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glossary` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `term` varchar(60) NOT NULL,
  `text` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glossary`
--

LOCK TABLES `glossary` WRITE;
/*!40000 ALTER TABLE `glossary` DISABLE KEYS */;
INSERT INTO `glossary` VALUES
(1,'Spezifische Schnittkraft','Die Spezifische Zerspankraft k ist die auf den Spanungsquerschnitt A bezogene Zerspankraft F.'),
(2,'Brinellhärte','<b>Härte</b> ist der mechanische Widerstand, den ein Werkstoff der mechanischen Eindringung eines anderen Körpers entgegensetzt. Je nach der Art der Einwirkung unterscheidet man verschiedene Arten von Härte.\r\nDie vom schwedischen Ingenieur Johan August <em>Brinell</em> im Jahre 1900 entwickelte und auf der Weltausstellung in Paris präsentierte Methode der Härteprüfung kommt bei weichen bis mittelharten Metallen (EN ISO 6506-1 bis EN ISO 6506-4) wie zum Beispiel unlegiertem Baustahl, Aluminiumlegierungen, bei Holz (ISO 3350) und bei Werkstoffen mit ungleichmäßigem Gefüge, wie etwa Gusseisen, zur Anwendung. Dabei wird eine Hartmetallkugel mit einer festgelegten Prüfkraft F in die Oberfläche des zu prüfenden Werkstückes gedrückt.'),
(3,'Test','Testtext'),
(4,'Test2','Testtext2'),
(5,'Test3','Testtext 3');
/*!40000 ALTER TABLE `glossary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `glossary_processes`
--

DROP TABLE IF EXISTS `glossary_processes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `glossary_processes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `glossary_id` int(11) NOT NULL,
  `processes_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `glossary_processes_glossary` (`glossary_id`),
  KEY `glossary_processes_process` (`processes_id`),
  CONSTRAINT `glossary_processes_glossary` FOREIGN KEY (`glossary_id`) REFERENCES `glossary` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `glossary_processes_process` FOREIGN KEY (`processes_id`) REFERENCES `processes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `glossary_processes`
--

LOCK TABLES `glossary_processes` WRITE;
/*!40000 ALTER TABLE `glossary_processes` DISABLE KEYS */;
INSERT INTO `glossary_processes` VALUES
(1,1,1),
(2,2,1),
(3,2,2),
(4,3,1),
(5,3,2),
(18,4,2),
(20,5,1),
(21,5,2);
/*!40000 ALTER TABLE `glossary_processes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `info_texts`
--

DROP TABLE IF EXISTS `info_texts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `info_texts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` tinyint(4) NOT NULL,
  `type_id` int(11) NOT NULL,
  `position` tinyint(4) NOT NULL,
  `text` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `info_ref_id` (`type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `info_texts`
--

LOCK TABLES `info_texts` WRITE;
/*!40000 ALTER TABLE `info_texts` DISABLE KEYS */;
INSERT INTO `info_texts` VALUES
(1,1,1,3,'Prozess-spezifischer Infotext für Angabe der Prozessparameter von Kantenanleimmaschinen...'),
(2,1,1,4,'Prozess-spezifischer Infotext für Angabe der Nebenbedingungen von Kantenanleimmaschinen...');
/*!40000 ALTER TABLE `info_texts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `material_properties`
--

DROP TABLE IF EXISTS `material_properties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `material_properties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `property` varchar(40) NOT NULL,
  `unit` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `material_properties`
--

LOCK TABLES `material_properties` WRITE;
/*!40000 ALTER TABLE `material_properties` DISABLE KEYS */;
INSERT INTO `material_properties` VALUES
(1,'Dichte','g/cm^3'),
(2,'Schnittkraftkonstante k_c0,5','N/mm^1,5'),
(7,'Brinellhärte','N/mm^2');
/*!40000 ALTER TABLE `material_properties` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `motorlobs`
--

DROP TABLE IF EXISTS `motorlobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `motorlobs` (
  `motor_id` int(11) NOT NULL,
  `meta` text DEFAULT NULL,
  `profile` blob DEFAULT NULL,
  PRIMARY KEY (`motor_id`),
  CONSTRAINT `motorblob` FOREIGN KEY (`motor_id`) REFERENCES `component_motors` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `motorlobs`
--

LOCK TABLES `motorlobs` WRITE;
/*!40000 ALTER TABLE `motorlobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `motorlobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `process_parameters`
--

DROP TABLE IF EXISTS `process_parameters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `process_parameters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `processes_id` int(11) NOT NULL,
  `name` varchar(30) NOT NULL,
  `unit` varchar(15) NOT NULL,
  `variable_name` varchar(20) NOT NULL,
  `material_properties_id` int(11) DEFAULT NULL,
  `restricting` tinyint(1) NOT NULL,
  `dependent` tinyint(1) NOT NULL,
  `derived_parameter` varchar(20) DEFAULT NULL,
  `min_column` varchar(40) DEFAULT NULL,
  `max_column` varchar(40) DEFAULT NULL,
  `dependency` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `processes_parameters` (`processes_id`),
  KEY `process_parameters_properties` (`material_properties_id`),
  CONSTRAINT `process_parameters_properties` FOREIGN KEY (`material_properties_id`) REFERENCES `material_properties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `processes_parameters` FOREIGN KEY (`processes_id`) REFERENCES `processes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `process_parameters`
--

LOCK TABLES `process_parameters` WRITE;
/*!40000 ALTER TABLE `process_parameters` DISABLE KEYS */;
INSERT INTO `process_parameters` VALUES
(1,1,'Werkstückdicke','mm','p_part_width',NULL,0,0,NULL,NULL,NULL,NULL),
(2,1,'Werkstücklänge','cm','p_part_length',NULL,0,0,NULL,NULL,NULL,NULL),
(3,1,'Fräsbreite','mm','p_milling_width',NULL,0,0,NULL,NULL,NULL,NULL),
(4,1,'Frästiefe','mm','p_milling_depth',NULL,0,0,NULL,NULL,NULL,NULL),
(5,1,'Spez. Schnittkraft','N/mm^1,5','p_k_c05',2,0,0,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `process_parameters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `process_solvers`
--

DROP TABLE IF EXISTS `process_solvers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `process_solvers` (
  `id` int(11) NOT NULL,
  `processes_id` int(11) NOT NULL,
  `code` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `processes_processsolvers` (`processes_id`),
  CONSTRAINT `processes_processsolvers` FOREIGN KEY (`processes_id`) REFERENCES `processes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `process_solvers`
--

LOCK TABLES `process_solvers` WRITE;
/*!40000 ALTER TABLE `process_solvers` DISABLE KEYS */;
INSERT INTO `process_solvers` VALUES
(1,1,'from math import *\r\nimport copy\r\n\r\n\r\nindices = {}\r\nopt_indices = {}\r\nopt_value = -1\r\n\r\n\r\ndef call_solver(target_func, tf_sig, model, data):\r\n    # sorting: occurrence of component properties in conditions can lead to earlier termination of solution branch\r\n    components = sorted(model[\'components\'], key=sort_components_by_conditions(model[\'conditions\']), reverse=True)\r\n    wander_tree(model, components, {}, target_func, tf_sig, data)\r\n    print(\'OPT\')\r\n    print(opt_indices)\r\n    print(opt_value)\r\n    return opt_indices, opt_value, \'no special remarks\'\r\n\r\n\r\ndef wander_tree(model, components, combination, tf, tf_sig, data):\r\n    current_comp_type = data[components[0][\'component_api_name\']]\r\n    global indices\r\n    for index, comp in enumerate(current_comp_type):\r\n        var_name = components[0][\'variable_name\']\r\n        indices[var_name] = index\r\n        new_combination = {**combination, var_name: comp}\r\n        if conditions_satisfied(model, new_combination, data):\r\n            if len(components) > 1:\r\n                new_components = copy.copy(components)\r\n                new_components.pop(0)\r\n                wander_tree(model, new_components, new_combination, tf, tf_sig, data)\r\n            else:\r\n                eval_target_func(model, new_combination, tf, tf_sig, data)\r\n\r\n\r\ndef conditions_satisfied(model, combination, data):\r\n    for data_key in data.keys():\r\n        exec(data_key + \' = data[\"\' + data_key + \'\"]\')\r\n    for comb_key in combination.keys():\r\n        exec(comb_key + \' = combination[\"\' + comb_key + \'\"]\')\r\n    for parameter_set in model[\'process_parameters\']:\r\n        for parameter_key in parameter_set.keys():\r\n            exec(parameter_key + \' = parameter_set[\"\' + parameter_key + \'\"]\')\r\n        for cond in model[\'conditions\']:\r\n            try:\r\n                result = eval(cond)\r\n                if not result:\r\n                    return False\r\n            except NameError as ex:     # conditions with missing vars have to be evaluated at a deeper level\r\n                print(\'Condition parameter not defined: \' + ex.args[0])\r\n    # ToDo: check implicit conditions\r\n    return True\r\n\r\n\r\ndef eval_target_func(model, combination, target_func, tf_sig, data):\r\n    for data_key in data.keys():\r\n        exec(data_key + \' = data[\"\' + data_key + \'\"]\')\r\n    for comb_key in combination.keys():\r\n        exec(comb_key + \' = combination[\"\' + comb_key + \'\"]\')\r\n    global opt_value\r\n    global opt_indices\r\n    global indices\r\n    val = [0]\r\n    weight_sum = [0]\r\n    for parameter_set in model[\'process_parameters\']:\r\n        for pp in parameter_set.keys():\r\n            exec(pp + \' = parameter_set[\"\' + pp + \'\"]\')\r\n        exec(\'weight_sum[0] = weight_sum[0] + portion\')\r\n        exec(\'val[0] = val[0] + portion * \' + tf_sig)\r\n    val[0] = val[0] / weight_sum[0]\r\n    if val[0] > -1 and (val[0] < opt_value or opt_value == -1):\r\n        opt_value = val[0]\r\n        opt_indices = {**indices}\r\n\r\n\r\ndef sort_components_by_conditions(conditions):\r\n    def count_component_occurrence_in_conditions(comp, cond=conditions):\r\n        count = 0\r\n        for c in cond:\r\n            tokens = c.replace(\'[\', \' \').split()\r\n            for token in tokens:\r\n                if comp[\'variable_name\'] == token:\r\n                    count += 1\r\n        return count\r\n    return count_component_occurrence_in_conditions\r\n');
/*!40000 ALTER TABLE `process_solvers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `processes`
--

DROP TABLE IF EXISTS `processes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `processes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `view_name` varchar(40) NOT NULL,
  `api_name` varchar(30) NOT NULL,
  `variant_tree` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `processes`
--

LOCK TABLES `processes` WRITE;
/*!40000 ALTER TABLE `processes` DISABLE KEYS */;
INSERT INTO `processes` VALUES
(1,'Kantenanleimmaschine','edge_banding',1),
(2,'Dummy-Prozess','dummy',0);
/*!40000 ALTER TABLE `processes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `property_values`
--

DROP TABLE IF EXISTS `property_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `property_values` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `material_properties_id` int(11) NOT NULL,
  `value` double NOT NULL,
  `material` varchar(40) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `properties_values` (`material_properties_id`),
  CONSTRAINT `properties_values` FOREIGN KEY (`material_properties_id`) REFERENCES `material_properties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `property_values`
--

LOCK TABLES `property_values` WRITE;
/*!40000 ALTER TABLE `property_values` DISABLE KEYS */;
INSERT INTO `property_values` VALUES
(1,2,22.5,'MDF'),
(2,2,15,'Spanplatte'),
(3,2,33,'Buche'),
(4,2,33,'Eiche'),
(5,1,0.68,'Buche'),
(6,1,0.65,'Eiche'),
(8,7,34,'Buche'),
(11,7,34,'Eiche');
/*!40000 ALTER TABLE `property_values` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role` varchar(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES
(1,'data'),
(2,'opt'),
(3,'admin');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tree_questions`
--

DROP TABLE IF EXISTS `tree_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `parent_response` tinyint(1) NOT NULL,
  `variant_questions_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tree_variant_questions` (`variant_questions_id`),
  CONSTRAINT `tree_variant_questions` FOREIGN KEY (`variant_questions_id`) REFERENCES `variant_questions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tree_questions`
--

LOCK TABLES `tree_questions` WRITE;
/*!40000 ALTER TABLE `tree_questions` DISABLE KEYS */;
INSERT INTO `tree_questions` VALUES
(4,NULL,0,1),
(5,4,1,2),
(6,4,0,3),
(7,5,1,4),
(8,6,1,4),
(9,6,0,4),
(10,5,0,5),
(11,10,1,6),
(12,11,1,7),
(13,12,0,9),
(14,11,0,8),
(15,14,0,7),
(16,10,0,6),
(17,16,1,8),
(18,17,0,9),
(19,16,0,3),
(20,19,0,4),
(21,19,1,4),
(22,21,1,8),
(23,22,0,7),
(24,21,0,10);
/*!40000 ALTER TABLE `tree_questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(20) NOT NULL,
  `password_hash` varchar(100) NOT NULL,
  `role` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `users_role` (`role`),
  CONSTRAINT `users_role` FOREIGN KEY (`role`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES
(1,'admin','pbkdf2:sha256:150000$0d1YxUHK$1828d59860ed572d79ea16f33a6155b35a906affede33336542db332eb833c3f',3),
(2,'user','pbkdf2:sha256:150000$tcDN0hyg$d35c532d6a6f0109d88245759e36532dc8813faf994a9d17fbad336a863f0309',1),
(3,'Markus','pbkdf2:sha256:150000$l7UAAUGj$90703a7eb8e9433f167ff44789515951d73179df8add124207cf1d817604cf29',3),
(4,'user2','pbkdf2:sha256:150000$DUJ2UdyH$4d75142dffbecee806acd8be5d6b91be2199524d9b2bbc694c85994e3bd21722',2);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `variant_components`
--

DROP TABLE IF EXISTS `variant_components`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `variant_components` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `variants_id` int(11) NOT NULL,
  `position` tinyint(3) unsigned NOT NULL,
  `component_api_name` varchar(40) NOT NULL,
  `variable_name` varchar(30) NOT NULL,
  `description` varchar(40) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `variant_components_variants` (`variants_id`),
  CONSTRAINT `variant_components` FOREIGN KEY (`variants_id`) REFERENCES `variants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `variant_components`
--

LOCK TABLES `variant_components` WRITE;
/*!40000 ALTER TABLE `variant_components` DISABLE KEYS */;
INSERT INTO `variant_components` VALUES
(1,15,1,'motors','v_milling_motor','Fräsermotor'),
(2,15,2,'motors','v_flush_motor','Bündigfräsermotor'),
(5,15,3,'gears','v_milling_gear','Fräsergetriebe');
/*!40000 ALTER TABLE `variant_components` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `variant_excludes`
--

DROP TABLE IF EXISTS `variant_excludes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `variant_excludes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `variants_id` int(11) NOT NULL,
  `response` tinyint(1) NOT NULL,
  `processes_id` int(11) NOT NULL,
  `tree_questions_id` int(11) DEFAULT NULL,
  `variant_questions_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `excludes_processes_id` (`processes_id`),
  KEY `excludes_variants_id` (`variants_id`)
) ENGINE=InnoDB AUTO_INCREMENT=123 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `variant_excludes`
--

LOCK TABLES `variant_excludes` WRITE;
/*!40000 ALTER TABLE `variant_excludes` DISABLE KEYS */;
INSERT INTO `variant_excludes` VALUES
(1,1,1,1,4,NULL),
(3,2,1,1,4,NULL),
(4,3,1,1,4,NULL),
(5,4,1,1,4,NULL),
(6,5,0,1,4,NULL),
(7,6,0,1,4,NULL),
(8,7,0,1,4,NULL),
(9,8,0,1,4,NULL),
(10,9,0,1,4,NULL),
(11,11,0,1,4,NULL),
(12,12,0,1,4,NULL),
(13,13,0,1,4,NULL),
(14,14,0,1,4,NULL),
(15,15,0,1,4,NULL),
(16,16,0,1,4,NULL),
(17,17,0,1,4,NULL),
(18,18,0,1,4,NULL),
(19,19,0,1,4,NULL),
(20,20,0,1,4,NULL),
(21,21,0,1,4,NULL),
(22,22,0,1,4,NULL),
(23,23,0,1,4,NULL),
(24,1,1,1,6,NULL),
(25,2,1,1,6,NULL),
(26,3,0,1,6,NULL),
(27,4,0,1,6,NULL),
(28,3,1,1,8,NULL),
(29,4,0,1,8,NULL),
(30,2,1,1,9,NULL),
(31,1,0,1,9,NULL),
(32,5,0,1,5,NULL),
(33,6,0,1,5,NULL),
(34,7,1,1,5,NULL),
(35,8,1,1,5,NULL),
(36,9,1,1,5,NULL),
(37,11,1,1,5,NULL),
(38,12,1,1,5,NULL),
(39,13,1,1,5,NULL),
(40,14,1,1,5,NULL),
(41,15,1,1,5,NULL),
(42,16,1,1,5,NULL),
(43,17,1,1,5,NULL),
(44,18,1,1,5,NULL),
(45,19,1,1,5,NULL),
(46,20,1,1,5,NULL),
(47,21,1,1,5,NULL),
(48,22,1,1,5,NULL),
(49,23,1,1,5,NULL),
(50,5,1,1,7,NULL),
(51,6,0,1,7,NULL),
(52,18,0,1,10,NULL),
(53,19,0,1,10,NULL),
(54,20,0,1,10,NULL),
(55,21,0,1,10,NULL),
(56,22,0,1,10,NULL),
(57,23,0,1,10,NULL),
(58,7,1,1,10,NULL),
(59,8,1,1,10,NULL),
(60,9,1,1,10,NULL),
(61,11,1,1,10,NULL),
(62,12,1,1,10,NULL),
(63,13,1,1,10,NULL),
(64,14,1,1,10,NULL),
(65,15,1,1,10,NULL),
(66,16,1,1,10,NULL),
(67,17,1,1,10,NULL),
(68,18,1,1,11,NULL),
(69,19,1,1,11,NULL),
(70,20,1,1,11,NULL),
(71,21,0,1,11,NULL),
(72,22,0,1,11,NULL),
(73,23,0,1,11,NULL),
(74,21,1,1,12,NULL),
(75,22,1,1,12,NULL),
(76,23,0,1,12,NULL),
(77,21,1,1,13,NULL),
(78,22,0,1,13,NULL),
(79,18,1,1,14,NULL),
(80,19,1,1,14,NULL),
(81,20,0,1,14,NULL),
(82,18,1,1,15,NULL),
(83,19,0,1,15,NULL),
(84,7,1,1,16,NULL),
(85,8,1,1,16,NULL),
(86,9,1,1,16,NULL),
(87,11,1,1,16,NULL),
(88,12,1,1,16,NULL),
(89,13,1,1,16,NULL),
(90,14,1,1,16,NULL),
(91,15,0,1,16,NULL),
(92,16,0,1,16,NULL),
(93,17,0,1,16,NULL),
(94,15,1,1,17,NULL),
(95,16,1,1,17,NULL),
(96,17,0,1,17,NULL),
(97,15,1,1,18,NULL),
(98,16,0,1,18,NULL),
(99,7,1,1,19,NULL),
(100,8,1,1,19,NULL),
(101,9,0,1,19,NULL),
(102,11,0,1,19,NULL),
(103,12,0,1,10,NULL),
(104,13,0,1,19,NULL),
(105,14,0,1,19,NULL),
(106,7,1,1,20,NULL),
(107,8,0,1,20,NULL),
(108,9,1,1,21,NULL),
(109,11,1,1,21,NULL),
(110,12,0,1,21,NULL),
(111,13,0,1,21,NULL),
(112,14,0,1,21,NULL),
(113,15,0,1,21,NULL),
(114,16,0,1,21,NULL),
(115,17,0,1,21,NULL),
(116,9,1,1,24,NULL),
(117,11,0,1,24,NULL),
(118,12,1,1,22,NULL),
(119,14,1,1,22,NULL),
(120,13,0,1,21,NULL),
(121,12,1,1,23,NULL),
(122,14,0,1,23,NULL);
/*!40000 ALTER TABLE `variant_excludes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `variant_questions`
--

DROP TABLE IF EXISTS `variant_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `variant_questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `processes_id` int(11) NOT NULL,
  `question` tinytext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `variant_question_processes` (`processes_id`),
  CONSTRAINT `variant_question_processes` FOREIGN KEY (`processes_id`) REFERENCES `processes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `variant_questions`
--

LOCK TABLES `variant_questions` WRITE;
/*!40000 ALTER TABLE `variant_questions` DISABLE KEYS */;
INSERT INTO `variant_questions` VALUES
(1,1,'Fügefräsen?'),
(2,1,'Heißluft?'),
(3,1,'Eckenkopieren?'),
(4,1,'Leimfugenziehen?'),
(5,1,'Laser?'),
(6,1,'Bündigfräsen?'),
(7,1,'Nutfräsen?'),
(8,1,'Eckschwabbeln?'),
(9,1,'Universalfräsen?'),
(10,1,'Schwabbeln?');
/*!40000 ALTER TABLE `variant_questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `variant_selection`
--

DROP TABLE IF EXISTS `variant_selection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `variant_selection` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `processes_id` int(11) NOT NULL,
  `selection` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`selection`)),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `variant_selection`
--

LOCK TABLES `variant_selection` WRITE;
/*!40000 ALTER TABLE `variant_selection` DISABLE KEYS */;
INSERT INTO `variant_selection` VALUES
(1,1,'{\"list\": [], \"tree\": {\"no\": {\"excludes\": [5, 6, 7, 8, 9, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23], \"no\": {\"excludes\": [3, 4], \"no\": {\"excludes\": [1], \"no\": null, \"question\": null, \"yes\": null}, \"question\": \"Leimfugenziehen?\", \"yes\": {\"excludes\": [2], \"no\": null, \"question\": null, \"yes\": null}}, \"question\": \"Eckenkopieren?\", \"yes\": {\"excludes\": [1, 2], \"no\": {\"excludes\": [4], \"no\": null, \"question\": null, \"yes\": null}, \"question\": \"Leimfugenziehen?\", \"yes\": {\"excludes\": [3], \"no\": null, \"question\": null, \"yes\": null}}}, \"question\": \"F\\u00fcgefr\\u00e4sen?\", \"yes\": {\"excludes\": [1, 2, 3, 4], \"no\": {\"excludes\": [5, 6], \"no\": {\"excludes\": [18, 19, 20, 21, 22, 23, 12], \"no\": {\"excludes\": [15, 16, 17], \"no\": {\"excludes\": [9, 11, 13, 14], \"no\": {\"excludes\": [8], \"no\": null, \"question\": null, \"yes\": null}, \"question\": \"Leimfugenziehen?\", \"yes\": {\"excludes\": [7], \"no\": null, \"question\": null, \"yes\": null}}, \"question\": \"Eckenkopieren?\", \"yes\": {\"excludes\": [7, 8], \"no\": {\"excludes\": [12, 13, 14, 15, 16, 17, 13], \"no\": {\"excludes\": [11], \"no\": null, \"question\": null, \"yes\": null}, \"question\": \"Schwabbeln?\", \"yes\": {\"excludes\": [9], \"no\": null, \"question\": null, \"yes\": null}}, \"question\": \"Leimfugenziehen?\", \"yes\": {\"excludes\": [9, 11], \"no\": {\"excludes\": [], \"no\": {\"excludes\": [14], \"no\": null, \"question\": null, \"yes\": null}, \"question\": \"Nutfr\\u00e4sen?\", \"yes\": {\"excludes\": [12], \"no\": null, \"question\": null, \"yes\": null}}, \"question\": \"Eckschwabbeln?\", \"yes\": {\"excludes\": [12, 14], \"no\": null, \"question\": null, \"yes\": null}}}}, \"question\": \"B\\u00fcndigfr\\u00e4sen?\", \"yes\": {\"excludes\": [7, 8, 9, 11, 12, 13, 14], \"no\": {\"excludes\": [17], \"no\": {\"excludes\": [16], \"no\": null, \"question\": null, \"yes\": null}, \"question\": \"Universalfr\\u00e4sen?\", \"yes\": {\"excludes\": [15], \"no\": null, \"question\": null, \"yes\": null}}, \"question\": \"Eckschwabbeln?\", \"yes\": {\"excludes\": [15, 16], \"no\": null, \"question\": null, \"yes\": null}}}, \"question\": \"Laser?\", \"yes\": {\"excludes\": [7, 8, 9, 11, 12, 13, 14, 15, 16, 17], \"no\": {\"excludes\": [21, 22, 23], \"no\": {\"excludes\": [20], \"no\": {\"excludes\": [19], \"no\": null, \"question\": null, \"yes\": null}, \"question\": \"Nutfr\\u00e4sen?\", \"yes\": {\"excludes\": [18], \"no\": null, \"question\": null, \"yes\": null}}, \"question\": \"Eckschwabbeln?\", \"yes\": {\"excludes\": [18, 19], \"no\": null, \"question\": null, \"yes\": null}}, \"question\": \"B\\u00fcndigfr\\u00e4sen?\", \"yes\": {\"excludes\": [18, 19, 20], \"no\": {\"excludes\": [23], \"no\": {\"excludes\": [22], \"no\": null, \"question\": null, \"yes\": null}, \"question\": \"Universalfr\\u00e4sen?\", \"yes\": {\"excludes\": [21], \"no\": null, \"question\": null, \"yes\": null}}, \"question\": \"Nutfr\\u00e4sen?\", \"yes\": {\"excludes\": [21, 22], \"no\": null, \"question\": null, \"yes\": null}}}}, \"question\": \"Hei\\u00dfluft?\", \"yes\": {\"excludes\": [7, 8, 9, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23], \"no\": {\"excludes\": [6], \"no\": null, \"question\": null, \"yes\": null}, \"question\": \"Leimfugenziehen?\", \"yes\": {\"excludes\": [5], \"no\": null, \"question\": null, \"yes\": null}}}}}');
/*!40000 ALTER TABLE `variant_selection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `variants`
--

DROP TABLE IF EXISTS `variants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `variants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `processes_id` int(11) NOT NULL,
  `name` tinytext NOT NULL,
  `target_func` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `variants_process` (`processes_id`),
  CONSTRAINT `variants_processes` FOREIGN KEY (`processes_id`) REFERENCES `processes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `variants`
--

LOCK TABLES `variants` WRITE;
/*!40000 ALTER TABLE `variants` DISABLE KEYS */;
INSERT INTO `variants` VALUES
(1,1,'Leim mit Fugenziehen',''),
(2,1,'Leim',''),
(3,1,'Leim mit Schwabbel',''),
(4,1,'Leim mit Fugenziehen und Schwabbel',''),
(5,1,'Heißluft',''),
(6,1,'Heißluft mit Fugenziehen',''),
(7,1,'Fügefraser, Leim',''),
(8,1,'Fügefraser, Leim mit Schwabbel',''),
(9,1,'Fügefraser, Leim mit Eckenkopierer',''),
(11,1,'Fügefraser, Leim mit Eckenkopierer und Schwabbel',''),
(12,1,'Fügefraser, Leim mit Eckenkopierer, Ziehklinge und Schwabbel',''),
(13,1,'Fügefraser, Leim mit Eckenkopierer, Ziehklinge und Eck-/Schwabbel',''),
(14,1,'Fügefraser, Leim mit Eckenkopierer, Ziehklinge, Schwabbel und Nutfräse',''),
(15,1,'Fügefraser, Leim mit Eckenkopierer, Bündigfräser','def noise(v):\r\n    print(\'Variant 15 - noise\')\r\n    print(v)\r\n\r\ndef target_func(p_milling_width):\r\n    v = p_milling_width * p_milling_width\r\n    # noise(v)\r\n    return v\r\n'),
(16,1,'Fügefraser, Leim mit Eckenkopierer, Bündig- und Universalfräser',''),
(17,1,'Fügefraser, Leim mit Eckenkopierer, Bündigfräser und Eckschwabbel',''),
(18,1,'Laser',''),
(19,1,'Laser mit Nutfräse',''),
(20,1,'Laser mit Eckschwabbel',''),
(21,1,'Laser mit Bündigfräser',''),
(22,1,'Laser mit Bündig- und Universalfräser',''),
(23,1,'Laser mit Bündigfräser und Eckschwabbel','');
/*!40000 ALTER TABLE `variants` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-05-03 12:56:08
