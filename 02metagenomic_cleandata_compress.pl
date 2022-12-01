#!/usr/bin/perl -w
use strict;
##
## To combined forward reads with unpaired reads
## 
## ************************ user input ************************
##
##
my $inFolder       = '/home/thsti/metagenomicsAnalysis/01BDasSir/20220323_R29_PE'; #folder path of clean raw reads
my $identifier = 'fq';
##
##
## ************************************************************
my $outFolder     = $inFolder.'_02GZ'; #folder path of clean raw reads
mkdir($outFolder, 0755);
opendir(DIR, $inFolder) or die("could not open $inFolder\n");
while(readdir(DIR))
     {
           if($_ =~ /$identifier$/)
             { 
                  #print $_,"\n";
                  my $sample = $_;
                  $sample =~ s/^\s+|\s+$//;
                  $sample =~ s/$identifier$//;
                  my $input = $sample;
                  my $inputfile = $inFolder.'/'.$input.'fq';
                  my $outputfile = $outFolder.'/'.$input.'fastq';
                  open(OUT, ">$outputfile") or die("could not open file $outputfile\n");
                  open(IN, $inputfile) or die("could not open file $inputfile\n");
                  while(my $ln = <IN>)
                  	{
                  		print OUT $ln; 
                  	}
                  close(IN);
                  #my $pairedfwdread = $inFolder.'/'.$sample.'_R1.fq';
                  #my $pairedrwdread = $inFolder.'/'.$sample.'_R2.fq';
                  #my $unpairedfwdread = $inFolder.'/'.$sample.'_R1_unpaired.fq';
                  #my $unpairedrwdread = $inFolder.'/'.$sample.'_R2_unpaired.fq';
                  #foreach my $file ($pairedfwdread, $unpairedfwdread, $unpairedrwdread)
                  #	{
                  #		next if(-z $file);
                  #		print $file,"\n";
                  #		open (IN, $file) or die("could not open $file\n");
                  #		while(my $ln = <IN>)
                  #			{
                  #				print OUT $ln; 
                  #			}
                  #		close(IN);
                  #		
                  #	}
                  close(OUT);
                  system("gzip $outputfile");
              }
    }
closedir(DIR);
