#!/usr/bin/perl -w
use strict;
##
##
## reading the trimmomatic generated summary file
##
## ************************ user input ************************
##
##
my $inFolder  = '/home/thsti/metagenomicsAnalysis/01BDasSir/20220223_R29rawread_01trimmo'; #folder path of raw reads
##
##
## ************************************************************
my $output = $inFolder.'_all_summaries.xlsx';
my $inFolderNamePath = &Strip($inFolder);
   $inFolderNamePath = &ProcessFolder($inFolderNamePath);
#my $inputpath = $inFolderNamePath;
#   $inputpath =~ s/\/+$//;    
#my @path = split(/\//, $inputpath);
#my $outfile = $path[$#path].'_all_summaries';
#my $output = $inFolderNamePath.$outfile;
opendir(INDIR, $inFolderNamePath)||die("Could not open the $inFolderNamePath\n");
open(OUTPT, ">$output")||die("\n\n\n ERROR!!!!!!\nCould not open the $output\n\n\n");
print OUTPT "#sample", "\t";
print OUTPT "Input Read Pairs","\t";
print OUTPT "Both Surviving Reads", "\t";
print OUTPT "\%Both Surviving Read", "\t";
print OUTPT "Forward Only Surviving Reads", "\t";
print OUTPT "\%Forward Only Surviving Read", "\t";
print OUTPT "Reverse Only Surviving Reads", "\t";
print OUTPT "\%Reverse Only Surviving Read","\t";
print OUTPT "Dropped Reads", "\t";
print OUTPT "\%Dropped Read", "\n";
while (my $file = readdir INDIR) 
 {
   $file = &Strip($file);
   next if($file =~ /^\.+/);
   if($file =~ /summary$/)
    {
      $file =~ s/^\s+|\s+$//;
      my $fileName =  $file;
      $fileName =~ s/_summary$//;
      print OUTPT $fileName, "\t";
      my $readingFile = $inFolderNamePath.$file;
      my @sum;
      open(FILE, $readingFile)||die("\n\n\n ERROR!!!!!!\nCould not open the $readingFile\n\n\n");
      while(<FILE>)
        {
          if($_ !~ /^\s+/)
           {
              my $ln = $_;
              $ln =~ s/^\s+|\s+$//;
              my @lnArray = split(/\:/, $ln);
              push(@sum, $lnArray[$#lnArray]);
            }
        }   
     my $sumline = join("\t", @sum);
     print OUTPT $sumline, "\n";    
    }
 }
###........Removing either spaces or newline characters........................
sub Strip
 {
    my $stripVal = shift;
    $stripVal =~ s/^\s+|\s+$//;
    return($stripVal);
 }
###..........processing input or output folders................................
sub ProcessFolder
 {
   my $folderNamePath = shift;
   if($folderNamePath =~ /\/$/)
   {
      return($folderNamePath);
   }
else
   {
      $folderNamePath = $folderNamePath.'/';
      return($folderNamePath);
   }
 }
