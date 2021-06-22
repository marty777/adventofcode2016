#!/usr/bin/perl
package day21;

use Exporter;
our @ISA= qw( Exporter );
our @EXPORT = qw( day21);

sub unscramble {
	my($start, @instructions) = @_;
	my @result = split //, $start;
	for $i(0..$#instructions) {
		$inst = $instructions[$#instructions - $i];
		# same operation
		if(index($inst, "swap position") > -1) {
			my $substr = substr($inst,length("swap position "));
			my ($a, $b) = split(" with position ", $substr);
			my $x = int($a);
			my $y = int($b);
			my $temp = $result[$x];
			$result[$x] = $result[$y];
			$result[$y] = $temp;
		}
		#same operation
		elsif(index($inst, "swap letter") > -1) {
			my $substr = substr($inst,length("swap letter "));
			my ($a, $b) = split(" with letter ", $substr);
			my $x = -1;
			my $y = -1;
			for my $i(0..$#result) {
				if($result[$i] eq $a) {
					$x = $i;
				}
				elsif($result[$i] eq $b) {
					$y = $i;
				}
			}
			if($x == -1 || $y == -1) {
				util::println("A position error has occured with instruction $inst\n");
				return 0;
			}
			
			my $temp = $result[$x];
			$result[$x] = $result[$y];
			$result[$y] = $temp;
		}
		# reverse direction
		elsif(index($inst, "rotate left") > -1) {
			my $substr = substr($inst,length("rotate left "));
			my ($a) = substr($substr, 0, index($substr, " step"));
			my $x = int($a);
			while ($x > 0) {
				my $temp = pop @result;
				unshift @result, $temp;
				$x--;
			}
			
		}
		# reverse direction
		elsif(index($inst, "rotate right") > -1) {
			my $substr = substr($inst,length("rotate right "));
			my ($a) = substr($substr, 0, index($substr, " step"));
			my $x = int($a);
			while ($x > 0) {
				my $temp = shift @result;
				push @result, $temp;
				$x--;
			}
		}
		#reverse direction but need to determine unscrambled position of letter.
		elsif(index($inst, "rotate based on position of letter") > -1) {
			my $a = substr($inst,length("rotate based on position of letter "));
			my $x = -1;
			for my $i(0..$#result) {
				if($result[$i] eq $a) {
					$x = $i;
					last;
				}
			}
			if($x == -1) {
				util::println("A position error has occured with instruction $inst\n");
				return 0;
			}
			$x1 = -1;
			# dumb idea, but try the rule forward with varying indexes until match.
			# i'm pretty sure the are indexes with multiple possible solutions using
			# this approach, but my answer worked so ¯\_(ツ)_/¯. possibly the puzzle
			# rules have been tailored to avoid this.
			for $z (0..$#result) {
				$z1 = ($z + ($z + 1 + ($z >= 4 ? 1 : 0))) % (scalar @result);
				if($z1 == $x) {
					$x1 = ($x - $z) % (scalar @result);
				}
			}
			if($x1 == -1) {
				util::println("No reversal found for instruction $inst\n");
				return 0;
			}
			while($x1 > 0) {
				# rotate left
				my $temp = shift @result;
				push @result, $temp;
				$x1--;
			}
		}
		# same operation
		elsif(index($inst, "reverse positions ") > -1) {
			my $substr = substr($inst,length("reverse positions "));
			my ($a, $b) = split(" through ", $substr);
			my $x = int($a);
			my $y = int($b);
			my @temp = splice(@result, $x, ($y-$x + 1));
			splice(@result, $x, 0, reverse @temp);
		}
		# reverse indexes
		elsif(index($inst, "move position ") > -1) {
			my $substr = substr($inst,length("move position "));
			my ($a, $b) = split(" to position ", $substr);
			my $x = int($a);
			my $y = int($b);
			my @temp = splice(@result, $y, 1);
			splice(@result, $x, 0, @temp);
		}
		else {
			util::println("Unrecognized instruction $inst\n");
			return 0;
		}
	}
	return join("", @result);
}

sub scramble {
	my($start, @instructions) = @_;
	my @result = split //, $start;
	for my $inst (@instructions) {
		if(index($inst, "swap position") > -1) {
			my $substr = substr($inst,length("swap position "));
			my ($a, $b) = split(" with position ", $substr);
			my $x = int($a);
			my $y = int($b);
			my $temp = $result[$x];
			$result[$x] = $result[$y];
			$result[$y] = $temp;
		}
		elsif(index($inst, "swap letter") > -1) {
			my $substr = substr($inst,length("swap letter "));
			my ($a, $b) = split(" with letter ", $substr);
			my $x = -1;
			my $y = -1;
			for my $i(0..$#result) {
				if($result[$i] eq $a) {
					$x = $i;
				}
				elsif($result[$i] eq $b) {
					$y = $i;
				}
			}
			if($x == -1 || $y == -1) {
				util::println("A position error has occured with instruction $inst\n");
				return 0;
			}
			
			my $temp = $result[$x];
			$result[$x] = $result[$y];
			$result[$y] = $temp;
		}
		elsif(index($inst, "rotate left") > -1) {
			my $substr = substr($inst,length("rotate left "));
			my ($a) = substr($substr, 0, index($substr, " step"));
			my $x = int($a);
			while ($x > 0) {
				my $temp = shift @result;
				push @result, $temp;
				$x--;
			}
		}
		elsif(index($inst, "rotate right") > -1) {
			my $substr = substr($inst,length("rotate right "));
			my ($a) = substr($substr, 0, index($substr, " step"));
			my $x = int($a);
			while ($x > 0) {
				my $temp = pop @result;
				unshift @result, $temp;
				$x--;
			}
		}
		elsif(index($inst, "rotate based on position of letter") > -1) {
			my $a = substr($inst,length("rotate based on position of letter "));
			my $x = -1;
			for my $i(0..$#result) {
				if($result[$i] eq $a) {
					$x = $i;
					last;
				}
			}
			if($x == -1) {
				util::println("A position error has occured with instruction $inst\n");
				return 0;
			}
			if($x >= 4) {
				$x++;
			}
			$x++;
			while($x > 0) {
				# rotate right
				my $temp = pop @result;
				unshift @result, $temp;
				$x--;
			}
		}
		elsif(index($inst, "reverse positions ") > -1) {
			my $substr = substr($inst,length("reverse positions "));
			my ($a, $b) = split(" through ", $substr);
			my $x = int($a);
			my $y = int($b);
			my @temp = splice(@result, $x, ($y-$x + 1));
			splice(@result, $x, 0, reverse @temp);
		}
		elsif(index($inst, "move position ") > -1) {
			my $substr = substr($inst,length("move position "));
			my ($a, $b) = split(" to position ", $substr);
			my $x = int($a);
			my $y = int($b);
			my @temp = splice(@result, $x, 1);
			splice(@result, $y, 0, @temp);
		}
		else {
			util::println("Unrecognized instruction $inst\n");
			return 0;
		}
	}
	return join("", @result);
}

sub day21 {
	my ($path) = @_;
	my @lines = util::file_read($path);
	
	my $part1 = scramble('abcdefgh', @lines);
	my $part2 = unscramble('fbgdceah', @lines);
	
	util::println("Part 1: ", $part1);	
	util::println("Part 2: ", $part2);
}
1;
