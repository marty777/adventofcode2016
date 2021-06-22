#!/usr/bin/perl
package day06;

use Exporter;
our @ISA= qw( Exporter );
our @EXPORT = qw( day06 );


sub day06 {
	my ($path) = @_;
	my @lines = util::file_read($path);
	
	my $part1 = "";
	my $part2 = "";
	my $len = length(@lines[0]);
	for my $i (0..$len-1) {
		my %counts;
		foreach $line (@lines) {
			my $char = substr($line, $i, 1);
			if(exists $counts{$char}) {
				$counts{$char}++;		
			}
			else {
				$counts{$char} = 1;
			}
		}
		@chars = sort {$counts{$b} <=> $counts{$a}} keys %counts;
		$part1 .= $chars[0];
		$part2 .= $chars[$#chars];
	}
	
	util::println("Part 1: ", $part1);
	util::println("Part 2: ", $part2);
}
