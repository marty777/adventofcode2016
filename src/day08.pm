#!/usr/bin/perl
package day08;

use Exporter;
our @ISA= qw( Exporter );
our @EXPORT = qw( day08 );

sub print_screen {
	my ($width, $height, @screen) = @_;
	for $y (0..$height-1) {
		for $x (0..$width-1) {
			print($screen[$y][$x]);
		}
		print("\n");
	}
}

sub rect {
	my ($width, $height, @screen) = @_;
	for $y (0..$height-1) {
		for $x (0..$width-1) {
			$screen[$y][$x] = '#';
		}
	}
}

sub rotate_col {
	my ($col, $shift, $height, @screen) = @_;
	my @col_buff = [];
	for $y (0..$height-1) {
		$col_buff[$y] = $screen[$y][$col];
	}
	for $y (0..$height-1) {
		$screen[$y][$col] = $col_buff[($y - $shift) % $height];
	}
}

sub rotate_row {
	my ($row, $shift, $width, @screen) = @_;
	my @row_buff = [];
	for $x (0..$width-1) {
		$row_buff[$x] = $screen[$row][$x];
	}
	for $x (0..$width-1) {
		$screen[$row][$x] = $row_buff[($x - $shift) % $width];
	}
}

sub day08 {
	my ($path) = @_;
	my @lines = util::file_read($path);
	
	my $part1 = 0;
	
	my $width = 50;
	my $height = 6;
	my @screen;
	my @row;
	my @column;
	for $i (0..$height-1) {
		$screen[$i] = [];
		for $j (0..$width-1) {
			$screen[$i][$j] = '.';
			#util::println("$j, $i", $screen[$i][$j]);
		}
	}
	# print(" $width $height\n");
	# print_screen($width, $height, @screen);
	# rect(3,2,@screen);
	# print("-----------\n");
	# print_screen($width, $height, @screen);
	# rotate_col(1,1, $height,@screen);
	# print("-----------\n");
	# print_screen($width, $height, @screen);
	# rotate_row(0,4, $width,@screen);
	# print("-----------\n");
	# print_screen($width, $height, @screen);
	
	
	foreach $line (@lines) {
		if (index($line, "rect ") != -1) {
			$sub = substr($line, length("rect "));
			($w, $h) = split "x", $sub;
			rect($w, $h, @screen);
			
		}
		elsif(index($line, "rotate row") != -1) {
			$sub = substr($line, length("rotate row y="));
			($y, $shift) = split " by ", $sub;
			rotate_row($y, $shift, $width, @screen);
		}
		elsif (index($line, "rotate column") != -1) {
			$sub = substr($line, length("rotate column x="));
			($x, $shift) = split " by ", $sub;
			rotate_col($x, $shift, $height, @screen);
		}
		
	}
	
	for $y (0..$height-1) {
		for $x (0..$width-1) {
			if($screen[$y][$x] eq '#') {
				$part1++;
			}
		}
	}
	
	util::println("Part 1: ", $part1);
	util::println("Part 2: ");
	print_screen($width, $height, @screen);
}
