#!/usr/bin/perl
package day13;

use Exporter;
our @ISA= qw( Exporter );
our @EXPORT = qw( day13 );

sub coord_key {
	my($x,$y) = @_;
	return("$x,$y");
}

sub is_wall {
	my($seed, $x, $y) = @_;
	my $a = ($x * $x) + (3 * $x) + (2 * $x * $y) + $y + ($y*$y);
	$a += $seed;
	my $bit_count = 0;
	for my $i (0..31) {
		my $bit = 0x01 & ($a >> $i);
		if($bit) {
			$bit_count++;
		}
	}
	return ($bit_count % 2);
}

sub explore {
	my($seed, $start_x, $start_y, $dest_x, $dest_y) = @_;
	
	my %seen = ();
	my @stack = ();
	my $dest_key = coord_key($dest_x, $dest_y);
	
	@pos = ($start_x, $start_y, 0);
	push @stack, \@pos;
	while(scalar @stack > 0) {
		@curr_pos = @{shift @stack};
		
		my $curr_key = coord_key($curr_pos[0], $curr_pos[1]);
		my $curr_steps = $curr_pos[2];
		
		if(!exists($seen{$curr_key})) {
			$seen{$curr_key} = $curr_pos[2];
			
		}
		else {
			if($curr_steps < $seen{$curr_key}) {
				$seen{$curr_key} = $curr_steps;
			}
		}
		if($curr_key eq $dest_key) {
			my $part2_count = 0;
			for my $key (keys %seen) {
				if($seen{$key} <= 50) {
					$part2_count++;
				}
			}
			return $curr_steps, $part2_count;

		}
		#try all open neighbors
		my $next_x = $curr_pos[0];
		my $next_y = $curr_pos[1];
		my $next_key = "";
		#north
		$next_x = $curr_pos[0];
		$next_y = $curr_pos[1] + 1;
		$next_key = coord_key($next_x, $next_y);
		if($next_x >= 0 && $next_y >= 0 && !is_wall($seed, $next_x, $next_y) && !exists($seen{$next_key})) {
			my @next_pos = ($next_x, $next_y, $curr_steps+1); 
			push @stack, \@next_pos;
		}
		#east
		$next_x = $curr_pos[0] + 1;
		$next_y = $curr_pos[1];
		$next_key = coord_key($next_x, $next_y);
		if($next_x >= 0 && $next_y >= 0 && !is_wall($seed, $next_x, $next_y) && !exists($seen{$next_key})) {
			my @next_pos = ($next_x, $next_y, $curr_steps+1); 
			push @stack, \@next_pos;
		}
		#south
		$next_x = $curr_pos[0];
		$next_y = $curr_pos[1] - 1;
		$next_key = coord_key($next_x, $next_y);
		if($next_x >= 0 && $next_y >= 0 && !is_wall($seed, $next_x, $next_y) && !exists($seen{$next_key})) {
			my @next_pos = ($next_x, $next_y, $curr_steps+1); 
			push @stack, \@next_pos;
		}
		#west
		$next_x = $curr_pos[0] - 1;
		$next_y = $curr_pos[1];
		$next_key = coord_key($next_x, $next_y);
		if($next_x >= 0 && $next_y >= 0 && !is_wall($seed, $next_x, $next_y) && !exists($seen{$next_key})) {
			my @next_pos = ($next_x, $next_y, $curr_steps+1); 
			push @stack, \@next_pos;
		}
	}
	
	return -1;
}

sub day13 {
	my ($path) = @_;
	my @lines = util::file_read($path);
	
	my $seed = int($lines[0]);

	my ($part1, $part2) = explore($seed, 1,1,31,39);
	
	util::println("Part 1: ", $part1);
	util::println("Part 2: ", $part2);
}
1;
