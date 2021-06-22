#!/usr/bin/perl
package day22;

use Storable qw(dclone);

use Exporter;
our @ISA= qw( Exporter );
our @EXPORT = qw( day22);

sub print_state {
	my ($width, $height, @state) = @_;
	my $goal_x = $state[$height];
	my $goal_y = $state[$height+1];
	my $steps = $state[$height+4];
	for $y (0..$height-1) {
		for $x (0..$width-1) {
			if($x == $goal_x && $y == $goal_y) {
				print("G ");
			}
			elsif($state[$y][$x] == 1) {
				print(". ");
			}
			elsif($state[$y][$x] == 2) {
				print("# ");
			}
			else {
				print("_ ");
			}
		}
		print("\n");
	}
	print("Goal: ($state[$height],$state[$height+1]) Empty: ($state[$height+2], $state[$height+3]) Steps: $state[$height+4]\n");
}

sub parse {
	my($line) = @_;
	if(index($line, "/dev/") == -1) {
		return 0;
	}
	my @split = split ' ', $line; # space does arbitrary whitespace matching on split.
	my $node = $split[0];
	my $substr1 = substr($node, length("/dev/grid/note-x"));
	my ($x, $y) = split("-y", $substr1);
	my $size = substr($split[1], 0, length($split[1]) - 1);
	my $used = substr($split[2], 0, length($split[1]) - 1);
	return (int($x), int($y), int($size), int($used));
}

sub state_key {
	my ($width, $height, @state) = @_;
	my $goal_x = $state[$height];
	my $goal_y = $state[$height+1];
	my $empty_x = $state[$height+2];
	my $empty_y = $state[$height+3];
	return "E[$empty_x,$empty_y]G[$goal_x,$goal_y]";
	
}

