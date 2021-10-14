-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Erstellungszeit: 15. Okt 2021 um 00:54
-- Server-Version: 10.4.20-MariaDB
-- PHP-Version: 8.0.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `eehbv_proto`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `aggregate_components`
--

CREATE TABLE `aggregate_components` (
  `id` int(11) NOT NULL,
  `aggregate_api_name` varchar(30) NOT NULL,
  `component_api_name` varchar(30) NOT NULL,
  `variable_name` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `aggregate_parts`
--

CREATE TABLE `aggregate_parts` (
  `id` int(11) NOT NULL,
  `aggregate_id` int(11) NOT NULL,
  `component_id` int(11) NOT NULL,
  `aggregate_components_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `aggregate_variables`
--

CREATE TABLE `aggregate_variables` (
  `id` int(11) NOT NULL,
  `api_name` varchar(30) NOT NULL,
  `column_name` varchar(30) NOT NULL,
  `func` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `column_info`
--

CREATE TABLE `column_info` (
  `id` int(11) NOT NULL,
  `component_id` int(30) NOT NULL,
  `column_name` varchar(30) NOT NULL,
  `view_name` varchar(40) NOT NULL,
  `type` varchar(7) NOT NULL,
  `position` tinyint(4) NOT NULL,
  `unit` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `column_info`
--

INSERT INTO `column_info` (`id`, `component_id`, `column_name`, `view_name`, `type`, `position`, `unit`) VALUES
(1, 1, 'name', 'Modell', 'VARCHAR', 1, NULL),
(2, 1, 'manufacturer', 'Hersteller', 'VARCHAR', 2, NULL),
(3, 1, 'n_max', 'Max. Drehzahl', 'DOUBLE', 3, 's^-1'),
(4, 1, 'm_max', 'Max. Drehmoment', 'DOUBLE', 4, 'Nm'),
(5, 1, 'asycn', 'Asynchron', 'BOOL', 5, NULL),
(6, 2, 'name', 'Modell', 'VARCHAR', 1, NULL),
(7, 2, 'manufacturer', 'Hersteller', 'VARCHAR', 2, NULL),
(8, 2, 'gear_ratio', 'Übersetzung', 'DOUBLE', 3, NULL);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `components`
--

CREATE TABLE `components` (
  `id` int(11) NOT NULL,
  `table_name` varchar(30) NOT NULL,
  `view_name` varchar(30) NOT NULL,
  `api_name` varchar(15) NOT NULL,
  `is_aggregate` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `components`
--

INSERT INTO `components` (`id`, `table_name`, `view_name`, `api_name`, `is_aggregate`) VALUES
(1, 'component_motor', 'Motoren', 'motors', 0),
(2, 'component_gear', 'Getriebe', 'gears', 0);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `component_gear`
--

CREATE TABLE `component_gear` (
  `id` int(11) NOT NULL,
  `name` varchar(40) NOT NULL,
  `manufacturer` varchar(40) DEFAULT NULL,
  `gear_ratio` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `component_gear`
--

INSERT INTO `component_gear` (`id`, `name`, `manufacturer`, `gear_ratio`) VALUES
(1, 'Gear AX', 'Gearontologists', 200),
(2, 'Gear 2000', 'Gearontologists', 2000),
(4, 'Gear++', 'Gearontologists', 22),
(5, 'GearX', 'Man2', 430);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `component_motor`
--

CREATE TABLE `component_motor` (
  `id` int(11) NOT NULL,
  `name` varchar(40) NOT NULL,
  `manufacturer` varchar(40) NOT NULL,
  `n_max` double NOT NULL,
  `m_max` double NOT NULL,
  `async` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `component_motor`
--

INSERT INTO `component_motor` (`id`, `name`, `manufacturer`, `n_max`, `m_max`, `async`) VALUES
(1, 'motor1', 'man1', 4000, 250, 0),
(2, 'motor2', 'man1', 4200, 230, 0),
(3, 'motor3', 'man1', 4200, 250, 0),
(4, 'motor4', 'man2', 4200, 230, 0),
(5, 'motor5', 'man3', 4200, 230, 0),
(6, 'motor6', 'man2', 4500, 230, 0),
(8, 'motorX', 'man2', 4200, 230, 0);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `gearblobs`
--

CREATE TABLE `gearblobs` (
  `gear_id` int(11) NOT NULL,
  `meta` text DEFAULT NULL,
  `profile` blob DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `info_texts`
--

CREATE TABLE `info_texts` (
  `id` int(11) NOT NULL,
  `type` tinyint(4) NOT NULL,
  `type_id` int(11) NOT NULL,
  `position` tinyint(4) NOT NULL,
  `text` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `info_texts`
--

INSERT INTO `info_texts` (`id`, `type`, `type_id`, `position`, `text`) VALUES
(1, 1, 1, 3, 'Prozess-spezifischer Infotext für Angabe der Prozessparameter von Kantenanleimmaschinen...'),
(2, 1, 1, 4, 'Prozess-spezifischer Infotext für Angabe der Nebenbedingungen von Kantenanleimmaschinen...');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `material_properties`
--

CREATE TABLE `material_properties` (
  `id` int(11) NOT NULL,
  `property` varchar(40) NOT NULL,
  `unit` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `material_properties`
--

INSERT INTO `material_properties` (`id`, `property`, `unit`) VALUES
(1, 'Dichte', 'g/cm^3'),
(2, 'Schnittkraftkonstante k_c0,5', 'N/mm^1,5'),
(7, 'Brinellhärte', 'N/mm^2');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `motorlobs`
--

CREATE TABLE `motorlobs` (
  `motor_id` int(11) NOT NULL,
  `meta` text DEFAULT NULL,
  `profile` blob DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `processes`
--

CREATE TABLE `processes` (
  `id` int(11) NOT NULL,
  `view_name` varchar(40) NOT NULL,
  `api_name` varchar(30) NOT NULL,
  `variant_tree` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `processes`
--

INSERT INTO `processes` (`id`, `view_name`, `api_name`, `variant_tree`) VALUES
(1, 'Kantenanleimmaschine', 'edge_banding', 1);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `process_parameters`
--

CREATE TABLE `process_parameters` (
  `id` int(11) NOT NULL,
  `processes_id` int(11) NOT NULL,
  `name` varchar(30) NOT NULL,
  `unit` varchar(15) NOT NULL,
  `variable_name` varchar(20) NOT NULL,
  `material_properties_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `process_parameters`
--

INSERT INTO `process_parameters` (`id`, `processes_id`, `name`, `unit`, `variable_name`, `material_properties_id`) VALUES
(1, 1, 'Werkstückdicke', 'mm', 'part_width', NULL),
(2, 1, 'Werkstücklänge', 'cm', 'part_length', NULL),
(3, 1, 'Fräsbreite', 'mm', 'milling_width', NULL),
(4, 1, 'Frästiefe', 'mm', 'milling_depth', NULL),
(5, 1, 'Spez. Schnittkraft', 'N/mm^1,5', 'k_c05', 2);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `process_solvers`
--

CREATE TABLE `process_solvers` (
  `id` int(11) NOT NULL,
  `code` mediumtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `process_solvers`
--

INSERT INTO `process_solvers` (`id`, `code`) VALUES
(1, 'def call_solver(model):\r\n    return internalsolve(model)\r\n\r\n\r\ndef internalsolve(model):\r\n    for key, value in model.items():\r\n        print (key, value)\r\n    return model\r\n');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `property_values`
--

CREATE TABLE `property_values` (
  `id` int(11) NOT NULL,
  `material_properties_id` int(11) NOT NULL,
  `value` double NOT NULL,
  `material` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `property_values`
--

INSERT INTO `property_values` (`id`, `material_properties_id`, `value`, `material`) VALUES
(1, 2, 22.5, 'MDF'),
(2, 2, 15, 'Spanplatte'),
(3, 2, 33, 'Buche'),
(4, 2, 33, 'Eiche'),
(5, 1, 0.68, 'Buche'),
(6, 1, 0.65, 'Eiche'),
(8, 7, 34, 'Buche'),
(11, 7, 34, 'Eiche');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `tree_questions`
--

CREATE TABLE `tree_questions` (
  `id` int(11) NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `parent_response` tinyint(1) NOT NULL,
  `variant_questions_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `tree_questions`
--

INSERT INTO `tree_questions` (`id`, `parent_id`, `parent_response`, `variant_questions_id`) VALUES
(4, NULL, 0, 1),
(5, 4, 1, 2),
(6, 4, 0, 3),
(7, 5, 1, 4),
(8, 6, 1, 4),
(9, 6, 0, 4),
(10, 5, 0, 5),
(11, 10, 1, 6),
(12, 11, 1, 7),
(13, 12, 0, 9),
(14, 11, 0, 8),
(15, 14, 0, 7),
(16, 10, 0, 6),
(17, 16, 1, 8),
(18, 17, 0, 9),
(19, 16, 0, 3),
(20, 19, 0, 4),
(21, 19, 1, 4),
(22, 21, 1, 8),
(23, 22, 0, 7),
(24, 21, 0, 10);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `variants`
--

CREATE TABLE `variants` (
  `id` int(11) NOT NULL,
  `processes_id` int(11) NOT NULL,
  `name` tinytext NOT NULL,
  `target_func` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `variants`
--

INSERT INTO `variants` (`id`, `processes_id`, `name`, `target_func`) VALUES
(1, 1, 'Leim mit Fugenziehen', ''),
(2, 1, 'Leim', ''),
(3, 1, 'Leim mit Schwabbel', ''),
(4, 1, 'Leim mit Fugenziehen und Schwabbel', ''),
(5, 1, 'Heißluft', ''),
(6, 1, 'Heißluft mit Fugenziehen', ''),
(7, 1, 'Fügefraser, Leim', ''),
(8, 1, 'Fügefraser, Leim mit Schwabbel', ''),
(9, 1, 'Fügefraser, Leim mit Eckenkopierer', ''),
(11, 1, 'Fügefraser, Leim mit Eckenkopierer und Schwabbel', ''),
(12, 1, 'Fügefraser, Leim mit Eckenkopierer, Ziehklinge und Schwabbel', ''),
(13, 1, 'Fügefraser, Leim mit Eckenkopierer, Ziehklinge und Eck-/Schwabbel', ''),
(14, 1, 'Fügefraser, Leim mit Eckenkopierer, Ziehklinge, Schwabbel und Nutfräse', ''),
(15, 1, 'Fügefraser, Leim mit Eckenkopierer, Bündigfräser', ''),
(16, 1, 'Fügefraser, Leim mit Eckenkopierer, Bündig- und Universalfräser', ''),
(17, 1, 'Fügefraser, Leim mit Eckenkopierer, Bündigfräser und Eckschwabbel', ''),
(18, 1, 'Laser', ''),
(19, 1, 'Laser mit Nutfräse', ''),
(20, 1, 'Laser mit Eckschwabbel', ''),
(21, 1, 'Laser mit Bündigfräser', ''),
(22, 1, 'Laser mit Bündig- und Universalfräser', ''),
(23, 1, 'Laser mit Bündigfräser und Eckschwabbel', '');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `variant_components`
--

CREATE TABLE `variant_components` (
  `id` int(11) NOT NULL,
  `variants_id` int(11) NOT NULL,
  `position` tinyint(3) UNSIGNED NOT NULL,
  `component_api_name` varchar(40) NOT NULL,
  `variable_name` varchar(30) NOT NULL,
  `description` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `variant_components`
--

INSERT INTO `variant_components` (`id`, `variants_id`, `position`, `component_api_name`, `variable_name`, `description`) VALUES
(1, 15, 1, 'motors', 'v_milling_motor', 'Fräsermotor'),
(2, 15, 2, 'motors', 'v_flush_motor', 'Bündigfräsermotor'),
(5, 15, 3, 'gears', 'v_milling_gear', 'Fräsergetriebe');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `variant_excludes`
--

CREATE TABLE `variant_excludes` (
  `id` int(11) NOT NULL,
  `variants_id` int(11) NOT NULL,
  `response` tinyint(1) NOT NULL,
  `processes_id` int(11) NOT NULL,
  `tree_questions_id` int(11) DEFAULT NULL,
  `variant_questions_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `variant_excludes`
--

INSERT INTO `variant_excludes` (`id`, `variants_id`, `response`, `processes_id`, `tree_questions_id`, `variant_questions_id`) VALUES
(1, 1, 1, 1, 4, NULL),
(3, 2, 1, 1, 4, NULL),
(4, 3, 1, 1, 4, NULL),
(5, 4, 1, 1, 4, NULL),
(6, 5, 0, 1, 4, NULL),
(7, 6, 0, 1, 4, NULL),
(8, 7, 0, 1, 4, NULL),
(9, 8, 0, 1, 4, NULL),
(10, 9, 0, 1, 4, NULL),
(11, 11, 0, 1, 4, NULL),
(12, 12, 0, 1, 4, NULL),
(13, 13, 0, 1, 4, NULL),
(14, 14, 0, 1, 4, NULL),
(15, 15, 0, 1, 4, NULL),
(16, 16, 0, 1, 4, NULL),
(17, 17, 0, 1, 4, NULL),
(18, 18, 0, 1, 4, NULL),
(19, 19, 0, 1, 4, NULL),
(20, 20, 0, 1, 4, NULL),
(21, 21, 0, 1, 4, NULL),
(22, 22, 0, 1, 4, NULL),
(23, 23, 0, 1, 4, NULL),
(24, 1, 1, 1, 6, NULL),
(25, 2, 1, 1, 6, NULL),
(26, 3, 0, 1, 6, NULL),
(27, 4, 0, 1, 6, NULL),
(28, 3, 1, 1, 8, NULL),
(29, 4, 0, 1, 8, NULL),
(30, 2, 1, 1, 9, NULL),
(31, 1, 0, 1, 9, NULL),
(32, 5, 0, 1, 5, NULL),
(33, 6, 0, 1, 5, NULL),
(34, 7, 1, 1, 5, NULL),
(35, 8, 1, 1, 5, NULL),
(36, 9, 1, 1, 5, NULL),
(37, 11, 1, 1, 5, NULL),
(38, 12, 1, 1, 5, NULL),
(39, 13, 1, 1, 5, NULL),
(40, 14, 1, 1, 5, NULL),
(41, 15, 1, 1, 5, NULL),
(42, 16, 1, 1, 5, NULL),
(43, 17, 1, 1, 5, NULL),
(44, 18, 1, 1, 5, NULL),
(45, 19, 1, 1, 5, NULL),
(46, 20, 1, 1, 5, NULL),
(47, 21, 1, 1, 5, NULL),
(48, 22, 1, 1, 5, NULL),
(49, 23, 1, 1, 5, NULL),
(50, 5, 1, 1, 7, NULL),
(51, 6, 0, 1, 7, NULL),
(52, 18, 0, 1, 10, NULL),
(53, 19, 0, 1, 10, NULL),
(54, 20, 0, 1, 10, NULL),
(55, 21, 0, 1, 10, NULL),
(56, 22, 0, 1, 10, NULL),
(57, 23, 0, 1, 10, NULL),
(58, 7, 1, 1, 10, NULL),
(59, 8, 1, 1, 10, NULL),
(60, 9, 1, 1, 10, NULL),
(61, 11, 1, 1, 10, NULL),
(62, 12, 1, 1, 10, NULL),
(63, 13, 1, 1, 10, NULL),
(64, 14, 1, 1, 10, NULL),
(65, 15, 1, 1, 10, NULL),
(66, 16, 1, 1, 10, NULL),
(67, 17, 1, 1, 10, NULL),
(68, 18, 1, 1, 11, NULL),
(69, 19, 1, 1, 11, NULL),
(70, 20, 1, 1, 11, NULL),
(71, 21, 0, 1, 11, NULL),
(72, 22, 0, 1, 11, NULL),
(73, 23, 0, 1, 11, NULL),
(74, 21, 1, 1, 12, NULL),
(75, 22, 1, 1, 12, NULL),
(76, 23, 0, 1, 12, NULL),
(77, 21, 1, 1, 13, NULL),
(78, 22, 0, 1, 13, NULL),
(79, 18, 1, 1, 14, NULL),
(80, 19, 1, 1, 14, NULL),
(81, 20, 0, 1, 14, NULL),
(82, 18, 1, 1, 15, NULL),
(83, 19, 0, 1, 15, NULL),
(84, 7, 1, 1, 16, NULL),
(85, 8, 1, 1, 16, NULL),
(86, 9, 1, 1, 16, NULL),
(87, 11, 1, 1, 16, NULL),
(88, 12, 1, 1, 16, NULL),
(89, 13, 1, 1, 16, NULL),
(90, 14, 1, 1, 16, NULL),
(91, 15, 0, 1, 16, NULL),
(92, 16, 0, 1, 16, NULL),
(93, 17, 0, 1, 16, NULL),
(94, 15, 1, 1, 17, NULL),
(95, 16, 1, 1, 17, NULL),
(96, 17, 0, 1, 17, NULL),
(97, 15, 1, 1, 18, NULL),
(98, 16, 0, 1, 18, NULL),
(99, 7, 1, 1, 19, NULL),
(100, 8, 1, 1, 19, NULL),
(101, 9, 0, 1, 19, NULL),
(102, 11, 0, 1, 19, NULL),
(103, 12, 0, 1, 10, NULL),
(104, 13, 0, 1, 19, NULL),
(105, 14, 0, 1, 19, NULL),
(106, 7, 1, 1, 20, NULL),
(107, 8, 0, 1, 20, NULL),
(108, 9, 1, 1, 21, NULL),
(109, 11, 1, 1, 21, NULL),
(110, 12, 0, 1, 21, NULL),
(111, 13, 0, 1, 21, NULL),
(112, 14, 0, 1, 21, NULL),
(113, 15, 0, 1, 21, NULL),
(114, 16, 0, 1, 21, NULL),
(115, 17, 0, 1, 21, NULL),
(116, 9, 1, 1, 24, NULL),
(117, 11, 0, 1, 24, NULL),
(118, 12, 1, 1, 22, NULL),
(119, 14, 1, 1, 22, NULL),
(120, 13, 0, 1, 21, NULL),
(121, 12, 1, 1, 23, NULL),
(122, 14, 0, 1, 23, NULL);

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `variant_questions`
--

CREATE TABLE `variant_questions` (
  `id` int(11) NOT NULL,
  `processes_id` int(11) NOT NULL,
  `question` tinytext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `variant_questions`
--

INSERT INTO `variant_questions` (`id`, `processes_id`, `question`) VALUES
(1, 1, 'Fügefräsen?'),
(2, 1, 'Heißluft?'),
(3, 1, 'Eckenkopieren?'),
(4, 1, 'Leimfugenziehen?'),
(5, 1, 'Laser?'),
(6, 1, 'Bündigfräsen?'),
(7, 1, 'Nutfräsen?'),
(8, 1, 'Eckschwabbeln?'),
(9, 1, 'Universalfräsen?'),
(10, 1, 'Schwabbeln?');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `variant_selection`
--

CREATE TABLE `variant_selection` (
  `id` int(11) NOT NULL,
  `processes_id` int(11) NOT NULL,
  `selection` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`selection`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `variant_selection`
--

INSERT INTO `variant_selection` (`id`, `processes_id`, `selection`) VALUES
(1, 1, '{\"list\": [], \"tree\": {\"no\": {\"excludes\": [5, 6, 7, 8, 9, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23], \"no\": {\"excludes\": [3, 4], \"no\": {\"excludes\": [1], \"no\": null, \"question\": null, \"yes\": null}, \"question\": \"Leimfugenziehen?\", \"yes\": {\"excludes\": [2], \"no\": null, \"question\": null, \"yes\": null}}, \"question\": \"Eckenkopieren?\", \"yes\": {\"excludes\": [1, 2], \"no\": {\"excludes\": [4], \"no\": null, \"question\": null, \"yes\": null}, \"question\": \"Leimfugenziehen?\", \"yes\": {\"excludes\": [3], \"no\": null, \"question\": null, \"yes\": null}}}, \"question\": \"F\\u00fcgefr\\u00e4sen?\", \"yes\": {\"excludes\": [1, 2, 3, 4], \"no\": {\"excludes\": [5, 6], \"no\": {\"excludes\": [18, 19, 20, 21, 22, 23, 12], \"no\": {\"excludes\": [15, 16, 17], \"no\": {\"excludes\": [9, 11, 13, 14], \"no\": {\"excludes\": [8], \"no\": null, \"question\": null, \"yes\": null}, \"question\": \"Leimfugenziehen?\", \"yes\": {\"excludes\": [7], \"no\": null, \"question\": null, \"yes\": null}}, \"question\": \"Eckenkopieren?\", \"yes\": {\"excludes\": [7, 8], \"no\": {\"excludes\": [12, 13, 14, 15, 16, 17, 13], \"no\": {\"excludes\": [11], \"no\": null, \"question\": null, \"yes\": null}, \"question\": \"Schwabbeln?\", \"yes\": {\"excludes\": [9], \"no\": null, \"question\": null, \"yes\": null}}, \"question\": \"Leimfugenziehen?\", \"yes\": {\"excludes\": [9, 11], \"no\": {\"excludes\": [], \"no\": {\"excludes\": [14], \"no\": null, \"question\": null, \"yes\": null}, \"question\": \"Nutfr\\u00e4sen?\", \"yes\": {\"excludes\": [12], \"no\": null, \"question\": null, \"yes\": null}}, \"question\": \"Eckschwabbeln?\", \"yes\": {\"excludes\": [12, 14], \"no\": null, \"question\": null, \"yes\": null}}}}, \"question\": \"B\\u00fcndigfr\\u00e4sen?\", \"yes\": {\"excludes\": [7, 8, 9, 11, 12, 13, 14], \"no\": {\"excludes\": [17], \"no\": {\"excludes\": [16], \"no\": null, \"question\": null, \"yes\": null}, \"question\": \"Universalfr\\u00e4sen?\", \"yes\": {\"excludes\": [15], \"no\": null, \"question\": null, \"yes\": null}}, \"question\": \"Eckschwabbeln?\", \"yes\": {\"excludes\": [15, 16], \"no\": null, \"question\": null, \"yes\": null}}}, \"question\": \"Laser?\", \"yes\": {\"excludes\": [7, 8, 9, 11, 12, 13, 14, 15, 16, 17], \"no\": {\"excludes\": [21, 22, 23], \"no\": {\"excludes\": [20], \"no\": {\"excludes\": [19], \"no\": null, \"question\": null, \"yes\": null}, \"question\": \"Nutfr\\u00e4sen?\", \"yes\": {\"excludes\": [18], \"no\": null, \"question\": null, \"yes\": null}}, \"question\": \"Eckschwabbeln?\", \"yes\": {\"excludes\": [18, 19], \"no\": null, \"question\": null, \"yes\": null}}, \"question\": \"B\\u00fcndigfr\\u00e4sen?\", \"yes\": {\"excludes\": [18, 19, 20], \"no\": {\"excludes\": [23], \"no\": {\"excludes\": [22], \"no\": null, \"question\": null, \"yes\": null}, \"question\": \"Universalfr\\u00e4sen?\", \"yes\": {\"excludes\": [21], \"no\": null, \"question\": null, \"yes\": null}}, \"question\": \"Nutfr\\u00e4sen?\", \"yes\": {\"excludes\": [21, 22], \"no\": null, \"question\": null, \"yes\": null}}}}, \"question\": \"Hei\\u00dfluft?\", \"yes\": {\"excludes\": [7, 8, 9, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23], \"no\": {\"excludes\": [6], \"no\": null, \"question\": null, \"yes\": null}, \"question\": \"Leimfugenziehen?\", \"yes\": {\"excludes\": [5], \"no\": null, \"question\": null, \"yes\": null}}}}}');

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `aggregate_components`
--
ALTER TABLE `aggregate_components`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `aggregate_parts`
--
ALTER TABLE `aggregate_parts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `aggregate_parts_components` (`aggregate_components_id`);

--
-- Indizes für die Tabelle `aggregate_variables`
--
ALTER TABLE `aggregate_variables`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `column_info`
--
ALTER TABLE `column_info`
  ADD PRIMARY KEY (`id`),
  ADD KEY `component_tables` (`component_id`);

--
-- Indizes für die Tabelle `components`
--
ALTER TABLE `components`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `component_gear`
--
ALTER TABLE `component_gear`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `component_motor`
--
ALTER TABLE `component_motor`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `gearblobs`
--
ALTER TABLE `gearblobs`
  ADD PRIMARY KEY (`gear_id`);

--
-- Indizes für die Tabelle `info_texts`
--
ALTER TABLE `info_texts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `info_ref_id` (`type_id`);

--
-- Indizes für die Tabelle `material_properties`
--
ALTER TABLE `material_properties`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `motorlobs`
--
ALTER TABLE `motorlobs`
  ADD PRIMARY KEY (`motor_id`);

--
-- Indizes für die Tabelle `processes`
--
ALTER TABLE `processes`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `process_parameters`
--
ALTER TABLE `process_parameters`
  ADD PRIMARY KEY (`id`),
  ADD KEY `processes_parameters` (`processes_id`),
  ADD KEY `process_parameters_properties` (`material_properties_id`);

--
-- Indizes für die Tabelle `process_solvers`
--
ALTER TABLE `process_solvers`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `property_values`
--
ALTER TABLE `property_values`
  ADD PRIMARY KEY (`id`),
  ADD KEY `properties_values` (`material_properties_id`);

--
-- Indizes für die Tabelle `tree_questions`
--
ALTER TABLE `tree_questions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tree_variant_questions` (`variant_questions_id`);

--
-- Indizes für die Tabelle `variants`
--
ALTER TABLE `variants`
  ADD PRIMARY KEY (`id`),
  ADD KEY `variants_process` (`processes_id`);

--
-- Indizes für die Tabelle `variant_components`
--
ALTER TABLE `variant_components`
  ADD PRIMARY KEY (`id`),
  ADD KEY `variant_components_variants` (`variants_id`);

--
-- Indizes für die Tabelle `variant_excludes`
--
ALTER TABLE `variant_excludes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `excludes_processes_id` (`processes_id`),
  ADD KEY `excludes_variants_id` (`variants_id`);

--
-- Indizes für die Tabelle `variant_questions`
--
ALTER TABLE `variant_questions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `variant_question_processes` (`processes_id`);

--
-- Indizes für die Tabelle `variant_selection`
--
ALTER TABLE `variant_selection`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `aggregate_components`
--
ALTER TABLE `aggregate_components`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `aggregate_parts`
--
ALTER TABLE `aggregate_parts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `aggregate_variables`
--
ALTER TABLE `aggregate_variables`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `column_info`
--
ALTER TABLE `column_info`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT für Tabelle `components`
--
ALTER TABLE `components`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT für Tabelle `component_gear`
--
ALTER TABLE `component_gear`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT für Tabelle `component_motor`
--
ALTER TABLE `component_motor`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT für Tabelle `info_texts`
--
ALTER TABLE `info_texts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT für Tabelle `material_properties`
--
ALTER TABLE `material_properties`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT für Tabelle `processes`
--
ALTER TABLE `processes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT für Tabelle `process_parameters`
--
ALTER TABLE `process_parameters`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT für Tabelle `property_values`
--
ALTER TABLE `property_values`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT für Tabelle `tree_questions`
--
ALTER TABLE `tree_questions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT für Tabelle `variants`
--
ALTER TABLE `variants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT für Tabelle `variant_components`
--
ALTER TABLE `variant_components`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT für Tabelle `variant_excludes`
--
ALTER TABLE `variant_excludes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=123;

--
-- AUTO_INCREMENT für Tabelle `variant_questions`
--
ALTER TABLE `variant_questions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT für Tabelle `variant_selection`
--
ALTER TABLE `variant_selection`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `aggregate_parts`
--
ALTER TABLE `aggregate_parts`
  ADD CONSTRAINT `aggregate_parts_components` FOREIGN KEY (`aggregate_components_id`) REFERENCES `aggregate_components` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `column_info`
--
ALTER TABLE `column_info`
  ADD CONSTRAINT `component_tables` FOREIGN KEY (`component_id`) REFERENCES `components` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `gearblobs`
--
ALTER TABLE `gearblobs`
  ADD CONSTRAINT `gearblob` FOREIGN KEY (`gear_id`) REFERENCES `component_gear` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `motorlobs`
--
ALTER TABLE `motorlobs`
  ADD CONSTRAINT `motorblob` FOREIGN KEY (`motor_id`) REFERENCES `component_motor` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `process_parameters`
--
ALTER TABLE `process_parameters`
  ADD CONSTRAINT `process_parameters_properties` FOREIGN KEY (`material_properties_id`) REFERENCES `material_properties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `processes_parameters` FOREIGN KEY (`processes_id`) REFERENCES `processes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `process_solvers`
--
ALTER TABLE `process_solvers`
  ADD CONSTRAINT `processes_processsolvers` FOREIGN KEY (`id`) REFERENCES `processes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `property_values`
--
ALTER TABLE `property_values`
  ADD CONSTRAINT `properties_values` FOREIGN KEY (`material_properties_id`) REFERENCES `material_properties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `tree_questions`
--
ALTER TABLE `tree_questions`
  ADD CONSTRAINT `tree_variant_questions` FOREIGN KEY (`variant_questions_id`) REFERENCES `variant_questions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `variants`
--
ALTER TABLE `variants`
  ADD CONSTRAINT `variants_processes` FOREIGN KEY (`processes_id`) REFERENCES `processes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `variant_components`
--
ALTER TABLE `variant_components`
  ADD CONSTRAINT `variant_components` FOREIGN KEY (`variants_id`) REFERENCES `variants` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `variant_questions`
--
ALTER TABLE `variant_questions`
  ADD CONSTRAINT `variant_question_processes` FOREIGN KEY (`processes_id`) REFERENCES `processes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
