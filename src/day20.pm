#!/usr/bin/perl
package day20;

use Exporter;
our @ISA= qw( Exporter );
our @EXPORT = qw( day20);

sub day20 {
	my ($path) = @_;
	my @lines = util::file_read($path);
	
	my @blocklist = ();
	
	for $line(@lines) {
		my ($a,$b) = split "-", $line;
		my $lo = int($a);
		my $hi = int($b);
		my $insert = 0;
		for $i (0..$#blocklist) {
			if($lo < $blocklist[$i][0]) {
				last;
			}
			$insert++;
		}
		splice @blocklist, $insert, 0, [$lo, $hi];
		
	}
	my $part1 = 0;
	for $i (0..$#blocklist) {
		if($part1 >= $blocklist[$i][0] && $part1 <= $blocklist[$i][1]) {
			$part1 = $blocklist[$i][1]+1;
		}
	}
	
	# build up a list of non-contiguous ranges, then find the gaps in the list
	my @blocklist2 = ();
	for $i (0..$#blocklist) {
		my $found = 0;
		for $j (0..$#blocklist2) {
			if(($blocklist[$i][0] >= $blocklist2[$j][0] && $blocklist[$i][0] <= $blocklist2[$j][1]) 
			|| ($blocklist[$i][1] >= $blocklist2[$j][0] && $blocklist[$i][1] <= $blocklist2[$j][1])) {
				$found = 1;
				if($blocklist[$i][0] < $blocklist2[$j][0]) {
					$blocklist2[$j][0] = $blocklist[$i][0];
				}
				if($blocklist[$i][1] > $blocklist2[$j][1]) {
					$blocklist2[$j][1] = $blocklist[$i][1];
				}
				last;
			}
		}
		if(!$found) {
			push @blocklist2, [ $blocklist[$i][0], $blocklist[$i][1] ]
		}
	}
	
	my $part2 = $blocklist2[0][0]; # lower gap, 0->...
	my $low = $blocklist2[0][0] - 1;
	for $i (1..$#blocklist2) {
		$part2 += $blocklist2[$i][0] - $blocklist2[$i-1][1] - 1;
	}
	$part2 += 4294967295 - $blocklist2[$#blocklist2][1]; # upper gap ...->4294967295
	
	util::println("Part 1: ", $part1);	
	util::println("Part 2: ", $part2);
}

1;