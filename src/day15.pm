#!/usr/bin/perl
package day15;

use Exporter;
our @ISA= qw( Exporter );
our @EXPORT = qw( day15);

# shamelessly copied from https://rosettacode.org/wiki/Modular_inverse#Perl
sub invmod {
  my($a,$n) = @_;
  my($t,$nt,$r,$nr) = (0, 1, $n, $a % $n);
  while ($nr != 0) {
    # Use this instead of int($r/$nr) to get exact unsigned integer answers
    my $quot = int( ($r - ($r % $nr)) / $nr );
    ($nt,$t) = ($t-$quot*$nt,$nt);
    ($nr,$r) = ($r-$quot*$nr,$nr);
  }
  return if $r > 1;
  $t += $n if $t < 0;
  $t;
}

sub day15 {
	my ($path) = @_;
	my @lines = util::file_read($path);

	my $part1 = 0;
	my $part2 = 0;
	
	my @discs = ();
	for my $i (0..$#lines) {
		my @words = split(" ", $lines[$i]);
		my $positions = int($words[3]);
		my $start_pos = int(substr($words[11], 0, length($words[11]) - 1));
		my $required_pos = ($positions - ($i+1)) % $positions;
		push @discs, [$positions, $start_pos, $required_pos];
	}
	
	# good old CRT. By inspection, all my moduli are prime and therefore pairwise co-prime.
	my $M = 1; # product of all moduli
	for my $i(0..$#discs) {
		$M *= $discs[$i][0];
	}

	my $sum = 0;
	for my $i(0..$#discs) {
		my $b = $M/$discs[$i][0];
		my $b_inv = invmod($b, $discs[$i][0]);
		$sum += ($discs[$i][2] - $discs[$i][1]) * $b * $b_inv;
	}
	$part1 = ($sum % $M);
	
	# add disc for part 2
	push @discs, [11, 0, ((11 - ((scalar @discs)+1)) % 11)];
	
	$M = 1;
	for my $i(0..$#discs) {
		$M *= $discs[$i][0];
	}
	$sum = 0;
	for my $i(0..$#discs) {
		my $b = $M/$discs[$i][0];
		my $b_inv = invmod($b, $discs[$i][0]);
		$sum += ($discs[$i][2] - $discs[$i][1]) * $b * $b_inv;
	}
	$part2 = ($sum % $M);
	
	util::println("Part 1: ", $part1);
	util::println("Part 2: ", $part2);
}

1;