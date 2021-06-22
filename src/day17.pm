#!/usr/bin/perl
package day17;

use Digest::MD5 qw(md5 md5_hex md5_base64);

use Exporter;
our @ISA= qw( Exporter );
our @EXPORT = qw( day17);

sub pos_key {
	my($pos_x, $pos_y) = @_;
	return("$pos_x,$pos_y");
}

sub is_open {
	my($dir, $hash) = @_;
	my $open_chars = "bcdef";
	
	if($dir eq 'U') {
		$char = substr($hash, 0, 1);
		
		if(index($open_chars, $char) > -1) {
			return 1;
		}
		return 0;
	}
	elsif($dir eq 'D') {
		$char = substr($hash, 1, 1);
		if(index($open_chars, $char) > -1) {
			return 1;
		}
		return 0;
	}
	elsif($dir eq 'L') {
		$char = substr($hash, 2, 1);
		if(index($open_chars, $char) > -1) {
			return 1;
		}
		return 0;
	}
	elsif($dir eq 'R') {
		$char = substr($hash, 3, 1);
		if(index($open_chars, $char) > -1) {
			return 1;
		}
		return 0;
	}
	return 0;
}

sub solve {
	my($passcode, $part2) = @_;
	
	my @stack = ();
	my %seen = ();
	
	my $end_key = pos_key(3,3);
	my @init = (0, 0, "", 0);
	
	push @stack, \@init;
	
	while(scalar @stack > 0) {
		my @curr_state = @{shift @stack};
		
		my $curr_pos_x = $curr_state[0];
		my $curr_pos_y = $curr_state[1];
		my $curr_path = $curr_state[2];
		my $curr_steps = $curr_state[3];
		my $curr_key = pos_key($curr_pos_x, $curr_pos_y);
		
		if(exists($seen{$curr_key})) {
			if($part2) {
				if(length($seen{$curr_key}) < length($curr_state[2])) {
					$seen{$curr_key} = $curr_state[2];
				}
			}
			else {
				if(length($seen{$curr_key}) > length($curr_state[2])) {
					$seen{$curr_key} = $curr_state[2];
				}
			}
		}
		else {
			$seen{$curr_key} = $curr_state[2];
		}
		
		# goal 
		if($curr_pos_x == 3 && $curr_pos_y == 3) {
			if(!$part2) {
				last;
			}
			else {
				next;
			}
		}
		
		#next states
		my $curr_hash = md5_hex($passcode.$curr_path);
		#north
		if($curr_pos_y > 0 && is_open('U', $curr_hash)) {
			my @next_state = ($curr_pos_x, $curr_pos_y - 1, $curr_path.'U', $curr_steps+1);
			push @stack, \@next_state; 
		}
		#south
		if($curr_pos_y < 3 && is_open('D', $curr_hash)) { 
			my @next_state = ($curr_pos_x, $curr_pos_y + 1, $curr_path.'D', $curr_steps+1);
			push @stack, \@next_state; 
		}
		#west
		if($curr_pos_x > 0 && is_open('L', $curr_hash)) { 
			my @next_state = ($curr_pos_x - 1, $curr_pos_y, $curr_path.'L', $curr_steps+1);
			push @stack, \@next_state; 
		}
		#east
		if($curr_pos_x < 3 && is_open('R', $curr_hash)) { 
			my @next_state = ($curr_pos_x + 1, $curr_pos_y, $curr_path.'R', $curr_steps+1);
			push @stack, \@next_state; 
		}
	}
	if(exists($seen{$end_key})) {
		return $seen{$end_key};
	}
	return "";
}

sub day17 {
	my ($path) = @_;
	my @lines = util::file_read($path);

	my $passcode = $lines[0];
	#$passcode = 'ulqzkmiv';
	
	my $part1 = solve($passcode, 0);
	my $part2 = length(solve($passcode, 1));
	
	util::println("Part 1: ", $part1);
	util::println("Part 2: ", $part2);
}

1;