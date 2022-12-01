#!/usr/bin/perl -w
use strict;
##
##
##	parsing the taxonomy OTU table file at user defined taxonomy hirarchy level 
##
##
##
my $otuTable = '/home/thsti/metagenomicsAnalysis/01BDasSir/16sRNA_Balabhgharh_analysis/16sRNA_Balabhgharh_OTUftable_combined_filtered.tsv';
my $newotuTable = '/home/thsti/metagenomicsAnalysis/01BDasSir/16sRNA_Balabhgharh_analysis/16sRNA_Balabhgharh_OTUftable_combined_filtered_phylumlevel1.tsv';
my $taxcolName = 'taxonomy';
my $taxlevel = 2; #taxonomy hirarchy level
my $samplecol = 3; #starting coloumn number of sample
my $samplenum = 162; #total number of samples
##
##
##
my %taxlineage = (1 => 'Kingdom', 2 => 'Phylum', 3 => 'Class', 4 => 'Order', 5 => 'Family', 6 => 'Genus', 7 =>'Species');
my %newOTU;
my $taxcolNum;
open(IN, $otuTable) or die"could not open $otuTable,$!";
open(OUT, ">$newotuTable") or die"could not open $newotuTable,$!";
while(my $ln = <IN>)
	{
		$ln =~ s/^\s+|\s+$//;
		my @lnA = split(/\t/, $ln); 
		if($ln =~ m/^\#/g)
			{
				my $nwln = join("\t", @lnA[($samplecol-1)..(($samplenum-1)+($samplecol-1))]);
				print '#OTU',"\t",$nwln,"\t",$taxlineage{$taxlevel},"\n";
				print OUT '#OTU',"\t",$nwln,"\t",$taxlineage{$taxlevel},"\n";
				for(my $count = 0; $count<scalar(@lnA); $count++)
					{	
						$lnA[$count] =~ s/^\s+|\s+$//;
						if($lnA[$count] eq $taxcolName)
							{
								$taxcolNum = $count;
								last;
							}
							
					}
			}
		else
			{
				my @otuLevel = split(/;/, $lnA[$taxcolNum]);
				if(scalar@otuLevel>1)
					{
						my $newtaxon = $otuLevel[$taxlevel-1];
						$newtaxon =~ s/\[|\]//g;
						#print $newtaxon,"\n";
						if(exists $newOTU{$newtaxon})
							{
								my @combA = @{$newOTU{$newtaxon}};
								my $count = 0;
								for(my $a=$samplecol-1; $a<($samplenum+$samplecol)-1; $a++)
									{
										$lnA[$a] = $lnA[$a]+$combA[$count];
										$count++;
									}
								$newOTU{$newtaxon} = [@lnA[($samplecol-1)..(($samplenum-1)+($samplecol-1))]];
								undef(@combA);
							}
						else
							{
								$newOTU{$newtaxon} = [@lnA[($samplecol-1)..(($samplenum-1)+($samplecol-1))]];
							}
					}
				undef(@otuLevel);
			}
		undef(@lnA);
	}
close(IN);
#print $taxcolNum,"\n";
my $num = 1;
foreach my $capword (keys %newOTU)
	{
		my @countA = @{$newOTU{$capword}};
		my $countLn = join("\t", @countA);
		print 'OTU_'.$num,"\t",$countLn,"\t",$capword,"\n";
		print OUT 'OTU_'.$num,"\t",$countLn,"\t",$capword,"\n";
		$num++;
	}
undef(%newOTU);
