#!/usr/bin/perl -w
use strict;
##
##
##	combing metadata.tsv and feature-table.tsv 
##	to make new table with seq taxonomy hirarchy and frequency table
##
##
my $metadata = '/home/thsti/metagenomicsAnalysis/16sRNA_Obese/sample_cleaned_trimmed_Qiime2Analysis/metadata_q17len100.tsv';
my $ftable = '/home/thsti/metagenomicsAnalysis/16sRNA_Obese/sample_cleaned_trimmed_Qiime2Analysis/P40obese_sample_cleaned_trimmed_rename_OTUfeature-table_q17len100.tsv';
my $newtable = '/home/thsti/metagenomicsAnalysis/16sRNA_Obese/sample_cleaned_trimmed_Qiime2Analysis/P40obese_sample_cleaned_trimmed_rename_OTUfeature-table_q17len100_combined1.tsv';
##
##

open(TABLE, $ftable) or die "could not open the input file $ftable, $!";
open(OUT, ">$newtable") or die "could not open the output file $newtable, $!";
my ($otuTax, $otuSeq) = &MakeHash($metadata);
my %otuTax = %$otuTax;
my %otuSeq = %$otuSeq;
my $otuNum = 1;
while(my $ln =<TABLE>)
	{
		if($ln =~ /^#/)
			{
				if($ln =~ /^#OTU ID/)
					{
						$ln =~ s/^\s+|\s+$//;
						print '#CST ID',"\t",$ln,"\t",'taxonomy',"\t",'sequence',"\n";
						print OUT '#CST ID',"\t",$ln,"\t",'taxonomy',"\t",'sequence',"\n";
					}
				else
					{
						print $ln;
						print OUT $ln;
					}
			}
		else
			{
				$ln =~ s/^\s+|\s+$//;
				my @lnA = split(/\t/, $ln);
				my $ftureID =  $lnA[0];
				#my ($tax, $seq) = &ParsingMetaData($ftureID, @meta);
				my $tax = $otuTax{$ftureID};
				my $seq = $otuSeq{$ftureID};
				my $num2keep;
				if(exists $otuTax{$tax})
					{
						$num2keep = $otuTax{$tax};
					}
				else
					{
						$otuTax{$tax} = 'CST_'.$otuNum;
						$num2keep = 'CST_'.$otuNum;
						$otuNum++;
						
					}
				print $num2keep,"\t",$ln,"\t",$tax,"\t",$seq,"\n";
				print OUT $num2keep,"\t",$ln,"\t",$tax,"\t",$seq,"\n";
				undef(@lnA);
				delete($otuTax{$ftureID});
				delete($otuSeq{$ftureID});
			}
	}
close(TABLE);
close(OUT);
undef(%otuTax);
undef(%otuSeq);
undef(%otuSeq);
##
## ****************************ParsingMetaData****************************************
sub ParsingMetaData
	{
		my ($id, @m) = @_;
		my ($tx, $sq);
		#print $id,"\t",$file,"\n";
		for(my $a = 0; $a<scalar@m; $a++)
			{
				my $l = $m[$a];
				$l =~ s/^\s+|\s+$//;
				my @al = split(/\t/, $l);
				#print $al[0], "\n";
				if($al[0] eq $id)
					{
						$sq = $al[1];						
						$tx = $al[2];
						last;
					}
				undef(@al);
			}
		return($tx, $sq);
	}
##
## ************************Hash table of Seq and Tax**********************************
sub MakeHash
	{ 
		my $metadata = shift;
		open(META, $metadata) or die "could not open the input file $metadata, $!";
		my (%taxhash, %seqhash);
		while(<META>)
			{
				if($. > 2)
					{
						my $l = $_;
						$l =~ s/^\s+|\s+$//;
						my @al = split(/\t/, $l);
						$taxhash{$al[0]} = $al[2];
						$seqhash{$al[0]} = $al[1];
					} 
			}
		return(\%taxhash, \%seqhash);
		close(META);
	}
			
