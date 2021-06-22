#!/usr/bin/perl
package day09;

use Exporter;
our @ISA= qw( Exporter );
our @EXPORT = qw( day09 );

sub decompress2 {
	my($depth, @chars) = @_;
	
	my $line = join("", @chars);
	my $count = 0;
	my $index = 0;
	while($index <= $#chars) {
		if($chars[$index] eq '(') {
			my $index2 = $index + 1;
			while($chars[$index2] ne ')' && $index2 <= $#chars) {
				$index2++;
			}
			my $marker = "";
			for my $i ($index+1..$index2-1) {
				$marker .= $chars[$i];
			}
			my ($characters, $repeat) = split("x", $marker);
			$count += decompress2($depth + 1, @chars[$index2+1..$index2+$characters]) * $repeat;
			$index = $index2 + $characters;
		}
		else {
			$count += 1;
		}
		$index += 1;
	}
	return $count;
}

sub decompress {
	my($line) = @_;
	my @chars = split //, $line;
	my $ret = "";
	my $index = 0;
	
	while($index <= $#chars) {
		if($chars[$index] eq '(') {
			my $index2 = $index + 1;
			while($chars[$index2] ne ')' && $index2 <= $#chars) {
				$index2++;
			}
			my $marker = "";
			for my $i ($index+1..$index2-1) {
				$marker .= $chars[$i];
			}
			my ($characters, $repeat) = split("x", $marker);
			for my $r (0..$repeat-1) {
				for my $i ($index2+1..$index2+$characters) {
					$ret .= $chars[$i];
				}
			}
			$index = $index2+$characters;
		}
		else {
			$ret .= $chars[$index];
		}
		$index += 1;
	}
	return $ret;
}

sub day09 {
	my ($path) = @_;
	my @lines = util::file_read($path);
	
	my $part1 = 0;
	my $part2 = 0;
	
	foreach $line (@lines) {
		$result = decompress($line);
		$part1 += length($result);
		my @chars = split(//, $line);
		$part2 += decompress2(0,@chars);
	}
	
	util::println("Part 1: ", $part1);
	util::println("Part 2: ", $part2);
}
