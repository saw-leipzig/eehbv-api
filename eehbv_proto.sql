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
) ENGINE=InnoDB AUTO_INCREMENT=124 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `column_info`
--

LOCK TABLES `column_info` WRITE;
/*!40000 ALTER TABLE `column_info` DISABLE KEYS */;
INSERT INTO `column_info` VALUES
(1,1,'name','Modell','VARCHAR',1,NULL),
(2,1,'manufacturer','Hersteller','VARCHAR',2,NULL),
(3,1,'n_nominal','Nenndrehzahl','DOUBLE',6,'1/min'),
(28,1,'price','Preis','INT',3,'Euro'),
(29,1,'p_nominal','Nennleistung','DOUBLE',4,'W'),
(32,1,'m_nominal','Nenndrehmoment','DOUBLE',5,'Nm'),
(33,1,'coeff_a','Koeff. A','DOUBLE',7,''),
(34,1,'coeff_b','Koeff. B','DOUBLE',8,''),
(35,1,'coeff_c','Koeff. C','DOUBLE',9,''),
(36,1,'coeff_d','Koeff. D','INT',10,''),
(37,1,'coeff_e','Koeff. E','DOUBLE',11,''),
(38,1,'coeff_f','Koeff. F','DOUBLE',12,''),
(39,1,'coeff_g','Koeff. G','DOUBLE',13,''),
(100,26,'name','Modell','VARCHAR',1,NULL),
(101,26,'manufacturer','Hersteller','VARCHAR',2,NULL),
(102,26,'price','Preis','DOUBLE',2,'Euro'),
(103,26,'p_r_m','P(r,M)','DOUBLE',4,'kW'),
(104,26,'s_r_equ','S(r,equ)','DOUBLE',5,'kVA'),
(105,26,'p_0_25','P(0;25)','DOUBLE',6,''),
(106,26,'p_0_50','P(0;50)','DOUBLE',7,''),
(107,26,'p_0_100','P(0;100)','DOUBLE',8,''),
(108,26,'p_50_25','P(50;25)','DOUBLE',9,''),
(109,26,'p_50_50','P(50;50)','DOUBLE',10,''),
(110,26,'p_50_100','P(50;100)','DOUBLE',11,''),
(111,26,'p_90_50','P(90;50)','DOUBLE',12,''),
(112,26,'p_90_100','P(90;100)','DOUBLE',13,''),
(117,28,'name','Modell','VARCHAR',1,NULL),
(118,28,'manufacturer','Hersteller','VARCHAR',2,NULL),
(119,28,'price','Preis','DOUBLE',2,'Euro'),
(120,28,'efficiency','Wirkungsgrad','DOUBLE',4,''),
(121,28,'m_nominal','Nennmoment','DOUBLE',5,'Nm'),
(122,28,'gear_ratio','Übersetzung','DOUBLE',6,''),
(123,26,'f_nominal','Nennfrequenz','DOUBLE',14,'Hz');
/*!40000 ALTER TABLE `column_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `component_gears`
--

DROP TABLE IF EXISTS `component_gears`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `component_gears` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(40) DEFAULT NULL,
  `manufacturer` varchar(40) DEFAULT NULL,
  `price` float DEFAULT NULL,
  `efficiency` float DEFAULT NULL,
  `m_nominal` float DEFAULT NULL,
  `gear_ratio` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `component_gears`
--

LOCK TABLES `component_gears` WRITE;
/*!40000 ALTER TABLE `component_gears` DISABLE KEYS */;
INSERT INTO `component_gears` VALUES
(1,'verbaut','Homag',120,0.9,46.62,10);
/*!40000 ALTER TABLE `component_gears` ENABLE KEYS */;
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
  `m_nominal` double NOT NULL,
  `n_nominal` double NOT NULL,
  `coeff_a` double NOT NULL,
  `coeff_b` double NOT NULL,
  `coeff_c` double NOT NULL,
  `coeff_d` double NOT NULL,
  `coeff_e` double NOT NULL,
  `coeff_f` double NOT NULL,
  `coeff_g` double NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `component_motors`
--

