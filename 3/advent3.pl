#!/usr/bin/perl

use strict;
use warnings;

sub process_line {
    my ($prev, $curr, $next) = @_;

    my $sum_of_valid_parts = 0;
    my $line_length = length($curr);

    print("===================================================\n");
    print defined $prev ? $prev : "---"; print "\n";
    print $curr; print "\n";
    print defined $next ? $next : "---"; print "\n\n";
    
    while ($curr =~ /\b(\d+)\b/g) {
        my $start_pos = $-[0] == 0 ? 0 : $-[0] - 1;
        my $end_pos = $+[0];
        my $check_length = $end_pos - $start_pos + 1;
        my $matched_number = $1;

        my $adjacent_to_character_in_prev = defined $prev && substr($prev, $start_pos, $check_length) =~ /[^\d\.]/g;
        my $adjacent_to_character_in_curr = ($start_pos > 0 && substr($curr, $start_pos, 1) =~ /[^\d\.]/g) || substr($curr, $end_pos, 1) =~ /[^\d\.]/g;
        my $adjacent_to_character_in_next = defined $next && substr($next, $start_pos, $check_length) =~ /[^\d\.]/g;
        
        print("Part: $matched_number \t POS: $start_pos - $end_pos ($check_length) \t$adjacent_to_character_in_prev\t$adjacent_to_character_in_curr\t$adjacent_to_character_in_next\t");

        if ($adjacent_to_character_in_curr || $adjacent_to_character_in_next || $adjacent_to_character_in_prev) {
            print("VALID\n");
            $sum_of_valid_parts += int($matched_number);
        }
        else {
            print("INVALID\n");
        }
    }

    return $sum_of_valid_parts;
}

sub do_things {
    my ($filename) = @_;
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
        $sum += process_line($prev, $curr, $next);

        $prev = $curr;
        $curr = $next;
        $next = shift @lines;
    }

    close $file;
    return $sum;
}

1;