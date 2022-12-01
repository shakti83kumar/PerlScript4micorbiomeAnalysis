#!/usr/bin/perl -w
use strict;
##
##
##	
##	extracting CSTs(cummunity state taxons) from combined OTUs table in fasta format
##
##
my $ftable = '/home/thsti/metagenomicsAnalysis/16sRNA_Obese/sample_cleaned_trimmed_Qiime2Analysis/P40obese_sample_cleaned_trimmed_rename_OTUfeature-table_q17len100_filtered.tsv';
my $CSTsfolder = '/home/thsti/metagenomicsAnalysis/16sRNA_Obese/sample_cleaned_trimmed_Qiime2Analysis/P40obese_sample_cleaned_trimmed_rename_OTUfeature-table_q17len100_filtered_CSTs';
##
##
##
my %CSTids;
open(TABLE, $ftable) or die "could not open file $ftable, $!";
while(my $ln =<TABLE>)
	{
		if($ln =~ /^\#/)
			{
				next;
			}
		else
			{
				$ln =~ s/^\s+|\s+$//;
				my @lnA = split(/\t/, $ln);
				$CSTids{$lnA[0]} += 1;
				undef(@lnA);
			}
	}
close(TABLE);
foreach my $eachCSTs (keys%CSTids)
	{
		my $count = 1;
		my $CSTsfile = $CSTsfolder.'/'.$eachCSTs.'.fasta';
		#my $CSTsRname = $CSTsfolder.'/'.$eachCSTs.'_namelist';
		open(TABLE1, $ftable) or die "could not open file $ftable, $!";
		open(OUT,">$CSTsfile") or die "could not open file $CSTsfile, $!";
		#open(RNAME, ">$CSTsRname") or die "could not open file $CSTsRname, $!";
		while(my $ln =<TABLE1>)
			{

				if($ln =~ /^\#/)
					{		
						next;
					}
				else
					{
						$ln =~ s/^\s+|\s+$//;
						my @lnA = split(/\t/, $ln);
						if($lnA[0] eq $eachCSTs)
							{
								print $CSTsfile,"\t",$lnA[1],"\n";
								#print RNAME $eachCSTs.'_OTU_'.$count,"\t",$lnA[1],"\n";
								print OUT '>'.$eachCSTs.'_'.$lnA[1],"\n";
								print OUT $lnA[$#lnA],"\n";
								$count++;
							}
						undef(@lnA);
					}
			}
		close(TABLE1);
		close(OUT);
	}
undef(%CSTids);

