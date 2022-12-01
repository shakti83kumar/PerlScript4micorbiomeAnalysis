#!/usr/bin/perl -w
use strict;

my $fasDict = '/home/thsti/metagenomicsAnalysis/01BDasSir/16sRNA_Balabhgharh_analysis/sample144';
my $outDict = '/home/thsti/metagenomicsAnalysis/01BDasSir/16sRNA_Balabhgharh_analysis/sample144_nr';
my $format = 'fasta';
opendir(DIR, $fasDict) or die "could not open the directory $fasDict $!";
mkdir($outDict, 0755);
while(my $file = readdir(DIR))
	{
		if($file =~ /fasta$/)
			{
				my %ids;
				my $fileName = $file;
				open(FILE, $fasDict.'/'.$fileName) or die"could not open the directory $fileName $!";
				open(OUT, '>'.$outDict.'/'.$fileName) or die"could not be created $fileName $!";
				while(my $line = <FILE>)
					{
						if ($line =~ /^>/)
							{
								$line =~ s/^\s+|\s+$//;
								my @lineA = split(/\s/, $line);
								$ids{$lineA[0]} += 1;
							}
					}
				foreach my $cap (keys%ids)
					{
						print OUT $cap,"\t", $ids{$cap},"\n";
					}
					
				close(FILE);
				close(OUT);
			}
	}
