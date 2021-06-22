#!/usr/bin/perl
package day25;

use Exporter;
our @ISA= qw( Exporter );
our @EXPORT = qw( day25);


# i'm not sure how robust this is for other inputs.
# in mine, the input value in reg a is added to the product of two positive
# integers in the instructions.
# the output is a repeated 12 digit sequence of the binary digits of that sum.
# 2730 = 0b101010101010
# 1365 = 0b010101010101
sub solve {
	my(@lines) = @_;
	@vals = ();
	for $i (0..$#lines) {
		my @split = split(" ", $lines[$i]);
		if(ord($split[1]) >= ord('a') && ord($split[1]) <= ord('d')) {
			next;
		}
		my $val = int($split[1]);
		if($val > 2) {
			push @vals, $val;
		}
	}
	my $product = 1;
	for my $val (@vals) {
		$product *= $val;
	}
	
	if($product < 1365) {
		return 1365 - $product;
	}
	else {
		return 2730 - $product;
	}
}

sub day25 {
	my ($path) = @_;
	my @lines = util::file_read($path);
	
	my $part1 = solve(@lines);
	util::println("Part 1: ", $part1);
}