# using a combination of dijkstra to get the empty node to the goal node and then undirected bfs 
# to get the goal node to 0,0 doesn't provide as much of a speed improvement as i'd hoped. it works
# though, and it should be robust against arbitrary obstacle positions.
sub path {
	my ($width, $height, @state) = @_;
	my $goal_x_index = $height;
	my $goal_y_index = $height+1;
	my $empty_x_index = $height+2;
	my $empty_y_index = $height+3;
	my $steps_index = $height+4;
	
	# find length of path from empty to west of goal using dijkstra's algorithm.
	# if west blocked, use south.
	my $dijkstra_dest_x = $width-2;
	my $dijkstra_dest_y = 0;
	if($state[$dijkstra_dest_y][$dijkstra_dest_x] == 2) {
		$dijkstra_dest_x = $width - 1;
		$dijkstra_dest_y = 1;
	}
	my $d_x_index = 0;
	my $d_y_index = 1;
	my $d_steps_index = 2;
	my @dijkstra_state = ($state[$empty_x_index], $state[$empty_y_index], 0); #empty space x, y, steps
	my @dijkstra_stack = ();
	
	my %seen = ();
	
	push @dijkstra_stack, \@dijkstra_state;
	my $goal_start_x = $state[$goal_x_index];
	my $goal_start_y = $state[$goal_y_index];
	my $dijkstra_end_key = "E[$dijkstra_dest_x,$dijkstra_dest_y]G[$goal_start_x,$goal_start_y]";
	
	#explore entire space to make sure we have the shortest path and to increase previously seen states.
	while(scalar @dijkstra_stack > 0) {
		my @curr_pos = @{shift @dijkstra_stack};
		my $curr_key = "E[$curr_pos[0],$curr_pos[1]]G[$goal_start_x,$goal_start_y]";
		if(exists($seen{$curr_key}) && $seen{$curr_key} <= $curr_pos[$d_steps_index]) {
			next;
		}
		$seen{$curr_key} = $curr_pos[$d_steps_index];
		#north
		if($curr_pos[$d_y_index] > 0 && $state[$curr_pos[$d_y_index] - 1][$curr_pos[$d_x_index]] != 2) {
			my @next_pos = ($curr_pos[$d_x_index], $curr_pos[$d_y_index] - 1, $curr_pos[$d_steps_index]+1);
			push @dijkstra_stack, \@next_pos;
		}
		#south
		if($curr_pos[$d_y_index] < $height-1 && $state[$curr_pos[$d_y_index] + 1][$curr_pos[$d_x_index]] != 2) {
			my @next_pos = ($curr_pos[$d_x_index], $curr_pos[$d_y_index] + 1, $curr_pos[$d_steps_index]+1);
			push @dijkstra_stack, \@next_pos;
		}
		#west
		if($curr_pos[$d_x_index] > 0 && $state[$curr_pos[$d_y_index]][$curr_pos[$d_x_index] - 1] != 2) {
			my @next_pos = ($curr_pos[$d_x_index] - 1, $curr_pos[$d_y_index], $curr_pos[$d_steps_index]+1);
			push @dijkstra_stack, \@next_pos;
		}
		#east
		if($curr_pos[$d_x_index] < $width-1 && $state[$curr_pos[$d_y_index]][$curr_pos[$d_x_index] + 1] != 2) {
			my @next_pos = ($curr_pos[$d_x_index] + 1, $curr_pos[$d_y_index], $curr_pos[$d_steps_index]+1);
			push @dijkstra_stack, \@next_pos;
		}
	}
	
	$d_steps = $seen{$dijkstra_end_key};
	# remove destination key from seen
	delete $seen{$dijkstra_end_key};
	
	# configure state - move empty to dest position and set steps
	$state[$state[$empty_y_index]][$state[$empty_x_index]] = 1;
	$state[$empty_x_index] = $dijkstra_dest_x; # empty cell x pos
	$state[$empty_y_index] = $dijkstra_dest_y; # empty cell y pos
	$state[$dijkstra_dest_y][$dijkstra_dest_x] = 0;
	$state[$steps_index] = $d_steps;
	
	# run bfs forward
	my @stack = ();
	push @stack, \@state;
	
	while(scalar @stack > 0) {
		my @curr_state = @{shift @stack};
		my $curr_goal_x = $curr_state[$goal_x_index];
		my $curr_goal_y = $curr_state[$goal_y_index];
		my $curr_empty_x = $curr_state[$empty_x_index];
		my $curr_empty_y = $curr_state[$empty_y_index];
		my $curr_steps = $curr_state[$steps_index];
		
		if($curr_goal_x == 0 && $curr_goal_y == 0) {
			return $curr_state[$steps_index]; # steps
		}
		my $curr_key = state_key($width, $height, @curr_state);
		if(exists($seen{$curr_key})) {
			next;
		}
		$seen{$curr_key} = $curr_steps;
		
		# try all possible moves of the empty position
		# avoid copying and pushing states to the stack
		# if they've been previously visited, rather then rejecting them
		# after being added and popped. It won't skip duplication entirely but
		# it should help. The states are quite big at the moment.
		#north
		if($curr_empty_y > 0 && $curr_state[$curr_empty_y-1][$curr_empty_x] != 2) {
			my $next_goal_x = $curr_goal_x;
			my $next_goal_y = $curr_goal_y;
			my $next_empty_x = $curr_empty_x;
			my $next_empty_y = $curr_empty_y-1;
			if($next_empty_y == $next_goal_y && $next_empty_x == $next_goal_x) {
				$next_goal_x = $curr_empty_x;
				$next_goal_y = $curr_empty_y;
			}
			$next_key = "E[$next_empty_x,$next_empty_y]G[$next_goal_x,$next_goal_y]";
			if(!exists($seen{$next_key})) {
				my @next_state = @{ dclone(\@curr_state) };
				$next_state[$goal_x_index] = $next_goal_x;
				$next_state[$goal_y_index] = $next_goal_y;
				$next_state[$empty_x_index] = $next_empty_x;
				$next_state[$empty_y_index] = $next_empty_y;
				$next_state[$curr_empty_y][$curr_empty_x] = 1;
				$next_state[$next_empty_y][$next_empty_x] = 0;
				$next_state[$steps_index] = $curr_steps + 1;
				push @stack, \@next_state;
			}
		}
		#south
		if($curr_empty_y < $height - 1 && $curr_state[$curr_empty_y+1][$curr_empty_x] != 2) {
			my $next_goal_x = $curr_goal_x;
			my $next_goal_y = $curr_goal_y;
			my $next_empty_x = $curr_empty_x;
			my $next_empty_y = $curr_empty_y+1;
			if($next_empty_y == $next_goal_y && $next_empty_x == $next_goal_x) {
				$next_goal_x = $curr_empty_x;
				$next_goal_y = $curr_empty_y;
			}
			$next_key = "E[$next_empty_x,$next_empty_y]G[$next_goal_x,$next_goal_y]";
			if(!exists($seen{$next_key})) {
				my @next_state = @{ dclone(\@curr_state) };
				$next_state[$goal_x_index] = $next_goal_x;
				$next_state[$goal_y_index] = $next_goal_y;
				$next_state[$empty_x_index] = $next_empty_x;
				$next_state[$empty_y_index] = $next_empty_y;
				$next_state[$curr_empty_y][$curr_empty_x] = 1;
				$next_state[$next_empty_y][$next_empty_x] = 0;
				$next_state[$steps_index] = $curr_steps + 1;
				push @stack, \@next_state;
			}
		}
		# west
		if($curr_empty_x > 0 && $curr_state[$curr_empty_y][$curr_empty_x-1] != 2) {
			my $next_goal_x = $curr_goal_x;
			my $next_goal_y = $curr_goal_y;
			my $next_empty_x = $curr_empty_x-1;
			my $next_empty_y = $curr_empty_y;
			if($next_empty_y == $next_goal_y && $next_empty_x == $next_goal_x) {
				$next_goal_x = $curr_empty_x;
				$next_goal_y = $curr_empty_y;
			}
			$next_key = "E[$next_empty_x,$next_empty_y]G[$next_goal_x,$next_goal_y]";
			if(!exists($seen{$next_key})) {
				my @next_state = @{ dclone(\@curr_state) };
				$next_state[$goal_x_index] = $next_goal_x;
				$next_state[$goal_y_index] = $next_goal_y;
				$next_state[$empty_x_index] = $next_empty_x;
				$next_state[$empty_y_index] = $next_empty_y;
				$next_state[$curr_empty_y][$curr_empty_x] = 1;
				$next_state[$next_empty_y][$next_empty_x] = 0;
				$next_state[$steps_index] = $curr_steps + 1;
				push @stack, \@next_state;
			}
		}
		# east
		if($curr_empty_x < $width - 1 && $curr_state[$curr_empty_y][$curr_empty_x+1] != 2) {
			my $next_goal_x = $curr_goal_x;
			my $next_goal_y = $curr_goal_y;
			my $next_empty_x = $curr_empty_x+1;
			my $next_empty_y = $curr_empty_y;
			if($next_empty_y == $next_goal_y && $next_empty_x == $next_goal_x) {
				$next_goal_x = $curr_empty_x;
				$next_goal_y = $curr_empty_y;
			}
			$next_key = "E[$next_empty_x,$next_empty_y]G[$next_goal_x,$next_goal_y]";
			if(!exists($seen{$next_key})) {
				my @next_state = @{ dclone(\@curr_state) };
				$next_state[$goal_x_index] = $next_goal_x;
				$next_state[$goal_y_index] = $next_goal_y;
				$next_state[$empty_x_index] = $next_empty_x;
				$next_state[$empty_y_index] = $next_empty_y;
				$next_state[$curr_empty_y][$curr_empty_x] = 1;
				$next_state[$next_empty_y][$next_empty_x] = 0;
				$next_state[$steps_index] = $curr_steps + 1;
				push @stack, \@next_state;
			}
		}
		
	}
	
	return -1;
}