LOCK TABLES `component_motors` WRITE;
/*!40000 ALTER TABLE `component_motors` DISABLE KEYS */;
INSERT INTO `component_motors` VALUES
(21,'motor1','gen7',7577,7500,6.23113984459092,11493.84,0.0202325398117543,-0.0156096978894997,0.0404601993378447,-0.015510646269561,0.010110022184825,-0.0023796343824729,0.0700912619921917),
(22,'motor2','gen7',7526,7500,6.23602282586026,11484.84,0.0392346473716156,-0.0214305403768178,0.0609489259441487,-0.0454075743637984,0.0297579557559659,-0.0078363099912677,0.0995994151199501),
(23,'motor3','gen7',7533,7500,6.24757706055278,11463.6,0.0194259930546377,-0.0165705076651098,0.042568145614255,-0.0188089218565073,0.012229028990959,-0.0027083003078223,0.0759541049422321),
(24,'motor4','gen7',4003,4000,3.26575512402703,11696.28,0.0230810384795087,-0.0062116197399769,0.0223124835766566,-0.0104118824659417,0.0064939686905098,-0.0024431003692712,0.0486780828843823),
(25,'motor5','gen7',4046,4000,3.26598967991413,11695.44,0.0266266420141421,-0.0064873904428387,0.0237626120571422,-0.0128870848407639,0.0080643426408413,-0.0031612384125787,0.0524444263811558),
(26,'motor6','gen7',4012,4000,3.26625778504516,11694.48,0.0310728470126845,-0.0067085989567416,0.0258370733342406,-0.0164562860238821,0.010354077349856,-0.0041958291358392,0.057443637413766),
(27,'motor7','gen7',4001,4000,3.39700848621486,11244.36,0.0242336769804643,-0.0172709465597949,0.0475214879501727,-0.0422510319929268,0.0271264809378502,-0.0055657007480559,0.116530236797089),
(28,'motor8','gen7',4073,4000,3.39791505138657,11241.36,0.0276860841435004,-0.0178468125312096,0.0504164443604659,-0.0530059024561394,0.0340420409900153,-0.0070347602235718,0.125210898760892),
(29,'motor9','gen7',4090,4000,3.39914875682148,11237.28,0.0319864595034306,-0.0183598623721544,0.0543101789397731,-0.0687023830819245,0.0442165469745578,-0.0091101047682743,0.137120600756021),
(30,'motor10','gen7',4095,4000,3.39769743161896,11242.08,0.0253887360223598,-0.0174829023255526,0.0490976045313185,-0.0528043342825204,0.0338529773794697,-0.0068784268272933,0.125162016006951),
(31,'motor11','gen7',4063,4000,3.39914875682148,11237.28,0.0296009707271771,-0.0180255200668794,0.0532284519998594,-0.0721186706473457,0.0463313393409548,-0.0092888073535786,0.139742953426451),
(32,'motor12','gen7',4093,4000,3.38688790721504,11277.96,0.0245376870915376,-0.0163032874488211,0.0450696967599697,-0.0369227591376709,0.0236945386655586,-0.005048246153499,0.109229911574517),
(33,'motor13','gen7',4069,4000,3.38768091212089,11275.32,0.0280765378812448,-0.0168795960041314,0.0478293158307552,-0.0461300642688031,0.0296090640795353,-0.0063862976805278,0.116989891966848),
(34,'motor14','gen7',7570,7500,6.24757706055278,11463.6,0.0192919551144458,-0.0165343577483208,0.0424796978412876,-0.0188477057808102,0.0122512257735886,-0.0027087030786764,0.0760007575562558),
(35,'motor15','gen7',4003,4000,3.38876288109134,11271.72,0.0324916749323087,-0.0174090114665935,0.0515487260783474,-0.0594702547390986,0.0382476195820892,-0.0082760970227881,0.127572550880614),
(36,'motor16','gen7',4048,4000,3.38746460123012,11276.04,0.0258024492304762,-0.016522109737571,0.046559441146546,-0.0460036956913679,0.0294736979549995,-0.0062366991855903,0.116963454569412),
(37,'motor17','gen7',4091,4000,3.38876288109134,11271.72,0.0301609712185868,-0.0170860487458218,0.0505048176423177,-0.0624554499864695,0.0400893965825896,-0.0084273539336216,0.129931745390942),
(38,'motor18','gen7',4071,4000,3.38760880542118,11275.56,0.024324274239296,-0.0163592096366169,0.0452269501246991,-0.0372298510400202,0.0238907892091416,-0.0050681618341242,0.109724323597593),
(39,'motor19','gen7',4036,4000,3.38840214798427,11272.92,0.0278158935685531,-0.0169295615696886,0.0479508394557156,-0.0465052958190473,0.0298474198895749,-0.0064047813434693,0.117513358958113),
(40,'motor20','gen7',4036,4000,3.38948457777886,11269.32,0.0321718271860017,-0.0174596438272359,0.0516369025996947,-0.0599335698652912,0.0385405921548273,-0.0082906329417637,0.128129862503397),
(41,'motor21','gen7',4026,4000,3.37786665305294,11308.08,0.0247327256778196,-0.0154633820320765,0.0429627463975199,-0.0324173439016274,0.0207981778182134,-0.0045936910794472,0.102829715791505),
(42,'motor22','gen7',4033,4000,3.37854785526499,11305.8,0.0283301157394847,-0.0160349389093396,0.045574615751058,-0.0403274470060324,0.0258744211811648,-0.0058130895978489,0.109789972263352),
(43,'motor23','gen7',4062,4000,3.37951635222948,11302.56,0.032824364501739,-0.0165781169232966,0.0491149303998773,-0.0517000594946635,0.0332320487478136,-0.0075341917086731,0.119226283911712),
(44,'motor24','gen7',4028,4000,3.37883475945302,11304.84,0.0245703344932502,-0.0155429931880656,0.043177705399444,-0.0327529917290473,0.021014351311556,-0.0046199527672105,0.103425699297734),
(45,'motor25','gen7',7560,7500,6.24855820127318,11461.8,0.0230711794547335,-0.01789271331115,0.0462934593514391,-0.0245935228742145,0.0159564480074338,-0.0036709186425798,0.0819646067317863),
(46,'motor26','gen7',4088,4000,3.37951635222948,11302.56,0.028131396189819,-0.0161128698707324,0.0457705354192272,-0.0407442482770801,0.0261417984562598,-0.0058410838302128,0.110426170130228),
(47,'motor27','gen7',4060,4000,3.38048540461328,11299.32,0.0325791900932399,-0.0166547345260092,0.0492859525022116,-0.0522279740232698,0.0335696258484413,-0.0075633487484216,0.119914103620595),
(48,'motor28','gen7',4046,4000,3.37991108427525,11301.24,0.0244319504855956,-0.0156384423498841,0.0434302317792489,-0.0331175529347326,0.0212501776087989,-0.0046508401948703,0.104082723593754),
(49,'motor29','gen7',4093,4000,3.38059311140626,11298.96,0.0279617465772857,-0.0162058314776001,0.0460057589400403,-0.0411992887774019,0.0264349631306973,-0.0058752042593582,0.111129884297859),
(50,'motor30','gen7',4013,4000,3.38152685785695,11295.84,0.0323697553417099,-0.0167478375924919,0.0495044790343881,-0.0528061545763445,0.0339412907496194,-0.0076005739396139,0.12067563847535),
(51,'motor31','gen7',4098,4000,3.26961281697507,11682.48,0.0221331434870095,-0.0063444305461648,0.0225964827252739,-0.012767346566244,0.0079591299398212,-0.0027163780215793,0.0523259707815531),
(52,'motor32','gen7',4014,4000,3.26988151730724,11681.52,0.0254832311263461,-0.0066035370800618,0.0240833886690181,-0.0159438373696674,0.0099735077928032,-0.0035031829410953,0.0566027553687357),
(53,'motor33','gen7',4009,4000,3.2702174548347,11680.32,0.0296792091407767,-0.0067943734449348,0.0261877504649052,-0.0205762521971577,0.0129411764142447,-0.0046349931739708,0.0623210730853273),
(54,'motor34','gen7',4070,4000,3.27011666632892,11680.68,0.0219953767520335,-0.0063768507410893,0.0227078376885747,-0.0129539546970954,0.0080760036309339,-0.0027302884961423,0.0526687020700891),
(55,'motor35','gen7',4090,4000,3.27038544948465,11679.72,0.0253175232689929,-0.0066329557505523,0.0241769746024122,-0.0161833008859734,0.0101234720680337,-0.0035188012347829,0.0569765957184137),
(56,'motor36','gen7',7560,7500,6.24855820127318,11461.8,0.0229469594661017,-0.0178606912956585,0.046210384619488,-0.0246380983125288,0.0159822050068854,-0.0036700250397446,0.0820113083628796),
(57,'motor37','gen7',4056,4000,3.27072149057028,11678.52,0.0294783831049872,-0.006825360264739,0.0262692853917864,-0.0208913429850385,0.0131388794518649,-0.0046523118165557,0.0627360234534779),
(58,'motor38','gen7',4071,4000,3.26719649974125,11691.12,0.0224169060698805,-0.0062086110813263,0.022198454831109,-0.0114735135009256,0.0071507781945815,-0.002556110796359,0.0502204402173838),
(59,'motor39','gen7',4070,4000,3.26743126272894,11690.28,0.0258296496166088,-0.0064750205508493,0.023648909558548,-0.0142627218582385,0.0089189312803643,-0.0032999454652047,0.0542096796774658),
(60,'motor40','gen7',4047,4000,3.26773315043415,11689.2,0.0301065813903421,-0.0066813288410153,0.025710583903725,-0.0183053572651421,0.0115087098456963,-0.0043701657979202,0.0595213951332221);
/*!40000 ALTER TABLE `component_motors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `component_transformers`
--

DROP TABLE IF EXISTS `component_transformers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `component_transformers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(40) DEFAULT NULL,
  `manufacturer` varchar(40) DEFAULT NULL,
  `price` float DEFAULT NULL,
  `p_r_m` float DEFAULT NULL,
  `s_r_equ` float DEFAULT NULL,
  `p_0_25` float DEFAULT NULL,
  `p_0_50` float DEFAULT NULL,
  `p_0_100` float DEFAULT NULL,
  `p_50_25` float DEFAULT NULL,
  `p_50_50` float DEFAULT NULL,
  `p_50_100` float DEFAULT NULL,
  `p_90_50` float DEFAULT NULL,
  `p_90_100` float DEFAULT NULL,
  `f_nominal` double NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `component_transformers`
--

LOCK TABLES `component_transformers` WRITE;
/*!40000 ALTER TABLE `component_transformers` DISABLE KEYS */;
INSERT INTO `component_transformers` VALUES
(1,'FU1','gen_fu',500,0.12,0.278,33.79,33.84,34.3,33.89,34.04,34.84,34.39,35.85,200),
(2,'FU2','gen_fu',510,0.18,0.381,25.24,25.28,25.75,25.34,25.48,26.28,25.83,27.3,200),
(3,'FU3','gen_fu',510,0.25,0.5,19.74,19.78,20.25,19.84,19.99,20.78,20.34,21.8,200),
(4,'FU4','gen_fu',520,0.37,0.697,14.77,14.82,15.29,14.87,15.02,15.82,15.37,16.84,200),
(5,'FU5','gen_fu',520,0.55,0.977,11.14,11.19,11.66,11.24,11.39,12.19,11.74,13.21,200),
(6,'FU6','gen_fu',530,0.75,1.29,8.96,9,9.47,9.06,9.2,10,9.55,11.02,200),
(7,'FU7','gen_fu',530,1.1,1.71,6.86,7.13,7.82,6.93,7.33,8.4,7.68,9.51,200),
(8,'FU8','gen_fu',540,1.5,2.29,5.56,5.83,6.52,5.63,6.03,7.1,6.38,8.21,200),
(9,'FU9','gen_fu',540,2.2,3.3,4.54,4.82,5.51,4.61,5.02,6.09,5.37,7.2,200),
(10,'FU10','gen_fu',550,3,4.44,4.07,4.35,5.04,4.14,4.55,5.62,4.9,6.72,200),
(11,'FU11','gen_fu',560,4,5.85,3.74,4.02,4.71,3.82,4.22,5.29,4.57,6.39,200),
(12,'FU12','gen_fu',570,5.5,7.94,3.35,3.63,4.32,3.42,3.83,4.9,4.18,6.01,200),
(13,'FU13','gen_fu',580,7.5,9.95,2.8,3.09,4.02,2.86,3.28,4.64,3.61,5.84,200),
(14,'FU14','gen_fu',580,11,14.4,2.39,2.68,3.61,2.46,2.87,4.23,3.2,5.43,200),
(15,'FU15','gen_fu',590,15,19.5,2.15,2.44,3.37,2.22,2.63,3.99,2.96,5.18,200),
(16,'FU16','gen_fu',600,18.5,23.9,2.02,2.32,3.24,2.09,2.51,3.86,2.83,5.05,200),
(17,'FU17','gen_fu',610,22,28.3,1.94,2.23,3.16,2.01,2.43,3.78,2.75,4.97,200),
(18,'FU18','gen_fu',620,30,38.2,1.83,2.12,3.05,1.9,2.31,3.67,2.64,4.87,200),
(19,'FU19','gen_fu',630,37,47,1.76,2.05,2.98,1.83,2.24,3.6,2.57,4.79,200),
(20,'FU20','gen_fu',640,45,56.9,1.71,2.01,2.93,1.78,2.2,3.55,2.52,4.75,200),
(21,'FU21','gen_fu',660,55,68.4,1.62,1.93,2.9,1.7,2.13,3.53,2.47,4.74,200),
(22,'FU22','gen_fu',680,75,92.8,1.58,1.88,2.85,1.65,2.08,3.48,0.242,4.69,200),
(23,'FU23','gen_fu',690,90,111,1.55,1.86,2.82,1.62,2.05,3.45,2.39,4.66,200),
(24,'FU24','gen_fu',700,110,135,1.24,1.48,2.27,1.32,1.68,2.91,2.02,4.11,200),
(25,'FU25','gen_fu',700,132,162,1.23,1.47,2.26,1.3,1.67,2.89,2.01,4.1,200),
(26,'FU26','gen_fu',710,160,196,1.22,1.46,2.25,1.29,1.66,2.88,2,4.09,200),
(27,'FU27','gen_fu',710,200,245,1.21,1.45,2.24,1.28,1.65,2.87,1.98,4.07,200),
(28,'FU28','gen_fu',720,250,302,1.17,1.42,2.24,1.24,1.61,2.88,1.95,4.1,200),
(29,'FU29','gen_fu',720,315,302,1.16,1.41,2.23,1.23,1.61,2.87,1.94,4.09,200),
(30,'FU30','gen_fu',730,355,429,1.16,1.41,2.23,1.12,1.6,2.87,1.94,4.09,200),
(31,'FU31','gen_fu',740,400,483,1.16,1.41,2.23,1.23,16,2.87,1.94,4.09,200),
(32,'FU32','gen_fu',740,500,604,1.15,1.4,2.22,1.22,1.6,2.86,1.94,4.08,200),
(33,'FU33','gen_fu',750,560,677,1.15,1.4,2.22,1.22,1.6,2.86,1.93,4.08,200),
(34,'FU34','gen_fu',760,630,761,1.15,1.4,2.22,1.22,1.6,2.86,1.3,4.08,200),
(35,'FU35','gen_fu',770,710,858,1.15,1.4,2.22,1.22,1.59,2.86,1.93,4.08,200),
(36,'FU36','gen_fu',780,800,967,1.15,1.4,2.22,1.22,1.59,2.86,1.93,4.08,200),
(37,'FU37','gen_fu',790,900,1088,1.15,1.39,2.21,1.21,1.59,2.86,1.93,4.08,200),
(38,'FU38','gen_fu',800,1000,1209,1.14,1.39,2.21,1.21,1.59,2.85,1.93,4.08,200);
/*!40000 ALTER TABLE `component_transformers` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `components`
--

LOCK TABLES `components` WRITE;
/*!40000 ALTER TABLE `components` DISABLE KEYS */;
INSERT INTO `components` VALUES
(1,'component_motors','Motoren','motors',0),
(26,'component_transformers','Frequenzumrichter','transformers',0),
(28,'component_gears','Getriebe','gears',0);
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
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `info_texts`
--

LOCK TABLES `info_texts` WRITE;
/*!40000 ALTER TABLE `info_texts` DISABLE KEYS */;
INSERT INTO `info_texts` VALUES
(1,1,1,3,'Prozess-spezifischer Infotext für Angabe der Prozessparameter von Kantenanleimmaschinen...'),
(2,1,1,4,'Prozess-spezifischer Infotext für Angabe der Nebenbedingungen von Kantenanleimmaschinen...'),
(3,1,2,3,'Hilfetext Prozessparameter'),
(4,1,2,4,'Hilfetext Nebenbedingungen'),
(9,1,16,3,''),
(10,1,16,4,''),
(11,1,17,3,''),
(12,1,17,4,''),
(13,1,18,3,''),
(14,1,18,4,''),
(15,1,20,3,''),
(16,1,20,4,''),
(17,1,21,3,''),
(18,1,21,4,'');
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
  `doc` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `processes_loss_functions` (`processes_id`),
  CONSTRAINT `processes_loss_functions` FOREIGN KEY (`processes_id`) REFERENCES `processes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loss_functions`
--

