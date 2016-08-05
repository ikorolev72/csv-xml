#						CSV-XML parser 


##  What is it?
##  -----------
Perl application for parse files in specified folder. 
Files format: csv, xml and html.
File names: runParameters.xml, First_Base_Report.htm, RunInfo.xml, SampleSheet.csv
Files found in dirs with mask `^\d{6}_\w\d{5}_\d{4}_\w{10}$` ( For example `160221_D00427_0078_AHJ7M7BCXX` ).



##  The Latest Version

	version 1.1 2016.08.05
	
##  Whats new

Fixed hash value in table runparameters with nonexisting strings.
	

##  Installation
Application require next perl modules:
```
use DBI;
use Getopt::Long;
use HTML::TokeParser;
use XML::Simple;
use Text::CSV;
```
You can install modules by any usefull way, for example by `cpan` command, or `ppm` (for AS perl), and so on.

Installation steps:

1.  make 'home' directory for application `mkdir /opt/csv-xml`
2.  untar pars16.tar in this directory `tar -x -C /opt/csv-xml -f pars16.tar`
3. With any editor change in the file PARS16.pm next variables:

		```
		$Paths->{HOME}='/opt/csv-xml'; # the 'home' application
		$Paths->{RUNFOLDER}="$Paths->{HOME}/data"; # Your RunFolder with data
		$Paths->{LOG}="$Paths->{HOME}/log/pars16.log"; # define your log file

		$DB->{dsn}="DBI:mysql:database=unixpinc_NGS_LIMS;host=localhost;port=3306"; # Your database, host and port
		$DB->{user}="root"; # your database user
		$DB->{password}="root123";	# database user password
		```
4. Open `Mysql workbench` or `phpmyadmin`, or command line mysql and execute file `create_tables.sql` in your database.
5. Run the programm `cd /opt/csv-xml; ./parser_all.pl`
		
##  Running
There are several scripts:

|Script or file  | Description|
|----------------|----------------------|
|parser_all.pl   | main script, search new dirs in runfolder, parse all files in such dirs and insert data into database |
|parser_first_base_report.pl | script parse First_Base_Report.htm in folder ( folder defined by parameter --id=runId ) and insert data into database |
|parser_runid.pl | script search new folders in your RunFolder and insert data into database |
|parser_runinfo.pl | script parse RunInfo.xml in folder ( folder defined by parameter --id=runId ) and insert data into database |
|parser_runparameter.pl | script parse runParameters.xml in folder ( folder defined by parameter --id=runId ) and insert data into database |
|parser_samplesheet.pl | script parse SampleSheet.csv in folder ( folder defined by parameter --id=runId ) and insert data into database |
|clear_all.pl | WARNING!!! This script clear all data in your tables!!! Use for testing only!!!!|
|create_tables.sql | sql you can use for make requred tables in your database|
|PARS16.pm | common used variable and function for this project|
|log/pars16.log | log file|


## How to add cron tasks
If you need start this script periodicly you need add next line in cron with `crontab -e`
For start the task every Saturday in 23-30 
```
30	23	*	*	6	/opt/csv-xml/parser_all.pl > /dev/null 2>&1
```
For start the task every day in 23-30 
```
30	23	*	*	*	/opt/csv-xml/parser_all.pl > /dev/null 2>&1
```



## How to select parsed data from tables
### RunFolder 
Folder name in RunFolder is unique ID for  files of project.
Folder name inserted into table `runfolder` as `run_id`.
SQL sample: 
```
select * from runfolder where run_id='160221_D00427_0078_AHJ7M7BCXX';
```

### runParameters.xml
File runParameters.xml parsed into tables `runparameter` and  `readtable`.
Unique key for `runparameter` is `run_id`, multiple records from xml  'Read' tag inserts into 
table `readtable` and aviable with key `read_id`.
SQL sample:
```
select a.run_id, a.computername, a.barcode, b.* from runparameter a, readtable b where a.run_id='160221_D00427_0078_AHJ7M7BCXX' and a.read_id=b.read_id ;
```

### RunInfo.xml
File RunInfo.xml parsed into tables `runinfo` and  `readtable`.
Unique key for `runparameter` is `run_id`, multiple records from xml  'Read' tag inserts into 
table `readtable` and aviable with key `read_id`.
SQL sample: 
```
select a.*, b.* from runinfo a, readtable b where a.run_id='160221_D00427_0078_AHJ7M7BCXX' and a.read_id=b.read_id ;
```


### SampleSheet.csv
File SampleSheet.csv parsed into table `samplesheet`.
Any record from table can be selected by `run_id`, `sample_id` and `lane`.
SQL sample: 
```
select a.* from samplesheet a where a.run_id='160221_D00427_0078_AHJ7M7BCXX' ;
select a.* from samplesheet a where a.run_id='160221_D00427_0078_AHJ7M7BCXX' and sample_id=15;
select a.* from samplesheet a where a.run_id='160221_D00427_0078_AHJ7M7BCXX' and sample_id=15 and lane=1 ;
```


### First_Base_Report.htm
File First_Base_Report.htm parsed into tables `first_base_report` and `surface`.
Every record can be selected by run_id . 
SQL sample: 
```
select 'Top Surface', a.*, b.* from first_base_report a, surface b  where a.run_id='160315_D00427_0082_AHKJ7FBCXX' and b.surface_id=a.top_id ;
select 'Bottom Surface', a.*, b.* from first_base_report a, surface b  where a.run_id='160315_D00427_0082_AHKJ7FBCXX' and b.surface_id=a.bottom_id ;
select a.*, b.* from first_base_report a, surface b where a.run_id='160617_D00427_0099_BC8TF3ANXX' and b.surface_id=a.top_id or b.surface_id=a.bottom_id 
```



## Known bugs

 
  Licensing
  ---------
	GNU

  Contacts
  --------

     o korolev-ia [at] yandex.ru
     o http://www.unixpin.com

	 