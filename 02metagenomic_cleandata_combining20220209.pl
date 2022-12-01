#!/usr/bin/perl -w
use strict;
##
## To combined forward reads with unpaired reads
## 
## ************************ user input ************************
##
##
my $inFolder       = '/home/thsti/metagenomicsAnalysis/RJD_microbiome_analysis/Data_Microbiome_Human_Coco_01trimmo'; #folder path of clean raw reads
my $identifier = 'RD';
##
##
## ************************************************************
my $outFolder     = $inFolder.'_02combinedGZ'; #folder path of clean raw reads
mkdir($outFolder, 0755);
opendir(DIR, $inFolder) or die("could not open $inFolder\n");
while(readdir(DIR))
     {
           if($_ =~ /log$/)
             { 
                  #print $_,"\n";
                  my $sample = $_;

                  $sample =~ s/^\s+|\s+$//;
                  $sample =~ s/_log$//;
                  my $output = $outFolder.'/'.$identifier.$sample.'_'.$sample.'_L001_'.'R1_001.fastq';
                  open(OUT, ">$output") or die("could not open file $output\n");
                  my $pairedfwdread = $inFolder.'/'.$sample.'_R1.fq';
                  my $pairedrwdread = $inFolder.'/'.$sample.'_R2.fq';
                  my $unpairedfwdread = $inFolder.'/'.$sample.'_R1_unpaired.fq';
                  my $unpairedrwdread = $inFolder.'/'.$sample.'_R2_unpaired.fq';
                  foreach my $file ($pairedfwdread, $unpairedfwdread, $unpairedrwdread)
                  	{
                  		next if(-z $file);
                  		print $file,"\n";
                  		open (IN, $file) or die("could not open $file\n");
                  		while(my $ln = <IN>)
                  			{
                  				print OUT $ln; 
                  			}
                  		close(IN);
                  		
                  	}
                  close(OUT);
                  system("gzip $output");
              }
    }
closedir(DIR);
