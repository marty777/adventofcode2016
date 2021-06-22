#!/usr/bin/perl
package day02;

use Exporter;
our @ISA= qw( Exporter );
our @EXPORT = qw( day02 );

sub day02 {
	my ($path) = @_;
	my @lines = util::file_read($path);
	
	my $pos_x1 = 1;
    my $pos_y1 = 1;
	my $pos_x2 = 0;
	my $pos_y2 = 2;
	my $part1 = "";
	my $part2 = "";
	my @map = (['X','X','1','X','X'], ['X', '2', '3', '4', 'X'], ['5', '6', '7', '8', '9'], ['X', 'A', 'B', 'C', 'X'], ['X','X','D','X','X']);
	foreach $line (@lines) {
		my @chars = split //, $line;
		my $length = scalar @chars;
		
		for my $i (0..$#chars) {
			if($chars[$i] eq 'U') {
				$pos_y1 -= 1;
				if($pos_y1 < 0) {
					$pos_y1 = 0;
				}
				if($pos_y2 > 0 && $map[$pos_y2 - 1][$pos_x2] ne 'X') {
					$pos_y2 -= 1;
				}
			}
			elsif($chars[$i] eq 'L') {
				$pos_x1 -= 1;
				if($pos_x1 < 0) {
					$pos_x1 = 0;
				}
				if($pos_x2 > 0 && $map[$pos_y2][$pos_x2 - 1] ne 'X') {
					$pos_x2 -= 1;
				}
			}
			elsif($chars[$i] eq 'D') {
				$pos_y1 += 1;
				if($pos_y1 > 2) {
					$pos_y1 = 2;
				}
				if($pos_y2 < 4 && $map[$pos_y2 + 1][$pos_x2] ne 'X') {
					$pos_y2 += 1;
				}
				
			}
			elsif($chars[$i] eq 'R') {
				$pos_x1 += 1;
				if($pos_x1 > 2) {
					$pos_x1 = 2;
				}
				if($pos_x2 < 4 && $map[$pos_y2][$pos_x2 + 1] ne 'X') {
					$pos_x2 += 1;
				}
			}
		}
		$part1 .= (($pos_x1 + 3*$pos_y1) + 1);
		$part2 .= $map[$pos_y2][$pos_x2];
	}
	
	util::println("Part 1: ", $part1);
	util::println("Part 2: ", $part2);
}
