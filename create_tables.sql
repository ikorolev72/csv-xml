-- phpMyAdmin SQL Dump
-- version 4.5.4.1deb2ubuntu2
-- http://www.phpmyadmin.net
--
-- Хост: localhost
-- Время создания: Июл 12 2016 г., 15:41
-- Версия сервера: 5.7.12-0ubuntu1.1
-- Версия PHP: 7.0.4-7ubuntu2.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `unixpinc_NGS_LIMS`
--

-- --------------------------------------------------------

--
-- Структура таблицы `first_base_report`
--

CREATE TABLE `first_base_report` (
  `run_id` varchar(45) NOT NULL,
  `top_id` int(11) NOT NULL,
  `bottom_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `readtable`
--

CREATE TABLE `readtable` (
  `number0` int(11) DEFAULT NULL,
  `numcycles` int(11) DEFAULT NULL,
  `isindexedread` varchar(1) DEFAULT NULL,
  `read_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `runfolder`
--

CREATE TABLE `runfolder` (
  `dt` datetime NOT NULL,
  `run_id` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `runinfo`
--

CREATE TABLE `runinfo` (
  `number0` int(11) DEFAULT NULL,
  `flowcell` varchar(45) DEFAULT NULL,
  `instrument` varchar(45) DEFAULT NULL,
  `date0` date DEFAULT NULL,
  `lanecount` int(11) DEFAULT NULL,
  `surfacecount` int(11) DEFAULT NULL,
  `swathcount` int(11) DEFAULT NULL,
  `tilecount` int(11) DEFAULT NULL,
  `read_id` int(11) NOT NULL,
  `run_id` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `runparameter`
--

CREATE TABLE `runparameter` (
  `run_id` varchar(45) NOT NULL,
  `recipefragmentversion` varchar(45) DEFAULT NULL,
  `flowcell` varchar(45) DEFAULT NULL,
  `remapqscores` varchar(45) DEFAULT NULL,
  `computername` varchar(45) DEFAULT NULL,
  `sbs0` varchar(45) DEFAULT NULL,
  `performprerunfluidicscheck` tinyint(1) DEFAULT NULL,
  `experimentname` varchar(45) DEFAULT NULL,
  `numtilesperswath` int(11) DEFAULT NULL,
  `cpldversion` varchar(45) DEFAULT NULL,
  `clusteringchoice` varchar(45) DEFAULT NULL,
  `resumecycle` int(11) DEFAULT NULL,
  `mockrun` tinyint(1) DEFAULT NULL,
  `periodicsave` varchar(45) DEFAULT NULL,
  `areaperpixelmm2` varchar(45) DEFAULT NULL,
  `swathscanmode` varchar(45) DEFAULT NULL,
  `username0` varchar(45) DEFAULT NULL,
  `scannedbarcode` varchar(45) DEFAULT NULL,
  `tempfolder0` varchar(254) DEFAULT NULL,
  `read1` int(11) DEFAULT NULL,
  `firstbaseconfirmation` tinyint(1) DEFAULT NULL,
  `enableanalysis` tinyint(1) DEFAULT NULL,
  `compressbcls` tinyint(1) DEFAULT NULL,
  `indexread2` int(11) DEFAULT NULL,
  `promptforpereagents` tinyint(1) DEFAULT NULL,
  `samplesheet` varchar(254) DEFAULT NULL,
  `outputfolder` varchar(254) DEFAULT NULL,
  `motordelayframes` int(11) DEFAULT NULL,
  `maxsubsequentzjumphalfum` int(11) DEFAULT NULL,
  `maxinitialzjumphalfum` int(11) DEFAULT NULL,
  `numberofinitialzjumps` int(11) DEFAULT NULL,
  `groupsize` int(11) DEFAULT NULL,
  `cvgainstart` int(11) DEFAULT NULL,
  `igain` int(11) DEFAULT NULL,
  `hotpixel` int(11) DEFAULT NULL,
  `offset` int(11) DEFAULT NULL,
  `dithersize` int(11) DEFAULT NULL,
  `ihistory` int(11) DEFAULT NULL,
  `cvgainposlocked` int(11) DEFAULT NULL,
  `dithershift` int(11) DEFAULT NULL,
  `softwarelaserlag` int(11) DEFAULT NULL,
  `intensityceiling` int(11) DEFAULT NULL,
  `index0` varchar(45) DEFAULT NULL,
  `applicationversion` varchar(45) DEFAULT NULL,
  `indexread1` int(11) DEFAULT NULL,
  `templatecyclecount` int(11) DEFAULT NULL,
  `enablenotifications` tinyint(1) DEFAULT NULL,
  `numanalysisthreads` int(11) DEFAULT NULL,
  `resume` tinyint(1) DEFAULT NULL,
  `slideholder` varchar(45) DEFAULT NULL,
  `pairendfc` tinyint(1) DEFAULT NULL,
  `runmode` varchar(45) DEFAULT NULL,
  `focuscamerafirmware` varchar(45) DEFAULT NULL,
  `integrationmode` varchar(45) DEFAULT NULL,
  `cameradriver` varchar(45) DEFAULT NULL,
  `fcposition` varchar(45) DEFAULT NULL,
  `selectedsurface` varchar(45) DEFAULT NULL,
  `enablecameralogging` tinyint(1) DEFAULT NULL,
  `camerafirmware` varchar(45) DEFAULT NULL,
  `rehyb0` varchar(45) DEFAULT NULL,
  `autotiltonce` tinyint(1) DEFAULT NULL,
  `rapidrunchemistry` varchar(45) DEFAULT NULL,
  `imageheight` int(11) DEFAULT NULL,
  `chemistryversion` varchar(45) DEFAULT NULL,
  `enableautocenter` tinyint(1) DEFAULT NULL,
  `applicationname` varchar(45) DEFAULT NULL,
  `focusmethod` varchar(45) DEFAULT NULL,
  `rtaversion` varchar(45) DEFAULT NULL,
  `scannumber` int(11) DEFAULT NULL,
  `imagewidth` int(11) DEFAULT NULL,
  `enablebasecalling` tinyint(1) DEFAULT NULL,
  `supportmultiplesurfacesinui` tinyint(1) DEFAULT NULL,
  `enablelft` tinyint(1) DEFAULT NULL,
  `runid1` int(11) DEFAULT NULL,
  `username1` varchar(45) DEFAULT NULL,
  `runmonitoringonly` tinyint(1) DEFAULT NULL,
  `sendinstrumenthealthtoilmn` tinyint(1) DEFAULT NULL,
  `tempfolder1` varchar(254) DEFAULT NULL,
  `plannedrun` tinyint(1) DEFAULT NULL,
  `workflowtype` varchar(45) DEFAULT NULL,
  `barcode` varchar(45) DEFAULT NULL,
  `tileheight` int(11) DEFAULT NULL,
  `fpgaversion` varchar(45) DEFAULT NULL,
  `adapterplate` varchar(45) DEFAULT NULL,
  `pe0` varchar(45) DEFAULT NULL,
  `numswaths` int(11) DEFAULT NULL,
  `scannerid` varchar(45) DEFAULT NULL,
  `aligntophix` varchar(45) DEFAULT NULL,
  `scanid` varchar(45) DEFAULT NULL,
  `washbarcode` varchar(45) DEFAULT NULL,
  `isnew200cycle` tinyint(1) DEFAULT NULL,
  `id0` varchar(45) DEFAULT NULL,
  `isnew50cycle` tinyint(1) DEFAULT NULL,
  `numbercyclesremaining` int(11) DEFAULT NULL,
  `prime` tinyint(1) DEFAULT NULL,
  `isnew500cycle` tinyint(1) DEFAULT NULL,
  `rehyb1` varchar(45) DEFAULT NULL,
  `pe1` varchar(45) DEFAULT NULL,
  `id1` varchar(45) DEFAULT NULL,
  `keepintensityfiles` tinyint(1) DEFAULT NULL,
  `tilewidth` int(11) DEFAULT NULL,
  `sbs1` varchar(45) DEFAULT NULL,
  `useexistingrecipe` tinyint(1) DEFAULT NULL,
  `runstartdate` int(11) DEFAULT NULL,
  `servicerun` tinyint(1) DEFAULT NULL,
  `lanelength` int(11) DEFAULT NULL,
  `read2` int(11) DEFAULT NULL,
  `read_id` int(11) NOT NULL,
  `select_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `samplesheet`
--

CREATE TABLE `samplesheet` (
  `sample_id` varchar(45) NOT NULL,
  `lane` int(11) DEFAULT NULL,
  `sample_name` varchar(45) DEFAULT NULL,
  `sample_plate` varchar(45) DEFAULT NULL,
  `sample_well` varchar(45) DEFAULT NULL,
  `i7_index_id` varchar(45) DEFAULT NULL,
  `index0` varchar(45) DEFAULT NULL,
  `sample_project` varchar(45) DEFAULT NULL,
  `description` varchar(45) DEFAULT NULL,
  `run_id` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `selecttable`
--

CREATE TABLE `selecttable` (
  `name` varchar(45) DEFAULT NULL,
  `select_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Структура таблицы `sequ`
--

CREATE TABLE `sequ` (
  `id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `sequ`
--

INSERT INTO `sequ` (`id`) VALUES
(1);

-- --------------------------------------------------------

--
-- Структура таблицы `surface`
--

CREATE TABLE `surface` (
  `surface_id` int(11) NOT NULL,
  `id` int(11) NOT NULL,
  `metric` varchar(45) DEFAULT NULL,
  `lane1` float DEFAULT NULL,
  `lane2` float DEFAULT NULL,
  `lane3` float DEFAULT NULL,
  `lane4` float DEFAULT NULL,
  `lane5` float DEFAULT NULL,
  `lane6` float DEFAULT NULL,
  `lane7` float DEFAULT NULL,
  `lane8` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `first_base_report`
--
ALTER TABLE `first_base_report`
  ADD PRIMARY KEY (`run_id`);

--
-- Индексы таблицы `runfolder`
--
ALTER TABLE `runfolder`
  ADD PRIMARY KEY (`run_id`);

--
-- Индексы таблицы `runinfo`
--
ALTER TABLE `runinfo`
  ADD PRIMARY KEY (`run_id`);

--
-- Индексы таблицы `runparameter`
--
ALTER TABLE `runparameter`
  ADD PRIMARY KEY (`run_id`);

--
-- Индексы таблицы `surface`
--
ALTER TABLE `surface`
  ADD PRIMARY KEY (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
