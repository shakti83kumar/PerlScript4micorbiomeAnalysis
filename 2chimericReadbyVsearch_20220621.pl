#!/usr/bin/perl -w
use strict;
##
## raw reads is processed by fastp program
##
##
##
##
## ************************ user input ************************
##
##
my $inFolder       = '/home/thsti/metagenomicsAnalysis/01BDasSir/GarbhiniMicrobiome2Analysis/GarbhiniMicrobiomeData_01mergedreads'; #folder path of raw reads;
my $rawreadfmt = 'assembled.fastq';
my $vsearch  = 'vsearch'; #path of fastp program:
my $p = 1; #number of processors; 
##
## ************************************************************
my $outFolder     = $inFolder; #folder path of clean raw reads
my $inFolderNamePath = &Strip($inFolder);
my $outFolderNamePath = &Strip($outFolder);
#my (@fileArray, %baseNameHash);
opendir(INDIR, $inFolderNamePath)||die("Could not open the $inFolderNamePath\n");
while (my $file = readdir INDIR) 
 {
   $file = &Strip($file);
   next if($file =~ /^\.+/);
   if($file =~ /$rawreadfmt$/)
    {
    	my $assembledReads = $inFolderNamePath.'/'.$file;
    	my $nonchimeraReads = $assembledReads;
    	my $chimeraReads = $assembledReads;
    	my $chimeraLog = $assembledReads;
    	$nonchimeraReads =~ s/fastq$/nonchimera.fasta/;
    	$chimeraReads =~ s/fastq$/chimera.fasta/;
    	$chimeraLog =~ s/fastq$/chimeraAnalysis.log/;
    	print $nonchimeraReads,"\n";
    	print $chimeraReads, "\n";
       system("$vsearch --uchime_denovo $assembledReads --nonchimeras $nonchimeraReads --chimeras $chimeraReads --log $chimeraLog");
       #push(@fileArray, $file);
    }
 }
closedir(INDIR);
#undef(@fileArray);
#undef(%baseNameHash);
###........Removing either spaces or newline characters........................
sub Strip
 {
    my $stripVal = shift;
    $stripVal =~ s/^\s+|\s+$//;
    return($stripVal);
 }
