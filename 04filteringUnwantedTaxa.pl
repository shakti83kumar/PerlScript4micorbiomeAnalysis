#!/usr/bin/perl -w
use strict;
##
##
##	removing the some OTUs by mentioned taxonomy from  feature table
##	
##
##
##
my $ftable = '/home/thsti/metagenomicsAnalysis/16sRNA_Obese/sample_cleaned_trimmed_Qiime2Analysis/P40obese_sample_cleaned_trimmed_rename_OTUfeature-table_q17len100_combined1.tsv';
my $newtable1 = '/home/thsti/metagenomicsAnalysis/16sRNA_Obese/sample_cleaned_trimmed_Qiime2Analysis/P40obese_sample_cleaned_trimmed_rename_OTUfeature-table_q17len100_filtered.tsv';
my $newtable2 = '/home/thsti/metagenomicsAnalysis/16sRNA_Obese/sample_cleaned_trimmed_Qiime2Analysis/P40obese_sample_cleaned_trimmed_rename_OTUfeature-table_q17len100_unwanted.tsv';
my $taxonomyCol = 20; # column number of the taxonomy in $ftable.
my @filterlist = 
	(
		'Unassigned',
		'd__Eukaryota',
		'Mitochondria',
		'Chloroplast',
		'd__Archaea',
	);
##
##
my $tobefilter = join("|", @filterlist);
open(TABLE, $ftable) or die "could not open the input file $ftable, $!";
open(OUT1, ">$newtable1") or die "could not open the output file $newtable1, $!";
open(OUT2, ">$newtable2") or die "could not open the output file $newtable2, $!";
while(my $ln =<TABLE>)
	{
		if($ln =~ /^#/)
			{

				print $ln;
				print OUT1 $ln;
				print OUT2 $ln;
			}
		else
			{
				$ln =~ s/^\s+|\s+$//;
				my @lnA = split(/\t/, $ln);
				#print $lnA[46],"\t",$tobefilter,"\n";
				if($lnA[$taxonomyCol-1] =~ m/$tobefilter/g)
					{
						print OUT2 $ln,"\n";
					}
				else
					{
						print OUT1 $ln,"\n";
					}
				undef(@lnA);
					
			}
	}
close(TABLE);
close(OUT1);
close(OUT2);

		


