#!/usr/bin/perl -w
use strict;
##
##
##USAGE: running the BLAST program in batch mode  
## 
## ..............EXECUTE COMMOND in terminal...............
## export BLASTDB="/home/thsti/Databases/16S_ribosomal_RNA"
##
## ************** user input **********************************************
##
#print("Enter the input folderName or inputFolderPath:");
my $inFolder = '/home/thsti/metagenomicsAnalysis/16sRNA_Obese/sample_cleaned_trimmed_Qiime2Analysis/P40obese_sample_cleaned_trimmed_rename_OTUfeature-table_q17len100_filtered_CSTs';
#print ("Enter the NCBI nt/nr database Path:");
my $ncbiNR_NT = '/home/thsti/Databases/16S_ribosomal_RNA';
my $blastprgm = '/home/thsti/Softwares/ncbi-blast-2.13.0/bin/blastn';
my $threadsNum = 10;
##
## ************************************************************************
##
my $outFolder = $inFolder.'_blastn';
mkdir $outFolder, 0755;
my $inFolderNamePath = &Strip($inFolder);
$inFolderNamePath = &ProcessFolder($inFolderNamePath);
my $outFolderNamePath = &Strip($outFolder);
$outFolderNamePath = &ProcessFolder($outFolderNamePath);
$ncbiNR_NT = &Strip($ncbiNR_NT);
$ncbiNR_NT = &ProcessFolder($ncbiNR_NT);
my $ncbiNR_NT_path = $ncbiNR_NT.'16S_ribosomal_RNA';
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
my $outputfile;
my $outputfilePath;
my $inputfilePath;
opendir(INDIR, $inFolderNamePath)||die("Could not open the $inFolderNamePath\n");
while (my $file = readdir INDIR) 
 {
   $file = &Strip($file);
   next if($file =~ /^\.+/);
   my @fileArray = split(/\./, $file);
   print "...BLASTing the $fileArray[0]...\n";
   $outputfile = $fileArray[0].'_blastn';
   $outputfilePath = $outFolderNamePath.$outputfile;
   $inputfilePath = $inFolderNamePath.$file;
   &BLAST($inputfilePath, $outputfilePath);
   #open(OUT, ">$outputfilePath")||die("Could not open the $outputfilePath\n");
 }
sub BLAST
 {
    my ($in, $out) = @_;
    my (@cmd, $cmdLine, $logfile);
    @cmd = ("$blastprgm -task megablast");
    push(@cmd, "-query $in");       
    push(@cmd, "-db $ncbiNR_NT_path");     ## path of database 
    push(@cmd, "-max_target_seqs 10");     ## no of target hits to be printed
    push(@cmd, "-evalue 1e-5");            ## evalue can be changed.
    push(@cmd, "-num_threads $threadsNum");         ## number of thread can be changed.
    push(@cmd, "-outfmt '6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qcovs sscinames'"); ## customize output     
    push(@cmd, "-out $out");
    $cmdLine = join(" ", @cmd);
    system($cmdLine);
    undef @cmd;
 }
