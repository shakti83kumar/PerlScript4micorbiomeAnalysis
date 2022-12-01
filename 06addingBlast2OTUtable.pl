#!/usr/bin/perl -w
use strict;
##
##
##	combing metadata.tsv and feature-table.tsv 
##	to make new table with seq taxonomy hirarchy and frequency table
##
##
my $ftable = '/home/thsti/metagenomicsAnalysis/16sRNA_Obese/sample_cleaned_trimmed_Qiime2Analysis/P40obese_sample_cleaned_trimmed_rename_OTUfeature-table_q17len100_filtered.tsv';
my $be2addfolder = '/home/thsti/metagenomicsAnalysis/16sRNA_Obese/sample_cleaned_trimmed_Qiime2Analysis/P40obese_sample_cleaned_trimmed_rename_OTUfeature-table_q17len100_filtered_CSTs_blastn';
my $newtable = '/home/thsti/metagenomicsAnalysis/16sRNA_Obese/sample_cleaned_trimmed_Qiime2Analysis/P40obese_sample_cleaned_trimmed_rename_OTUfeature-table_q17len100_filtered_besthit.tsv';
##
##

open(TABLE, $ftable) or die "could not open the input file $ftable, $!";
open(OUT, ">$newtable") or die "could not open the output file $newtable, $!";
while(my $ln =<TABLE>)
	{
		if($ln =~ /^#/)
			{
				if($ln =~ m/^#CST/)
					{
						$ln =~ s/^\s+|\s+$//;
						#print $ln,"\t",'species_name',"\t",'%identity',"\t",'%queryCov',"\t",'eValue',"\n";
						print OUT $ln,"\t",'species_name',"\t",'%identity',"\t",'%queryCov',"\t",'eValue',"\n";
					}
			}
		else
			{
				$ln =~ s/^\s+|\s+$//;
				my @lnA = split(/\t/, $ln);
				my $ftureID =  $lnA[0].'_'.$lnA[1];
				my ($sps, $idperc, $qcovperc, $eval) = &ParsingFolder($lnA[0], $ftureID, $be2addfolder);
				#print $ln,"\t",$sps,"\t",$idperc,"\t",$qcovperc,"\t",$eval,"\n";
				print OUT $ln,"\t",$sps,"\t",$idperc,"\t",$qcovperc,"\t",$eval,"\n";
				undef(@lnA);
			}
	}
close(TABLE);
close(OUT);
##
## ****************************ParsingMetaData****************************************
sub ParsingFolder
	{
		my($cstid, $fid, $folder) = @_;
		#print $cstid,"\t",$fid,"\t",$folder,"\n";
		my $sp = 'NA';
		my $idper = 'NA';
		my $qcv = 'NA';
		my $eval = 'NA';
		my $fileName = $folder.'/'.$cstid.'_blastn_besthit1';
		#print $fileName, "\n";
		open(FILE, $fileName) or die "could not open the input file $fileName, $!";
		while(my $l = <FILE>)
			{
				$l =~ s/^\s+|\s+$//;
				#print $l,"\n";
				my @al = split(/\t/, $l);
				print $al[0],"\t",$fid,"\n";
				if($al[0] eq $fid)
					{
						$idper = $al[2];
						$eval = $al[10];					
						$qcv = $al[12];
						my @spsName = split(/ /, $al[13]);
						$sp = 'g__'.$spsName[0].'; '.'s__'.$spsName[1]
					}
				undef(@al);
			}
		print $sp,"\t",$idper,"\t",$qcv,"\t",$eval,"\n";
		return($sp, $idper, $qcv, $eval);
		close(FILE);
	}
