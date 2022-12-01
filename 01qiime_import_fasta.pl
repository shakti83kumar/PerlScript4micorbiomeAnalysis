#!/usr/bin/perl -w
use strict;

my $fasDict = '/home/thsti/metagenomicsAnalysis/01BDasSir/16sRNA_Balabhgharh_analysis/sample_trimmed_nr';
my $outDict = '/home/thsti/metagenomicsAnalysis/01BDasSir/16sRNA_Balabhgharh_analysis/sample_trimmed_nr_qza';
my $format = 'fasta';
opendir(DIR, $fasDict) or die "could not open the directory $fasDict $!";
mkdir($outDict, 0755);
while(my $file = readdir(DIR))
	{
		if($file =~ /fasta$/)
			{
				my $fileName = $file;
				$fileName =~ s/fasta$//;
				my $fileNameqza = $fileName.'qza';
				my $input = $fasDict.'/'.$file;
				my $output = $outDict.'/'.$fileNameqza;
				system("qiime tools import --type FeatureData[Sequence] --input-path $input --output-path $output");
				print $fileName, "\n";
			}
	}
