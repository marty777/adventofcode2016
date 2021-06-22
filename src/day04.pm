#!/usr/bin/perl
package day04;

use Exporter;
our @ISA= qw( Exporter );
our @EXPORT = qw( day04 );

sub rotate {
	my ($str, $increments) = @_;
	my @split = split(//, $str);
	my $ret = "";
	for $i (0..$#split) {
		if($split[$i] eq "-"){
			$ret .= " ";
		}
		else {
			$ret .= chr(((ord($split[$i]) - 97 + $increments) % 26) + 97);
		}
	}
	return $ret;
	
}

sub day04 {
	my ($path) = @_;
	my @lines = util::file_read($path);
	
	my $part1 = 0;
	my $part2 = 0;
	foreach $line (@lines) {
		my @split = split("-", $line);
		my $last = $split[$#split];
		my $sector = substr($last, 0, index($last, '['));
		my $checksum = substr($last, index($last, '[')+1, index($last, ']') - index($last, '[') - 1);
		my $chars = "";
		my $encrypted = "";
		my %charcount = {};
		for my $i (0..($#split-1)) {
			my @split_chr = split //, $split[$i]; 
			for $j (0..$#split_chr) {
				if(exists $charcount{$split_chr[$j]}) {
					$charcount{$split_chr[$j]} += 1;
				}
				else {
					$charcount{$split_chr[$j]} = 1;
				}
			}
			$chars .= $split[$i];
			$encrypted .= $split[$i];
			if($i < $#split-1) {
				$encrypted .= '-';
			}
				
		}
		my $sorted_chars = "";
		my $charcount = 0;
		foreach my $key (sort {$charcount{$b} <=> $charcount{$a} || $a cmp $b} keys %charcount) {
			#print($key, ": ", $charcount{$key}, "\n");
			if($charcount < 5) {
				$sorted_chars .= $key;
			}
			$charcount += 1;
		}
		if($sorted_chars eq $checksum) {
			$part1 += int($sector);
			my $decrypted = rotate($encrypted , $sector);
			if(index($decrypted, "northpole object storage") != -1) { 	
				$part2 = $sector;
			}
			
		}
	}
	
	
	util::println("Part 1: ", $part1);
	util::println("Part 2: ", $part2);
}
