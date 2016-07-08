

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


create table if not exists runinforead (
  `number0` integer null,
  `numcycles` integer null,
  `isindexedread` varchar(1) null,
  `read_id` integer not null,
  primary key (`read_id`))
default character set = utf8;



