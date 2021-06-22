#!/usr/bin/perl
package day24;

use Storable qw(dclone);

use Exporter;
our @ISA= qw( Exporter );
our @EXPORT = qw( day24);

sub print_grid {
	my (@grid) = @_;
	for$y (0..$#grid) {
		my @row = @{$grid[$y]};
		for $x (0..$#row) {
			if($row[$x] == - 1) {
				print('.');
			}
			elsif($row[$x] == -2) {
				print('#');
			}
			else {
				print($row[$x]);
			}
		}
		print("\n");
	}
}

sub optimize {
	my ($max_poi, $part2, @distances) = @_;
	
	my @stack = ();
	my %seen = ();
	
	my $best = -1;
	
	my @start = ('0', 0);
	push @stack, \@start;
	while (scalar @stack > 0) {
		my @curr_state = @{shift @stack};
		if(length($curr_state[0]) == $max_poi + 1) {
			if($part2) {
				my $prev = int(substr($curr_state[0], length($curr_state[0]) - 1));
				my $dist = $curr_state[1] + $distances[$prev][0];
				if($best == -1 || $best > $dist) {
					$best = $dist;
				}
			}
			else {
				if($best == -1 || $best > $curr_state[1]) {
					$best = $curr_state[1];
				}
			}
		}
		for $i(0..$max_poi) {
			my $str = "$i";
			if(index($curr_state[0], $str) > -1) {
				next;
			}
			my $prev = int(substr($curr_state[0], length($curr_state[0]) - 1));
			my $next_key = "$curr_state[0]$str";
			my $next_dist = $curr_state[1] + $distances[$prev][$i];
			if(exists($seen{$next_key})) {
				next;
			}
			my @next_state = ($next_key, $next_dist);
			push @stack, \@next_state;
			$seen{$next_key} = $next_dist;
		}
	}
	return $best;
}


sub pathlen {
	my($start_x, $start_y, $dest_x, $dest_y, @grid) = @_;
	
	my $width = scalar @{$grid[0]};
	my $height = scalar @grid;
	
	# dijkstra
	my @stack = ();
	my %seen = ();
	
	my $end_key = $dest_x + ($width*$dest_y);
	my @state = ($start_x, $start_y, 0);
	push @stack, \@state;
	
	my $max_steps = 0;
	
	while(scalar @stack > 0) {
		my @curr_state = @{shift @stack};
		my $curr_key = $curr_state[0] +  ($width * $curr_state[1]);
		if(exists($seen{$curr_key}) && $seen{$curr_key} < $curr_state[2]) {
			next;
		}
		$seen{$curr_key} = $curr_state[2];
		if($curr_key eq $end_key) {
			last;
		}
		if($curr_state[2] > $max_steps) {
			$max_steps = $curr_state[2];
		}
		
		#north
		if($curr_state[1] > 0 && $grid[$curr_state[1] - 1][$curr_state[0]] != -2) {
			my @next_state = ($curr_state[0], $curr_state[1] - 1, $curr_state[2] + 1 );
			my $next_key = $next_state[0] +  ($width * $next_state[1]);
			if(!exists($seen{$next_key}) || $seen{$next_key} > $next_state[2]) {
				#more aggressive use of seen hash to minimize items pushed to stack
				$seen{$next_key} = $next_state[2];
				push @stack, \@next_state;
			}
		}
		#south
		if($curr_state[1] < $height-1 && $grid[$curr_state[1] + 1][$curr_state[0]] != -2) {
			my @next_state = ($curr_state[0], $curr_state[1] + 1, $curr_state[2] + 1 );
			my $next_key = $next_state[0] +  ($width * $next_state[1]);
			if(!exists($seen{$next_key}) || $seen{$next_key} > $next_state[2]) {
				$seen{$next_key} = $next_state[2];
				push @stack, \@next_state;
			}
		}
		#west
		if($curr_state[0] > 0 && $grid[$curr_state[1]][$curr_state[0] - 1] != -2) {
			my @next_state = ($curr_state[0] - 1, $curr_state[1], $curr_state[2] + 1 );
			my $next_key = $next_state[0] +  ($width * $next_state[1]);
			if(!exists($seen{$next_key}) || $seen{$next_key} > $next_state[2]) { 
				$seen{$next_key} = $next_state[2];
				push @stack, \@next_state;
			}
		}
		#east
		if($curr_state[0] < $width - 1 && $grid[$curr_state[1]][$curr_state[0]  + 1] != -2) {
			my @next_state = ($curr_state[0] + 1, $curr_state[1], $curr_state[2] + 1 );
			my $next_key = $next_state[0] +  ($width * $next_state[1]);
			if(!exists($seen{$next_key}) || $seen{$next_key} > $next_state[2]) {
				$seen{$next_key} = $next_state[2];
				push @stack, \@next_state;
			}
		}
	}
	
	if(exists($seen{$end_key})) {
		return $seen{$end_key};
	}
	return -1;
}

sub day24 {
	my ($path) = @_;
	my @lines = util::file_read($path);
	
	my @grid = ();
	my $max_poi = 0;
	my %positions = ();
	for $i(0..$#lines) {
			my @row = ();
			my @line_split = split //, $lines[$i];
			for $j (0..$#line_split) {
				$val = -1; # empty path
				if($line_split[$j] eq '#') {
					$val = -2; # obstacle
				}
				# restricted to single-digit poi values, but the map format does that anyway.
				elsif(ord($line_split[$j]) >=  ord('0') && ord($line_split[$j]) <= ord('9')) {
					$val = int($line_split[$j]); # poi number
					$positions{$val} = [$j, $i];
					if($val > $max_poi) {
						$max_poi = $val;
					}
				}
				push @row, $val;
			}
			push @grid, \@row;
	}
	
	# build cache of distances between poi nodes
	my @distances = ();
	for $i(0..$max_poi) {
		my @row = ();
		for $j (0..$max_poi) {
			push @row, -1;
		}
		push @distances, \@row;
	}
	for $i (0..$max_poi) {
		for $j (0..$max_poi) {
			if($distances[$j][$i] > -1) {
				$distances[$i][$j] = $distances[$j][$i];
			}
			else {
				$distances[$i][$j] = pathlen($positions{$i}[0], $positions{$i}[1], $positions{$j}[0], $positions{$j}[1], @grid);
			}
		}
	}
	
	# solve using pre-computed distances between poi nodes
	my $part1 = optimize($max_poi, 0, @distances);
	util::println("Part 1: ", $part1);
	my $part2 = optimize($max_poi, 1, @distances);;
	util::println("Part 2: ", $part2);
}

1;