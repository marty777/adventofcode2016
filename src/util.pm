#!/usr/bin/perl
package util;

use warnings;
use Exporter;

our @ISA= qw( Exporter );

# these CAN be exported.
#our @EXPORT_OK = qw( export_me export_me_too );

# these are exported by default.
our @EXPORT = qw( usage file_read println );


sub usage {
	print("Usage:");
    print("\tperl adventofcode2016.pl [DAY] [INPUT FILE] ...\n");
    print("\t[DAY]\t\tThe advent program day to run\n");
    print("\t[INPUT FILE]\tThe relative or absolute path to the input file.\n");
    print("\nExample:\n");
    print("\tperl adventofcode2016.pl 1 data/day1/input.txt\n");
	exit 0;
}

sub file_read {
	my ($path) = @_;
	my $handle;
	unless (open $handle, "<:encoding(utf8)", $path) {
	   print(STDERR "Could not open file '$path': $!\n");
	   usage();
	}
	chomp(my @lines = <$handle>);
	close $handle;
	# get rid of line breaks
	for my $i (0 .. $#lines) {
		$lines[$i] =~ s/[\n\r]//g;
	}
	return @lines;
}

sub println {
	print(@_, "\n");
}