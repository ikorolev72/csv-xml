-- Create tables !!!!
-- 


CREATE TABLE sequ (id int);  
INSERT INTO sequ (id) VALUES (1);



create table if not exists samplesheet (
  `sample_id` varchar(45) not null,
  `lane` int null,
  `sample_name` varchar(45) null,
  `sample_plate` varchar(45) null,
  `sample_well` varchar(45) null,
  `i7_index_id` varchar(45) null,
  `index0` varchar(45) null,
  `sample_project` varchar(45) null,
  `description` varchar(45) null,
  `run_id` varchar(45) not null ) default character set = utf8;
  
create table if not exists runfolder (
	dt datetime not null,
  `run_id` varchar(45) not null,  
  primary key (`run_id`))
default character set = utf8;

create table if not exists runinfo (
  `number0` integer null,
  `flowcell` varchar(45) null,
  `instrument` varchar(45) null,
  `date0` date null,
  `lanecount` integer null,
  `surfacecount` integer null,
  `swathcount` integer null,
  `tilecount` integer null,
  `read_id` integer not null,
  `run_id` varchar(45) not null,
  primary key (`run_id`))
default character set = utf8;


create table if not exists readtable (
  `number0` integer null,
  `numcycles` integer null,
  `isindexedread` varchar(1) null,
  `read_id` integer not null)
default character set = utf8;

create table if not exists selecttable (
  `name` varchar(45) null,
  `select_id` integer not null )
default character set = utf8;


create table if not exists runparameter (
`run_id` varchar(45) not null,
`recipefragmentversion` varchar(45) null,
`flowcell` varchar(45) null,
`remapqscores` varchar(45) null,
`computername` varchar(45) null,
`sbs0` varchar(45) null,
`performprerunfluidicscheck` boolean,
`experimentname` varchar(45) null,
`numtilesperswath` integer null,
`cpldversion` varchar(45) null,
`clusteringchoice` varchar(45) null,
`resumecycle` integer null,
`mockrun` boolean,
`periodicsave` varchar(45) null,
`areaperpixelmm2` varchar(45) null,
`swathscanmode` varchar(45) null,
`username0` varchar(45) null,
`scannedbarcode` varchar(45) null,
`tempfolder0` varchar(254) null,
`read1` integer null,
`firstbaseconfirmation` boolean,
`enableanalysis` boolean,
`compressbcls` boolean,
`indexread2` integer null,
`promptforpereagents` boolean,
`samplesheet` varchar(254) null,
`outputfolder` varchar(254) null,
`motordelayframes` integer null,
`maxsubsequentzjumphalfum` integer null,
`maxinitialzjumphalfum` integer null,
`numberofinitialzjumps` integer null,
`groupsize` integer null,
`cvgainstart` integer null,
`igain` integer null,
`hotpixel` integer null,
`offset` integer null,
`dithersize` integer null,
`ihistory` integer null,
`cvgainposlocked` integer null,
`dithershift` integer null,
`softwarelaserlag` integer null,
`intensityceiling` integer null,
`index0` varchar(45) null,
`applicationversion` varchar(45) null,
`indexread1` integer null,
`templatecyclecount` integer null,
`enablenotifications` boolean,
`numanalysisthreads` integer null,
`resume` boolean,
`slideholder` varchar(45) null,
`pairendfc` boolean,
`runmode` varchar(45) null,
`focuscamerafirmware` varchar(45) null,
`integrationmode` varchar(45) null,
`cameradriver` varchar(45) null,
`fcposition` varchar(45) null,
`selectedsurface` varchar(45) null,
`enablecameralogging` boolean,
`camerafirmware` varchar(45) null,
`rehyb0` varchar(45) null,
`autotiltonce` boolean,
`rapidrunchemistry` varchar(45) null,
`imageheight` integer null,
`chemistryversion` varchar(45) null,
`enableautocenter` boolean,
`applicationname` varchar(45) null,
`focusmethod` varchar(45) null,
`rtaversion` varchar(45) null,
`scannumber` integer null,
`imagewidth` integer null,
`enablebasecalling` boolean,
`supportmultiplesurfacesinui` boolean,
`enablelft` boolean,
`runid1` integer null,
`username1` varchar(45) null,
`runmonitoringonly` boolean,
`sendinstrumenthealthtoilmn` boolean,
`tempfolder1` varchar(254) null,
`plannedrun` boolean,
`workflowtype` varchar(45) null,
`barcode` varchar(45) null,
`tileheight` integer null,
`fpgaversion` varchar(45) null,
`adapterplate` varchar(45) null,
`pe0` varchar(45) null,
`numswaths` integer null,
`scannerid` varchar(45) null,
`aligntophix` varchar(45) null,
`scanid` varchar(45) null,
`washbarcode` varchar(45) null,
`isnew200cycle` boolean,
`id0` varchar(45) null,
`isnew50cycle` boolean,
`numbercyclesremaining` integer null,
`prime` boolean,
`isnew500cycle` boolean,
`rehyb1` varchar(45) null,
`pe1` varchar(45) null,
`id1` varchar(45) null,
`keepintensityfiles` boolean,
`tilewidth` integer null,
`sbs1` varchar(45) null,
`useexistingrecipe` boolean,
`runstartdate` integer null,
`servicerun` boolean,
`lanelength` integer null,
`read2` integer null,
`read_id` integer not null,
`select_id` integer not null,
  primary key (`run_id`))
default character set = utf8;




create table if not exists first_base_report (
  `run_id` varchar(45) not null,
  `top_id` integer not null,
  `bottom_id` integer not null,
  primary key (`run_id`)  
  )
default character set = utf8;


create table if not exists surface (
  `surface_id` integer not null,
  `id` integer not null,
  `metric` varchar(45) null,
  `lane1` float null,
  `lane2` float null,
  `lane3` float null,
  `lane4` float null,
  `lane5` float null,
  `lane6` float null,
  `lane7` float null,
  `lane8` float null,
  primary key (`id`)  
  )
default character set = utf8;




