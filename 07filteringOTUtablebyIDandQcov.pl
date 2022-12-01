#!/usr/bin/perl -w
use strict;
##
##
##	parsing the taxonomy OTU table based on %idenetiy and %query coverage in blast 
##
##
##
my $otuTable = '/media/shakti/SHAKTI4/04MetagenomicsAnalysis/GarbhiniMicrobiome2Analysis/seq_table_PTB_NIBMG_otuseq_sps.tsv';
my $newotuTable = '//media/shakti/SHAKTI4/04MetagenomicsAnalysis/GarbhiniMicrobiome2Analysis/seq_table_PTB_NIBMG_otuseq_sps_id97qv90.tsv';
my $idcolName = '%identity'; # header name of column having %idenetiy value
my $qvcolName = 'qcoverage'; # header name of column having %query coverage value
my $idpercval = 97; # %idenetiy value to be used filtered
my $qvpercval = 90; # %query coverage value to be used filtered
##
##
##
my @filterA = ($idcolName, $qvcolName);
my ($idcol, $qcovcol); 
open(IN, $otuTable) or die"could not open $otuTable,$!";
open(OUT, ">$newotuTable") or die"could not open $newotuTable,$!";
while(my $ln = <IN>)
	{
		$ln =~ s/^\s+|\s+$//;
		my @lnA = split(/\t/, $ln); 
		if($ln =~ m/^\#/g)
			{
				print $ln,"\n";
				print OUT $ln,"\n";
				my @colA; 
				for(my $count = 0; $count<scalar(@lnA); $count++)
					{	
						$lnA[$count] =~ s/^\s+|\s+$//;
						foreach my $val (@filterA)
							{
								if($lnA[$count] eq $val)
									{
										push(@colA, $count);
									}
							}	
					}
				($idcol, $qcovcol) = 	@colA;
			}
		print $lnA[$idcol], "\t", $lnA[$qcovcol],"\n"; 
		if(($lnA[$idcol] eq 'NA')||($lnA[$qcovcol] eq 'NA'))
			{
				next;
			}
		else
			{
				
				if(($lnA[$idcol]>=$idpercval)&&($lnA[$qcovcol]>=$qvpercval))
					{
						print $ln,"\n";
						print OUT $ln,"\n";
					}
			}
		undef(@lnA);
	}
undef(@filterA);
close(IN);
close(OUT);
