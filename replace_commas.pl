#!/usr/bin/perl

my $infile = shift @ARGV;
my $outfile = $infile."_edit";

open (INFILE,"<$infile") or die "\tUnable to open ".$infile.": ".$!."\n\n";
open (OUTFILE,">$outfile") or die "\tUnable to write ".$outfile.": ".$!."\n\n";

my $i = 0;

while (<INFILE>) {
	my($line) = $_;
	++$i;
	$line =~ s/,/\./;
	$line =~ s/\;/\,/g;
	print OUTFILE $line;
}

print "\nFound and replaced in $i lines, result file: ".$outfile."\n\n";

close(OUTFILE);
close(INFILE);
