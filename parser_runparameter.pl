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

$fn="runParameters.xml" unless( $fn ); 
my $filename="$Paths->{RUNFOLDER}/$runId/$fn" ;
unless( -f $filename ) {
	w2log( "File $filename not exist\n" ) ;
	exit(2);
}

my $dbh=db_connect( ) ;
exit ( 3 ) unless( $dbh );


unless ( parse_runParameters ( $filename, $dbh, $runId ) ) { # if any errors we exit with 4 
	db_disconnect();
	exit(4);
}

# all ok
db_disconnect( $dbh );
exit(0);



sub parse_runParameters {
	my $filename=shift;
	my $dbh=shift;
	my $runId=shift;	
	my $xml=ReadXml( $filename );
	#print Dumper( $xml );
	my $tmp_root=$xml->{'RunParameters'}->{'Setup'};
	my %hrow;

# 
$hrow{run_id}=$runId ;
#$hrow{run_id}=substr( $tmp_root->{'RunID'}, 0, 45 ) ; 
$hrow{recipefragmentversion}=substr( $tmp_root->{'RecipeFragmentVersion'}, 0, 45 ) ;
$hrow{flowcell}=substr( $tmp_root->{'Flowcell'}, 0, 45 ) ;
$hrow{remapqscores}=substr( $tmp_root->{'RemapQScores'}, 0, 45 ) ;
$hrow{computername}=substr( $tmp_root->{'ComputerName'}, 0, 45 ) ;
$hrow{sbs0}=substr( $tmp_root->{'Sbs'}, 0, 45 ) ;
$hrow{performprerunfluidicscheck}=1 if($tmp_root->{'PerformPreRunFluidicsCheck'}=~/^true$/ );
$hrow{performprerunfluidicscheck}=0 if($tmp_root->{'PerformPreRunFluidicsCheck'}=~/^false$/ );
$hrow{experimentname}=substr( $tmp_root->{'ExperimentName'}, 0, 45 ) ;
$hrow{numtilesperswath}=$tmp_root->{'NumTilesPerSwath'} if($tmp_root->{'NumTilesPerSwath'}=~/^\d+$/ );
$hrow{cpldversion}=substr( $tmp_root->{'CPLDVersion'}, 0, 45 ) ;
$hrow{clusteringchoice}=substr( $tmp_root->{'ClusteringChoice'}, 0, 45 ) ;
$hrow{resumecycle}=$tmp_root->{'ResumeCycle'} if($tmp_root->{'ResumeCycle'}=~/^\d+$/ );
$hrow{mockrun}=1 if($tmp_root->{'MockRun'}=~/^true$/ );
$hrow{mockrun}=0 if($tmp_root->{'MockRun'}=~/^false$/ );
$hrow{periodicsave}=substr( $tmp_root->{'PeriodicSave'}, 0, 45 ) ;
$hrow{areaperpixelmm2}=substr( $tmp_root->{'AreaPerPixelmm2'}, 0, 45 ) ;
$hrow{swathscanmode}=substr( $tmp_root->{'SwathScanMode'}, 0, 45 ) ;
$hrow{username0}=substr( $tmp_root->{'Username'}, 0, 45 ) ;
$hrow{scannedbarcode}=substr( $tmp_root->{'ScannedBarcode'}, 0, 45 ) ;
$hrow{tempfolder1}=substr( $tmp_root->{'TempFolder'}, 0, 254 ) ;
$hrow{read1}=$tmp_root->{'Read1'} if($tmp_root->{'Read1'}=~/^\d+$/ );
$hrow{firstbaseconfirmation}=1 if($tmp_root->{'FirstBaseConfirmation'}=~/^true$/ );
$hrow{firstbaseconfirmation}=0 if($tmp_root->{'FirstBaseConfirmation'}=~/^false$/ );
$hrow{enableanalysis}=1 if($tmp_root->{'EnableAnalysis'}=~/^true$/ );
$hrow{enableanalysis}=0 if($tmp_root->{'EnableAnalysis'}=~/^false$/ );
$hrow{compressbcls}=1 if($tmp_root->{'CompressBcls'}=~/^true$/ );
$hrow{compressbcls}=0 if($tmp_root->{'CompressBcls'}=~/^false$/ );
$hrow{indexread2}=$tmp_root->{'IndexRead2'} if($tmp_root->{'IndexRead2'}=~/^\d+$/ );
$hrow{promptforpereagents}=1 if($tmp_root->{'PromptForPeReagents'}=~/^true$/ );
$hrow{promptforpereagents}=0 if($tmp_root->{'PromptForPeReagents'}=~/^false$/ );
$hrow{samplesheet}=substr( $tmp_root->{'SampleSheet'}, 0, 254 ) ;
$hrow{outputfolder}=substr( $tmp_root->{'OutputFolder'}, 0, 254 ) ;
$hrow{motordelayframes}=$tmp_root->{'FPGADynamicFocusSettings'}->{'MotorDelayFrames'} if($tmp_root->{'FPGADynamicFocusSettings'}->{'MotorDelayFrames'}=~/^\d+$/ );
$hrow{maxsubsequentzjumphalfum}=$tmp_root->{'FPGADynamicFocusSettings'}->{'MaxSubsequentZJumpHalfUm'} if($tmp_root->{'FPGADynamicFocusSettings'}->{'MaxSubsequentZJumpHalfUm'}=~/^\d+$/ );
$hrow{maxinitialzjumphalfum}=$tmp_root->{'FPGADynamicFocusSettings'}->{'MaxInitialZJumpHalfUm'} if($tmp_root->{'FPGADynamicFocusSettings'}->{'MaxInitialZJumpHalfUm'}=~/^\d+$/ );
$hrow{numberofinitialzjumps}=$tmp_root->{'FPGADynamicFocusSettings'}->{'NumberOfInitialZJumps'} if($tmp_root->{'FPGADynamicFocusSettings'}->{'NumberOfInitialZJumps'}=~/^\d+$/ );
$hrow{groupsize}=$tmp_root->{'FPGADynamicFocusSettings'}->{'GroupSize'} if($tmp_root->{'FPGADynamicFocusSettings'}->{'GroupSize'}=~/^\d+$/ );
$hrow{cvgainstart}=$tmp_root->{'FPGADynamicFocusSettings'}->{'CVGainStart'} if($tmp_root->{'FPGADynamicFocusSettings'}->{'CVGainStart'}=~/^\d+$/ );
$hrow{igain}=$tmp_root->{'FPGADynamicFocusSettings'}->{'IGain'} if($tmp_root->{'FPGADynamicFocusSettings'}->{'IGain'}=~/^\d+$/ );
$hrow{hotpixel}=$tmp_root->{'FPGADynamicFocusSettings'}->{'HotPixel'} if($tmp_root->{'FPGADynamicFocusSettings'}->{'HotPixel'}=~/^\d+$/ );
$hrow{offset}=$tmp_root->{'FPGADynamicFocusSettings'}->{'Offset'} if($tmp_root->{'FPGADynamicFocusSettings'}->{'Offset'}=~/^\d+$/ );
$hrow{dithersize}=$tmp_root->{'FPGADynamicFocusSettings'}->{'DitherSize'} if($tmp_root->{'FPGADynamicFocusSettings'}->{'DitherSize'}=~/^\d+$/ );
$hrow{ihistory}=$tmp_root->{'FPGADynamicFocusSettings'}->{'IHistory'} if($tmp_root->{'FPGADynamicFocusSettings'}->{'IHistory'}=~/^\d+$/ );
$hrow{cvgainposlocked}=$tmp_root->{'FPGADynamicFocusSettings'}->{'CVGainPosLocked'} if($tmp_root->{'FPGADynamicFocusSettings'}->{'CVGainPosLocked'}=~/^\d+$/ );
$hrow{dithershift}=$tmp_root->{'FPGADynamicFocusSettings'}->{'DitherShift'} if($tmp_root->{'FPGADynamicFocusSettings'}->{'DitherShift'}=~/^\d+$/ );
$hrow{softwarelaserlag}=$tmp_root->{'FPGADynamicFocusSettings'}->{'SoftwareLaserLag'} if($tmp_root->{'FPGADynamicFocusSettings'}->{'SoftwareLaserLag'}=~/^\d+$/ );
$hrow{intensityceiling}=$tmp_root->{'FPGADynamicFocusSettings'}->{'IntensityCeiling'} if($tmp_root->{'FPGADynamicFocusSettings'}->{'IntensityCeiling'}=~/^\d+$/ );
$hrow{index0}=substr( $tmp_root->{'Index'}, 0, 45 ) ;
$hrow{applicationversion}=substr( $tmp_root->{'ApplicationVersion'}, 0, 45 ) ;
$hrow{indexread1}=$tmp_root->{'IndexRead1'} if($tmp_root->{'IndexRead1'}=~/^\d+$/ );
$hrow{templatecyclecount}=$tmp_root->{'TemplateCycleCount'} if($tmp_root->{'TemplateCycleCount'}=~/^\d+$/ );
$hrow{enablenotifications}=1 if($tmp_root->{'EnableNotifications'}=~/^true$/ );
$hrow{enablenotifications}=0 if($tmp_root->{'EnableNotifications'}=~/^false$/ );
$hrow{numanalysisthreads}=$tmp_root->{'NumAnalysisThreads'} if($tmp_root->{'NumAnalysisThreads'}=~/^\d+$/ );
$hrow{resume}=1 if($tmp_root->{'Resume'}=~/^true$/ );
$hrow{resume}=0 if($tmp_root->{'Resume'}=~/^false$/ );
$hrow{slideholder}=substr( $tmp_root->{'SlideHolder'}, 0, 45 ) ;
$hrow{pairendfc}=1 if($tmp_root->{'PairEndFC'}=~/^true$/ );
$hrow{pairendfc}=0 if($tmp_root->{'PairEndFC'}=~/^false$/ );
$hrow{runmode}=substr( $tmp_root->{'RunMode'}, 0, 45 ) ;
$hrow{focuscamerafirmware}=substr( $tmp_root->{'FocusCameraFirmware'}, 0, 45 ) ;
$hrow{integrationmode}=substr( $tmp_root->{'IntegrationMode'}, 0, 45 ) ;
$hrow{cameradriver}=substr( $tmp_root->{'CameraDriver'}, 0, 45 ) ;
$hrow{fcposition}=substr( $tmp_root->{'FCPosition'}, 0, 45 ) ;
$hrow{selectedsurface}=substr( $tmp_root->{'SelectedSurface'}, 0, 45 ) ;
$hrow{enablecameralogging}=1 if($tmp_root->{'EnableCameraLogging'}=~/^true$/ );
$hrow{enablecameralogging}=0 if($tmp_root->{'EnableCameraLogging'}=~/^false$/ );
$hrow{camerafirmware}=substr( $tmp_root->{'CameraFirmware'}, 0, 45 ) ;
$hrow{rehyb0}=substr( $tmp_root->{'Rehyb'}, 0, 45 ) ;
$hrow{autotiltonce}=1 if($tmp_root->{'AutoTiltOnce'}=~/^true$/ );
$hrow{autotiltonce}=0 if($tmp_root->{'AutoTiltOnce'}=~/^false$/ );
$hrow{rapidrunchemistry}=substr( $tmp_root->{'RapidRunChemistry'}, 0, 45 ) ;
$hrow{imageheight}=$tmp_root->{'ImageHeight'} if($tmp_root->{'ImageHeight'}=~/^\d+$/ );
$hrow{chemistryversion}=substr( $tmp_root->{'ChemistryVersion'}, 0, 45 ) ;
$hrow{enableautocenter}=1 if($tmp_root->{'EnableAutoCenter'}=~/^true$/ );
$hrow{enableautocenter}=0 if($tmp_root->{'EnableAutoCenter'}=~/^false$/ );
$hrow{applicationname}=substr( $tmp_root->{'ApplicationName'}, 0, 45 ) ;
$hrow{focusmethod}=substr( $tmp_root->{'FocusMethod'}, 0, 45 ) ;
$hrow{rtaversion}=substr( $tmp_root->{'RTAVersion'}, 0, 45 ) ;
$hrow{scannumber}=$tmp_root->{'ScanNumber'} if($tmp_root->{'ScanNumber'}=~/^\d+$/ );
$hrow{imagewidth}=$tmp_root->{'ImageWidth'} if($tmp_root->{'ImageWidth'}=~/^\d+$/ );
$hrow{enablebasecalling}=1 if($tmp_root->{'EnableBasecalling'}=~/^true$/ );
$hrow{enablebasecalling}=0 if($tmp_root->{'EnableBasecalling'}=~/^false$/ );
$hrow{supportmultiplesurfacesinui}=1 if($tmp_root->{'SupportMultipleSurfacesInUI'}=~/^true$/ );
$hrow{supportmultiplesurfacesinui}=0 if($tmp_root->{'SupportMultipleSurfacesInUI'}=~/^false$/ );
$hrow{enablelft}=1 if($tmp_root->{'EnableLft'}=~/^true$/ );
$hrow{enablelft}=0 if($tmp_root->{'EnableLft'}=~/^false$/ );
$hrow{runid1}=$tmp_root->{'BaseSpaceSettings'}->{'RunId'} if($tmp_root->{'BaseSpaceSettings'}->{'RunId'}=~/^\d+$/ );
$hrow{username1}=substr( $tmp_root->{'BaseSpaceSettings'}->{'Username'}, 0, 45 ) ;
$hrow{runmonitoringonly}=1 if($tmp_root->{'BaseSpaceSettings'}->{'RunMonitoringOnly'}=~/^true$/ );
$hrow{runmonitoringonly}=0 if($tmp_root->{'BaseSpaceSettings'}->{'RunMonitoringOnly'}=~/^false$/ );
$hrow{sendinstrumenthealthtoilmn}=1 if($tmp_root->{'BaseSpaceSettings'}->{'SendInstrumentHealthToILMN'}=~/^true$/ );
$hrow{sendinstrumenthealthtoilmn}=0 if($tmp_root->{'BaseSpaceSettings'}->{'SendInstrumentHealthToILMN'}=~/^false$/ );
$hrow{tempfolder0}=substr( $tmp_root->{'BaseSpaceSettings'}->{'TempFolder'}, 0, 254 ) ;
$hrow{plannedrun}=1 if($tmp_root->{'BaseSpaceSettings'}->{'PlannedRun'}=~/^true$/ );
$hrow{plannedrun}=0 if($tmp_root->{'BaseSpaceSettings'}->{'PlannedRun'}=~/^false$/ );
$hrow{workflowtype}=substr( $tmp_root->{'WorkFlowType'}, 0, 45 ) ;
$hrow{barcode}=substr( $tmp_root->{'Barcode'}, 0, 45 ) ;
$hrow{tileheight}=$tmp_root->{'TileHeight'} if($tmp_root->{'TileHeight'}=~/^\d+$/ );
$hrow{fpgaversion}=substr( $tmp_root->{'FPGAVersion'}, 0, 45 ) ;
$hrow{adapterplate}=substr( $tmp_root->{'AdapterPlate'}, 0, 45 ) ;
$hrow{pe0}=substr( $tmp_root->{'Pe'}, 0, 45 ) ;
$hrow{numswaths}=$tmp_root->{'NumSwaths'} if($tmp_root->{'NumSwaths'}=~/^\d+$/ );
$hrow{scannerid}=substr( $tmp_root->{'ScannerID'}, 0, 45 ) ;
$hrow{aligntophix}=substr( $tmp_root->{'AlignToPhiX'}, 0, 45 ) ;
$hrow{scanid}=substr( $tmp_root->{'ScanID'}, 0, 45 ) ;
$hrow{washbarcode}=substr( $tmp_root->{'WashBarcode'}, 0, 45 ) ;
$hrow{isnew200cycle}=1 if($tmp_root->{'ReagentKits'}->{'Sbs'}->{'SbsReagentKit'}->{'IsNew200Cycle'}=~/^true$/ );
$hrow{isnew200cycle}=0 if($tmp_root->{'ReagentKits'}->{'Sbs'}->{'SbsReagentKit'}->{'IsNew200Cycle'}=~/^false$/ );
$hrow{id0}=substr( $tmp_root->{'ReagentKits'}->{'Sbs'}->{'SbsReagentKit'}->{'ID'}, 0, 45 ) ;
$hrow{isnew50cycle}=1 if($tmp_root->{'ReagentKits'}->{'Sbs'}->{'SbsReagentKit'}->{'IsNew50Cycle'}=~/^true$/ );
$hrow{isnew50cycle}=0 if($tmp_root->{'ReagentKits'}->{'Sbs'}->{'SbsReagentKit'}->{'IsNew50Cycle'}=~/^false$/ );
$hrow{numbercyclesremaining}=$tmp_root->{'ReagentKits'}->{'Sbs'}->{'SbsReagentKit'}->{'NumberCyclesRemaining'} if($tmp_root->{'ReagentKits'}->{'Sbs'}->{'SbsReagentKit'}->{'NumberCyclesRemaining'}=~/^\d+$/ );
$hrow{prime}=1 if($tmp_root->{'ReagentKits'}->{'Sbs'}->{'SbsReagentKit'}->{'Prime'}=~/^true$/ );
$hrow{prime}=0 if($tmp_root->{'ReagentKits'}->{'Sbs'}->{'SbsReagentKit'}->{'Prime'}=~/^false$/ );
$hrow{isnew500cycle}=1 if($tmp_root->{'ReagentKits'}->{'Sbs'}->{'SbsReagentKit'}->{'IsNew500Cycle'}=~/^true$/ );
$hrow{isnew500cycle}=0 if($tmp_root->{'ReagentKits'}->{'Sbs'}->{'SbsReagentKit'}->{'IsNew500Cycle'}=~/^false$/ );
$hrow{rehyb1}=substr( $tmp_root->{'Rehyb'}, 0, 45 ) ;
$hrow{pe1}=substr( $tmp_root->{'ReagentKits'}->{'Pe'}, 0, 45 ) ;
$hrow{id1}=substr( $tmp_root->{'ReagentKits'}->{'ReagentKits'}->{'Index'}->{'ReagentKit'}->{'ID'}, 0, 45 ) ;
$hrow{keepintensityfiles}=1 if($tmp_root->{'KeepIntensityFiles'}=~/^true$/ );
$hrow{keepintensityfiles}=0 if($tmp_root->{'KeepIntensityFiles'}=~/^false$/ );
$hrow{tilewidth}=$tmp_root->{'TileWidth'} if($tmp_root->{'TileWidth'}=~/^\d+$/ );
$hrow{sbs1}=substr( $tmp_root->{'ReagentBottles'}->{'Sbs'}, 0, 45 ) ;
$hrow{useexistingrecipe}=1 if($tmp_root->{'UseExistingRecipe'}=~/^true$/ );
$hrow{useexistingrecipe}=0 if($tmp_root->{'UseExistingRecipe'}=~/^false$/ );
$hrow{runstartdate}=$tmp_root->{'RunStartDate'} if($tmp_root->{'RunStartDate'}=~/^\d+$/ );
$hrow{servicerun}=1 if($tmp_root->{'ServiceRun'}=~/^true$/ );
$hrow{servicerun}=0 if($tmp_root->{'ServiceRun'}=~/^false$/ );
$hrow{lanelength}=$tmp_root->{'LaneLength'} if($tmp_root->{'LaneLength'}=~/^\d+$/ );
$hrow{read2}=$tmp_root->{'Read2'} if($tmp_root->{'Read2'}=~/^\d+$/ );
$hrow{read_id}=GetNextSequence( $dbh ) ;
$hrow{select_id}=GetNextSequence( $dbh ) ;

my $read_id=$hrow{read_id};
my $select_id=$hrow{select_id};
	
my $table='runparameter';
my @Columns=qw(
adapterplate
aligntophix
applicationname
applicationversion
areaperpixelmm2
autotiltonce
barcode
cameradriver
camerafirmware
chemistryversion
clusteringchoice
compressbcls
computername
cpldversion
cvgainposlocked
cvgainstart
dithershift
dithersize
enableanalysis
enableautocenter
enablebasecalling
enablecameralogging
enablelft
enablenotifications
experimentname
fcposition
firstbaseconfirmation
flowcell
focuscamerafirmware
focusmethod
fpgaversion
groupsize
hotpixel
id0
id1
igain
ihistory
imageheight
imagewidth
index0
indexread1
indexread2
integrationmode
intensityceiling
isnew200cycle
isnew500cycle
isnew50cycle
keepintensityfiles
lanelength
maxinitialzjumphalfum
maxsubsequentzjumphalfum
mockrun
motordelayframes
numanalysisthreads
numbercyclesremaining
numberofinitialzjumps
numswaths
numtilesperswath
offset
outputfolder
pairendfc
pe0
pe1
performprerunfluidicscheck
periodicsave
plannedrun
prime
promptforpereagents
rapidrunchemistry
read1
read2
read_id
recipefragmentversion
rehyb0
rehyb1
remapqscores
resume
resumecycle
rtaversion
run_id
runid1
runmode
runmonitoringonly
runstartdate
samplesheet
sbs0
sbs1
scanid
scannedbarcode
scannerid
scannumber
selectedsurface
select_id
sendinstrumenthealthtoilmn
servicerun
slideholder
softwarelaserlag
supportmultiplesurfacesinui
swathscanmode
tempfolder0
tempfolder1
templatecyclecount
tileheight
tilewidth
useexistingrecipe
username0
username1
washbarcode
workflowtype

);


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


	# insert read records
	undef( $hrow);
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
		#print Dumper( $read );
		$hrow{isindexedread}=$read->{'IsIndexedRead'} if( $read->{'IsIndexedRead'} =~ /^(Y|N)$/i ) ;	
		$hrow{numcycles}=$read->{'NumCycles'}  if( $read->{'NumCycles'}=~/^\d+$/ );	
		$hrow{number0}=$read->{'Number'} if($read->{'Number'}=~/^\d+$/ );	
		$hrow{read_id}=$read_id ;
		foreach $key( @Columns ) {
			push( @rows, $hrow{$key} );
		}		
		unless( InsertRecord( $dbh, $sql, \@rows ) ) {
			return 0;
		}				
	}	

	# insert SelectedSections records
	undef( $hrow);
	$table='selecttable';
	@Columns=qw( name select_id ) ;
	$sql="INSERT into $table
					( ". join(',', @Columns  ) ." )
					values 
					( ".join( ',', map{ '?' } @Columns )." ) ;";	
					
	# usualy field 'select' - is array, but in case one value, we make array from it
	my $tmp_root2=$tmp_root->{'SelectedSections'}->{'Section'};
	$tmp_root2=( $tmp_root2 ) if( ref( $tmp_root2 ) ne 'ARRAY' ); 
	foreach $select ( @{ $tmp_root2 } ) {
		my %hrow;
		my @rows;
		#print Dumper( $tmp_root2 );
		$hrow{name}=substr( $select->{'Name'}, 0, 45 ) ;
		$hrow{select_id}=$select_id ;
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
		Parse xml file runParameters.xml 
		Usage: $0 --id=run_id [--fn=filename.xml] [--help]
		where
		run_id  - run id directory
		filename.csv - alternative filename ( default is runParameterss.xml )
		Sample:
		$0 --id=160302_D00427_0079_AHKJMKBCXX
";
	exit (1);
}