#!/usr/bin/perl
package day19;

use POSIX;

use Exporter;
our @ISA= qw( Exporter );
our @EXPORT = qw( day19);

sub part1 {
	my ($num_elves) = @_;
	my @circle = ();
	# crude linked list
	for $i(0..$num_elves-1) {
		push @circle, [1, $i == 0 ? $num_elves - 1 : $i - 1,$i == $num_elves - 1 ? 0 : $i+1];
	}
	my $elf_count = $num_elves;
	my $index = 0;
	while(1) {
		$prev = $circle[$index][1];
		$next = $circle[$index][2];
		$circle[$index][0] += $circle[$next][0];
		$circle[$next][0] = 0;
		$circle[$index][2] = $circle[$next][2];
		$circle[$next][2] = -1;
		$elf_count--;
		if($elf_count == 1) {
			return $index + 1;
		}
		$index = $circle[$index][2];
	}
}

#simulating the input number of elves is infeasible.
#but the pattern of surviving elves as the circle increases
#has a predictable form.
sub part2 {
	my($max) = @_;
	$i = 1;
	$val = 1;
	$inc = 1;
	while($i <= $max) {
		if(2*$val >= $i) {
			$inc = 2;
		}
		if($i == $max) {
			return $val;
		}
		if($val + $inc > $i+1) {
			$val = 1;
			$inc = 1;
		}
		else {
			$val = $val + $inc;
		}
		$i++;
	}
}

sub day19 {
	my ($path) = @_;
	my @lines = util::file_read($path);
	
	my $elves = int($lines[0]);
	
	my $part1 = part1($elves);
	my $part2 = part2($elves);
	
	util::println("Part 1: ", $part1);	
	util::println("Part 2: ", $part2);
}

1;