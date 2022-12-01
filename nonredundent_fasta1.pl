#!/usr/bin/perl -w
use strict;

my $fasDict = '/media/thsti/SeaGate20200702/06_metagenomeAnalysis/16sRNA_Obese/P40_sample_trimmed_merged';
my $outDict = '/media/thsti/SeaGate20200702/06_metagenomeAnalysis/16sRNA_Obese/P40_sample_trimmed_merged_nr';
my $format = 'fasta';
opendir(DIR, $fasDict) or die "could not open the directory $fasDict $!";
mkdir($outDict, 0755);
while(my $file = readdir(DIR))
	{
		if($file =~ /fasta$/)
			{
				my %sequence;
				my $header;
				my $temp_seq;
				my $capword;
				my $fileName = $file;
				my $count1 = 0; 
				my $count2 = 0;
				print $fileName, "\n";
				open(FILE, $fasDict.'/'.$fileName) or die"could not open the directory $fileName $!";
				open(OUT, '>'.$outDict.'/'.$fileName) or die"could not be created $fileName $!";
				while(<FILE>)
     					{	
						chop;
						next if /^\s*$/; #skip empty line 
						if ($_ =~ /^>/)  #when see head line
		  					 {	
		   						$header= $_;
		   						$header =~ s/^\s+|\s+$//;
		   						$count1++;
		   						if ($sequence{$header})
		   	   						{
		    	     							print ("#CAUTION: SAME FASTA HAS BEEN READ MULTIPLE TIMES.\n#CAUTION: PLEASE CHECK FASTA SEQUENCE:$header\n");
			   						}
	           						if ($temp_seq) 
			  						{
			     							$temp_seq=""; # If there is alreay sequence in temp_seq, empty the sequence file;
			   						} 
		   					}
		   					
						else # when see the sequence line 
		   					{
		      						s/^\s+|\s+$//;
		      						$temp_seq .= $_;
		      						$sequence{$header}=$temp_seq; #update the contents
		   					}
     					}
     				print $count1,"\n";
     				close(FILE);
				foreach $capword (keys %sequence)
					{
						$count2++;
						print OUT $capword,"\n";
						print OUT $sequence{$capword},"\n"; 
					}
				print $count2, "\n";
				close(OUT);
				undef(%sequence);
			}
	}
closedir(DIR);
