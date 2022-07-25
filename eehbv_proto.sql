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
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `column_info`
--

LOCK TABLES `column_info` WRITE;
/*!40000 ALTER TABLE `column_info` DISABLE KEYS */;
INSERT INTO `column_info` VALUES
(1,1,'name','Modell','VARCHAR',1,NULL),
(2,1,'manufacturer','Hersteller','VARCHAR',2,NULL),
(3,1,'n_max','Nom. Drehzahl','DOUBLE',13,'s^-1'),
(28,1,'price','Preis','INT',3,'Euro'),
(29,1,'p_nominal','Nennleistung','DOUBLE',4,'kW'),
(32,1,'p_0_25','P(0;25)','DOUBLE',5,'%'),
(33,1,'p_0_50','P(0;50)','DOUBLE',6,'%'),
(34,1,'p_0_100','P(0;100)','DOUBLE',7,'%'),
(35,1,'p_50_25','P(50;25)','DOUBLE',8,'%'),
(36,1,'p_50_50','P(50;50)','INT',9,'%'),
(37,1,'p_50_100','P(50;100)','DOUBLE',10,'%'),
(38,1,'p_90_50','P(90;50)','DOUBLE',11,'%'),
(39,1,'p_90_100','P(90;100)','DOUBLE',12,'%');
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
  `price` int(11) NOT NULL,
  `p_nominal` double NOT NULL,
  `p_0_25` double NOT NULL,
  `p_0_50` double NOT NULL,
  `p_0_100` double NOT NULL,
  `p_50_25` double NOT NULL,
  `p_50_50` double NOT NULL,
  `p_50_100` double NOT NULL,
  `p_90_50` double NOT NULL,
  `p_90_100` double NOT NULL,
  `n_nominal` double NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `component_motors`
--

