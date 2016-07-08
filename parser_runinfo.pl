#!/usr/bin/perl
# korolev-ia [at] yandex.ru
# version 1.0 2016.07.05
##############################

use PARS16;
use XML::Simple qw(:strict);


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


unless ( parse_RunInfo ( $filename, $dbh ) ) { # if any errors we exit with 4 
	db_disconnect();
	exit(4);
}

# all ok
db_disconnect( $dbh );
exit(0);



sub parse_RunInfo {
	my $filename=shift;
	my $dbh=shift;
	my $xml=ReadXml( $filename );
	print Dumper( $xml );
	my $tmp_root=$xml->{'RunInfo'}->{'Run'};
	my $hrow;
	
	$hrow->{run_id}=$tmp_root->{'Id'} ;
	$hrow->{flowcell}=$tmp_root->{'Flowcell'} ;
	$hrow->{instrument}=$tmp_root->{'Instrument'} ;
	$hrow->{surfacecount}=$tmp_root->{'FlowcellLayout'}->{'SurfaceCount'} ;
	$hrow->{lanecount}=$tmp_root->{'FlowcellLayout'}->{'LaneCount'} ;
	$hrow->{swathcount}=$tmp_root->{'FlowcellLayout'}->{'SwathCount'} ;
	$hrow->{tilecount}=$tmp_root->{'FlowcellLayout'}->{'TileCount'} ;
	$hrow->{date0}=$tmp_root->{'Date'} ;
	$hrow->{number0}=$tmp_root->{'Number'} ;	
	$hrow->{read_id}=GetNextSequence( $dbh ) ;
	#print Dumper( $tmp_root->{'FlowcellLayout'}->{'SwathCount'} );
	
	#print Dumper( $hrow );
	my $read_id=$hrow->{read_id};

	my @rows;
	my $table='runinfo';
	my @Columns=qw( swathcount number0 flowcell instrument run_id date0 read_id lanecount tilecount surfacecount  ) ;
	foreach $key( @Columns ) {
			push( @rows, $hrow->{$key} );
	}
	
	my $sql="INSERT into $table
					( ". join(',', @Columns  ) ." )
					values 
					( ".join( ',', map{ '?' } @Columns )." ) ;";	
	unless( InsertRecord( $dbh, $sql, \@rows ) ) {
		return 0;
	}

	undef( $hrow);
	$table='runinforead';
	@Columns=qw( number0 numcycles isindexedread read_id ) ;
	$sql="INSERT into $table
					( ". join(',', @Columns  ) ." )
					values 
					( ".join( ',', map{ '?' } @Columns )." ) ;";	
					
	# usualy field 'read' - is array, but in case one value, we make array from it
	$tmp_root->{'Reads'}->{'Read'}=( $tmp_root->{'Reads'}->{'Read'} ) if( ref( $tmp_root->{'Reads'}->{'Read'} ) ne ARRAY ); 
	foreach $read ( @{ $tmp_root->{'Reads'}->{'Read'} } ) {
		my $hrow;
		my @rows;
		$hrow->{isindexedread}=$read->{'IsIndexedRead'}  ;	
		$hrow->{numcycles}=$read->{'NumCycles'}  ;	
		$hrow->{number0}=$read->{'Number'} ;	
		$hrow->{read_id}=$read_id ;
		foreach $key( @Columns ) {
			push( @rows, $hrow->{$key} );
		}		
		unless( InsertRecord( $dbh, $sql, \@rows ) ) {
			return 0;
		}				
	}
	return 1;

}


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