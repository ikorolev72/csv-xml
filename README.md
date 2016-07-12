#						CSV-XML parser 


##  What is it?
##  -----------
Perl application for parse files in specified folder. 
Files format: csv, xml and html.
File names: runParameters.xml, First_Base_Report.htm, RunInfo.xml, SampleSheet.csv
Files found in dirs with mask `^\d{6}_\w\d{5}_\d{4}_\w{10}$` ( For example `160221_D00427_0078_AHJ7M7BCXX` ).



##  The Latest Version

	version 1.0 2016.07.12
	
##  Whats new

	First release
	

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

		
##  Running
There are several scripts:
Script or file  | Description
----------------|----------------------
parser_all.pl   | main script, search new dirs in runfolder, parse all files in such dirs and insert data into database 
parser_first_base_report.pl | script parse First_Base_Report.htm in folder ( folder defined by parameter --id=runId ) and insert data into database 
parser_runid.pl | script search new folders in your RunFolder and insert data into database 
parser_runinfo.pl | script parse RunInfo.xml in folder ( folder defined by parameter --id=runId ) and insert data into database 
parser_runparameter.pl | script parse runParameters.xml in folder ( folder defined by parameter --id=runId ) and insert data into database 
parser_samplesheet.pl | script parse SampleSheet.csv in folder ( folder defined by parameter --id=runId ) and insert data into database 
clear_all.pl | WARNING!!! This script clear all data in your tables!!! Use for testing only!!!!
create_tables.sql | sql you can use for make requred tables in your database
PARS16.pm | common used variable and function for this project
log/pars16.log | log file



## Known bugs

 
  Licensing
  ---------
	GNU

  Contacts
  --------

     o korolev-ia [at] yandex.ru
     o http://www.unixpin.com

	 