LOCK TABLES `loss_functions` WRITE;
/*!40000 ALTER TABLE `loss_functions` DISABLE KEYS */;
INSERT INTO `loss_functions` VALUES
(1,1,'import numpy as np\r\n\r\ndef target_func(a, b):\r\n	rt = RotatingTool(diameter=125, num_teeth=3, ang_kappa=90, ang_lambda=65)\r\n	return a * b\r\n\r\n\r\nclass RotatingTool:\r\n    \"\"\"Base class for rotating cutting tools.\"\"\"\r\n\r\n    def __init__(self, diameter, num_teeth, ang_kappa, ang_lambda):\r\n        \"\"\"\r\n        Initialize a rotary cutting tool.\r\n\r\n        Parameters\r\n        ----------\r\n        diameter : float\r\n            tool diameter in mm.\r\n        num_teeth : integer\r\n            number of teeth.\r\n        ang_kappa : float\r\n            cutting angle in deg.\r\n        ang_lambda : float\r\n            cutting angle in deg.\r\n\r\n        Returns\r\n        -------\r\n        Object.\r\n\r\n        \"\"\"\r\n        self.d = diameter / 1000\r\n        self.z = num_teeth\r\n        self.ang_kap = ang_kappa * np.pi / 180\r\n        self.ang_lam = ang_lambda\r\n        self.process_params = None\r\n        self.ppp = False\r\n\r\n    def define_cutting_process(self, kc05, rpm, feed_speed, cutting_width,\r\n                               depth_of_cut, protrusion=0):\r\n        \"\"\"\r\n        Definition of a wood cutting process.\r\n\r\n        Parameters\r\n        ----------\r\n        kc05: float\r\n            specific cutting force of material in N/mm^1.5\r\n        rpm : float\r\n            rotations per minute.\r\n        feed_speed : float\r\n            feed speed in meters per minute.\r\n        cutting_width : float\r\n            cutting width in mm.\r\n        depth_of_cut : float\r\n            depth of cut in mm.\r\n        protrusion : float\r\n            saw blades only: blade protrusion in mm\r\n        Returns\r\n        -------\r\n        A dictonary of the cutting parameters.\r\n\r\n        \"\"\"\r\n        # check for numeric values?\r\n        # conversion to SI Units\r\n        parameter_dict = dict([(\"kc05\", kc05*1000**1.5), (\"rpm\", rpm),\r\n                               (\"feed_speed\", feed_speed/60),\r\n                               (\"cw\", cutting_width/1000),\r\n                               (\"ae\", depth_of_cut/1000),\r\n                               (\"n\", rpm/60), (\"protrusion\", protrusion/1000)])\r\n\r\n        self.process_params = parameter_dict\r\n        self.ppp = True\r\n\r\n    def check_process_param_dict(self):\r\n        \"\"\"Check if a Process Parameters Dictonary is available.\"\"\"\r\n        if self.ppp:\r\n            return self.ppp\r\n        else:\r\n            print(\"Please parse a process parameter dict \\\r\n                  to make this calculation.\")\r\n            return self.ppp\r\n\r\n    def calculate_geometry_parameters(self):\r\n        \"\"\"\r\n        Calculate specific geometry values for the given process parameters.\r\n\r\n        Returns\r\n        -------\r\n        A dictonary containing all relevant cutting process values.\r\n\r\n        \"\"\"\r\n        fz = self.fz()\r\n        vc = self.vc()\r\n        omega = self.angular_vel()\r\n        phi = self.ang_phi()\r\n        sb = self.sb(phi)\r\n        ze = self.ze(phi)\r\n        hm = self.hm(fz, sb)\r\n\r\n        res = dict([(\"vc\", vc), (\"feed per tooth\", fz), (\"phi\", phi),\r\n                    (\"cut arc length\", sb), (\"ze\", ze),\r\n                    (\"medium chip thickness\", hm), (\"ang_v\", omega)])\r\n        return res\r\n\r\n    def calculate_process_output(self, geometry_dict):\r\n        \"\"\"\r\n        Calculate cutting force, moment and power.\r\n\r\n        Returns\r\n        -------\r\n        A dictonary containing calculation results.\r\n\r\n        \"\"\"\r\n        Fc = self.Fc(geometry_dict.get(\"medium chip thickness\"))\r\n        M = self.cutting_moment(Fc, geometry_dict.get(\"ze\"))\r\n        P = self.cutting_power(M, geometry_dict.get(\"ang_v\"))\r\n\r\n        res = dict([(\"cutting force\", Fc), (\"cutting moment\", M),\r\n                    (\"cutting power\", P)])\r\n        return res\r\n\r\n    def angular_vel(self):\r\n        \"\"\"Calculate the tools angular velocity.\"\"\"\r\n        if self.check_process_param_dict():\r\n            return 2 * np.pi * self.process_params.get(\"n\")\r\n\r\n    def vc(self):\r\n        \"\"\"Calculate the cutting speed.\"\"\"\r\n        if self.check_process_param_dict():\r\n            return self.d * np.pi / self.process_params.get(\"n\")\r\n\r\n    def fz(self):\r\n        \"\"\"Calculate the feed per tooth.\"\"\"\r\n        if self.check_process_param_dict():\r\n            return self.process_params.get(\"feed_speed\") / \\\r\n                (self.process_params.get(\"n\") * self.z)\r\n\r\n    def sb(self, ang_phi):\r\n        \"\"\"Arc length of tooth in cutting operation.\"\"\"\r\n        if self.check_process_param_dict():\r\n            return self.d * ang_phi * 0.5\r\n\r\n    def ze(self, ang_phi):\r\n        \"\"\"Calculate the number of active teeth.\"\"\"\r\n        if self.check_process_param_dict():\r\n            return self.z * ang_phi / np.pi * 0.5\r\n\r\n    def ang_phi(self):\r\n        \"\"\"\r\n        Calculate angle of operation?.\r\n\r\n        Returns\r\n        -------\r\n        Angle of operation in radians.\r\n\r\n        \"\"\"\r\n        if self.check_process_param_dict():\r\n            h1 = self.process_params.get(\"ae\") - \\\r\n                self.process_params.get(\"protrusion\")\r\n            return np.arccos(1-2*h1/self.d) - \\\r\n                np.arccos(1-2*self.process_params.get(\"protrusion\")/self.d)\r\n\r\n    def hm(self, feed_per_tooth, cut_arc_length):\r\n        \"\"\"\r\n        Calculate medium chip thickness.\r\n\r\n        Parameters\r\n        ----------\r\n        feed_per_tooth : float\r\n            feed per tooth in meters/tooth.\r\n        cut_arc_length : floath\r\n            tooth active arc length in meters.\r\n\r\n        Returns\r\n        -------\r\n        None.\r\n\r\n        \"\"\"\r\n        if self.check_process_param_dict():\r\n            return feed_per_tooth * np.sin(self.ang_kap) * \\\r\n                self.process_params.get(\"ae\") / cut_arc_length\r\n\r\n    def Fc(self, medium_chip_thickness):\r\n        \"\"\"Calculate cutting force.\"\"\"\r\n        return self.process_params.get(\"kc05\") * \\\r\n            self.process_params.get(\"cw\") /\\\r\n            np.sin(self.ang_kap) * np.sqrt(medium_chip_thickness)\r\n\r\n    def cutting_moment(self, cutting_force, ze):\r\n        \"\"\"Moment of the cutting force acting on the motor.\"\"\"\r\n        return ze * cutting_force * self.d * 0.5\r\n\r\n    def cutting_power(self, moment, angular_vel):\r\n        \"\"\"Power of the cutting motor.\"\"\"\r\n        return moment * angular_vel\r\n','Motorverlust',''),
(2,1,'def target_func(param_a, param_b):\r\n    return param_a * param_b * param_b','Wandlerverlust',''),
(57,21,'def target_func(width_wp, width_band):\n    # width workpiece mm, width edge band mm\n    return (width_band - width_wp) / 2\n','Kantenbandüberlapp','width workpiece mm, width edge band mm'),
(58,21,'def target_func(list_var, index):\n    # list, index\n    return list_var[index]\n','Listenselektion','list, index'),
(59,21,'import numpy as np\r\n\r\n\r\ndef target_func(diameter, num_teeth, ang_kappa, ang_lambda, cutting_width, depth_of_cut, kc05, rpm, feed_speed,\r\n                length_wp, gap_wp, r_bend, n_motors):\r\n    # diameter mm, num_teeth, ang_kappa °, ang_lambda ° - tool parameters, provided as process parameters\r\n    # cutting_width mm, depth_of_cut mm -\r\n    # kc05 N/mm^1,5, rpm, feed_speed m/min, length_wp cm, gap_wp cm, r_bend mm, n_motors for multiple\r\n    # returns list of cutting force, moment, max power, and mean power -- accessible by index starting with 0\r\n    power_variables = straight_cut(diameter, num_teeth, ang_kappa, ang_lambda, cutting_width, depth_of_cut, kc05, rpm,\r\n                                   feed_speed) if r_bend == 0 else \\\r\n        bend_cut(diameter, num_teeth, ang_lambda, kc05, rpm, feed_speed, r_bend)\r\n    portion_load = length_wp / (length_wp + gap_wp)\r\n    return [*power_variables, power_variables[2] * portion_load * n_motors]\r\n\r\n\r\ndef straight_cut(diameter, num_teeth, ang_kappa, ang_lambda, cutting_width, depth_of_cut, kc05, rpm, feed_speed):\r\n    milling_tool = RotatingTool(diameter=diameter, num_teeth=num_teeth, ang_kappa=ang_kappa, ang_lambda=ang_lambda)\r\n    milling_tool.define_cutting_process(kc05, rpm, feed_speed, cutting_width, depth_of_cut)\r\n    geometry_variables = milling_tool.calculate_geometry_parameters()\r\n    return milling_tool.calculate_process_output(geometry_variables)\r\n\r\n\r\ndef bend_cut(diameter, num_teeth, ang_lambda, kc05, rpm, feed_speed, r_bend):\r\n    n = 10\r\n    xs = [r_bend * (1 - 1 / 2 / n - i / n) for i in range(n)]\r\n    kappa = [np.arccos(x / r_bend) for x in xs]\r\n    pieces = [{\"ang_kappa\": k, \"depth_of_cut\": (r_bend * (1 - np.sin(k)))} for k in kappa]\r\n    pvs = []\r\n    for piece in pieces:\r\n        milling_tool = RotatingTool(diameter=diameter, num_teeth=num_teeth, ang_kappa=piece[\"ang_kappa\"],\r\n                                    ang_lambda=ang_lambda)\r\n        milling_tool.define_cutting_process(kc05, rpm, feed_speed, r_bend / n, piece[\"depth_of_cut\"])\r\n        geometry_variables = milling_tool.calculate_geometry_parameters()\r\n        pvs.append(milling_tool.calculate_process_output(geometry_variables))\r\n    return [sum([pv[0] for pv in pvs]), sum([pv[1] for pv in pvs]), sum([pv[2] for pv in pvs])]\r\n\r\n\r\nclass RotatingTool:\r\n    \"\"\"Base class for rotating cutting tools.\"\"\"\r\n\r\n    def __init__(self, diameter, num_teeth, ang_kappa, ang_lambda):\r\n        \"\"\"\r\n        Initialize a rotary cutting tool.\r\n\r\n        Parameters\r\n        ----------\r\n        diameter : float\r\n            tool diameter in mm.\r\n        num_teeth : integer\r\n            number of teeth.\r\n        ang_kappa : float\r\n            cutting angle in deg.\r\n        ang_lambda : float\r\n            cutting angle in deg.\r\n\r\n        Returns\r\n        -------\r\n        Object.\r\n\r\n        \"\"\"\r\n        self.d = diameter / 1000\r\n        self.z = num_teeth\r\n        self.ang_kap = ang_kappa * np.pi / 180\r\n        self.ang_lam = ang_lambda\r\n        self.process_params = None\r\n        self.ppp = False\r\n\r\n    def define_cutting_process(self, kc05, rpm, feed_speed, cutting_width,\r\n                               depth_of_cut, protrusion=0):\r\n        \"\"\"\r\n        Definition of a wood cutting process.\r\n\r\n        Parameters\r\n        ----------\r\n        kc05: float\r\n            specific cutting force of material in N/mm^1.5\r\n        rpm : float\r\n            rotations per minute.\r\n        feed_speed : float\r\n            feed speed in meters per minute.\r\n        cutting_width : float\r\n            cutting width in mm.\r\n        depth_of_cut : float\r\n            depth of cut in mm.\r\n        protrusion : float\r\n            saw blades only: blade protrusion in mm\r\n        Returns\r\n        -------\r\n        A dictonary of the cutting parameters.\r\n\r\n        \"\"\"\r\n        # check for numeric values?\r\n        # conversion to SI Units\r\n        parameter_dict = dict([(\"kc05\", kc05*1000**1.5), (\"rpm\", rpm),\r\n                               (\"feed_speed\", feed_speed/60),\r\n                               (\"cw\", cutting_width/1000),\r\n                               (\"ae\", depth_of_cut/1000),\r\n                               (\"n\", rpm/60), (\"protrusion\", protrusion/1000)])\r\n\r\n        self.process_params = parameter_dict\r\n        self.ppp = True\r\n\r\n    def check_process_param_dict(self):\r\n        \"\"\"Check if a Process Parameters Dictonary is available.\"\"\"\r\n        if self.ppp:\r\n            return self.ppp\r\n        else:\r\n            print(\"Please parse a process parameter dict \\\r\n                  to make this calculation.\")\r\n            return self.ppp\r\n\r\n    def calculate_geometry_parameters(self):\r\n        \"\"\"\r\n        Calculate specific geometry values for the given process parameters.\r\n\r\n        Returns\r\n        -------\r\n        A dictonary containing all relevant cutting process values.\r\n\r\n        \"\"\"\r\n        fz = self.fz()\r\n        vc = self.vc()\r\n        omega = self.angular_vel()\r\n        phi = self.ang_phi()\r\n        sb = self.sb(phi)\r\n        ze = self.ze(phi)\r\n        hm = self.hm(fz, sb)\r\n\r\n        res = dict([(\"vc\", vc), (\"feed per tooth\", fz), (\"phi\", phi),\r\n                    (\"cut arc length\", sb), (\"ze\", ze),\r\n                    (\"medium chip thickness\", hm), (\"ang_v\", omega)])\r\n        return res\r\n\r\n    def calculate_process_output(self, geometry_dict):\r\n        \"\"\"\r\n        Calculate cutting force, moment and power.\r\n\r\n        Returns\r\n        -------\r\n        A dictonary containing calculation results.\r\n\r\n        \"\"\"\r\n        Fc = self.Fc(geometry_dict.get(\"medium chip thickness\"))\r\n        M = self.cutting_moment(Fc, geometry_dict.get(\"ze\"))\r\n        P = self.cutting_power(M, geometry_dict.get(\"ang_v\"))\r\n\r\n        res = dict([(\"cutting force\", Fc), (\"cutting moment\", M),\r\n                    (\"cutting power\", P)])\r\n        \r\n        return [Fc, M, P]\r\n\r\n    def angular_vel(self):\r\n        \"\"\"Calculate the tools angular velocity.\"\"\"\r\n        if self.check_process_param_dict():\r\n            return 2 * np.pi * self.process_params.get(\"n\")\r\n\r\n    def vc(self):\r\n        \"\"\"Calculate the cutting speed.\"\"\"\r\n        if self.check_process_param_dict():\r\n            return self.d * np.pi / self.process_params.get(\"n\")\r\n\r\n    def fz(self):\r\n        \"\"\"Calculate the feed per tooth.\"\"\"\r\n        if self.check_process_param_dict():\r\n            return self.process_params.get(\"feed_speed\") / \\\r\n                (self.process_params.get(\"n\") * self.z)\r\n\r\n    def sb(self, ang_phi):\r\n        \"\"\"Arc length of tooth in cutting operation.\"\"\"\r\n        if self.check_process_param_dict():\r\n            return self.d * ang_phi * 0.5\r\n\r\n    def ze(self, ang_phi):\r\n        \"\"\"Calculate the number of active teeth.\"\"\"\r\n        if self.check_process_param_dict():\r\n            return self.z * ang_phi / np.pi * 0.5\r\n\r\n    def ang_phi(self):\r\n        \"\"\"\r\n        Calculate angle of operation?.\r\n\r\n        Returns\r\n        -------\r\n        Angle of operation in radians.\r\n\r\n        \"\"\"\r\n        if self.check_process_param_dict():\r\n            h1 = self.process_params.get(\"ae\") - \\\r\n                self.process_params.get(\"protrusion\")\r\n            return np.arccos(1-2*h1/self.d) - \\\r\n                np.arccos(1-2*self.process_params.get(\"protrusion\")/self.d)\r\n\r\n    def hm(self, feed_per_tooth, cut_arc_length):\r\n        \"\"\"\r\n        Calculate medium chip thickness.\r\n\r\n        Parameters\r\n        ----------\r\n        feed_per_tooth : float\r\n            feed per tooth in meters/tooth.\r\n        cut_arc_length : floath\r\n            tooth active arc length in meters.\r\n\r\n        Returns\r\n        -------\r\n        None.\r\n\r\n        \"\"\"\r\n        if self.check_process_param_dict():\r\n            return feed_per_tooth * np.sin(self.ang_kap) * \\\r\n                self.process_params.get(\"ae\") / cut_arc_length\r\n\r\n    def Fc(self, medium_chip_thickness):\r\n        \"\"\"Calculate cutting force.\"\"\"\r\n        return self.process_params.get(\"kc05\") * \\\r\n            self.process_params.get(\"cw\") /\\\r\n            np.sin(self.ang_kap) * np.sqrt(medium_chip_thickness)\r\n\r\n    def cutting_moment(self, cutting_force, ze):\r\n        \"\"\"Moment of the cutting force acting on the motor.\"\"\"\r\n        return ze * cutting_force * self.d * 0.5\r\n\r\n    def cutting_power(self, moment, angular_vel):\r\n        \"\"\"Power of the cutting motor.\"\"\"\r\n        return moment * angular_vel\r\n','Prozesswerte Fräsen','diameter mm, num_teeth, ang_kappa °, ang_lambda ° - tool parameters, provided as process parameters\ncutting_width mm, depth_of_cut mm -\nkc05 N/mm^1,5, rpm, feed_speed m/min, length_wp cm, gap_wp cm, r_bend mm, n_motors for multiple\nreturns list of cutting force, moment, max power, and mean power -- accessible by index starting with 0'),
(60,21,'from statistics import mean\n\n\ndef target_func(coeff_a, coeff_b, coeff_c, coeff_d, coeff_e, coeff_f, coeff_g, f_nominal, m_nominal, p_nominal, length, gap, f_load_abs, m_load_abs):\n    # coeff_a, coeff_b, coeff_c, coeff_d, coeff_e, coeff_f, coeff_g - efficiency coefficients of motor\n    # f_nominal 1/min, m_nominal Nm, p_nominal W - nominal rotation frequency, torque, and power of motor\n    # length cm, gap cm - length of workpiece and gap between workpieces\n    # f_load_abs 1/min, m_load_abs Nm - set rotation frequency, torque of process ; m can be list of equally to weight values (time resolved moment during load)\n    f_load = f_load_abs / f_nominal\n    f_idle = f_load\n    m_load = [load/m_nominal for load in m_load_abs] if type(m_load_abs) == list else m_load_abs / m_nominal\n    portion_load = length / (length + gap)\n    loss_load = mean([motor_loss(coeff_a, coeff_b, coeff_c, coeff_d, coeff_e, coeff_f, coeff_g, f_load, m) for m in m_load]) if type(m_load) == list else \\\n        motor_loss(coeff_a, coeff_b, coeff_c, coeff_d, coeff_e, coeff_f, coeff_g, f_load, m_load) \n    relative_loss = portion_load * loss_load + (1 - portion_load) * motor_loss(coeff_a, coeff_b, coeff_c, coeff_d, coeff_e, coeff_f, coeff_g, f_idle, 0)\n    return relative_loss * p_nominal\n\n\ndef motor_loss(coeff_a, coeff_b, coeff_c, coeff_d, coeff_e, coeff_f, coeff_g, f, m):\n    return coeff_a + coeff_b * f + coeff_c * f ** 2 + coeff_d * f * m ** 2 + coeff_e * f ** 2 * m ** 2 + coeff_f * m ** 2 + coeff_g * m\n\n\ndef motor_loss_eight(p_100_100, p_50_100, p_0_100, p_100_50, p_50_50, p_0_50, p_50_25, p_0_25, f_rel, m_rel):\n    f_z = f_rel * 100   # in %\n    m_z = m_rel * 100   # in %\n    if f_z < 0.5 and m_z < 50: # seg 3\n        return p_0_25 + f_z / 50 * (p_50_25 - p_0_25) + (m_z - 25) / 25 * (p_0_50 - p_0_25 + f_z / 50 * (p_50_50 - p_0_50 - p_50_25 + p_0_25))\n    if f_z < 0.5 and m_z >= 50: # seg 1\n        return p_0_50 + f_z / 50 * (p_50_50 - p_0_50) + (m_z - 50) / 50 * (p_0_100 - p_0_50 + f_z / 50 * (p_50_100 - p_0_100 - p_50_50 + p_0_50))\n    if f_z >= 0.5 and m_z < 50: # seg 4\n        return p_0_25 + f_z / 50 * (p_50_25 - p_0_25) + (m_z - 25) / 25 * (p_50_50 - p_0_25 + (f_z - 50) / 50 * (p_100_50 - p_50_50) - f_z / 50 * (p_50_25 - p_0_25))\n    if f_z >= 0.5 and m_z >= 50: # seg 2\n        return p_50_50 + (f_z - 50) * f_z / 50 * (p_100_50 - p_50_50) + (m_z - 50) / 50 * (p_50_100 - p_50_50 + (f_z - 50) / 50 * (p_100_100 - p_50_100 - p_100_50 + p_50_50))\n','Motorwärmeleistung','coeff_a, coeff_b, coeff_c, coeff_d, coeff_e, coeff_f, coeff_g - efficiency coefficients of motor\nf_nominal 1/min, m_nominal Nm, p_nominal W - nominal rotation frequency, torque, and power of motor\nlength cm, gap cm - length of workpiece and gap between workpieces\nf_load_abs 1/min, m_load_abs Nm - set rotation frequency, torque of process ; m can be list of equally to weight values (time resolved moment during load)'),
(61,21,'from statistics import mean\n\n\ndef target_func(p_90_100, p_50_100, p_0_100, p_90_50, p_50_50, p_0_50, p_50_25, p_0_25, p_nominal, f_nominal, length, gap, f_load_abs, m_load_abs, m_nominal_motor):\n    # p_x_y - relative efficieny values of motor\n    # f_nominal Hz, m_nominal Nm, p_nominal W - nominal rotation frequency, torque, and power of motor\n    # length cm, gap cm - length of workpiece and gap between workpieces\n    # f_load_abs 1/min, m_load_abs Nm - set rotation frequency, torque of process ; m can be list of equally to weight values (time resolved moment during load)\n    f_load = f_load_abs / f_nominal / 60\n    f_idle = f_load\n    i_qz_load = [load/m_nominal_motor for load in m_load_abs] if type(m_load_abs) == list else m_load_abs / m_nominal_motor\n    portion_load = length / (length + gap)\n    loss_load = mean([converter_loss(p_90_100, p_50_100, p_0_100, p_90_50, p_50_50, p_0_50, p_50_25, p_0_25, f_load, i_qz_load) for m in i_qz_load]) if type(i_qz_load) == list else \\\n        converter_loss(p_90_100, p_50_100, p_0_100, p_90_50, p_50_50, p_0_50, p_50_25, p_0_25, f_load, i_qz_load) \n    relative_loss = portion_load * loss_load + (1 - portion_load) * converter_loss(p_90_100, p_50_100, p_0_100, p_90_50, p_50_50, p_0_50, p_50_25, p_0_25, f_idle, 0)\n    return relative_loss * p_nominal\n\n\ndef converter_loss(p_90_100, p_50_100, p_0_100, p_90_50, p_50_50, p_0_50, p_50_25, p_0_25, f_rel, i_rel):\n    f_z = f_rel * 100   # in %\n    i_qz = i_rel * 100   # in %\n    if f_z < 0.5 and i_qz < 50: # seg 3\n        return p_0_25 + f_z / 50 * (p_50_25 - p_0_25) + (i_qz - 25) / 25 * (p_0_50 - p_0_25 + f_z / 50 * (p_50_50 - p_0_50 - p_50_25 + p_0_25))\n    if f_z < 0.5 and i_qz >= 50: # seg 1\n        return p_0_50 + f_z / 50 * (p_50_50 - p_0_50) + (i_qz - 50) / 50 * (p_0_100 - p_0_50 + f_z / 50 * (p_50_100 - p_0_100 - p_50_50 + p_0_50))\n    if f_z >= 0.5 and i_qz < 50: # seg 4\n        return p_0_25 + f_z / 50 * (p_50_25 - p_0_25) + (i_qz - 25) / 25 * (p_50_50 - p_0_25 + (f_z - 50) / 40 * (p_90_50 - p_50_50) - f_z / 50 * (p_50_25 - p_0_25))\n    if f_z >= 0.5 and i_qz >= 50: # seg 2\n        return p_50_50 + (f_z - 50) * f_z / 40 * (p_90_50 - p_50_50) + (i_qz - 50) / 50 * (p_50_100 - p_50_50 + (f_z - 50) / 40 * (p_90_100 - p_50_100 - p_90_50 + p_50_50))\n','Wärmeleistung Spannungswandler','p_x_y - relative efficieny values of motor\np_nominal W, f_nominal Hz - nominal power and rotation frequency of motor\nlength cm, gap cm - length of workpiece and gap between workpieces\nf_load_abs 1/min, m_load_abs Nm, m_nominal Nm - set rotation frequency, torque of process, and nominal torque of motor\n-- m_load_abs can be list of equally to weight values (time resolved moment during load)'),
(62,21,'from math import tan\n\n\ndef target_func(v_feed, alpha, length, gap, width_band):\n    # v_feed m/min, alpha °, length cm, gap cm, width_band mm\n    # returns downward speed in m/min, load and idle time in arbitrary units\n    v_down = tan(alpha) * v_feed\n    t_total = (length + gap) / v_feed\n    t_load = width_band / v_down\n    t_idle = t_total - t_load\n    return [v_down, t_load, t_idle]\n','Hilfswerte Kappsäge','v_feed m/min, alpha °, length cm, gap cm, width_band mm\nreturns downward speed in m/min, load and idle time in arbitrary units'),
(63,21,'from math import sin, sqrt\n\n\ndef target_func(ang_kappa, kc05, feed_speed, cutting_width, depth_of_cut, length, gap):\n    # ang_kappa °, kc05 N/mm^1.5, feed_speed m /min, cutting_width mm, depth_of_cut mm,\n    # length workpiece cm, gap workpiece cm\n    power_load = feed_speed/60 * kc05*1000**1.5 * cutting_width/1000 * sqrt(depth_of_cut/1000) / sin(ang_kappa)\n    return length / (length + gap) * power_load\n','Ziehklingenleistung','ang_kappa °, kc05 N/mm^1.5, feed_speed m /min, cutting_width mm, depth_of_cut mm,\nlength workpiece cm, gap workpiece cm'),
(64,21,'from math import sqrt, cos, sin, atan\r\n\r\n\r\ndef target_func(a, mu, k_c, f_zero, v_feed, x_1, y_1, dx, x_3, y_3, length_band, length_wp, gap_wp):\r\n    v_feed_si = v_feed / 60\r\n    return process_power(a, mu, k_c, f_zero, v_feed_si, x_1, y_1, dx, x_3, y_3, length_band, length_wp, gap_wp)\r\n\r\n\r\ndef process_power(a, mu, k_c, f_zero, v_feed, x_1, y_1, dx, x_3, y_3, length_band, length_wp, gap_wp):	\r\n    s = spring_path(x_1, y_1, dx, x_3, y_3)\r\n    l = length_band * length_wp / (length_wp + gap_wp)  # l: summierte Laenge aller Werkstuecke im System\r\n    return (mu * s * k_c * l / a + f_zero) * v_feed\r\n	\r\n\r\ndef spring_path(x_1, y_1, dx, x_3, y_3):	# Federweg s\r\n    alpha = angle(x_1, y_1, dx)\r\n    return (sqrt(x_3 ** 2 + y_3 ** 2) * cos(alpha) ** 3 * (x_3 - sin(alpha) * sqrt(x_3 ** 2 + y_3 ** 2))) /\\\r\n            sqrt(x_1 ** 2 + y_1 ** 2 - (x_1 - dx) ** 2)\r\n\r\n\r\ndef angle(x_1, y_1, dx):\r\n    return atan((x_1 - dx) / sqrt(x_1 ** 2 + y_1 ** 2 - (x_1 - dx) ** 2))\r\n','Vorschubleistung','a Abstand Anpressrollen, mu Reibungskoeff. Band, k_c Federkonstante, f_zero Vorspannung Feder,\nv_feed Vorschubgeschw. m/min, x_1, y_1, dx, x_3, y_3, length_band, length_wp, gap_wp'),
(65,21,'from math import pi\n\n\ndef target_func(i_gears, eta, m_nominal, disc_diam, v_feed, process_pow):\n    v_feed_si = v_feed / 60\n    omega = dg(i_gears, v_feed_si, disc_diam)\n    m_process = process_moment(process_pow, omega)\n    m_gr = gear_moment(m_nominal, m_process, eta)\n    gl = gear_loss(m_gr, omega)\n    total_moment = moment_feed_system(m_gr, m_process)\n    return [gl, total_moment, omega, m_process]\n\n\ndef gear_loss(m_gr, omega):\n    return m_gr * omega\n\n\ndef moment_feed_system(m_g, m_process):	\n    return m_g + m_process\n\n\ndef gear_moment(m_nominal, m_process, eta):		# oben berechnete Prozessleistung muss für m_process durch die Ausgangsdrehzahl des Getriebes geteilt werden, Drehzahl aus Vorschubgeschwindkeit und Durchmesser der Scheibe (ebenfalls als Prozessparameter anzugeben)\n    return (1 - eta) / eta * (0.6 * m_nominal + 0.4 * m_process)\n\n\ndef process_moment(process_pow, omega):\n    return process_pow / omega\n\n\ndef dg(i_gears, v_feed, disc_diam):\n    f = f_abtrieb(v_feed, disc_diam)\n    return i_gears * f\n\n\ndef f_abtrieb(v_feed, d):\n    return v_feed / pi / d\n','Getriebewerte','i_gears Uebersetzung Getriebe, eta Getriebewirkungsgrad, m_nominal Nennmoment Getriebe Nm,\ndisc_diam m, v_feed Vorschub m/min, process_pow\nreturns gear_loss, total moment of feed system, (to divide by nominal motor moment for motor loss), omega and process moment');
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
  `variable_name` varchar(30) NOT NULL,
  `defaults` varchar(30) NOT NULL,
  `material_properties_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `processes_parameters` (`processes_id`),
  KEY `process_parameters_properties` (`material_properties_id`),
  CONSTRAINT `process_parameters_properties` FOREIGN KEY (`material_properties_id`) REFERENCES `material_properties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `processes_parameters` FOREIGN KEY (`processes_id`) REFERENCES `processes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=210 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `process_parameters`
--

LOCK TABLES `process_parameters` WRITE;
/*!40000 ALTER TABLE `process_parameters` DISABLE KEYS */;
INSERT INTO `process_parameters` VALUES
(1,1,'Werkstückdicke','mm',0,'p_part_width','',NULL),
(2,1,'Werkstücklänge','cm',0,'p_part_length','',NULL),
(3,1,'Fräsbreite','mm',0,'p_milling_width','',NULL),
(4,1,'Frästiefe','mm',0,'p_milling_depth','',NULL),
(5,1,'Spez. Schnittkraft','N/mm^1,5',0,'p_k_c05','',2),
(6,1,'Zähne Kappsäge','',1,'p_teeth_clipping','12,16,20',NULL),
(166,21,'Vorschubgeschwindigkeit','m / min',0,'p_feed_speed','',NULL),
(167,21,'Werkstückdicke','mm',0,'p_width','',NULL),
(168,21,'Werkstücklänge','cm',0,'p_length','',NULL),
(169,21,'Breite Kantenband','mm',0,'p_width_band','',NULL),
(170,21,'Dicke Kantenband','mm',0,'p_thickness_band','',NULL),
(171,21,'Werkstücklücke','cm',0,'p_gap','',NULL),
(172,21,'Abnutzungsfaktor Fräsen','',0,'p_wear_factor','1',NULL),
(173,21,'Spez. Schnittkraftkonstante','N/mm^1.5',0,'p_kc05','',2),
(174,21,'Spez. Schnittkraftkonst. Band','N/mm^1.5',0,'p_kc05_band','',2),
(175,21,'Zahnzahl Vorfräse','',0,'p_pre_teeth','3',NULL),
(176,21,'Frästiefe Vorfräse','mm',0,'p_pre_depth','3',NULL),
(177,21,'Winkel kappa Vorfräse','°',0,'p_pre_ang_kappa','90',NULL),
(178,21,'Winkel lambda Vorfräse','°',0,'p_pre_ang_lambda','65',NULL),
(179,21,'Drehzahl Vorfräse','1/min',0,'p_pre_n','9000',NULL),
(180,21,'Werkzeugdurchm. Vorfräse','mm',0,'p_pre_diameter','125',NULL),
(181,21,'Zahnzahl Kappsäge','',0,'p_trim_teeth','24',NULL),
(182,21,'Winkel kappa Kappsäge','°',0,'p_trim_ang_kappa','65',NULL),
(183,21,'Winkel lambda Kappsäge','°',0,'p_trim_ang_lambda','5',NULL),
(184,21,'Drehzahl Kappsäge','1/min',0,'p_trim_n','12000',NULL),
(185,21,'Werkzeugdurchm. Kappsäge','mm',0,'p_trim_diameter','120',NULL),
(186,21,'Blattdicke Kappsäge','mm',0,'p_trim_width','3.2',NULL),
(187,21,'Winkel Führung Kappsäge','°',1,'p_trim_angle','45',NULL),
(188,21,'Zahnzahl Bündigfräser','',0,'p_flush_teeth','3',NULL),
(189,21,'Winkel kappa Bündigfräser','°',0,'p_flush_ang_kappa','90',NULL),
(190,21,'Winkel lambda Bündigfräser','°',0,'p_flush_ang_lambda','65',NULL),
(191,21,'Drehzahl Bündigfräse','1/min',0,'p_flush_n','12000',NULL),
(192,21,'Werkzeugdurchm. Bündigfräser','mm',0,'p_flush_diameter','80',NULL),
(193,21,'Zahnzahl Radienfräser','',0,'p_round_teeth','4',NULL),
(194,21,'Fräsradius Radienfräser','mm',0,'p_round_radius','',NULL),
(195,21,'Werkzeugdurchm. Radienfräser','mm',0,'p_round_diameter','125',NULL),
(196,21,'Einstellwinkel Ziehklinge','°',1,'p_scraper_ang','90',NULL),
(197,21,'Eingriff Ziehklinge','mm',1,'p_scraper_depth','0.2',NULL),
(198,21,'Spannfederpunkt x1','m',1,'p_feed_x1','',NULL),
(199,21,'Spannfederpunkt y1','m',1,'p_feed_y1','',NULL),
(200,21,'Spannfederpunkt x3','m',1,'p_feed_x3','',NULL),
(201,21,'Spannfederpunkt y3','m',1,'p_feed_y3','',NULL),
(202,21,'Federkonstante Spannfedern','N/m',1,'p_feed_kc','49660',NULL),
(203,21,'Reibungskoeffizient Förderband','',1,'p_feed_mu','6',NULL),
(204,21,'Transferbandlänge','m',1,'p_feed_l','6.5',NULL),
(205,21,'Abstand Band-Federelemente','m',1,'p_feed_spring_dist','0.07',NULL),
(206,21,'Spannweg Werkstück','m',1,'p_feed_delta_x','0.004',NULL),
(207,21,'Vorspannung Band-Spannfeder','N',1,'p_feed_f0','200',NULL),
(208,21,'Durchmesser Riemenscheiben','m',1,'p_feed_disc_diam','0.2',NULL),
(209,21,'Drehzahl Radienfräser','1/min',0,'p_round_n','8700',NULL);
/*!40000 ALTER TABLE `process_parameters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `process_solvers`
--

