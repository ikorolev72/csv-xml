

CREATE TABLE IF NOT EXISTS SampleSheet (
  `Sample_ID` VARCHAR(45) NOT NULL,
  `Lane` INT NULL,
  `Sample_Name` VARCHAR(45) NULL,
  `Sample_Plate` VARCHAR(45) NULL,
  `Sample_Well` VARCHAR(45) NULL,
  `I7_Index_ID` VARCHAR(45) NULL,
  `index` VARCHAR(45) NULL,
  `Sample_Project` VARCHAR(45) NULL,
  `Description` VARCHAR(45) NULL,
  `Run_ID` VARCHAR(45) NOT NULL ) DEFAULT CHARACTER SET = utf8;
  
CREATE TABLE IF NOT EXISTS Runfolder (
	dt DATETIME not null,
  `Run_ID` VARCHAR(45) NOT NULL,  
  PRIMARY KEY (`Run_ID`))
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS RunInfo (
  `Run_ID` VARCHAR(45) NOT NULL,
  `Number` integer NULL,
  `Flowcell` VARCHAR(45) NULL,
  `Instrument` VARCHAR(45) NULL,
  `Date` date NULL,
  `LaneCount` VARCHAR(45) NULL,
  `SurfaceCount` VARCHAR(45) NULL,
  `Read_id` integer not NULL,
  PRIMARY KEY (`Run_ID`))
DEFAULT CHARACTER SET = utf8;


CREATE TABLE IF NOT EXISTS RunInfoRead (
  `Read_ID` integer NOT NULL,
  `Number` integer NULL,
  `NumCycles` integer NULL,
  `IsIndexedRead` VARCHAR(1) NULL,
  PRIMARY KEY (`Read_ID`))
DEFAULT CHARACTER SET = utf8;



