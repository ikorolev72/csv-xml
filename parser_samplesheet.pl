#!/usr/bin/perl
# korolev-ia [at] yandex.ru
# version 1.0 2016.07.05
##############################

# The second table is the SampleSheet.csv file where the first lines until the [Data] section should be
# skipped. The Sample_IDs are not unique at the moment and can be redundant. All columns from the
# header should be read into the database as indicated in the database schema. CSV module for parsing
# can be used.

use PARS16;
use Text::CSV;




GetOptions (
        'id|i=s' => \$runId,
        'fn|f=s' => \$fn,
        "help|h|?"  => \$help ) or show_help();

show_help() if($help);
show_help() unless($runId);

$fn="SampleSheet.csv" unless( $fn ); 
my $filename="$Paths->{RUNFOLDER}/$runId/$fn" ;
unless( -f $filename ) {
	w2log( "File $filename not exist\n" ) ;
	exit(2);
}

my $dbh=db_connect( ) ;
exit ( 3 ) unless( $dbh );


unless ( parse_SampleSheet ( $filename, $dbh ) ) { # if any errors we exit with 4 
	db_disconnect();
	exit(4);
}

# all ok
db_disconnect( $dbh );
exit(0);




sub parse_SampleSheet {
	my $filename=shift;
	my $dbh=shift;
	my @rows;
	my $csv = Text::CSV->new ( { binary => 1 } ) ;  # should set binary attribute.
	unless( $csv ) {
		w2log "Cannot use CSV: ".Text::CSV->error_diag ();
		return 0;
	}


	my $fh;
	unless( open(  $fh, "<:encoding(utf8)", $filename ) ) {
		w2log( "$filename: $!" );
		return 0;
	}
	
	my $found_data_section=0;
	while ( my $row = $csv->getline( $fh ) ) {
		if( $row->[0]=~/^\[Data\]$/ )  {
			$found_data_section=1 ;
			next;
		}
		next unless( $found_data_section );		
		push @rows, $row;
	}
	$csv->eof or $csv->error_diag();
	close $fh;


	my $sql;
	my $table='samplesheet';
	@Columns=qw( lane sample_id sample_name sample_plate sample_well i7_index_id rindex sample_project description run_id ) ;
	
	shift @rows; # remove columns names 
	$sql="INSERT into $table
					( ". join(',', @Columns  ) ." )
					values 
					( ".join( ',', map{ '?' } @Columns )." ) ;";	
	foreach $row ( @rows ) {

		push( @{$row}, $runId );
		print Dumper($row);
		unless( InsertRecord( $dbh, $sql, $row ) ) {

			return 0;
		}
	}
	return 1;
}





sub show_help {
        print STDERR "
		Parse csv file SampleSheet.csv 
		Usage: $0 --id=run_id [--fn=filename.csv] [--help]
		where		
		run_id  - run id directory
		filename.csv - alternative filename ( default is SampleSheet.csv )
		Sample:
		$0 --id=160302_D00427_0079_AHKJMKBCXX
";
	exit (1);
}