DROP TABLE IF EXISTS `process_solvers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `process_solvers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `processes_id` int(11) NOT NULL,
  `code` mediumtext DEFAULT NULL,
  `use_solver` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `processes_processsolvers` (`processes_id`),
  CONSTRAINT `processes_processsolvers` FOREIGN KEY (`processes_id`) REFERENCES `processes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `process_solvers`
--

LOCK TABLES `process_solvers` WRITE;
/*!40000 ALTER TABLE `process_solvers` DISABLE KEYS */;
INSERT INTO `process_solvers` VALUES
(1,1,'from math import *\r\nimport copy\r\n\r\ncurrent_losses = {}\r\nweighted_losses = {}\r\nindices = {}\r\nopts = []\r\ncost_opts = []\r\n\r\n\r\ndef call_solver(loss_func, model, data):\r\n    # ToDo: as class\r\n    global current_losses, weighted_losses, indices, opts, cost_opts\r\n    # reset -  problematic for several parallel requests\r\n    current_losses = {}\r\n    weighted_losses = {}\r\n    indices = {}\r\n    opts = []\r\n    cost_opts = []\r\n\r\n    components = model[\'components\']\r\n    update_losses(data, model, {}, loss_func, 0)\r\n    wander_tree(1, model, components, {}, loss_func, data)\r\n    return opts, cost_opts, \'no special remarks\'\r\n\r\n\r\ndef wander_tree(depth, model, components, combination, lfs, data):\r\n    current_comp_type = data[components[0][\'component_api_name\']]\r\n    global indices\r\n#    print(\'wander_tree - \' + str(depth))\r\n    # select new component\r\n    for index, comp in enumerate(current_comp_type):\r\n        var_name = components[0][\'variable_name\']\r\n        indices[var_name] = index\r\n        new_combination = {**combination, var_name: comp}\r\n        if conditions_satisfied(model, new_combination, data, depth):\r\n            update_losses(data, model, new_combination, lfs, depth)\r\n            # recursive decision\r\n            if len(components) > 1:\r\n                new_components = copy.copy(components)\r\n                new_components.pop(0)\r\n                wander_tree(depth + 1, model, new_components, new_combination, lfs, data)\r\n            else:\r\n                summarize_and_check_results(model, new_combination)\r\n\r\n\r\ndef update_losses(data, model, combination, lfs, depth):\r\n    global current_losses\r\n    # unpack variables and previous components\r\n    for general_key in model[\'general_parameters\']:\r\n        exec(general_key + \' = model[\"general_parameters\"][\"\' + general_key + \'\"]\')\r\n    for data_key in data.keys():\r\n        exec(data_key + \' = data[\"\' + data_key + \'\"]\')\r\n    for comb_key in combination.keys():\r\n        exec(comb_key + \' = combination[\"\' + comb_key + \'\"]\')\r\n    for lf_key in lfs.keys():\r\n        exec(\'target_func_\' + str(lf_key) + \' = lfs[\' + str(lf_key) + \']\')\r\n    # eval losses to evaluated after newly selected component\r\n    for lf in model[\'loss_functions\']:\r\n        if lf[\'eval_after_position\'] == depth:\r\n            exec(\'current_losses[\"\' + lf[\'variable_name\'] + \'\"] = []\')  # reset loss list\r\n            for pos in range(len(model[\'process_profiles\'])):\r\n                parameter_set = model[\'process_profiles\'][pos]\r\n                for parameter_key in parameter_set.keys():\r\n                    # exec(parameter_key + \' = parameter_set[\"\' + parameter_key + \'\"]\')\r\n                    exec(parameter_key + \' = model[\"process_profiles\"][\' + str(pos) + \'][\"\' + parameter_key + \'\"]\')\r\n                # unpack previously evaluated losses\r\n                for current_losses_key in current_losses.keys():\r\n                    if current_losses_key != lf[\'variable_name\']:\r\n                        exec(current_losses_key + \' = current_losses[\"\' + current_losses_key + \'\"][\' + str(pos) + \']\')\r\n                # eval current loss\r\n                # print(\'EXEC \' + lf[\'variable_name\'] + \' = \' + lf[\'function_call\'])\r\n                exec(lf[\'variable_name\'] + \' = \' + lf[\'function_call\'])\r\n                # ToDo: view group\r\n                # pack current loss for deeper levels\r\n                exec(\'current_losses[\"\' + lf[\'variable_name\'] + \'\"].append(\' + lf[\'variable_name\'] + \')\')\r\n\r\n\r\ndef conditions_satisfied(model, combination, data, depth):\r\n    # noinspection DuplicatedCode\r\n    for data_key in data.keys():\r\n        exec(data_key + \' = data[\"\' + data_key + \'\"]\')\r\n    for comb_key in combination.keys():\r\n        exec(comb_key + \' = combination[\"\' + comb_key + \'\"]\')\r\n    for general_key in model[\'general_parameters\']:\r\n        exec(general_key + \' = model[\"general_parameters\"][\"\' + general_key + \'\"]\')\r\n    global current_losses\r\n    # check request conditions\r\n    for pos in range(len(model[\'process_profiles\'])):  # conditions have to be fulfilled for all profiles\r\n        for parameter_key in model[\'process_profiles\'][pos].keys():\r\n            exec(parameter_key + \' = model[\"process_profiles\"][\' + str(pos) + \'][\"\' + parameter_key + \'\"]\')\r\n        for current_losses_key in current_losses.keys():\r\n            exec(current_losses_key + \' = current_losses[\"\' + current_losses_key + \'\"][\' + str(pos) + \']\')\r\n        for cond in model[\'conditions\']:\r\n            try:\r\n                result = eval(cond)\r\n                if not result:\r\n                    # print(\'Condition evaluated to False: \' + cond)\r\n                    return False\r\n            except NameError as ex:  # conditions with missing vars have to be evaluated at a deeper level\r\n                print(\'Condition parameter not defined: \' + ex.args[0])\r\n        # check implicit conditions\r\n        for restr in model[\'restrictions\']:\r\n            if depth == restr[\'eval_after_position\']:\r\n                try:\r\n                    result = eval(restr[\'restriction\'])\r\n                    if not result:\r\n                        return False\r\n                except NameError as ex:\r\n                    print(\'Condition parameter not defined: \' + ex.args[0])\r\n    return True\r\n\r\n\r\ndef summarize_and_check_results(model, combination):\r\n    # new part\r\n    global current_losses\r\n    total = sum_losses(model)\r\n    # costs optimization\r\n    acquisition_costs = update_cost_opts(model, combination, total) if model[\'result_settings\'][\'costs_opt\'][\r\n        \'exec\'] else None\r\n    # sort current combination in optimal solutions\r\n    update_opts(model, total, acquisition_costs)\r\n\r\n\r\ndef sum_losses(model):\r\n    global current_losses\r\n    global weighted_losses\r\n    total = 0\r\n    for current_losses_key in current_losses.keys():\r\n        if function_is_loss(model, current_losses_key):\r\n            weighted_losses[current_losses_key] = sum(clk * profile[\'portion\'] for clk, profile\r\n                                                      in zip(current_losses[current_losses_key], model[\'process_profiles\']))\r\n            total += weighted_losses[current_losses_key]\r\n    return total\r\n\r\n\r\ndef update_cost_opts(model, combination, total):\r\n    global cost_opts\r\n    global indices\r\n    acquisition_costs = sum(comp[\'price\'] for comp in combination.values()) + model[\'result_settings\'][\'costs_opt\'][\'assembly_costs\']\r\n    energy_costs = total * model[\'result_settings\'][\'costs_opt\'][\'price_kwh\'] * model[\'result_settings\'][\'costs_opt\'][\'amortisation_time\']\r\n    inserted = False\r\n    for pos, old_opt in enumerate(cost_opts):\r\n        if old_opt[\'total_costs\'] > acquisition_costs + energy_costs:\r\n            cost_opts.insert(pos, build_cost_opt(model, total, acquisition_costs, energy_costs))\r\n            inserted = True\r\n            if len(cost_opts) > int(model[\'result_settings\'][\'n_list\']):\r\n                cost_opts.pop()\r\n            break\r\n    if len(cost_opts) < int(model[\'result_settings\'][\'n_list\']) and not inserted:\r\n        cost_opts.append(build_cost_opt(model, total, acquisition_costs, energy_costs))\r\n    return acquisition_costs\r\n\r\n\r\ndef build_cost_opt(model, total, acquisition_costs, energy_costs):\r\n    global weighted_losses\r\n    global indices\r\n    return {\'total_costs\': acquisition_costs + energy_costs,\r\n            \'acquisition_costs\': acquisition_costs,\r\n            \'energy_costs\': energy_costs,\r\n            \'total\': total,\r\n            \'partials\': {val[1]: {\'value\': val[0], \'aggregate\': val[2]} for val in\r\n                         partial_generator(model)},\r\n            \'indices\': copy.copy(indices)}\r\n\r\n\r\ndef update_opts(model, total, acquisition_costs):\r\n    global opts\r\n    inserted = False\r\n    for pos, old_opt in enumerate(opts):\r\n        if old_opt[\'total\'] > total:\r\n            opts.insert(pos, build_opt(model, total, acquisition_costs))\r\n            inserted = True\r\n            if len(opts) > int(model[\'result_settings\'][\'n_list\']):\r\n                opts.pop()\r\n            break\r\n    if len(opts) < int(model[\'result_settings\'][\'n_list\']) and not inserted:\r\n        opts.append(build_opt(model, total, acquisition_costs))\r\n\r\n\r\ndef build_opt(model, total, acquisition_costs):\r\n    global weighted_losses\r\n    global indices\r\n    return {\'acquisition_costs\': acquisition_costs,\r\n            \'total\': total,\r\n            \'partials\': {val[1]: {\'value\': val[0], \'aggregate\': val[2]} for val in\r\n                         partial_generator(model)},\r\n            \'indices\': copy.copy(indices)}\r\n\r\n\r\ndef description_and_aggregate_from_variable(model, var):\r\n    function_by_var = next(lf for lf in model[\'loss_functions\'] if lf[\'variable_name\'] == var)\r\n    return [function_by_var[\'description\'], function_by_var[\'aggregate\']]\r\n\r\n\r\ndef function_is_loss(model, var):\r\n    return all(lf[\'is_loss\'] for lf in model[\'loss_functions\'] if lf[\'variable_name\'] == var)\r\n\r\n\r\ndef partial_generator(model):\r\n    global weighted_losses\r\n    for key in weighted_losses.keys():\r\n        yield [weighted_losses[key]] + description_and_aggregate_from_variable(model, key)\r\n',0),
(9,21,'',0);
/*!40000 ALTER TABLE `process_solvers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `process_sources`
--

