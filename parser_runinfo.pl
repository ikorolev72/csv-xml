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


unless ( parse_RunInfo ( $filename, $dbh, $runId ) ) { # if any errors we exit with 4 
	db_disconnect( $dbh );
	exit(4);
}

# all ok
db_disconnect( $dbh );
exit(0);



sub parse_RunInfo {
	my $filename=shift;
	my $dbh=shift;
	my $runId=shift;
	my $xml=ReadXml( $filename );
	#print Dumper( $xml );
	#return 1;
	my $tmp_root=$xml->{'RunInfo'}->{'Run'};
	my %hrow;



$hrow{run_id}=$runId ;
$hrow{flowcell}=substr( $tmp_root->{'Flowcell'}, 0, 45 ) ;
$hrow{instrument}=substr( $tmp_root->{'Instrument'}, 0, 45 ) ;
$hrow{lanecount}=$tmp_root->{'LaneCount'} if($tmp_root->{'LaneCount'}=~/^\d+$/ );
$hrow{swathcount}=$tmp_root->{'SwathCount'} if($tmp_root->{'SwathCount'}=~/^\d+$/ );
$hrow{surfacecount}=$tmp_root->{'SurfaceCount'} if($tmp_root->{'SurfaceCount'}=~/^\d+$/ );
$hrow{tilecount}=$tmp_root->{'TileCount'} if($tmp_root->{'TileCount'}=~/^\d+$/ );
$hrow{date0}=$tmp_root->{'Date'} if($tmp_root->{'Date'}=~/^d{6}$/ );
$hrow{number0}=$tmp_root->{'Number'} if($tmp_root->{'Number'}=~/^\d+$/ );
$hrow{read_id}=GetNextSequence( $dbh ) ;	

	

	#print Dumper( $tmp_root->{'FlowcellLayout'}->{'SwathCount'} );
	
	#print Dumper( $hrow );
	my $read_id=$hrow{read_id};

	my @rows=();
	my $table='runinfo';
	my @Columns=qw( swathcount number0 flowcell instrument run_id date0 read_id lanecount tilecount surfacecount  ) ;
	foreach $key( @Columns ) {
			push( @rows, $hrow{$key} );
	}
	
	my $sql="INSERT into $table
					( ". join(',', @Columns  ) ." )
					values 
					( ".join( ',', map{ '?' } @Columns )." ) ;";	
	unless( InsertRecord( $dbh, $sql, \@rows ) ) {
		return 0;
	}

	undef( %hrow);
	$table='readtable';
	@Columns=qw( number0 numcycles isindexedread read_id ) ;
	$sql="INSERT into $table
					( ". join(',', @Columns  ) ." )
					values 
					( ".join( ',', map{ '?' } @Columns )." ) ;";	
					
	# usualy field 'read' - is array, but in case one value, we make array from it
	$tmp_root->{'Reads'}->{'Read'}=( $tmp_root->{'Reads'}->{'Read'} ) if( ref( $tmp_root->{'Reads'}->{'Read'} ) ne 'ARRAY' ); 
	foreach $read ( @{ $tmp_root->{'Reads'}->{'Read'} } ) {
		my %hrow;
		my @rows;
		$hrow{isindexedread}=$read->{'IsIndexedRead'} if( $read->{'IsIndexedRead'} =~ /^(Y|N)$/i ) ;	
		$hrow{numcycles}=$read->{'NumCycles'}  if($read->{'NumCycles'}=~/^\d+$/ );;	
		$hrow{number0}=$read->{'Number'} if($read->{'Number'}=~/^\d+$/ );;	
		$hrow{read_id}=$read_id ;
		foreach $key( @Columns ) {
			push( @rows, $hrow{$key} );
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