#!/usr/bin/perl
package day05;

use Exporter;
our @ISA= qw( Exporter );
our @EXPORT = qw( day05 );

use Digest::MD5 qw(md5_hex);

sub hash {
	my ($str, $index) = @_;
	my $hash = md5_hex($str.$index);
	if(index($hash, "00000") == 0) {
		return (substr($hash, 5, 1), substr($hash, 6, 1));
	}
	else {
		return ("", "");
	}
}

sub part2count {
	my (@part2) = @_;
	my $count = 0;
	for $i (0..7) {
		if($part2[$i] ne '') {
			$count++;
		}
	}
	return $count;
}


sub day05{
	my ($path) = @_;
	my @lines = util::file_read($path);
	
	my $input = $lines[0];
	my $md5_hash = md5_hex($input);
	
	my $part1 = "";
	my @part2_arr = ('','','','','','','','');
	
	my $index = 0;
	my $done = 0;

	while(length($part1) < 8 || part2count(@part2_arr) < 8) {
		my ($six, $seven) = hash($input, $index);
		if($six ne "" && length($part1) < 8) {
			$part1 .= $six;
		}
		if($seven ne "" && part2count(@part2_arr) < 8) {
			if(ord($six) >= 48 && ord($six) <= 55 && $part2_arr[int($six)] eq '') {
				$part2_arr[int($six)] = $seven;
			}
		}
		$index += 1;
	}
	
	$part2 = join("", @part2_arr);
	
	util::println("Part 1: ", $part1);
	util::println("Part 2: ", $part2);
}
