#!/usr/bin/perl -w
use strict;

my $fasDict = '/media/shakti/SHAKTI4/MicrobiomeZaighum/hACE2metagenomicsCombinedAnalysis_01mergedreads';
my $outDict = '/media/shakti/SHAKTI4/MicrobiomeZaighum/hACE2metagenomicsCombinedAnalysis_01mergedreads_rename';
my $namelist = '/media/shakti/SHAKTI4/MicrobiomeZaighum/hACE2metagenomicsCombinedAnalysis_01mergedreads_namelist';
my $format = 'fasta';
opendir(DIR, $fasDict) or die "could not open the directory $fasDict $!";
mkdir($outDict, 0755);
while(my $file = readdir(DIR))
	{
		if($file =~ /$format$/)
			{
				my $fileName = $file;
				my $sampleName = &FIND($fileName, $namelist);
				open(FILE, $fasDict.'/'.$fileName) or die"could not open the directory $fileName $!";
				open(OUT, '>'.$outDict.'/'.$fileName) or die"could not be created $fileName $!";
				while(my $line = <FILE>)
					{
						if ($line =~ /^>/)
							{
								$line =~ s/^\s+|\s+$//;
								$line =~ s/^>//;
								my $newline = '>'.$sampleName.'_'.$line;
								print OUT $newline,"\n";
							}
						else
							{
								print OUT $line;
							}
					}
				close(FILE);
				close(OUT);
			}
	}
sub FIND
{
	my ($fname,$filepath) =  @_;
	$fname =~ s/^\s+|\s+$//;
	my $newName;
	open(IN, $filepath) or die"could not open the file $fname $!";
	while(my $ln = <IN>)
		{
			$ln =~ s/^\s+|\s+$//;
			my @lnA = split("\t", $ln);
			if($lnA[0] eq $fname)
				{
					$newName = $lnA[$#lnA];
					print $lnA[0],"\t",$fname,"\t",$newName,"\n";
					last;
				}
		}
	return($newName);
	close(IN);
}
