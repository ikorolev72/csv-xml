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


my @rows;
my $csv = Text::CSV->new ( { binary => 0 } )  # should set binary attribute.
                or die "Cannot use CSV: ".Text::CSV->error_diag ();

open my $fh, "<:encoding(utf8)", $filename or die "$filename: $!";
#open my $fh, "<", $filename or die "$filename: $!";
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


my $dbh=db_connect( ) ;
exit ( 3 ) unless( $dbh );

my $sql;
my $table='SAMPLESHEET';
foreach $row ( @rows ) {
	$sql="INSERT into $table
					( ". join(',', $Columns->{$table}  ) ." )
					values 
					( ".join( ',', map{ '?' } $Columns->{$table} )." ) ;"
	push( @{$row}, $runId );
	InsertRecord( $dbh, $sql, $row ) ;
}

# all ok
db_disconnect();
exit(0);









sub show_help {
        print STDERR "
		Parse csv files. 
		Usage: $0 --id=run_id [--fn=filename.csv] [--help]
		where
        run_id  - run id directory
		filename.csv - alternative filename ( default is SampleSheet.csv )
		Sample:
		$0 --id=160302_D00427_0079_AHKJMKBCXX
";
	exit (1);
}
