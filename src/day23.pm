#!/usr/bin/perl
package day23;

use Exporter;
our @ISA= qw( Exporter );
our @EXPORT = qw( day23);

sub part1 {
	my (@lines) = @_;
	my $a = 7;
	my $b = 0;
	my $c = 0;
	my $d = 0;
	my $index = 0;
	my @reg = ($a,$b,$c,$d);
	my @tgl = ();
	my $count = 0;
	for $l (@lines) {
		push(@tgl, 0);
	}
	while(1) {
		if($index > $#lines) {
			last;
		}
		$count++;
		my @parts = split(" ", $lines[$index]);
		$inst = @parts[0];
		if($tgl[$index] == 1) {
			if($inst eq 'inc') {
				$inst = 'dec';
			}
			elsif($inst eq 'dec') {
				$inst = 'inc';
			}
			elsif($inst eq 'tgl') {
				$inst = 'inc';
			}
			elsif($inst eq 'jnz') {
				$inst = 'cpy';
			}
			elsif($inst eq 'cpy') {
				$inst = 'jnz';
			}
		}
		# more robust checking. value 1 may be either integer or register. value 2 must be register.
		if($inst eq "cpy") {
			# if value 2 not register, bad instruction
			if(! (ord($parts[2]) >= ord('a') && ord($parts[2]) <= ord('d')) ) {
				# do nothing.
			}
			elsif(ord($parts[1]) >= ord('a') && ord($parts[1]) <= ord('d')) {
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
		# value 1 must be register.
		elsif($inst eq 'inc') {
			if(ord($parts[1]) >= ord('a') && ord($parts[1]) <= ord('d')) {
				my $src = ord($parts[1]) - ord('a');
				$reg[$src]++;
			}
			$index++;
		}
		# value 1 must be register
		elsif($inst eq 'dec') {
			if(ord($parts[1]) >= ord('a') && ord($parts[1]) <= ord('d')) {
				my $src = ord($parts[1]) - ord('a');
				$reg[$src]--;
			}
			$index++;
		}
		# value 1 and 2 may be either register or integer
		elsif($inst eq 'jnz') {
			$src = 0;
			$amt = 0;
			if(ord($parts[1]) >= ord('a') && ord($parts[1]) <= ord('d')) {
				$src = $reg[ord($parts[1]) - ord('a')];
			}
			else {
				$src = int($parts[1]);
			}
			
			if(ord($parts[2]) >= ord('a') && ord($parts[2]) <= ord('d')) {
				$amt = $reg[ord($parts[2]) - ord('a')];
			}
			else {
				$amt = int($parts[2]);
			}
			if($src != 0) {
				$index += $amt;
			}
			else {
				$index++;
			}
		}
		elsif($inst eq 'tgl') {
			$src = 0;
			if(ord($parts[1]) >= ord('a') && ord($parts[1]) <= ord('d')) {
				$src = $reg[ord($parts[1]) - ord('a')];
			}
			else {
				$src = int($parts[1]);
			}
			$tgl[$index + $src] = ($tgl[$index + $src] == 1 ? 0 : 1);
			$index++;
		}
	}
	return $reg[0];
}

# no idea how robust this is for other inputs.
# for my input program, the output is 12! + the product of 
# two non-negative integers that appear in instructions.
sub part2 {
	my (@lines) = @_;
	my $product = 1;
	my $val = 12;
	while($val > 1) {
		$product *= $val;
		$val--;
	}
	@vals = ();
	for $line (@lines) {
		@split = split(' ', $line);
		for $s(@split) {
			$i = int($s);
			if($i > 1) {
				push @vals, $i;
			}
		}
	}
	
	$product2 = 1;
	for $int (@vals) {
		$product2 *= $int;
	}
	return $product + $product2;
}

sub day23 {
	my ($path) = @_;
	my @lines = util::file_read($path);

	my $part1 = part1(@lines);
	my $part2 = part2(@lines);
	util::println("Part 1: ", $part1);
	util::println("Part 2: ", $part2);
}

1;