LOCK TABLES `component_motors` WRITE;
/*!40000 ALTER TABLE `component_motors` DISABLE KEYS */;
INSERT INTO `component_motors` VALUES
(1,'motor1','ref',500,0.75,9.3,11.7,22.8,12.1,1.5,24.7,19.2,29.5,12000),
(2,'motor2','ref',800,1.1,7.4,9.7,20.5,10,12.3,22.2,16.2,26.3,12000),
(3,'motor3','ref',1200,2.2,5.2,7.2,15.5,7.4,9.4,17.9,12.7,21.4,12000);
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
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_api_name` (`api_name`)
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
-- Table structure for table `loss_functions`
--

DROP TABLE IF EXISTS `loss_functions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `loss_functions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `processes_id` int(11) NOT NULL,
  `func` text NOT NULL,
  `description` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `processes_loss_functions` (`processes_id`),
  CONSTRAINT `processes_loss_functions` FOREIGN KEY (`processes_id`) REFERENCES `processes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loss_functions`
--

LOCK TABLES `loss_functions` WRITE;
/*!40000 ALTER TABLE `loss_functions` DISABLE KEYS */;
INSERT INTO `loss_functions` VALUES
(1,1,'def target_func(param_a, param_b):\r\n    return param_a * param_b','Motorverlust'),
(2,1,'def target_func(param_a, param_b):\r\n    return param_a * param_b * param_b','Wandlerverlust');
/*!40000 ALTER TABLE `loss_functions` ENABLE KEYS */;
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
  `general` tinyint(1) NOT NULL,
  `variable_name` varchar(20) NOT NULL,
  `defaults` varchar(30) NOT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `process_parameters`
--

LOCK TABLES `process_parameters` WRITE;
/*!40000 ALTER TABLE `process_parameters` DISABLE KEYS */;
INSERT INTO `process_parameters` VALUES
(1,1,'Werkstückdicke','mm',0,'p_part_width','',NULL,0,0,NULL,NULL,NULL,NULL),
(2,1,'Werkstücklänge','cm',0,'p_part_length','',NULL,0,0,NULL,NULL,NULL,NULL),
(3,1,'Fräsbreite','mm',0,'p_milling_width','',NULL,0,0,NULL,NULL,NULL,NULL),
(4,1,'Frästiefe','mm',0,'p_milling_depth','',NULL,0,0,NULL,NULL,NULL,NULL),
(5,1,'Spez. Schnittkraft','N/mm^1,5',0,'p_k_c05','',2,0,0,NULL,NULL,NULL,NULL),
(6,1,'Zähne Kappsäge','',1,'p_teeth_clipping','12,16,20',NULL,0,0,NULL,NULL,NULL,NULL);
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
(1,1,'from math import *\r\nimport copy\r\n\r\ncurrent_losses = {}\r\nweighted_losses = {}\r\nindices = {}\r\nopts = []\r\ncost_opts = []\r\n\r\n\r\ndef call_solver(loss_func, model, data):\r\n    # ToDo: as class\r\n    global current_losses, weighted_losses, indices, opts, cost_opts\r\n    # reset -  problematic for several parallel requests\r\n    current_losses = {}\r\n    weighted_losses = {}\r\n    indices = {}\r\n    opts = []\r\n    cost_opts = []\r\n\r\n    components = model[\'components\']\r\n    # ToDo: eval dependent variables!\r\n    update_losses(data, model, {}, loss_func, 0)\r\n    wander_tree(1, model, components, {}, loss_func, data)\r\n    return opts, cost_opts, \'no special remarks\'\r\n\r\n\r\ndef wander_tree(depth, model, components, combination, lfs, data):\r\n    current_comp_type = data[components[0][\'component_api_name\']]\r\n    global indices\r\n#    print(\'wander_tree - \' + str(depth))\r\n    # select new component\r\n    for index, comp in enumerate(current_comp_type):\r\n        var_name = components[0][\'variable_name\']\r\n        indices[var_name] = index\r\n        new_combination = {**combination, var_name: comp}\r\n        if conditions_satisfied(model, new_combination, data):\r\n            update_losses(data, model, new_combination, lfs, depth)\r\n            # recursive decision\r\n            if len(components) > 1:\r\n                new_components = copy.copy(components)\r\n                new_components.pop(0)\r\n                wander_tree(depth + 1, model, new_components, new_combination, lfs, data)\r\n            else:\r\n                summarize_and_check_results(model, new_combination)\r\n\r\n\r\ndef update_losses(data, model, combination, lfs, depth):\r\n    global current_losses\r\n    # unpack variables and previous components\r\n    for general_key in model[\'general_parameters\']:\r\n        exec(general_key + \' = model[\"general_parameters\"][\"\' + general_key + \'\"]\')\r\n    for data_key in data.keys():\r\n        exec(data_key + \' = data[\"\' + data_key + \'\"]\')\r\n    for comb_key in combination.keys():\r\n        exec(comb_key + \' = combination[\"\' + comb_key + \'\"]\')\r\n    for lf_key in lfs.keys():\r\n        exec(\'target_func_\' + str(lf_key) + \' = lfs[\' + str(lf_key) + \']\')\r\n    # eval losses to evaluated after newly selected component\r\n    for lf in model[\'loss_functions\']:\r\n        if lf[\'eval_after_position\'] == depth:\r\n            exec(\'current_losses[\"\' + lf[\'variable_name\'] + \'\"] = []\')  # reset loss list\r\n            for pos in range(len(model[\'process_profiles\'])):\r\n                parameter_set = model[\'process_profiles\'][pos]\r\n                for parameter_key in parameter_set.keys():\r\n                    # exec(parameter_key + \' = parameter_set[\"\' + parameter_key + \'\"]\')\r\n                    exec(parameter_key + \' = model[\"process_profiles\"][\' + str(pos) + \'][\"\' + parameter_key + \'\"]\')\r\n                # unpack previously evaluated losses\r\n                for current_losses_key in current_losses.keys():\r\n                    if current_losses_key != lf[\'variable_name\']:\r\n                        exec(current_losses_key + \' = current_losses[\"\' + current_losses_key + \'\"][\' + str(pos) + \']\')\r\n                # eval current loss\r\n                print(\'EXEC \' + lf[\'variable_name\'] + \' = \' + lf[\'function_call\'])\r\n                exec(lf[\'variable_name\'] + \' = \' + lf[\'function_call\'])\r\n                # ToDo: view group\r\n                # pack current loss for deeper levels\r\n                exec(\'current_losses[\"\' + lf[\'variable_name\'] + \'\"].append(\' + lf[\'variable_name\'] + \')\')\r\n\r\n\r\ndef conditions_satisfied(model, combination, data):\r\n    # noinspection DuplicatedCode\r\n    for data_key in data.keys():\r\n        exec(data_key + \' = data[\"\' + data_key + \'\"]\')\r\n    for comb_key in combination.keys():\r\n        exec(comb_key + \' = combination[\"\' + comb_key + \'\"]\')\r\n    for general_key in model[\'general_parameters\']:\r\n        exec(general_key + \' = model[\"general_parameters\"][\"\' + general_key + \'\"]\')\r\n    global current_losses\r\n    for pos in range(len(model[\'process_profiles\'])):  # conditions have to be fulfilled for all profiles\r\n        for parameter_key in model[\'process_profiles\'][pos].keys():\r\n            exec(parameter_key + \' = model[\"process_profiles\"][\' + str(pos) + \'][\"\' + parameter_key + \'\"]\')\r\n        for current_losses_key in current_losses.keys():\r\n            exec(current_losses_key + \' = current_losses[\"\' + current_losses_key + \'\"][\' + str(pos) + \']\')\r\n        for cond in model[\'conditions\']:\r\n            try:\r\n                result = eval(cond)\r\n                if not result:\r\n                    return False\r\n            except NameError as ex:  # conditions with missing vars have to be evaluated at a deeper level\r\n                print(\'Condition parameter not defined: \' + ex.args[0])\r\n    # ToDo: check implicit conditions\r\n    return True\r\n\r\n\r\ndef summarize_and_check_results(model, combination):\r\n    # new part\r\n    global current_losses\r\n    total = sum_losses(model)\r\n    # costs optimization\r\n    acquisition_costs = update_cost_opts(model, combination, total) if model[\'result_settings\'][\'costs_opt\'][\r\n        \'exec\'] else None\r\n    # sort current combination in optimal solutions\r\n    update_opts(model, total, acquisition_costs)\r\n\r\n\r\ndef sum_losses(model):\r\n    global current_losses\r\n    global weighted_losses\r\n    total = 0\r\n    for current_losses_key in current_losses.keys():\r\n        weighted_losses[current_losses_key] = sum(clk * profile[\'portion\'] for clk, profile\r\n                                                  in zip(current_losses[current_losses_key], model[\'process_profiles\']))\r\n        total += weighted_losses[current_losses_key]\r\n    return total\r\n\r\n\r\ndef update_cost_opts(model, combination, total):\r\n    global cost_opts\r\n    global indices\r\n    acquisition_costs = sum(combination[\'price\']) + model[\'result_settings\'][\'costs_opt\']\r\n    energy_costs = total * model[\'result_settings\'][\'costs_opt\'][\'price_kwh\'] * model[\'result_settings\'][\'costs_opt\'][\r\n        \'amortization_time\']\r\n    inserted = False\r\n    for pos, old_opt in enumerate(cost_opts):\r\n        if old_opt[\'total_costs\'] > acquisition_costs + energy_costs:\r\n            cost_opts.insert(pos, build_cost_opt(model, total, acquisition_costs, energy_costs))\r\n            inserted = True\r\n            if len(cost_opts) > int(model[\'result_settings\'][\'n_list\']):\r\n                cost_opts.pop()\r\n            break\r\n    if len(cost_opts) < int(model[\'result_settings\'][\'n_list\']) and not inserted:\r\n        cost_opts.append(build_cost_opt(model, total, acquisition_costs, energy_costs))\r\n    return acquisition_costs\r\n\r\n\r\ndef build_cost_opt(model, total, acquisition_costs, energy_costs):\r\n    global weighted_losses\r\n    global indices\r\n    return {\'total_costs\': acquisition_costs + energy_costs,\r\n            \'acquisition_costs\': acquisition_costs,\r\n            \'energy_costs\': energy_costs,\r\n            \'total\': total,\r\n            \'partials\': {val[1]: {\'value\': val[0], \'aggregate\': val[2]} for val in\r\n                         partial_generator(model)},\r\n            \'indices\': copy.copy(indices)}\r\n\r\n\r\ndef update_opts(model, total, acquisition_costs):\r\n    global opts\r\n    inserted = False\r\n    for pos, old_opt in enumerate(opts):\r\n        if old_opt[\'total\'] > total:\r\n            opts.insert(pos, build_opt(model, total, acquisition_costs))\r\n            inserted = True\r\n            if len(opts) > int(model[\'result_settings\'][\'n_list\']):\r\n                opts.pop()\r\n            break\r\n    if len(opts) < int(model[\'result_settings\'][\'n_list\']) and not inserted:\r\n        opts.append(build_opt(model, total, acquisition_costs))\r\n\r\n\r\ndef build_opt(model, total, acquisition_costs):\r\n    global weighted_losses\r\n    global indices\r\n    return {\'acquisition_costs\': acquisition_costs,\r\n            \'total\': total,\r\n            \'partials\': {val[1]: {\'value\': val[0], \'aggregate\': val[2]} for val in\r\n                         partial_generator(model)},\r\n            \'indices\': copy.copy(indices)}\r\n\r\n\r\ndef description_and_aggregate_from_variable(model, var):\r\n    function_by_var = next(lf for lf in model[\'loss_functions\'] if lf[\'variable_name\'] == var)\r\n    return [function_by_var[\'description\'], function_by_var[\'aggregate\']]\r\n\r\n\r\ndef partial_generator(model):\r\n    global weighted_losses\r\n    for key in weighted_losses.keys():\r\n        yield [weighted_losses[key]] + description_and_aggregate_from_variable(model, key)\r\n');
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
  KEY `variant_components_api_name` (`component_api_name`),
  CONSTRAINT `variant_components` FOREIGN KEY (`variants_id`) REFERENCES `variants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `variant_components_api_name` FOREIGN KEY (`component_api_name`) REFERENCES `components` (`api_name`) ON DELETE CASCADE ON UPDATE CASCADE
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
(5,15,3,'motors','v_forward_motor','Nebenantriebsmotor');
/*!40000 ALTER TABLE `variant_components` ENABLE KEYS */;
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

