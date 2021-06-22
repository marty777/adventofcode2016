#!/usr/bin/perl
package day03;

use Exporter;
our @ISA= qw( Exporter );
our @EXPORT = qw( day03 );

sub day03 {
	my ($path) = @_;
	my @lines = util::file_read($path);
	
	my $part1 = 0;
	my $part2 = 0;
	foreach $line (@lines) {
		my @sides = split(" ", $line);
		if($sides[0] + $sides[1] > $sides[2] && $sides[0] + $sides[2] > $sides[1] && $sides[1] + $sides[2] > $sides[0]) {
			$part1 += 1
		}
	}
	
	for my $col (0..2) {
		my $row = 0;
		while($row < $#lines) {
			my @sides0 = split(" ", $lines[$row]);
			my @sides1 = split(" ", $lines[$row + 1]);
			my @sides2 = split(" ", $lines[$row + 2]);
			if($sides0[$col] + $sides1[$col] > $sides2[$col] && $sides0[$col] + $sides2[$col] > $sides1[$col] && $sides1[$col] + $sides2[$col] > $sides0[$col]) {
				$part2 += 1
			}
			$row += 3;
		}
	}
	
	util::println("Part 1: ", $part1);
	util::println("Part 2: ", $part2);
}
