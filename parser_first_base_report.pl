#!/usr/bin/perl
# korolev-ia [at] yandex.ru
# version 1.0 2016.07.05
##############################

# The second table is the SampleSheet.csv file where the first lines until the [Data] section should be
# skipped. The Sample_IDs are not unique at the moment and can be redundant. All columns from the
# header should be read into the database as indicated in the database schema. CSV module for parsing
# can be used.

use PARS16;
use HTML::PullParser;

GetOptions (
        'id|i=s' => \$runId,
        'fn|f=s' => \$fn,
        "help|h|?"  => \$help ) or show_help();

show_help() if($help);
show_help() unless($runId);

$fn="First_Base_Report.htm" unless( $fn ); 
my $filename="$Paths->{RUNFOLDER}/$runId/$fn" ;
unless( -f $filename ) {
	w2log( "File $filename not exist\n" ) ;
	# return 0 if file do not exist!!!!
	exit(0); 
}

#my $dbh=db_connect( ) ;
#exit ( 3 ) unless( $dbh );

unless ( parse_First_Base_Report ( $filename, $dbh, $runId ) ) { # if any errors we exit with 4 
	db_disconnect();
	exit(4);
}

# all ok
db_disconnect( $dbh );
exit(0);

sub parse_First_Base_Report ( $filename, $dbh, $runId )  {
	my $filename=shift;
	my $dbh=shift;
	my $runId=shift;
	my $parser = HTML::PullParser->new(
	file => $filename,
    text => 'text',
  );

my $result='';
my $start_surface_section=0;
while(my $t = $parser->get_token) {
	print Dumper( $t );
	$result .="%". $t->[0];
}
	
print $result;
$result=~/#Top Surface#\s+#\s+(.+)#\s+#\s+#\s+#Bottom Surface#\s#\s(.+)#\s+#\s#\s#/sg;
print "\n\n$1\n\n$2";
	
}




sub show_help {
        print STDERR "
		Parse html file First_Base_Report.htm 
		Usage: $0 --id=run_id [--fn=filename.html] [--help]
		where
		run_id  - run id directory
		filename.csv - alternative filename ( default is First_Base_Report.htm )
		Sample:
		$0 --id=160302_D00427_0079_AHKJMKBCXX
";
	exit (1);
}