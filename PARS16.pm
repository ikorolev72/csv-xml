# common variables and functions
# korolev-ia [at] yandex.ru
# version 1.0 2016.07.05


use DBI;
use Data::Dumper;
# use JSON;
use Getopt::Long;


$Paths->{HOME}='/opt/csv-xml';
if( -d 'c:\git\csv-xml' ) { 
	$Paths->{HOME}='c:\git\csv-xml';
}

$Paths->{RUNFOLDER}="$Paths->{HOME}/data";
$Paths->{LOG}="$Paths->{HOME}/log/pars16.log";

$Columns->{SAMPLESHEET}=qw ( Lane Sample_ID Sample_Name Sample_Plate Sample_Well I7_Index_ID index Sample_Project Description run_id ) ;
$Columns->{RUNFOLDER}=qw ( dt run_id ) ;

$DB->{dsn}="DBI:mysql:NGS_LIMS";
$DB->{user}="root";
$DB->{password}="igor123";



sub db_connect {
my $dsn      = $DB->{dsn};
my $user     = $DB->{user};
my $password = $DB->{password};

my $dbh = DBI->connect($dsn, $user, $password, {
   PrintError       => 0,
   RaiseError       => 1,
   AutoCommit       => 1,
   FetchHashKeyName => 'NAME_lc',
}) or w2log( "Cannot connect to database : $DBI::errstr" );
return $dbh;
}



sub db_disconnect {
	my $dbh=shift;
	$dbh->disconnect;
}


sub get_date {
	my $time=shift() || time();
	my $format=shift || "%s-%.2i-%.2i %.2i:%.2i:%.2i";
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime($time);
	$year+=1900;$mon++;
    return sprintf( $format,$year,$mon,$mday,$hour,$min,$sec);
}	


sub w2log {
	my $msg=shift;
	open (LOG,">>$Paths->{LOG}") || print ("Can't open file $Paths->{LOG}. $msg") ;
	print LOG get_date()."\t$msg\n";
	print STDERR $msg;
	close (LOG);
}


sub db_connect {
	
my $dbfile = "$Paths->{DB}/sqlite.db"; 
my $dsn      = "dbi:SQLite:dbname=$dbfile";
my $user     = "";
my $password = "";

my $dbh = DBI->connect($dsn, $user, $password, {
   PrintError       => 0,
   RaiseError       => 1,
   AutoCommit       => 1,
   FetchHashKeyName => 'NAME_lc',
}) or w2log ( "Cannot connect to database : $DBI::errstr" );
return $dbh;
}

sub db_disconnect {
	my $dbh=shift;
	$dbh->disconnect;
}

sub GetRecord {
	my $dbh=shift;
	my $id=shift;
	my $table=shift;
	#my $fields=shift || '*';
	my $stmt ="SELECT * from $table where id = ? ;";
	my $sth = $dbh->prepare( $stmt );
	my $rv;
	unless ( $rv = $sth->execute( $id ) || $rv < 0 ) {
		message2 ( "Someting wrong with database  : $DBI::errstr" );
		w2log ( "Sql( $stmt ) Someting wrong with database  : $DBI::errstr" );
		return 0;
	}
	return ( $sth->fetchrow_hashref );	
}

sub GetNextSequence {
	my $dbh=shift;
	my $table='sequ';
	my $stmt ="update $table set id=id+1; ";
	my $sth = $dbh->prepare( $stmt );
	my $rv;
	unless ( $rv = $sth->execute( ) || $rv < 0 ) {
		message2 ( "Someting wrong with database  : $DBI::errstr" );
		w2log ( "Sql( $stmt ) Someting wrong with database  : $DBI::errstr" );
		return 0;
	}
	$stmt ="select id from $table";
	$sth = $dbh->prepare( $stmt );
	unless ( $rv = $sth->execute(  ) || $rv < 0 ) {
		message2 ( "Someting wrong with database  : $DBI::errstr" );
		w2log ( "Sql( $stmt ) Someting wrong with database  : $DBI::errstr" );
		return 0;
	}
	my $row=$sth->fetchrow_hashref;
	return ( $row->{id} );	
}


sub InsertRecord {
	my $dbh=shift;
	my $stmt=shift; # sql
	my $row=shift; # data
	my $sth = $dbh->prepare( $stmt );
	my $rv;
	unless ( $rv = $sth->execute( @{$row} )  || $rv < 0  ) {
		w2log ( "Sql( $stmt ). Someting wrong with database  : $DBI::errstr" );
		return 0;
	}
	return ( 1 );	
}



sub ReadFile {
	my $filename=shift;
	my $ret="";
	open (IN,"$filename") || w2log("Can't open file $filename") ;
		while (<IN>) { $ret.=$_; }
	close (IN);
	return $ret;
}	

sub WriteFile {
	my $filename=shift;
	my $body=shift;
	unless( open (OUT,">$filename")) { w2log("Can't open file $filename for write" ) ;return 0; }
	print OUT $body;
	close (OUT);
	return 1;
}	

sub AppendFile {
	my $filename=shift;
	my $body=shift;
	unless( open (OUT,">>$filename")) { w2log("Can't open file $filename for append" ) ;return 0; }
	print OUT $body;
	close (OUT);
	return 1;
}

