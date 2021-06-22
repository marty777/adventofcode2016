#!/usr/bin/perl
package day07;

use Exporter;
our @ISA= qw( Exporter );
our @EXPORT = qw( day07 );

sub supports_ssl {
	my ($supernet, $hypernet) = @_;
	my @superchars = split //, $supernet;
	my @hyperchars = split //, $hypernet;
	for $i (0..$#superchars-2) {
		if($superchars[$i] eq $superchars[$i+2] && $superchars[$i + 1] && $superchars[$i] ne $superchars[$i+1]) {
			for $j (0..$#hyperchars-2) {
				if($hyperchars[$j] eq $superchars[$i+1] && $hyperchars[$j+1] eq $superchars[$i] && $hyperchars[$j+2] eq $superchars[$i+1]) {
					return 1;
				}
			}
		}
	}
	return 0;
}


sub contains_abba {
	my ($str) = @_;
	my @chars = split //, $str;
	for $i (0..$#chars-3) {
		if($chars[$i] eq $chars[$i+3] && $chars[$i + 1] eq $chars[$i + 2] && $chars[$i] ne $chars[$i+1]) {
			return 1;
		}
	}
	return 0;
}

sub day07 {
	my ($path) = @_;
	my @lines = util::file_read($path);
	
	my $part1 = 0;
	my $part2 = 0;
	
	foreach $line (@lines) {
		@chars = split //, $line;
		my $index = 0;
		my $last_index = 0;
		my $in_brackets = 0;
		my $abba_out = 0;
		my $abba_in = 0;
		my $supernet = "";
		my $hypernet = "";
		while($index <= $#chars) {
			if($chars[$index] eq '[') {
				$supernet .= substr($line, $last_index, $index - $last_index );
				if(contains_abba(substr($line, $last_index, $index - $last_index ))) {
					$abba_out++;
				}
				$last_index = $index+1;
			}
			elsif ($chars[$index] eq ']') {
				$hypernet .= substr($line, $last_index, $index - $last_index );
				if(contains_abba(substr($line, $last_index, $index - $last_index))) {
					$abba_in++;
				}
				$last_index = $index + 1;
			}
			elsif ($index == $#chars) {
				$supernet .= substr($line, $last_index, $index - $last_index + 1 );
				if(contains_abba(substr($line, $last_index, $index - $last_index + 1))) {
					$abba_out++;
				}
			}
			$index++;
		}
		if($abba_out > 0 && $abba_in == 0) {
			$part1++;
		}
		if(supports_ssl($supernet, $hypernet)) {
			$part2++;
		}
	}
	
	util::println("Part 1: ", $part1);
	util::println("Part 2: ", $part2);
}
