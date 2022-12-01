#!/usr/bin/perl -w
use strict;


## ************************ user input ************************
##
##
my $inFolder       = '/home/thsti/metagenomicsAnalysis/01BDasSir/20220223_R29rawread'; #folder path of raw reads
my $trimoJavaPath  = '/home/thsti/Softwares/Trimmomatic-0.39'; #path of the trimmomatic jar file:
my $extensionOfrawdata = 'fastq.gz'; 
##
##
## ************************************************************
my $outFolder     = $inFolder.'_01trimmo'; #folder path of clean raw reads
mkdir($outFolder, 0755);
my $inFolderNamePath = &Strip($inFolder);
my $outFolderNamePath = &Strip($outFolder);
$inFolderNamePath = &ProcessFolder($inFolderNamePath);
$outFolderNamePath = &ProcessFolder($outFolderNamePath);
$trimoJavaPath = &Strip($trimoJavaPath);
$trimoJavaPath = &ProcessFolder($trimoJavaPath);
my $jarName = &FindJar($trimoJavaPath);
my $trimoJava = $trimoJavaPath.$jarName;
my $primerPath = $trimoJavaPath.'adapters'.'/'.'NexteraPE-PE.fa';
my (@fileArray, %baseNameHash);
opendir(INDIR, $inFolderNamePath)||die("Could not open the $inFolderNamePath\n");
while (my $file = readdir INDIR) 
 {
   $file = &Strip($file);
   next if($file =~ /^\.+/);
   if($file =~ /$extensionOfrawdata$/)
    {
       my @fileNameArray = split(/\_/, $file);
       my $baseName = join("_", @fileNameArray[0..2]);
       $baseNameHash{$baseName} += 1;
       #push(@fileArray, $file);
    }
 }
foreach my $eachFile (sort (keys %baseNameHash))
 {
   my $inFarwdRead = $inFolderNamePath.$eachFile.'_R1_001.'.$extensionOfrawdata;
   my $inRevsdRead = $inFolderNamePath.$eachFile.'_R2_001.'.$extensionOfrawdata;
   my $outFarwdRead = $outFolderNamePath.$eachFile.'_R1_001.fq';
   my $outRevsdRead = $outFolderNamePath.$eachFile.'_R2_001.fq';
   my $unpaired_outFarwdRead = $outFolderNamePath.$eachFile.'_R1_unpaired.fq';
   my $unpaired_outRevsdRead = $outFolderNamePath.$eachFile.'_R2_unpaired.fq';
   my $failed_out_reads = $outFolderNamePath.$eachFile.'_failed_out.fq';
   my $outputBase = $outFolderNamePath.$eachFile;
=head
   $inFarwdRead = $inFolderNamePath.$eachFile.'_R1'.'.fastq.gz';
   $inRevsdRead = $inFolderNamePath.$eachFile.'_R2'.'.fastq.gz';
   $outFarwdRead = $outFolderNamePath.$eachFile.'_R1.fq';
   $outRevsdRead = $outFolderNamePath.$eachFile.'_R2.fq';
   $unpaired_outFarwdRead = $outFolderNamePath.$eachFile.'_R1_unpaired.fq';
   $unpaired_outRevsdRead = $outFolderNamePath.$eachFile.'_R2_unpaired.fq';
   $failed_out_reads = $outFolderNamePath.$eachFile.'_failed_out.fq';
   $outputBase = $outFolderNamePath.$eachFile;
=cut
	 print ("filename: $eachFile\n");
         print ("Java path: $trimoJava\n");
         print ("farword primer: $inFarwdRead\n");
         print ("reverse read: $inRevsdRead\n");
         print ("output file name: $outputBase\n");
         print ("Illumina primer path: $primerPath\n");
         &TrimmomaticProcess($trimoJava, $inFarwdRead, $inRevsdRead, $outFarwdRead, $outRevsdRead, $unpaired_outFarwdRead, $unpaired_outRevsdRead, $outputBase, $primerPath);
   }