DROP TABLE IF EXISTS `process_sources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `process_sources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `processes_id` int(11) NOT NULL,
  `request` mediumtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `process_sources`
--

LOCK TABLES `process_sources` WRITE;
/*!40000 ALTER TABLE `process_sources` DISABLE KEYS */;
/*!40000 ALTER TABLE `process_sources` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `processes`
--

LOCK TABLES `processes` WRITE;
/*!40000 ALTER TABLE `processes` DISABLE KEYS */;
INSERT INTO `processes` VALUES
(1,'Test','test',1),
(2,'Dummy-Prozess','dummy',0),
(21,'KAM','edge_banding',0);
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
-- Table structure for table `requests`
--

DROP TABLE IF EXISTS `requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `requests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `processes_id` int(11) NOT NULL,
  `timestamp` varchar(19) NOT NULL,
  `status` tinyint(4) NOT NULL,
  `request` text NOT NULL,
  `result` text NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `requests_timestamp` (`timestamp`),
  KEY `requests_processes_index` (`processes_id`),
  CONSTRAINT `requests_processes` FOREIGN KEY (`processes_id`) REFERENCES `processes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `requests`
--

LOCK TABLES `requests` WRITE;
/*!40000 ALTER TABLE `requests` DISABLE KEYS */;
/*!40000 ALTER TABLE `requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `restrictions`
--

