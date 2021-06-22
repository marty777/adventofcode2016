#!/usr/bin/perl
package day10;

use Exporter;
our @ISA= qw( Exporter );
our @EXPORT = qw( day10 );

sub print_bots {
	my (%bots) = @_;
	foreach $key (keys %bots) {
		#print("Printing $key\n");
		util::println("Bot $key\tLO: ", $bots{$key}{'lo'}, "\tHI: ", $bots{$key}{'hi'});
	}
}

sub give_to_bot {
	my($bot, $val, $bots) = @_;
	
	if(exists $bots->{$bot}) {
		my $hi = $bots->{$bot}{'hi'};
		my $lo = $bots->{$bot}{'lo'};
		if($hi > -1 && $lo > -1) {
			return 0;
		}
		if($hi == -1 && $lo == -1) {
			$bots->{$bot}{'lo'} = $val;
		}
		elsif($lo > $val) {
			$bots->{$bot}{'lo'} = $val;
			$bots->{$bot}{'hi'} = $lo;
		}
		else {
			$bots->{$bot}{'hi'} = $val;
		}
		return 1;
	}
	else {
		$bots->{$bot} = {'lo'=>$val, 'hi'=>-1};
		return 1;
	}
}

sub day10 {
	my ($path) = @_;
	my @lines = util::file_read($path);
	
	my $part1 = 0;
	my $part2 = 0;
	
	my @init = ();
	my @rules = ();
	my %bots = ();
	my %outputs = ();
	foreach $line (@lines) {
		if(index($line, "value ") != -1) {
			my $substr = substr($line, length("value "));
			my ($value, $bot) = split(" goes to bot ", $substr);
			give_to_bot(int($bot), int($value), \%bots);
		}
		else {
			my $substr = substr($line, length("bot "));
			my ($src, $right) = split(" gives low to ", $substr);
			my ($low, $high) = split(" and high to ", $right);
			$low_bot = -1;
			$high_bot = -1;
			$low_output = -1;
			$high_output = -1;
			if(index($low, "output") != -1) {
				$low_output = int(substr($low, length("output ")));
			}
			else {
				$low_bot = int(substr($low, length("bot ")));
			}
			if(index($high, "output") != -1) {
				$high_output = int(substr($high, length("output ")));
			}
			else {
				$high_bot = int(substr($high, length("bot ")));
			}
			my $rule = [int($src), int($low_bot), int($high_bot), int($low_output), int($high_output)];
			push(@rules, $rule);
		}
	}
	
	while(1) {
		my $unsatisfied = 0;
		for my $key (keys %bots) {
			if($bots{$key}{'hi'} > -1 && $bots{$key}{'lo'} > -1) {
				if($bots{$key}{'lo'} == 17 && $bots{$key}{'hi'} == 61) {
					$part1 = $key;
				}
				# find rules
				for $i (0..$#rules) {
					if($rules[$i][0] != $key) {
						next;
					}
					# check if can be passed to recipient bots
					my $can_satisfy = 1;
					if($rules[$i][1] > -1) {
						if(!exists($bots{$rules[$i][1]})) {
							$bots{$rules[$i][1]} = {'lo'=>-1, 'hi'=>-1};
						}
						if($bots{$rules[$i][1]}{'hi'} > -1) {
							$can_satisfy = 0;
						}
					}
					if($rules[$i][2] > -1) {
						if(!exists($bots{$rules[$i][2]})) {
							$bots{$rules[$i][2]} = {'lo'=>-1, 'hi'=>-1};
						}
						if($bots{$rules[$i][2]}{'hi'} > -1) {
							$can_satisfy = 0;
						}
					}
					if($can_satisfy) {
						# low to bot
						if($rules[$i][1] > -1) {
							give_to_bot($rules[$i][1], $bots{$key}{'lo'}, \%bots);
						}
						#low to output
						else {
							if(exists $outputs{$rules[$i][3]}) {
								push(@{$outputs{$rules[$i][3]}}, ($bots{$key}{'lo'}));
							}
							else {
								$outputs{$rules[$i][3]} = ($bots{$key}{'lo'});
							}
						}
						$bots{$key}{'lo'} = -1;
						# high to bot
						if($rules[$i][2] > -1) {
							give_to_bot($rules[$i][2], $bots{$key}{'hi'}, \%bots);
						}
						#hi to output
						else {
							if(exists $outputs{$rules[$i][4]}) {
								push(@{$outputs{$rules[$i][4]}}, ($bots{$key}{'hi'}));
							}
							else {
								$outputs{$rules[$i][4]} = ($bots{$key}{'hi'});
							}
						}
						$bots{$key}{'hi'} = -1;
					}
					
				}
			}
			
		}
		$unsatisfied = 0;
		for my $key (keys %bots) {
			if($bots{$key}{'hi'} > -1 && $bots{$key}{'lo'} > -1) {
				$unsatisfied++;
			}
		}
		if($unsatisfied == 0) {
			last;
		}
		
	}
	
	
	$part2 = $outputs{0} * $outputs{1}* $outputs{2};
	
	util::println("Part 1: ", $part1);
	util::println("Part 2: ", $part2);
}