closedir(INDIR);
undef(@fileArray);
undef(%baseNameHash);
##
##
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
###..........Trimomatic Processing ............................................

sub TrimmomaticProcess
 {
#java -jar trimmomatic-0.39.jar PE input_forward.fq.gz input_reverse.fq.gz output_forward_paired.fq.gz output_forward_unpaired.fq.gz output_reverse_paired.fq.gz output_reverse_unpaired.fq.gz ILLUMINACLIP:TruSeq3-PE.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 MINLEN:36
    my ($trimPrg, $forwardR, $reverseR, $outFarwdRead, $outRevsdRead, $unpaired_outFarwdRead, $unpaired_outRevsdRead, $baseOutput, $primerPath) = @_;
    print ("subrutine java path: $trimPrg\n");
    my (@cmd, $cmdLine, $logfile, $sumfile);
    $logfile = $baseOutput."_log";
    $sumfile = $baseOutput."_summary";
    push(@cmd, "java -jar $trimPrg PE");
    push(@cmd, "-threads 2 -trimlog $logfile");
    push(@cmd, "-summary $sumfile");
    push(@cmd, "$forwardR $reverseR");
    #push(@cmd, "$reverseR");
    push(@cmd, "$outFarwdRead $unpaired_outFarwdRead");
    push(@cmd, "$outRevsdRead $unpaired_outRevsdRead");  
#    push(@cmd, "$unpaired_outFarwdRead");  
    #push(@cmd, "$unpaired_outRevsdRead");    
#    push(@cmd, "-baseout $baseOutput");
    push(@cmd, "ILLUMINACLIP:$primerPath:2:30:10:2:keepBothReads");
    push(@cmd, "SLIDINGWINDOW:4:20");
    push(@cmd, "LEADING:20");
    push(@cmd, "TRAILING:20");
    push(@cmd, "MINLEN:36");
    push(@cmd, "HEADCROP:20");
    push(@cmd, "TAILCROP:10");
    $cmdLine = join(" ", @cmd);
    system($cmdLine);
    undef @cmd;
 }
###..........................Fastp Processing ..................................
sub FastpProcess
 {
    my ($inFarwdR, $inRevsdR, $outFarwdR, $outRevsdR, $unpaired_outFarwdRead, $unpaired_outRevsdRead, $failed_out_reads, $baseOutput) = @_;
    my (@cmd, $cmdLine, $logfile);
    $logfile = $baseOutput."_log";
    @cmd = ("fastp");
    push(@cmd, "-i $inFarwdR");
    push(@cmd, "-I $inRevsdR");
    push(@cmd, "-o $outFarwdR");
    push(@cmd, "-O $outRevsdR");
    push(@cmd, "--unpaired1 $unpaired_outFarwdRead");
    push(@cmd, "--unpaired2 $unpaired_outRevsdRead");
    push(@cmd, "--failed_out $failed_out_reads");
    push(@cmd, "-f 20");         ## trimming how many bases in front for read1.
    push(@cmd, "-F 20");         ## trimming how many bases in front for read2.
    push(@cmd, "-t 20");         ## trimming how many bases in front for read1,
    push(@cmd, "-T 20");         ## trimming how many bases in tail for read2. 
    push(@cmd, "-q 30");         ## the quality value that a base is qualified.
    push(@cmd, "-h $logfile");
    push(@cmd, "-j $logfile");
    $cmdLine = join(" ", @cmd);
    system($cmdLine);
    undef @cmd;
 }
 ###...............Finding jar..................................................
 sub FindJar
 {
    my $jarfilePath = shift;
    my $jarfile;   
    opendir(JARDIR, $jarfilePath)||die("Could not open the $jarfilePath\n");
    my @jarfiles = grep(/\.jar$/, readdir(JARDIR));
    return($jarfiles[$#jarfiles]); 
    print $jarfiles[$#jarfiles], "\n";
    closedir(JARDIR);   
 }