sub day22 {
	my ($path) = @_;
	my @lines = util::file_read($path);

	my @nodes = ();
	for $i (2..$#lines) {
		my @node = parse($lines[$i]);
		push @nodes, \@node;
	}
	
	my $max_x = 0;
	my $max_y = 0;
	for my $i(0..$#nodes) {
		if($nodes[$i][0] > $max_x) {
			$max_x = $nodes[$i][0];
		}
		if($nodes[$i][1] > $max_y) {
			$max_y = $nodes[$i][1];
		}
	}
	
	my $goal_capacity = -1;
	my $goal_used = -1;
	my $goal_x_index = $max_x;
	my $goal_y_index = 0;
	for my $i (0..$#nodes) {
		if($nodes[$i][0] == $goal_x_index && $nodes[$i][1] == $goal_y_index) {
			$goal_capacity = $nodes[$i][2];
			$goal_used = $nodes[$i][3];
			last;
		}
	}
	
	# build simplfied state
	my @state = ();
	my $empty_x = -1;
	my $empty_y = -1;
	my $empty_i = -1;
	my $empty_count = 0;
	for $y(0..$max_y) {
		my @insert = ();
		my @row = ();
		for $x(0..$max_x) {
			for my $i (0..$#nodes) {
				if($nodes[$i][0] == $x && $nodes[$i][1] == $y) {
					my $viable = ($nodes[$i][3] > $goal_capacity && $nodes[$i][2] >= $goal_used) ? 2 : ($nodes[$i][3] == 0 ? 0 : 1);
					if($viable == 0) {
						$empty_x = $x;
						$empty_y = $y;
						$empty_i = $i;
						$empty_count++;
					}
					push @row, $viable;
					last;
				}
			}
		}
		push @state, \@row;
	}
	
	if($empty_count != 1) {
		util::println("More than one empty node found $empty_count. Exiting...");
		exit();
	}
	push @state, $max_x; # goal data x
	push @state, 0; # goal data y
	push @state, $empty_x; #empty node x
	push @state, $empty_y; #empty node y
	push @state, 0; # steps
	
	my $part1 = 0;
	for $i (0..$#nodes) {
		if($i == $empty_i) {
			next;
		}
		if($nodes[$i][3] <= $nodes[$empty_i][2]) {
			$part1++;
		}
	}
	util::println("Part 1: ", $part1);
	
	# partially solve part 2 using djisktra's algorithm to find min # of steps
	# from empty node to immediately west of goal node. If west is an obstacle,
	# use immediately south instead. One of those has to be open.
	
	# my $empty_dest_x = $max_x - 1;
	# my $empty_dest_y = 0;
	# if($state[$empty_dest_y][$empty_dest_x] == 2) {
		# $empty_dest_x = $max_x;
		# $empty_dest_y = 1;
	# }
	# my $path_len = path($max_x + 1, $max_y + 1, $empty_x, $empty_y, $empty_dest_x, $empty_dest_y, @state);
	
	# given the starting point for an empty cell, run forward with undirected BFS until solution found.
	# i suspect this portion can be solved simply, but i can't guarantee there aren't any obstacles between the goal and (0,0) which
	# would complicate things.
	
	# my @state2 = @{ dclone(\@state) };
	# $state2[$max_y + 3] = $empty_dest_x; # empty cell x pos
	# $state2[$max_y + 4] = $empty_dest_y; # empty cell y pos
	# $state2[$empty_y][$empty_x] = 1;
	# $state2[$empty_dest_y][$empty_dest_x] = 0;
	# my $path_len2 = solve($max_x + 1, $max_y + 1, @state2);
	
	# my $part2 = $path_len + $path_len2;
	my $part2 = path($max_x + 1, $max_y + 1, @state);
	util::println("Part 2: ", $part2);
}

1;