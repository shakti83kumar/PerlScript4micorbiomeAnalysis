#!/usr/bin/perl -w
use strict;
##
##
## To change the 'A1_R1.fastq' --> 'COVID_A1_L001_R1_001.fastq.gz'
##
##
my $fastqDir = '/home/adapt/DrBabhtoshSirProjects/metagenomicsAnalysis/20210713covid19TrimPairedReads';
my $outputDir = '/home/adapt/DrBabhtoshSirProjects/metagenomicsAnalysis/20210713covid19TrimPairedReadsGZ';
my $metadataFile = '/home/adapt/DrBabhtoshSirProjects/metagenomicsAnalysis/covid19_Sample_metadata'; 
##
##
open(META, ">$metadataFile") or die "could not open $metadataFile $!";
opendir(DIR, $fastqDir) or die "could not open $fastqDir $!";
my %HashmetaName;
while(my $fq = readdir(DIR))
	{
		if($fq =~ /fastq$/)
			{
				$fq =~ s/^\s+|\s+$//;
				my $infile = $fastqDir.'/'.$fq;
				my @fqA = split(/\_|\./, $fq);
				my $newfq = 'COVID'.$fqA[0].'_'.$fqA[0].'_'.'L001'.'_'.$fqA[1].'_'.'001'.'.fastq';
				my $metadata = 'COVID'.$fqA[0];
				print $metadata, "\n";
				$HashmetaName{$metadata} += 1;
				my $outfile = $outputDir.'/'.$newfq;
				print $fq,'-->', $newfq, "\n";
				open(IN, $infile) or die "could not open $infile $!";
				open(OUT, ">$outfile") or die "could not open $outfile $!";
				while(my $ln = <IN>)
					{
						print OUT $ln;
					}
				system("gzip $outfile");
				close(IN);
				close(OUT);
				undef(@fqA);
			}
	}
closedir(DIR);
foreach my $keyword (keys( %HashmetaName))
	{
		print META $keyword,"\n";
	}
close(META);
undef(%HashmetaName);
