#!/usr/bin/perl -w
use strict;
use Parallel::ForkManager;
##
## raw reads is processed by fastp program
##
##
##
##
## ************************ user input ************************
##
##
my $inFolder       = '/media/thsti/backup/04MetagenomicsAnalysis/01BDasSir/GarbhiniMicrobiome2Analysis/GarbhiniMicrobiomeData_02mergedreads'; #folder path of raw reads;
my $rawreadfmt = 'assembled.fastq';
my $vsearch  = 'vsearch'; #path of fastp program:
my $p = 10; #number of processors; 
##
## ************************************************************
my $outFolder     = $inFolder; #folder path of clean raw reads
my $inFolderNamePath = &Strip($inFolder);
my $outFolderNamePath = &Strip($outFolder);
#my (@fileArray, %baseNameHash);
opendir(INDIR, $inFolderNamePath)||die("Could not open the $inFolderNamePath\n");
my @filesArray = grep(/$rawreadfmt$/,readdir(INDIR));
if(scalar(@filesArray)<$p)
	{
		$p = scalar(@filesArray);
	}
my $pm =  Parallel::ForkManager->new($p);
foreach my $file (@filesArray)
	{
    		my $assembledReads = $inFolderNamePath.'/'.$file;
    		my $nonchimeraReads = $assembledReads;
    		my $chimeraReads = $assembledReads;
    		my $chimeraLog = $assembledReads;
    		$nonchimeraReads =~ s/fastq$/nonchimera.fasta/;
    		$chimeraReads =~ s/fastq$/chimera.fasta/;
    		$chimeraLog =~ s/fastq$/chimeraAnalysis.log/;
    		my $pid = $pm->start() and next;
    		print "PID: $$\n";
    		print $nonchimeraReads,"\n";
    		print $chimeraReads, "\n";
    		&PROCESS($vsearch, $assembledReads, $nonchimeraReads, $chimeraReads, $chimeraLog);
       	#system("$vsearch --uchime_denovo $assembledReads --nonchimeras $nonchimeraReads --chimeras $chimeraReads --log $chimeraLog");
       	$pm -> finish();
       }
$pm->wait_all_children;
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
 
###.............Processing the code............................................
sub PROCESS
	{
		my ($program, $R12, $nonchimeraR12, $chimeraR12, $chimeraR12Log) = @_;
		system("$program --uchime_denovo $R12 --nonchimeras $nonchimeraR12 --chimeras $chimeraR12 --log $chimeraR12Log");
	}
