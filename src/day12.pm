#!/usr/bin/perl
package day12;

use Exporter;
our @ISA= qw( Exporter );
our @EXPORT = qw( day12 );

sub execute {
	my ($part2, @lines) = @_;
	my $a = 0;
	my $b = 0;
	my $c = ($part2 ? 1 : 0);
	my $d = 0;
	my $index = 0;
	my @reg = ($a,$b,$c,$d);
	while(1) {
		if($index > $#lines) {
			last;
		}
		my @parts = split(" ", $lines[$index]);
		if($parts[0] eq "cpy") {
			if(ord($parts[1]) >= ord('a') && ord($parts[1]) <= ord('d')) {
				my $src = ord($parts[1]) - ord('a');
				my $dst = ord($parts[2]) - ord('a');
				$reg[$dst] = $reg[$src];
			}
			else {
				my $src = int($parts[1]);
				my $dst = ord($parts[2]) - ord('a');
				$reg[$dst] = $src;
			}
			$index++;
		}
		elsif($parts[0] eq 'inc') {
			my $src = ord($parts[1]) - ord('a');
			$reg[$src]++;
			$index++;
		}
		elsif($parts[0] eq 'dec') {
			my $src = ord($parts[1]) - ord('a');
			$reg[$src]--;
			$index++;
		}
		elsif($parts[0] eq 'jnz') {
			if(ord($parts[1]) >= ord('a') && ord($parts[1]) <= ord('d')) {
				$src = ord($parts[1]) - ord('a');
				$amt = int($parts[2]);
				if($reg[$src] != 0) {
					$index += $amt;
				}
				else {
					$index++;
				}
			}
			else {
				$src = int($parts[1]);
				$amt = int($parts[2]);
				if($src != 0) {
					$index += $amt;
				}
				else {
					$index++;
				}
			}
			
		}
	}
	return $reg[0];
}

sub day12 {
	my ($path) = @_;
	my @lines = util::file_read($path);
	
	my $part1 = execute(0,@lines);
	my $part2 = execute(1, @lines);
	
	util::println("Part 1: ", $part1);
	util::println("Part 2: ", $part2);
}

1;