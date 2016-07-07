

create table if not exists samplesheet (
  `sample_id` varchar(45) not null,
  `lane` int null,
  `sample_name` varchar(45) null,
  `sample_plate` varchar(45) null,
  `sample_well` varchar(45) null,
  `i7_index_id` varchar(45) null,
  `index` varchar(45) null,
  `sample_project` varchar(45) null,
  `description` varchar(45) null,
  `run_id` varchar(45) not null ) default character set = utf8;
  
create table if not exists runfolder (
	dt datetime not null,
  `run_id` varchar(45) not null,  
  primary key (`run_id`))
default character set = utf8;

create table if not exists runinfo (
  `run_id` varchar(45) not null,
  `number` integer null,
  `flowcell` varchar(45) null,
  `instrument` varchar(45) null,
  `date` date null,
  `lanecount` varchar(45) null,
  `surfacecount` varchar(45) null,
  `read_id` integer not null,
  primary key (`run_id`))
default character set = utf8;


create table if not exists runinforead (
  `read_id` integer not null,
  `number` integer null,
  `numcycles` integer null,
  `isindexedread` varchar(1) null,
  primary key (`read_id`))
default character set = utf8;



