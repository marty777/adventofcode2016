#!/usr/bin/perl
package day16;

use Exporter;
our @ISA= qw( Exporter );
our @EXPORT = qw( day16);

sub checksum {
	my($len, @a) = @_;
	my @ret = ();
	for my $i (0..($len/2)-1) {
		$b = $a[2*$i];
		$c = $a[(2*$i) + 1];
		if($b eq $c) {
			push @ret, '1';
		}
		else {
			push @ret, '0';
		}
	}
	return @ret;
}

sub generate {
	my(@a) = @_;
	my @ret = ();
	my @b = ();
	for my $i (0..($#a)) {
		my $c = $a[$i];
		push @ret, $c;
		if($c eq '0') {
			unshift @b, '1';
		}
		else {
			unshift @b, '0';
		}
	}
	push @ret, '0';
	push @ret, @b;
	return @ret;
}

sub str_to_arr {
	my($a) = @_;
	return split //, $a;
}

sub arr_to_str {
	my(@a) = @_;
	return join("", @a);
}

sub gen_and_checksum {
	my($init_str, $length) = @_;
	my @a = str_to_arr($init_str);
	while(scalar @a < $length) {
		@a = generate(@a);
	}
	my @checksum = checksum($length, @a);
	while((scalar @checksum) % 2 == 0) {
		@checksum = checksum(scalar(@checksum), @checksum);
	}
	return @checksum;
}

sub day16 {
	my ($path) = @_;
	my @lines = util::file_read($path);

	my $initial = $lines[0];
		
	my $part1 = arr_to_str(gen_and_checksum($initial, 272));
	util::println("Part 1: ", $part1);
	my $part2 = arr_to_str(gen_and_checksum($initial, 35651584));
	util::println("Part 2: ", $part2);
}

1;