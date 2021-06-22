#!/usr/bin/perl
package day11;

use Storable qw(dclone);
use Exporter;
use Data::Dumper;
our @ISA= qw( Exporter );
our @EXPORT = qw( day11 );


sub parse_line {
	my($floor, $line, $prefix) = @_;
	my @result = ();
	$line = substr($line, length($prefix), length($line)-1-length($prefix));
	@sections = split(", ", $line);
	for $section (@sections) {
		if(index($section, " and ") != -1) {
			
			my ($a, $b) = split(" and ", $section);
			$a = substr($a, length("a "));
			$b = substr($b, length("a "));
			push(@result, $a);
			push(@result, $b);
		}
		elsif (index($section, "and ") != -1) {
			$section = substr($section, length("and a "));
			push(@result, $section);
		}
		else {
			$section = substr($section, length("a "));
			push(@result, $section);
		}
	}
	my @ret = ();
	for my $item (@result) {
		my $item_tag = "";
		my $item_type = 1;
		if(index($item, "-compatible") != -1) {
			$item_tag = substr($item, 0, index($item, "-compatible"));
			$item_type = 1;
		}
		else {
			$item_tag = substr($item, 0, index($item, " "));
			$item_type = 2;
		}
		if(!exists($tag_cache{$item_tag})) {
			$tag_cache{$item_tag} = $last_tag_index;
			$last_tag_index++;
		}
		push(@ret, [$tag_cache{$item_tag}, $item_type, $floor]);
	}
	
	return @ret;
}

sub end_key {
	my (@state) = @_;
		my $index = ord('A');
		my $ret = '4[][][][';
		my %tags = ();
		my @items = ();
		for $i (0..$#state -2) {
			if(exists($tags{$state[$i][0]})) {
				push @items, chr($tags{$state[$i][0]}).($state[$i][1] == 1 ? 'C' : 'G');
			}
			else {
				$tags{$state[$i][0]} = $index;
				$index++;
				push @items, chr($tags{$state[$i][0]}).($state[$i][1] == 1 ? 'C' : 'G');
			}
		}
		$ret .= join(",", sort @items);
		$ret .= ']';
		return $ret;
}

sub state_key {
		my (@state) = @_;
		my $index = ord('A');
		my $ret = "$state[$#state-1]";
		my %tags = ();
		for $floor (1..4) {
			my @items = ();
			for $i (0..$#state -1) {
				if($state[$i][2] == $floor) {
					if(exists($tags{$state[$i][0]})) {
						push @items, chr($tags{$state[$i][0]}).($state[$i][1] == 1 ? 'C' : 'G');
					}
					else {
						$tags{$state[$i][0]} = $index;
						$index++;
						push @items, chr($tags{$state[$i][0]}).($state[$i][1] == 1 ? 'C' : 'G');
					}
				}
			}
			$ret .= '['.join(",", sort @items).']';
		}
		return $ret;
}

sub key_to_state {
	my($key) = @_;
	my $elevator = ord(substr($key, 0, 1)) - ord('0');
	my @floor_strs = split('\[', $key);
	my @state = ();
	#print Dumper(@floor_strs);
	my $item_index = 0;
	for $i (1..4) {
		my $str = substr($floor_strs[$i],0,length($floor_strs[$i]) - 1);
		my @items = split(',', $str);
		for $item (@items) {
			#print("$i $item $item[0] $item[1]\n");
			push @state, [ord(substr($item, 0, 1)) - ord('A'), substr($item,1,1) eq 'C' ? 1 : 2, $i];
		}
	}
	push @state, $elevator;
	return @state;
}

sub viable {
	my(@state) = @_;
	for $i (0..$#state - 2) {
		if($state[$i][1] == 1) {
			my $gen_present = 0;
			my $other_gens = 0;
			for $j (0..$#state - 2) {
				if($i == $j) {
					next;
				}
				if($state[$j][0] == $state[$i][0] && $state[$j][2] == $state[$i][2]) {
					$gen_present = 1;
				}
				elsif($state[$j][1] == 2 && $state[$j][0] != $state[$i][0] && $state[$j][2] == $state[$i][2]) {
					$other_gens++;
				}
			}
			if(!$gen_present && $other_gens > 0) {
				return 0;
			}
		}
	}
	return 1;
}

sub solve {
	my $verbose = 0;
	my($end_key, @state) = @_;
	Dumper(@state);
	my @stack = ();
	my %seen = ();
	
	push @stack, \@state;
	
	my $curr_steps = 0;
	while(scalar @stack > 0) {
		my @curr_state = @{shift @stack};
		my $curr_key = state_key(@curr_state);
		if($curr_steps < $curr_state[$#curr_state] && $verbose) {
			$curr_steps++;
			util::println("On steps $curr_steps $curr_state[$#curr_state] stack",scalar @stack);
		}
		if($curr_key eq $end_key) {
			return $curr_state[$#curr_state]; 
		}
		if(exists($seen{$curr_key})) {
			next;
		}
		$seen{$curr_key} = @curr_state[$#curr_state]; # steps;
		my $elevator = $curr_state[$#curr_state - 1];
		# check items below elevator pos
		my $below_count = 0;
		for my $i (0..$#curr_state - 2) {
			if($curr_state[$i][2] < $elevator) {
				$below_count++;
			}
		}
		for my $down (0..1) {
			if($down && $below_count == 0) {
				next;
			}
			my $next_elevator = $elevator + 1;
			if($down) {
				$next_elevator = $elevator - 1;
			}
			if($next_elevator < 1 || $next_elevator > 4) {
				next;
			}
			my @curr_items = ();
			for my $i (0..$#curr_state - 2) {
				if($curr_state[$i][2] == $elevator) {
					push @curr_items, $i;
				}
			}
			for my $i (0..$#curr_items) {
				for my $j ($i..$#curr_items) {
					my @next_state = @{dclone(\@curr_state)};
					$next_state[$#next_state]++; #increment steps
					$next_state[$#next_state - 1] = $next_elevator;
					$next_state[$curr_items[$i]][2] = $next_elevator;
					if ($j != $i) {
						$next_state[$curr_items[$j]][2] = $next_elevator;
					}
					if(!viable(@next_state) || exists($seen{state_key(@next_state)})) {
						next;
					}
					push @stack, \@next_state;
				}
				
			}
		}
	}
	return -1;
}

sub day11 {
	my ($path) = @_;
	my @lines = util::file_read($path);
	
	my @floor1 = parse_line(1, $lines[0], "The first floor contains ");
	my @floor2 = parse_line(2, $lines[1], "The second floor contains ");
	my @floor3 = parse_line(3, $lines[2], "The third floor contains ");
	my @floor4 = ();

	my @state = (@floor1,@floor2,@floor3,@floor4, 1, 0); # items + elevator position + steps
	my $end_key = end_key(@state);
	my $part1 = solve($end_key, @state);
	
	# part 2 - add items
	my @state2 = ();
	my $hi_index = -1;
	for my $i (0..$#state - 2) {
		if($state[$i][0] > $hi_index) {
			$hi_index = $state[$i][0];
		}
	}
	push @floor1, [$hi_index+1, 1, 1];
	push @floor1, [$hi_index+1, 2, 1];
	push @floor1, [$hi_index+2, 1, 1];
	push @floor1, [$hi_index+2, 2, 1];
	
	my @state2 = (@floor1,@floor2,@floor3,@floor4, 1, 0); # items + elevator position + steps
	my $end_key2 = end_key(@state2);
	my $part2 = solve($end_key2, @state2);
	
	util::println("Part 1: ", $part1);
	util::println("Part 2: ", $part2);
}

1;