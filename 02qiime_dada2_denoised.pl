#!/usr/bin/perl -w
use strict;
##
# qiime dada2 denoise-single \
#  --p-trim-left 0 \
#  --p-trunc-len 0 \
#  --i-demultiplexed-seqs {QIIME_DEMUX}.qza \
#  --o-representative-sequences {REP-SEQS}.qza \
#  --o-table {TABLE}.qza \
#  --o-denoising-stats {STATS}.qza
##
##
##
my $fasDict = '/home/thsti/metagenomicsAnalysis/01BDasSir/16sRNA_Balabhgharh_analysis/sample_trimmed_nr_qza';
my $outDict = '/home/thsti/metagenomicsAnalysis/01BDasSir/16sRNA_Balabhgharh_analysis/sample_trimmed_nr_qza';
my $format = '.qza';
opendir(DIR, $fasDict) or die "could not open the directory $fasDict $!";
mkdir($outDict, 0755);
while(my $file = readdir(DIR))
	{
		if($file =~ /$format$/)
			{
				my $fileName = $file;
				print $fileName, "\n";
				$fileName =~ s/$format$//;
				my $input = $fasDict.'/'.$file;
				my $fileNameRepsq = $outDict.'/'.$fileName.'_repseq.qza';
				my $fileNameTable = $outDict.'/'.$fileName.'_table.qza';
				my $fileNameStats = $outDict.'/'.$fileName.'_stats.qza';
				system("qiime dada2 denoise-single --p-trim-left 0 --p-trunc-len 0 --i-demultiplexed-seqs $input --o-representative-sequences $fileNameRepsq --o-table $fileNameTable --o-denoising-stats $fileNameStats");
			}
	}
closedir(DIR);