DROP TABLE IF EXISTS `restrictions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `restrictions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `processes_id` int(11) NOT NULL,
  `restriction` text NOT NULL,
  `eval_after_position` int(11) NOT NULL,
  `description` varchar(40) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `restrictions_processes` (`processes_id`),
  CONSTRAINT `restrictions_processes` FOREIGN KEY (`processes_id`) REFERENCES `processes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `restrictions`
--

LOCK TABLES `restrictions` WRITE;
/*!40000 ALTER TABLE `restrictions` DISABLE KEYS */;
INSERT INTO `restrictions` VALUES
(28,21,'0 <= c_pre_motor[\'p_nominal\'] - p_wear_factor * l_pre_pow_max',1,'Vorfräsmotorleistung'),
(29,21,'0 <= c_pre_motor[\'n_nominal\'] - p_pre_n',1,'Vorfräsmotordrehzahl'),
(30,21,'0 <= c_pre_converter[\'p_r_m\'] - c_pre_motor[\'p_nominal\']',2,'Vorfräsumrichterleistung'),
(31,21,'0 <= c_pre_converter[\'f_nominal\'] * 60 - p_pre_n',2,'Vorfräsumrichterfrequenz'),
(32,21,'0 <= c_trim_motor[\'p_nominal\'] - l_trim_pow_max * p_wear_factor',3,'Kappmotorleistung'),
(33,21,'0 <= c_trim_motor[\'n_nominal\'] - p_trim_n',3,'Kappmotordrehzahl'),
(34,21,'0 <= c_trim_converter[\'p_r_m\'] - c_trim_motor[\'p_nominal\']',4,'Kappumrichterleistung'),
(35,21,'0 <= c_trim_converter[\'f_nominal\'] * 60 - p_trim_n',4,'Kappumrichterfrequenz'),
(36,21,'0 <= c_flush_motor[\'p_nominal\'] - l_flush_pow_max * p_wear_factor',5,'Bündigmotorleistung'),
(37,21,'0 <= c_flush_motor[\'n_nominal\'] - p_flush_n',5,'Bündigmotordrehzahl'),
(38,21,'0 <= c_flush_converter[\'p_r_m\'] - c_flush_motor[\'p_nominal\']',6,'Bündigumrichterleistung'),
(39,21,'0 <= c_flush_converter[\'f_nominal\'] * 60 - p_flush_n',6,'Bündigumrichterfrequenz'),
(40,21,'0 <= c_round_motor[\'p_nominal\'] - l_round_pow_max * p_wear_factor',7,'Radienmotorleistung'),
(41,21,'0 <= c_round_motor[\'n_nominal\'] - p_round_n',7,'Radienmotordrehzahl'),
(42,21,'0 <= c_round_converter[\'p_r_m\'] - c_round_motor[\'p_nominal\']',8,'Radienumrichterleistung'),
(43,21,'0 <= c_round_converter[\'f_nominal\'] * 60 - p_round_n',8,'Radienumrichterfrequenz'),
(44,21,'0 <= c_feed_gears[\'m_nominal\'] - l_feed_m',9,'Vortriebgetriebemoment'),
(45,21,'0 <= c_feed_motor[\'p_nominal\'] - l_feed_pow - l_feed_gear_loss',10,'Vortriebmotorleistung'),
(46,21,'0 <= c_feed_motor[\'n_nominal\'] - l_feed_omega',10,'Vortriebmotordrehzahl');
/*!40000 ALTER TABLE `restrictions` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `variant_components`
--

LOCK TABLES `variant_components` WRITE;
/*!40000 ALTER TABLE `variant_components` DISABLE KEYS */;
INSERT INTO `variant_components` VALUES
(1,15,1,'motors','v_milling_motor','Fräsermotor'),
(2,15,2,'motors','v_flush_motor','Bündigfräsermotor'),
(5,15,3,'motors','v_forward_motor','Nebenantriebsmotor'),
(41,38,0,'motors','c_pre_motor','Vorfräsmotor'),
(42,38,1,'transformers','c_pre_converter','Vorfräsumrichter'),
(43,38,2,'motors','c_trim_motor','Kappmotor'),
(44,38,3,'transformers','c_trim_converter','Kappumrichter'),
(45,38,4,'motors','c_flush_motor','Bündigfräsmotor'),
(46,38,5,'transformers','c_flush_converter','Bündigfräsumrichter'),
(47,38,6,'motors','c_round_motor','Radienfräsmotor'),
(48,38,7,'transformers','c_round_converter','Radienfräsumrichter'),
(49,38,8,'gears','c_feed_gears','Getriebe Bandvorschub'),
(50,38,9,'motors','c_feed_motor','Bandvorschubmotor');
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
  PRIMARY KEY (`id`),
  KEY `process_variant_selection` (`processes_id`),
  CONSTRAINT `process_variant_selection` FOREIGN KEY (`processes_id`) REFERENCES `processes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `variant_selection`
