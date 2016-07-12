@a=qw( lane sample_id sample_name sample_plate sample_well i7_index_id index0 sample_project description run_id );
$i=0;
foreach( @a ) {
	print "\$hrow{$_}=substr( \$row[$i], 0, 45 ) ;\n" ;
	$i++;
}