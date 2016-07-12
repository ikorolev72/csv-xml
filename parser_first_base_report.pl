#!/usr/bin/perl
# korolev-ia [at] yandex.ru
# version 1.0 2016.07.05
##############################

# The second table is the SampleSheet.csv file where the first lines until the [Data] section should be
# skipped. The Sample_IDs are not unique at the moment and can be redundant. All columns from the
# header should be read into the database as indicated in the database schema. CSV module for parsing
# can be used.

use PARS16;
#use HTML::PullParser;
use HTML::TokeParser;

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

my $dbh=db_connect( ) ;
exit ( 3 ) unless( $dbh );

unless ( parse_First_Base_Report ( $filename, $dbh, $runId ) ) { # if any errors we exit with 4 
	db_disconnect( $dbh );
	exit(4);
}

# all ok
db_disconnect( $dbh );
exit(0);

sub parse_First_Base_Report ( $filename, $dbh, $runId )  {
	my $filename=shift;
	my $dbh=shift;
	my $runId=shift;

	my $html=ReadFile( $filename );
	my $parser = HTML::TokeParser->new(\$html);

my $result='';
while (my $token = $parser->get_token) {
	#print Dumper( $token );
	$result .="$token->[1]#" if( $token->[0] =~'T');
}  
  	
#print $result;
$result=~/#Top Surface#\s+#\s+(.+\w#\s+)#\s+.+#Bottom Surface#\s#\s(.+\w#\s+)#\s+/sg;
#print "\n\n$1\n\n$2";
my @top=split( /\n/, $1 );
my @bottom=split( /\n/, $2 );
#print Dumper( @top );
#print Dumper( @bottom );

my %hrow;
$hrow{top_id}=GetNextSequence( $dbh ) ;
$hrow{bottom_id}=GetNextSequence( $dbh ) ;
$hrow{run_id}=$runId ;

my $top_id=$hrow{top_id};
my $bottom_id=$hrow{bottom_id};

	my @rows=();
	my $table='first_base_report';
	my @Columns=qw( top_id bottom_id run_id ) ;
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
	
unless( parse_surface ( $dbh, \@top, $top_id ) ) {
	return 0;
}

unless( parse_surface ( $dbh, \@bottom, $bottom_id )) {
	return 0;
}

	return 1;
}


sub parse_surface {
	my $dbh=shift;
	my $top=shift;
	my $surface_id=shift;
	shift @{ $top };
	foreach my $line ( @{ $top } ){
		$line=~s/^#//;
		$line=~s/#$//;
		my @Fields=split( /#/, $line );
		my @Columns=qw( metric lane1 lane2 lane3 lane4 lane5 lane6 lane7 lane8 surface_id id ) ;
		my %hrow;
$hrow{metric}=substr( @Fields[0] , 0, 45 ) ;
$hrow{lane1}=@Fields[1] if( @Fields[1]=~/^\d*\.?\d*$/ ) ;
$hrow{lane2}=@Fields[2] if( @Fields[2]=~/^\d*\.?\d*$/ ) ;
$hrow{lane3}=@Fields[3] if( @Fields[3]=~/^\d*\.?\d*$/ ) ;
$hrow{lane4}=@Fields[4] if( @Fields[4]=~/^\d*\.?\d*$/ ) ;
$hrow{lane5}=@Fields[5] if( @Fields[5]=~/^\d*\.?\d*$/ ) ;
$hrow{lane6}=@Fields[6] if( @Fields[6]=~/^\d*\.?\d*$/ ) ;
$hrow{lane7}=@Fields[7] if( @Fields[7]=~/^\d*\.?\d*$/ ) ;
$hrow{lane8}=@Fields[8] if( @Fields[8]=~/^\d*\.?\d*$/ ) ;
$hrow{lane1}=@Fields[1] if( @Fields[1]=~/^\d*\.?\d*$/ ) ;
$hrow{surface_id}=$surface_id;
$hrow{id}=GetNextSequence( $dbh ) ;

		my @rows=();
		my $table='surface';
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
	}
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