--
-- Table structure for table `variants_loss_functions`
--

DROP TABLE IF EXISTS `variants_loss_functions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `variants_loss_functions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `variants_id` int(11) NOT NULL,
  `loss_functions_id` int(11) NOT NULL,
  `parameter_list` text NOT NULL,
  `variable_name` varchar(20) NOT NULL,
  `description` varchar(40) NOT NULL,
  `eval_after_position` int(11) NOT NULL,
  `position` int(11) NOT NULL,
  `aggregate` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `variants_variants_loss_functions` (`variants_id`),
  KEY `loss_functions_variants_loss_functions` (`loss_functions_id`),
  CONSTRAINT `loss_functions_variants_loss_functions` FOREIGN KEY (`loss_functions_id`) REFERENCES `loss_functions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `variants_variants_loss_functions` FOREIGN KEY (`variants_id`) REFERENCES `variants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `variants_loss_functions`
--

LOCK TABLES `variants_loss_functions` WRITE;
/*!40000 ALTER TABLE `variants_loss_functions` DISABLE KEYS */;
INSERT INTO `variants_loss_functions` VALUES
(1,15,1,'(p_part_width, p_part_length)','r_milling_motor_loss','Verlust Fügefräsmotor',1,1,'Fügefräse'),
(2,15,1,'(p_part_width, p_part_length)','r_milling_trans_loss','Verlust Fügefräswandler',3,2,'Fügefräse'),
(3,15,2,'(p_part_width, p_part_length)','r_trim_motor_loss','Verlust Kappmotor',2,3,'Kappaggregat');
/*!40000 ALTER TABLE `variants_loss_functions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-07-25 14:07:54