--

LOCK TABLES `variant_selection` WRITE;
/*!40000 ALTER TABLE `variant_selection` DISABLE KEYS */;
INSERT INTO `variant_selection` VALUES
(1,1,'{\"list\": [], \"tree\": {\"no\": {\"excludes\": [5, 6, 7, 8, 9, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23], \"no\": {\"excludes\": [3, 4], \"no\": {\"excludes\": [1], \"no\": null, \"question\": null, \"yes\": null}, \"question\": \"Leimfugenziehen?\", \"yes\": {\"excludes\": [2], \"no\": null, \"question\": null, \"yes\": null}}, \"question\": \"Eckenkopieren?\", \"yes\": {\"excludes\": [1, 2], \"no\": {\"excludes\": [4], \"no\": null, \"question\": null, \"yes\": null}, \"question\": \"Leimfugenziehen?\", \"yes\": {\"excludes\": [3], \"no\": null, \"question\": null, \"yes\": null}}}, \"question\": \"F\\u00fcgefr\\u00e4sen?\", \"yes\": {\"excludes\": [1, 2, 3, 4], \"no\": {\"excludes\": [5, 6], \"no\": {\"excludes\": [18, 19, 20, 21, 22, 23, 12], \"no\": {\"excludes\": [15, 16, 17], \"no\": {\"excludes\": [9, 11, 13, 14], \"no\": {\"excludes\": [8], \"no\": null, \"question\": null, \"yes\": null}, \"question\": \"Leimfugenziehen?\", \"yes\": {\"excludes\": [7], \"no\": null, \"question\": null, \"yes\": null}}, \"question\": \"Eckenkopieren?\", \"yes\": {\"excludes\": [7, 8], \"no\": {\"excludes\": [12, 13, 14, 15, 16, 17, 13], \"no\": {\"excludes\": [11], \"no\": null, \"question\": null, \"yes\": null}, \"question\": \"Schwabbeln?\", \"yes\": {\"excludes\": [9], \"no\": null, \"question\": null, \"yes\": null}}, \"question\": \"Leimfugenziehen?\", \"yes\": {\"excludes\": [9, 11], \"no\": {\"excludes\": [], \"no\": {\"excludes\": [14], \"no\": null, \"question\": null, \"yes\": null}, \"question\": \"Nutfr\\u00e4sen?\", \"yes\": {\"excludes\": [12], \"no\": null, \"question\": null, \"yes\": null}}, \"question\": \"Eckschwabbeln?\", \"yes\": {\"excludes\": [12, 14], \"no\": null, \"question\": null, \"yes\": null}}}}, \"question\": \"B\\u00fcndigfr\\u00e4sen?\", \"yes\": {\"excludes\": [7, 8, 9, 11, 12, 13, 14], \"no\": {\"excludes\": [17], \"no\": {\"excludes\": [16], \"no\": null, \"question\": null, \"yes\": null}, \"question\": \"Universalfr\\u00e4sen?\", \"yes\": {\"excludes\": [15], \"no\": null, \"question\": null, \"yes\": null}}, \"question\": \"Eckschwabbeln?\", \"yes\": {\"excludes\": [15, 16], \"no\": null, \"question\": null, \"yes\": null}}}, \"question\": \"Laser?\", \"yes\": {\"excludes\": [7, 8, 9, 11, 12, 13, 14, 15, 16, 17], \"no\": {\"excludes\": [21, 22, 23], \"no\": {\"excludes\": [20], \"no\": {\"excludes\": [19], \"no\": null, \"question\": null, \"yes\": null}, \"question\": \"Nutfr\\u00e4sen?\", \"yes\": {\"excludes\": [18], \"no\": null, \"question\": null, \"yes\": null}}, \"question\": \"Eckschwabbeln?\", \"yes\": {\"excludes\": [18, 19], \"no\": null, \"question\": null, \"yes\": null}}, \"question\": \"B\\u00fcndigfr\\u00e4sen?\", \"yes\": {\"excludes\": [18, 19, 20], \"no\": {\"excludes\": [23], \"no\": {\"excludes\": [22], \"no\": null, \"question\": null, \"yes\": null}, \"question\": \"Universalfr\\u00e4sen?\", \"yes\": {\"excludes\": [21], \"no\": null, \"question\": null, \"yes\": null}}, \"question\": \"Nutfr\\u00e4sen?\", \"yes\": {\"excludes\": [21, 22], \"no\": null, \"question\": null, \"yes\": null}}}}, \"question\": \"Hei\\u00dfluft?\", \"yes\": {\"excludes\": [7, 8, 9, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23], \"no\": {\"excludes\": [6], \"no\": null, \"question\": null, \"yes\": null}, \"question\": \"Leimfugenziehen?\", \"yes\": {\"excludes\": [5], \"no\": null, \"question\": null, \"yes\": null}}}}}'),
(9,21,'{\"list\": [], \"tree\": [{\"id\": \"root\", \"question\": \"\", \"info\": \"\", \"excludes\": [], \"exclude_choices\": [], \"answers\": [{\"response\": \"yes\", \"question\": \"\", \"excludes\": [], \"exclude_choices\": [], \"id\": \"y\", \"answers\": []}, {\"response\": \"no\", \"question\": \"\", \"excludes\": [], \"exclude_choices\": [], \"id\": \"n\", \"answers\": []}]}]}');
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
  PRIMARY KEY (`id`),
  KEY `variants_process` (`processes_id`),
  CONSTRAINT `variants_processes` FOREIGN KEY (`processes_id`) REFERENCES `processes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `variants`
--

LOCK TABLES `variants` WRITE;
/*!40000 ALTER TABLE `variants` DISABLE KEYS */;
INSERT INTO `variants` VALUES
(1,1,'Leim mit Fugenziehen'),
(2,1,'Leim'),
(3,1,'Leim mit Schwabbel'),
(4,1,'Leim mit Fugenziehen und Schwabbel'),
(5,1,'Heißluft'),
(6,1,'Heißluft mit Fugenziehen'),
(7,1,'Fügefraser, Leim'),
(8,1,'Fügefraser, Leim mit Schwabbel'),
(9,1,'Fügefraser, Leim mit Eckenkopierer'),
(11,1,'Fügefraser, Leim mit Eckenkopierer und Schwabbel'),
(12,1,'Fügefraser, Leim mit Eckenkopierer, Ziehklinge und Schwabbel'),
(13,1,'Fügefraser, Leim mit Eckenkopierer, Ziehklinge und Eck-/Schwabbel'),
(14,1,'Fügefraser, Leim mit Eckenkopierer, Ziehklinge, Schwabbel und Nutfräse'),
(15,1,'Fügefraser, Leim mit Eckenkopierer, Bündigfräser'),
(16,1,'Fügefraser, Leim mit Eckenkopierer, Bündig- und Universalfräser'),
(17,1,'Fügefraser, Leim mit Eckenkopierer, Bündigfräser und Eckschwabbel'),
(18,1,'Laser'),
(19,1,'Laser mit Nutfräse'),
(20,1,'Laser mit Eckschwabbel'),
(21,1,'Laser mit Bündigfräser'),
(22,1,'Laser mit Bündig- und Universalfräser'),
(23,1,'Laser mit Bündigfräser und Eckschwabbel'),
(38,21,'Var 1');
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
  `is_loss` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `variants_variants_loss_functions` (`variants_id`),
  KEY `loss_functions_variants_loss_functions` (`loss_functions_id`),
  CONSTRAINT `loss_functions_variants_loss_functions` FOREIGN KEY (`loss_functions_id`) REFERENCES `loss_functions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `variants_variants_loss_functions` FOREIGN KEY (`variants_id`) REFERENCES `variants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `variants_loss_functions`
--

LOCK TABLES `variants_loss_functions` WRITE;
/*!40000 ALTER TABLE `variants_loss_functions` DISABLE KEYS */;
INSERT INTO `variants_loss_functions` VALUES
(1,15,1,'(p_part_width, p_part_length)','r_milling_motor_loss','Verlust Fügefräsmotor',1,1,'Fügefräse',1),
(2,15,1,'(p_part_width, p_part_length)','r_milling_trans_loss','Verlust Fügefräswandler',3,2,'Fügefräse',1),
(3,15,2,'(p_part_width, p_part_length)','r_trim_motor_loss','Verlust Kappmotor',2,3,'Kappaggregat',1),
(53,38,57,'(p_width, p_width_band)','l_overlap_band','Kantenüberlapp',0,0,'Bündigfräser',0),
(54,38,59,'(p_pre_diameter, p_pre_teeth, p_pre_ang_kappa, p_pre_ang_lambda, p_width, p_pre_depth, p_kc05, p_pre_n, p_feed_speed, p_length, p_gap, 0, 1)','l_pre_values','Fräswerte Vorfräsen',0,1,'Vorfräse',0),
(55,38,58,'(l_pre_values, 3)','l_pre_pow','Leistung Vorfäsen',0,2,'Vorfräse',1),
(56,38,58,'(l_pre_values, 2)','l_pre_pow_max','Max. Leistung Vorfräsen',0,3,'Vorfräse',0),
(57,38,58,'(l_pre_values, 1)','l_pre_m','Lastmoment Vorfräse',0,4,'Vorfräse',0),
(58,38,60,'(c_pre_motor[\'coeff_a\'], c_pre_motor[\'coeff_b\'], c_pre_motor[\'coeff_c\'], c_pre_motor[\'coeff_d\'], c_pre_motor[\'coeff_e\'], c_pre_motor[\'coeff_f\'], c_pre_motor[\'coeff_g\'], c_pre_motor[\'n_nominal\'], c_pre_motor[\'m_nominal\'], c_pre_motor[\'p_nominal\'], p_length, p_gap, p_pre_n, l_pre_m)','l_pre_motor_loss','Motorwärmeleistung Vorfräse',1,5,'Vorfräse',1),
(59,38,61,'(c_pre_converter[\'p_90_100\'], c_pre_converter[\'p_50_100\'], c_pre_converter[\'p_0_100\'], c_pre_converter[\'p_90_50\'], c_pre_converter[\'p_50_50\'], c_pre_converter[\'p_0_50\'], c_pre_converter[\'p_50_25\'], c_pre_converter[\'p_0_25\'], c_pre_converter[\'p_r_m\'], c_pre_motor[\'n_nominal\'], p_length, p_gap, p_pre_n, l_pre_m, c_pre_motor[\'m_nominal\'])','l_pre_coverter_loss','Wechselrichterverlust Vorfräse',2,6,'Vorfräse',1),
(60,38,62,'(p_feed_speed, p_trim_angle, p_length, p_gap, p_width_band)','l_trim_values','Kappsägenwerte',0,7,'Kappsäge',0),
(61,38,58,'(l_trim_values, 0)','l_trim_speed','Schnittgeschwindigkeit Kappsäge',0,8,'Kappsäge',0),
(62,38,58,'(l_trim_values, 1)','l_trim_t_load','Lastzeit Kappsäge',0,9,'Kappsäge',0),
(63,38,58,'(l_trim_values, 2)','l_trim_t_idle','Leerlaufzeit Kappsäge',0,10,'Kappsäge',0),
(64,38,59,'(p_trim_diameter, p_trim_teeth, p_trim_ang_kappa, p_trim_ang_lambda, p_trim_diameter, p_thickness_band, p_kc05_band, p_trim_n, l_trim_speed, l_trim_t_load, l_trim_t_idle, 0, 2)','l_trim_motor_values','Fräswerte Kappen',0,11,'Kappsäge',0),
(65,38,58,'(l_trim_motor_values, 3)','l_trim_pow','Leistung Kappen',0,12,'Kappsäge',1),
(66,38,58,'(l_trim_motor_values, 2)','l_trim_pow_max','Max. Leistung Kappen',0,13,'Kappsäge',0),
(67,38,58,'(l_trim_motor_values, 1)','l_trim_m','Lastmoment Kappen',0,14,'Kappsäge',0),
(68,38,60,'(c_trim_motor[\'coeff_a\'], c_trim_motor[\'coeff_b\'], c_trim_motor[\'coeff_c\'], c_trim_motor[\'coeff_d\'], c_trim_motor[\'coeff_e\'], c_trim_motor[\'coeff_f\'], c_trim_motor[\'coeff_g\'], c_trim_motor[\'n_nominal\'], c_trim_motor[\'m_nominal\'], c_trim_motor[\'p_nominal\'], l_trim_t_load, l_trim_t_idle, p_trim_n, l_trim_m)','l_trim_motor_loss','Motorwärmeleistung Kappsäge',3,15,'Kappsäge',1),
(69,38,61,'(c_trim_converter[\'p_90_100\'], c_trim_converter[\'p_50_100\'], c_trim_converter[\'p_0_100\'], c_trim_converter[\'p_90_50\'], c_trim_converter[\'p_50_50\'], c_trim_converter[\'p_0_50\'], c_trim_converter[\'p_50_25\'], c_trim_converter[\'p_0_25\'], c_trim_motor[\'p_nominal\'], c_trim_motor[\'n_nominal\'], l_trim_t_load, l_trim_t_idle, p_trim_n, l_trim_m, c_trim_motor[\'m_nominal\'])','l_trim_converter_los','Wechselrichterverlust Kappsäge',4,16,'Kappsäge',1),
(70,38,59,'(p_flush_diameter, p_flush_teeth, p_flush_ang_kappa, p_flush_ang_lambda, p_thickness_band, l_overlap_band, p_kc05_band, p_flush_n, p_feed_speed, p_length, p_gap, 0, 2)','l_flush_values','Fräswerte Bündigfräse',0,17,'Bündigfräser',0),
(71,38,58,'(l_flush_values, 3)','l_flush_pow','Leistung Bündigfräsen',0,18,'Bündigfräser',1),
(72,38,58,'(l_flush_values, 2)','l_flush_pow_max','Max. Leistung Bündigfräsen',0,19,'Bündigfräser',0),
(73,38,58,'(l_flush_values, 1)','l_flush_m','Lastmoment Bündigfräsen',0,20,'Bündigfräser',0),
(74,38,60,'(c_flush_motor[\'coeff_a\'], c_flush_motor[\'coeff_b\'], c_flush_motor[\'coeff_c\'], c_flush_motor[\'coeff_d\'], c_flush_motor[\'coeff_e\'], c_flush_motor[\'coeff_f\'], c_flush_motor[\'coeff_g\'], c_flush_motor[\'n_nominal\'], c_flush_motor[\'m_nominal\'], c_flush_motor[\'p_nominal\'], p_length, p_gap, p_flush_n, l_flush_m)','l_flush_motor_loss','Motorwärmeleistung Bündigfräsen',5,21,'Bündigfräser',1),
(75,38,61,'(c_flush_converter[\'p_90_100\'], c_flush_converter[\'p_50_100\'], c_flush_converter[\'p_0_100\'], c_flush_converter[\'p_90_50\'], c_flush_converter[\'p_50_50\'], c_flush_converter[\'p_0_50\'], c_flush_converter[\'p_50_25\'], c_flush_converter[\'p_0_25\'], c_flush_motor[\'p_nominal\'], c_flush_motor[\'n_nominal\'], p_length, p_gap, p_flush_n, l_flush_m, c_flush_motor[\'m_nominal\'])','l_flush_conv_loss','Wechselrichterverlust Bündigfräser',6,22,'Bündigfräser',1),
(76,38,59,'(p_round_diameter, p_round_teeth, 0, 90, p_round_radius, p_round_radius, p_kc05, p_round_n, p_feed_speed, p_length, p_gap, p_round_radius, 2)','l_round_values','Fräswerte Radienfräser',0,23,'Radienfräser',0),
(77,38,58,'(l_round_values, 3)','l_round_pow','Leistung Radienfräsen',0,24,'Radienfräser',1),
(78,38,58,'(l_round_values, 2)','l_round_pow_max','Max. Leistung Radienfräsen',0,25,'Radienfräser',0),
(79,38,58,'(l_round_values, 1)','l_round_m','Lastmoment Radienfräsen',0,26,'Radienfräser',0),
(80,38,60,'(c_round_motor[\'coeff_a\'], c_round_motor[\'coeff_b\'], c_round_motor[\'coeff_c\'], c_round_motor[\'coeff_d\'], c_round_motor[\'coeff_e\'], c_round_motor[\'coeff_f\'], c_round_motor[\'coeff_g\'], c_round_motor[\'n_nominal\'], c_round_motor[\'m_nominal\'], c_round_motor[\'p_nominal\'], p_length, p_gap, p_round_n, l_round_m)','l_round_motor_loss','Motorwärmeleistung Radienfräser',7,27,'Radienfräser',1),
(81,38,61,'(c_round_converter[\'p_90_100\'], c_round_converter[\'p_50_100\'], c_round_converter[\'p_0_100\'], c_round_converter[\'p_90_50\'], c_round_converter[\'p_50_50\'], c_round_converter[\'p_0_50\'], c_round_converter[\'p_50_25\'], c_round_converter[\'p_0_25\'], c_round_motor[\'p_nominal\'], c_round_motor[\'n_nominal\'], p_length, p_gap, p_round_n, l_round_m, c_round_motor[\'m_nominal\'])','l_round_conv_loss','Wechsrichterverlust Radienfräsen',8,28,'Radienfräser',1),
(82,38,63,'(p_scraper_ang, p_kc05_band, p_feed_speed, p_width, p_scraper_depth, p_length, p_gap)','l_scraper_pow','Ziehklingenleistung',0,29,'Ziehklingen',1),
(83,38,64,'(p_feed_spring_dist, p_feed_mu, p_feed_kc, p_feed_f0, p_feed_speed, p_feed_x1, p_feed_y1, p_feed_delta_x, p_feed_x3, p_feed_y3, p_feed_l, p_length, p_gap)','l_feed_pow','Vorschubspannleistung',0,30,'Vortrieb',1),
(84,38,65,'(c_feed_gears[\'gear_ratio\'], c_feed_gears[\'efficiency\'], c_feed_gears[\'m_nominal\'], p_feed_disc_diam, p_feed_speed, l_feed_pow)','l_feed_gear_values','Vorschubgetriebewerte',9,31,'Vortrieb',0),
(85,38,58,'(l_feed_gear_values, 0)','l_feed_gear_loss','Vorschubgetriebereibwärme',9,32,'Vortrieb',1),
(86,38,58,'(l_feed_gear_values, 1)','l_feed_m_total','Gesamtmoment Vorschubsystem',9,33,'Vortrieb',0),
(87,38,58,'(l_feed_gear_values, 2)','l_feed_omega','Eingangsdrehzahl Vorschubgetriebe',9,34,'Vortrieb',0),
(88,38,58,'(l_feed_gear_values, 3)','l_feed_m','Lastmoment Vorspannung',9,35,'Vortrieb',0),
(89,38,60,'(c_feed_motor[\'coeff_a\'], c_feed_motor[\'coeff_b\'], c_feed_motor[\'coeff_c\'], c_feed_motor[\'coeff_d\'], c_feed_motor[\'coeff_e\'], c_feed_motor[\'coeff_f\'], c_feed_motor[\'coeff_g\'], c_feed_motor[\'n_nominal\'], c_feed_motor[\'m_nominal\'], c_feed_motor[\'p_nominal\'], 1, 0, l_feed_omega, l_feed_m_total)','l_feed_motor_loss','Motorwärmeleistung Vortrieb',9,36,'Vortrieb',1);
/*!40000 ALTER TABLE `variants_loss_functions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `variants_restrictions`
--

DROP TABLE IF EXISTS `variants_restrictions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `variants_restrictions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `variants_id` int(11) NOT NULL,
  `restrictions_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `variants_variants_restrictions` (`variants_id`),
  KEY `restrictions_variants_restrictions` (`restrictions_id`),
  CONSTRAINT `restrictions_variants_restrictions` FOREIGN KEY (`restrictions_id`) REFERENCES `restrictions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `variants_variants_restrictions` FOREIGN KEY (`variants_id`) REFERENCES `variants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `variants_restrictions`
--

LOCK TABLES `variants_restrictions` WRITE;
/*!40000 ALTER TABLE `variants_restrictions` DISABLE KEYS */;
INSERT INTO `variants_restrictions` VALUES
(24,38,28),
(25,38,29),
(26,38,30),
(27,38,31),
(28,38,32),
(29,38,33),
(30,38,34),
(31,38,35),
(32,38,36),
(33,38,37),
(34,38,38),
(35,38,39),
(36,38,40),
(37,38,41),
(38,38,42),
(39,38,43),
(40,38,44),
(41,38,45),
(42,38,46);
/*!40000 ALTER TABLE `variants_restrictions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-06-15  0:55:29
