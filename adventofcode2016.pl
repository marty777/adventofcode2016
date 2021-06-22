#!/usr/bin/perl

use warnings;

# use lib for relative path to src dir
use File::Spec;
use FindBin qw($Bin);
use lib File::Spec->catdir($Bin, 'src');

use util;
use Scalar::Util qw(looks_like_number);
use Time::HiRes qw(time);

use day01;
use day02;
use day03;
use day04;
use day05;
use day06;
use day07;
use day08;
use day09;
use day10;
use day11;
use day12;
use day13;
use day14;
use day15;
use day16;
use day17;
use day18;
use day19;
use day20;
use day21;
use day22;
use day23;
use day24;
use day25;

my $max_day = 25;

my @days = ();
for my $i (0..$max_day-1) {
	my $leading_zero = "";
	if($i < 9) {
		$leading_zero = "0"
	}
	$days[$i] = "day".$leading_zero.($i+1);
}

my $days_len = scalar @days;
my $arg_len = scalar @ARGV;
if($arg_len < 2) {
	util::usage();
}
my $arg_day = $ARGV[0];
my $arg_path = $ARGV[1];
if(!looks_like_number($arg_day) || $arg_day < 1 || $arg_day > $days_len ) {
	util::usage();
}
my $start_time = time();
$days[$arg_day - 1]->($arg_path);
my $end_time = time();
util::println("Completed in ", int(1000*($end_time - $start_time)), " ms");

