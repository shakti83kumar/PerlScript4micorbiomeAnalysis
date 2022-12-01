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
my $inFolder       = '/home/thsti/GenomeAssembling/20220527_R42'; #folder path of raw reads
my $rawreadfmt = 'fastq.gz';
my $fastp  = 'fastp'; #path of fastp program:
my $merge = 'Y';
my $qual = 20;
my $trim = 10;
my $minlngth = 50;
my $want2trim = 'Y';
my $adpterfile = '/home/thsti/Softwares/Trimmomatic-0.39/adapters/TruSeq3-SE.fa';
##
## ************************************************************
my $outFolder     = $inFolder.'_01fastp_withunmerged'; #folder path of clean raw reads
mkdir($outFolder, 0755);
my $inFolderNamePath = &Strip($inFolder);
my $outFolderNamePath = &Strip($outFolder);
$inFolderNamePath = &ProcessFolder($inFolderNamePath);
$outFolderNamePath = &ProcessFolder($outFolderNamePath);
my (@fileArray, %baseNameHash);
opendir(INDIR, $inFolderNamePath)||die("Could not open the $inFolderNamePath\n");
opendir(INDIR, $inFolderNamePath)||die("Could not open the $inFolderNamePath\n");
while (my $file = readdir INDIR) 
 {
   $file = &Strip($file);
   next if($file =~ /^\.+/);
   if($file =~ /$rawreadfmt$/)
    {
       my @fileNameArray = split(/\_/, $file);
       #my $baseName = join("_", $fileNameArray[0]);
       my $baseName = join("_", @fileNameArray[0..1]);
       $baseNameHash{$baseName} += 1;
       #push(@fileArray, $file);
    }
 }
foreach my $eachFile (sort (keys %baseNameHash))
 {
	#my $inFarwdRead = $inFolderNamePath.$eachFile.'_R1.'.$rawreadfmt;
	#my $inRevsdRead = $inFolderNamePath.$eachFile.'_R2.'.$rawreadfmt;
	my $inFarwdRead = $inFolderNamePath.$eachFile.'_L001_R1_001.'.$rawreadfmt;
	my $inRevsdRead = $inFolderNamePath.$eachFile.'_L001_R1_001.'.$rawreadfmt;
	my $outFarwdRead = $outFolderNamePath.$eachFile.'_L001_R1_001.'.$rawreadfmt;
	my $outRevsdRead = $outFolderNamePath.$eachFile.'_L001_R2_001.'.$rawreadfmt;
	my $unpaired_outFarwdRead = $outFolderNamePath.$eachFile.'_L001_R1_unpaired.'.$rawreadfmt;
	my $unpaired_outRevsdRead = $outFolderNamePath.$eachFile.'_L001_R2_unpaired.'.$rawreadfmt;
	my $failed_out_reads = $outFolderNamePath.$eachFile.'_L001_failed_out.'.$rawreadfmt;
	my $merged_reads = $outFolderNamePath.$eachFile.'_L002_R1_001.'.$rawreadfmt;
	my $outputBase = $outFolderNamePath.$eachFile;
	my $combined_reads = $outFolderNamePath.$eachFile.'_L003_R1_001.'.$rawreadfmt;
	&FastpProcess($fastp, $inFarwdRead, $inRevsdRead, $outFarwdRead, $outRevsdRead, $unpaired_outFarwdRead, $unpaired_outRevsdRead, $merged_reads, $failed_out_reads, $outputBase, $adpterfile);
	system("cat $merged_reads $unpaired_outFarwdRead $unpaired_outRevsdRead >$combined_reads");
   }
closedir(INDIR);
undef(@fileArray);
undef(%baseNameHash);
##
##
## ************************* fastp processing ******************************
sub FastpProcess
	{
		my ($prg, $iR1, $iR2, $oR1, $oR2, $unR1, $unR2, $mgR, $flR, $out, $adpterfile) = @_;
		my (@cmd, $cmdLine, $logfile, $verbose);
		$logfile = $out."_log";
		$verbose = $out.'_verbose';
		print $out, "\n";
		@cmd = ($prg);
		push(@cmd, "-m") if($merge eq 'Y');
		push(@cmd, "--adapter_fasta $adpterfile");
		#push(@cmd, "-f $trim");         ## trimming how many bases in front for read1.
		#push(@cmd, "-F $trim");         ## trimming how many bases in front for read2.
		#push(@cmd, "-t $trim");         ## trimming how many bases in front for read1,
		#push(@cmd, "-T $trim");         ## trimming how many bases in tail for read2. 
		push(@cmd, "-q $qual");         ## the quality value that a base is qualified.
		push(@cmd, "-5 $qual");
		push(@cmd, "-3 $qual");
		push(@cmd, "-r $qual");		
		push(@cmd, "-l $minlngth");	    
		push(@cmd, "-i $iR1");
		push(@cmd, "-I $iR2");
		push(@cmd, "-o $oR1");
		push(@cmd, "-O $oR2");
		push(@cmd, "--merged_out $mgR") if($merge eq 'Y');
		push(@cmd, "--unpaired1 $unR1");
		push(@cmd, "--unpaired2 $unR2");
		push(@cmd, "--failed_out $flR");
		push(@cmd, "-h $logfile");
		push(@cmd, "-j $logfile");
		#push(@cmd, "-V $verbose");
		
=for
fastp -m -i /home/thsti/metagenomicsAnalysis/01BDasSir/R29test3/Rakesh-K-TyagiS24/Rakesh-K-Tyagi_S24_L001_R1_001.fastq.gz
-r 20 \
-q 20 \
-l 50 \
-o /home/thsti/metagenomicsAnalysis/01BDasSir/R29test3/Rakesh-K-TyagiS24/Rakesh-K-Tyagi_S24_L001_R1.fastq.gz \
-I /home/thsti/metagenomicsAnalysis/01BDasSir/R29test3/Rakesh-K-TyagiS24/Rakesh-K-Tyagi_S24_L001_R2_001.fastq.gz \
-O /home/thsti/metagenomicsAnalysis/01BDasSir/R29test3/Rakesh-K-TyagiS24/Rakesh-K-Tyagi_S24_L001_R2.fastq.gz \
--unpaired1 /home/thsti/metagenomicsAnalysis/01BDasSir/R29test3/Rakesh-K-TyagiS24/Rakesh-K-Tyagi_S24_L001_U1.fastq.gz \
--unpaired2 /home/thsti/metagenomicsAnalysis/01BDasSir/R29test3/Rakesh-K-TyagiS24/Rakesh-K-Tyagi_S24_L001_U2.fastq.gz  \
--merged_out /home/thsti/metagenomicsAnalysis/01BDasSir/R29test3/Rakesh-K-TyagiS24/Rakesh-K-Tyagi_S24_L002_R1_001.fastq.gz
=cut
		$cmdLine = join(" ", @cmd);
		system($cmdLine);
		undef @cmd;	
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
      #$folderNamePath =~ s/\/$//;
      return($folderNamePath);
   }
else
   {
      $folderNamePath = $folderNamePath.'/';
      return($folderNamePath);
   }
 }


