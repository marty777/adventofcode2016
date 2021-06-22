#!/usr/bin/perl
package day18;

use Exporter;
our @ISA= qw( Exporter );
our @EXPORT = qw( day18);

sub next_row {
	my ($row, $verbose) = @_;
	@row_r = split //, $row;
	@next_row = split //, $row;
	for $i (0..$#next_row) {
		my ($a,$b,$c) = (0,0,0);
		if($i > 0) {
			$a = ($row_r[$i-1] eq '.' ? 0 : 1);		
		}
		if($i < $#next_row) {
			$c = ($row_r[$i+1] eq '.' ? 0 : 1);
		}
		$b = ($row_r[$i] eq '.' ? 0 : 1);
		
		if( ($a && $b && !$c) || (!$a && $b && $c) || ($a && !$b && !$c) || (!$a && !$b && $c) ) {
			$next_row[$i] = '^';
		}
		else {
			$next_row[$i] = '.'
		}
	}
	return ((join "", @next_row));
}

sub safe {
	my ($row) = @_;
	my @row_r = split //, $row;
	my $safe = 0;
	for $i(0..$#row_r) {
		if($row_r[$i] eq '.') {
			$safe++;
		}
	}
	return $safe;
}

sub day18 {
	my ($path) = @_;
	my @lines = util::file_read($path);

	my $part1 = 0;
	my $part2 = 0;

	my $start = $lines[0];
	$part1 += safe($start);
	my $next = next_row($start);
	
	for my $i (0..(40 - 2)) {
		$part1 += safe($next);
		$next = next_row($next, $i == 0);
	}
	
	util::println("Part 1: ", $part1);
	
	$part2 += safe($start);
	$next = next_row($start);
	for my $i (0..(400000 - 2)) {
		
		$part2 += safe($next);
		$next = next_row($next, $i == 0);
	}
	
	util::println("Part 2: ", $part2);
}

1;