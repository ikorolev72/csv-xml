#!/usr/bin/perl
# korolev-ia [at] yandex.ru
# version 1.0 2016.07.05
##############################

use PARS16;



GetOptions (
        'id|i=s' => \$runId,
        'fn|f=s' => \$fn,
        "help|h|?"  => \$help ) or show_help();

show_help() if($help);
show_help() unless($runId);

$fn="RunInfo.xml" unless( $fn ); 
my $filename="$Paths->{RUNFOLDER}/$runId/$fn" ;
unless( -f $filename ) {
	w2log( "File $filename not exist\n" ) ;
	exit(2);
}

my $dbh=db_connect( ) ;
exit ( 3 ) unless( $dbh );


unless ( parse_RunInfo ( $filename, $dbh, $runId ) ) { # if any errors we exit with 4 
	db_disconnect( $dbh );
	exit(4);
}

# all ok
db_disconnect( $dbh );
exit(0);



sub show_help {
        print STDERR "
		Parse xml file RunInfo.xml 
		Usage: $0 --id=run_id [--fn=filename.xml] [--help]
		where
		run_id  - run id directory
		filename.csv - alternative filename ( default is RunInfo.xml )
		Sample:
		$0 --id=160302_D00427_0079_AHKJMKBCXX
";
	exit (1);
}