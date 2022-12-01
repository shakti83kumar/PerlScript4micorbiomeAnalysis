#!/usr/bin/perl -w
use strict;
##
##
##	combing metadata.tsv and feature-table.tsv 
##	to make new table with seq taxonomy hirarchy and frequency table
##
##
my $metadata = '/home/thsti/metagenomicsAnalysis/01BDasSir/16sRNA_Balabhgharh_analysis/16sRNA_Balabhgharh_OTUfeature-tablemetadata.tsv';
my $ftable = '/home/thsti/metagenomicsAnalysis/01BDasSir/16sRNA_Balabhgharh_analysis/16sRNA_Balabhgharh_OTUfeature-table.tsv';
my $newtable = '/home/thsti/metagenomicsAnalysis/01BDasSir/16sRNA_Balabhgharh_analysis/16sRNA_Balabhgharh_OTUftable_combined.tsv';
##
##

open(TABLE, $ftable) or die "could not open the input file $ftable, $!";
open(OUT, ">$newtable") or die "could not open the output file $newtable, $!";
my %otuTax;
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
				my ($tax, $seq) = &ParsingMetaData($ftureID, $metadata);
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
			}
	}
undef(%otuTax);
close(TABLE);
close(OUT);
##
## ****************************ParsingMetaData****************************************
sub ParsingMetaData
	{
		my($id, $file) = @_;
		my ($tx, $sq);
		#print $id,"\t",$file,"\n";
		open(FILE, $file) or die "could not open the input file $file, $!";
		while(my $l = <FILE>)
			{
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
		close(FILE);
		return($tx, $sq);
	}
