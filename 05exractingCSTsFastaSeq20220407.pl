#!/usr/bin/perl -w
use strict;
##
##
##	
##	extracting CSTs(cummunity state taxons) from combined OTUs table in fasta format
##
##
my $ftable = '/home/thsti/metagenomicsAnalysis/01BDasSir/16sRNA_Balabhgharh_analysis/16sRNA_Balabhgharh_OTUftable_combined_filtered.tsv';
my $CSTsfolder = '/home/thsti/metagenomicsAnalysis/01BDasSir/16sRNA_Balabhgharh_analysis/16sRNA_Balabhgharh_OTUftable_combined_filtered_CSTs2';
##
##
##
my %CSTids;
my $otuCol;
my $seqCol;
print '...reading the table......',"\n";
open(TABLE, $ftable) or die "could not open file $ftable, $!";
while(my $ln =<TABLE>)
	{
		if($ln =~ /^\#/)
			{
				if($ln =~ /^\#CST/)
					{
						#print $ln;
						$ln =~ s/^\s+|\s+$//;
						my @lnA = split(/\t/, $ln);
						for(my $a = 0; $a<scalar(@lnA); $a++)
							{
								if($lnA[$a] eq '#OTU ID')
									{
										$otuCol = $a;
									}
								if($lnA[$a] eq 'sequence')
									{
										$seqCol = $a;
									}
							}
						undef(@lnA);
					}
				next;
			}
		else
			{
				$ln =~ s/^\s+|\s+$//;
				my @lnA = split(/\t/, $ln);
				my $key = $lnA[0];
				my $value = join("\n", $lnA[$otuCol], $lnA[$seqCol]);
				push(@{$CSTids{$key}},$value);
				undef(@lnA);
			}
	}
close(TABLE);
print '..segregating OTUs according to Cummunity State Taxs(CSTs)...',"\n";
foreach my $eachCSTs (keys%CSTids)
	{
		my $CSTsfile = $CSTsfolder.'/'.$eachCSTs.'.fasta';
		open(OUT,">$CSTsfile") or die "could not open file $CSTsfile, $!";
		foreach my $eachln (@{$CSTids{$eachCSTs}})
			{
				print OUT '>'.$eachCSTs.'_'.$eachln,"\n";
			}
		close(OUT);
		delete($CSTids{$eachCSTs});
	}
undef(%CSTids);
