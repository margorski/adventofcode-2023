#!/usr/bin/perl

use strict;
use warnings;

sub process_line_p1 {
    my ($prev, $curr, $next, $debug) = @_;

    my $sum_of_valid_parts = 0;
    my $line_length = length($curr);

    if ($debug) {
        print("===================================================\n");
        print defined $prev ? $prev : "---"; print "\n";
        print $curr; print "\n";
        print defined $next ? $next : "---"; print "\n\n";
    }

    while ($curr =~ /\b(\d+)\b/g) {
        my $start_pos = $-[0] == 0 ? 0 : $-[0] - 1;
        my $end_pos = $+[0];
        my $check_length = $end_pos - $start_pos + 1;
        my $matched_number = $1;

        my $adjacent_to_character_in_prev = defined $prev && substr($prev, $start_pos, $check_length) =~ /[^\d\.]/g;
        my $adjacent_to_character_in_curr = ($start_pos > 0 && substr($curr, $start_pos, 1) =~ /[^\d\.]/g) || substr($curr, $end_pos, 1) =~ /[^\d\.]/g;
        my $adjacent_to_character_in_next = defined $next && substr($next, $start_pos, $check_length) =~ /[^\d\.]/g;
        
        if ($debug) {
            print("Part: $matched_number \t POS: $start_pos - $end_pos ($check_length) \t$adjacent_to_character_in_prev\t$adjacent_to_character_in_curr\t$adjacent_to_character_in_next\t");
        }

        if ($adjacent_to_character_in_curr || $adjacent_to_character_in_next || $adjacent_to_character_in_prev) {
            if ($debug) { print("VALID\n"); }
            $sum_of_valid_parts += int($matched_number);
        }
        elsif ($debug) {
            print("INVALID\n");
        }
    }

    return $sum_of_valid_parts;
}

sub search_for_gear_part_in_other_lines {
    my ($line, $gear_position) = @_;
    
    my @gear_parts = ();

    while ($line =~ /\b(\d+)\b/g) {
        # adjacent vertically (only one digit scenario)
        if ($-[0] <= $gear_position && $+[0] > $gear_position) {
            push @gear_parts, int($1);
            last;
        }

        if ($+[0] == $gear_position || $-[0]-1 == $gear_position) {
            push @gear_parts, int($1);
        }          
    }

    return @gear_parts;
}

sub process_line_p2 {
    my ($prev, $curr, $next, $debug) = @_;

    my $sum_of_gear_ratios = 0;

    if ($debug) {
        print("===================================================\n");
        print defined $prev ? $prev : "---"; print "\n";
        print $curr; print "\n";
        print defined $next ? $next : "---"; print "\n\n";
    }

    while ($curr =~ /\*/g) {
        my $gear_position = $-[0];
        my @gear_parts = ();

        if ($debug) { print("Got asterisk at position " . $gear_position . "\n"); }

        my @prev_line_parts = defined $prev ? search_for_gear_part_in_other_lines($prev, $gear_position) : ();
        my @next_line_gear_parts = defined $next ? search_for_gear_part_in_other_lines($next, $gear_position) : ();

        my $left_curr_line_string = substr($curr, $gear_position+1);
        if ($left_curr_line_string =~ /^(\d+)\b/g) {
            push @gear_parts, int($1);
        }

        my $right_curr_line_string = substr($curr, 0, $gear_position);
        if ($right_curr_line_string =~ /\b(\d+)$/g) {
            push @gear_parts, int($1);
        }

        push @gear_parts, @prev_line_parts;
        push @gear_parts, @next_line_gear_parts;

        if ($debug) { print("Found potential parts: " . join(" ", @gear_parts) . "\n"); }

        if (scalar(@gear_parts) == 2) {
            if ($debug) { print("VALID\n"); }
            $sum_of_gear_ratios += ($gear_parts[0] * $gear_parts[1]);
        }
        elsif ($debug) {
            print("INVALID\n");
        }
    }

    print("Sum: " . $sum_of_gear_ratios . "\n");
    return $sum_of_gear_ratios;
}

sub do_things {
    my ($filename, $mode, $debug) = @_;
    my @lines;

    open(my $file, '<', $filename) or die "Could not open file " . $filename . " !";

    while (my $line = <$file>) {
        chomp $line;
        push @lines, $line;
    }

    my $prev = undef;
    my $curr = shift @lines;
    my $next = shift @lines;

    my $sum = 0;

    while (defined $curr) {
        if ($mode eq "p1") {
            $sum += process_line_p1($prev, $curr, $next, $debug);
        }
        elsif ($mode eq "p2") {
            $sum += process_line_p2($prev, $curr, $next, $debug);
        }
        else {
            print("Incorrect mode. Leaving.");
            return;
        }

        $prev = $curr;
        $curr = $next;
        $next = shift @lines;
    }

    close $file;
    print("Result is " . $sum . "\n");
    return $sum;
}

1;