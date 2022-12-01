#!/usr/bin/perl -w
use strict;
##
##
## filtering the blast result with seqence identity and coverage and GC calculation  
##
## ************************* user input *******************************************
##
#my $blast_folder_path  = '/home/thsti/metagenomicsAnalysis/16sRNA_Obese/sample_cleaned_trimmed_Qiime2Analysis/P40obese_sample_cleaned_trimmed_rename_OTUfeature-table_q17len100_filtered_CSTs_blastn';
#my $contig_folder_path = '/home/thsti/metagenomicsAnalysis/16sRNA_Obese/sample_cleaned_trimmed_Qiime2Analysis/P40obese_sample_cleaned_trimmed_rename_OTUfeature-table_q17len100_filtered_CSTs';
#my $contig_format = 'fasta';
##
my $blast_folder_path  = '/media/shakti/SHAKTI4/04MetagenomicsAnalysis/GarbhiniMicrobiome2Analysis/ptb_garbhini_NIBMG-20221103T184910Z-001/ptb_garbhini_NIBMG/otuseqBLASTnResults';
my $contig_folder_path = '/media/shakti/SHAKTI4/04MetagenomicsAnalysis/GarbhiniMicrobiome2Analysis/ptb_garbhini_NIBMG-20221103T184910Z-001/ptb_garbhini_NIBMG/otusequencesfastafiles';
my $contig_format = 'fasta'; 
## ********************************************************************************
$blast_folder_path = Strip($blast_folder_path);
$blast_folder_path = ProcessFolder($blast_folder_path);
$contig_folder_path = Strip($contig_folder_path);
$contig_folder_path = ProcessFolder($contig_folder_path);
$contig_format = Strip($contig_format);
opendir(INDIR, $contig_folder_path)||die("\n\nERRORR.....\nCould not open the $contig_folder_path\n");
while(my $file = readdir(INDIR))
   {
        if($file =~ /$contig_format$/)
          {
              my @filePart = split(/\./, $file);
              my $blastFile = $filePart[0].'_blastn';
              #my $contigPathFile = $contig_folder_path.$file;
              #my $blastPathFile  = $blast_folder_path.$blastFile;
              #print $contigPathFile, "\n";
              #print $blastPathFile, "\n";
              system("perl PerlScriptsNGS/2contig_filtering_by_identitiy_and_coverage20220411.pl $blast_folder_path $contig_folder_path $file $blastFile");
              #system("perl PerlScriptsNGS/3GCcontentContigs_BlastParsing_spades.pl $blast_folder_path $contig_folder_path $file $blastFile");
              #system("perl PerlScriptsNGS/4species_diversity_calculation.pl $blast_folder_path $contig_folder_path $file $blastFile");    
              #system("perl PerlScriptsNGS/5contigs_segrigation_by_species.pl $blast_folder_path $contig_folder_path $file $blastFile");                          
          }
   }
closedir(INDIR);
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
 ###............................................................................
