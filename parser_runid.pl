#!/usr/bin/perl
# korolev-ia [at] yandex.ru
# version 1.0 2016.07.05
##############################

# The first table should consist all the Run_IDs which are the names of the Runfolder.
# So the first table to generate is a list of the folder names (Runfolder) in the working directory.
# The first script should go through the working directory, print every folder name and should
# insert the list into the sql database. Run ids should be primary keys and are unique. 

use PARS16;

GetOptions (
        'new|n' => \$new,
        "help|h|?"  => \$help ) or show_help();

show_help() if($help);

$globmask='^\d{6}_\w\d{5}_\d{4}_\w{10}$' ;

my $dir=$Paths->{RUNFOLDER};
my @ls;
opendir(DIR, $dir) || w2log( "can't opendir $dir: $!" );
	@ls=grep { /$globmask/ && -d "$dir/$_" } readdir(DIR) ;
closedir DIR;



my $dbh=db_connect( ) ;
exit ( 3 ) unless( $dbh );

my $stmt ="SELECT run_id from RUNFOLDER ;";
my $sth = $dbh->prepare( $stmt );
my $rv;
	unless ( $rv = $sth->execute( $value ) || $rv < 0 ) {
		w2log ( "Sql( $stmt ) Someting wrong with database  : $DBI::errstr" );
		exit(4);
	}

	
my $sql;
my $table='RUNFOLDER';
while ( my $hrow=$sth->fetchrow_hashref ){
	next if ( grep{ /^$hrow->{row_id}$/ } @ls ) ;
	$sql="INSERT into $table
					( ". join(',', $Columns->{$table}  ) ." )
					values 
					( ".join( ',', map{ '?' } $Columns->{$table} )." ) ;" ;
	my $row;
	push( @{$row}, $dt );
	push( @{$row}, $hrow->{row_id} );
	
	InsertRecord( $dbh, $sql, $row ) ;
	if( $new ) {
		print "$hrow->{row_id}\n" ;
	}
}

unless( $new ) {
	foreach( @ls ) {
		print "$_\n";
	}
}

# all ok
db_disconnect();
exit(0);



sub show_help {
        print STDERR "
		Search and insert run_id in to table Runfolder. 
		Usage: $0 [--new] [--help]
		where
        --new show only new inserted run_id dirs (default: show all RunId )
		Sample:
		$0 --new
";
	exit (1);
}

