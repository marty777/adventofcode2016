#!/usr/bin/perl
package day01;

use Exporter;
our @ISA= qw( Exporter );
our @EXPORT = qw( day01 );

sub day01 {
	my ($path) = @_;
	my @lines = util::file_read($path);
	my @directions = split(", ", @lines[0]);

	
	my $pos_x = 0;
	my $pos_y = 0;
	my $dir = 0;
	my %pos_hash;
	
	my $part2 = -1;
	foreach my $direction (@directions) {
		my $turn = substr($direction, 0, 1);
		my $dist = substr($direction, 1);
		if($turn eq "R") {
			$dir = ($dir - 1) % 4;
		}
		elsif($turn eq "L") {
			$dir = ($dir + 1) % 4;
		}
		while($dist > 0) {
			if($dir == 0) {
				$pos_y += 1;
			}
			elsif($dir == 1) {
				$pos_x += 1;
			}
			elsif($dir == 2) {
				$pos_y -= 1;
			}
			elsif($dir == 3) {
				$pos_x -= 1;
			}
			
			$pos_str = $pos_x.",".$pos_y;
			if(exists $pos_hash{$pos_str}) {
				if($part2 == -1) {
					$part2 = abs($pos_x) + abs($pos_y);
				}
			}
			else {
				$pos_hash{$pos_str} = 1;
			}
			$dist--;
		}
		
	}
	my $part1 = abs($pos_x) + abs($pos_y);
	util::println("Part 1: ", $part1);
	util::println("Part 2: ", $part2);
}
