#!/usr/bin/perl
#  Get variant allele from every single cell
#  merge counts from single cell into a matrix 
use strict;
use warnings;

if(@ARGV<1)
{
	print "perl $0  <SNV file> <summary> <sc_output_path>\n";
	exit;
}

my $SNV=$ARGV[0];
my $summary=$ARGV[1];
my $sc_output=$ARGV[2];
my %SNV_hash;

open IN, "$SNV" or die "can not open $SNV\n";
while(<IN>)
{
	my @a=split;
	$SNV_hash{$a[1]}{"base"}=$a[2]."/".$a[3];
	my $flag=0;
	if($a[4]<$a[5]){$flag=1}
	$SNV_hash{$a[1]}{"flag"}=$flag; 
	
}
close IN;


open SUM,"$summary" or die " can not open $summary\n";
my %matrix;

<SUM>;
while(<SUM>)
{
	chomp;
	my @a=split; 
	my $file=$sc_output.$a[0]."/Mapping_hg19/".$a[0].".counts";
	open SC,"$file" or die "can not open $file\n";
	while(<SC>)
	{
		my @b=split; 
		if ( exists($SNV_hash{$b[1]}))
		{
		#	print "position\t",$b[1],"\t";
			my $base=$SNV_hash{$b[1]}{"base"};
			my $flag=$SNV_hash{$b[1]}{"flag"};
		#	print $base,"\t";
		#	print $b[2]."/".$b[5],"\n";
			if ($base eq $b[2]."/".$b[5])			
			{		if($flag == 1)
					{
					$matrix{$a[0]}{$b[1]}=$b[7];
					}
					else{
					$matrix{$a[0]}{$b[1]}=$b[8];
					}	
			}
			else
			{
				$matrix{$a[0]}{$b[1]}=0;
			}
		}
	}
	close SC;
	$matrix{$a[0]}{"depth"}=$a[17];
}

foreach my $sc (keys %matrix)
{
	print $sc;
	
	foreach my $site (keys %SNV_hash)
	{
		my $count;
		if(exists($matrix{$sc}{$site}))
 		{$count=$matrix{$sc}{$site}}
		else
		{$count="na"}
		print "\t", $count;
	}
	print "\t",$matrix{$sc}{"depth"},"\n";
}

my @sites=keys %SNV_hash;
print STDERR join("\n",@sites),"\n";
