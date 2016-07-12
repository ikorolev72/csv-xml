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





my $dbh=db_connect( ) ;
exit ( 3 ) unless( $dbh );




unless ( parse_runfolder ( $dbh, $new ) ) { # if any errors we exit with 4 
	db_disconnect( $dbh );
	exit(4);
}


# all ok
db_disconnect( $dbh );
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

