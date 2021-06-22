#!/usr/bin/perl
package day14;

use Digest::MD5 qw(md5_hex);

use Exporter;
our @ISA= qw( Exporter );
our @EXPORT = qw( day14);

sub hash {
	my($index, $salt, $part2) = @_;
	if($part2) {
		return stretched_hash($index, $salt);
	}
	return(md5_hex($salt."$index"));
}

sub stretched_hash {
	my($index, $salt) = @_;
	$hash = md5_hex($salt."$index");
	for $i (0..2015) {
		$hash = md5_hex($hash);
	}
	return($hash);
}

sub hash_check {
	my ($index, $salt, $part2) = @_;
	my $start = hash($index, $salt, $part2);
	my $match = "";
	for my $i (0..length($start) - 3) {
		my $a = substr($start, $i, 1);
		my $b = substr($start, $i+1, 1);
		my $c = substr($start, $i+2, 1);
		if($a eq $b && $a eq $c) {
			$match = $a;
			last;
		}
	}
	if ($match eq "") {
		return 0;
	}
	my $match_str = "$match$match$match$match$match";
	for $i (1..1001) {
		my $hash = hash($index + $i, $salt, $part2);
		if(index($hash, $match_str) > -1) {
			return 1;
		}
	}
	return 0;
}

sub day14 {
	my ($path) = @_;
	my @lines = util::file_read($path);

	my $part1 = 0;
	my $part2 = 0;
	
	my $salt = $lines[0];
	
	my $found = 0;
	my $i = 0;
	util::println("This may take a while...");
	while(1) {
		if(hash_check($i, $salt, 0)) {
			$found++;
			if($found == 64) {
				$part1 = $i;
				last;
			}
		}
		$i++;
	}
	util::println("Part 1: ", $part1);
	
	$found = 0;
	$i = 0;
	while(1) {
		if(hash_check($i, $salt, 1)) {
			$found++;
			if($found == 64) {
				$part2 = $i;
				last;
			}
		}
		$i++;
	}
	util::println("Part 2: ", $part2);
}
1;
